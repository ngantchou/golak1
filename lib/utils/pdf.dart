import 'dart:io';

import 'package:golak/elements/lightRichLedger.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

final pdf = Document();

exportAsPDF() async {
  Directory dir = await getApplicationDocumentsDirectory();
  String pdfPath = '${dir.path}/pdfs';
  Directory(pdfPath).createSync();
  pdf.addPage(
    Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Center(
          child: LightRichLedger(),
        ); // Center
      },
    ),
  ); // Page
  Printing.sharePdf(bytes: pdf.save());
  // final File file =
  //     File('$pdfPath/ledger' + DateTime.now().toString() + '.pdf');
  // try {
  //   // file.writeAsBytesSync(pdf.save());
  // } catch (e) {
  //   print(e);
  // }
}
