import 'package:classinsights/models/room.dart';
import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/room_widget.dart';
import 'package:flutter/material.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const currentRoomID = "2";
    const List<Room> rooms = [
      Room(
        id: "1",
        name: "OG3-DV6",
        deviceCount: 28,
      ),
      Room(
        id: "2",
        name: "OG1-DV3",
        deviceCount: 20,
      ),
      Room(
        id: "3",
        name: "OG1-DV3",
        deviceCount: 16,
      ),
      Room(
        id: "4",
        name: "OG2-4",
        deviceCount: 1,
      ),
      Room(
        id: "5",
        name: "UG-DV1",
        deviceCount: 8,
      ),
      Room(
        id: "6",
        name: "UG-DV2",
        deviceCount: 8,
      ),
      Room(
        id: "7",
        name: "OG3-DV5",
        deviceCount: 18,
      ),
    ];

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
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: rooms.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10.0),
          itemBuilder: (context, index) => RoomWidget(room: rooms[index]),
        ),
      ],
    );
  }
}
