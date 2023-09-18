import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ElectricityChart extends StatelessWidget {
  const ElectricityChart({super.key});

  @override
  Widget build(BuildContext context) {
    const data = [
      FlSpot(1, 12),
      FlSpot(2, 12),
      FlSpot(3, 15),
      FlSpot(4, 14),
      FlSpot(5, 14),
      FlSpot(6, 13.5),
      FlSpot(7, 12),
      FlSpot(8, 14),
      FlSpot(9, 13.5),
      FlSpot(10, 9),
      FlSpot(11, 8),
      FlSpot(12, 6),
    ];

    final smallestValue = data.reduce((value, element) => value.y < element.y ? value : element).y;

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
                          meta.max.toInt() == value.toInt() ? "Jetzt" : value.toInt().toString(),
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
                      interval: 5,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          value.toInt().toString(),
                          textAlign: TextAlign.center,
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
                minY: smallestValue - 1 < 0 ? 0 : smallestValue - 1,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Theme.of(context).colorScheme.primary,
                    tooltipRoundedRadius: 20,
                    getTooltipItems: (touchedSpots) => touchedSpots
                        .map((spot) => LineTooltipItem(
                              "${spot.y} kWh",
                              TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
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
