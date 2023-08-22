import 'package:classinsights/models/room.dart';
import 'package:classinsights/screens/room_details_screen.dart';
import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  final Room room;
  final bool current;
  const RoomWidget({super.key, required this.room, this.current = false});

  @override
  Widget build(BuildContext context) {
    openClass() => Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, firstAnimation, secondAnimation) => RoomDetailScreen(room.id),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
    return WidgetContainer(
      label: "${room.deviceCount.toString()} ${room.deviceCount == 1 ? "Gerät" : "Geräte"}",
      title: room.name,
      showArrow: true,
      primary: current,
      onTab: openClass,
    );
  }
}
