import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../services/http/model_http_service.dart';
import '../../../../services/query_builder/query_builder.dart';

typedef CollectionBuilder<M extends Model> = Widget Function(
  BuildContext context, {
  required List<M> items,
  required EventSink<void> updateSink,
  required QueryBuilder queryBuilder,
});

class WithCollection<M extends Model> extends StatefulWidget {
  final CollectionBuilder<M> collectionBuilder;
  final ModelHttpService<M> httpService;

  // TODO is it ok with qb?
  final QueryBuilder queryBuilder;

  const WithCollection({
    required this.httpService,
    required this.collectionBuilder,
    required this.queryBuilder,
    super.key,
  });

  @override
  State<WithCollection<M>> createState() => WithCollectionState();
}

class WithCollectionState<M extends Model> extends State<WithCollection<M>> {
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
