import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';
import 'parent_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String selectedRole = 'Admin';
  bool loading = false;

  Future<void> login() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter email & password')));
      return;
    }
    setState(() => loading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      
      final doc = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
      
      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found in database. Contact Admin.')));
        setState(() => loading = false);
        return;
      }

      final role = doc.data()?['role'] ?? 'Parent';

      if (role != selectedRole) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You selected $selectedRole but your account is $role')));
        setState(() => loading = false);
        return;
      }

      if (!mounted) return;

      if (role == 'Admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
      } else if (role == 'Teacher') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TeacherDashboardScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ParentDashboardScreen()));
      }

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 120,
                errorBuilder: (_,__,___) => const Icon(Icons.school, size: 80, color: Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 12),
              const Text(
                'SALAAMA MUSLIM\nJUNIOR SCHOOL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF0D47A1)),
                textAlign: TextAlign.center,
              ),
              const Text('DESTINED TO SUCCEED', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: 'Select Role',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Teacher', child: Text('Teacher')),
                  DropdownMenuItem(value: 'Parent', child: Text('Parent')),
                ],
                onChanged: (v) => setState(() => selectedRole = v!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
              const SizedBox(height: 16),
              const Text('© 2026 Salaama Muslim Junior School', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
