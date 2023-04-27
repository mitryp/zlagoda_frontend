import 'package:flutter/material.dart';

import '../../services/http/helpers/http_service_helper.dart';
import '../../special_queries.dart';
import '../../utils/json_decode.dart';
import '../dialogs/creation_dialog.dart';
import '../widgets/utils/helping_functions.dart';

//
// class SpecialQueriesPage extends StatefulWidget {
//   const SpecialQueriesPage({super.key});
//
//   @override
//   State<SpecialQueriesPage> createState() => _SpecialQueriesPageState();
// }
//
// class _SpecialQueriesPageState extends State<SpecialQueriesPage> {
//   //CollectionTable<R extends ConvertibleToRow<R>>? table;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageBase.column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildButtonsBlock(),
//           ConstrainedBox(
//             constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width / 2),
//             //child: table ?? const Text('Обріть необхідну функцію.'),
//             child: const Text('Обріть необхідну функцію.'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildButtonsBlock() {
//     return Card(
//         child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       child: Flex(
//         direction: Axis.horizontal,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ElevatedButton(
//           //   onPressed: () async {
//           //     final res = await showDialog(inputHint: '',
//           //         get: RegularClientsService().get,
//           //         message: 'Мінімальна кількість куплених товарів');
//           //
//           //     if(res == null) return;
//           //
//           //     table = CollectionTable<Client>(
//           //       itemsSupplier: () async =>
//           //       {
//           //         RegularClientsService().get(await)
//           //       },
//           //       updateStream: updateStream,
//           //       queryBuilder: queryBuilder,
//           //     )
//           //
//           //     final res = await showDialog<Client>(
//           //       message: 'Мінімальна кількість покупок',
//           //       get: RegularClientsService().get,
//           //       inputHint: '',
//           //     );
//           //   },
//           //   child: const Text('Постійні клієнти'),),
//           ElevatedButton(
//             child: const Text('Товари, продані всіма касирами'),
//             onPressed: () {
//               // table = CollectionTable<Employee>(
//               //   itemsSupplier: ProductsSoldByAllCashiersService().get,
//               //   queryBuilder: QueryBuilder(sort: Sort(SortOption.employeeSurname)),
//               // updateStream: (){}
//               // ,);
//             },
//           )
//         ],
//       ),
//     ));
//   }
//
//   void _updateCallback(ValueChangeStatus updatedStatus) {
//     if (updatedStatus == ValueChangeStatus.notChanged) return;
//     //TODO
//   }
//
//   Widget buildTable<R extends ConvertibleToRow<R>>(List<R> items) {
//     return DataTable(
//       showCheckboxColumn: false,
//       columns: columnsOf<R>(),
//       rows: items.map((e) => e.buildRow(context, _updateCallback)).toList(),
//     );
//   }
//
//   Future<ValueStatusWrapper<int>?> showDialog<R extends ConvertibleToRow<R>>({
//     required String inputHint,
//     required Future<List<R>> Function(int) get,
//     required String message,
//   }) async {
//     return showCreationDialog<ValueStatusWrapper<int>>(
//         context: context,
//         inputBuilder: (textController) => TextFormField(
//               decoration: InputDecoration(label: Text(inputHint)),
//               controller: textController,
//               validator: isNonNegativeInteger,
//             ),
//         buttonProps: [
//           ButtonProps<List<R>>(
//             fetchCallback: (value) {
//               return get(value);
//             },
//             caption: 'Підтвердити',
//             message: message,
//           )
//         ]);
//   }
// }

class SpecialQueriesPage extends StatelessWidget {
  final List<SpecialQuery> specialQueries;

  const SpecialQueriesPage(this.specialQueries, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: makeSeparated(specialQueries.map((e) => buildQueryButton(e, context)).toList()),
        ),
      ),
    );
  }

  Widget buildQueryButton(SpecialQuery query, BuildContext context) {
    return OutlinedButton(
      onPressed: () => processQuery(query, context),
      child: Text(query.queryName),
    );
  }

  void processQuery(SpecialQuery query, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => makeDialog(query),
    );
  }

  Widget makeDialog(SpecialQuery query) {
    if (query.isStaticQuery) {
      return StaticSpecialQueryDialog(query);
    }

    return SingleInputQueryDialog(
      query,
      inputBuilder: query.inputBuilder!,
      inputConverter: query.inputConverter!,
    );
  }
}

class StaticSpecialQueryDialog extends StatefulWidget {
  final SpecialQuery query;

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

typedef InputConverter = dynamic Function(String input);

class SingleInputQueryDialog extends StatefulWidget {
  final SpecialQuery query;
  final InputBuilder inputBuilder;
  final InputConverter inputConverter;

  const SingleInputQueryDialog(
    this.query, {
    required this.inputBuilder,
    required this.inputConverter,
    super.key,
  });

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
    return Dialog(
      child: Column(
        children: [
          Form(
            key: formKey,
            child: widget.inputBuilder(controller),
          ),
          OutlinedButton(onPressed: _processFetch, child: const Text('Виконати запит')),
          buildOutput(),
        ],
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

    return widget.query.makePresentationWidget(context, json);
  }

  void _processFetch() {
    if (!formKey.currentState!.validate()) return;
    fetchQuery(widget.query.inputConverter!(controller.text));
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
          widget.query.parameterName!: param.toString()
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
