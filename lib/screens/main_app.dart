import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'activity_page.dart';
import 'manual_controls_page.dart';
import 'settings_page.dart';
import '../providers/flight_mode_provider.dart';

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

  void _showManualModeRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Mode Required'),
        content: const Text(
          'Please switch to Manual Mode from the Home page to access Manual Controls.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final flightModeProvider = Provider.of<FlightModeProvider>(context);
    final isManualMode = flightModeProvider.isManualMode;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      // Swipe between tabs
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          // Prevent navigating to Manual Controls (index 2) when in Auto mode
          if (index == 2 && !isManualMode) {
            // Revert to previous page
            Future.microtask(() {
              _pageController.jumpToPage(_currentIndex);
              _showManualModeRequiredDialog();
            });
            return;
          }
          setState(() => _currentIndex = index);
        },
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
            // Prevent tapping Manual Controls (index 2) when in Auto mode
            if (index == 2 && !isManualMode) {
              _showManualModeRequiredDialog();
              return;
            }
            setState(() => _currentIndex = index);
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          },
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
            const BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_rounded),
              label: 'ACTIVITY',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.gamepad,
                color: isManualMode 
                  ? (isLight ? Colors.black54 : null) 
                  : Colors.grey.shade400,
              ),
              label: 'MANUAL',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'SETTINGS',
            ),
          ],
        ),
      ),
    );
  }
}
