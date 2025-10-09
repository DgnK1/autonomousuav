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
  late final PageController _pageController;

  final List<Widget> _pages = [
    const HomePage(), // Home Page
    const ActivityPage(), // ActivityPage
    const ManualControlsPage(), // Manual Controls Page
    const SettingsPage(), // Settings Page
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      // Swipe between tabs
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isLight ? Colors.white : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 6,
              spreadRadius: 0,
              offset: Offset(0, -1), // slight glow above bar
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: isLight ? Colors.white : null,
          selectedItemColor: isLight ? Colors.black : null,
          unselectedItemColor: isLight ? Colors.black54 : null,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() => _currentIndex = index);
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
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
      ),
    );
  }
}
