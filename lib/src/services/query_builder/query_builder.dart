import '../../model/basic_models/employee.dart';
import 'filter.dart';
import 'sort.dart';

class QueryBuilder {
  int _paginationLimit = 10;
  int _paginationPage = 0;
  final List<Filter> _filters = [];
  Sort _sort;

  QueryBuilder({required Sort sort}): _sort = sort;

  set paginationLimit(int limit) => _paginationLimit = limit;

  set paginationPage(int offset) => _paginationPage = offset;

  set sort(Sort sort) => _sort = sort;

  void addFilter(Filter filter) => _filters.add(filter);

  bool removeFilter(FilterField filterField) => _filters.remove(Filter(filterField, ''));

  Map<String, dynamic> get queryParams {
    var queryParams = {
      'sortBy': _sort.fieldName,
      'order': _sort.order.name,
      'limit': _paginationLimit,
      'offset': _paginationPage * _paginationLimit,
    };

    for (var filter in _filters) {
      var value = filter.value;

      if (filter.value is DateTime) value = value.millisecondsSinceEpoch / 1000;
      if (filter.value is Position) value = value.name;

      queryParams['${filter.fieldName}Filter'] = value;
    }

    return queryParams;
  }
}
