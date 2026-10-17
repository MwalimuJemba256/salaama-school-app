import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard - Live 275"), backgroundColor: Color(0xFF2196F3)),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFFE3F2FD),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCount("Secular", "120", Colors.blue),
                _buildCount("Arabic", "95", Colors.green),
                _buildCount("Quran", "60", Colors.orange),
                _buildCount("Total", "275", Color(0xFF2196F3)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Live Cooperation - Teachers Teaching Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('lessons_log').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: Text("No live classes - Demo Mode"));
                if (snapshot.data!.docs.isEmpty) return Center(child: Text("No lessons yet. Teachers start class to appear here."));
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.green, radius: 6),
                        title: Text("${doc['teacherName']} - ${doc['class']}"),
                        subtitle: Text("${doc['section']} | ${doc['subject']} | ${doc['topic']}"),
                        trailing: Text("${doc['timestamp'].toDate().hour}:${doc['timestamp'].toDate().minute}"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCount(String title, String count, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}