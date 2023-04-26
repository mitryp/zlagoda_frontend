import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/basic_models/employee.dart';
import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../model/other_models/table_receipt.dart';
import '../../../../services/http/helpers/collection_slice_wrapper.dart';
import '../../../../services/http/helpers/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/filter.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../../utils/value_status.dart';
import '../../../pages/page_base.dart';
import '../../permissions/authorizer.dart';
import '../../utils/helping_functions.dart';
import 'model_collection_view.dart';

const itemsPerPage = 5;

abstract class CollectionSearchFilterDelegate {
  final VoidCallback updateCallback;
  final QueryBuilder queryBuilder;

  const CollectionSearchFilterDelegate({
    required this.updateCallback,
    required this.queryBuilder,
  });

  void updateSort(Sort sort) {
    queryBuilder.sort = sort;
    updateCallback();
  }

  void addFilter(Filter filter) {
    queryBuilder.addFilter(filter);
    updateCallback();
  }

  void removeFilter(FilterOption filterOption) {
    queryBuilder.removeFilter(filterOption);
    updateCallback();
  }

  List<Widget> buildSearches(BuildContext context);

  List<Widget> buildFilters(BuildContext context);

  Widget buildSort(BuildContext context);

  String subRoute(BuildContext context) => '';
}

typedef CsfDelegateConstructor = CollectionSearchFilterDelegate Function({
  required QueryBuilder queryBuilder,
  required VoidCallback updateCallback,
});

/*
  CollectionView:
    -> filters/sorting/search
    -> table, which can be updated by the filters
    -> add button
 */

class CollectionView<SCol extends ConvertibleToRow<SCol>> extends StatefulWidget {
  final RedirectCallbackWithValueStatus onAddPressed;
  final QueryBuilder queryBuilder;
  final CsfDelegateConstructor searchFilterDelegate;

  const CollectionView({
    required this.searchFilterDelegate,
    required this.onAddPressed,
    required this.queryBuilder,
    super.key,
  });

  @override
  State<CollectionView<SCol>> createState() => _CollectionViewState<SCol>();
}

class _CollectionViewState<SCol extends ConvertibleToRow<SCol>> extends State<CollectionView<SCol>>
    with RouteAware {
  late final ModelHttpService<SCol, dynamic> httpService =
      makeModelHttpService<SCol>() as ModelHttpService<SCol, dynamic>;

  late CollectionSearchFilterDelegate searchFilterDelegate = widget.searchFilterDelegate(
    queryBuilder: widget.queryBuilder,
    updateCallback: fetchItems,
  );
  late final StreamController<void> updateStreamController = StreamController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.queryBuilder
      ..paginationLimit = itemsPerPage
      ..subRoute = searchFilterDelegate.subRoute(context);
    fetchItems();
  }

  void fetchItems() => updateStreamController.sink.add(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBase.column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSearchFilters(),
          CollectionTable<SCol>(
            itemsSupplier: () => httpService.get(widget.queryBuilder),
            updateStream: updateStreamController.stream,
            queryBuilder: widget.queryBuilder,
          ),
        ],
      ),
      floatingActionButton: buildAddButton(),
    );
  }

  Widget buildSearchFilters() {
    const horizontalPadding = 16.0;

    const divider = SizedBox(
      height: 25,
      child: VerticalDivider(
        color: Colors.grey,
        thickness: 1,
        width: horizontalPadding * 2,
      ),
    );

    final sort = searchFilterDelegate.buildSort(context);
    final filters = searchFilterDelegate.buildFilters(context);
    final searches = searchFilterDelegate.buildSearches(context);

    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: horizontalPadding),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          sort,
          filters.isEmpty ? const SizedBox() : divider,
          ...makeSeparated(filters),
          searches.isEmpty ? const SizedBox() : divider,
          ...makeSeparated(searches),
        ],
      ),
    ));
  }

  Widget buildAddButton() {
    final authStrategy =
        SCol == TableReceipt ? hasPosition(Position.cashier) : hasPosition(Position.manager);

    return Authorizer.emptyUnauthorized(
      authorizationStrategy: authStrategy,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        onPressed: () => widget.onAddPressed(context).then(
          (v) {
            if (v.status != ValueChangeStatus.notChanged) fetchItems();
          },
        ),
        label: const Text('Створити'),
      ),
    );
  }
}

class CollectionTable<R extends ConvertibleToRow<R>> extends StatefulWidget {
  final Future<CollectionSliceWrapper<R>> Function() itemsSupplier;
  final Stream<void> updateStream;
  final QueryBuilder queryBuilder;

  const CollectionTable({
    required this.itemsSupplier,
    required this.updateStream,
    required this.queryBuilder,
    super.key,
  });

  @override
  State<CollectionTable<R>> createState() => _CollectionTableState<R>();
}

class _CollectionTableState<R extends ConvertibleToRow<R>> extends State<CollectionTable<R>> {
  late final StreamSubscription<void> updateSubscription;
  late List<R> items;
  late int totalCount;
  bool isLoaded = false;
  Object? error;

  @override
  void initState() {
    super.initState();
    updateSubscription = widget.updateStream.listen((_) => fetchItems());
    fetchItems();
  }

  @override
  void dispose() {
    updateSubscription.cancel();
    super.dispose();
  }

  Future<void> fetchItems() {
    setState(() {
      isLoaded = false;
      error = null;
    });

    return widget.itemsSupplier().then(
      (collectionSlice) {
        if (!mounted) return;

        setState(() {
          this.items = collectionSlice.items;
          this.totalCount = collectionSlice.totalCount;

          isLoaded = true;
        });
      },
    ).catchError((err) {
      if (!mounted) return;
      setState(() => error = err);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: Text('Помилка при завантаженні колекції: $error'),
      );
    }

    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final limit = widget.queryBuilder.paginationLimit;
    final offset = widget.queryBuilder.paginationOffset;

    return IntrinsicWidth(
      child: Column(
        children: [
          DataTable(
            showCheckboxColumn: false,
            columns: columnsOf<R>(),
            rows: items.map((e) => e.buildRow(context, _updateCallback)).toList(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    if (offset == 0) return;
                    widget.queryBuilder.paginationOffset = offset - limit;
                    fetchItems();
                  },
                  icon: const Icon(Icons.arrow_left),
                  splashRadius: 20,
                ),
                Text(
                  '${offset ~/ limit + 1} '
                  '/ ${(totalCount / limit + .4).round()}',
                ),
                IconButton(
                  onPressed: () {
                    if (offset >= totalCount - limit) return;
                    widget.queryBuilder.paginationOffset = offset + limit;
                    fetchItems();
                  },
                  icon: const Icon(Icons.arrow_right),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return PaginatedDataTable(
    //   showCheckboxColumn: false,
    //   columns: columnsOf<R>(),
    //   //rows: items.map((m) => m.buildRow(context, _updateCallback)).toList(),
    //   source: CollectionViewSource(
    //     context: context,
    //     totalCount: totalCount,
    //     items: items,
    //     fetchItems: fetchItems,
    //   ),
    //   rowsPerPage: min(itemsPerPage, items.length),
    //   // onPageChanged: (value) {
    //   // setState(() => widget.queryBuilder.paginationOffset = value);
    //   // fetchItems();
    //   // },
    // );
  }

  void _updateCallback(ValueChangeStatus updatedStatus) {
    if (updatedStatus == ValueChangeStatus.notChanged) return;
    fetchItems();
  }
}

class CollectionViewSource<R extends ConvertibleToRow<R>> extends DataTableSource {
  final BuildContext context;
  final List<R> items;
  final int totalCount;
  final Future<void> Function() fetchItems;

  CollectionViewSource({
    required this.context,
    required this.totalCount,
    required this.items,
    required this.fetchItems,
  });

  void _updateCallback(ValueChangeStatus updatedStatus) {
    if (updatedStatus == ValueChangeStatus.notChanged) return;
    fetchItems();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) return null;
    return items[index].buildRow(context, _updateCallback);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalCount;

  @override
  int get selectedRowCount => 0;
}
