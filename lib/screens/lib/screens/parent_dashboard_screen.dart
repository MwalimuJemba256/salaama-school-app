import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/salaama_appbar.dart';
import 'login_screen.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SalaamaAppBar(
        title: 'Parent Portal',
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if(context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
          })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF0D47A1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset('assets/images/logo.png', height: 50, errorBuilder: (_,__,___) => const Icon(Icons.child_care, color: Colors.white, size: 50)),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ahmed Mukasa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('P.5 Blue | ID: SMJ-2024-0125', style: TextStyle(color: Colors.white70)),
                    ],
                  )
                ],
              ),
            ),
          ),
          _tile(Icons.bar_chart, 'Results', 'Term 2 - 85%'),
          _tile(Icons.payments, 'Fees Status', 'Paid - UGX 0 balance'),
          _tile(Icons.directions_bus, 'Transport', 'Bus No. 3'),
          _tile(Icons.notifications, 'Announcements', '3 New'),
          _tile(Icons.chat, 'Chat Teacher', 'Contact class teacher'),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String sub) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D47A1)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}