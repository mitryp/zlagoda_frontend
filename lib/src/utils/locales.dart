import '../model/basic_models/category.dart';
import '../model/basic_models/client.dart';
import '../model/basic_models/employee.dart';
import '../model/basic_models/product.dart';
import '../model/basic_models/store_product.dart';
import '../model/interfaces/model.dart';

const _localizedModelNames = {
  Product: 'Товар',
  StoreProduct: 'Товар у магазині',
  Category: 'Категорія',
  Employee: 'Працівник',
  Client: 'Картка клієнта',
};

String makeModelLocalizedName<M extends Model>([Type? modelType]) {
  return _localizedModelNames[modelType ?? M] ?? 'Нелокалізована модель ${modelType ?? M}';
}
