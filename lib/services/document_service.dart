import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DocumentService {
  static const salaamaGreen = PdfColor.fromInt(0xFF0D5A2D);
  static const salaamaBlue = PdfColor.fromInt(0xFF1E3A8A);
  static const salaamaGold = PdfColor.fromInt(0xFFD4AF37);

  // ================= ID CARD - ENGLISH & ARABIC =================
  static Future<void> generateStudentIdCard({
    required Map<String, dynamic> student,
    required bool isArabic,
  }) async {
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.amiriRegular();
    final arabicBold = await PdfGoogleFonts.amiriBold();
    final engFont = await PdfGoogleFonts.poppinsRegular();
    final engBold = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) {
          return pw.Center(
            child: pw.Container(
              width: 320,
              height: 480,
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: isArabic ? salaamaBlue : salaamaGreen, width: 3),
                borderRadius: pw.BorderRadius.circular(15),
              ),
              child: pw.Column(
                children: [
                  pw.Container(
                    color: isArabic ? salaamaBlue : salaamaGreen,
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Center(
                      child: pw.Text(
                        isArabic ? 'مدرسة سلاما الإسلامية - كامبالا' : 'SALAAMA MUSLIM JUNIOR SCHOOL',
                        style: pw.TextStyle(font: isArabic ? arabicBold : engBold, color: PdfColors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(isArabic ? 'مصيرها النجاح' : 'DESTINED TO SUCCEED', style: pw.TextStyle(font: engFont, fontSize: 8)),
                  pw.Divider(thickness: 1.5, color: isArabic ? salaamaBlue : salaamaGreen),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    width: 90,
                    height: 90,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      border: pw.Border.all(color: isArabic ? salaamaBlue : salaamaGreen, width: 2),
                    ),
                    child: pw.Center(child: pw.Text(isArabic ? 'الصورة' : 'PHOTO', style: pw.TextStyle(font: engFont, fontSize: 10))),
                  ),
                  pw.SizedBox(height: 12),
                  _idRow(isArabic ? 'رقم الطالب' : 'Student ID', student['studentId'] ?? '', isArabic, arabicFont, engBold),
                  _idRow(isArabic ? 'الاسم' : 'Name', student['fullName'] ?? '', isArabic, arabicFont, engBold),
                  _idRow(isArabic ? 'الفصل' : 'Class', student['class'] ?? '', isArabic, arabicFont, engBold),
                  _idRow(isArabic ? 'ولي الأمر' : 'Parent', student['parentName'] ?? '', isArabic, arabicFont, engBold),
                  _idRow(isArabic ? 'الهاتف' : 'Phone', student['parentPhone'] ?? '', isArabic, arabicFont, engBold),
                  pw.Spacer(),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(6),
                    color: isArabic ? salaamaBlue : salaamaGreen,
                    child: pw.Center(child: pw.Text(isArabic ? 'بطاقة الطالب 2025-2026' : 'STUDENT ID 2025-2026', style: pw.TextStyle(font: engBold, color: PdfColors.white, fontSize: 10))),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    await _saveAndShare(pdf, 'ID_${student['studentId']}_${isArabic ? 'AR' : 'EN'}.pdf', isArabic ? 'بطاقة الطالب' : 'Student ID');
  }

  // ================= REPORT CARD - SECULAR + THEOLOGY WITH TARBIYAH =================
  static Future<void> generateReportCard({
    required Map<String, dynamic> student,
    required Map<String, dynamic> marks, // {'English':85, 'Quran':95, 'Tarbiah - Tauhid':88}
    required String term, // Term 1, 2, 3
    required bool isArabic,
  }) async {
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.amiriRegular();
    final arabicBold = await PdfGoogleFonts.amiriBold();
    final engFont = await PdfGoogleFonts.poppinsRegular();
    final engBold = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(color: salaamaGreen, padding: const pw.EdgeInsets.all(12), child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text('SALAAMA MUSLIM JUNIOR SCHOOL', style: pw.TextStyle(font: engBold, color: PdfColors.white, fontSize: 16)),
                  pw.Text(isArabic ? 'تقرير الأداء الأكاديمي' : 'ACADEMIC REPORT - $term', style: pw.TextStyle(font: isArabic ? arabicBold : engFont, color: PdfColors.white, fontSize: 12)),
                ]),
                pw.Text('DESTINED TO SUCCEED', style: pw.TextStyle(font: engFont, color: PdfColors.white, fontSize: 8)),
              ])),
              pw.SizedBox(height: 12),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Name: ${student['fullName']}', style: pw.TextStyle(font: engBold, fontSize: 12)),
                pw.Text('ID: ${student['studentId']}', style: pw.TextStyle(font: engFont, fontSize: 10)),
              ]),
              pw.Text('Class: ${student['class']} | Term: $term | Year: 2025-2026', style: pw.TextStyle(font: engFont, fontSize: 10)),
              pw.SizedBox(height: 12),

              // SECULAR TABLE
              if (marks.keys.any((k) => ['English','Math','Science','SST','Mathematics','Social Studies'].any((s) => k.contains(s))))
                pw.Column(children: [
                  pw.Container(color: PdfColor.fromInt(0xFFE8F5E9), padding: const pw.EdgeInsets.all(6), child: pw.Text('SECULAR SUBJECTS - المواد العلمانية', style: pw.TextStyle(font: engBold, fontSize: 11))),
                  _marksTable(marks.entries.where((e) => !isTheologySubject(e.key)).toList(), isArabic, arabicFont, arabicBold, engFont, engBold),
                  pw.SizedBox(height: 10),
                ]),

              // THEOLOGY TABLE - WITH TARBIYAH GROUP
              pw.Container(color: PdfColor.fromInt(0xFFE3F2FD), padding: const pw.EdgeInsets.all(6), child: pw.Text(isArabic ? 'المواد الشرعية - مع التربية' : 'THEOLOGY SUBJECTS - With Tarbiah: Tauhid, Siirah, Hadith', style: pw.TextStyle(font: isArabic ? arabicBold : engBold, fontSize: 11))),
              _marksTable(marks.entries.where((e) => isTheologySubject(e.key)).toList(), isArabic, arabicFont, arabicBold, engFont, engBold),

              pw.SizedBox(height: 15),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Total: ${marks.values.fold<int>(0, (a, b) => a + (b as int))} / ${marks.length * 100}', style: pw.TextStyle(font: engBold)),
                pw.Text('Grade: ${_overallGrade(marks)}', style: pw.TextStyle(font: engBold, color: salaamaGreen)),
              ]),
              pw.SizedBox(height: 20),
              pw.Center(child: pw.Text(isArabic ? 'بارك الله فيكم وجزاكم خيرا' : 'May Allah Bless You - Destined to Succeed', style: pw.TextStyle(font: isArabic ? arabicBold : engBold, color: salaamaGreen, fontSize: 12))),
            ],
          );
        },
      ),
    );

    await _saveAndShare(pdf, 'Report_${student['studentId']}_${term}_${isArabic ? 'AR' : 'EN'}.pdf', 'Report Card');
  }

  // ================= HIFZ CERTIFICATE =================
  static Future<void> generateHifzCertificate({
    required Map<String, dynamic> student,
    required String surah,
    required String juz,
    required String grade,
  }) async {
    final pdf = pw.Document();
    final arabicBold = await PdfGoogleFonts.amiriBold();
    final arabicReg = await PdfGoogleFonts.amiriRegular();
    final engBold = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) {
          return pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all(color: salaamaGreen, width: 6)),
            padding: const pw.EdgeInsets.all(25),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('بسم الله الرحمن الرحيم', style: pw.TextStyle(font: arabicBold, fontSize: 14)),
                pw.SizedBox(height: 20),
                pw.Container(color: salaamaGreen, padding: const pw.EdgeInsets.all(10), child: pw.Center(child: pw.Text('SALAAMA MUSLIM JUNIOR SCHOOL', style: pw.TextStyle(font: engBold, color: PdfColors.white, fontSize: 18)))),
                pw.SizedBox(height: 15),
                pw.Text('شهادة حفظ القرآن الكريم', style: pw.TextStyle(font: arabicBold, fontSize: 28, color: salaamaGreen)),
                pw.SizedBox(height: 10),
                pw.Text('QURAN HIFZ CERTIFICATE', style: pw.TextStyle(font: engBold, fontSize: 16, color: salaamaBlue)),
                pw.Divider(thickness: 2, color: salaamaGold),
                pw.SizedBox(height: 20),
                pw.Text('تشهد إدارة المدرسة بأن الطالب/ة', style: pw.TextStyle(font: arabicReg, fontSize: 16)),
                pw.SizedBox(height: 12),
                pw.Text(student['fullName'] ?? '', style: pw.TextStyle(font: arabicBold, fontSize: 24, color: salaamaGreen)),
                pw.Text('ID: ${student['studentId']} | Class: ${student['class']}', style: pw.TextStyle(font: engBold, fontSize: 12)),
                pw.SizedBox(height: 15),
                pw.Text('قد أتم حفظ سورة ${surah} - الجزء ${juz} - بتقدير ${grade}', style: pw.TextStyle(font: arabicReg, fontSize: 14), textAlign: pw.TextAlign.center),
                pw.SizedBox(height: 10),
                pw.Text('Completed Hifz of Surah $surah - Juz $juz - Grade $grade', style: pw.TextStyle(font: engBold, fontSize: 12)),
                pw.SizedBox(height: 30),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [pw.Text('___________', style: pw.TextStyle(font: arabicReg)), pw.Text('الشيخ المحفظ', style: pw.TextStyle(font: arabicReg, fontSize: 10))]),
                  pw.Column(children: [pw.Text('___________', style: pw.TextStyle(font: arabicReg)), pw.Text('مدير المدرسة', style: pw.TextStyle(font: arabicReg, fontSize: 10))]),
                ]),
                pw.SizedBox(height: 20),
                pw.Text('بارك الله فيه وجعله من أهل القرآن الذين هم أهل الله وخاصته', style: pw.TextStyle(font: arabicBold, fontSize: 12, color: salaamaGreen), textAlign: pw.TextAlign.center),
              ],
            ),
          );
        },
      ),
    );

    await _saveAndShare(pdf, 'Hifz_${student['studentId']}_${surah}.pdf', 'Hifz Certificate');
  }

  // ================= HELPERS =================
  static bool isTheologySubject(String name) {
    final n = name.toLowerCase();
    return n.contains('quran') || n.contains('fiqh') || n.contains('tarbiah') || n.contains('tauhid') || n.contains('siirah') || n.contains('hadith') || n.contains('lugha') || n.contains('arabic');
  }

  static pw.Widget _idRow(String label, String value, bool isArabic, pw.Font arFont, pw.Font bold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(children: [
        pw.Expanded(flex: 2, child: pw.Text('$label:', style: pw.TextStyle(font: isArabic ? arFont : bold, fontSize: 9, fontWeight: pw.FontWeight.bold))),
        pw.Expanded(flex: 3, child: pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 9))),
      ]),
    );
  }

  static pw.Widget _marksTable(List<MapEntry<String, dynamic>> entries, bool isArabic, pw.Font arFont, pw.Font arBold, pw.Font enFont, pw.Font enBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF5F5F5)), children: [
          _cell(isArabic ? 'المادة' : 'Subject', true, isArabic ? arBold : enBold),
          _cell(isArabic ? 'الدرجة' : 'Marks', true, enBold),
          _cell(isArabic ? 'التقدير' : 'Grade', true, enBold),
        ]),
        ...entries.map((e) => pw.TableRow(children: [
          _cell(isArabic ? _arabicName(e.key) : e.key, false, isArabic ? arFont : enFont),
          _cell('${e.value}', false, enFont),
          _cell(_grade(e.value as int), false, enFont),
        ])),
      ],
    );
  }

  static pw.Widget _cell(String text, bool header, pw.Font font) {
    return pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: header ? 9 : 8, fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal)));
  }

  static String _grade(int m) {
    if (m >= 80) return 'ممتاز E';
    if (m >= 70) return 'جيد جدا VG';
    if (m >= 60) return 'جيد G';
    if (m >= 50) return 'مقبول P';
    return 'راسب F';
  }

  static String _overallGrade(Map<String, dynamic> marks) {
    final avg = marks.values.fold<int>(0, (a, b) => a + (b as int)) / marks.length;
    return _grade(avg.round());
  }

  static String _arabicName(String en) {
    const map = {'Quran': 'القرآن', 'Quran - Hifz': 'القرآن - حفظ', 'Quran - Tafsir': 'القرآن - تفسير', 'Quran - Tajwid': 'القرآن - تجويد', 'Fiqh': 'الفقه', 'Tarbiah - Tauhid': 'التربية - التوحيد', 'Tarbiah - Siirah': 'التربية - السيرة', 'Tarbiah - Hadith': 'التربية - الحديث', 'Arabic': 'العربية', 'Lugha': 'اللغة', 'English': 'الإنجليزية', 'Mathematics': 'الرياضيات', 'Science': 'العلوم', 'SST': 'الاجتماعيات'};
    return map[en] ?? en;
  }

  static Future<void> _saveAndShare(pw.Document pdf, String fileName, String title) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
    try { await Share.shareXFiles([XFile(file.path)], text: '$title - Salaama Muslim Junior School - Destined to Succeed\n$fileName'); } catch (_) {}
  }

  // PNG from Widget
  static Future<void> widgetToPng(GlobalKey key, String fileName) async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName.png');
    await file.writeAsBytes(pngBytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Salaama PNG: $fileName');
  }
}
