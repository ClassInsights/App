import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/screens/splash_screen.dart';
import 'package:classinsights/widgets/container_content.dart';
import 'package:classinsights/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30.0),
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Header("Herzlich Willkommen!"),
            const Text("Class Insights ist eine App, die dir einen Überblick über die EDV Infrasturktur an der HAK/HAS/HLW Landeck gibt."),
            const SizedBox(
              height: 20.0,
            ),
            const Text("Um die App nutzen zu können, musst du dich mit deinem Microsoft Schulaccount anmelden."),
            const SizedBox(
              height: 30.0,
            ),
            ContainerWithContent(
              label: "Mit Microsoft",
              title: "Anmelden",
              primary: true,
              showArrow: true,
              onTab: () => ref.read(authProvider.notifier).initialLogin().then(
                    (success) => success
                        ? Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, firstAnimation, secondAnimation) => const SplashScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          )
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              content: const Text("Login fehlgeschlagen! Bitte versuchen Sie es später erneut."),
                            ),
                          ),
                  ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
