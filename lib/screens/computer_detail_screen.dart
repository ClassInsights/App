import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:classinsights/widgets/others/sub_screen_container.dart';
import 'package:flutter/material.dart';

class ComputerDetailScreen extends StatefulWidget {
  final Computer computer;
  const ComputerDetailScreen(this.computer, {super.key});

  @override
  State<ComputerDetailScreen> createState() => ComputerDetailScreenState();
}

class ComputerDetailScreenState extends State<ComputerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SubScreenContainer(
      title: widget.computer.name,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Computerdaten",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: App.defaultPadding),
                Text("Letzter Nutzer: ${widget.computer.lastUser}"),
                const SizedBox(height: App.smallPadding),
                Text("Zuletzt verwendet: ${widget.computer.lastSeen.day}-${widget.computer.lastSeen.month}-${widget.computer.lastSeen.year}"),
                const SizedBox(height: App.smallPadding),
                Text("IP: ${widget.computer.ipAddress}"),
                const SizedBox(height: App.smallPadding),
                Text("MAC: ${widget.computer.macAddress}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
