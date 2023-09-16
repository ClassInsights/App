import 'package:classinsights/providers/localstore_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier(ref));

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final StateNotifierProviderRef ref;
  ThemeNotifier(this.ref) : super(ThemeMode.light);

  ThemeMode get theme => state;

  Future<ThemeMode> refreshTheme({Brightness? brightness}) async {
    final themeData = await ref.read(localstoreProvider.notifier).item("ci_theme");
    if (themeData != null) {
      final theme = themeData.value == "light" ? ThemeMode.light : ThemeMode.dark;
      state = theme;
      return theme;
    } else {
      final theme = brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
      state = theme;
      return theme;
    }
  }

  void switchTheme() {
    ref.read(localstoreProvider.notifier).setItem("ci_theme", state == ThemeMode.light ? "dark" : "light");
    refreshTheme();
  }
}
