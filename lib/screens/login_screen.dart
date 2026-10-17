import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFFE8F5E9), Colors.white],
            stops: [0.0, 0.35, 0.6],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60),
                // LOGO - EXACT LIKE YOUR DESIGN
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0,5))],
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (c,e,s) => Icon(Icons.school, size: 70, color: Color(0xFF0D6EFD)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text('SALAAMA MUSLIM\nJUNIOR SCHOOL', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0D2A54), letterSpacing: 0.5, height: 1.2)),
                SizedBox(height: 8),
                Text('DESTINED TO SUCCEED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50), letterSpacing: 1.2)),
                SizedBox(height: 35),
                Text('Welcome Back', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D2A54))),
                SizedBox(height: 5),
                Text('Sign in to your account', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      // ADMIN LOGIN - BLUE LIKE DESIGN
                      SizedBox(
                        width: double.infinity, height: 54,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.shield, color: Colors.white),
                          label: Text('Admin Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0D4DA1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      // TEACHER LOGIN - WHITE GREEN BORDER LIKE DESIGN
                      SizedBox(
                        width: double.infinity, height: 54,
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.co_present, color: Color(0xFF2E7D32)),
                          label: Text('Teacher Login', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 16, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF81C784), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Teacher Login coming next! 👨‍🏫')));
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      Text('Need help? Contact school admin', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 18, color: Colors.grey),
                          SizedBox(width: 25),
                          Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey),
                          SizedBox(width: 25),
                          Icon(Icons.school_outlined, size: 18, color: Colors.grey),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// KEEP YOUR DASHBOARD CODE BELOW - DON'T DELETE
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HEAD TEACHER - Admin'), backgroundColor: Color(0xFF0D2A54), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: _statCard('Ordinary', '180', Icons.school, Colors.orange)),
              SizedBox(width: 10),
              Expanded(child: _statCard('Tahfiz', '75', Icons.menu_book, Colors.purple)),
              SizedBox(width: 10),
              Expanded(child: _statCard('Non-Teaching', '20', Icons.work, Colors.teal)),
            ]),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xFF0D2A54), borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                Row(children: [Icon(Icons.circle, color: Colors.green, size: 12), SizedBox(width: 8), Text('LIVE Monitoring', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _liveItem('12', 'Present', Icons.check_circle),
                  _liveItem('5', 'Late', Icons.access_time),
                  _liveItem('3', 'Absent', Icons.cancel),
                ]),
              ]),
            ),
            SizedBox(height: 20),
            Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6,
              children: [
                _actionTile('Add Student', Icons.person_add, Colors.blue),
                _actionTile('View Classes', Icons.class_, Colors.green),
                _actionTile('Attendance', Icons.fact_check, Colors.orange),
                _actionTile('Reports', Icons.bar_chart, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _statCard(String t, String n, IconData i, Color c) => Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.3))), child: Column(children: [Icon(i, color: c), SizedBox(height: 6), Text(n, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(t, style: TextStyle(fontSize: 11))] ));
  Widget _liveItem(String n, String l, IconData i) => Column(children: [Icon(i, color: Colors.white, size: 28), SizedBox(height: 4), Text(n, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text(l, style: TextStyle(color: Colors.white70, fontSize: 11))]);
  Widget _actionTile(String t, IconData i, Color c) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: c, size: 32), SizedBox(height: 8), Text(t, style: TextStyle(fontWeight: FontWeight.bold))]));
}
