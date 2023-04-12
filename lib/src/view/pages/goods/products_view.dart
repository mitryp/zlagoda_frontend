import 'package:flutter/material.dart';

import '../../../model/basic_models/product.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

class ProductsView extends ModelCollectionView<Product> {
  const ProductsView({super.key}) : super(searchFilterDelegate: TestSfd.new);
}

// class _ProductsViewState extends State<ProductsView> {
//   final queryBuilder = QueryBuilder(sort: const Sort(field: 'upc', order: Order.asc));
//
//   @override
//   Widget build(BuildContext context) {
//     return WithCollection<Product>(
//       httpService: makeHttpService<Product>(),
//       queryBuilder: queryBuilder,
//       collectionBuilder: (context, {required items, required queryBuilder, required updateSink}) {
//         return CollectionView(
//           items,
//           elementSchema: Product.schema,
//           onAddPressed: () {},
//           updateSink: updateSink,
//           searchFilterDelegate: TestSfd(updateSink: updateSink),
//         );
//       },
//     );
//   }
// }

class TestSfd extends CollectionSearchFilterDelegate {
  const TestSfd({required super.updateSink});

  @override
  List<Widget> buildFilters(BuildContext context) {
    // TODO: implement buildFilters
    return [];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    // TODO: implement buildSearches
    return [];
  }

  @override
  Widget buildSort(BuildContext context) {
    // TODO: implement buildSort
    return const SizedBox();
  }

}
