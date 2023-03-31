import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/http/http_service.dart';
import '../../services/query_builder/query_builder.dart';
import '../../typedefs.dart';

typedef CollectionBuilder<M extends Model> = Widget Function(
  BuildContext context,
  List<M> items,
  EventSink<void> updateSink,
);

class WidgetWithCollection<M extends Model> extends StatefulWidget {
  final CollectionBuilder builder;
  final HttpService<M> httpService;

  const WidgetWithCollection({
    required this.httpService,
    required this.builder,
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

    widget.httpService.get().then((models) {
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
