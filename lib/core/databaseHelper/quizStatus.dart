import 'package:shared_preferences/shared_preferences.dart';

class QuizCompletionStatus {
  static const String _easyQuizKey = "easy_quiz_completed";
  static const String _intermediateQuizKey = "intermediate_quiz_completed";
  static const String _hardQuizKey = "hard_quiz_completed";

  // Function to mark a quiz as completed
  static Future<void> markQuizAsCompleted(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    if (difficulty == "Easy") {
      await prefs.setBool(_easyQuizKey, true);
    } else if (difficulty == "Intermediate") {
      await prefs.setBool(_intermediateQuizKey, true);
    } else if (difficulty == "Hard") {
      await prefs.setBool(_hardQuizKey, true);
    }
  }

  // Function to mark a quiz as completed
  static Future<void> resetQuizAsFalse() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_easyQuizKey, false);

    await prefs.setBool(_intermediateQuizKey, false);

    await prefs.setBool(_hardQuizKey, false);
  }

  // Function to mark a quiz as completed
  static Future<void> markQuiz() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("hard_quiz_completed", false);
  }

  // Check if a specific quiz level is completed
  static Future<bool> isQuizCompleted(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    if (difficulty == "Easy") {
      return prefs.getBool(_easyQuizKey) ?? false;
    } else if (difficulty == "Intermediate") {
      return prefs.getBool(_intermediateQuizKey) ?? false;
    } else if (difficulty == "Hard") {
      return prefs.getBool(_hardQuizKey) ?? false;
    }
    return false;
  }

  // Check if all quizzes are completed
  static Future<bool> areAllQuizzesCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_easyQuizKey) ?? false) &&
        (prefs.getBool(_intermediateQuizKey) ?? false) &&
        (prefs.getBool(_hardQuizKey) ?? false);
  }
}
