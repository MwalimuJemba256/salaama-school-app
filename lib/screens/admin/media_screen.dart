import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});
  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SalaamaAppBar(
        title: "Media",
        backgroundColor: const Color(0xFF37474F),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.photo), text: "Pictures"),
            Tab(icon: Icon(Icons.videocam), text: "Videos"),
            Tab(icon: Icon(Icons.audiotrack), text: "Audios"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMediaTab("pictures"),
          _buildMediaTab("videos"),
          _buildMediaTab("audios"),
        ],
      ),
    );
  }

  Widget _buildMediaTab(String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('school_media').where('type', isEqualTo: type).orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Center(child: Text("No $type yet"));
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data();
            return Card(
              child: ListTile(
                leading: Icon(type == "pictures" ? Icons.photo : type == "videos" ? Icons.videocam : Icons.audiotrack),
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Text(data['description'] ?? ''),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => docs[i].reference.delete()),
              ),
            );
          },
        );
      },
    );
  }
}
