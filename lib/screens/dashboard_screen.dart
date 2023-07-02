import 'package:classinsights/widgets/header.dart';
import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(title: "Willkommen, Jakob."),
        Column(
          children: [
            WidgetContainer(
              child: Text("Hello World!"),
            ),
          ],
        ),
      ],
    );
  }
}
