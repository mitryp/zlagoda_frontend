import 'package:flutter/material.dart';

class PageBase extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets bodyPadding;

  const PageBase({
    required Widget this.child,
    this.bodyPadding = const EdgeInsets.all(8),
    super.key,
  })  : children = null,
        mainAxisAlignment = null,
        crossAxisAlignment = null;

  const PageBase.column({
    required List<Widget> this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.bodyPadding = const EdgeInsets.all(8),
    super.key,
  }) : child = null;

  @override
  Widget build(BuildContext context) {
    final child = this.child ??
        Column(
          mainAxisAlignment: mainAxisAlignment!,
          crossAxisAlignment: crossAxisAlignment!,
          children: children!,
        );

    return SafeArea(
      minimum: bodyPadding,
      child: child,
    );
  }
}
