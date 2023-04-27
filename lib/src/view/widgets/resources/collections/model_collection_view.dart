import 'package:flutter/material.dart';

import '../../../../model/interfaces/convertible_to_pdf.dart';
import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../model/model_schema_factory.dart';
import '../../../../model/schema/schema.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../../utils/value_status.dart';
import '../../auth/authorizer.dart';
import 'collection_view.dart';

typedef RedirectCallbackWithValueStatus = Future<ValueStatusWrapper> Function(
    BuildContext);

abstract class ModelCollectionView<SCol extends ConvertibleToRow<SCol>,
    CTPdf extends ConvertibleToPdf<CTPdf>> extends StatefulWidget {
  final CsfDelegateConstructor searchFilterDelegate;
  final SortOption defaultSortField;
  final RedirectCallbackWithValueStatus onAddPressed;
  final UserAuthorizationStrategy authorizationStrategy;

  const ModelCollectionView({
    required this.defaultSortField,
    required this.searchFilterDelegate,
    required this.onAddPressed,
    this.authorizationStrategy = hasUser,
    super.key,
  });

  @override
  State<ModelCollectionView<SCol, CTPdf>> createState() =>
      _ModelCollectionViewState<SCol, CTPdf>();
}

class _ModelCollectionViewState<SCol extends ConvertibleToRow<SCol>, CTPdf extends ConvertibleToPdf<CTPdf>>
    extends State<ModelCollectionView<SCol, CTPdf>> {
  late final queryBuilder = QueryBuilder(sort: Sort(widget.defaultSortField));

  Schema<SCol> get elementSchema => makeModelSchema<SCol>();

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      authorizationStrategy: widget.authorizationStrategy,
      child: CollectionView<SCol, CTPdf>(
        searchFilterDelegate: widget.searchFilterDelegate,
        onAddPressed: widget.onAddPressed,
        queryBuilder: queryBuilder,
      ),
    );
  }
}
