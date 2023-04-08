import '../../typedefs.dart';
import '../basic_models/category.dart';
import '../basic_models/product.dart';
import '../interfaces/serializable.dart';

class ProductWithCategory implements Serializable {
  final Product product;
  final Category category;

  const ProductWithCategory(this.product, this.category);

  static ProductWithCategory? fromJson(JsonMap json) {
    final product = Product.schema.fromJson(json);
    final category = Category.schema.fromJson(json);

    if ([product, category].contains(null)) return null;

    return ProductWithCategory(product!, category!);
  }

  @override
  JsonMap toJson() =>
      {...Product.schema.toJson(product), ...Category.schema.toJson(category)};
}
