import 'package:classinsights/widgets/widget_container.dart';
import 'package:flutter/material.dart';

class ContainerWithContent extends StatelessWidget {
  final bool primary;
  final double width;
  final String label;
  final String title;
  final Widget? child;
  final Function? onTab;
  final bool showArrow;

  const ContainerWithContent({
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
    return GestureDetector(
      onTap: onTab == null ? null : onTab as void Function()?,
      child: WidgetContainer(
        primary: primary,
        width: width,
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