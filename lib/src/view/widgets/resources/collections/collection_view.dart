import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../model/basic_models/receipt.dart';
import '../../../../model/interfaces/convertible_to_pdf.dart';
import '../../../../model/basic_models/employee.dart';
import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../services/http/helpers/collection_slice_wrapper.dart';
import '../../../../services/http/helpers/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/filter.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../../utils/value_status.dart';
import '../../../pages/page_base.dart';
import '../../auth/authorizer.dart';
import '../../reports/open_report_button.dart';
import '../../utils/helping_functions.dart';
import 'model_collection_view.dart';

const itemsPerPage = 8;

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

  Widget? buildStats(BuildContext context, Stream<void> updateStream) => null;
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

class CollectionView<SCol extends ConvertibleToRow<SCol>, CTPdf extends ConvertibleToPdf<CTPdf>>
    extends StatefulWidget {
  final RedirectCallbackWithValueStatus onAddPressed;
  final QueryBuilder queryBuilder;
  late final QueryBuilder initialQB;
  final CsfDelegateConstructor searchFilterDelegate;

  CollectionView({
    required this.searchFilterDelegate,
    required this.onAddPressed,
    required this.queryBuilder,
    super.key,
  }) {
    initialQB = QueryBuilder(sort: queryBuilder.sort);
  }

  @override
  State<CollectionView<SCol, CTPdf>> createState() => _CollectionViewState<SCol, CTPdf>();
}

class _CollectionViewState<SCol extends ConvertibleToRow<SCol>,
        CTPdf extends ConvertibleToPdf<CTPdf>> extends State<CollectionView<SCol, CTPdf>>
    with RouteAware {
  late final ModelHttpService<SCol, dynamic> httpService =
      makeModelHttpService<SCol>() as ModelHttpService<SCol, dynamic>;

  late CollectionSearchFilterDelegate searchFilterDelegate = widget.searchFilterDelegate(
    queryBuilder: widget.queryBuilder,
    updateCallback: fetchItems,
  );
  late final StreamController<void> updateStreamController = StreamController.broadcast();

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
          Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildSearchFilters(),
                ReportButton<CTPdf>(queryBuilder: widget.initialQB),
              ]),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width / 2),
            child: CollectionTable<SCol>(
              itemsSupplier: () => httpService.get(widget.queryBuilder),
              updateStream: updateStreamController.stream,
              queryBuilder: widget.queryBuilder,
            ),
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
    final stats = searchFilterDelegate.buildStats(context, updateStreamController.stream);

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
          stats == null ? const SizedBox() : divider,
          if (stats != null) stats,
        ],
      ),
    ));
  }

  Widget buildAddButton() {
    final authStrategy = SCol == Receipt
        ? hasPosition(Position.cashier)
        : hasPosition(Position.manager);

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
        ));
  }

  Widget buildReportButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ReportButton<CTPdf>(queryBuilder: widget.initialQB),
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

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Text('Записи в системі обліку відсутні.'),
        ),
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
  }

  void _updateCallback(ValueChangeStatus updatedStatus) {
    if (updatedStatus == ValueChangeStatus.notChanged) return;
    fetchItems();
  }
}
