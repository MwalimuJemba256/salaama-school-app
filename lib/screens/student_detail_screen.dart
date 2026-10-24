import 'package:flutter/material.dart';
import '../services/document_service.dart'; // Import document service

class StudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> studentData; // Comes from student list
  const StudentDetailScreen({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5A2D),
        title: Text(studentData['fullName'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // STUDENT PHOTO + INFO CARD
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0D5A2D), width: 3),
                        image: studentData['photoUrl'] != '' && studentData['photoUrl'] != null
                            ? DecorationImage(image: NetworkImage(studentData['photoUrl']), fit: BoxFit.cover)
                            : null,
                        color: Colors.grey[200],
                      ),
                      child: studentData['photoUrl'] == '' || studentData['photoUrl'] == null
                          ? const Icon(Icons.person, size: 50, color: Color(0xFF0D5A2D))
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(studentData['fullName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('${studentData['studentId']} • ${studentData['class']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                          Text('Parent: ${studentData['parentName']}', style: const TextStyle(fontSize: 12)),
                          Text('Phone: ${studentData['parentPhone']}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ===== HERE - PASTE THE BUTTONS - STEP 4 CODE =====
            const Align(alignment: Alignment.centerLeft, child: Text('GENERATE DOCUMENTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0D5A2D)))),
            const SizedBox(height: 10),

            // ID CARD BUTTONS - ENGLISH + ARABIC
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: const Text('ID EN', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D5A2D), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () => DocumentService.generateStudentIdCard(
                      student: studentData,
                      isArabic: false,
                      asPdf: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: const Text('بطاقة عربي', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () => DocumentService.generateStudentIdCard(
                      student: studentData,
                      isArabic: true,
                      asPdf: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // REPORT CARD - CORRECTED WITH QURAN HIFZ/TAFSIR/TAJWID + TARBIA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.school),
                label: const Text('Theology Report - عربي - Quran Hifz/Tafsir/Tajwid + Tarbia'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => DocumentService.generateReportCard(
                  student: studentData,
                  marks: {
                    'Quran - Hifz': 95,
                    'Quran - Tafsir': 88,
                    'Quran - Tajwid': 92,
                    'Fiqh': 87,
                    'Tarbia - Tauhid': 90,
                    'Tarbia - Siirah': 85,
                    'Tarbia - Hadith': 88,
                    'Lugha': 84,
                  },
                  isArabic: true,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // HIFZ CERTIFICATE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.mosque),
                label: const Text('Hifz Certificate - شهادة حفظ'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => DocumentService.generateHifzCertificate(
                  student: studentData,
                  surah: 'Surah Al-Baqarah',
                  juz: 'Juz 1',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // OTHER ACTIONS
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.exit_to_app, color: Colors.red), label: const Text('Leave Child', style: TextStyle(color: Colors.red)), onPressed: () => Navigator.pushNamed(context, '/child_leave', arguments: studentData))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.edit, color: Color(0xFF0D5A2D)), label: const Text('Edit', style: TextStyle(color: Color(0xFF0D5A2D))), onPressed: () {})),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
