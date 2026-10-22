import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'footer_service.dart';

class PdfService {
  static Future<Uint8List> generateGradeCard(Map student, List marks) async {
    final pdf = pw.Document();
    final footer = await FooterService.getFooter();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Container(
        color: PdfColor.fromHex("#FFF8E1"),
        child: pw.Column(children: [
          pw.Container(
            color: PdfColor.fromHex("#0D6EFD"),
            padding: pw.EdgeInsets.all(20),
            child: pw.Center(child: pw.Text(student["name"] ?? "Student", style: pw.TextStyle(color: PdfColors.white, fontSize: 20))),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColor.fromHex("#0B3D91")),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColor.fromHex("#0D6EFD")),
                children: [pw.Padding(padding: pw.EdgeInsets.all(8), child: pw.Text("Subject", style: pw.TextStyle(color: PdfColors.white))), pw.Padding(padding: pw.EdgeInsets.all(8), child: pw.Text("Marks", style: pw.TextStyle(color: PdfColors.white)))],
              ),
              ...marks.map((m) => pw.TableRow(children: [pw.Padding(padding: pw.EdgeInsets.all(6), child: pw.Text(m["subject"])), pw.Padding(padding: pw.EdgeInsets.all(6), child: pw.Text("${m["marks"]}"))])),
            ],
          ),
          pw.Spacer(),
          if (footer["showFooter"] == true)
            pw.Container(
              color: PdfColor.fromHex("#0B3D91"),
              padding: pw.EdgeInsets.all(10),
              child: pw.Column(children: [
                pw.Text(footer["footerLine1"] ?? "", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                pw.Text(footer["footerLine2"] ?? "", style: pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                pw.Text(footer["footerLine3"] ?? "", style: pw.TextStyle(color: PdfColors.white, fontSize: 8)),
              ]),
            ),
        ]),
      ),
    ));
    return pdf.save();
  }
}