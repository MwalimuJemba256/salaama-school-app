import 'package:flutter/material.dart';

class SchoolMediaScreen extends StatefulWidget {
  const SchoolMediaScreen({super.key});
  @override
  State<SchoolMediaScreen> createState() => _SchoolMediaScreenState();
}

class _SchoolMediaScreenState extends State<SchoolMediaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF065F46),
        title: const Text('Salaama Media Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.video_library), text: 'Video Panel'),
            Tab(icon: Icon(Icons.audiotrack), text: 'Audio Hifz'),
            Tab(icon: Icon(Icons.people), text: 'All People'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: VIDEO PANEL
          _videoTab(),
          // TAB 2: AUDIO
          _audioTab(),
          // TAB 3: ALL PEOPLE MEDIA
          _peopleTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF065F46),
        onPressed: () => _showUploadDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Upload', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _videoTab() {
    final videos = [
      {'title': 'Quran Hifz - Juz Amma - Top Class', 'person': 'Student: Ahmed - P5', 'duration': '05:23', 'type': 'Theology'},
      {'title': 'Tarbiah - Siirah Lesson', 'person': 'Ustadha: Sheikh Musa', 'duration': '12:45', 'type': 'Theology'},
      {'title': 'Science Experiment - P6', 'person': 'Teacher: Ms. Sarah', 'duration': '08:10', 'type': 'Secular'},
      {'title': 'School Assembly - Adhan', 'person': 'All Students', 'duration': '03:30', 'type': 'School'},
      {'title': 'Graduation Ceremony 2024', 'person': 'Baby to P7', 'duration': '25:00', 'type': 'Event'},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: videos.length,
      itemBuilder: (c,i) {
        final v = videos[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.black87, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
              child: Stack(children: [
                const Center(child: Icon(Icons.play_circle_fill, size: 60, color: Colors.white70)),
                Positioned(bottom: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)), child: Text(v['duration']!, style: const TextStyle(color: Colors.white, fontSize: 11)))),
                Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF065F46), borderRadius: BorderRadius.circular(12)), child: Text(v['type']!, style: const TextStyle(color: Colors.white, fontSize: 10)))),
              ]),
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF065F46), child: Icon(Icons.person, color: Colors.white, size: 18)),
              title: Text(v['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(v['person']!, style: const TextStyle(fontSize: 11)),
              trailing: IconButton(icon: const Icon(Icons.share, size: 18), onPressed: () {}),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Playing: ${v['title']}'))),
            ),
          ]),
        );
      },
    );
  }

  Widget _audioTab() {
    final audios = [
      {'title': 'Surah Al-Baqarah - Hifz', 'person': 'Hafiz: Bilal - P7', 'juz': 'Juz 1', 'duration': '10:20'},
      {'title': 'Quran Tafsir - Ayatul Kursi', 'person': 'Sheikh: Quran Tafsir Teacher', 'juz': 'Tafsir', 'duration': '15:00'},
      {'title': 'Tajwid - Makharij', 'person': 'Ustadha: Tajwid Class', 'juz': 'Tajwid', 'duration': '08:30'},
      {'title': 'Hadith - 40 Nawawi', 'person': 'Tarbiah Hadith Teacher', 'juz': 'Hadith', 'duration': '06:15'},
      {'title': 'Nasheed - Salaama Anthem', 'person': 'All Students', 'juz': 'Nasheed', 'duration': '04:00'},
      {'title': 'Adhan - Dhuhr', 'person': 'Muadhin: Staff', 'juz': 'Adhan', 'duration': '02:30'},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: audios.length,
      itemBuilder: (c,i) {
        final a = audios[i];
        return Card(
          child: ListTile(
            leading: Container(width: 50, height: 50, decoration: BoxDecoration(color: const Color(0xFF065F46).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.audiotrack, color: Color(0xFF065F46))),
            title: Text(a['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a['person']!, style: const TextStyle(fontSize: 11)),
              const SizedBox(height: 2),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)), child: Text(a['juz']!, style: TextStyle(fontSize: 10, color: Colors.green[800]))),
                const SizedBox(width: 8),
                Text(a['duration']!, style: const TextStyle(fontSize: 10, color: Colors.black45)),
              ]),
            ]),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.play_arrow, color: Color(0xFF065F46)), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Playing audio: ${a['title']}')))),
              IconButton(icon: const Icon(Icons.share, size: 16), onPressed: () {}),
            ]),
          ),
        );
      },
    );
  }

  Widget _peopleTab() {
    final people = [
      {'name': 'Students (1,250)', 'count': '1,250 videos/audios', 'icon': Icons.school, 'color': Colors.blue},
      {'name': 'Secular Teachers (20)', 'count': 'English, Math, Science, SST', 'icon': Icons.menu_book, 'color': Colors.orange},
      {'name': 'Theology Teachers (15)', 'count': 'Quran Hifz/Tafsir/Tajwid, Fiqh, Lugha, Tarbiah Tauhid/Siirah/Hadith', 'icon': Icons.auto_stories, 'color': const Color(0xFF065F46)},
      {'name': 'OTHER Staff (10)', 'count': 'Cook, Guard, Cleaner, Driver, Matron', 'icon': Icons.badge, 'color': Colors.brown},
      {'name': 'Parents (890)', 'count': 'Feedback audios, Meetings', 'icon': Icons.family_restroom, 'color': Colors.purple},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: people.length,
      itemBuilder: (c,i) {
        final p = people[i];
        return Card(
          child: ExpansionTile(
            leading: CircleAvatar(backgroundColor: (p['color'] as Color).withOpacity(0.15), child: Icon(p['icon'] as IconData, color: p['color'] as Color, size: 20)),
            title: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text(p['count'] as String, style: const TextStyle(fontSize: 11)),
            children: [
              ListTile(leading: const Icon(Icons.video_library, size: 18), title: const Text('Videos', style: TextStyle(fontSize: 12)), trailing: const Text('12', style: TextStyle(fontSize: 12)), onTap: () {}),
              ListTile(leading: const Icon(Icons.audiotrack, size: 18), title: const Text('Audios', style: TextStyle(fontSize: 12)), trailing: const Text('25', style: TextStyle(fontSize: 12)), onTap: () {}),
            ],
          ),
        );
      },
    );
  }

  void _showUploadDialog() {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: const Text('Upload Media'),
      content: const Text('Choose: Video (MP4) or Audio (MP3) for Student/Teacher/OTHER Staff'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
        ElevatedButton(onPressed: () { Navigator.pop(c); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open gallery - Upload to Firebase Storage'))); }, child: const Text('Pick File')),
      ],
    ));
  }
}
