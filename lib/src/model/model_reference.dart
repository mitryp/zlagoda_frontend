import '../services/http/http_service_factory.dart';
import '../services/http/model_http_service.dart';
import '../typedefs.dart';
import '../view/widgets/resources/models/model_table.dart';
import 'interfaces/model.dart';

class ModelReference<M extends Model> {
  final dynamic primaryKeyValue;

  const ModelReference(this.primaryKeyValue);

  Type get modelType => M;

  ModelHttpService<M> get httpService => makeHttpService<M>();

  Future<M> fetch() => httpService.singleById(primaryKeyValue).then((v) => v!);
}

class ForeignKey<M extends Model> {
  final String foreignKeyName;
  final ModelReference<M> reference;
  final ModelTableGenerator<M> tableGenerator;

  const ForeignKey(this.foreignKeyName, {required this.reference, required this.tableGenerator});

  Type get modelType => M;
}

ModelTableGenerator<M> connectedTable<M extends Model>(dynamic primaryKey) =>
    () => ModelReference<M>(primaryKey).fetch().then(ModelTable.new);

ForeignKey<M> foreignKey<M extends Model>(String foreignKeyName, dynamic primaryKeyValue) {
  final ref = ModelReference<M>(primaryKeyValue);

  return ForeignKey<M>(foreignKeyName,
      reference: ref, tableGenerator: () => ref.fetch().then(ModelTable.new));
}
