import 'package:flutter/material.dart';

class ComputerDetailItem extends StatelessWidget {
  final IconData icon;
  final String data;
  const ComputerDetailItem({required this.icon, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(data),
      ],
    );
  }
}
