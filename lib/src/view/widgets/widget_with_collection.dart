import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/interfaces/model.dart';
import '../../services/http/http_service.dart';
import '../../services/query_builder/query_builder.dart';

typedef CollectionBuilder<M extends Model> = Widget Function(
  BuildContext context,
  List<M> items,
  EventSink<void> updateSink,
);

class WidgetWithCollection<M extends Model> extends StatefulWidget {
  final CollectionBuilder builder;
  final HttpService<M> httpService;
  // TODO is it ok with qb?
  final QueryBuilder qb;

  const WidgetWithCollection({
    required this.httpService,
    required this.builder,
    required this.qb,
    super.key,
  });

  @override
  State<WidgetWithCollection<M>> createState() => WidgetWithCollectionState();
}

class WidgetWithCollectionState<M extends Model> extends State<WidgetWithCollection<M>> {
  final StreamController<void> streamController = StreamController();
  late final StreamSubscription<void> updateSubscription;

  bool isLoaded = false;
  late List<M> items;

  void onUpdate(void e) => fetchItems();

  @override
  void initState() {
    super.initState();

    updateSubscription = streamController.stream.listen(onUpdate);
    fetchItems();
  }

  @override
  void dispose() {
    updateSubscription.cancel();
    super.dispose();
  }

  void fetchItems() {
    setState(() => isLoaded = false);

    widget.httpService.get(widget.qb).then((models) {
      if (!mounted) return;
      setState(() {
        items = models;
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return widget.builder(context, items, streamController.sink);
  }
}
