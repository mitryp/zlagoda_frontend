import 'package:flutter/material.dart';

import '../model/basic_models/employee.dart';
import '../special_queries.dart';
import 'pages/collections/clients_view.dart';
import 'pages/collections/employees_view.dart';
import 'pages/collections/goods/goods_tab_view.dart';
import 'pages/collections/receipts_view.dart';
import 'pages/special_queries_page.dart';

enum AppPage {
  goods(Icons.list, label: 'Товари'),
  receipts(Icons.receipt_long, label: 'Чеки'),
  clients(Icons.group, label: 'Клієнти'),
  employees(Icons.person, label: 'Працівники'),
  stats(Icons.query_stats, label: 'Статистика');

  final IconData iconData;
  final String label;
  final Position requiredPosition;

  const AppPage(this.iconData, {required this.label, this.requiredPosition = Position.cashier});

  String get route => '/app/$name';

  WidgetBuilder get widget => pagesToWidgets[this]!;
}

final pagesToWidgets = <AppPage, WidgetBuilder>{
  AppPage.goods: (_) => const GoodsTabView(),
  AppPage.receipts: (_) => const ReceiptsView(),
  AppPage.clients: (_) => const ClientsView(),
  AppPage.employees: (_) => const EmployeesView(),
  AppPage.stats: (_) => const SpecialQueriesPage([
        RegularClients(),
        ReceiptsWithAllCategories(),
        ProductsSoldByAllCashiers(),
        BestCashiers(),
        SoldFor(),
        PurchasedByAllClients(),
      ])
};
