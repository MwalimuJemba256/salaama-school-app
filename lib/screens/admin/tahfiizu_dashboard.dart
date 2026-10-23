import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TahfiizuDashboard extends StatelessWidget {
  const TahfiizuDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahfiizu Dashboard'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مدرسة التحفيظ', 
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Darsu | Sittah | Muraaji\'a System',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _statCard('Total Hufaadhu', '0', Icons.people, Colors.green),
                _statCard('Darsu Today', '0', Icons.menu_book, Colors.blue),
                _statCard('Sittah Pending', '0', Icons.pending, Colors.orange),
                _statCard('Muraaji\'a Done', '0', Icons.check_circle, Colors.teal),
              ],
            ),
            const SizedBox(height: 20),

            // Action Buttons
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _actionBtn(context, 'Add Darsu', Icons.add, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _actionBtn(context, 'Sittah Check', Icons.list_alt, Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _actionBtn(context, 'Muraaji\'a', Icons.replay, Colors.purple)),
                const SizedBox(width: 12),
                Expanded(child: _actionBtn(context, 'Reports', Icons.bar_chart, Colors.orange)),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Activity
            const Text('Recent Hifz Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('tahfiizu_records').limit(10).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No records yet - Add first Darsu!')));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Card(
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text('No Tahfiizu records yet'),
                      subtitle: Text('Start by adding Darsu for students'),
                    ),
                  );
                }
                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(doc['studentName'] ?? 'Student'),
                        subtitle: Text(doc['type'] ?? 'Darsu'),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _actionBtn(BuildContext context, String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title - Coming Soon In shaa Allah')));
      },
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
