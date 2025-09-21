import 'package:flutter/material.dart';
import 'login_page.dart';
import '../widgets/app_header.dart';
import '../widgets/notifications_sheet.dart';

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
    return ColoredBox(
      color: const Color(0xFFF2F2F2),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (shared) with notifications
            AppHeader(
              title: 'Settings',
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),

            // Page content
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  listTileTheme: const ListTileThemeData(
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C1C),
                    ),
                    subtitleTextStyle: TextStyle(fontSize: 24),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    visualDensity: VisualDensity.comfortable,
                  ),
                  iconTheme: const IconThemeData(size: 22),
                ),
                child: ListView(
                  children: [
                    SwitchListTile(
                      title: const Text('Notification'),
                      secondary: const Icon(Icons.notifications),
                      value: notification,
                      onChanged: (bool value) {
                        setState(() {
                          notification = value;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.dark_mode),
                      title: const Text('Dark Mode'),
                      onTap: () {
                        setState(() {
                          darkMode = !darkMode;
                        });
                        // You can add actual dark mode toggle logic here if needed
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share App'),
                      onTap: () {
                        // Add share app logic
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Privacy Policy'),
                      onTap: () {
                        // Add privacy policy logic
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Terms and Conditions'),
                      onTap: () {
                        // Add terms and conditions logic
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.mail),
                      title: const Text('Contact'),
                      onTap: () {
                        // Add contact logic
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.feedback),
                      title: const Text('Feedback'),
                      onTap: () {
                        // Add feedback logic
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
