import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../model/interfaces/convertible_to_pdf.dart';
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
    final report = pw.Document(pageMode: PdfPageMode.fullscreen);
    final baseFont = await PdfGoogleFonts.nunitoMedium();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final headerStyle = pw.TextStyle(fontSize: 6, fontBold: boldFont);
    final rowStyle = pw.TextStyle(fontSize: 5, font: baseFont);

    pw.Widget buildTextWithPadding(String text, pw.TextStyle style) =>
        pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              vertical: 3.0,
              horizontal: 5.0,
            ),
            child: pw.Text(
              text,
              style: style,
            ));

    final header = pw.TableRow(
        children: pdfColumns<CTPdf>()
            .map((caption) => buildTextWithPadding(caption, headerStyle))
            .toList());

    final data = reportedItems
        .map((item) => pw.TableRow(
            children: item.pdfRow
                .map((text) => buildTextWithPadding(text.toString(), rowStyle))
                .toList()))
        .toList();

    final table = pw.Table(
      border: pw.TableBorder.all(),
      children: [
        header,
        ...data,
      ],
    );

    report.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        clip: true,
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.nunitoMedium(),
        ),
        build: (context) => table));

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
      return null;
    });
  }
}
