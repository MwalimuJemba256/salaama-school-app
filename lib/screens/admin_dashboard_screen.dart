import 'package:flutter/material.dart';

// If Tahfiizu file exists, keep import - else comment it
// import 'admin/tahfiizu_dashboard.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menus = [
      // {"icon": Icons.menu_book, "title": "Tahfiizu Dashboard", "subtitle": "Darsu | Sitta | Muraaji'a", "color": const Color(0xFF2E7D32), "highlight": true, "page": const TahfiizuDashboard()},
      {"icon": Icons.people, "title": "Students", "subtitle": "Manage students", "color": const Color(0xFF1565C0), "page": null},
      {"icon": Icons.class_, "title": "Classes", "subtitle": "Manage classes", "color": const Color(0xFF6A1B9A), "page": null},
      {"icon": Icons.assessment, "title": "Reports", "subtitle": "View reports", "color": const Color(0xFFEF6C00), "page": null},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemCount: menus.length,
        itemBuilder: (context, i) {
          final m = menus[i];
          return _card(
            icon: m["icon"] as IconData,
            title: m["title"] as String,
            subtitle: m["subtitle"] as String,
            color: m["color"] as Color,
            highlight: m["highlight"] == true,
            onTap: () {
              if (m["page"] != null) Navigator.push(context, MaterialPageRoute(builder: (_) => m["page"]));
            },
          );
        },
      ),
    );
  }

  Widget _card({required IconData icon, required String title, String? subtitle, required Color color, bool highlight = false, VoidCallback? onTap}) {
    return Card(
      elevation: highlight ? 8 : 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
