import 'package:flutter/material.dart';

import '../../../model/basic_models/receipt.dart';
import '../../../model/common_models/name.dart';
import '../../../model/joined_models/joined_sale.dart';
import '../../../model/other_models/table_receipt.dart';
import '../../../model/search_models/short_cashier.dart';
import '../../../services/query_builder/filter.dart';
import '../../../services/query_builder/sort.dart';
import '../../../utils/value_status.dart';
import '../../widgets/queries/connected_model_filter.dart';
import '../../widgets/queries/filters/date_filter.dart';
import '../../widgets/queries/sort_block.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';
import '../../widgets/resources/receipt_model_view.dart';

Future<ValueStatusWrapper<Receipt>> _redirectToReceiptCreation(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return ReceiptModelView(
        fetchFunction: () async => Receipt(
          receiptId: 1,
          cost: 20000,
          employeeName: const Name(firstName: "Ім'я", lastName: 'Прізвище'),
          date: DateTime.now(),
          tax: 1000,
          employeeId: '1',
          sales: [
            const JoinedSale(
              storeProductId: 1,
              price: 100,
              quantity: 2,
              productName: 'Product name',
              upc: '0000000000',
              isProm: false,
            ),
          ],
        ),
      );
    },
  ));

  // todo
  return Future.value(ValueStatusWrapper.notChanged());
  // return Navigator.of(context)
  // .push<ValueStatusWrapper<Receipt>>(MaterialPageRoute(
  // builder: (context) => ReceiptModelView(fetchFunction: ),
  // ))
  //     .then((wr) => wr ?? ValueStatusWrapper<SSingle>.notChanged());

  // return AppNavigation.of(context).openModelCreation<Receipt>();
}

class ReceiptsView extends ModelCollectionView<TableReceipt> {
  const ReceiptsView({super.key})
      : super(
          defaultSortField: SortOption.date,
          searchFilterDelegate: ReceiptsSearchFilters.new,
          onAddPressed: _redirectToReceiptCreation,
        );
}

class ReceiptsSearchFilters extends CollectionSearchFilterDelegate {
  const ReceiptsSearchFilters({
    required super.queryBuilder,
    required super.updateCallback,
  });

  @override
  List<Widget> buildFilters(BuildContext context) {
    return [
      DateFilter(
        addFilter: addFilter,
        removeFilter: removeFilter,
      ),
      ConnectedModelFilter<String, ShortCashier>(
        filterOption: FilterOption.employeeId,
        addFilter: addFilter,
        removeFilterByOption: removeFilter,
        caption: 'Всі касири',
        searchHint: 'Пошук касирів за табельним номером або ПІБ...',
      ),
    ];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    return [];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.date,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}
