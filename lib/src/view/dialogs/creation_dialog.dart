import 'package:flutter/material.dart';

import '../../theme.dart';

const double _padding = 24;

typedef InputBuilder = Widget Function(TextEditingController);

class ButtonProps<T> {
  final Future<T?> Function(int) fetchCallback;
  final String caption;
  final Color color;
  final String? message;

  const ButtonProps({
    required this.fetchCallback,
    required this.caption,
    this.color = primary,
    this.message
  });
}

class CreationDialog extends StatefulWidget {
  final InputBuilder inputBuilder;
  final controller = TextEditingController();
  final List<ButtonProps> buttonProps;

  CreationDialog({
    required this.inputBuilder,
    required this.buttonProps,
    super.key,
  });

  @override
  State<CreationDialog> createState() => _CreationDialogState();
}

class _CreationDialogState extends State<CreationDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      contentPadding: const EdgeInsets.all(_padding),
      actionsPadding: const EdgeInsets.all(_padding).copyWith(top: 0),
      content: widget.inputBuilder(widget.controller),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: widget.buttonProps.map((props) =>
          Tooltip(
            message: props.message,
            child: ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);
                final res = await props.fetchCallback(int.parse(widget.controller.text));
                setState(() => isLoading = false);

                Navigator.of(context).pop(res);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(props.color)),
              child: isLoading ? const CircularProgressIndicator() : Text(props.caption),
            ),
          )).toList(),
    );
  }
}

Future<T?> showCreationDialog<T>({
  required BuildContext context,
  required InputBuilder inputBuilder,
  required List<ButtonProps> buttonProps,
}) async =>
    showDialog<T>(
      context: context,
      builder: (context) =>
      CreationDialog(
        inputBuilder: inputBuilder,
        buttonProps: buttonProps,
      ),
    );
