import 'package:flutter/material.dart';

import '../../services/http/helpers/http_service_helper.dart';
import '../../special_queries.dart';
import '../../typedefs.dart';
import '../../utils/json_decode.dart';
import '../dialogs/creation_dialog.dart';

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
    return const Placeholder();
  }
}

class StaticSpecialQueryDialog extends StatefulWidget {
  final SpecialQuery query;

  const StaticSpecialQueryDialog(this.query, {super.key});

  @override
  State<StaticSpecialQueryDialog> createState() => _StaticSpecialQueryDialogState();
}

class _StaticSpecialQueryDialogState extends State<StaticSpecialQueryDialog> {
  late final JsonMap json;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchQuery();
  }

  Future<void> fetchQuery() async {
    final response = await makeRequest(HttpMethod.get, widget.query.makeUri({}));

    final res = await httpServiceController<Map<String, dynamic>>(
      response,
      (response) => decodeResponseBody(response),
      (response) => {},
    );

    if (!mounted || res.isEmpty) return;
    setState(() {
      json = res;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return widget.query.makePresentationWidget(context, json);
  }
}

typedef InputConverter = dynamic Function(String input);

class SingleInputQueryPage extends StatefulWidget {
  final SpecialQuery query;
  final InputBuilder inputBuilder;
  final InputConverter inputConverter;

  const SingleInputQueryPage(
    this.query, {
    required this.inputBuilder,
    required this.inputConverter,
    super.key,
  });

  @override
  State<SingleInputQueryPage> createState() => _SingleInputQueryPageState();
}

class _SingleInputQueryPageState extends State<SingleInputQueryPage> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late JsonMap json;
  bool isLoading = false;
  bool isLoaded = false;

  Future<void> fetchQuery(dynamic param) async {
    setState(() {
      isLoading = true;
      isLoaded = false;
    });

    final response = await makeRequest(
      HttpMethod.get,
      widget.query.makeUri({widget.query.parameterName!: param.toString()}),
    );

    if (!mounted) return;

    final res = await httpServiceController<Map<String, dynamic>>(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: widget.inputBuilder(controller),
        ),
        OutlinedButton(onPressed: _processFetch, child: const Text('Виконати запит')),
      ],
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
        child: Text('Запиту не було'),
      );
    }

    return widget.query.makePresentationWidget(context, json);
  }

  void _processFetch() {
    if (!formKey.currentState!.validate()) return;
  }
}
