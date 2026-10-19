import 'package:flutter/material.dart';
import '../../core/colors.dart';

class ParentPanel extends StatelessWidget {
  const ParentPanel({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon':Icons.child_care,'title':'My Children','sub':'Baby - P7 & Tahfiizu'},
      {'icon':Icons.receipt,'title':'Fees & Balance','sub':'View & Pay'},
      {'icon':Icons.grade,'title':'Results & Reports','sub':'Download PDF/PNG'},
      {'icon':Icons.calendar_today,'title':'Attendance','sub':'Daily update'},
      {'icon':Icons.video_library,'title':'Media','sub':'Videos, Audios, Docs'},
      {'icon':Icons.chat,'title':'Chat with Teacher','sub':'Direct message'},
      {'icon':Icons.picture_as_pdf,'title':'Document Generator','sub':'Custom colors'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Panel'), backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
      body: GridView.builder(padding: const EdgeInsets.all(12), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12), itemCount: items.length, itemBuilder: (c,i){
        return Card(color: AppColors.lightBlue, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(items[i]['icon'] as IconData, size: 40, color: AppColors.primaryBlue), const SizedBox(height:8), Text(items[i]['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)), Text(items[i]['sub'] as String, style: const TextStyle(fontSize: 10))]));
      }),
    );
  }
}