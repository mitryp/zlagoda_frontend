import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortEmployee extends ShortModel<String> {
  static final Schema<ShortEmployee> schema = Schema(ShortEmployee.new, [
    FieldDescription<String, ShortEmployee>(
      'primaryKey',
      (o) => o.primaryKey,
      labelCaption: '',
    ),
    FieldDescription<String, ShortEmployee>(
      'descriptiveAttr',
      (o) => o.descriptiveAttr,
      labelCaption: 'Пошук за табельним номером або ПІБ працівника',
    ),
  ]);

  ShortEmployee({required super.primaryKey, required super.descriptiveAttr});

  static ShortEmployee? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  String toString() {
    return '$primaryKey $descriptiveAttr';
  }
}
