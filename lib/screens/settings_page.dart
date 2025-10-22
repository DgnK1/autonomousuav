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
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (shared) with notifications
            AppHeader(
              title: 'Settings',
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),

            // Page content
            Expanded(
              child: Theme(
                data: theme.copyWith(
                  listTileTheme: ListTileThemeData(
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    subtitleTextStyle: const TextStyle(fontSize: 24),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
