import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  // Getter for dark mode status
  bool get isDarkMode => _isDarkMode;

  // Function to toggle theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners about the theme change
  }

  // Method to get the appropriate ThemeData based on dark mode status
  ThemeData getTheme() {
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
