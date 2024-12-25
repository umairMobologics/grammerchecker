// Check SharedPreferences to see if the intro has been shown
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkIfIntroShown(String key) async {
  final prefs = await SharedPreferences.getInstance();
  bool _hasSeenIntro = await prefs.getBool(key) ?? false;

  // If intro hasn't been shown yet, start the intro
  if (!_hasSeenIntro) {
    // Show the intro
    // Set the flag in SharedPreferences to true
    prefs.setBool(key, true);
    return true;
  } else {
    return false;
  }
}
