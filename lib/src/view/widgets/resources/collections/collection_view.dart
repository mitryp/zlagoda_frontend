import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../services/http/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/filter.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../../utils/value_status.dart';
import '../../../pages/page_base.dart';
import '../../utils/helping_functions.dart';
import 'model_collection_view.dart';

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
  void initState() {
    super.initState();
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

  Widget buildAddButton() => ElevatedButton.icon(
        icon: const Icon(Icons.add),
        onPressed: () => widget.onAddPressed(context).then((v) {
          if (v.status != ValueChangeStatus.notChanged) fetchItems();
        }),
        label: const Text('Створити'),
      );
}

class CollectionTable<R extends ConvertibleToRow<R>> extends StatefulWidget {
  final Future<List<R>> Function() itemsSupplier;
  final Stream<void> updateStream;

  const CollectionTable({required this.itemsSupplier, required this.updateStream, super.key});

  @override
  State<CollectionTable<R>> createState() => _CollectionTableState<R>();
}

class _CollectionTableState<R extends ConvertibleToRow<R>> extends State<CollectionTable<R>> {
  late final StreamSubscription<void> updateSubscription;
  late List<R> items;
  bool isLoaded = false;
  Object? error;

  late final List<String> columnNames = columnNamesOf<R>();

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
      (items) {
        if (!mounted) return;
        setState(() {
          this.items = items;
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

    return DataTable(
      showCheckboxColumn: false,
      columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: items.map((m) => m.buildRow(context, _updateCallback)).toList(),
    );
  }

  void _updateCallback(ValueChangeStatus updatedStatus) {
    if (updatedStatus == ValueChangeStatus.notChanged) return;
    fetchItems();
  }
}
