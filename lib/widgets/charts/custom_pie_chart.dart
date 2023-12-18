import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final String title;
  final double progress;
  final String primaryName;
  final String secondaryName;
  const CustomPieChart({
    required this.title,
    required this.progress,
    required this.primaryName,
    required this.secondaryName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 40.0),
          LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              height: constraints.maxWidth,
              width: constraints.maxWidth,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 10.0,
                  sectionsSpace: 5.0,
                  startDegreeOffset: 90.0,
                  sections: [
                    PieChartSectionData(
                      color: Theme.of(context).colorScheme.primary,
                      value: progress,
                      title: "${progress.toStringAsFixed(0)}%",
                      radius: constraints.maxWidth / 2.5,
                      titleStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                    PieChartSectionData(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      value: 100 - progress,
                      title: "${(100 - progress).toStringAsFixed(0)}%",
                      radius: constraints.maxWidth / 2.5,
                      titleStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 5.0,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 5.0),
              Text(
                primaryName,
              ),
              const SizedBox(width: 20.0),
              CircleAvatar(
                radius: 5.0,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              const SizedBox(width: 5.0),
              Text(secondaryName),
            ],
          )
        ],
      ),
    );
  }
}
