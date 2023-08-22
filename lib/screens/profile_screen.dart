import 'package:classinsights/providers/theme_provider.dart';
import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;
    switchTheme() => ref.read(themeProvider.notifier).switchTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header("Konto"),
        Text(
          "Jakob Wassertheurer",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 15.0),
        const Text("Schüler"),
        const SizedBox(height: 10.0),
        const Text("4KK (SIEM)"),
        const SizedBox(height: 10.0),
        const Text("26 Stunden/Woche"),
        const SizedBox(height: 20.0),
        WidgetContainer(
          label: darkMode ? "Aktiviert" : "Deaktiviert",
          title: "Dunkler Modus",
          onTab: switchTheme,
          primary: true,
        )
      ],
    );
  }
}
