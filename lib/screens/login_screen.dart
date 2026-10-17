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
              Center(
                child: Icon(Icons.school, size: 80, color: Color(0xFF0D2A54)),
              ),
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
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0D2A54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _goToDemo();
                  },
                  child: Text('LOGIN WITH OTP', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Text('For Testing (No OTP needed):', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _goToDemo();
                  },
                  child: Text('DEMO LOGIN - HEAD TEACHER', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _goToDemoTeacher();
                  },
                  child: Text('DEMO LOGIN - TEACHER', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 30),
              Center(child: Text('275 Students • Live Monitoring', style: TextStyle(color: Colors.grey, fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }

  void _goToDemo() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DemoAdminScreen()));
  }

  void _goToDemoTeacher() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DemoTeacherScreen()));
  }
}

class DemoAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HEAD TEACHER - Admin'), backgroundColor: Color(0xFF0D2A54)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.check_circle, size: 100, color: Colors.green),
          SizedBox(height: 20),
          Text('LOGIN SUCCESS!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('275 Students Live', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Ordinary | Tahfiz | Non-Teaching', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 30),
          ElevatedButton(onPressed: () {}, child: Text('View Dashboard')),
        ]),
      ),
    );
  }
}

class DemoTeacherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TEACHER Dashboard'), backgroundColor: Colors.orange),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.person, size: 100, color: Colors.orange),
          SizedBox(height: 20),
          Text('TEACHER LOGIN SUCCESS!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Start Class - Islamic / Secular Tabs'),
          SizedBox(height: 30),
          ElevatedButton(onPressed: () {}, child: Text('Start Class')),
        ]),
      ),
    );
  }
}
