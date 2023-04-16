enum Order { asc, desc }

class Sort {
  late final String fieldName;
  late final Order order;

  Sort(SortField field, [Order? order]) {
    fieldName = field.name;
    this.order = order ?? field.order;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Sort &&
              runtimeType == other.runtimeType &&
              fieldName == other.fieldName;

  @override
  int get hashCode => fieldName.hashCode ^ order.hashCode;
}

enum SortField {
  employeeName(Order.asc),
  clientName(Order.asc),
  categoryName(Order.asc),
  productName(Order.asc),
  storeProductName(Order.asc),
  quantity(Order.desc),
  date(Order.desc);

  final Order order;

  const SortField(this.order);
}
