import 'package:flutter/material.dart';

import 'products_view.dart';

Widget buildProductsView(BuildContext context) => const ProductsView();

enum GoodsTab {
  products('Товари', builder: buildProductsView),
  storeProducts('Товари в магазині', builder: buildProductsView),
  categories('Категорії', builder: buildProductsView);

  final String tabName;
  final WidgetBuilder builder;

  const GoodsTab(this.tabName, {required this.builder});
}

class GoodsTabView extends StatefulWidget {
  const GoodsTabView({super.key});

  @override
  State<GoodsTabView> createState() => _GoodsTabViewState();
}

class _GoodsTabViewState extends State<GoodsTabView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final tabController = TabController(length: 3, vsync: this);

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
              children: GoodsTab.values.map((e) => e.builder(context)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildTabs() => GoodsTab.values.map(buildTab).toList();

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
