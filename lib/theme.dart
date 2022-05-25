import 'package:flutter/material.dart';

class ThemeSelector extends ChangeNotifier {
  String themeName = "LIGHT";
  getTheme() {
    return themeName == "DARK" ? darkTheme : lightTheme;
  }

  setTheme(bool isDarkMode) {
    themeName = isDarkMode ? "DARK" : "LIGHT";
    notifyListeners();
  }

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.grey[800],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.black),
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.red),
      subtitle2: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.red),
    ),
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      subtitle2: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
