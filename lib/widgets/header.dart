import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final bool showBottomMargin;

  const Header(this.title, {this.showBottomMargin = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        showBottomMargin ? const SizedBox(height: 20.0) : const SizedBox.shrink(),
      ],
    );
  }
}
