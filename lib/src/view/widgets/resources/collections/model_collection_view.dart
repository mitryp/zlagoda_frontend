import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../model/model_scheme_factory.dart';
import '../../../../model/schema/schema.dart';
import '../../../../services/http/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import 'collection_view.dart';
import 'with_collection.dart';

typedef CsfDelegateConstructor = CollectionSearchFilterDelegate Function({
  required QueryBuilder queryBuilder,
  required EventSink<void> updateSink,
});

abstract class ModelCollectionView<R extends ConvertibleToRow<R>> extends StatefulWidget {
  final CsfDelegateConstructor searchFilterDelegate;
  final SortField defaultSortField;

  const ModelCollectionView({
    required this.defaultSortField,
    required this.searchFilterDelegate,
    super.key,
  });

  @override
  State<ModelCollectionView<R>> createState() => _ModelCollectionViewState<R>();
}

class _ModelCollectionViewState<R extends ConvertibleToRow<R>>
    extends State<ModelCollectionView<R>> {
  late final queryBuilder = QueryBuilder(sort: Sort(widget.defaultSortField));

  ModelHttpService<R> get httpService => makeHttpService<R>();

  Schema<R> get elementSchema => makeModelSchema<R>();

  @override
  Widget build(BuildContext context) {
    return WithCollection<R>(
      httpService: httpService,
      queryBuilder: queryBuilder,
      collectionBuilder: buildCollection,
    );
  }

  Widget buildCollection(
    BuildContext context, {
    required List<R> items,
    required QueryBuilder queryBuilder,
    required EventSink<void> updateSink,
  }) {
    return CollectionView<R>(
      items,
      elementSchema: elementSchema,
      updateSink: updateSink,
      searchFilterDelegate: widget.searchFilterDelegate(
        queryBuilder: queryBuilder,
        updateSink: updateSink,
      ),
      onAddPressed: () {},
    );
  }
}

class CSFDelegate extends CollectionSearchFilterDelegate {
  const CSFDelegate({
    required QueryBuilder queryBuilder,
    required super.updateSink,
  });

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
    throw const SizedBox();
  }
}
