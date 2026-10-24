import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../widgets/salaama_app_bar.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SalaamaAppBar(title: "Teachers", backgroundColor: Color(0xFF2E7D32)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(context),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('teachers').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No teachers yet. Click + to add!"));
          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, i) {
              final data = docs[i].data();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: const Color(0xFF2E7D32), child: Text((data['name'] ?? 'T')[0], style: const TextStyle(color: Colors.white))),
                  title: Text(data['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${data['subject'] ?? ''} | ${data['phone'] ?? ''}\n${data['email'] ?? ''}"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => docs[i].reference.delete()),
                    ],
                  ),
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
    final subjectCtrl = TextEditingController(text: "Mathematics");
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Teacher"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name *", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: "Subject (Math, English, Quran)", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone Number", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Login Email (teacher@salaama.com)", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: salaryCtrl, decoration: const InputDecoration(labelText: "Salary UGX", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              try {
                // 1. FIXED: Create teacher account WITHOUT logging out admin
                String? teacherUid;
                if (emailCtrl.text.trim().isNotEmpty) {
                  try {
                    // Use secondary Firebase app so admin stays logged in
                    FirebaseApp secondaryApp = await Firebase.initializeApp(
                      name: 'secondary-${DateTime.now().millisecondsSinceEpoch}',
                      options: Firebase.app().options,
                    );
                    UserCredential cred = await FirebaseAuth.instanceFor(app: secondaryApp)
                        .createUserWithEmailAndPassword(
                            email: emailCtrl.text.trim(),
                            password: "salaama123");
                    teacherUid = cred.user?.uid;
                    await secondaryApp.delete();
                  } catch (e) {
                    debugPrint("Auth create error (may already exist): $e");
                  }
                }
                
                // 2. Add to teachers collection - LIMITLESS
                await FirebaseFirestore.instance.collection('teachers').add({
                  'name': nameCtrl.text.trim(),
                  'subject': subjectCtrl.text.trim(),
                  'phone': phoneCtrl.text.trim(),
                  'email': emailCtrl.text.trim(),
                  'salary': salaryCtrl.text.trim(),
                  'uid': teacherUid ?? '',
                  'createdAt': FieldValue.serverTimestamp(),
                });

                // 3. Add to users collection for Role based rules (staff)
                if (teacherUid != null) {
                  await FirebaseFirestore.instance.collection('users').doc(teacherUid).set({
                    'email': emailCtrl.text.trim(),
                    'name': nameCtrl.text.trim(),
                    'role': 'staff',
                    'subject': subjectCtrl.text.trim(),
                    'phone': phoneCtrl.text.trim(),
                    'createdAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));
                } else if (emailCtrl.text.trim().isNotEmpty) {
                  // Fallback if UID not got
                  await FirebaseFirestore.instance.collection('users').doc(emailCtrl.text.trim()).set({
                    'email': emailCtrl.text.trim(),
                    'name': nameCtrl.text.trim(),
                    'role': 'staff',
                    'subject': subjectCtrl.text.trim(),
                    'phone': phoneCtrl.text.trim(),
                    'createdAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));
                }

                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Teacher Added! Email: ${emailCtrl.text.trim()} | Pass: salaama123"),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 4),
                  ),
                );
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
