import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/register_child_screen.dart';
import 'screens/teacher_list_screen.dart';
import 'screens/other_staff_screen.dart';
import 'screens/child_leave_screen.dart';
import 'screens/student_detail_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/students_list_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/school_media_screen.dart'; // <-- MEDIA IMPORT
import 'screens/fees_receipt_screen.dart'; // <-- FEES RECEIPT IMPORT NEW

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
   await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
    debugPrint("✅ Firebase initialized");
  } catch (e) {
    debugPrint("⚠️ Firebase failed but app will continue: $e");
  }
  runApp(const SalaamaApp());
}

class SalaamaApp extends StatelessWidget {
  const SalaamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salaama Muslim Junior School',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D5A2D),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D5A2D)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;
        switch (settings.name) {
          // ===== ORIGINAL 6 =====
          case '/register_child':
            return MaterialPageRoute(builder: (_) => const RegisterChildScreen());
          case '/teacher_list':
            return MaterialPageRoute(builder: (_) => const TeacherListScreen());
          case '/other_staff':
            return MaterialPageRoute(builder: (_) => const OtherStaffScreen());
          case '/timetable':
            return MaterialPageRoute(builder: (_) => const TimetableScreen());
          case '/students_list':
            return MaterialPageRoute(builder: (_) => const StudentsListScreen());
          case '/student_detail':
            if (args != null) {
              return MaterialPageRoute(builder: (_) => StudentDetailScreen(studentData: args));
            }
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/child_leave':
            if (args != null) {
              return MaterialPageRoute(builder: (_) => ChildLeaveScreen(student: args));
            }
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/teacher_dashboard':
            if (args != null) {
              return MaterialPageRoute(builder: (_) => TeacherDashboard(teacher: args));
            }
            return MaterialPageRoute(builder: (_) => const LoginScreen());

          // ===== 12 CARDS + MEDIA + FEES RECEIPT =====
          case '/staff_tab':
            return MaterialPageRoute(builder: (_) => const StaffTabScreen());
          case '/classes':
            return MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Classes - Streams', subtitle: 'Baby, Top, P1-P7\nSecular: English, Math, Science, SST\nTheology: Quran Hifz/Tafsir/Tajwid, Fiqh, Lugha\nTarbiah: Tauhid, Siirah, Hadith', color: Colors.orange));
          case '/attendance':
            return MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Attendance - Daily', subtitle: 'All Students + Teachers + OTHER Staff\nManaged by Admin', color: Color(0xFF0F766E)));
          case '/exams':
            return MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Exams - Results', subtitle: 'Secular + Theology with Tarbiah\nTauhid, Siirah, Hadith Report EN/AR', color: Colors.red));
          case '/tahfiizu':
            return MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Tahfiizu - Qur\'an', subtitle: 'Juz 1-30 Tracking\nQuran: Hifz / Tafsir / Tajwid\nHifz Certificate ممتاز', color: Color(0xFF065F46)));
          case '/fees':
            return MaterialPageRoute(builder: (_) => const FeesReceiptScreen()); // <-- NOW REAL FEES RECEIPT WITH PDF EN/AR + SHARE
          case '/cashflow':
            return MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Cashflow - Income', subtitle: 'Income + Expense + Balance\nDaily, Monthly Reports\nAdmin Only', color: Colors.purple));
          case '/chat':
            return MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Chat - Staff+Parent', subtitle: 'Admin ↔ Teachers ↔ Parents\nWhatsApp style\nManaged by Admin', color: Color(0xFF1E40AF)));
          case '/notices':
            return MaterialPageRoute(builder: (_) => const SchoolMediaScreen()); // Media + Notices together
          case '/school_media':
            return MaterialPageRoute(builder: (_) => const SchoolMediaScreen()); // Video + Audio Firebase Upload
          case '/settings':
            return MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Settings - School Info', subtitle: '8 Roles:\nAdmin, Head Teacher, DOS, Bursar\nTeacher, Tahfiizu, Parent, OTHER Staff\nAll Managed by Admin', color: Colors.grey));
          case '/admin_dashboard':
            return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

          default:
            return null;
        }
      },
    );
  }
}

// ===== STAFF TAB SCREEN - 3 TABS: SECULAR / THEOLOGY / OTHER =====
class StaffTabScreen extends StatelessWidget {
  const StaffTabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E40AF),
          title: const Text('Staff - All People', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [Tab(text: 'Secular'), Tab(text: 'Theology'), Tab(text: 'OTHER')],
          ),
        ),
        body: TabBarView(children: [
          _buildStaffList(['English','Mathematics','Science','SST'], Colors.blue, 'Secular'),
          _buildStaffList(['Quran - Hifz','Quran - Tafsir','Quran - Tajwid','Fiqh','Lugha','Tarbiah - Tauhid','Tarbiah - Siirah','Tarbiah - Hadith'], const Color(0xFF065F46), 'Theology'),
          _buildStaffList(['Cook','Guard','Cleaner','Driver','Matron','Secretary'], Colors.brown, 'OTHER'),
        ]),
        floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF1E40AF), onPressed: () => Navigator.pushNamed(context, '/register_child'), child: const Icon(Icons.add, color: Colors.white)),
      ),
    );
  }

  Widget _buildStaffList(List<String> subjects, Color color, String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: subjects.length,
      itemBuilder: (c,i) => Card(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(Icons.person, color: color, size: 18)),
          title: Text(subjects[i], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text('$type - Managed by Admin', style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          onTap: () {},
        ),
      ),
    );
  }
}

// ===== PLACEHOLDER FOR OTHER CARDS =====
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  const PlaceholderScreen({super.key, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: color, title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(Icons.construction, size: 50, color: color)),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4), textAlign: TextAlign.center),
            const SizedBox(height: 28),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => Navigator.pop(context), child: const Text('Back to Dashboard', style: TextStyle(color: Colors.white))),
          ]),
        ),
      ),
    );
  }
}
