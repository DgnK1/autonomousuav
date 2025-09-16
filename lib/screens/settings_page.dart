import 'package:flutter/material.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notification = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDark ? Color(0xFF121212) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notification'),
            secondary: Icon(Icons.notifications),
            value: notification,
            onChanged: (bool value) {
              setState(() {
                notification = value;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            onTap: () {
              setState(() {
                darkMode = !darkMode;
              });
              // You can add actual dark mode toggle logic here if needed
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate App'),
            onTap: () {
              // Add rate app logic
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share App'),
            onTap: () {
              // Add share app logic
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy Policy'),
            onTap: () {
              // Add privacy policy logic
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Terms and Conditions'),
            onTap: () {
              // Add terms and conditions logic
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text('Cookies Policy'),
            onTap: () {
              // Add cookies policy logic
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Contact'),
            onTap: () {
              // Add contact logic
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {
              // Add feedback logic
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
