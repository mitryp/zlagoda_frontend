import '../services/http/http_service_factory.dart';
import '../services/http/model_http_service.dart';
import '../typedefs.dart';
import '../view/widgets/resources/models/model_table.dart';
import 'interfaces/model.dart';

class ModelReference<M extends Model> {
  final dynamic primaryKey;

  const ModelReference(this.primaryKey);

  Type get modelType => M;

  ModelHttpService<M> get resourceService => makeHttpService<M>();

  Future<M> fetch() => resourceService.singleById(primaryKey).then((v) => v!);
}

ModelTableGenerator<M> connectedTable<M extends Model>(dynamic primaryKey) =>
        () => ModelReference<M>(primaryKey).fetch().then(ModelTable.new);
