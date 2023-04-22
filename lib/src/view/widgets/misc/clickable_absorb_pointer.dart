import 'package:flutter/material.dart';

class ClickableAbsorbPointer extends StatelessWidget {
  final MouseCursor cursor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  const ClickableAbsorbPointer({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.cursor = SystemMouseCursors.click,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AbsorbPointer(
          child: child,
        ),
      ),
    );
  }
}
