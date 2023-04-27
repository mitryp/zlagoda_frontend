import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortCategory extends ShortModel<int> {
  static final Schema<ShortCategory> schema = Schema(ShortCategory.new, [
    FieldDescription<int, ShortCategory>(
      'primaryKey',
      (o) => o.primaryKey,
      labelCaption: '',
    ),
    FieldDescription<String, ShortCategory>(
      'descriptiveAttr',
      (o) => o.descriptiveAttr,
      labelCaption: 'Пошук за назвою категорії',
    ),
  ]);

  ShortCategory({required super.primaryKey, required super.descriptiveAttr});

  static ShortCategory? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  String toString() {
    return descriptiveAttr;
  }
}
