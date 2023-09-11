import "package:classinsights/providers/auth_provider.dart";
import "package:classinsights/screens/login_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final int index;

  const CustomAppBar({
    super.key,
    required this.height,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logout() {
      ref.read(authProvider.notifier).logout();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
            pageBuilder: (context, firstAnimation, secondAnimation) => const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  index == 2
                      ? GestureDetector(
                          onTap: logout,
                          child: Text(
                            "Abmelden",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
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
  Size get preferredSize => Size.fromHeight(height);
}
