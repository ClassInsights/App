import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DangerZoneWidget extends ConsumerWidget {
  final Computer computer;
  const DangerZoneWidget(this.computer, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    shutdownComputer() async {
      debugPrint("Shutting down computer");
    }

    restartComputer() async {
      debugPrint("Restarting computer");
    }

    logoutUser() async {
      debugPrint("Logging out user");
    }

    return WidgetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gefahrenzone",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: App.smallPadding),
          const Text("Bediene den Computer aus der Ferne."),
          const SizedBox(height: App.defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: shutdownComputer,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                ),
                child: Text(
                  "Herunterfahren",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              TextButton(
                onPressed: logoutUser,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                ),
                child: Text(
                  "Abmelden",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              TextButton(
                onPressed: restartComputer,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                ),
                child: Text(
                  "Neustarten",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
