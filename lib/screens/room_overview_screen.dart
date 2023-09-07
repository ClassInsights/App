import 'package:classinsights/providers/room_provider.dart';
import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassesScreen extends ConsumerWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int? currentRoomID = 63;
    final rooms = ref.read(roomProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header("Klassen", showBottomMargin: currentRoomID != null),
        currentRoomID == null
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Aktueller Raum"),
                  const SizedBox(height: 4.0),
                  RoomWidget(
                    room: rooms.firstWhere((room) => room.id == currentRoomID),
                    current: true,
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    "Sonstige Räume",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
        ListView.separated(
          padding: const EdgeInsets.all(0.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: rooms.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          itemBuilder: (context, index) => RoomWidget(
            room: rooms[index],
          ),
        ),
      ],
    );
  }
}
