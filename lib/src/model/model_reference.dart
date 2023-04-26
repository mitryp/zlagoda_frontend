import 'package:flutter/cupertino.dart';

import '../services/http/helpers/http_service_factory.dart';
import '../services/http/model_http_service.dart';
import '../typedefs.dart';
import '../view/widgets/queries/model_search_initiator.dart';
import '../view/widgets/resources/models/foreign_key_editor.dart';
import '../view/widgets/resources/models/model_table.dart';
import 'interfaces/model.dart';
import 'interfaces/search_model.dart';

class ModelReference<M extends Model> {
  final dynamic primaryKeyValue;

  const ModelReference(this.primaryKeyValue);

  Type get modelType => M;

  ModelHttpService get httpService => makeModelHttpService<M>();

  bool get isConnected => primaryKeyValue != null;

  Future<M> fetch() {
    assert(isConnected);
    return httpService.singleById(primaryKeyValue).then((v) => v as M);
  }
}

class ForeignKey<M extends Model, SM extends ShortModel> {
  final String foreignKeyName;
  final ModelReference<M> reference;
  final ModelTableGenerator<M> tableGenerator;
  final String? label;

  const ForeignKey(
    this.foreignKeyName, {
    required this.reference,
    required this.tableGenerator,
    this.label,
  });

  Type get modelType => M;

  ForeignKeyEditor<M, SM> makeEditor({
    required UpdateCallback<dynamic> updateCallback,
    M? initiallyConnectedModel,
  }) {
    return ForeignKeyEditor<M, SM>(
      updateCallback: updateCallback,
      initialForeignKey: this,
      initiallyConnectedModel: initiallyConnectedModel,
    );
  }

  ModelSearchInitiatorConstructor<dynamic, SM> get searchInitiator {
    return ModelSearchInitiator<dynamic, SM>.new;
  }
}

ForeignKey<M, SM> foreignKey<M extends Model, SM extends ShortModel>(
  String foreignKeyName, [
  dynamic primaryKeyValue,
]) {
  final ref = ModelReference<M>(primaryKeyValue);

  return ForeignKey<M, SM>(
    foreignKeyName,
    reference: ref,
    tableGenerator: () => ref.fetch().then(ModelTable.new),
  );
}
