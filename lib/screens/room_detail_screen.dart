import 'package:classinsights/main.dart';
import 'package:classinsights/providers/computer_provider.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/providers/ratelimit_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
import 'package:classinsights/widgets/computer/computer_list.dart';
import 'package:classinsights/widgets/others/lesson_widget.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:classinsights/widgets/others/sensor_display_widget.dart';
import 'package:classinsights/widgets/others/sub_screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomDetailScreen extends ConsumerWidget {
  final int roomID;
  const RoomDetailScreen(this.roomID, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.read(roomProvider.notifier).getRoomById(roomID);

    if (room == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Klasse nicht gefunden",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20.0),
            const Text(
              "Bitte versuche es erneut. Wenn das Problem weiterhin besteht, kontaktiere uns.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Zurück",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SubScreenContainer(
      title: room.name,
      refreshAction: () async {
        await ref.read(roomProvider.notifier).refreshRooms();
        await ref.read(lessonProvider.notifier).refreshLessons();
        await ref.read(computerProvider.notifier).fetchComputers(roomID);
        ref.read(ratelimitProvider.notifier).addRateLimit("reload-${room.id}");
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LessonWidget(roomId: roomID),
          const SizedBox(height: App.defaultPadding),
          SensorDisplayWidget(room.name.toLowerCase()),
          const SizedBox(height: 50.0),
          Text(
            "Registrierte Computer",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: App.defaultPadding),
          ComputerList(roomID)
        ],
      ),
    );
  }
}
