import 'package:flutter/material.dart';
import '../../core/colors.dart';

class MediaLibrary extends StatelessWidget {
  const MediaLibrary({super.key});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Library'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primaryBlue,
              tabs: [
                Tab(text: 'Videos', icon: Icon(Icons.video_library)),
                Tab(text: 'Audio', icon: Icon(Icons.audiotrack)),
                Tab(text: 'Documents', icon: Icon(Icons.picture_as_pdf)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      ListTile(leading: Icon(Icons.video_library, color: Colors.red), title: Text('Morning Assembly P7'), subtitle: Text('2 mins'), trailing: Icon(Icons.download)),
                      ListTile(leading: Icon(Icons.video_library, color: Colors.red), title: Text('Tahfiizu Recitation'), subtitle: Text('Hifz Class'), trailing: Icon(Icons.download)),
                      ListTile(leading: Icon(Icons.video_library, color: Colors.red), title: Text('School Event 2026'), subtitle: Text('Annual Day'), trailing: Icon(Icons.download)),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      ListTile(leading: Icon(Icons.audiotrack, color: AppColors.primaryBlue), title: Text('School Anthem'), subtitle: Text('Salaama Anthem'), trailing: Icon(Icons.download)),
                      ListTile(leading: Icon(Icons.audiotrack, color: AppColors.primaryBlue), title: Text('Quran Recitation'), subtitle: Text('Tahfiizu Section'), trailing: Icon(Icons.download)),
                      ListTile(leading: Icon(Icons.audiotrack, color: AppColors.primaryBlue), title: Text('Assembly Dua'), subtitle: Text('Morning'), trailing: Icon(Icons.download)),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      ListTile(leading: Icon(Icons.picture_as_pdf, color: Colors.green), title: Text('Fee Structure 2026 PDF'), subtitle: Text('Baby to P7 + Tahfiizu'), trailing: Icon(Icons.download)),
                      ListTile(leading: Icon(Icons.picture_as_pdf, color: Colors.green), title: Text('Report Card PNG'), subtitle: Text('Custom Colors'), trailing: Icon(Icons.download)),
                      ListTile(leading: Icon(Icons.picture_as_pdf, color: Colors.green), title: Text('ID Card Template'), subtitle: Text('PNG & PDF'), trailing: Icon(Icons.download)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.upload), label: Text('Upload Media'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue))),
                  SizedBox(width: 10),
                  Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.picture_as_pdf), label: Text('Generate PNG/PDF'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}