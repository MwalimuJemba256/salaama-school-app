import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin/admin_dashboard.dart';
import 'staff/tahfiizu_entry_screen.dart';
import 'parent/parent_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController(text: "nassakalatiifah@gmail.com");
  final passCtrl = TextEditingController();
  String selectedRole = "admin";

  Future<void> login() async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailCtrl.text.trim(), password: passCtrl.text.trim());
      final doc = await FirebaseFirestore.instance.collection("users").doc(cred.user!.email).get();
      final role = doc.data()?["role"] ?? selectedRole;

      if (role == "admin") Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
      else if (role == "staff") Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TahfiizuEntryScreen()));
      else Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ParentDashboard()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D6EFD), Color(0xFFFFF8E1)])),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.school, size: 80, color: Color(0xFF0B3D91)),
            Text("SALAAMA LOGIN", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            DropdownButton<String>(value: selectedRole, items: ["admin", "staff", "parent"].map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(), onChanged: (v) => setState(() => selectedRole = v!)),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("LOGIN AS ${selectedRole.toUpperCase()}")),
          ]),
        ),
      ),
    );
  }
}