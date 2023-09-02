import 'package:classinsights/providers/localstore_provider.dart';
import 'package:classinsights/providers/theme_provider.dart';
import 'package:classinsights/widgets/container_content.dart';
import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  var version = "Unknown";

  Future<String> initVersion() async {
    var info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  void initState() {
    super.initState();
    initVersion().then((data) => setState(() => version = data));
  }

  @override
  Widget build(BuildContext context) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;

    void switchTheme() => ref.read(themeProvider.notifier).switchTheme();

    void openGithub() async {
      if (!await launchUrl(Uri.parse("https://github.com/ClassInsights/App"))) {
        throw Exception("Could not launch Repository URL");
      }
    }

    void resetData() => {
          ref.read(localstoreProvider.notifier).clear(),
          ref.read(themeProvider.notifier).refreshTheme(MediaQuery.of(context).platformBrightness),
        };

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
        const SizedBox(height: 40.0),
        ContainerWithContent(
          label: darkMode ? "Aktiviert" : "Deaktiviert",
          title: "Dunkler Modus",
          onTab: switchTheme,
          primary: true,
        ),
        const SizedBox(height: 15.0),
        WidgetContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Adresse",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10.0),
              const Text("HAK/HAS/HLW Landeck"),
              const SizedBox(height: 10.0),
              const Text("Kreuzgasse 9 a"),
              const SizedBox(height: 10.0),
              const Text("6500 Landeck"),
              const SizedBox(height: 10.0),
              const Text("Österreich"),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        WidgetContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10.0),
              const Text("HAK/HAS/HLW Landeck"),
              const SizedBox(height: 10.0),
              Text("App Version: $version"),
              const SizedBox(height: 10.0),
              Text("© ${DateTime.now().year} HAK/HAS/HLW Landeck"),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: openGithub,
                child: Text(
                  "Quellcode",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        ContainerWithContent(
          label: "Zurücksetzen",
          title: "Lokale Daten löschen",
          onTab: resetData,
          primary: true,
        ),
      ],
    );
  }
}
