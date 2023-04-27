import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/schema/extractors.dart';
import '../../services/http/helpers/http_service_helper.dart';
import '../../services/query_builder/filter.dart';
import '../../services/query_builder/query_builder.dart';
import '../../typedefs.dart';
import '../../utils/json_decode.dart';

typedef JsonFetchFunction = Future<JsonMap> Function();

class StatsBlock extends StatefulWidget {
  final List<StatsFetcher> fetchers;
  final QueryBuilder? queryBuilder;
  final Stream<void> updateStream;

  const StatsBlock(
    this.fetchers, {
    this.queryBuilder,
    required this.updateStream,
    super.key,
  });

  @override
  State<StatsBlock> createState() => _StatsBlockState();
}

class _StatsBlockState extends State<StatsBlock> {
  late final StreamSubscription<void> updateSubscription;
  late final Iterable<String> presentations;
  bool isLoaded = false;
  Object? error;

  @override
  void initState() {
    super.initState();
    updateSubscription = widget.updateStream.listen((_) => fetchValues());
    fetchValues();
  }

  @override
  void dispose() {
    updateSubscription.cancel();
    super.dispose();
  }

  Future<void> fetchValues() async {
    if (!mounted) return;
    setState(() => isLoaded = false);
    try {
      final futures = await Future.wait(
        widget.fetchers.map((fetcher) => makeStatsRequest(fetcher, widget.queryBuilder)),
      );
      if (!mounted) return;
      setState(() {
        isLoaded = true;
        presentations = futures;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() => error = err);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: presentations.map(Text.new).toList(),
    );
  }
}

typedef JsonConverter<T> = T Function(JsonMap json);

class StatsFetcher<T> {
  final String fieldName;
  final String label;
  final String url;
  final Extractor<T>? fieldExtractor;
  final List<FilterOption> allowedFilters;

  const StatsFetcher({
    required this.fieldName,
    required this.label,
    required this.url,
    this.fieldExtractor,
    this.allowedFilters = const [],
  });

  Extractor<T> get extractor => fieldExtractor ?? Extractor<T>();

  T? extract(JsonMap json) => extractor.extractFrom(json, fieldName);

  String present(JsonMap json) => '$label: ${extract(json)}';
}

Future<String> makeStatsRequest<T>(
  StatsFetcher<T> statsFetcher, [
  QueryBuilder? queryBuilder,
]) async {
  final Iterable<MapEntry<String, dynamic>>? params;
  if (queryBuilder == null) {
    params = null;
  } else {
    params = queryBuilder.queryParams.entries.where(
      (e) => statsFetcher.allowedFilters.map((e) => '${e.name}Filter').contains(e.key),
    );
  }

  final response = await makeRequest(
    HttpMethod.get,
    Uri.http(baseRoute, statsFetcher.url, params == null ? null : Map.fromEntries(params)),
  );

  return httpServiceController(
    response,
    (response) => statsFetcher.present(decodeResponseBody<JsonMap>(response)),
    (response) => '${statsFetcher.label}: помилка',
  );
}
