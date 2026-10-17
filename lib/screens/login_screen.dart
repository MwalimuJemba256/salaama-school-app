import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF4A90E2), Color(0xFFE8F5E9), Colors.white], stops: [0.0, 0.35, 0.6])),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 55),
              Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0,5))]), child: ClipOval(child: Image.asset('assets/images/logo.png', fit: BoxFit.cover, errorBuilder: (c,e,s) => Icon(Icons.school, size: 70, color: Color(0xFF0D4DA1))))),
              SizedBox(height: 28),
              Text('SALAAMA MUSLIM\nJUNIOR SCHOOL', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0D2A54), height: 1.2)),
              SizedBox(height: 8),
              Text('DESTINED TO SUCCEED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50), letterSpacing: 1.2)),
              SizedBox(height: 30),
              Text('Welcome Back', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D2A54))),
              Text('Sign in to your account', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              SizedBox(height: 28),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Column(children: [
                  SizedBox(width: double.infinity, height: 54, child: ElevatedButton.icon(icon: Icon(Icons.shield, color: Colors.white), label: Text('Admin Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D4DA1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard())); })),
                  SizedBox(height: 14),
                  SizedBox(width: double.infinity, height: 54, child: OutlinedButton.icon(icon: Icon(Icons.co_present, color: Color(0xFF2E7D32)), label: Text('Teacher Login', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 16, fontWeight: FontWeight.bold)), style: OutlinedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Color(0xFF81C784), width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Teacher Login - Coming Next!'))); })),
                  SizedBox(height: 22),
                  Text('Need help? Contact school admin', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0, backgroundColor: Color(0xFF0D4DA1), foregroundColor: Colors.white,
        title: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white), child: ClipOval(child: Image.asset('assets/images/logo.png', errorBuilder: (c,e,s) => Icon(Icons.school, size: 20)))), SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('SALAAMA MUSLIM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)), Text('Head Teacher Panel', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400))])]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: _stat('Ordinary', '180', 'P1-P7', Icons.school, Colors.orange)),
            SizedBox(width: 10),
            Expanded(child: _stat('Tahfiz', '75', 'Quran', Icons.menu_book, Color(0xFF7B1FA2))),
            SizedBox(width: 10),
            Expanded(child: _stat('Staff', '20', 'Non-Teach', Icons.work, Color(0xFF00796B))),
          ]),
          SizedBox(height: 18),
          Container(width: double.infinity, padding: EdgeInsets.all(18), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D2A54), Color(0xFF0D4DA1)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)]), child: Column(children: [Row(children: [Icon(Icons.circle, color: Colors.greenAccent, size: 12), SizedBox(width: 8), Text('LIVE School Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_live('12','Present','✅'), _live('5','Late','⏰'), _live('3','Absent','❌'), _live('275','Total','👥')])])),
          SizedBox(height: 22),
          Text('Quick Actions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D2A54))),
          SizedBox(height: 12),
          GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5, children: [
            _action(context, 'Add Student', Icons.person_add, Color(0xFF0D4DA1)),
            _action(context, 'View Classes', Icons.class_, Color(0xFF2E7D32)),
            _action(context, 'Attendance', Icons.fact_check, Color(0xFFEF6C00)),
            _action(context, 'Reports', Icons.bar_chart, Color(0xFF6A1B9A)),
            _action(context, 'Fees', Icons.payments, Color(0xFF00897B)),
            _action(context, 'Teachers', Icons.groups, Color(0xFF1565C0)),
          ]),
        ]),
      ),
    );
  }
  Widget _stat(String t, String n, String s, IconData i, Color c) => Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]), child: Column(children: [Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: c.withOpacity(0.1), shape: BoxShape.circle), child: Icon(i, color: c, size: 22)), SizedBox(height: 8), Text(n, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0D2A54))), Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), Text(s, style: TextStyle(fontSize: 10, color: Colors.grey))]));
  Widget _live(String n, String l, String e) => Column(children: [Text(e, style: TextStyle(fontSize: 20)), SizedBox(height: 4), Text(n, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text(l, style: TextStyle(color: Colors.white70, fontSize: 11))]);
  Widget _action(BuildContext ctx, String t, IconData i, Color c) => InkWell(onTap: (){ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('$t opening...')));}, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: c.withOpacity(0.1), shape: BoxShape.circle), child: Icon(i, color: c, size: 26)), SizedBox(height: 10), Text(t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0D2A54)))])));
}
