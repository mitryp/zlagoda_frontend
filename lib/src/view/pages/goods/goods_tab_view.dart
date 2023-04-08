import 'package:flutter/material.dart';

import '../../../model/basic_models/product.dart';
import '../../../model/basic_models/store_product.dart';
import '../../../services/http/http_service_factory.dart';
import '../../widgets/resources/collections/model_collection_view.dart';
import '../../widgets/resources/models/model_view.dart';

class GoodsTabView extends StatefulWidget {
  const GoodsTabView({super.key});

  @override
  State<GoodsTabView> createState() => _GoodsTabViewState();
}

class _GoodsTabViewState extends State<GoodsTabView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: .5,
              child: TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'Товари'),
                  Tab(text: 'Типи'),
                  Tab(text: 'Категорії'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TabBarView(
                children: [
                  buildTest(),
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
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildTest() {
    // return const ModelCollectionView<Product>(
    //   columnNames: ['1', '2', '3'],
    // );

    return ModelView(
      fetchFunction: () => makeHttpService<Product>().singleById('123456789').then((v) => v!),
    );
  }
}
