import 'package:flutter/material.dart';

import '../../typedefs.dart';

class PageBase extends StatelessWidget {
  final Widget? child;
  final FlexContainerType? containerType;
  final List<Widget>? children;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final EdgeInsets bodyPadding;

  const PageBase({
    required Widget this.child,
    this.bodyPadding = const EdgeInsets.all(8),
    super.key,
  })  : children = null,
        mainAxisAlignment = null,
        crossAxisAlignment = null,
        mainAxisSize = null,
        verticalDirection = null,
        containerType = null;

  const PageBase.column({
    required List<Widget> this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.bodyPadding = const EdgeInsets.all(8),
    super.key,
  })  : containerType = Column.new,
        child = null;

  const PageBase.row({
    required List<Widget> this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.up,
    this.bodyPadding = const EdgeInsets.all(8),
    super.key,
  })  : containerType = Row.new,
        child = null;

  @override
  Widget build(BuildContext context) {
    final child = this.child ??
        containerType!(
          mainAxisAlignment: mainAxisAlignment!,
          crossAxisAlignment: crossAxisAlignment!,
          mainAxisSize: mainAxisSize!,
          verticalDirection: verticalDirection!,
          children: children!,
        );

    return SafeArea(
      minimum: bodyPadding,
      child: child,
    );
  }
}
