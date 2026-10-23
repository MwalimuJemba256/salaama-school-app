import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});
  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String selectedDocType = "Fees Receipt";
  final docTypes = ["Fees Receipt", "Report Card", "Tahfiizu Certificate", "Attendance Report"];

  String selectedStudent = "";
  Map<String, dynamic>? studentData;
  Map<String, dynamic>? feesData;
  Map<String, dynamic>? examData;

  final GlobalKey _receiptKey = GlobalKey();
  final GlobalKey _reportKey = GlobalKey();
  final GlobalKey _tahfiizuKey = GlobalKey();

  bool isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Documents - PNG"), backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Document Type", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDocType,
              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              items: docTypes.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => selectedDocType = v!),
            ),
            const SizedBox(height: 16),
            const Text("Select Student", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (context, snap) {
                final students = snap.data?.docs ?? [];
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Student Name", isDense: true),
                  items: students.map((d) => DropdownMenuItem<String>(value: d.data()['name'], child: Text(d.data()['name']))).toList(),
                  onChanged: (v) async {
                    setState(() => selectedStudent = v!);
                    // Fetch student data
                    final stDoc = students.firstWhere((d) => d.data()['name'] == v);
                    setState(() => studentData = stDoc.data());
                    // Fetch latest fees payment
                    final feesQuery = await FirebaseFirestore.instance.collection('fees_payments').where('studentName', isEqualTo: v).orderBy('createdAt', descending: true).limit(1).get();
                    if (feesQuery.docs.isNotEmpty) setState(() => feesData = feesQuery.docs.first.data());
                    // Fetch latest exam
                    final examQuery = await FirebaseFirestore.instance.collection('exam_results').where('studentName', isEqualTo: v).orderBy('createdAt', descending: true).limit(1).get();
                    if (examQuery.docs.isNotEmpty) setState(() => examData = examQuery.docs.first.data());
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            if (selectedStudent.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 10),
              const Text("Preview (Will Generate as PNG)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              _buildPreview(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0), padding: const EdgeInsets.all(16)),
                  icon: isGenerating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: Text(isGenerating ? "Generating PNG..." : "Generate & Share PNG", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: isGenerating ? null : () => _generateAndShare(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Row(children: [Icon(Icons.info, size: 16, color: Colors.blue), SizedBox(width: 8), Expanded(child: Text("PNG will be saved to gallery and can be shared via WhatsApp, Email, etc.", style: TextStyle(fontSize: 11, color: Colors.blue))) ]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    switch (selectedDocType) {
      case "Fees Receipt": return _buildReceiptPreview();
      case "Report Card": return _buildReportCardPreview();
      case "Tahfiizu Certificate": return _buildTahfiizuPreview();
      case "Attendance Report": return _buildAttendancePreview();
      default: return _buildReceiptPreview();
    }
  }

  Widget _buildReceiptPreview() {
    return RepaintBoundary(
      key: _receiptKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF0D47A1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.school, color: Colors.white)), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SALAAMA MUSLIM JUNIOR SCHOOL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text("DESTINED TO SUCCEED - Fees Receipt", style: TextStyle(fontSize: 10, color: Colors.grey))]))]),
            const Divider(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Receipt No:", style: TextStyle(fontSize: 11, color: Colors.grey)), Text("R-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Date:", style: TextStyle(fontSize: 11, color: Colors.grey)), Text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}", style: const TextStyle(fontSize: 11))]),
            const SizedBox(height: 16),
            Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Student: ${studentData?['name'] ?? selectedStudent}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), const SizedBox(height: 4), Text("Class: ${studentData?['class'] ?? feesData?['className'] ?? 'N/A'} | Term: ${feesData?['term'] ?? 'Term 1'}", style: const TextStyle(fontSize: 11)), Text("Parent: ${studentData?['parentPhone'] ?? 'N/A'}", style: const TextStyle(fontSize: 11))])),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Colors.green.shade200), borderRadius: BorderRadius.circular(8), color: Colors.green.shade50), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Expected Amount:", style: TextStyle(fontSize: 12)), Text("UGX ${feesData?['expectedAmount'] ?? 450000}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]), const SizedBox(height: 6), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Amount Paid:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), Text("UGX ${feesData?['paidAmount'] ?? 0}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green))]), const Divider(), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Balance:", style: TextStyle(fontSize: 12)), Text("UGX ${feesData?['balance'] ?? 0}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: (feesData?['balance'] ?? 0) <= 0 ? Colors.green : Colors.red))]), const SizedBox(height: 6), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Payment Method:", style: TextStyle(fontSize: 11, color: Colors.grey)), Text("${feesData?['paymentMethod'] ?? 'Cash'}", style: const TextStyle(fontSize: 11))])])),
            const SizedBox(height: 16),
            const Text("Thank you for your payment! May Allah bless you.", style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("© Salaama School", style: TextStyle(fontSize: 9, color: Colors.grey)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)), child: Text((feesData?['balance'] ?? 0) <= 0 ? "PAID" : "PARTIAL", style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)))]),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCardPreview() {
    return RepaintBoundary(
      key: _reportKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(children: [const Icon(Icons.school, color: Color(0xFF0D47A1)), const SizedBox(width: 8), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SALAAMA MUSLIM JUNIOR SCHOOL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text("Academic Report Card - DESTINED TO SUCCEED", style: TextStyle(fontSize: 9, color: Colors.grey))]))]),
            const Divider(height: 20),
            Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Name: ${studentData?['name'] ?? selectedStudent}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text("Class: ${studentData?['class'] ?? examData?['className'] ?? ''} | ${examData?['term'] ?? 'Term 1'} ${examData?['examType'] ?? ''}", style: const TextStyle(fontSize: 10))])), Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)), child: Text("Total: ${examData?['total'] ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)))]),
            const SizedBox(height: 12),
            const Align(alignment: Alignment.centerLeft, child: Text("Secular Subjects", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blue))),
            const SizedBox(height: 4),
            ...["English", "Mathematics", "Science", "SST"].map((sub) => Padding(padding: const EdgeInsets.only(bottom: 3), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(sub, style: const TextStyle(fontSize: 11)), Text("${examData?[sub] ?? 0}/100", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]))),
            const SizedBox(height: 8),
            const Align(alignment: Alignment.centerLeft, child: Text("Theology Subjects", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF00695C)))),
            const SizedBox(height: 4),
            ...["Quran", "Fiqh", "Arabic", "Tahfiizu"].map((sub) => Padding(padding: const EdgeInsets.only(bottom: 3), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(sub, style: const TextStyle(fontSize: 11)), Text("${examData?[sub] ?? 0}/100", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]))),
            const Divider(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Average:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), Text("${(examData?['average'] ?? 0).toStringAsFixed(1)}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 8),
            const Text("Class Teacher Signature: ___________________", style: TextStyle(fontSize: 9, color: Colors.grey)),
            const SizedBox(height: 4),
            const Text("Head Teacher: DESTINED TO SUCCEED", style: TextStyle(fontSize: 8, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTahfiizuPreview() {
    return RepaintBoundary(
      key: _tahfiizuKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFFFF8E1), border: Border.all(color: const Color(0xFF00695C), width: 2), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            const Icon(Icons.menu_book, size: 40, color: Color(0xFF00695C)),
            const SizedBox(height: 8),
            const Text("بسم الله الرحمن الرحيم", style: TextStyle(fontSize: 14, color: Color(0xFF00695C), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("SALAAMA MUSLIM JUNIOR SCHOOL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const Text("Tahfiizu Certificate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
            const Divider(height: 20, color: Color(0xFF00695C)),
            const Text("This certifies that", style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            Text(selectedStudent, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Class: ${studentData?['class'] ?? ''}", style: const TextStyle(fontSize: 11)),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF00695C).withOpacity(0.2))), child: const Column(children: [Text("MashaAllah has memorized Quran with excellence", style: TextStyle(fontSize: 11)), SizedBox(height: 6), Text("May Allah make it beneficial for him/her in this life and Akhirah", style: TextStyle(fontSize: 9, fontStyle: FontStyle.italic, color: Colors.grey))])),
            const SizedBox(height: 12),
            const Text("Sheikh Signature: ________________", style: TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 8),
            Text("Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}", style: const TextStyle(fontSize: 9, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendancePreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const Text("Attendance Report", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Student: $selectedStudent", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('attendance').where('studentName', isEqualTo: selectedStudent).snapshots(),
            builder: (context, snap) {
              final docs = snap.data?.docs ?? [];
              final present = docs.where((d) => d.data()['isPresent'] == true).length;
              final percent = docs.isEmpty ? 0 : (present / docs.length * 100).toStringAsFixed(1);
              return Column(children: [Text("$percent% Present ($present/${docs.length} days)", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)), const SizedBox(height: 8), ...docs.take(5).map((d) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(d.data()['date'] ?? '', style: const TextStyle(fontSize: 11)), Text(d.data()['status'] ?? '', style: TextStyle(fontSize: 11, color: d.data()['isPresent'] == true ? Colors.green : Colors.red))] ))]);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndShare() async {
    setState(() => isGenerating = true);
    try {
      GlobalKey key;
      if (selectedDocType == "Fees Receipt") key = _receiptKey;
      else if (selectedDocType == "Report Card") key = _reportKey;
      else key = _tahfiizuKey;

      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final fileName = "${selectedDocType.replaceAll(' ', '_')}_${selectedStudent.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png";
      final file = await File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: "Salaama Muslim Junior School - $selectedDocType for $selectedStudent\nDESTINED TO SUCCEED");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PNG Generated & Ready to Share! Can send via WhatsApp!"), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error generating PNG: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => isGenerating = false);
    }
  }
}
