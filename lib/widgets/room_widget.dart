import 'package:classinsights/models/room.dart';
import 'package:classinsights/screens/room_details_screen.dart';
import 'package:classinsights/widgets/container_content.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  final Room room;
  final bool current;

  const RoomWidget({
    super.key,
    required this.room,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    void openClass() => Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, firstAnimation, secondAnimation) => RoomDetailScreen(room.id),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

    return ContainerWithContent(
      label: "${room.deviceCount.toString()} ${room.deviceCount == 1 ? "Gerät" : "Geräte"}",
      title: room.name,
      showArrow: true,
      primary: current,
      onTab: openClass,
    );
  }
}
