import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../typedefs.dart';

const _defaultConfirmationDialogStyle = ConfirmationDialogStyle(
  acceptButtonColor: secondary,
  cancelButtonColor: primary,
  padding: 24,
);

class ConfirmationDialog extends StatelessWidget {
  final Widget? content;
  final String? message;
  final TextStyle? textStyle;
  final ConfirmationDialogStyle style;

  const ConfirmationDialog({
    required Widget this.content,
    this.style = _defaultConfirmationDialogStyle,
    super.key,
  })  : message = null,
        textStyle = null;

  const ConfirmationDialog.message(
    String this.message, {
    this.textStyle,
    this.style = _defaultConfirmationDialogStyle,
    super.key,
  }) : content = null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      contentPadding: EdgeInsets.all(style.padding),
      actionsPadding: EdgeInsets.all(style.padding).copyWith(top: 0),
      content: content ?? Text(message!, style: textStyle),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(style.acceptButtonColor)),
          child: const Text('Підтвердити'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(style.cancelButtonColor)),
          child: const Text('Скасувати'),
        ),
      ],
    );
  }
}

class ConfirmationDialogStyle {
  final Color acceptButtonColor;
  final Color cancelButtonColor;

  /// Padding on the edges and between content and actions.
  ///
  final double padding;

  const ConfirmationDialogStyle({
    required this.acceptButtonColor,
    required this.cancelButtonColor,
    required this.padding,
  });
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required ExactWidgetBuilder<ConfirmationDialog> builder,
}) async =>
    showDialog<bool>(context: context, builder: builder).then((b) => b ?? false);
