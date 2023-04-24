import '../interfaces/serializable.dart';
import '../model_reference.dart';
import 'search_model.dart';

abstract class Model implements Serializable {
  const Model();

  dynamic get primaryKey;

  List<ForeignKey> get foreignKeys => [];

  SearchModel toSearchModel() =>
      throw UnimplementedError('Model $runtimeType does not support search');
}
