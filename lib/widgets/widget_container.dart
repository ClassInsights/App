import 'package:classinsights/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetContainer extends ConsumerWidget {
  final Widget child;
  final double width;
  final bool primary;

  const WidgetContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkMode = ref.watch(themeProvider.notifier).theme == ThemeMode.dark;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: primary ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: (primary ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer)
                .withOpacity(darkMode ? .1 : .1),
            blurRadius: 5.0,
            offset: const Offset(2.0, 4.0),
          ),
        ],
      ),
      child: child,
    );
  }
}
