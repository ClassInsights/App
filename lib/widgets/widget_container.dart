import 'package:flutter/material.dart';

class WidgetContainer extends StatelessWidget {
  final bool primary;
  final double width;
  final String label;
  final String title;
  final Widget child;

  const WidgetContainer({
    super.key,
    this.primary = false,
    this.width = double.infinity,
    this.label = "",
    required this.title,
    this.child = const SizedBox(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                  ],
                ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          child is SizedBox
              ? child
              : Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    child,
                  ],
                ),
        ],
      ),
    );
  }
}
