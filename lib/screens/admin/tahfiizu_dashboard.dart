import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TahfiizuDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tahfiizu Dashboard - Admin View"), backgroundColor: Color(0xFF0B3D91)),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("tahfiizu_records").orderBy("date", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data();
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(d["studentName"] ?? "Student"),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Darsu: ${d["darsu"]}"),
                    Text("Sitta: ${d["darsu_sitta"]}"),
                    Text("Muraaja: ${d["muraaja"]}"),
                  ]),
                  trailing: Icon(Icons.book, color: Color(0xFF7AC74F)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
