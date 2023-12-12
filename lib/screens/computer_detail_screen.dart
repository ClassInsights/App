import 'dart:convert';
import 'dart:io';

import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/models/ethernet_data.dart';
import 'package:classinsights/models/user_role.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/computer_data_provider.dart';
import 'package:classinsights/providers/computer_provider.dart';
import 'package:classinsights/providers/ratelimit_provider.dart';
import 'package:classinsights/widgets/charts/cpu_usage_chart.dart';
import 'package:classinsights/widgets/charts/disk_usage_chart.dart';
import 'package:classinsights/widgets/charts/power_consumption_chart.dart';
import 'package:classinsights/widgets/charts/ram_usage_chart.dart';
import 'package:classinsights/widgets/computer/dangerzone.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:classinsights/widgets/others/sub_screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ComputerDetailScreen extends ConsumerStatefulWidget {
  final Computer computer;
  const ComputerDetailScreen(this.computer, {super.key});

  @override
  ConsumerState<ComputerDetailScreen> createState() => _ComputerDetailScreenState();
}

class _ComputerDetailScreenState extends ConsumerState<ComputerDetailScreen> with WidgetsBindingObserver {
  late WebSocketChannel channel;
  bool didFail = false;

  void openWebSocket() {
    debugPrint("Connecting to websocket...");
    final wsUrl = "${dotenv.env['WS_URL']}/${widget.computer.id}";
    final accessToken = ref.read(authProvider).creds.accessToken;
    if (accessToken.isEmpty) return;

    setState(() {
      try {
        channel = IOWebSocketChannel.connect(
          Uri.parse(wsUrl),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken",
          },
        );
      } catch (e) {
        debugPrint("Error connecting to websocket: $e");
        didFail = true;
      }
    });

    debugPrint("Connected to websocket");
  }

  void closeWebSocket() async {
    debugPrint("Closing websocket connection...");
    if (channel.closeCode != null) return;
    await channel.sink.close();
    debugPrint("Closed websocket connection");
  }

  @override
  void initState() {
    super.initState();
    Future(() => ref.read(computerDataProvider.notifier).clearComputerData());
    WidgetsBinding.instance.addObserver(this);
    openWebSocket();
  }

  @override
  void dispose() async {
    closeWebSocket();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Future(() => ref.read(computerDataProvider.notifier).clearComputerData());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      openWebSocket();
    } else if (state == AppLifecycleState.paused) {
      closeWebSocket();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (didFail || channel.closeCode != null) {
      return SubScreenContainer(
        title: widget.computer.name,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Computer ist offline",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Der Computer ist nicht mehr mit dem Netzwerk verbunden - möglicherweise wurde er heruntergefahren.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      );
    }

    final role = ref.read(authProvider).data.role;

    final hasLastUser = widget.computer.lastUser != null && widget.computer.lastUser?.startsWith("NT") == false;

    return SubScreenContainer(
      refreshAction: () async {
        final limiter = ref.read(ratelimitProvider.notifier);
        if (limiter.isRateLimited("refresh-computer-${widget.computer.id}")) return;
        limiter.addRateLimit("refresh-computer-${widget.computer.id}");
        ref.read(computerDataProvider.notifier).clearComputerData();
        closeWebSocket();
        openWebSocket();
        ref.read(computerProvider.notifier).fetchComputers(widget.computer.id);
      },
      title: widget.computer.name,
      body: LayoutBuilder(
        builder: (_, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Computerdaten",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: App.defaultPadding),
                  if (hasLastUser) Text("Letzter Nutzer: ${widget.computer.lastUser}"),
                  if (hasLastUser) const SizedBox(height: App.smallPadding),
                  Text(
                      "Zuletzt verwendet: ${widget.computer.lastSeen.day}/${widget.computer.lastSeen.month}/${widget.computer.lastSeen.year} ${widget.computer.lastSeen.hour}:${widget.computer.lastSeen.minute.toString().padLeft(2, "0")} Uhr"),
                  const SizedBox(height: App.smallPadding),
                  Text("IP: ${widget.computer.ipAddress}"),
                  const SizedBox(height: App.smallPadding),
                  Text("MAC: ${widget.computer.macAddress}"),
                ],
              ),
            ),
            const SizedBox(height: App.defaultPadding),
            Column(
              children: [
                StreamBuilder(
                  stream: channel.stream,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.only(
                          top: 50.0,
                          bottom: 50.0,
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    final data = jsonDecode(snapshot.data)["Data"];
                    final computerData = ComputerData(
                      powerConsumption: data["Power"],
                      ramUsage: data["RamUsage"],
                      cpuUsage: data["CpuUsage"][0],
                      diskUsage: data["DiskUsages"][0],
                      ethernetData: EthernetData(
                        uploadSpeed: data["EthernetUsages"][0]["Upload Speed"],
                        downloadSpeed: data["EthernetUsages"][0]["Download Speed"],
                      ),
                    );
                    Future(() => ref.read(computerDataProvider.notifier).addComputerData(computerData));
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PowerConsumptionChart(),
                        SizedBox(height: App.defaultPadding),
                        RamUsageChart(),
                        SizedBox(height: App.defaultPadding),
                        CpuUsageChart(),
                        SizedBox(height: App.defaultPadding),
                        DiskUsageChart(),
                        SizedBox(height: 50.0),
                      ],
                    );
                  },
                ),
                role != Role.admin && role != Role.teacher ? const SizedBox() : DangerZoneWidget(widget.computer),
                // DangerZoneWidget(widget.computer),
              ],
            )
          ],
        ),
      ),
    );
  }
}
