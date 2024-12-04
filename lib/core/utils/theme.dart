import 'package:flutter/material.dart';

// Define your color constants
class AppColors {
  static const Color waveColor = Colors.blue; // Adjust as needed
  static const Color waveBackgroundColor = Colors.grey; // Adjust as needed
  static const Color progressTextColor = Color.fromARGB(255, 233, 69, 5);
  static const Color blue =
      Color.fromARGB(255, 13, 230, 67); // Adjust as needed
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const lightBLue = Color(0xFF6179cd);
  static const grey = Colors.grey;
}

// Define your app theme
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
}
