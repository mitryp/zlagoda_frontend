import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../model/basic_models/client.dart';
import '../../../model/basic_models/category.dart';
import '../../../model/basic_models/employee.dart';
import '../../../model/basic_models/receipt.dart';
import '../../../model/interfaces/convertible_to_pdf.dart';
import '../../../model/joined_models/joined_store_product.dart';
import '../../../model/joined_models/product_with_category.dart';

final collectionsToCaptions = {
  ProductWithCategory: 'products',
  JoinedStoreProduct: 'store_products',
  Category: 'categories',
  Employee: 'employees',
  Client: 'clients',
  Receipt: 'receipts'
};


class ReportPreview<CTPdf extends ConvertibleToPdf<CTPdf>> extends StatelessWidget {
  final pw.Document report;

  const ReportPreview({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final String? fileName = collectionsToCaptions[CTPdf];
    assert(fileName != null);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Перегляд звіту'),
        ),
        body: PdfPreview(
          build: (format) => report.save(),
          allowSharing: true,
          allowPrinting: true,
          initialPageFormat: PdfPageFormat.a4,
          pdfFileName: 'Report_on_$fileName',
          canChangeOrientation: true,
        )
    );
  }
}
