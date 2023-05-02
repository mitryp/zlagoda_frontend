import 'package:flutter/material.dart';

import '../../../services/http/helpers/http_service_helper.dart';
import '../../../special_queries/special_query_base.dart';
import '../../../utils/json_decode.dart';
import '../../widgets/utils/helping_functions.dart';
import '../confirmation_dialog.dart';

class SingleInputQueryDialog extends StatefulWidget {
  final SingleInputSpecialQuery query;

  const SingleInputQueryDialog(this.query, {super.key});

  @override
  State<SingleInputQueryDialog> createState() => _SingleInputQueryDialogState();
}

class _SingleInputQueryDialogState extends State<SingleInputQueryDialog> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late dynamic json;
  bool isLoading = false;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      style: ConfirmationDialog.defaultStyle.copyWith(
        acceptButtonLabel: 'Закрити',
        cancelButtonLabel: null,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: makeSeparated([
            Text(
              widget.query.queryName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Form(
              key: formKey,
              child: widget.query.inputBuilder(controller),
            ),
            OutlinedButton(onPressed: _processFetch, child: const Text('Виконати запит')),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildOutput(),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildOutput() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!isLoaded) {
      return const Center(
        child: Text('Запиту ще не було'),
      );
    }

    return widget.query.makePresentationWidget(context, json, _processFetch);
  }

  void _processFetch() {
    if (!formKey.currentState!.validate()) return;
    fetchQuery(widget.query.inputConverter(controller.text));
  }

  Future<void> fetchQuery(dynamic param) async {
    setState(() {
      isLoading = true;
      isLoaded = false;
    });

    final response = await makeRequest(
      HttpMethod.get,
      widget.query.makeUri({
        if (param != null && (param is! String || param.isNotEmpty))
          widget.query.parameterName: '$param'
      }),
    );

    if (!mounted) return;

    final res = await httpServiceController<dynamic>(
      response,
      (response) => decodeResponseBody(response),
      (response) => {},
    );

    if (!mounted) return;

    setState(() {
      json = res;
      isLoading = false;
      isLoaded = true;
    });
  }
}
