import 'package:flutter/material.dart';

class WidgetContainer extends StatelessWidget {
  final bool primary;
  final double width;
  final Widget child;

  const WidgetContainer({
    super.key,
    this.primary = false,
    this.width = double.infinity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = primary
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.secondaryContainer;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(.5),
            blurRadius: 5.0,
            offset: const Offset(2.0, 4.0),
          ),
        ],
      ),
      child: child,
    );
  }
}
