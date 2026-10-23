import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      {"icon": Icons.person, "title": "My Child", "subtitle": "Profile", "color": Color(0xFFEF6C00)},
      {"icon": Icons.payments, "title": "Fees & Payments", "subtitle": "Balance: View", "color": Color(0xFFEF6C00)},
      {"icon": Icons.bar_chart, "title": "Results & Reports", "color": Color(0xFF1565C0)},
      {"icon": Icons.how_to_reg, "title": "Attendance View", "subtitle": "At School", "color": Color(0xFF2E7D32)},
      {"icon": Icons.menu_book, "title": "Tahfiizu Progress", "subtitle": "Darsu | Sitta | Muraaji'a", "color": Color(0xFF00897B)},
      {"icon": Icons.schedule, "title": "Timetable", "color": Color(0xFFEF6C00)},
      {"icon": Icons.chat_bubble, "title": "Chat with Admin", "color": Color(0xFF0D47A1)},
      {"icon": Icons.groups, "title": "Group Chat For All", "color": Color(0xFF0D47A1)},
      {"icon": Icons.video_library, "title": "Public Media", "subtitle": "School Videos & Audios", "color": Color(0xFFD32F2F)},
      {"icon": Icons.picture_as_pdf, "title": "Documents", "subtitle": "Forms, Circulars, Receipts PDF/PNG", "color": Color(0xFFD32F2F)},
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(backgroundColor: Color(0xFFEF6C00), title: Text("Parent Dashboard", style: TextStyle(color: Colors.white)), actions: [IconButton(icon: Icon(Icons.logout, color: Colors.white), onPressed: ()=>Navigator.popUntil(context, (r)=>r.isFirst))]),
      body: Column(
        children: [
          SizedBox(height: 16),
          Icon(Icons.family_restroom, size: 60, color: Color(0xFF1976D2)),
          Text("Welcome parent@gmail.com", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Your child's info will be here", style: TextStyle(color: Colors.grey, fontSize: 12)),
          SizedBox(height: 12),
          Expanded(child: Padding(padding: EdgeInsets.all(12), child: GridView.builder(
            itemCount: menus.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.15, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemBuilder: (ctx,i){
              var m=menus[i];
              return InkWell(
                onTap: (){},
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: (m["color"] as Color).withOpacity(0.12), shape: BoxShape.circle), child: Icon(m["icon"] as IconData, color: m["color"] as Color, size: 28)),
                    SizedBox(height: 6),
                    Text(m["title"] as String, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                    if (m["subtitle"]!=null) Text(m["subtitle"] as String, textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600)),
                  ]),
                ),
              );
            },
          ))),
        ],
      ),
    );
  }
}