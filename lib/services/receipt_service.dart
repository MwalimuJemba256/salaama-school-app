import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptService {
  static Future<void> generateReceipt({
    required String teacherName,
    required String section,
    required String subject,
    required String className,
    required String topic,
    required String date,
  }) async {
    final pdf = pw.Document();
    
    // Load logo
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // HEADER WITH LOGO + BRIGHT BLUE #2196F3
              pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(12),
                color: PdfColor.fromHex("#2196F3"),
                child: pw.Row(
                  children: [
                    pw.Image(logoImage, width: 60, height: 60),
                    pw.SizedBox(width: 15),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("SALAAMA MUSLIM JUNIOR SCHOOL",
                            style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text("DESTINED TO SUCCEED",
                            style: pw.TextStyle(
                                color: PdfColors.white, fontSize: 10)),
                        pw.Text("SALAAMA ROAD, KAMPALA - 0702642786",
                            style: pw.TextStyle(
                                color: PdfColors.white, fontSize: 8)),
                      ],
                    )
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("CLASS START RECEIPT", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text("Teacher: $teacherName"),
              pw.Text("Section: $section"),
              pw.Text("Subject: $subject (Dynamic A,B,C)"),
              pw.Text("Class: $className"),
              pw.Text("Topic: $topic"),
              pw.Text("Date: $date"),
              pw.SizedBox(height: 30),
              pw.Text("Signature: ___________________", style: pw.TextStyle(fontSize: 12)),
              pw.Spacer(),
              pw.Center(
                child: pw.Text("Powered by SALAAMA System - Bright Blue #2196F3",
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              )
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}