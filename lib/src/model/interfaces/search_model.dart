import 'model.dart';

abstract class SearchModel<K> extends Model {
  @override
  final K primaryKey;

  final String descriptiveAttr;

  const SearchModel({required this.primaryKey, required this.descriptiveAttr});
}

