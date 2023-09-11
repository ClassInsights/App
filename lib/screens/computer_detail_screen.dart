import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/widgets/appbars/detail_appbar.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            DetailAppbar(
              title: widget.computer.name,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
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
                            Text(
                                "Zuletzt verwendet: ${widget.computer.lastSeen.day}-${widget.computer.lastSeen.month}-${widget.computer.lastSeen.year}"),
                            const SizedBox(height: App.smallPadding),
                            Text("IP: ${widget.computer.ipAddress}"),
                            const SizedBox(height: App.smallPadding),
                            Text("MAC: ${widget.computer.macAddress}"),
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
