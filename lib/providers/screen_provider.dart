import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Screen {
  dashboard,
  rooms,
  settings,
}

final screenProvider = StateNotifierProvider<ScreenNotifier, Screen>(
  (_) => ScreenNotifier(),
);

class ScreenNotifier extends StateNotifier<Screen> {
  ScreenNotifier() : super(Screen.dashboard);

  Screen get screen => state;

  void setScreen(Screen screen) => state = screen;
}
