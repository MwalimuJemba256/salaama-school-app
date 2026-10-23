import 'package:flutter/material.dart';
import 'Admin/tahfiizu_dashboard.dart';
import 'Admin/students_management_screen.dart';
import 'Admin/teachers_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      {"icon": Icons.dashboard, "title": "Dashboard", "color": Color(0xFF1565C0)},
      {"icon": Icons.school, "title": "Students", "subtitle": "Filter: Secular/Theology/Tahfiizu", "color": Color(0xFF0D47A1), "page": const StudentsManagementScreen()},
      {"icon": Icons.groups, "title": "Teachers", "subtitle": "Secular | Theology | Tahfiizu", "color": Color(0xFF6A1B9A), "page": const TeachersManagementScreen()},
      {"icon": Icons.receipt_long, "title": "Fees & Receipts", "color": Color(0xFF1565C0)},
      {"icon": Icons.work, "title": "Teachers Salary", "color": Color(0xFF1565C0)},
      {"icon": Icons.assessment, "title": "Reports", "color": Color(0xFF1565C0)},
      {"icon": Icons.settings, "title": "School Settings", "color": Color(0xFF1565C0)},
      {"icon": Icons.show_chart, "title": "Cash Flow with Graph", "color": Color(0xFF1565C0)},
      {"icon": Icons.chat_bubble, "title": "Chat Box", "subtitle": "Admin-Parent-Teacher", "color": Color(0xFF1565C0)},
      {"icon": Icons.photo_library, "title": "Media Library", "subtitle": "Public Videos & Audios", "color": Color(0xFFD32F2F)},
      {"icon": Icons.picture_as_pdf, "title": "PDF Generator", "subtitle": "Forms, Circulars, Receipts PNG/PDF", "color": Color(0xFFD32F2F)},
      {"icon": Icons.menu_book, "title": "Tahfiizu Dashboard", "subtitle": "Darsu | Sitta | Muraaji'a", "color": Color(0xFF2E7D32), "highlight": true, "page": const TahfiizuDashboard()},
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(backgroundColor: Color(0xFF0D47A1), title: Text("Admin Dashboard - Salaama", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: menus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.15, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemBuilder: (ctx, i) {
            var m = menus[i];
            return _card(icon: m["icon"], title: m["title"], subtitle: m["subtitle"], color: m["color"], highlight: m["highlight"]==true, onTap: (){
              if(m["page"]!=null) Navigator.push(ctx, MaterialPageRoute(builder: (_)=> m["page"] as Widget));
            });
          },
        ),
      ),
    );
  }

  Widget _card({required IconData icon, required String title, String? subtitle, required Color color, bool highlight=false, required VoidCallback onTap}){
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(decoration: BoxDecoration(color: highlight?Color(0xFFE8F5E9):Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: highlight?color:Colors.grey.shade200, width: highlight?2:1)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(icon, size: 30, color: color)), SizedBox(height: 6), Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), if(subtitle!=null) Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)))])));
  }
}