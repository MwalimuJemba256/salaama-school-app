import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FeesReceiptScreen extends StatefulWidget {
  const FeesReceiptScreen({super.key});
  @override
  State<FeesReceiptScreen> createState() => _FeesReceiptScreenState();
}

class _FeesReceiptScreenState extends State<FeesReceiptScreen> {
  final _studentController = TextEditingController(text: 'Ahmed - P5 Blue');
  final _amountController = TextEditingController(text: '450000');
  final _termController = TextEditingController(text: 'Term 2 - 2024');

  Future<void> _generateReceipt(bool isArabic) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (c) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text(isArabic ? 'إيصال الرسوم' : 'Fees Receipt', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
            pw.Text('Salaama Muslim Junior School\nDestined to Succeed', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
          ]),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text(isArabic ? 'اسم الطالب: ${_studentController.text}' : 'Student: ${_studentController.text}', style: const pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 8),
          pw.Text(isArabic ? 'الفصل: ${_termController.text}' : 'Term: ${_termController.text}', style: const pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 8),
          pw.Text(isArabic ? 'المبلغ: UGX ${_amountController.text}' : 'Amount: UGX ${_amountController.text}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text(isArabic ? 'تم الدفع بنجاح - جزاكم الله خيرا' : 'Paid Successfully - Thank you', style: const pw.TextStyle(fontSize: 12)),
          pw.Spacer(),
          pw.Text(isArabic ? 'أمين الصندوق - Bursar' : 'Bursar Signature', style: const pw.TextStyle(fontSize: 11)),
        ]),
      ),
    );
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _shareReceipt() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (c) => pw.Center(child: pw.Text('Receipt for ${_studentController.text} - UGX ${_amountController.text}'))));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/receipt_${_studentController.text}.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: 'Fees Receipt - Salaama School');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF15803D), title: const Text('Fees Receipt - Bursar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: _studentController, decoration: const InputDecoration(labelText: 'Student Name + Class', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _amountController, decoration: const InputDecoration(labelText: 'Amount UGX', border: OutlineInputBorder()), keyboardType: TextInputType.number),
        const SizedBox(height: 12),
        TextField(controller: _termController, decoration: const InputDecoration(labelText: 'Term', border: OutlineInputBorder())),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: () => _generateReceipt(false), icon: const Icon(Icons.picture_as_pdf, color: Colors.white), label: const Text('PDF EN', style: TextStyle(color: Colors.white)))),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF065F46), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: () => _generateReceipt(true), icon: const Icon(Icons.picture_as_pdf, color: Colors.white), label: const Text('PDF عربي', style: TextStyle(color: Colors.white)))),
        ]),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700], padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: _shareReceipt, icon: const Icon(Icons.share, color: Colors.white), label: const Text('Share Receipt WhatsApp', style: TextStyle(color: Colors.white)))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green)), child: const Row(children: [Icon(Icons.info, color: Colors.green, size: 18), SizedBox(width: 8), Expanded(child: Text('Bursar can generate EN/AR receipt + Share to Parent WhatsApp - UGX 45M tracked', style: TextStyle(fontSize: 11)))])),
      ])),
    );
  }
}
