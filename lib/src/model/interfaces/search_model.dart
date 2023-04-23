import 'model.dart';

abstract class SearchModel<K> extends Model {
  @override
  final K primaryKey;

  final String descriptiveField;

  const SearchModel(this.primaryKey, this.descriptiveField);
}

