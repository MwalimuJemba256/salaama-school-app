import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students - Salaama"), backgroundColor: const Color(0xFF0D47A1), foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(context),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No students yet. Click + to add!"));
          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, i) {
              final data = docs[i].data();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: const Color(0xFF0D47A1), child: Text((data['name'] ?? 'S')[0], style: const TextStyle(color: Colors.white))),
                  title: Text(data['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${data['class'] ?? ''} | ${data['parentPhone'] ?? ''}"),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => docs[i].reference.delete()),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final classCtrl = TextEditingController(text: "P5");
    final phoneCtrl = TextEditingController();
    final ageCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Student"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name *", border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: classCtrl, decoration: const InputDecoration(labelText: "Class (P1-P7)", border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Parent Phone", border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              await FirebaseFirestore.instance.collection('students').add({
                'name': nameCtrl.text.trim(),
                'class': classCtrl.text.trim(),
                'age': ageCtrl.text.trim(),
                'parentPhone': phoneCtrl.text.trim(),
                'createdAt': FieldValue.serverTimestamp(),
              });
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Student Added! MashaAllah"), backgroundColor: Colors.green));
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
