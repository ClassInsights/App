import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  final String title;
  final Color color;

  const LegendItem({
    required this.title,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 5),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
