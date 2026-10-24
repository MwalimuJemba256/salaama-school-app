import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class SchoolMediaScreen extends StatefulWidget {
  const SchoolMediaScreen({super.key});
  @override
  State<SchoolMediaScreen> createState() => _SchoolMediaScreenState();
}

class _SchoolMediaScreenState extends State<SchoolMediaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _uploading = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _uploadMedia(bool isVideo) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: isVideo ? FileType.video : FileType.custom, allowedExtensions: isVideo ? null : ['mp3','m4a','wav']);
      if (result == null) return;
      File file = File(result.files.single.path!);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';
      String path = isVideo ? 'school_videos/$fileName' : 'school_audios/$fileName';

      setState(() { _uploading = true; _progress = 0; });
      UploadTask task = FirebaseStorage.instance.ref(path).putFile(file);
      task.snapshotEvents.listen((snap) { setState(() { _progress = snap.bytesTransferred / snap.totalBytes; }); });
      TaskSnapshot snap = await task;
      String url = await snap.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection(isVideo ? 'videos' : 'audios').add({
        'title': result.files.single.name,
        'url': url,
        'type': isVideo ? 'video' : 'audio',
        'person': 'Admin Upload',
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() { _uploading = false; });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${isVideo ? "Video" : "Audio"} uploaded! ${url.substring(0,30)}...')));
    } catch (e) {
      setState(() { _uploading = false; });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF065F46),
        title: const Text('Salaama Media Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(controller: _tabController, labelColor: Colors.white, unselectedLabelColor: Colors.white70, indicatorColor: Colors.white, tabs: const [Tab(icon: Icon(Icons.video_library), text: 'Video'), Tab(icon: Icon(Icons.audiotrack), text: 'Audio'), Tab(icon: Icon(Icons.people), text: 'People')]),
      ),
      body: Column(children: [
        if (_uploading) LinearProgressIndicator(value: _progress, backgroundColor: Colors.grey[200], color: const Color(0xFF065F46)),
        if (_uploading) Padding(padding: const EdgeInsets.all(8), child: Text('Uploading ${( _progress*100).toStringAsFixed(0)}% - Firebase Storage', style: const TextStyle(fontSize: 11))),
        Expanded(child: TabBarView(controller: _tabController, children: [_videoTabFirebase(), _audioTabFirebase(), _peopleTab()])),
      ]),
      floatingActionButton: Column(mainAxisSize: MainAxisSize.min, children: [
        FloatingActionButton.small(heroTag: 'v', backgroundColor: Colors.red, onPressed: () => _uploadMedia(true), child: const Icon(Icons.video_call, color: Colors.white)),
        const SizedBox(height: 8),
        FloatingActionButton.extended(heroTag: 'a', backgroundColor: const Color(0xFF065F46), onPressed: () => _uploadMedia(false), icon: const Icon(Icons.audiotrack, color: Colors.white), label: const Text('Upload Media', style: TextStyle(color: Colors.white))),
      ]),
    );
  }

  Widget _videoTabFirebase() {
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('videos').orderBy('createdAt', descending: true).snapshots(), builder: (c,snap) {
      if (!snap.hasData) return const Center(child: CircularProgressIndicator());
      if (snap.data!.docs.isEmpty) return _videoTabDemo();
      return ListView.builder(padding: const EdgeInsets.all(12), itemCount: snap.data!.docs.length, itemBuilder: (c,i) {
        var d = snap.data!.docs[i].data() as Map<String,dynamic>;
        return Card(child: ListTile(leading: const Icon(Icons.video_library, color: Color(0xFF065F46)), title: Text(d['title']??'Video', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), subtitle: Text(d['url']??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)), trailing: IconButton(icon: const Icon(Icons.play_arrow), onPressed: () {})));
      });
    });
  }

  Widget _audioTabFirebase() {
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('audios').orderBy('createdAt', descending: true).snapshots(), builder: (c,snap) {
      if (!snap.hasData) return const Center(child: CircularProgressIndicator());
      if (snap.data!.docs.isEmpty) return _audioTabDemo();
      return ListView.builder(padding: const EdgeInsets.all(12), itemCount: snap.data!.docs.length, itemBuilder: (c,i) {
        var d = snap.data!.docs[i].data() as Map<String,dynamic>;
        return Card(child: ListTile(leading: const Icon(Icons.audiotrack, color: Color(0xFF065F46)), title: Text(d['title']??'Audio', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), subtitle: Text(d['url']??'', maxLines: 1, style: const TextStyle(fontSize: 10)), trailing: IconButton(icon: const Icon(Icons.play_arrow), onPressed: () {})));
      });
    });
  }

  Widget _videoTabDemo() {
    final videos = [{'title': 'Quran Hifz - Juz Amma', 'person': 'Ahmed P5'}, {'title': 'Science Experiment', 'person': 'Ms Sarah'}, {'title': 'School Assembly', 'person': 'All Students'}];
    return ListView.builder(padding: const EdgeInsets.all(12), itemCount: videos.length, itemBuilder: (c,i) => Card(child: ListTile(leading: Container(width: 50, height: 50, color: Colors.black87, child: const Icon(Icons.play_circle, color: Colors.white)), title: Text(videos[i]['title']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), subtitle: Text(videos[i]['person']!, style: const TextStyle(fontSize: 11)))));
  }
  Widget _audioTabDemo() {
    final audios = [{'title': 'Surah Baqarah', 'person': 'Bilal P7'}, {'title': 'Tafsir Ayatul Kursi', 'person': 'Sheikh'}, {'title': 'Nasheed Salaama', 'person': 'All'}];
    return ListView.builder(padding: const EdgeInsets.all(12), itemCount: audios.length, itemBuilder: (c,i) => Card(child: ListTile(leading: const Icon(Icons.audiotrack, color: Color(0xFF065F46)), title: Text(audios[i]['title']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), subtitle: Text(audios[i]['person']!, style: const TextStyle(fontSize: 11)))));
  }
  Widget _peopleTab() {
    return ListView(padding: const EdgeInsets.all(12), children: const [
      ListTile(leading: CircleAvatar(child: Icon(Icons.school)), title: Text('Students 1,250 - Video+Audio'), subtitle: Text('Hifz, Secular lessons')),
      ListTile(leading: CircleAvatar(child: Icon(Icons.menu_book)), title: Text('Secular Teachers 20'), subtitle: Text('English Math Science SST')),
      ListTile(leading: CircleAvatar(child: Icon(Icons.auto_stories)), title: Text('Theology Teachers 15'), subtitle: Text('Quran Hifz/Tafsir/Tajwid, Fiqh, Lugha, Tarbiah Tauhid/Siirah/Hadith')),
      ListTile(leading: CircleAvatar(child: Icon(Icons.badge)), title: Text('OTHER Staff 10'), subtitle: Text('Cook Guard Cleaner Driver Matron')),
      ListTile(leading: CircleAvatar(child: Icon(Icons.family_restroom)), title: Text('Parents 890'), subtitle: Text('Feedback audios')),
    ]);
  }
}
