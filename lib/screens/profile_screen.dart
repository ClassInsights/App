import 'package:classinsights/main.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/providers/localstore_provider.dart';
import 'package:classinsights/providers/theme_provider.dart';
import 'package:classinsights/providers/version_provider.dart';
import 'package:classinsights/screens/login_screen.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:classinsights/widgets/others/header.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openGithub() async {
      if (!await launchUrl(Uri.parse("https://github.com/ClassInsights/App"))) {
        throw Exception("Could not launch Repository URL");
      }
    }

    void resetData() {
      ref.read(localstoreProvider.notifier).clear();
      ref.read(themeProvider.notifier).refreshTheme(brightness: MediaQuery.of(context).platformBrightness);
      ref.read(authProvider.notifier).logout();
    }

    final authData = ref.read(authProvider).data;
    final todaysLessons = ref.read(lessonProvider.notifier).getLessonsForDay(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header("Konto"),
        Text(
          authData.name,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: App.defaultPadding),
        authData.role != null ? Text(ref.read(authProvider.notifier).translateRole(authData.role!)) : const SizedBox.shrink(),
        const SizedBox(height: App.smallPadding),
        authData.schoolClass != null
            ? Text("${authData.schoolClass!.name} ${authData.schoolClass?.headTeacher != null ? "(${authData.schoolClass!.headTeacher})" : ""}")
            : const SizedBox.shrink(),
        const SizedBox(height: App.smallPadding),
        todaysLessons.isEmpty ? const Text("Schulfreier Tag") : Text("${todaysLessons.length} Stunden heute"),
        const SizedBox(height: 40.0),
        ContainerWithContent(
          label: "Dunkler Modus",
          title: ref.read(themeProvider) == ThemeMode.dark ? "Aktiviert" : "Deaktiviert",
          onTab: () => ref.read(themeProvider.notifier).switchTheme(),
          primary: true,
        ),
        const SizedBox(height: App.defaultPadding),
        WidgetContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Adresse",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: App.defaultPadding),
              const Text("HAK/HAS/HLW Landeck"),
              const SizedBox(height: App.smallPadding),
              const Text("Kreuzgasse 9 a"),
              const SizedBox(height: App.smallPadding),
              const Text("6500 Landeck"),
              const SizedBox(height: App.smallPadding),
              const Text("Österreich"),
            ],
          ),
        ),
        const SizedBox(height: App.defaultPadding),
        WidgetContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: App.defaultPadding),
              const Text("ClassInsights App"),
              const SizedBox(height: App.smallPadding),
              Text("App Version: ${ref.read(versionProvider)}"),
              const SizedBox(height: App.smallPadding),
              Text("© ${DateTime.now().year} HAK/HAS/HLW Landeck"),
              const SizedBox(height: App.smallPadding),
              GestureDetector(
                onTap: openGithub,
                child: Text(
                  "Quellcode",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: App.defaultPadding),
        ContainerWithContent(
          label: "Zurücksetzen",
          title: "Lokale Daten löschen",
          onTab: () {
            resetData();
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, firstAnimation, secondAnimation) => const LoginScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          primary: true,
        ),
      ],
    );
  }
}
