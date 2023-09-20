import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/widgets/charts/computer_chart.dart';
import 'package:flutter/material.dart';

class PiChartWidget extends StatelessWidget {
  final ComputerData data;
  const PiChartWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      crossAxisSpacing: App.defaultPadding,
      crossAxisCount: 2,
      childAspectRatio: 6 / 10,
      children: [
        ComputerChart(
          graphTitle: "Arbeitspeicher",
          alternativeTitle: "RAM",
          primaryTitle: "Verwendet",
          secondaryTitle: "Frei",
          progress: data.ramUsage,
        ),
        ComputerChart(
          graphTitle: "Festplatte",
          alternativeTitle: "SSD",
          primaryTitle: "Besetzt",
          secondaryTitle: "Frei",
          progress: data.diskUsage,
        ),
      ],
    );
  }
}
