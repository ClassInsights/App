import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final Widget? action;

  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  if (action != null) action!,
                ],
              ),
            ),
            Container(
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                color: Theme.of(context).colorScheme.onBackground.withOpacity(.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
