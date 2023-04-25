import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortClient extends ShortModel<String> {
  static final Schema<ShortClient> schema = Schema(ShortClient.new, [
    FieldDescription<String, ShortClient>(
      'primaryKey',
      (o) => o.primaryKey,
      labelCaption: '',
    ),
    FieldDescription<String, ShortClient>(
      'descriptiveAttr',
      (o) => o.descriptiveAttr,
      labelCaption: 'Пошук за номер картки або ПІБ клієнта',
    )
  ]);

  ShortClient({required super.primaryKey, required super.descriptiveAttr});

  static ShortClient? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  toJson() => schema.toJson(this);

  @override
  String toString() => '$primaryKey $descriptiveAttr';
}
