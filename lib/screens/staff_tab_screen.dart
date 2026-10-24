import 'package:flutter/material.dart';

class StaffTabScreen extends StatelessWidget {
  const StaffTabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xFF1E40AF), title: const Text('Staff Management', style: TextStyle(color: Colors.white)), iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(tabs: [Tab(text: 'Secular'), Tab(text: 'Theology'), Tab(text: 'OTHER')])),
        body: TabBarView(children: [
          _buildList(['English','Mathematics','Science','SST'], Colors.blue),
          _buildList(['Quran - Hifz','Quran - Tafsir','Quran - Tajwid','Fiqh','Lugha','Tarbiah - Tauhid','Tarbiah - Siirah','Tarbiah - Hadith'], const Color(0xFF065F46)),
          _buildList(['Cook','Guard','Cleaner','Driver','Matron','Secretary'], Colors.brown),
        ]),
      ),
    );
  }
  Widget _buildList(List<String> items, Color c) => ListView.builder(padding: const EdgeInsets.all(12), itemCount: items.length, itemBuilder: (_,i)=>Card(child: ListTile(leading: CircleAvatar(backgroundColor: c.withOpacity(0.15), child: Icon(Icons.person, color: c)), title: Text(items[i]), subtitle: const Text('Managed by Admin'), trailing: const Icon(Icons.arrow_forward_ios, size: 12))));
}
