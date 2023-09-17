import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ElectricityChart extends StatelessWidget {
  const ElectricityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, widgetConstraints) {
        return SizedBox(
          width: widgetConstraints.maxWidth,
          height: 150,
          child: GestureDetector(
            onHorizontalDragUpdate: (_) {},
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(1, 12),
                      FlSpot(2, 12),
                      FlSpot(3, 15),
                      FlSpot(5, 14),
                      FlSpot(6, 13.5),
                      FlSpot(7, 12),
                      FlSpot(8, 14),
                      FlSpot(9, 13.5),
                      FlSpot(10, 9),
                      FlSpot(11, 8),
                      FlSpot(12, 6),
                    ],
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}