import 'package:flutter/material.dart';

import '../../model/basic_models/employee.dart';
import '../../services/auth/user.dart';
import '../../special_queries/special_query_base.dart';
import '../dialogs/special_queries/single_input_query_dialog.dart';
import '../dialogs/special_queries/static_query_dialog.dart';
import '../widgets/auth/authorizer.dart';
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

bool _isManager(User? user) => hasPosition(Position.manager)(user);

class SpecialQueriesPage extends StatelessWidget {
  final List<StaticSpecialQuery> specialQueries;

  const SpecialQueriesPage(this.specialQueries, {super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      authorizationStrategy: _isManager,
      child: Scaffold(
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: makeSeparated(specialQueries.map((e) => buildQueryButton(e, context)).toList()),
            ),
          ),
        ),
      )
    );
  }

  Widget buildQueryButton(StaticSpecialQuery query, BuildContext context) {
    return OutlinedButton(
      onPressed: () => processQuery(query, context),
      child: Text(query.queryName),
    );
  }

  void processQuery(StaticSpecialQuery query, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => makeDialog(query),
    );
  }

  Widget makeDialog(StaticSpecialQuery query) {
    return query is SingleInputSpecialQuery
        ? SingleInputQueryDialog(query)
        : StaticSpecialQueryDialog(query);
  }
}
