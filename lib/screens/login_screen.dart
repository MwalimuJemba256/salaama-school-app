import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(child: Icon(Icons.school, size: 80, color: Color(0xFF0D2A54))),
              SizedBox(height: 20),
              Center(
                child: Text('SALAAMA MUSLIM\nJUNIOR SCHOOL',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D2A54))),
              ),
              SizedBox(height: 10),
              Center(child: Text('Kampala - Uganda', style: TextStyle(color: Colors.grey))),
              SizedBox(height: 40),
              Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+2567XXXXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D2A54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => _goToDemo(),
                  child: Text('LOGIN WITH OTP', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(height: 20), Divider(), SizedBox(height: 10),
              Text('For Testing:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => _goToDemo(),
                  child: Text('DEMO LOGIN - HEAD TEACHER', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToDemo() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
  }
}

// REAL ADMIN DASHBOARD NOW!
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text('HEAD TEACHER - Admin', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Color(0xFF0D2A54),
        actions: [IconButton(icon: Icon(Icons.logout, color: Colors.white), onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        })],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Cards
            Row(
              children: [
                Expanded(child: _statCard('275', 'Total Students', Icons.people, Colors.blue)),
                SizedBox(width: 12),
                Expanded(child: _statCard('95%', 'Attendance', Icons.check_circle, Colors.green)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statCard('Ordinary', '180 Students', Icons.school, Colors.orange)),
                SizedBox(width: 12),
                Expanded(child: _statCard('Tahfiz', '75 Students', Icons.menu_book, Colors.purple)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statCard('Non-Teaching', '20 Staff', Icons.work, Colors.teal)),
                SizedBox(width: 12),
                Expanded(child: _statCard('LIVE', 'Monitoring', Icons.live_tv, Colors.red)),
              ],
            ),
            SizedBox(height: 24),
            Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _actionTile(Icons.person_add, 'Add Student', 'Ordinary / Tahfiz / Non-Teaching'),
            _actionTile(Icons.class_, 'View Classes', 'P1 - P7, Tahfiz Levels'),
            _actionTile(Icons.assignment, 'Attendance Reports', 'Today / Weekly / Monthly'),
            _actionTile(Icons.people, 'Teachers', 'Manage Teachers & Roles'),
            _actionTile(Icons.settings, 'School Settings', 'Logo, Name, Year'),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D2A54)),
                onPressed: () {},
                icon: Icon(Icons.dashboard, color: Colors.white),
                label: Text('OPEN FULL DASHBOARD', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String title, String subtitle) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Color(0xFF0D2A54), child: Icon(icon, color: Colors.white, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
