import '../../typedefs.dart';
import '../basic_models/category.dart';
import '../basic_models/product.dart';
import '../basic_models/store_product.dart';
import '../interfaces/serializable.dart';

class JoinedStoreProduct implements Serializable {
  final StoreProduct storeProduct;
  final Product product;
  final Category category;

  const JoinedStoreProduct(this.storeProduct, this.product, this.category);

  static JoinedStoreProduct? fromJson(JsonMap json) {
    final storeProduct = StoreProduct.schema.fromJson(json);
    final product = Product.schema.fromJson(json);
    final category = Category.schema.fromJson(json);

    if ([storeProduct, product, category].contains(null)) return null;

    return JoinedStoreProduct(storeProduct!, product!, category!);
  }

  @override
  JsonMap toJson() => {
        ...StoreProduct.schema.toJson(storeProduct),
        ...Product.schema.toJson(product),
        ...Category.schema.toJson(category)
      };
}
