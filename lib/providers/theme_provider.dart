import 'package:classinsights/providers/localstore_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier(ref));

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final StateNotifierProviderRef ref;
  ThemeNotifier(this.ref) : super(ThemeMode.light);

  ThemeMode get theme => state;

  void refreshTheme(Brightness brightness) async {
    final themeData = await ref.read(localstoreProvider.notifier).item("theme");
    if (themeData != null) {
      state = themeData.value == "light" ? ThemeMode.light : ThemeMode.dark;
    } else {
      state = brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    }
  }

  void switchTheme() {
    ref.read(localstoreProvider.notifier).setItem("theme", state == ThemeMode.light ? "dark" : "light");
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
