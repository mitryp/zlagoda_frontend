import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../typedefs.dart';

class ConfirmationDialog extends StatelessWidget {
  static const defaultStyle = ConfirmationDialogStyle(
      acceptButtonColor: secondary,
      cancelButtonColor: primary,
      padding: 24,
      acceptButtonLabel: 'Підтвердити',
      cancelButtonLabel: 'Скасувати');

  final Widget? content;
  final String? message;
  final TextStyle? textStyle;
  final ConfirmationDialogStyle style;

  const ConfirmationDialog({
    required Widget this.content,
    this.style = defaultStyle,
    super.key,
  })  : message = null,
        textStyle = null;

  const ConfirmationDialog.message(
    String this.message, {
    this.textStyle,
    this.style = defaultStyle,
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
          child: Text(style.acceptButtonLabel),
        ),
        if (style.cancelButtonLabel != null)
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(style.cancelButtonColor)),
            child: Text(style.cancelButtonLabel!),
          ),
      ],
    );
  }
}

class ConfirmationDialogStyle {
  final String acceptButtonLabel;
  final String? cancelButtonLabel;
  final Color acceptButtonColor;
  final Color cancelButtonColor;

  /// Padding on the edges and between content and actions.
  ///
  final double padding;

  const ConfirmationDialogStyle({
    required this.acceptButtonColor,
    required this.cancelButtonColor,
    required this.acceptButtonLabel,
    this.cancelButtonLabel,
    required this.padding,
  });

  ConfirmationDialogStyle copyWith({
    Color? acceptButtonColor,
    Color? cancelButtonColor,
    double? padding,
    String? acceptButtonLabel,
    String? cancelButtonLabel,
  }) {
    return ConfirmationDialogStyle(
      acceptButtonColor: acceptButtonColor ?? this.acceptButtonColor,
      cancelButtonColor: cancelButtonColor ?? this.cancelButtonColor,
      acceptButtonLabel: acceptButtonLabel ?? this.acceptButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      padding: padding ?? this.padding,
    );
  }
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required ExactWidgetBuilder<ConfirmationDialog> builder,
}) async =>
    showDialog<bool>(context: context, builder: builder).then((b) => b ?? false);
