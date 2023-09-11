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
              builder: (context, constraints) => TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: constraints.maxWidth * (widget.progress / widget.baseValue)),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeInOut,
                  builder: (context, value, _) {
                    return Container(
                      width: value,
                      height: 3.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
