import '../../model/basic_models/employee.dart';
import 'filter.dart';
import 'sort.dart';

class QueryBuilder {
  int paginationLimit = 10;
  int paginationPage = 1;
  final Set<Filter> _filters = {};
  Sort sort;

  QueryBuilder({required this.sort});

  void addFilter(Filter filter) {
    _filters.remove(filter);
    _filters.add(filter);
  }

  bool removeFilter(FilterOption filterField) => _filters.remove(Filter(filterField, ''));

  Set<Filter> get filters => _filters;

  Map<String, dynamic> get queryParams {
    var queryParams = {
      'sortBy': sort.sortField,
      'order': sort.order.name,
      'limit': '$paginationLimit',
    };

    if(paginationLimit != 0)
      queryParams['offset'] = '${paginationPage * paginationLimit}';

    for (var filter in _filters) {
      var value = filter.value;

      if (filter.value is DateTime) value = value.millisecondsSinceEpoch / 1000;
      if (filter.value is Position) value = value.name;

      queryParams['${filter.fieldName}Filter'] = '$value';
    }

    return queryParams;
  }

  // Map<String, dynamic> get queryParams {
  //   var queryParams = {
  //     '_sort': sort.sortField,
  //     '_order': sort.order.name,
  //     '_limit': '$paginationLimit',
  //     '_page': '$paginationPage',
  //   };
  //
  //   for (var filter in _filters) {
  //     var value = filter.value;
  //
  //     if (filter.value is DateTime) value = value.millisecondsSinceEpoch / 1000;
  //     if (filter.value is Position) value = value.name;
  //
  //     queryParams[filter.fieldName] = '$value';
  //   }
  //
  //   return queryParams;
  // }
}
