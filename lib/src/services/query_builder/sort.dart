import 'package:flutter/material.dart';

enum Order {
  asc(Icons.arrow_downward),
  desc(Icons.arrow_upward);

  final IconData icon;

  const Order(this.icon);
}

class Sort {
  late final SortOption sortOption;
  late final Order order;

  Sort(this.sortOption, [Order? order]) {
    this.order = order ?? sortOption.defaultOrder;
  }

  String get sortField => sortOption.name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sort && runtimeType == other.runtimeType && sortField == other.sortField;

  @override
  int get hashCode => sortOption.hashCode ^ order.hashCode;
}

enum SortOption {
  employeeSurname(Order.asc, 'За прізвищем працівника'),
  clientSurname(Order.asc, 'За прізвищем клієнта'),
  categoryName(Order.asc, 'За назвою категорії'),
  productName(Order.asc, 'За назвою товару'),
  quantity(Order.desc, 'За кількістю'),
  date(Order.desc, 'За датою');

  final Order defaultOrder;
  final String caption;

  const SortOption(this.defaultOrder, this.caption);

  String get fieldName => name;
}
