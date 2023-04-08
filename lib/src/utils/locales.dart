import '../model/basic_models/category.dart';
import '../model/basic_models/product.dart';
import '../model/basic_models/store_product.dart';
import '../model/interfaces/model.dart';

const _localizedModelNames = {
  Product: 'Товар',
  StoreProduct: 'Товар у магазині',
  Category: 'Категорія'
};

String makeModelLocalizedName<M extends Model>([Type? modelType]) {
  return _localizedModelNames[modelType ?? M] ?? 'Нелокалізована модель $M';
}
