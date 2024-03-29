import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/screens/microsoft_login_screen.dart';
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
    void showError() {
      setState(() => alreadySubmited = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: const Text(
              "Login fehlgeschlagen! Bitte versuchen Sie es später erneut."),
        ),
      );
    }

    void login() {
      setState(() => alreadySubmited = true);
      Navigator.of(context)
          .push(
        PageRouteBuilder(
          pageBuilder: (context, firstAnimation, secondAnimation) =>
              const MicrosoftLoginScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      )
          .then((code) {
        ref.read(authProvider.notifier).initialLogin(code).then((success) {
          if (success) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, firstAnimation, secondAnimation) =>
                    const SplashScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
            showError();
          }
        });
      });
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
                const Text(
                    "ClassInsights ist eine App, die Ihnen einen Überblick über verschiedensten Raum- und Computerdaten an der HAK/HAS/HLW Landeck gibt. Die App wurde im Rahmen einer Diplomarbeit 2023/2024 entwickelt."),
                const SizedBox(height: 15.0),
                const Text(
                    "Um die App nutzen zu können, müssen Sie sich mit Ihrem Microsoft Schulaccount anmelden."),
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
