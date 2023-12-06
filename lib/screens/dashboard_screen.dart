import 'package:classinsights/main.dart';
import 'package:classinsights/models/room.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
import 'package:classinsights/providers/screen_provider.dart';
import 'package:classinsights/widgets/charts/electricity_chart.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:classinsights/widgets/others/header.dart';
import 'package:classinsights/widgets/others/lesson_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCount = ref.watch(roomProvider).length;

    void openWebsite() async {
      if (!await launchUrl(Uri.parse("https://eco-landeck.at"))) {
        throw Exception("Could not launch Website URL");
      }
    }

    return Column(
      children: [
        Header("Willkommen, ${ref.read(authProvider).data.name.split(" ").first}."),
        LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const LessonWidget(),
                const SizedBox(height: App.defaultPadding),
                Row(
                  children: [
                    ContainerWithContent(
                      label: "Öffnen",
                      title: "Website",
                      width: constraints.maxWidth / 2 - App.defaultPadding / 2,
                      showArrow: true,
                      onTab: openWebsite,
                    ),
                    const SizedBox(
                      width: App.defaultPadding,
                    ),
                    ContainerWithContent(
                      label: "Räume",
                      title: roomCount.toString(),
                      width: constraints.maxWidth / 2 - App.defaultPadding / 2,
                      showArrow: true,
                      onTab: () => ref.read(screenProvider.notifier).setScreen(Screen.dashboard, Screen.rooms),
                      primary: true,
                    ),
                  ],
                ),
                const SizedBox(
                  height: App.defaultPadding,
                ),
                ContainerWithContent(
                  label: "Registrierte Geräte",
                  title: ref.read(roomProvider).fold(0, (int previousElement, Room room) => previousElement + room.deviceCount).toString(),
                ),
                const SizedBox(
                  height: App.defaultPadding,
                ),
                WidgetContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Stromverbrauch Gesamt (kWh)", style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 40.0),
                      const ElectricityChart(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
