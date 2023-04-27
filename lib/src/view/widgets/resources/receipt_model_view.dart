import 'package:flutter/material.dart';

import '../../../model/basic_models/client.dart';
import '../../../model/basic_models/employee.dart';
import '../../../model/basic_models/receipt.dart';
import '../../../model/interfaces/convertible_to_row.dart';
import '../../../model/interfaces/convertibles_helper.dart';
import '../../../model/interfaces/model.dart';
import '../../../model/joined_models/joined_sale.dart';
import '../../../model/schema/field_type.dart';
import '../../../services/http/helpers/http_service_helper.dart';
import '../../../utils/coins_to_currency.dart';
import '../../../utils/navigation.dart';
import '../../../utils/value_status.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../text_link.dart';
import 'models/model_edit_view.dart';

typedef ReceiptFetchFunction = Future<Receipt> Function();

class ReceiptModelView extends StatefulWidget {
  final ReceiptFetchFunction fetchFunction;

  const ReceiptModelView({required this.fetchFunction, super.key});

  @override
  State<ReceiptModelView> createState() => _ReceiptModelViewState();
}

class _ReceiptModelViewState extends State<ReceiptModelView> {
  late Receipt receipt;
  bool isLoaded = false;
  Object? error;

  @override
  void initState() {
    super.initState();
    fetchReceipt();
  }

  Future<void> fetchReceipt() async {
    setState(() {
      isLoaded = false;
      error = null;
    });

    try {
      receipt = await widget.fetchFunction();
    } catch (err) {
      if (!mounted) return;
      return setState(() => error = err);
    }

    setState(() => isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    Widget? guard;

    if (error != null) {
      guard = Center(
        child: Text('$error'),
      );
    }

    if (!isLoaded) {
      guard = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Чек'),
        actions: [
          if (isLoaded) buildDeleteButton(processDeletion),
        ],
      ),
      body: guard ?? buildBody(),
    );
  }

  ConstrainedBox buildBody() {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildReceiptInfo(),
            buildSales(),
          ],
        ),
      ),
    );
  }

  Widget buildReceiptInfo() {
    final info = {
      'Дата': FieldType.datetime.presentation(receipt.date),
      'Вартість': toHryvnas(receipt.cost),
      'Податок': toHryvnas(receipt.tax),
    };

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...info.entries.map(buildReceiptFieldPresentation),
          ...buildReferences(),
        ],
      ),
    );
  }

  Widget buildReceiptFieldPresentation(MapEntry<String, Object> e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 17),
          children: [
            TextSpan(text: '${e.key}:  ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${e.value}')
          ],
        ),
      ),
    );
  }

  Iterable<Widget> buildReferences() {
    final client = receipt.clientId, employee = receipt.employeeId;
    return [
      buildReference('Клієнт:', buildLink<Client>(receipt.clientName?.fullName, client)),
      buildReference('Касир:', buildLink<Employee>(receipt.employeeName.fullName, employee)),
    ];
  }

  Widget buildReference(String label, Widget reference) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        reference,
      ],
    );
  }

  Widget buildLink<M extends Model>(String? repr, dynamic foreignKey) {
    if (repr == null) {
      return const Text(
        'немає даних',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      );
    }

    return TextLink(
      repr,
      onTap:
          foreignKey != null ? () => AppNavigation.of(context).toModelView<M>(foreignKey) : () {},
      style: const TextStyle(fontSize: 17),
    );
  }

  Widget buildSales() {
    final sales = receipt.sales;

    return DataTable(
      showCheckboxColumn: false,
      columns: columnsOf<JoinedSale>(),
      rows: sales.map(buildSaleRow).toList(),
    );
  }

  DataRow buildSaleRow(JoinedSale sale) {
    final values = rowValues<JoinedSale>(sale).toList()
      ..removeLast()
      ..add(FieldType.boolean.presentation(sale.isProm));

    return DataRow(
      cells: values.map((e) => DataCell(Text('$e'))).toList(),
      onSelectChanged: (_) {
        sale.redirectToModelView(context).then((status) {
          if (mounted && status.status != ValueChangeStatus.notChanged) {
            fetchReceipt();
          }
        });
      },
    );
  }

  Future<void> processDeletion() async {
    final isConfirmed = await showConfirmationDialog(
      context: context,
      builder: (context) => const ConfirmationDialog.message('Ви точно хочете видалити чек?'),
    );

    if (!mounted || !isConfirmed) return;

    final response = await makeRequest(
      HttpMethod.delete,
      Uri.http(baseRoute, 'api/receipts/${receipt.receiptId}'),
    );

    final deleted = await httpServiceController(response, (response) => true, (response) => false);
    if (!mounted || !deleted) return;
    Navigator.of(context).pop(ValueStatusWrapper<Receipt>.deleted());
  }
}
