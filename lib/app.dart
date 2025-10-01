import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'theme_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Autonomous UAV',
          debugShowCheckedModeBanner: false,
          // Light and Dark themes
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF222222),
            cardColor: const Color(0xFF3B3B3B),
            dividerColor: Colors.white24,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
              headlineSmall: TextStyle(color: Colors.white),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF222222),
              onSurface: Colors.white,
              surfaceVariant: Color(0xFF3B3B3B),
              onSurfaceVariant: Colors.white70,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(Color(0xFF3B3B3B)),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
                textStyle: const WidgetStatePropertyAll(
                  TextStyle(fontWeight: FontWeight.bold),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
            ),
          ),
          themeMode: mode, // Defaults to dark (see AppTheme)
          home: LoginPage(),
        );
      },
    );
  }
}
