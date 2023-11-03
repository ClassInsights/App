import 'package:classinsights/helpers/host_checker.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
import 'package:classinsights/providers/subject_provider.dart';
import 'package:classinsights/providers/version_provider.dart';
import 'package:classinsights/screens/connection_failed_screen.dart';
import 'package:classinsights/screens/login_screen.dart';
import 'package:classinsights/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool alreadyInitialized = false;
  var hintText = "";

  void updateHint(String hint) => setState(() => hintText = hint);

  showErrorPage() => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, firstAnimation, secondAnimation) => const ConnectionFailedScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );

  Future<void> initProviders() async {
    final apiAvailable = await checkHost(dotenv.env["API_HOST"]);
    if (!apiAvailable) {
      debugPrint("Failed to connect to ${dotenv.env["API_HOST"]}!");
      showErrorPage();
      return;
    }

    updateHint("Lese Account Daten...");

    final success = await ref.read(authProvider.notifier).reload();
    if (success != true) {
      debugPrint("Failed to reload auth data!");
      return;
    }

    updateHint("Lade App Meta Daten...");
    await ref.read(versionProvider.notifier).fetchVersion();
    updateHint("Lade Schulräume...");
    await ref.read(roomProvider.notifier).fetchRooms();
    updateHint("Lade Unterrichtsfächer...");
    await ref.read(subjectProvider.notifier).fetchSubjects();
    updateHint("Lade Stundenplan...");
    await ref.read(lessonProvider.notifier).fetchLessons();
    updateHint("Fertig!");
  }

  @override
  void initState() {
    initProviders().then((_) => setState(() => alreadyInitialized = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (alreadyInitialized) {
      ref.read(authProvider.notifier).verifyLogin().then(
            (valid) => valid
                ? Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TabsScreen()),
                  )
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ),
          );
    }

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              "assets/images/icon.png",
              width: 200.0,
              height: 200.0,
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              "ClassInsights",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Text(
              hintText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
