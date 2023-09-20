import 'package:flutter/material.dart';

class DetailAppbar extends StatelessWidget {
  final String title;
  final Function onBack;

  const DetailAppbar({
    required this.title,
    required this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 20.0),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
