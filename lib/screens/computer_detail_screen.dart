import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/models/ethernet_data.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:classinsights/widgets/others/sub_screen_container.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ComputerDetailScreen extends StatefulWidget {
  final Computer computer;
  const ComputerDetailScreen(this.computer, {super.key});

  @override
  State<ComputerDetailScreen> createState() => ComputerDetailScreenState();
}

class ComputerDetailScreenState extends State<ComputerDetailScreen> {
  final computerData = const ComputerData(
    powerConsumption: 54.0,
    ramUsage: 2564,
    cpuUsage: [
      23.0,
      16.4,
      14.3,
      11.8,
    ],
    diskUsage: 65.0,
    ethernetData: [
      EthernetData(uploadSpeed: "1.2", downloadSpeed: "2.3"),
      EthernetData(uploadSpeed: "1.2", downloadSpeed: "2.3"),
      EthernetData(uploadSpeed: "1.2", downloadSpeed: "2.3"),
      EthernetData(uploadSpeed: "1.2", downloadSpeed: "2.3"),
    ],
  );

  final List<ChartData> chartData = const [
    ChartData('David', 25),
    ChartData('Steve', 38),
    ChartData('Jack', 34),
    ChartData('Others', 52),
  ];

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
            Container(
              width: constraints.maxWidth / 2,
              color: Theme.of(context).colorScheme.onBackground,
              child: SfCircularChart(
                margin: const EdgeInsets.all(0),
                // legend: Legend(
                //   isVisible: true,
                //   overflowMode: LegendItemOverflowMode.wrap,
                //   position: LegendPosition.top,
                //   itemPadding: 0,
                //   toggleSeriesVisibility: false,
                //   isResponsive: false,
                //   legendItemBuilder: (legendText, series, point, seriesIndex) => Container(
                //     padding: const EdgeInsets.symmetric(vertical: 5),
                //     child: Row(
                //       children: [
                //         Container(
                //           width: 10,
                //           height: 10,
                //           decoration: BoxDecoration(
                //             color: seriesIndex == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                //             shape: BoxShape.circle,
                //           ),
                //         ),
                //         const SizedBox(width: App.smallPadding),
                //         Text(
                //           legendText,
                //           style: Theme.of(context).textTheme.bodyMedium,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                palette: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: [
                      ChartData('Verwendet', computerData.diskUsage),
                      ChartData('Frei', 100 - computerData.diskUsage),
                    ],
                    xValueMapper: (ChartData data, _) => data.label,
                    yValueMapper: (ChartData data, _) => data.value,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      // labelPosition: ChartDataLabelPosition.outside,
                      textStyle: TextStyle(
                        // color: Theme.of(context).colorScheme.primary,
                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                    dataLabelMapper: (ChartData data, _) => "${data.value.toStringAsFixed(0)}%",
                  )
                ],
              ),
            ),
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
