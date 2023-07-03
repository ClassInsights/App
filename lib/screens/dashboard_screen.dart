import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/progress_bar.dart';
import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final double minutes = 30.0;
  final double baseMinutes = 50.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(
          title: "Willkommen, Jakob.",
        ),
        Column(
          children: [
            WidgetContainer(
              label: "Aktuelle Stunde",
              title: "NTMA", // TODO: Replace with actual class
              child: ProgressBar(
                title:
                    'noch ${(baseMinutes - minutes).toStringAsFixed(0)} Minuten',
                progress: minutes,
                baseValue: baseMinutes,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ],
    );
  }
}
