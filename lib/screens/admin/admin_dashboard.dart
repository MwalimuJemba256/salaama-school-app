import 'package:flutter/material.dart';
import '../../core/colors.dart';
import 'finance_settings.dart';
import '../documents/pdf_png_generator.dart';
import '../media/media_library.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  
  @override
  Widget build(BuildContext context){
    final adminItems = [
      {'icon': Icons.dashboard, 'title': 'Dashboard'},
      {'icon': Icons.people, 'title': 'Students\nBaby-P7 & Tahfiizu'},
      {'icon': Icons.receipt, 'title': 'Fees & Receipts'},
      {'icon': Icons.work, 'title': 'Teachers Salary'},
      {'icon': Icons.bar_chart, 'title': 'Reports'},
      {'icon': Icons.settings, 'title': 'School Settings'},
      {'icon': Icons.show_chart, 'title': 'Cash Flow with Graph'},
      {'icon': Icons.chat, 'title': 'Chat Box'},
      {'icon': Icons.video_library, 'title': 'Media Library'},
      {'icon': Icons.picture_as_pdf, 'title': 'PDF Generator'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN MENU'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            color: AppColors.lightBlue,
            child: Row(
              children: [
                Image.asset('assets/logo.png', width: 50),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SALAAMA MUSLIM JUNIOR SCHOOL', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 12)),
                    Text('DESTINED TO SUCCEED', style: TextStyle(fontSize: 11, color: AppColors.accentGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.2),
              itemCount: adminItems.length,
              itemBuilder: (c, i){
                return InkWell(
                  onTap: (){
                    if(adminItems[i]['title'].toString().contains('Fees') || adminItems[i]['title'].toString().contains('Salary') || adminItems[i]['title'].toString().contains('Cash')){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> FinanceSettings()));
                    } else if(adminItems[i]['title'].toString().contains('PDF')){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> DocumentGenerator()));
                    } else if(adminItems[i]['title'].toString().contains('Media')){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> MediaLibrary()));
                    }
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(adminItems[i]['icon'] as IconData, size: 36, color: AppColors.primaryBlue),
                        SizedBox(height: 8),
                        Text(adminItems[i]['title'] as String, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: AppColors.primaryBlue,
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Text('ajemba53@gmail.com | nassakalatiffah@gmail.com | +256 702 642 786', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 9)),
          ),
        ],
      ),
    );
  }
}