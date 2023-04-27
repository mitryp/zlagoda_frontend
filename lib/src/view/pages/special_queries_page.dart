import 'package:flutter/material.dart';
import 'package:zlagoda_frontend/src/view/pages/page_base.dart';

import '../../model/basic_models/client.dart';
import '../../model/interfaces/convertible_to_row.dart';
import '../../model/schema/validators.dart';
import '../../services/http/special_queries_http_service.dart';
import '../../services/query_builder/query_builder.dart';
import '../../services/query_builder/sort.dart';
import '../../utils/value_status.dart';
import '../dialogs/creation_dialog.dart';
import '../widgets/resources/collections/collection_view.dart';

class SpecialQueriesPage extends StatefulWidget {
  const SpecialQueriesPage({super.key});

  @override
  State<SpecialQueriesPage> createState() => _SpecialQueriesPageState();
}

class _SpecialQueriesPageState extends State<SpecialQueriesPage> {
  //CollectionTable<R extends ConvertibleToRow<R>>? table;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBase.column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildButtonsBlock(),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery
                .of(context)
                .size
                .width / 2),
            //child: table ?? const Text('Обріть необхідну функцію.'),
            child: const Text('Обріть необхідну функцію.'),
          ),
        ],
      ),
    );
  }

  Widget buildButtonsBlock() {
    return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ElevatedButton(
              //   onPressed: () async {
              //     final res = await showDialog(inputHint: '',
              //         get: RegularClientsService().get,
              //         message: 'Мінімальна кількість куплених товарів');
              //
              //     if(res == null) return;
              //
              //     table = CollectionTable<Client>(
              //       itemsSupplier: () async =>
              //       {
              //         RegularClientsService().get(await)
              //       },
              //       updateStream: updateStream,
              //       queryBuilder: queryBuilder,
              //     )
              //
              //     final res = await showDialog<Client>(
              //       message: 'Мінімальна кількість покупок',
              //       get: RegularClientsService().get,
              //       inputHint: '',
              //     );
              //   },
              //   child: const Text('Постійні клієнти'),),
              ElevatedButton(
                child: const Text('Товари, продані всіма касирами'),
                onPressed: () {
                  // table = CollectionTable<Employee>(
                  //   itemsSupplier: ProductsSoldByAllCashiersService().get,
                  //   queryBuilder: QueryBuilder(sort: Sort(SortOption.employeeSurname)),
                  // updateStream: (){}
                   // ,);
                },
              )
            ],
          ),
        ));
  }

  void _updateCallback(ValueChangeStatus updatedStatus) {
    if (updatedStatus == ValueChangeStatus.notChanged) return;
    //TODO
  }

  Widget buildTable<R extends ConvertibleToRow<R>>(List<R> items) {
    return DataTable(
      showCheckboxColumn: false,
      columns: columnsOf<R>(),
      rows: items.map((e) => e.buildRow(context, _updateCallback)).toList(),
    );
  }

  Future<ValueStatusWrapper<int>?> showDialog<R extends ConvertibleToRow<R>>(
      {required String inputHint,
        required Future<List<R>> Function(int) get,
        required String message,
      }) async {
    return showCreationDialog<ValueStatusWrapper<int>>(
        context: context,
        inputBuilder: (textController) =>
            TextFormField(
              decoration: InputDecoration(label: Text(inputHint)),
              controller: textController,
              validator: isNonNegativeInteger,

            ),
        buttonProps: [
          ButtonProps<List<R>>(
            fetchCallback: (value) {
              return get(value);
            },
            caption: 'Підтвердити',
            message: message,
          )
        ]);
  }
}