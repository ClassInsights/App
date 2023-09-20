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
    const defaultPadding = 30.0;
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final content = SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (30.0 + 80.0) + .1,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 30.0, left: 30.0, right: 30.0),
                    child: body,
                  ),
                ),
              );

              return Container(
                margin: const EdgeInsets.only(top: defaultPadding + 80.0),
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
