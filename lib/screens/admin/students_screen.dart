import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SalaamaAppBar(title: "Students", backgroundColor: Color(0xFF0D47A1)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No students yet\nClick + to add", textAlign: TextAlign.center));
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text((data['name'] ?? 'S')[0].toString().toUpperCase())),
                  title: Text(data['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Class: ${data['class'] ?? ''} | Age: ${data['age'] ?? ''}\nParent: ${data['parentPhone'] ?? ''}"),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => docs[i].reference.delete()),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController(text: "Denise");
    final classCtrl = TextEditingController(text: "P5");
    final ageCtrl = TextEditingController(text: "14");
    final phoneCtrl = TextEditingController(text: "+256751489883");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Student"),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name *", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: classCtrl, decoration: const InputDecoration(labelText: "Class (P1-P7)", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Parent Phone", border: OutlineInputBorder()), keyboardType: TextInputType.phone),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name is required!"), backgroundColor: Colors.red));
                return;
              }
              try {
                await FirebaseFirestore.instance.collection('students').add({
                  'name': nameCtrl.text.trim(),
                  'class': classCtrl.text.trim(),
                  'age': int.tryParse(ageCtrl.text) ?? 0,
                  'parentPhone': phoneCtrl.text.trim(),
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${nameCtrl.text} Saved!"), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
