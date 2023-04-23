import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../model/interfaces/serializable.dart';
import '../../../../model/model_schema_factory.dart';
import '../../../../model/schema/field_description.dart';
import '../../../../model/schema/field_type.dart';
import '../../../../model/schema/schema.dart';
import '../../../../services/http/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../utils/locales.dart';
import '../../../pages/page_base.dart';
import '../../misc/clickable_absorb_pointer.dart';

class ModelEditForm<M extends Model> extends StatefulWidget {
  final M? model;
  final List<Model>? connectedModels;

  const ModelEditForm({this.model, this.connectedModels, super.key});

  @override
  State<ModelEditForm<M>> createState() => _ModelEditFormState<M>();
}

class _ModelEditFormState<M extends Model> extends State<ModelEditForm<M>> {
  late final Schema<M> schema = makeModelSchema<M>(M);
  late final ModelHttpService<dynamic, M> httpService =
      makeModelHttpService<M>() as ModelHttpService<dynamic, M>;
  final Map<FieldDescription<dynamic, M>, TextEditingController> fieldsToControllers = {};
  final Map<FieldDescription<dynamic, M>, Serializable?> fieldsToSerializable = {};
  late final GlobalKey<FormState> formKey = GlobalKey();

  bool get isEditing => widget.model != null;

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

    for (final field in schema.fields.where((e) => e.fieldType == FieldType.serializable)) {
      fieldsToSerializable[field] = isEditing ? field.fieldGetter(widget.model!) : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редагування ${makeModelLocalizedName<M>()}'),
        titleTextStyle: const TextStyle(color: Colors.black),
        actions: [
          if (isEditing) buildDeleteButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: PageBase(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: buildForm(),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: buildSaveButton(),
    );
  }

  Widget buildForm() {
    return Form(
      key: formKey,
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
    if (field.fieldType == FieldType.serializable) {
      return buildSerializableField(
        fieldsToSerializable.entries.firstWhere((e) => e.key == field),
        controller,
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: field.fieldType.inputType,
      validator: field.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        label: Text(field.labelCaption),
      ),
    );
  }

  Widget buildEnumConstrainedField(
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
            decoration: InputDecoration(label: Text(field.labelCaption)),
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
    return ClickableAbsorbPointer(
      cursor: SystemMouseCursors.text,
      onTap: () async {
        final dateConstraints = field.dateConstraints!;

        final date = await showDatePicker(
          context: context,
          initialDate: dateConstraints.initialDate,
          firstDate: dateConstraints.firstDate,
          lastDate: dateConstraints.lastDate,
        );
        if (date == null) return;
        setState(() {
          controller.text = field.fieldType.presentation(date);
        });
      },
      child: TextFormField(
        decoration: InputDecoration(label: Text(field.labelCaption)),
        controller: controller,
      ),
    );
  }

  Widget buildSerializableField(
    MapEntry<FieldDescription<dynamic, M>, Serializable?> entry,
    TextEditingController controller,
  ) {
    final field = entry.key;

    return ClickableAbsorbPointer(
      cursor: SystemMouseCursors.text,
      onTap: () async {
        final initial = fieldsToSerializable[field];

        final res = await field.serializableEditorBuilder!(context, initial);
        if (!mounted) return;
        setState(() {
          fieldsToSerializable[field] = res;
          controller.text = '$res';
        });
      },
      child: TextFormField(
        decoration: InputDecoration(label: Text(field.labelCaption)),
        controller: controller,
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

    return foreignKey.makeEditor(
      updateCallback: (newForeignKey) => entry.value.text = '$newForeignKey',
      initiallyConnectedModel: connectedModel,
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton.icon(
      icon: Icon(isEditing ? Icons.save : Icons.add),
      onPressed: () {
        if (!(formKey.currentState?.validate() ?? true)) return;
        if (isEditing)
          _update();
        else
          _create();
      },
      label: Text(isEditing ? 'Зберегти' : 'Створити'),
    );
  }

  Future<bool> _update() {
    final newModel = generateEditedModel();
    if (newModel == null) {
      print('update model is incorrect');
      return Future.value(false);
    }

    return httpService.update(newModel, newModel.primaryKey);
  }

  Future<bool> _create() {
    final newModel = generateEditedModel();
    if (newModel == null) {
      print('create model is incorrect');
      return Future.value(false);
    }

    return httpService.post(newModel);
  }

  Widget buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Icon(Icons.delete, color: Colors.red[800]),
        onPressed: () => httpService.delete(widget.model!.primaryKey).then(print),
      ),
    );
  }

  Map<String, dynamic> generateJson() {
    final json = <String, dynamic>{};
    for (final entry in fieldsToControllers.entries) {
      final field = entry.key;
      final controller = fieldsToControllers[field]!;

      dynamic value;
      if (field.fieldType == FieldType.constrainedToEnum) {
        value = field.enumConstraint!.values[int.parse(controller.text)];
      } else if (field.fieldType == FieldType.serializable) {
        value = fieldsToSerializable[field]!;
      } else {
        value = field.fieldType.converter(controller.text);
      }

      if (value == '' && field.isNullable) value = null;
      json[field.fieldName] = value;
    }

    return json.map((key, value) => MapEntry(key, Schema.processValue(value)));
  }

  M? generateEditedModel() => schema.fromJson(generateJson());
}
