import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/screens/login_screen.dart';
import 'package:classinsights/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).verifyLogin().then(
          (valid) => valid
              ? Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, firstAnimation, secondAnimation) => const TabsScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                )
              : Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, firstAnimation, secondAnimation) => const LoginScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
        );

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
