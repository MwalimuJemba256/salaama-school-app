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
  // SALAAMA COLORS
  static const salaamaGreen = PdfColor.fromInt(0xFF0D5A2D);
  static const salaamaBlue = PdfColor.fromInt(0xFF1E3A8A);

  // Generate STUDENT ID CARD - English & Arabic
  static Future<void> generateStudentIdCard({
    required Map<String, dynamic> student,
    required bool isArabic,
    required bool asPdf, // true=PDF, false=PNG via screenshot
  }) async {
    final pdf = pw.Document();
    
    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.amiriRegular();
    final arabicBold = await PdfGoogleFonts.amiriBold();
    final englishFont = await PdfGoogleFonts.poppinsRegular();
    final englishBold = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: salaamaGreen, width: 3),
              borderRadius: pw.BorderRadius.circular(15),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header - Salaama
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      isArabic ? 'مدرسة سلاما الإسلامية' : 'SALAAMA MUSLIM JUNIOR SCHOOL',
                      style: pw.TextStyle(
                        font: isArabic ? arabicBold : englishBold,
                        fontSize: 22,
                        color: salaamaGreen,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  isArabic ? 'مصيرها النجاح' : 'DESTINED TO SUCCEED',
                  style: pw.TextStyle(font: isArabic ? arabicFont : englishFont, fontSize: 12),
                ),
                pw.Divider(color: salaamaGreen, thickness: 2),
                pw.SizedBox(height: 20),

                // Photo Placeholder
                pw.Container(
                  width: 120,
                  height: 120,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: salaamaGreen, width: 2),
                  ),
                  child: pw.Center(child: pw.Text(isArabic ? 'صورة' : 'PHOTO', style: pw.TextStyle(font: englishFont))),
                ),
                pw.SizedBox(height: 20),

                // Details
                _buildInfoRow('Student ID:', student['studentId'], isArabic ? 'رقم الطالب:' : 'Student ID:', isArabic, arabicFont, englishFont, englishBold),
                _buildInfoRow('Name:', student['fullName'], isArabic ? 'الاسم:' : 'Name:', isArabic, arabicFont, englishFont, englishBold),
                _buildInfoRow('Class:', student['class'], isArabic ? 'الفصل:' : 'Class:', isArabic, arabicFont, englishFont, englishBold),
                _buildInfoRow('Parent:', student['parentName'], isArabic ? 'ولي الأمر:' : 'Parent:', isArabic, arabicFont, englishFont, englishBold),

                pw.Spacer(),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  color: salaamaGreen,
                  child: pw.Center(
                    child: pw.Text(
                      isArabic ? 'بطاقة الطالب - 2026' : 'STUDENT ID CARD - 2026',
                      style: pw.TextStyle(font: isArabic ? arabicBold : englishBold, color: PdfColors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await _saveAndShare(pdf, 'ID_${student['studentId']}_${isArabic ? 'AR' : 'EN'}.pdf');
  }

  // Generate REPORT CARD - Theology with Arabic
  static Future<void> generateReportCard({
    required Map<String, dynamic> student,
    required Map<String, dynamic> marks, // {'Quran': 85, 'Tauhid': 90...}
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
            children: [
              // Header
              pw.Container(
                color: salaamaGreen,
                padding: const pw.EdgeInsets.all(12),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      isArabic ? 'تقرير الطالب - علوم شرعية' : 'THEOLOGY REPORT CARD',
                      style: pw.TextStyle(font: isArabic ? arabicBold : engBold, color: PdfColors.white, fontSize: 18),
                    ),
                    pw.Text(
                      'SALAAMA',
                      style: pw.TextStyle(font: engBold, color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text('${student['fullName']} - ${student['class']}', style: pw.TextStyle(font: engBold, fontSize: 16)),
              pw.SizedBox(height: 15),

              // Marks Table
              pw.Table(
                border: pw.TableBorder.all(color: salaamaGreen, width: 1),
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE8F5E9)),
                    children: [
                      _tableCell(isArabic ? 'المادة' : 'Subject', true, isArabic ? arabicBold : engBold),
                      _tableCell(isArabic ? 'الدرجة' : 'Marks', true, isArabic ? arabicBold : engBold),
                      _tableCell(isArabic ? 'التقدير' : 'Grade', true, isArabic ? arabicBold : engBold),
                    ],
                  ),
                  // Subjects
                  ...marks.entries.map((e) {
                    final subjectArabic = _getArabicName(e.key);
                    return pw.TableRow(
                      children: [
                        _tableCell(isArabic ? subjectArabic : e.key, false, isArabic ? arabicFont : engFont),
                        _tableCell('${e.value}', false, engFont),
                        _tableCell(_getGrade(e.value), false, engFont),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                isArabic ? 'بارك الله فيكم' : 'May Allah Bless You',
                style: pw.TextStyle(font: isArabic ? arabicBold : engBold, fontSize: 14, color: salaamaGreen),
              ),
            ],
          );
        },
      ),
    );

    await _saveAndShare(pdf, 'Report_${student['studentId']}_${isArabic ? 'AR' : 'EN'}.pdf');
  }

  // Generate QURAN HIFZ CERTIFICATE - Arabic
  static Future<void> generateHifzCertificate({
    required Map<String, dynamic> student,
    required String surah,
    required String juz,
  }) async {
    final pdf = pw.Document();
    final arabicBold = await PdfGoogleFonts.amiriBold();
    final arabicRegular = await PdfGoogleFonts.amiriRegular();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: salaamaGreen, width: 5),
            ),
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('شهادة حفظ القرآن', style: pw.TextStyle(font: arabicBold, fontSize: 32, color: salaamaGreen)),
                pw.SizedBox(height: 20),
                pw.Text('تشهد مدرسة سلاما الإسلامية بأن الطالب/ة', style: pw.TextStyle(font: arabicRegular, fontSize: 18)),
                pw.SizedBox(height: 15),
                pw.Text(student['fullName'], style: pw.TextStyle(font: arabicBold, fontSize: 26)),
                pw.SizedBox(height: 15),
                pw.Text('قد أتم حفظ ${surah} - الجزء ${juz}', style: pw.TextStyle(font: arabicRegular, fontSize: 18)),
                pw.SizedBox(height: 30),
                pw.Text('بارك الله فيه وجعله من أهل القرآن', style: pw.TextStyle(font: arabicBold, fontSize: 16, color: salaamaGreen)),
              ],
            ),
          );
        },
      ),
    );

    await _saveAndShare(pdf, 'Hifz_${student['studentId']}_$surah.pdf');
  }

  // Helper - Save, Share, Send
  static Future<void> _saveAndShare(pw.Document pdf, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    // Save to Downloads + Share
    await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
    
    // Also share via WhatsApp / etc
    await Share.shareXFiles([XFile(file.path)], text: 'Salaama Document: $fileName - Destined to Succeed');
  }

  static pw.Widget _tableCell(String text, bool isHeader, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: isHeader ? 12 : 11, fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal)),
    );
  }

  static pw.Widget _buildInfoRow(String labelEn, String value, String label, bool isArabic, pw.Font arFont, pw.Font enFont, pw.Font enBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(flex: 2, child: pw.Text(label, style: pw.TextStyle(font: isArabic ? arFont : enBold, fontSize: 12))),
          pw.Expanded(flex: 3, child: pw.Text(value, style: pw.TextStyle(font: enFont, fontSize: 12))),
        ],
      ),
    );
  }

  static String _getGrade(int marks) {
    if (marks >= 80) return 'ممتاز / Excellent';
    if (marks >= 70) return 'جيد جدا / V.Good';
    if (marks >= 60) return 'جيد / Good';
    return 'مقبول / Pass';
  }

  static String _getArabicName(String english) {
    const map = {
      'Quran': 'القرآن الكريم',
      'Arabic': 'اللغة العربية',
      'Fiqh': 'الفقه',
      'Tauhid': 'التوحيد',
      'Siirah': 'السيرة النبوية',
      'Hadith': 'الحديث الشريف',
      'Tarbiah - Tauhid': 'التربية - التوحيد',
      'Tarbiah - Siirah': 'التربية - السيرة',
      'Tarbiah - Hadith': 'التربية - الحديث',
    };
    return map[english] ?? english;
  }

  // PNG GENERATOR - Convert any widget to PNG
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
