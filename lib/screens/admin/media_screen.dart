import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/salaama_app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
        backgroundColor: Color(0xFF37474F),
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [Tab(icon: Icon(Icons.photo), text: "Pictures"), Tab(icon: Icon(Icons.videocam), text: "Videos"), Tab(icon: Icon(Icons.audiotrack), text: "Audios")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMediaTab("image"), _buildMediaTab("video"), _buildMediaTab("audio")],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF37474F),
        icon: const Icon(Icons.cloud_upload, color: Colors.white),
        label: const Text("Upload", style: TextStyle(color: Colors.white)),
        onPressed: () => _showUploadDialog(),
      ),
    );
  }

  Widget _buildMediaTab(String type) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('school_media').where('type', isEqualTo: type).orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(type == "image" ? Icons.photo_library : type == "video" ? Icons.video_library : Icons.library_music, size: 64, color: Colors.grey.shade300), const SizedBox(height: 12), Text("No ${type}s yet\nClick Upload to add Salaama ${type}s", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))]));

        if (type == "image") {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data();
              return GestureDetector(
                onTap: () => _showImageView(data['url'], data['title']),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(data['url'] ?? '', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.broken_image))),
                      Positioned(bottom: 0, left: 0, right: 0, child: Container(color: Colors.black54, padding: const EdgeInsets.all(6), child: Text(data['title'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis))),
                      Positioned(top: 4, right: 4, child: GestureDetector(onTap: () => docs[i].reference.delete(), child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Icon(Icons.close, size: 12, color: Colors.white)))),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data();
            final isVideo = type == "video";
            return Card(
              child: ListTile(
                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isVideo ? Colors.red.shade50 : Colors.green.shade50, borderRadius: BorderRadius.circular(8)), child: Icon(isVideo ? Icons.play_circle_fill : Icons.music_note, color: isVideo ? Colors.red : Colors.green)),
                title: Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${data['description'] ?? ''}\n${data['date'] ?? ''} | ${data['className'] ?? 'All School'}"),
                isThreeLine: true,
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => docs[i].reference.delete()),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Playing: ${data['title']}\nURL: ${data['url']}"), backgroundColor: const Color(0xFF37474F)));
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showImageView(String url, String title) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(title: Text(title), backgroundColor: const Color(0xFF37474F), foregroundColor: Colors.white, automaticallyImplyLeading: false, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
            Flexible(child: Image.network(url, fit: BoxFit.contain)),
          ],
        ),
      ),
    );
  }

  void _showUploadDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final classCtrl = TextEditingController(text: "All School");
    String selectedType = "image";
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState2) => AlertDialog(
          title: const Text("Upload Media - Salaama"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: "Media Type", border: OutlineInputBorder()),
                  items: const [DropdownMenuItem(value: "image", child: Text("Picture (JPG, PNG)")), DropdownMenuItem(value: "video", child: Text("Video (MP4, YouTube Link)")), DropdownMenuItem(value: "audio", child: Text("Audio (MP3, Quran, Anasheed)"))],
                  onChanged: (v) => setState2(() => selectedType = v!),
                ),
                const SizedBox(height: 12),
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title * (e.g., P7 Graduation 2026)", border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: classCtrl, decoration: const InputDecoration(labelText: "Class / Event (All School, P7, Quran Competition)", border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: urlCtrl, decoration: InputDecoration(labelText: selectedType == "image" ? "Image URL or Firebase Storage URL" : selectedType == "video" ? "Video URL (YouTube or Storage)" : "Audio URL (MP3 Link)", border: const OutlineInputBorder(), hintText: "https://..."), maxLines: 2),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blueGrey.shade100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Quick Upload Options:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text("• For Pictures: Upload to Firebase Storage -> Copy URL", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                      Text("• For Videos: Paste YouTube link OR Storage URL", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                      Text("• For Audios: Quran recitations, Anasheed MP3 links", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                if (isUploading) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF37474F)),
              onPressed: isUploading ? null : () async {
                if (titleCtrl.text.isEmpty || urlCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title and URL required!")));
                  return;
                }
                setState2(() => isUploading = true);
                try {
                  await FirebaseFirestore.instance.collection('school_media').add({
                    'title': titleCtrl.text.trim(),
                    'description': descCtrl.text.trim(),
                    'url': urlCtrl.text.trim(),
                    'type': selectedType,
                    'className': classCtrl.text.trim(),
                    'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${selectedType.capitalize()} Uploaded! MashaAllah"), backgroundColor: Colors.green));
                } catch (e) {
                  setState2(() => isUploading = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
                }
              },
              child: const Text("Upload", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCap on String {
  String capitalize() => isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";
}
