import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;

  const Header(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
