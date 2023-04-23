import '../services/http/http_service_factory.dart';
import '../services/http/model_http_service.dart';
import '../typedefs.dart';
import '../view/widgets/resources/models/foreign_key_editor.dart';
import '../view/widgets/resources/models/model_table.dart';
import 'interfaces/model.dart';

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

class ForeignKey<M extends Model> {
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

  ForeignKeyEditor<M> makeEditor({
    required UpdateCallback<dynamic> updateCallback,
    M? initiallyConnectedModel,
  }) {
    return ForeignKeyEditor<M>(
      updateCallback: updateCallback,
      initialForeignKey: this,
      initiallyConnectedModel: initiallyConnectedModel,
    );
  }
}

ForeignKey<M> foreignKey<M extends Model>(String foreignKeyName, [dynamic primaryKeyValue]) {
  final ref = ModelReference<M>(primaryKeyValue);

  return ForeignKey<M>(
    foreignKeyName,
    reference: ref,
    tableGenerator: () => ref.fetch().then(ModelTable.new),
  );
}
