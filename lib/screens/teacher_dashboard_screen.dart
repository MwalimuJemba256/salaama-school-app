import 'package:flutter/material.dart';
import 'Teacher/tahfiizu_entry_screen.dart';
import 'Teacher/timetable_add_screen.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assume teacher type comes from login - for now we show both but Tahfiizu has NO classes
    final List<Map<String, dynamic>> teacherMenus = [
      // FOR SECULAR & THEOLOGY ONLY - HAS CLASSES
      {"icon": Icons.class_, "title": "My Classes", "subtitle": "Nursery, Middle, Top, P1-P7", "color": Color(0xFF2E7D32), "for": "secular_theology"},
      {"icon": Icons.people, "title": "My Students", "subtitle": "Nursery - P7", "color": Color(0xFF2E7D32), "for": "secular_theology"},
      {"icon": Icons.schedule, "title": "Add Timetable", "subtitle": "Nursery - P7 Only", "color": Color(0xFFEF6C00), "for": "secular_theology"},
      {"icon": Icons.grade, "title": "Gradebook", "subtitle": "Secular & Theology", "color": Color(0xFF2E7D32), "for": "secular_theology"},
      {"icon": Icons.menu_book_outlined, "title": "Lesson Plans", "color": Color(0xFF2E7D32), "for": "secular_theology"},
      {"icon": Icons.attach_money, "title": "Fees View Only", "color": Color(0xFF2E7D32), "for": "secular_theology"},

      // FOR TAHFIIZU - NO CLASSES
      {"icon": Icons.menu_book, "title": "Tahfiizu Daily", "subtitle": "Darsu | Darsu-Sitta | Omuraaji'a\nNO CLASSES", "color": Color(0xFF00897B), "highlight": true, "for": "tahfiizu"},
      {"icon": Icons.edit_note, "title": "Tahfiizu Entry", "subtitle": "Darsu Daily Entry", "color": Color(0xFF00897B), "highlight": true, "for": "tahfiizu"},

      // COMMON FOR ALL
      {"icon": Icons.category, "title": "Staff Type", "subtitle": "Secular | Theology | Tahfiizu", "color": Color(0xFF1565C0)},
      {"icon": Icons.support, "title": "Non-Teaching Staff", "color": Color(0xFF6A1B9A)},
      {"icon": Icons.calendar_today, "title": "Attendance", "color": Color(0xFF2E7D32)},
      {"icon": Icons.chat, "title": "Chat with Admin", "color": Color(0xFF0D47A1)},
      {"icon": Icons.groups, "title": "Group Chat All", "color": Color(0xFF0D47A1)},
      {"icon": Icons.video_library, "title": "Public Media", "subtitle": "Videos & Audios", "color": Color(0xFFD32F2F)},
      {"icon": Icons.picture_as_pdf, "title": "PDF/PNG Generator", "subtitle": "Forms & Receipts", "color": Color(0xFFD32F2F)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text("Teacher Dashboard", style: TextStyle(color: Colors.white)),
        actions: [IconButton(icon: Icon(Icons.logout, color: Colors.white), onPressed: () => Navigator.popUntil(context, (r) => r.isFirst))],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF2E7D32))),
            child: Row(
              children: [
                Icon(Icons.info, color: Color(0xFF2E7D32)),
                SizedBox(width: 8),
                Expanded(child: Text("Secular & Theology: Nursery, Middle, Top, P1-P7\nTahfiizu: No Classes - Only Quran", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)))),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: teacherMenus.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.1, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemBuilder: (ctx, i) {
                  var m = teacherMenus[i];
                  return _buildCard(icon: m["icon"], title: m["title"], subtitle: m["subtitle"], color: m["color"], highlight: m["highlight"]==true, onTap: () {
                    if (m["title"] == "Tahfiizu Entry") Navigator.push(ctx, MaterialPageRoute(builder: (_) => const TahfiizuEntryScreen()));
                    if (m["title"] == "Add Timetable") Navigator.push(ctx, MaterialPageRoute(builder: (_) => const TimetableAddScreen()));
                    if (m["title"] == "Tahfiizu Daily") {
                      showDialog(context: ctx, builder: (_) => AlertDialog(
                        title: Text("Tahfiizu Daily - NO CLASSES"),
                        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("1. Darsu: Memorized part from Quran daily"),
                          SizedBox(height: 8),
                          Text("2. Darsu-Sitta: Revision of 6 last memorized lessons"),
                          SizedBox(height: 8),
                          Text("3. Omuraaji'a: Constant revision daily"),
                        ]),
                        actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: Text("OK"))],
                      ));
                    }
                    if (m["title"] == "Staff Type") {
                      showDialog(context: ctx, builder: (_) => AlertDialog(
                        title: Text("Teaching Staff Categories"),
                        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("• Secular: Nursery, Middle, Top, P1-P7", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("• Theology: Nursery, Middle, Top, P1-P7", style: TextStyle(fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("• Tahfiizu: NO CLASSES", style: TextStyle(color: Color(0xFF00897B), fontWeight: FontWeight.bold)),
                          Text("  Teaches Darsu, Darsu-Sitta, Omuraaji'a"),
                        ]),
                        actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: Text("OK"))],
                      ));
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, String? subtitle, required Color color, bool highlight=false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(color: highlight?Color(0xFFE0F2F1):Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: highlight?color:Colors.grey.shade200, width: highlight?2:1), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(icon, color: color, size: 26)),
          SizedBox(height: 6),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          if (subtitle!=null) Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.grey.shade700))),
        ]),
      ),
    );
  }
}