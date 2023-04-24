import '../../typedefs.dart';
import '../basic_models/category.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortCategory extends SearchModel<int> {
  static final Schema<ShortCategory> schema = Schema(ShortCategory.new, [
    FieldDescription<int, ShortCategory>(
      'categoryId',
      (o) => o.primaryKey,
      labelCaption: '',
    ),
    FieldDescription<String, ShortCategory>(
      'categoryName',
      (o) => o.descriptiveField,
      labelCaption: 'Пошук за назвою категорії',
    ),
  ]);

  ShortCategory({required int categoryId, required String categoryName})
      : super(categoryId, categoryName);

  static ShortCategory? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);
}
