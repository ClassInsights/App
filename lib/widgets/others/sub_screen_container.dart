import 'package:classinsights/widgets/appbars/detail_appbar.dart';
import 'package:flutter/material.dart';

typedef FutureCallback = Future<void> Function();

class SubScreenContainer extends StatelessWidget {
  final String title;
  final Widget body;
  final FutureCallback? refreshAction;

  const SubScreenContainer({required this.title, required this.body, this.refreshAction, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final content = SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (30.0 + 70.0) + 0.1,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(30.0),
                    child: body,
                  ),
                ),
              );

              return Container(
                margin: const EdgeInsets.only(top: 30.0 + 70.0),
                child: refreshAction != null
                    ? RefreshIndicator(
                        onRefresh: refreshAction!,
                        color: Theme.of(context).colorScheme.background,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: content,
                      )
                    : content,
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: DetailAppbar(
              title: title,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
