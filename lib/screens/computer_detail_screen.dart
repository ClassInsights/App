import 'dart:convert';
import 'dart:io';

import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/models/ethernet_data.dart';
import 'package:classinsights/models/user_role.dart';
import 'package:classinsights/providers/auth_provider.dart';
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
  bool loading = true;
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

    setState(() => loading = false);
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
    WidgetsBinding.instance.addObserver(this);
    openWebSocket();
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    closeWebSocket();
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

    return SubScreenContainer(
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
                  Text("Letzter Nutzer: ${widget.computer.lastUser}"),
                  const SizedBox(height: App.smallPadding),
                  Text(
                      "Zuletzt verwendet: ${widget.computer.lastSeen.day}-${widget.computer.lastSeen.month}-${widget.computer.lastSeen.year} | ${widget.computer.lastSeen.hour}:${widget.computer.lastSeen.minute} Uhr"),
                  const SizedBox(height: App.smallPadding),
                  Text("IP: ${widget.computer.ipAddress}"),
                  const SizedBox(height: App.smallPadding),
                  Text("MAC: ${widget.computer.macAddress}"),
                ],
              ),
            ),
            const SizedBox(height: App.defaultPadding),
            loading
                ? Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      StreamBuilder(
                          stream: channel.stream,
                          builder: (_, snapshot) {
                            if (!snapshot.hasData) return const Text("Etwas ist schief gelaufen!");
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
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Power Consumption: ${computerData.powerConsumption}"),
                                Text("RAM Usage: ${computerData.ramUsage}"),
                                Text("CPU Usage: ${computerData.cpuUsage}"),
                                Text("Disk Usage: ${computerData.diskUsage}"),
                                Text("Ethernet Upload Speed: ${computerData.ethernetData.uploadSpeed}"),
                                Text("Ethernet Download Speed: ${computerData.ethernetData.downloadSpeed}"),
                                const SizedBox(height: App.defaultPadding),
                              ],
                            );
                          }),
                      ref.read(authProvider).data.role == Role.student ? const SizedBox() : DangerZoneWidget(widget.computer),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
