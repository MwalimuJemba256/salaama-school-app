import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = "Admin";
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(role: _selectedRole)));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
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
              const Icon(Icons.school, size: 100, color: Color(0xFF0D47A1)),
              const SizedBox(height: 12),
              const Text("SALAAMA MUSLIM\nJUNIOR SCHOOL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF0D47A1)), textAlign: TextAlign.center),
              const Text("DESTINED TO SUCCEED", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(labelText: "Select Role", prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                items: ["Admin", "Teacher", "Parent"].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _selectedRole = v!),
              ),
              const SizedBox(height: 16),
              TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email", prefixIcon: const Icon(Icons.email), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 16),
              TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password", prefixIcon: const Icon(Icons.lock), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: _loading ? null : _login, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }
}
