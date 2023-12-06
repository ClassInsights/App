import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const ChartContainer({
    required this.title,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 40.0),
        child,
      ],
    ));
  }
}
