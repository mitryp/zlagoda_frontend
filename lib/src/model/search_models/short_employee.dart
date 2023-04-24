import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortEmployee extends SearchModel<String> {
  static final Schema<ShortEmployee> schema = Schema(ShortEmployee.new, [
    FieldDescription<String, ShortEmployee>(
      'employeeId',
      (o) => o.primaryKey,
      labelCaption: 'Пошук за id працівника',
    ),
    FieldDescription<String, ShortEmployee>(
      'employeeName',
      (o) => o.descriptiveField,
      labelCaption: 'Пошук за назвою ПІБ працівника',
    ),
  ]);

  ShortEmployee({required String employeeId, required String employeeName})
      : super(employeeId, employeeName);

  static ShortEmployee? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);
}
