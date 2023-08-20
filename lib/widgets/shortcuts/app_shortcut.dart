import 'package:classinsights/providers/screen_provider.dart';
import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShortcut extends ConsumerWidget {
  final double width;
  const AppShortcut(this.width, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    openRooms() {
      ref.read(screenProvider.notifier).setScreen(Screen.rooms);
    }

    return WidgetContainer(
      title: "16",
      label: "Räume",
      width: width,
      showArrow: true,
      onTab: openRooms,
      primary: true,
    );
  }
}
