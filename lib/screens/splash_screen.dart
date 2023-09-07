import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
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

  Future<void> initProviders() async {
    await ref.read(authProvider.notifier).reload();
    await ref.read(versionProvider.notifier).fetchVersion();
    var validLogin = ref.read(authProvider).creds.accessToken.isNotEmpty;
    if (validLogin) {
      await ref.read(roomProvider.notifier).fetchRooms();
    }
  }

  @override
  void initState() {
    if (ref.read(authProvider).creds.accessToken.isNotEmpty) {
      setState(() => alreadyInitialized = true);
      return;
    }
    initProviders().then((_) => setState(() => alreadyInitialized = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (alreadyInitialized) {
      ref.read(authProvider.notifier).verifyLogin().then(
            (valid) => valid
                ? Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TabsScreen()),
                  )
                : Navigator.of(context).push(
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
          ],
        ),
      ),
    );
  }
}
