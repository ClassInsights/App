import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CPUChart extends StatelessWidget {
  // final List<FlSpot> data;
  const CPUChart({super.key});

  final graphData = const [
    FlSpot(1, 54),
    FlSpot(2, 36),
    FlSpot(3, 30),
    FlSpot(4, 19),
    FlSpot(5, 18),
    FlSpot(6, 25),
    FlSpot(7, 43),
    FlSpot(8, 52),
    FlSpot(9, 75),
    FlSpot(10, 43),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          verticalInterval: 1,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Theme.of(context).colorScheme.tertiary,
            dashArray: [2],
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Theme.of(context).colorScheme.tertiary,
            dashArray: [2],
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
        maxY: 100,
        minY: 0,
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: graphData,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
