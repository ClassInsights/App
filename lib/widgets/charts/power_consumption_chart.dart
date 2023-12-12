import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/providers/computer_data_provider.dart';
import 'package:classinsights/widgets/charts/chart_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PowerConsumptionChart extends ConsumerWidget {
  const PowerConsumptionChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(computerDataProvider) as List<ComputerData>?;
    if (data == null) return const SizedBox.shrink();

    final points = data.map((d) => FlSpot(data.indexOf(d).toDouble(), d.powerConsumption)).toList();

    final maxValue = points.reduce((value, element) => value.y > element.y ? value : element).y;

    return ChartContainer(
      title: "Energieverbrauch (in Watt)",
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: 150,
          width: constraints.maxWidth,
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
                        meta.max.toInt() == value.toInt()
                            ? "Jetzt"
                            : meta.min.toInt() == 0
                                ? ""
                                : value.toInt().toString(),
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
                    interval: maxValue / 3,
                    reservedSize: 40,
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
              lineTouchData: LineTouchData(
                longPressDuration: const Duration(milliseconds: 0),
                getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes
                    .map(
                      (spotindex) => TouchedSpotIndicatorData(
                        FlLine(color: Theme.of(context).colorScheme.primary, strokeWidth: 2, dashArray: [5]),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 6,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 0,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Theme.of(context).colorScheme.primary,
                  tooltipRoundedRadius: 20,
                  getTooltipItems: (touchedSpots) => touchedSpots
                      .map(
                        (spot) => LineTooltipItem(
                          "${spot.y.toStringAsFixed(1)}%",
                          TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: points,
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 2,
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
      ),
    );
  }
}
