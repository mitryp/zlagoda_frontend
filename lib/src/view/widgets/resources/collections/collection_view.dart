import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../model/model_scheme_factory.dart';
import '../../../../model/schema/schema.dart';
import '../../../../services/http/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/filter.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../pages/page_base.dart';

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

class CollectionView<R extends ConvertibleToRow<R>> extends StatefulWidget {
  final VoidCallback onAddPressed;
  final QueryBuilder queryBuilder;
  final CsfDelegateConstructor searchFilterDelegate;

  const CollectionView({
    required this.searchFilterDelegate,
    required this.onAddPressed,
    required this.queryBuilder,
    super.key,
  });

  @override
  State<CollectionView<R>> createState() => _CollectionViewState<R>();
}

class _CollectionViewState<R extends ConvertibleToRow<R>> extends State<CollectionView<R>> {
  late final ModelHttpService<R> httpService = makeHttpService<R>();
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
          CollectionTable(
            itemsSupplier: () => httpService.get(widget.queryBuilder),
            updateStream: updateStreamController.stream,
          ),
        ],
      ),
      floatingActionButton: buildAddButton(),
    );
  }

  Widget buildSearchFilters() {
    const divider = VerticalDivider();

    return Card(
      child: Row(
        children: [
          ...searchFilterDelegate.buildSearches(context),
          divider,
          ...searchFilterDelegate.buildFilters(context),
          divider,
          searchFilterDelegate.buildSort(context)
        ],
      ),
    );
  }

  Widget buildAddButton() => ElevatedButton(
        onPressed: widget.onAddPressed,
        child: const Text('Додати'),
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

  late final List<String> columnNames =
      schema.fields.where((r) => r.isShownInTable).map((r) => r.labelCaption).toList();

  Schema<R> get schema => makeModelSchema<R>();

  @override
  void initState() {
    super.initState();
    updateSubscription = widget.updateStream.listen((_) => loadItems());
    loadItems();
  }

  @override
  void dispose() {
    updateSubscription.cancel();
    super.dispose();
  }

  Future<void> loadItems() {
    setState(() {
      isLoaded = false;
      error = null;
    });

    return widget.itemsSupplier().then(
      (items) {
        if (mounted) {
          setState(() {
            this.items = items;
            isLoaded = true;
          });
        }
      },
    ).catchError((err) {
      if (mounted) {
        setState(() => error = err);
      }
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
      rows: items.map((m) => m.buildRow(context)).toList(),
    );
  }
}
