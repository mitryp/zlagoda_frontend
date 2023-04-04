/// Author: Verkhohliad Kateryna
class Filter {
  final String field;
  final String value;

  const Filter({required this.field, required this.value});
}

/// Author: Verkhohliad Kateryna
enum Order { asc, desc }

/// Author: Verkhohliad Kateryna
class Sort {
  final String field;
  final Order order;

  const Sort({required this.field, required this.order});
}

/// Author: Verkhohliad Kateryna
class QueryBuilder {
  int _paginationLimit = 10;
  int _paginationOffset = 1;
  final List<Filter> _filters = [];
  Sort _sort;

  QueryBuilder({required sort}): _sort = sort;

  set paginationLimit(int limit) => _paginationLimit = limit;

  set paginationOffset(int offset) => _paginationOffset = offset;

  set sort(Sort sort) => _sort = sort;

  addFilter(Filter filter) => _filters.add(filter);

  removeFilter(Filter filter) => _filters.remove(filter);

  Map<String, String> getQueryParams() {
    var queryParams = {
      'sortBy': _sort.field,
      'order': _sort.order.toString(),
      'limit': _paginationLimit.toString(),
      'offset': _paginationOffset.toString(),
    };

    for (var filter in _filters) {
      queryParams[filter.field] = '_${filter.value}';
    }

    return queryParams;
  }
}
