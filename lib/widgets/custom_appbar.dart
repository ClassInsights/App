import "package:flutter/material.dart";

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {
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
                      ? Text(
                          "Abmelden",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                        )
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
