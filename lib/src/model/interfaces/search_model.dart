import 'model.dart';

abstract class ShortModel<K> extends Model {
  @override
  final K primaryKey;

  final String descriptiveAttr;

  const ShortModel({required this.primaryKey, required this.descriptiveAttr});
}

