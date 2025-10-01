import 'package:flutter/material.dart';

/// Simple global theme controller using ValueNotifier.
/// Defaults to Dark Mode.
class AppTheme {
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static void toggle() {
    final isDark = themeMode.value == ThemeMode.dark;
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  static void set(ThemeMode mode) {
    themeMode.value = mode;
  }
}
