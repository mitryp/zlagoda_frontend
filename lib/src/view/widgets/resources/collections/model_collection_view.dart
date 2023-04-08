import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../model/interfaces/model.dart';
import '../../../../services/http/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/query_builder.dart';
import 'collection_view.dart';
import 'with_collection.dart';

class ModelCollectionView<M extends ConvertibleToRow> extends StatelessWidget {
  final List<String> columnNames;

  const ModelCollectionView({required this.columnNames, super.key});

  ModelHttpService<M> get httpService => makeHttpService<M>();

  @override
  Widget build(BuildContext context) {
    return WithCollection<M>(
      httpService: httpService,
      queryBuilder: QueryBuilder(sort: const Sort(field: 'name', order: Order.asc)),
      collectionBuilder: buildCollection,
    );
  }

  Widget buildCollection(
    BuildContext context, {
    required List<M> items,
    required QueryBuilder queryBuilder,
    required EventSink<void> updateSink,
  }) {
    return CollectionView<M>(
      items,
      columnNames: columnNames,
      updateSink: updateSink,
      searchFilterDelegate: CSFDelegate(updateSink: updateSink),
      onAddPressed: () {},
    );
  }
}

class CSFDelegate extends CollectionSearchFilterDelegate {
  const CSFDelegate({required super.updateSink});

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
