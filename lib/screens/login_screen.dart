import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'admin/admin_dashboard.dart';
import 'teacher/teacher_dashboard.dart';
import 'parent/parent_panel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Admin';
  final roles = ['Admin', 'Teacher', 'Staff Non-Teaching', 'Parent', 'Tahfiizu Teacher'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/logo.png', width: 130),
            const SizedBox(height: 10),
            const Text('SALAAMA MUSLIM JUNIOR SCHOOL APP', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const Text('DESTINED TO SUCCEED', style: TextStyle(color: AppColors.secondaryBlue)),
            const SizedBox(height: 20),
            DropdownButtonFormField(value: selectedRole, items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(), onChanged: (v)=>setState(()=>selectedRole=v!), decoration: InputDecoration(labelText: 'Select Role', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: 'Email / Username', prefixIcon: Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 15),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 25),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: (){
              if(selectedRole=='Admin') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const AdminDashboard()));
              else if(selectedRole.contains('Teacher')) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const TeacherDashboard()));
              else Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const ParentPanel()));
            }, child: const Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 16)))),
            const SizedBox(height: 20),
            Container(color: AppColors.primaryBlue, width: double.infinity, padding: EdgeInsets.all(12), child: Column(children: [Text('FOR SUPPORT:', style: TextStyle(color: Colors.white, fontSize: 10)), Text('nassakalatiffah@gmail.com | +256 702 642 786', style: TextStyle(color: Colors.white, fontSize: 11))]))
          ],
        ),
      ),
    );
  }
}