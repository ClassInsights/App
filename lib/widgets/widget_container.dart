import 'package:flutter/material.dart';

class WidgetContainer extends StatelessWidget {
  final bool primary;
  final double width;
  final String label;
  final String title;
  final Widget? child;
  final Function? onTab;
  final bool showArrow;

  const WidgetContainer({
    super.key,
    this.primary = false,
    this.width = double.infinity,
    required this.label,
    required this.title,
    this.child,
    this.onTab,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = primary ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer;
    return GestureDetector(
      onTap: onTab == null ? null : onTab as void Function()?,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(.5),
              blurRadius: 5.0,
              offset: const Offset(2.0, 4.0),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      label.toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: primary ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  Text(title,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: primary ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.onBackground,
                          )),
                  child == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            child!,
                          ],
                        ),
                ],
              ),
            ),
            showArrow
                ? Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: primary ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.secondary,
                    size: 20.0,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
