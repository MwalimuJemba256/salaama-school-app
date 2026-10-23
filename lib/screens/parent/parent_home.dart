import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentChildrenScreen extends StatelessWidget {
  const ParentChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text("My Children"), backgroundColor: const Color(0xFF6A1B9A), foregroundColor: Colors.white),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          // For now show all students, later filter by parentEmail
          // TODO: Link parentEmail to student
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No children linked\nAsk Admin to add your phone to student record"));
          
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: const Color(0xFF6A1B9A), child: Text((data['name'] ?? 'C')[0], style: const TextStyle(color: Colors.white))),
                  title: Text(data['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Class: ${data['class'] ?? ''}\nParent Phone: ${data['parentPhone'] ?? ''}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParentChildDetailScreen(studentName: data['name'], className: data['class']))),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6A1B9A),
        icon: const Icon(Icons.link, color: Colors.white),
        label: const Text("Link Child", style: TextStyle(color: Colors.white)),
        onPressed: () => _showLinkDialog(context),
      ),
    );
  }

  void _showLinkDialog(BuildContext context) {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Link Your Child"),
        content: TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: "Enter Student Name or ID", border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ask Admin to add your email to student record in Firestore"), backgroundColor: Colors.purple));
            },
            child: const Text("Link", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ParentChildDetailScreen extends StatelessWidget {
  final String studentName;
  final String className;
  const ParentChildDetailScreen({super.key, required this.studentName, required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(studentName), backgroundColor: const Color(0xFF6A1B9A), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF6A1B9A), borderRadius: BorderRadius.circular(16)),
              child: Column(children: [const Icon(Icons.child_care, color: Colors.white, size: 48), const SizedBox(height: 8), Text(studentName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text(className, style: const TextStyle(color: Colors.white70))]),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildMiniCard(context, Icons.payments, "Fees", "View Balance", Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParentFeesScreen(studentName: studentName)))),
                _buildMiniCard(context, Icons.fact_check, "Attendance", "95% Present", Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParentAttendanceScreen(studentName: studentName)))),
                _buildMiniCard(context, Icons.menu_book, "Tahfiizu", "Quran Progress", const Color(0xFF00695C), () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParentTahfiizuScreen(studentName: studentName)))),
                _buildMiniCard(context, Icons.quiz, "Exams", "View Results", Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParentExamsScreen(studentName: studentName)))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCard(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color), const Spacer(), Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(subtitle, style: TextStyle(color: color, fontSize: 11))]),
      ),
    );
  }
}

class ParentFeesScreen extends StatelessWidget {
  final String studentName;
  const ParentFeesScreen({super.key, required this.studentName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$studentName - Fees"), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('fees_payments').where('studentName', isEqualTo: studentName).snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No fees payments yet"));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final bal = d['balance'] ?? 0;
              return Card(child: ListTile(leading: CircleAvatar(backgroundColor: bal <= 0 ? Colors.green : Colors.orange, child: Icon(bal <= 0 ? Icons.check : Icons.warning, color: Colors.white)), title: Text("${d['term']} - UGX ${d['paidAmount']}"), subtitle: Text("Balance: UGX $bal | ${d['paymentMethod']}")));
            },
          );
        },
      ),
    );
  }
}

class ParentAttendanceScreen extends StatelessWidget {
  final String studentName;
  const ParentAttendanceScreen({super.key, required this.studentName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$studentName - Attendance"), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('attendance').where('studentName', isEqualTo: studentName).orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No attendance records yet"));
          final present = docs.where((d) => d.data()['isPresent'] == true).length;
          final percent = docs.isEmpty ? 0 : (present / docs.length * 100).toStringAsFixed(1);
          return Column(
            children: [
              Container(width: double.infinity, padding: const EdgeInsets.all(20), color: Colors.teal.shade50, child: Column(children: [Text("$percent% Present", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal)), Text("$present/${docs.length} days present")])),
              Expanded(child: ListView.builder(padding: const EdgeInsets.all(8), itemCount: docs.length, itemBuilder: (context, i) { final d = docs[i].data(); final isP = d['isPresent'] == true; return ListTile(leading: Icon(isP ? Icons.check_circle : Icons.cancel, color: isP ? Colors.green : Colors.red), title: Text(d['date'] ?? ''), subtitle: Text(d['status'] ?? ''), trailing: Text(d['className'] ?? '', style: const TextStyle(fontSize: 11))); })),
            ],
          );
        },
      ),
    );
  }
}

class ParentTahfiizuScreen extends StatelessWidget {
  final String studentName;
  const ParentTahfiizuScreen({super.key, required this.studentName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$studentName - Tahfiizu"), backgroundColor: const Color(0xFF00695C), foregroundColor: Colors.white),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tahfiizu_records').where('studentName', isEqualTo: studentName).orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No Tahfiizu progress yet\nMashaAllah child will start soon", textAlign: TextAlign.center));
          return ListView.builder(padding: const EdgeInsets.all(12), itemCount: docs.length, itemBuilder: (context, i) { final d = docs[i].data(); return Card(child: ListTile(leading: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)), child: Text(d['type'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))), title: Text("Surah ${d['surah']} | Ayah ${d['fromAyah']}-${d['toAyah']}"), subtitle: Text("Juz ${d['juz']} | Grade: ${d['grade']} | Sheikh: ${d['sheikhName']}\nDate: ${d['date']}"))); });
        },
      ),
    );
  }
}

class ParentExamsScreen extends StatelessWidget {
  final String studentName;
  const ParentExamsScreen({super.key, required this.studentName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$studentName - Exams"), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('exam_results').where('studentName', isEqualTo: studentName).orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No exam results yet"));
          return ListView.builder(padding: const EdgeInsets.all(12), itemCount: docs.length, itemBuilder: (context, i) { final d = docs[i].data(); return Card(child: ExpansionTile(title: Text("${d['term']} - ${d['examType']}", style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text("Total: ${d['total']} | Avg: ${(d['average'] ?? 0).toStringAsFixed(1)}"), children: [Padding(padding: const EdgeInsets.all(12), child: Wrap(spacing: 8, children: ["English", "Mathematics", "Science", "SST", "Quran", "Fiqh", "Arabic", "Tahfiizu"].map((sub) => Chip(label: Text("$sub: ${d[sub] ?? 0}", style: const TextStyle(fontSize: 11)))).toList()))])); });
        },
      ),
    );
  }
}
