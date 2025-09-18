import 'package:flutter/material.dart';
import 'home_page.dart';
import 'activity_page.dart';
import 'manual_controls_page.dart';
import 'settings_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Home Page
    const ActivityPage(), // ActivityPage
    const ManualControlsPage(), // Manual Controls Page
    const SettingsPage(), // Settings Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            label: 'ACTIVITY',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'MANUAL'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'SETTINGS',
          ),
        ],
      ),
    );
  }
}
