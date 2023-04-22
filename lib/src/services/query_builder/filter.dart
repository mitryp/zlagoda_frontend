import '../../model/basic_models/employee.dart';

class Filter<T> {
  final FilterOption<T> filterOption;
  final T value;

  const Filter(this.filterOption, this.value);

  String get fieldName => filterOption.name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filter &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName;

  @override
  int get hashCode => fieldName.hashCode;
}

enum FilterOption<T> {
  dateMin<DateTime>(),
  dateMax<DateTime>(),
  employeeName<String>(),
  position<Position>(),
  clientName<String>(),
  discount<int>(),
  categoryName<String>(),
  productName<String>(),
  isProm<bool>(),
  upc<String>();
}
