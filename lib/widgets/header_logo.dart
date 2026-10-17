import 'package:flutter/material.dart';

class HeaderLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFF2196F3),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png', width: 50, height: 50),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SALAAMA MUSLIM JUNIOR SCHOOL",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text("DESTINED TO SUCCEED",
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }
}