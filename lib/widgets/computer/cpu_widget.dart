import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/widgets/charts/cpu_chart.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:flutter/material.dart';

class CPUWidget extends StatelessWidget {
  final ComputerData data;
  const CPUWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Prozessor Auslastung",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: App.defaultPadding),
          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(0),
            childAspectRatio: 10 / 6,
            mainAxisSpacing: App.smallPadding,
            crossAxisSpacing: App.smallPadding,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: data.cpuUsage.map((cpuUsage) => const CPUChart()).toList(),
          ),
        ],
      ),
    );
  }
}
