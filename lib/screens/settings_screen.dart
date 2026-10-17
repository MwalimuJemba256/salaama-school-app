import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeService themeService = ThemeService();
  String language = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings - Changeable"), backgroundColor: Color(0xFF2196F3)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(title: Text("School: SALAAMA MUSLIM JUNIOR SCHOOL"), subtitle: Text("SALAAMA ROAD, KAMPALA")),
            ListTile(title: Text("Contact: 0702642786"), subtitle: Text("Motto: DESTINED TO SUCCEED")),
            Divider(),
            ListTile(
              title: Text("Primary Color - Bright Blue Changeable"),
              subtitle: Text("Current: #2196F3"),
              trailing: CircleAvatar(backgroundColor: Color(0xFF2196F3)),
              onTap: () {
                // Color picker logic - simple toggle
                themeService.setColor(Color(0xFF1B5E20)); // Example change to Islamic Green
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Theme changed - Saved!")));
              },
            ),
            ListTile(
              title: Text("Language"),
              subtitle: Text(language),
              trailing: DropdownButton<String>(
                value: language,
                items: ["English", "Arabic - عربي"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => language = v!),
              ),
            ),
            ListTile(title: Text("Students Total"), subtitle: Text("Secular 120 | Arabic 95 | Quran 60 = 275")),
          ],
        ),
      ),
    );
  }
}