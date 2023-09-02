import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final String title;
  final double progress;
  final double baseValue;

  const ProgressBar({
    super.key,
    this.title = "",
    required this.progress,
    required this.baseValue,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 3.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => Container(
                height: 3.0,
                width: constraints.maxWidth * (widget.progress / widget.baseValue),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
