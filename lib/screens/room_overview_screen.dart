import 'dart:async';

import 'package:classinsights/main.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
import 'package:classinsights/widgets/others/header.dart';
import 'package:classinsights/widgets/others/room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomOverviewScreen extends ConsumerStatefulWidget {
  const RoomOverviewScreen({super.key});

  @override
  ConsumerState<RoomOverviewScreen> createState() => _RoomOverviewScreenState();
}

class _RoomOverviewScreenState extends ConsumerState<RoomOverviewScreen> {
  late Timer timer;
  var now = DateTime.now();

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(() => now = DateTime.now());
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentRoomID = ref.read(lessonProvider.notifier).getLessonByDate(now)?.roomId ?? 0;
    final rooms = ref.read(roomProvider);
    final currentRoom = ref.read(roomProvider.notifier).getRoomById(currentRoomID);

    return Column(
      children: [
        const Header("Klassen"),
        currentRoom == null
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Aktueller Raum"),
                  const SizedBox(height: 4.0),
                  RoomWidget(
                    room: currentRoom,
                    current: true,
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    "Alle Räume",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: App.defaultPadding)
                ],
              ),
        ListView.separated(
          padding: const EdgeInsets.all(0.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: rooms.length,
          separatorBuilder: (context, index) {
            final room = rooms[index];
            if (room.id == currentRoomID) return const SizedBox.shrink();
            return const SizedBox(height: App.defaultPadding);
          },
          itemBuilder: (context, index) {
            final room = rooms[index];
            if (room.id == currentRoomID) return const SizedBox.shrink();
            return RoomWidget(
              key: ValueKey(room.id),
              room: room,
            );
          },
        ),
      ],
    );
  }
}
