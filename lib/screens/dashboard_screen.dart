import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/progress_bar.dart';
import 'package:classinsights/widgets/shortcuts/app_shortcut.dart';
import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final double minutes = 30.0;
  final double baseMinutes = 50.0;

  @override
  Widget build(BuildContext context) {
    const defaultPadding = 15.0;

    return Column(
      children: [
        const Header(
          title: "Willkommen, Jakob.",
        ),
        LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              WidgetContainer(
                label: "Aktuelle Stunde",
                title: "NTMA", // TODO: Replace with actual class
                child: ProgressBar(
                  title: 'noch ${(baseMinutes - minutes).toStringAsFixed(0)} Minuten',
                  progress: minutes,
                  baseValue: baseMinutes,
                ),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  WidgetContainer(
                    label: "Top",
                    title: "Hop",
                    width: constraints.maxWidth / 2 - defaultPadding / 2,
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  AppShortcut(constraints.maxWidth / 2 - defaultPadding / 2),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const WidgetContainer(
                label: "Aktive Computer",
                title: "121",
              )
            ],
          );
        }),
      ],
    );
  }
}
