import 'dart:collection';

import '../../model/basic_models/employee.dart';
import 'filter.dart';
import 'sort.dart';

class QueryBuilder {
  int paginationLimit = 0;
  int paginationOffset = 0;
  final Set<Filter> _filters = {};
  final Map _otherParams = {};
  Sort sort;
  String subRoute;

  QueryBuilder({required this.sort, this.subRoute = ''});

  void addFilter(Filter filter) {
    _filters.remove(filter);
    _filters.add(filter);
  }

  void removeFilter(FilterOption filterOption) =>
      _filters.removeWhere((e) => e.filterOption == filterOption);

  void addOtherParam(String key, dynamic value) =>
    _otherParams[key] = value;

  Set<Filter> get filters => _filters;

  Map<String, dynamic> get queryParams {
    var queryParams = {
      'sortBy': sort.sortField,
      'order': sort.order.name,
      'limit': '$paginationLimit',
    };

    if (paginationLimit != 0) queryParams['offset'] = '$paginationOffset';

    for (var filter in _filters) {
      var value = filter.value;

      if (value is DateTime) value = value.millisecondsSinceEpoch / 1000;
      if (value is Position) value = value.name;

      queryParams['${filter.fieldName}Filter'] = '$value';
    }

    for (final param in _otherParams.keys)
      queryParams[param] = '${_otherParams[param]}';

    return queryParams;
  }
}
