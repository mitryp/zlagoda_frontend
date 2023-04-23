import 'model.dart';

abstract class SearchModel<M extends Model, K, V> extends Model {
  @override
  final K primaryKey;

  final V descriptiveField;

  const SearchModel(this.primaryKey, this.descriptiveField);
}

