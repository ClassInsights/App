import 'package:classinsights/main.dart';
import 'package:classinsights/models/room.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
import 'package:classinsights/providers/screen_provider.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:classinsights/widgets/others/header.dart';
import 'package:classinsights/widgets/others/lesson_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLesson = ref.read(lessonProvider.notifier).getLessonByDate(DateTime.now());
    final roomCount = ref.watch(roomProvider).length;
    return Column(
      children: [
        Header("Willkommen, ${ref.read(authProvider).data.name.split(" ")[0]}."),
        LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                currentLesson != null
                    ? LessonWidget(lesson: currentLesson)
                    : const ContainerWithContent(label: "Aktuelle Stunde", title: "Keine Stunde gerade"),
                const SizedBox(height: App.defaultPadding),
                Row(
                  children: [
                    ContainerWithContent(
                      label: "Top",
                      title: "Hop",
                      width: constraints.maxWidth / 2 - App.defaultPadding / 2,
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
                  label: "Aktive Geräte",
                  title: ref.read(roomProvider).fold(0, (int previousElement, Room room) => previousElement + room.deviceCount).toString(),
                ),
                const SizedBox(
                  height: App.defaultPadding,
                ),
                ContainerWithContent(
                  label: "Graph",
                  title: "Stromverbrauch gesamt",
                  child: Container(
                    height: 100,
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
