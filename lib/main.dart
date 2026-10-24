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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
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
          default:
            return null;
        }
      },
    );
  }
}
