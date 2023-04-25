import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../typedefs.dart';

const double _padding = 24;

typedef InputBuilder = Widget Function(TextEditingController);

class ButtonProps {
  final void Function(int) fetchCallback;
  final String caption;
  final Color color;

  const ButtonProps({
    required this.fetchCallback,
    required this.caption,
    this.color = primary
  });
}

class CreationDialog extends StatelessWidget {
  final InputBuilder inputBuilder;
  final controller = TextEditingController();
  final List<ButtonProps> buttonProps;

  CreationDialog({
    required this.inputBuilder,
    required this.buttonProps,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      contentPadding: const EdgeInsets.all(_padding),
      actionsPadding: const EdgeInsets.all(_padding).copyWith(top: 0),
      content: inputBuilder(controller),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: buttonProps.map((props) =>
          ElevatedButton(
            onPressed: () async =>
                props.fetchCallback(int.parse(controller.text)),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(props.color)),
            child: Text(props.caption),
          )).toList(),
    );
  }
}

Future<bool> showCreationDialog({
  required BuildContext context,
  required InputBuilder inputBuilder,
  required List<ButtonProps> buttonProps,
}) async =>
    showDialog<bool>(
      context: context,
      builder: (context) =>
      CreationDialog(
        inputBuilder: inputBuilder,
        buttonProps: buttonProps,
      ),
    ).then((b) => b ?? false);
