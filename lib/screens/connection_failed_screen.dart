import 'package:classinsights/helpers/host_checker.dart';
import 'package:classinsights/screens/splash_screen.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:classinsights/widgets/others/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConnectionFailedScreen extends StatelessWidget {
  const ConnectionFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    showSplashScreen() => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const SplashScreen(),
          ),
        );

    showError() => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: const Text("App konnte keine Verbindung zum Server aufbauen!"),
          ),
        );

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(top: 30.0),
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Header("Verbindung fehlgeschlagen"),
              const Text("Du konntest keine Verbindung zum Schulserver herstellen. Bist du mit dem Schulnetzwerk verbunden?"),
              const Spacer(),
              ContainerWithContent(
                  title: "Erneut Versuchen",
                  primary: true,
                  showArrow: true,
                  onTab: () async {
                    final hostAvailable = await checkHost(dotenv.env["API_HOST"]);
                    if (hostAvailable) {
                      showSplashScreen();
                    } else {
                      debugPrint("Failed to connect to ${dotenv.env["API_HOST"]}!");
                      showError();
                    }
                  }),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
