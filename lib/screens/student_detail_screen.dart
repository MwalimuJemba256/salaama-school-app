import 'package:flutter/material.dart';
import '../services/document_service.dart';

class StudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> studentData;
  const StudentDetailScreen({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5A2D),
        title: Text(studentData['fullName'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PHOTO + INFO
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
                        image: studentData['photoUrl'] != '' && studentData['photoUrl'] != null ? DecorationImage(image: NetworkImage(studentData['photoUrl']), fit: BoxFit.cover) : null,
                        color: Colors.grey[200],
                      ),
                      child: studentData['photoUrl'] == '' || studentData['photoUrl'] == null ? const Icon(Icons.person, size: 50, color: Color(0xFF0D5A2D)) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(studentData['fullName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${studentData['studentId']} • ${studentData['class']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Parent: ${studentData['parentName'] ?? ''}', style: const TextStyle(fontSize: 11)),
                      Text('Phone: ${studentData['parentPhone'] ?? ''}', style: const TextStyle(fontSize: 11)),
                    ])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Align(alignment: Alignment.centerLeft, child: Text('GENERATE DOCUMENTS - 4 BUTTONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0D5A2D)))),
            const SizedBox(height: 10),

            // ===== 4 BUTTONS - UPDATED TO NEW SERVICE =====
            // Button 1 & 2 - ID EN + AR
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.badge, size: 18),
                    label: const Text('ID EN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D5A2D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      DocumentService.generateStudentIdCard(student: studentData, isArabic: false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Color(0xFF0D5A2D), content: Text('Generating ID English...')));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.badge, size: 18),
                    label: const Text('بطاقة عربي', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      DocumentService.generateStudentIdCard(student: studentData, isArabic: true);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Color(0xFF1E3A8A), content: Text('...جاري إنشاء البطاقة العربية')));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Button 3 - Report Card with Tarbiah Tauhid, Siirah, Hadith
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf, size: 20),
                label: const Text('Report Card - Tarbiah Report عربي', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  DocumentService.generateReportCard(
                    student: studentData,
                    marks: {
                      'English': 85,
                      'Mathematics': 90,
                      'Quran - Hifz': 95,
                      'Quran - Tafsir': 88,
                      'Quran - Tajwid': 92,
                      'Fiqh': 87,
                      'Tarbiah - Tauhid': 90,
                      'Tarbiah - Siirah': 85,
                      'Tarbiah - Hadith': 88,
                      'Lugha': 84,
                    },
                    term: 'Term 1',
                    isArabic: true,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating Theology Report... Tarbiah: Tauhid, Siirah, Hadith')));
                },
              ),
            ),
            const SizedBox(height: 10),

            // Button 4 - Hifz Certificate
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.workspace_premium, size: 20),
                label: const Text('Hifz Certificate - شهادة حفظ القرآن', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  DocumentService.generateHifzCertificate(
                    student: studentData,
                    surah: 'Al-Baqarah',
                    juz: '1',
                    grade: 'ممتاز',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Color(0xFFD4AF37), content: Text('Generating Hifz Certificate...')));
                },
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            Row(children: [
              Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.exit_to_app, color: Colors.red, size: 18), label: const Text('Leave Child', style: TextStyle(color: Colors.red, fontSize: 12)), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)), onPressed: () => Navigator.pushNamed(context, '/child_leave', arguments: studentData))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.edit, color: Color(0xFF0D5A2D), size: 18), label: const Text('Edit Info', style: TextStyle(color: Color(0xFF0D5A2D), fontSize: 12)), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0D5A2D))), onPressed: () {})),
            ]),
          ],
        ),
      ),
    );
  }
}
