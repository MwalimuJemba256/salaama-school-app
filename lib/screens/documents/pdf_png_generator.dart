import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/colors.dart' as appColors;

class DocumentGenerator extends StatefulWidget {
  const DocumentGenerator({super.key});
  @override
  State<DocumentGenerator> createState() => _DocumentGeneratorState();
}

class _DocumentGeneratorState extends State<DocumentGenerator> {
  Color selectedColor = appColors.AppColors.primaryBlue;
  String docType = 'Receipt';
  
  Future<void> generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4, build: (ctx){
      return pw.Column(children: [
        pw.Container(color: PdfColor.fromInt(selectedColor.value), width: double.infinity, padding: const pw.EdgeInsets.all(20), child: pw.Text('SALAAMA MUSLIM JUNIOR SCHOOL - $docType', style: pw.TextStyle(color: PdfColors.white, fontSize: 20))),
        pw.SizedBox(height:20),
        pw.Text('DESTINED TO SUCCEED', style: const pw.TextStyle(fontSize: 14)),
        pw.SizedBox(height:20),
        pw.Text('Student: Ahmad - P2 - Tahfiizu Section\nFees: UGX 520,000\nDate: ${DateTime.now()}'),
      ]);
    }));
    await Printing.layoutPdf(onLayout: (f)=>pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF & PNG Generator'), backgroundColor: appColors.AppColors.primaryBlue, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        DropdownButtonFormField(value: docType, items: ['Receipt','Report Card','ID Card','Fee Slip','Salary Slip'].map((e)=>DropdownMenuItem(value:e, child:Text(e))).toList(), onChanged: (v)=>setState(()=>docType=v!)),
        const SizedBox(height:20),
        const Text('Choose Custom Color:'),
        Row(children: [Colors.blue, Colors.green, Colors.red, Colors.orange, appColors.AppColors.primaryBlue].map((c)=> GestureDetector(onTap: ()=>setState(()=>selectedColor=c), child: Container(margin: const EdgeInsets.all(8), width: 40, height: 40, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(width: selectedColor==c?3:0))))).toList()),
        const SizedBox(height:30),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: generatePDF, child: const Text('Generate PDF with Custom Color'))),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: generatePDF, child: const Text('Generate PNG with Custom Color'))),
      ])),
    );
  }
}