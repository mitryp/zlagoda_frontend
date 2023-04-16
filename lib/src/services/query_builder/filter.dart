import '../../model/basic_models/employee.dart';

class Filter<T> {
  late final String fieldName;
  final T value;

  Filter(FilterField<T> field, this.value) {
    fieldName = field.name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filter &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName;

  @override
  int get hashCode => fieldName.hashCode ^ value.hashCode;
}

enum FilterField<T> {
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
