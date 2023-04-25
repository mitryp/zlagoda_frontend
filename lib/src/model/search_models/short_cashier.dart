import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortCashier extends ShortModel<String> {
  static final Schema<ShortCashier> schema = Schema(ShortCashier.new, [
    FieldDescription<String, ShortCashier>(
      'primaryKey',
      (o) => o.primaryKey,
      labelCaption: '',
    ),
    FieldDescription<String, ShortCashier>(
      'descriptiveAttr',
      (o) => o.descriptiveAttr,
      labelCaption: 'Пошук за табельним номером або ПІБ касира',
    ),
  ]);

  ShortCashier({required super.primaryKey, required super.descriptiveAttr});

  static ShortCashier? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  String toString() => '$primaryKey $descriptiveAttr';
}
