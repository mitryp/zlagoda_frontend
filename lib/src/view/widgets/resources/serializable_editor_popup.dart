import 'package:flutter/material.dart';

import '../../../model/interfaces/serializable.dart';
import '../../../model/model_schema_factory.dart';
import '../../../model/schema/field_description.dart';
import '../../../model/schema/schema.dart';
import '../../../theme.dart';

class SerializableEditorPopup<S extends Serializable> extends StatefulWidget {
  final S? initialSerializable;

  const SerializableEditorPopup({required this.initialSerializable, super.key});

  @override
  State<SerializableEditorPopup<S>> createState() => SerializableEditorPopupState<S>();
}

class SerializableEditorPopupState<S extends Serializable>
    extends State<SerializableEditorPopup<S>> {
  late final Schema<S> schema = makeModelSchema<S>();
  late final Map<FieldDescription<dynamic, S>, TextEditingController> fieldsToControllers;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    fieldsToControllers = Map.fromEntries(
      schema.fields.map((field) {
        String? text;
        if (widget.initialSerializable != null) {
          final value = field.fieldGetter(widget.initialSerializable!);
          text = value != null ? '$value' : null;
        }

        return MapEntry(field, TextEditingController(text: text));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              ...fieldsToControllers.entries.map(buildFormField),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: popEditedSerializable,
                  child: const Text('Зберегти'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormField(MapEntry<FieldDescription<dynamic, S>, TextEditingController> entry) {
    final field = entry.key;
    final controller = entry.value;

    return TextFormField(
      decoration: InputDecoration(label: Text(field.labelCaption)),
      controller: controller,
      validator: field.validator,
    );
  }

  void popEditedSerializable() {
    if (!formKey.currentState!.validate()) return;

    final json = fieldsToControllers.map(
      (key, value) {
        final text = value.text.trim();
        return MapEntry(key.fieldName, key.isNullable && text.isEmpty ? null : text);
      },
    );

    final newSerializable = schema.fromJson(json);

    Navigator.of(context).pop(newSerializable);
  }
}

Future<S?> showSerializableEditor<S extends Serializable>(
  BuildContext context,
  S initialSerializable,
) {
  return showDialog<S>(
    context: context,
    useSafeArea: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 250),
          child: SerializableEditorPopup<S>(initialSerializable: initialSerializable),
        ),
      );
    },
  );
}
