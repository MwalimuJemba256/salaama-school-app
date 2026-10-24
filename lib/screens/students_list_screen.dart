import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF0D5A2D), title: const Text('Students - Salaama', style: TextStyle(color: Colors.white))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').where('status', isEqualTo: 'Active').snapshots(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(backgroundImage: data['photoUrl'] != '' ? NetworkImage(data['photoUrl']) : null, child: data['photoUrl'] == '' ? const Icon(Icons.person) : null),
                title: Text(data['fullName']),
                subtitle: Text('${data['studentId']} • ${data['class']}'),
                onTap: () => Navigator.pushNamed(context, '/student_detail', arguments: data), // HERE - Opens detail with PDF buttons!
              );
            },
          );
        },
      ),
    );
  }
}
