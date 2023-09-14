import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/screens/splash_screen.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:classinsights/widgets/others/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var alreadySubmited = false;

  @override
  Widget build(BuildContext context) {
    void login() {
      setState(() => alreadySubmited = true);
      ref.read(authProvider.notifier).initialLogin().then(
        (success) {
          if (success) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, firstAnimation, secondAnimation) => const SplashScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
            setState(() => alreadySubmited = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                content: const Text("Login fehlgeschlagen! Bitte versuchen Sie es später erneut."),
              ),
            );
          }
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Header("Herzlich Willkommen!"),
                const Text("Class Insights ist eine App, die dir einen Überblick über die EDV Infrasturktur an der HAK/HAS/HLW Landeck gibt."),
                const SizedBox(height: 20.0),
                const Text("Um die App nutzen zu können, musst du dich mit deinem Microsoft Schulaccount anmelden."),
                const Spacer(),
                ContainerWithContent(
                  label: "Mit Microsoft",
                  title: "Anmelden",
                  primary: true,
                  showArrow: true,
                  onTab: login,
                ),
                const SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
          if (alreadySubmited) ...[
            const Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                ),
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
