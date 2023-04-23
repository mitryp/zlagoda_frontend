import 'package:flutter/material.dart';

import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../model/interfaces/serializable.dart';
import '../../../../model/model_schema_factory.dart';
import '../../../../model/schema/schema.dart';
import '../../../../services/http/http_service_factory.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import 'collection_view.dart';

abstract class ModelCollectionView<SCol extends ConvertibleToRow<SCol>> extends StatefulWidget {
  final CsfDelegateConstructor searchFilterDelegate;
  final SortOption defaultSortField;
  final VoidCallback onAddPressed;

  const ModelCollectionView({
    required this.defaultSortField,
    required this.searchFilterDelegate,
    required this.onAddPressed,
    super.key,
  });

  @override
  State<ModelCollectionView<SCol>> createState() => _ModelCollectionViewState<SCol>();
}

class _ModelCollectionViewState<SCol extends ConvertibleToRow<SCol>>
    extends State<ModelCollectionView<SCol>> {
  late final queryBuilder = QueryBuilder(sort: Sort(widget.defaultSortField));

  Schema<SCol> get elementSchema => makeModelSchema<SCol>();

  @override
  Widget build(BuildContext context) {
    return CollectionView<SCol>(
      searchFilterDelegate: widget.searchFilterDelegate,
      onAddPressed: widget.onAddPressed,
      queryBuilder: queryBuilder,
    );
  }
}

class CSFDelegate extends CollectionSearchFilterDelegate {
  const CSFDelegate({
    required super.queryBuilder,
    required super.updateCallback,
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
