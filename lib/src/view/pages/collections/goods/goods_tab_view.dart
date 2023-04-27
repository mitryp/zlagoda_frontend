import 'package:flutter/material.dart';

import '../../../../model/basic_models/employee.dart';
import '../../../widgets/auth/user_manager.dart';
import 'categories_view.dart';
import 'products_view.dart';
import 'store_products_view.dart';

Widget buildProductsView(BuildContext context) => const ProductsView();

Widget buildStoreProductsView(BuildContext context) => const StoreProductsView();

Widget buildCategoriesView(BuildContext context) => const CategoriesView();

enum GoodsTab {
  products('Товари', builder: buildProductsView),
  storeProducts('Товари в магазині', builder: buildStoreProductsView),
  categories(
    'Категорії',
    builder: buildCategoriesView,
    requiredPositionPermissions: Position.manager,
  );

  final String tabName;
  final WidgetBuilder builder;
  final Position requiredPositionPermissions;

  const GoodsTab(
    this.tabName, {
    required this.builder,
    this.requiredPositionPermissions = Position.cashier,
  });
}

class GoodsTabView extends StatefulWidget {
  const GoodsTabView({super.key});

  @override
  State<GoodsTabView> createState() => _GoodsTabViewState();
}

class _GoodsTabViewState extends State<GoodsTabView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final userManager = UserManager.of(context);
  late final tabController = TabController(
      length: GoodsTab.values.where(currentUserHasPermissionToView).length, vsync: this);

  GoodsTab get currentTab => GoodsTab.values[tabController.index];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: .5,
            child: TabBar(
              onTap: (index) => setState(() {}),
              controller: tabController,
              padding: const EdgeInsets.only(top: 5),
              tabs: buildTabs(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TabBarView(
              controller: tabController,
              children: GoodsTab.values
                  .where(currentUserHasPermissionToView)
                  .map((e) => e.builder(context))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildTabs() =>
      GoodsTab.values.where(currentUserHasPermissionToView).map(buildTab).toList();

  bool currentUserHasPermissionToView(GoodsTab tab) =>
      userManager.hasPositionPermissions(tab.requiredPositionPermissions);

  Widget buildTab(GoodsTab tab) {
    final background = Theme.of(context).colorScheme.background;

    return Container(
      height: 35,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(offset: const Offset(0, -3), blurRadius: 4, color: Colors.black.withOpacity(.1))
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        color: tab == currentTab ? background : Colors.white,
      ),
      child: Center(child: Text(tab.tabName)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
