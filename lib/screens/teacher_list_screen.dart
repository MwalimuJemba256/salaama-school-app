import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});
  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5A2D),
        title: const Text('Teachers - Salaama', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(controller: _tab, labelColor: Colors.white, unselectedLabelColor: Colors.white70, indicatorColor: Colors.white, tabs: const [Tab(text: 'ALL'), Tab(text: 'SECULAR'), Tab(text: 'THEOLOGY')]),
      ),
      body: TabBarView(controller: _tab, children: ['All', 'Secular', 'Theology'].map((type) => StreamBuilder<QuerySnapshot>(
        stream: type == 'All' ? FirebaseFirestore.instance.collection('teachers').snapshots() : FirebaseFirestore.instance.collection('teachers').where('teacherType', isEqualTo: type).snapshots(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No $type Teachers Yet'));
          return ListView.builder(itemCount: docs.length, itemBuilder: (ctx, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final isTheo = d['teacherType'] == 'Theology';
            return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: ListTile(
              leading: CircleAvatar(backgroundColor: isTheo ? const Color(0xFF1E3A8A).withOpacity(0.1) : const Color(0xFF0D5A2D).withOpacity(0.1), child: Icon(Icons.person, color: isTheo ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D))),
              title: Text(d['fullName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${d['teacherType']} • ${d['subjects']?.join(', ') ?? ''}\nQuran: Hifz/Tafsir/Tajwid, Tarbia: Tauhid/Siirah/Hadith'.substring(0, 60)),
              trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isTheo ? const Color(0xFF1E3A8A) : const Color(0xFF0D5A2D), borderRadius: BorderRadius.circular(6)), child: Text(d['teacherType'], style: const TextStyle(color: Colors.white, fontSize: 10))),
            ));
          });
        },
      )).toList()),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF0D5A2D), onPressed: () => Navigator.pushNamed(context, '/register_child'), child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
