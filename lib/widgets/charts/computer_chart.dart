import 'package:classinsights/main.dart';
import 'package:classinsights/widgets/charts/legend_item.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ComputerChart extends StatelessWidget {
  final String graphTitle;
  final String alternativeTitle;
  final String primaryTitle;
  final String secondaryTitle;
  final double progress;

  const ComputerChart({
    required this.graphTitle,
    required this.alternativeTitle,
    required this.primaryTitle,
    required this.secondaryTitle,
    required this.progress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetContainer(
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Text(
              constraints.maxWidth > 125 ? graphTitle : alternativeTitle,
              style: Theme.of(context).textTheme.titleSmall,
              softWrap: false,
            ),
          ),
          const SizedBox(height: App.smallPadding),
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                startDegreeOffset: 90,
                sectionsSpace: 5,
                sections: [
                  PieChartSectionData(
                    color: Theme.of(context).colorScheme.primary,
                    radius: 50,
                    titleStyle: Theme.of(context).textTheme.titleSmall,
                    showTitle: false,
                    value: progress,
                  ),
                  PieChartSectionData(
                    color: Theme.of(context).colorScheme.tertiary,
                    value: 100 - progress,
                    showTitle: false,
                    radius: 50,
                    titleStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: App.defaultPadding),
          LegendItem(title: primaryTitle, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: App.smallPadding),
          LegendItem(title: secondaryTitle, color: Theme.of(context).colorScheme.tertiary),
        ],
      ),
    );
  }
}
