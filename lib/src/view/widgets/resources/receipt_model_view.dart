import 'package:flutter/material.dart';

import '../../../model/basic_models/receipt.dart';
import '../../../model/interfaces/convertible_to_row.dart';
import '../../../model/joined_models/joined_sale.dart';
import '../../../model/schema/field_type.dart';
import '../../../utils/coins_to_currency.dart';
import '../../../utils/value_status.dart';

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
    if (error != null) {
      return Center(
        child: Text('$error'),
      );
    }

    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Чек')),
      body: ConstrainedBox(
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
      ),
    );
  }

  Widget buildReceiptInfo() {
    final info = {
      'Дата': FieldType.date.presentation(receipt.date),
      'Клієнт': receipt.clientName ?? 'немає даних',
      'Касир': receipt.employeeName,
      'Вартість': toHryvnas(receipt.cost),
      'Податок': toHryvnas(receipt.tax),
    };

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: info.entries.map(buildReceiptFieldPresentation).toList(),
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
}
