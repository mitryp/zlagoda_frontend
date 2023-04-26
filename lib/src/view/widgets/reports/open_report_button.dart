import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../model/interfaces/convertible_to_pdf.dart';
import '../../../model/interfaces/convertibles_helper.dart';
import '../../../services/http/helpers/http_service_factory.dart';
import '../../../services/query_builder/query_builder.dart';
import '../../../theme.dart';
import 'report_preview.dart';

class ReportButton<CTPdf extends ConvertibleToPdf<CTPdf>>
    extends StatefulWidget {
  final QueryBuilder queryBuilder;

  const ReportButton({super.key, required this.queryBuilder});

  @override
  State<ReportButton> createState() => _ReportButtonState<CTPdf>();
}

class _ReportButtonState<CTPdf extends ConvertibleToPdf<CTPdf>>
    extends State<ReportButton<CTPdf>> {
  bool isLoading = false;
  Widget initialChild = const Icon(Icons.print);
  late Widget child = initialChild;
  Object? error;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _openReport,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(secondary),
      ),
      child: child,
    );
  }

  void _openReport() async {
    final items = await _fetchItems();

    if (items == null) return;

    final report = await _createReport(items);

    if (!mounted) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportPreview<CTPdf>(report: report)));
  }

  Future<pw.Document> _createReport(List<CTPdf> reportedItems) async {
    final report = pw.Document();

    report.addPage(pw.Page(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.nunitoMedium(),
      ),
      build: (context) => pw.Table.fromTextArray(
        headers: columnNamesOf<CTPdf>(),
        data: reportedItems.map((item) => item.row).toList(),
      ),
    ));

    return report;
  }

  Future<List<CTPdf>?> _fetchItems() {
    setState(() {
      isLoading = true;
      error = null;
    });

    final service = makeModelHttpService<CTPdf>();

    return service.get(widget.queryBuilder).then(
      (collection) {
        if (!mounted) return null;

        setState(() => isLoading = false);

        return collection.items.cast<CTPdf>();
      },
    ).catchError((err) {
      if (!mounted) return null;
      setState(() => child = const Text('Помилка'));
    });
  }
}
