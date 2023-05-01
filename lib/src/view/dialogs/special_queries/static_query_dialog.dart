import 'package:flutter/material.dart';

import '../../../services/http/helpers/http_service_helper.dart';
import '../../../special_queries/special_query_base.dart';
import '../../../utils/json_decode.dart';

class StaticSpecialQueryDialog extends StatefulWidget {
  final StaticSpecialQuery query;

  const StaticSpecialQueryDialog(this.query, {super.key});

  @override
  State<StaticSpecialQueryDialog> createState() => _StaticSpecialQueryDialogState();
}

class _StaticSpecialQueryDialogState extends State<StaticSpecialQueryDialog> {
  late final dynamic json;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchQuery();
  }

  Future<void> fetchQuery() async {
    final response = await makeRequest(HttpMethod.get, widget.query.makeUri({}));

    final res = await httpServiceController<dynamic>(
      response,
      (response) => decodeResponseBody(response),
      (response) => null,
    );

    if (!mounted) return;
    setState(() {
      json = res;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: buildContent(),
    );
  }

  Widget buildContent() {
    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return widget.query.makePresentationWidget(context, json);
  }
}
