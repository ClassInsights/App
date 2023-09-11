import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
import 'package:classinsights/providers/subject_provider.dart';
import 'package:classinsights/providers/version_provider.dart';
import 'package:classinsights/screens/login_screen.dart';
import 'package:classinsights/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool alreadyInitialized = false;
  var hintText = "";

  Future<void> initProviders() async {
    setState(() => hintText = "Lese Account Daten...");
    await ref.read(authProvider.notifier).reload();
    setState(() => hintText = "Lade App Meta Daten...");
    await ref.read(versionProvider.notifier).fetchVersion();
    setState(() => hintText = "Lade Schulräume...");
    await ref.read(roomProvider.notifier).fetchRooms();
    setState(() => hintText = "Lade Unterrichtsfächer...");
    await ref.read(subjectProvider.notifier).fetchSubjects();
    setState(() => hintText = "Lade Stundenplan...");
    await ref.read(lessonProvider.notifier).fetchLessons();
    setState(() => hintText = "Fertig!");
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
                    PageRouteBuilder(
                      pageBuilder: (context, firstAnimation, secondAnimation) => const LoginScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              child: const Placeholder(),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              "Class Insights",
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
