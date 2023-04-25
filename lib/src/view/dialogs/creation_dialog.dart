import 'package:flutter/material.dart';

import '../../model/basic_models/store_product.dart';
import '../../theme.dart';
import '../../utils/value_status.dart';

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
  final formKey = GlobalKey<FormState>();

  void _onPressed(ButtonProps props) async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final res = await props.fetchCallback(int.parse(widget.controller.text));
    if(!mounted) return;

    setState(() => isLoading = false);

    Navigator.of(context).pop(ValueStatusWrapper<StoreProduct>.updated(res));
  }

  List<Widget> buildActions() {
    return widget.buttonProps.map((props) =>
        Tooltip(
          message: props.message,
          child: ElevatedButton(
            onPressed: ()async => _onPressed(props),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(props.color)),
            child: isLoading ? const CircularProgressIndicator() : Text(props.caption),
          ),
        )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      contentPadding: const EdgeInsets.all(_padding),
      actionsPadding: const EdgeInsets.all(_padding).copyWith(top: 0),
      content: Form(
          key: formKey,
        child: widget.inputBuilder(widget.controller),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: buildActions(),
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
