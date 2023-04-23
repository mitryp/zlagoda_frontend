import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../model/model_schema_factory.dart';
import '../../../../model/schema/schema.dart';
import '../../../../utils/locales.dart';
import '../../../../utils/navigation.dart';

typedef FieldGetter<R, M> = R Function(M);

class ModelTable<M extends Model> extends StatelessWidget {
  final M model;
  final bool showModelName;

  const ModelTable(this.model, {this.showModelName = true, super.key});

  Schema<M> get schema => makeModelSchema<M>(model.runtimeType);

  void redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).openModelViewFor<M>(model);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showModelName)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              makeModelLocalizedName<M>(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        DataTable(
          headingRowHeight: 0,
          columns: const [
            DataColumn(label: SizedBox()),
            DataColumn(label: SizedBox()),
          ],
          rows: buildRows(),
        ),
      ],
    );
  }

  List<DataRow> buildRows() {
    final labelsToValues = Map.fromEntries(
      schema.fields
          .where((field) => field.isShownOnIndividualPage)
          .map((field) => MapEntry(field.labelCaption!, field.presentFieldOf(model))),
    );

    return labelsToValues.entries.map(rowFromEntry).toList();
  }

  DataRow rowFromEntry(MapEntry<String, dynamic> e) => DataRow(cells: [
        DataCell(Text(e.key)),
        DataCell(Text(e.value.toString())),
      ]);
}
