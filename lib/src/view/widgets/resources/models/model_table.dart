import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../model/model_scheme_factory.dart';
import '../../../../model/schema/schema.dart';
import '../../../../utils/locales.dart';

typedef FieldGetter<R, M> = R Function(M);

class ModelTable<M extends Model> extends StatelessWidget {
  final M model;
  final bool showModelName;

  const ModelTable(this.model, {this.showModelName = true, super.key});

  Schema<M> get schema => makeModelSchema(model.runtimeType);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showModelName)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(makeModelLocalizedName<M>(), style: const TextStyle(fontSize: 16),),
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
      schema.retrievers
          .where((field) => field.isShownOnIndividualPage)
          .map((r) => MapEntry(r.labelCaption!, r.fieldGetter(model))),
    );

    return labelsToValues.entries.map(rowFromEntry).toList();
  }

  DataRow rowFromEntry(MapEntry<String, dynamic> e) => DataRow(cells: [
      DataCell(Text(e.key)),
      DataCell(Text(e.value.toString())),
    ]);
}