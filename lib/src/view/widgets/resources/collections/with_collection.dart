import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/interfaces/serializable.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/query_builder.dart';

typedef CollectionBuilder<S extends Serializable> = Widget Function(
  BuildContext context, {
  required List<S> items,
  required EventSink<void> updateSink,
  required QueryBuilder queryBuilder,
});

class WithCollection<S extends Serializable> extends StatefulWidget {
  final CollectionBuilder<S> collectionBuilder;
  final ModelHttpService<S> httpService;

  // TODO is it ok with qb?
  final QueryBuilder queryBuilder;

  const WithCollection({
    required this.httpService,
    required this.queryBuilder,
    required this.collectionBuilder,
    super.key,
  });

  @override
  State<WithCollection<S>> createState() => WithCollectionState();
}

class WithCollectionState<M extends Serializable> extends State<WithCollection<M>> {
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

    widget.httpService.get(widget.queryBuilder).then((models) {
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
      return const Center(child: CircularProgressIndicator());
    }

    return widget.collectionBuilder(
      context,
      items: items,
      updateSink: streamController.sink,
      queryBuilder: widget.queryBuilder,
    );
  }
}
