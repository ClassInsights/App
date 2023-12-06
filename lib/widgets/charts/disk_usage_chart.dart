import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/providers/computer_data_provider.dart';
import 'package:classinsights/widgets/charts/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiskUsageChart extends ConsumerWidget {
  const DiskUsageChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(computerDataProvider) as List<ComputerData>?;
    if (data == null) return const SizedBox.shrink();

    final lastData = data.last;

    return CustomPieChart(
      title: "Festplattenverwendung",
      progress: lastData.diskUsage,
      primaryName: "Belegt",
      secondaryName: "Frei",
    );
  }
}
