import 'package:flutter/material.dart';

class GoodsTabView extends StatefulWidget {
  const GoodsTabView({super.key});

  @override
  State<GoodsTabView> createState() => _GoodsTabViewState();
}

class _GoodsTabViewState extends State<GoodsTabView> with AutomaticKeepAliveClientMixin {
  // Navigator.of(context).pushNamed(AppPage.receipts.route);



  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: const [
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: .5,
              child: TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'Товари'),
                  Tab(text: 'Типи'),
                  Tab(text: 'Categories'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                const Placeholder(color: Colors.red),
                const Placeholder(color: Colors.green),
                const Placeholder(color: Colors.blue),

                // todo
                // WidgetWithCollection(
                //     httpService: httpService,
                //     builder: (context, items, updateSink) {
                //       return CollectionView(
                //         items,
                //         updateSink: updateSink,
                //         searchFilterDelegate: searchFilterDelegate,
                //         onAddPressed: () {},
                //       );
                //     },
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
