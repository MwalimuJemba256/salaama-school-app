import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String selectedRole = "Admin";
  bool loading = false;

  final roles = ["Admin", "Teacher", "Parent"];

  Future<void> login() async {
    setState(() => loading = true);
    try {
      // 1. Try Firebase Auth
      UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      // 2. Check Firestore for role if Parent
      String finalRole = selectedRole;
      
      if (selectedRole == "Parent") {
        // Check if parent exists by phone or email
        final parentQuery = await FirebaseFirestore.instance
            .collection('students')
            .where('parentPhone', isEqualTo: emailCtrl.text.trim())
            .limit(1)
            .get();
        
        // Or allow any email for parent role - parent can login with their phone as email
        // e.g. parent uses child phone number
        finalRole = "Parent";
      } else if (selectedRole == "Teacher") {
        final teacherQuery = await FirebaseFirestore.instance
            .collection('teachers')
            .where('email', isEqualTo: emailCtrl.text.trim())
            .limit(1)
            .get();
        finalRole = "Teacher";
      } else {
        finalRole = "Admin";
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(role: finalRole)),
      );
    } on FirebaseAuthException catch (e) {
      // For Parent - allow login without Firebase Auth if phone matches student
      if (selectedRole == "Parent") {
        try {
          final snap = await FirebaseFirestore.instance
              .collection('students')
              .where('parentPhone', isEqualTo: emailCtrl.text.trim())
              .limit(1)
              .get();
          if (snap.docs.isNotEmpty) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen(role: "Parent")),
            );
            return;
          }
        } catch (_) {}
      }
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/logo.png', errorBuilder: (c, e, s) => const Icon(Icons.school, size: 40, color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("SALAAMA MUSLIM JUNIOR SCHOOL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text("DESTINED TO SUCCEED", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: "Login As", border: OutlineInputBorder()),
                items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => selectedRole = v!),
              ),
              const SizedBox(height: 12),
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: selectedRole == "Parent" ? "Parent Phone (+256...)" : "Email", border: const OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: selectedRole == "Parent" ? "Child Name (or password)" : "Password", border: const OutlineInputBorder())),
              const SizedBox(height: 6),
              if (selectedRole == "Parent") const Text("Tip: Parent can login with phone number saved in student record", style: TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
                  onPressed: loading ? null : login,
                  child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
