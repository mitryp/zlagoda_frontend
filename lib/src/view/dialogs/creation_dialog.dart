import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../typedefs.dart';

const _acceptButtonColor = secondary;
const _cancelButtonColor = primary;
const double _padding = 24;

typedef InputBuilder = Widget Function(BuildContext, TextEditingController);

class CreationDialog extends StatelessWidget {
  final InputBuilder inputBuilder;
  final controller = TextEditingController();

  CreationDialog({
    required this.inputBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      contentPadding: const EdgeInsets.all(_padding),
      actionsPadding: const EdgeInsets.all(_padding).copyWith(top: 0),
      content: inputBuilder(context, controller),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(_acceptButtonColor)),
          child: const Text('Підтвердити'),
        ),
      ],
    );
  }
}

Future<bool> showCreationDialog({
  required BuildContext context,
  required ExactWidgetBuilder<CreationDialog> builder,
}) async =>
    showDialog<bool>(context: context, builder: builder)
        .then((b) => b ?? false);
