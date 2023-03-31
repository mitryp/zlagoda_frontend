import 'package:flutter/material.dart';

import 'pages/goods/goods_tab_view.dart';

enum AppPage {
  goods(Icons.list, label: 'Goods'),
  receipts(Icons.receipt_long, label: 'Receipts'),
  clients(Icons.group, label: 'Clients'),
  employees(Icons.person, label: 'Employees'),
  me(Icons.account_circle, label: 'Me');

  const AppPage(this.iconData, {required this.label});

  String get route => '/app/$name';

  WidgetBuilder get widget => pagesToWidgets[this]!;

  final IconData iconData;
  final String label;
}

final pagesToWidgets = <AppPage, WidgetBuilder>{
  AppPage.goods: (_) => GoodsTabView(),
  AppPage.receipts: (_) => Text('receipts'),
  AppPage.clients: (_) => Text('clients'),
  AppPage.employees: (_) => Text('employees'),
  AppPage.me: (_) => Text('me'),
};
