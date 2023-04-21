import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../model/model_scheme_factory.dart';
import '../../../../model/schema/field_description.dart';
import '../../../../model/schema/field_type.dart';
import '../../../../model/schema/schema.dart';
import '../../../../utils/locales.dart';
import '../../../pages/page_base.dart';
import 'foreign_key_editor.dart';

class ModelEditForm<M extends Model> extends StatefulWidget {
  final M? model;
  final List<Model>? connectedModels;

  const ModelEditForm({this.model, this.connectedModels, super.key});

  @override
  State<ModelEditForm<M>> createState() => _ModelEditFormState<M>();
}

class _ModelEditFormState<M extends Model> extends State<ModelEditForm<M>> {
  late final Schema<M> schema = makeModelSchema<M>(M);
  final Map<FieldDescription<dynamic, M>, TextEditingController> fieldsToControllers = {};

  @override
  void initState() {
    super.initState();

    final model = widget.model;

    for (final field in schema.fields) {
      String? presentation;
      if (model != null) {
        presentation = field.fieldType == FieldType.constrainedToEnum
            ? field.fieldGetter(model).index.toString()
            : field.presentFieldOf(model);
      }

      fieldsToControllers[field] = TextEditingController(text: presentation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редагування ${makeModelLocalizedName<M>()}'),
        titleTextStyle: const TextStyle(color: Colors.black),
        actions: [
          buildDeleteButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: PageBase(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Form(
                  child: Column(
                    children: [
                      ...fieldsToControllers.entries
                          .where((e) => e.key.isOwnProperty && e.key.isEditable)
                          .map(buildOwnFormField),
                      const SizedBox(height: 10),
                      ...fieldsToControllers.entries
                          .where((e) => !e.key.isOwnProperty)
                          .map(buildForeignKeyEditor),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOwnFormField(MapEntry<FieldDescription<dynamic, M>, TextEditingController> entry) {
    final field = entry.key;
    final controller = entry.value;

    if (field.fieldType == FieldType.constrainedToEnum) {
      return buildEnumConstrainedField(field, controller);
    }
    if (field.fieldType == FieldType.date) {
      return buildDateField(field, controller);
    }

    return TextFormField(
      controller: controller,
      keyboardType: field.fieldType.inputType,
      validator: field.validator,
      decoration: InputDecoration(
        label: Text(field.labelCaption),
      ),
    );
  }

  Row buildEnumConstrainedField(
      FieldDescription<dynamic, dynamic> field, TextEditingController controller) {
    final items = field.enumConstraint!.values
        .map((e) => DropdownMenuItem(value: e.index, child: Text('$e')))
        .toList();

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            items: items,
            value: int.parse(controller.text),
            decoration: InputDecoration(label: Text(field.labelCaption ?? field.fieldName)),
            onChanged: (value) {
              if (value == null) return;
              setState(() => controller.text = value.toString());
            },
          ),
        ),
      ],
    );
  }

  Widget buildDateField(FieldDescription<dynamic, M> field, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        // final date = await
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
        ),
      ),
    );
  }

  Widget buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        // todo deletion button
        icon: Icon(Icons.delete, color: Colors.red[800]),
        onPressed: () {},
      ),
    );
  }

  Widget buildForeignKeyEditor(
      MapEntry<FieldDescription<dynamic, M>, TextEditingController> entry) {
    final field = entry.key;
    final foreignKey =
        widget.model?.foreignKeys.firstWhere((key) => key.foreignKeyName == field.fieldName) ??
            field.defaultForeignKey!;
    final connectedModel = widget.connectedModels
        ?.firstWhere((e) => e.runtimeType == field.defaultForeignKey!.modelType);

    return ForeignKeyEditor(
      initialForeignKey: foreignKey,
      updateCallback: (newForeignKey) => entry.value.text = '$newForeignKey',
      initiallyConnectedModel: connectedModel,
    );
  }
}
