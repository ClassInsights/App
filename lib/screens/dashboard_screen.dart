import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/lesson.dart';
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
        const Header("Willkommen, Jakob."),
        LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              const LessonWidget(
                subject: "MAM",
                startTime: "2023-06-22T09:30:00.000Z",
                endTime: "2023-06-22T10:20:00.000Z",
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
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              WidgetContainer(
                label: "Graph",
                title: "Stromverbrauch gesamt",
                child: Container(
                  height: 100,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
