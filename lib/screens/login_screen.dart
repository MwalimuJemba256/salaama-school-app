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
  final _emailController = TextEditingController(text: "nassakalatiifah@gmail.com");
  final _passwordController = TextEditingController();
  String _selectedRole = "Admin";
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _loading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter email & password")));
      return;
    }
    setState(() => _loading = true);
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // FIX: Check if user exists in Firestore, if NOT, create him automatically!
      try {
        var userDoc = await _firestore.collection('users').doc(cred.user!.uid).get();
        if (!userDoc.exists) {
          // Also check by email
          var emailQuery = await _firestore.collection('users').where('email', isEqualTo: _emailController.text.trim()).get();
          if (emailQuery.docs.isEmpty) {
            // Auto-create Admin
            await _firestore.collection('users').doc(cred.user!.uid).set({
              'email': _emailController.text.trim(),
              'role': _selectedRole,
              'name': 'Admin',
              'uid': cred.user!.uid,
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
      } catch (e) {
        // If Firestore fails, still allow login!
        print("Firestore error: $e");
      }

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    } finally {
      setState(() => _loading = false);
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
            children: [
              Image.asset('assets/images/logo.png', height: 110, errorBuilder: (_, __, ___) => Image.asset('assets/images/salaama_logo.png', height: 110, errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 100, color: Color(0xFF0D47A1)))),
              const SizedBox(height: 12),
              const Text("SALAAMA MUSLIM\nJUNIOR SCHOOL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF0D47A1)), textAlign: TextAlign.center),
              const Text("DESTINED TO SUCCEED", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 30),
              
              // Role Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(labelText: "Select Role", prefixIcon: Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                items: ["Admin", "Teacher", "Parent"].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _selectedRole = v!),
              ),
              const SizedBox(height: 16),
              
              TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 16),
              
              TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("© 2026 Salaama Muslim Junior School", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
