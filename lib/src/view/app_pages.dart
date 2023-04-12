import 'package:flutter/material.dart';

import 'pages/goods/goods_tab_view.dart';

enum AppPage {
  goods(Icons.list, label: 'Товари'),
  receipts(Icons.receipt_long, label: 'Чеки'),
  clients(Icons.group, label: 'Клієнти'),
  employees(Icons.person, label: 'Працівники');

  const AppPage(this.iconData, {required this.label});

  String get route => '/app/$name';

  WidgetBuilder get widget => pagesToWidgets[this]!;

  final IconData iconData;
  final String label;
}

final pagesToWidgets = <AppPage, WidgetBuilder>{
  AppPage.goods: (_) => const GoodsTabView(),
  AppPage.receipts: (_) => Text('receipts'),
  AppPage.clients: (_) => Text('clients'),
  AppPage.employees: (_) => Text('employees'),
};
