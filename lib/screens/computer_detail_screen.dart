import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/models/ethernet_data.dart';
import 'package:classinsights/widgets/computer/cpu_widget.dart';
import 'package:classinsights/widgets/computer/pichart_widgets.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:classinsights/widgets/others/sub_screen_container.dart';
import 'package:flutter/material.dart';

class ComputerDetailScreen extends StatefulWidget {
  final Computer computer;
  const ComputerDetailScreen(this.computer, {super.key});

  @override
  State<ComputerDetailScreen> createState() => ComputerDetailScreenState();
}

class ComputerDetailScreenState extends State<ComputerDetailScreen> {
  final ComputerData computerData = const ComputerData(
    powerConsumption: [],
    ramUsage: 65,
    cpuUsage: [
      [60, 57, 48, 40, 73, 70, 54, 32, 25, 40, 57, 79, 91, 84, 78, 85, 75, 45, 37, 39],
      [30, 50, 54, 56, 50, 20, 22, 21, 21, 33, 33, 43, 45, 47, 45, 48, 47, 58, 74, 52],
      [58, 44, 34, 45, 53, 59, 66, 58, 61, 48, 57, 62, 62, 54, 62, 60, 74, 64, 49, 45],
      [42, 46, 49, 49, 51, 49, 46, 55, 61, 65, 72, 69, 64, 52, 54, 54, 61, 64, 66, 57]
    ],
    diskUsage: 35,
    ethernetData: [
      EthernetData(uploadSpeed: "123.2", downloadSpeed: "6.8"),
      EthernetData(uploadSpeed: "98.3", downloadSpeed: "7.2"),
      EthernetData(uploadSpeed: "102.4", downloadSpeed: "6.9"),
      EthernetData(uploadSpeed: "99.2", downloadSpeed: "7.1"),
      EthernetData(uploadSpeed: "36.2", downloadSpeed: "5.1"),
      EthernetData(uploadSpeed: "12.4", downloadSpeed: "3.1"),
      EthernetData(uploadSpeed: "5.6", downloadSpeed: "2.3"),
    ],
  );

  @override
  Widget build(BuildContext context) {
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
                  Text("Zuletzt verwendet: ${widget.computer.lastSeen.day}-${widget.computer.lastSeen.month}-${widget.computer.lastSeen.year}"),
                  const SizedBox(height: App.smallPadding),
                  Text("IP: ${widget.computer.ipAddress}"),
                  const SizedBox(height: App.smallPadding),
                  Text("MAC: ${widget.computer.macAddress}"),
                ],
              ),
            ),
            const SizedBox(height: App.defaultPadding),
            CPUWidget(computerData),
            const SizedBox(height: App.defaultPadding),
            PiChartWidget(computerData),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  const ChartData(this.label, this.value);
}
