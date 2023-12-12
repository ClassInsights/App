import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/providers/computer_data_provider.dart';
import 'package:classinsights/widgets/charts/custom_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RamUsageChart extends ConsumerWidget {
  const RamUsageChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(computerDataProvider) as List<ComputerData>?;
    if (data == null) return const SizedBox.shrink();

    final lastData = data.last;
    return CustomPieChart(
      title: "RAM-Verwendung",
      progress: lastData.ramUsage,
      primaryName: "Belegt",
      secondaryName: "Frei",
    );
  }
}
