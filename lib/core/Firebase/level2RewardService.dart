import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grammer_checker_app/core/model/RewardCenterModels/level2RewardModel.dart';

import '../databaseHelper/QuizDatabase.dart';

class Level2RewardService {
  static Future<void> saveQuestionsToFirestore(
      List<Level2RewardModel> questions, String category) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Clear existing data in the category collection first
      QuerySnapshot existingData = await firestore.collection(category).get();
      for (var doc in existingData.docs) {
        await doc.reference.delete();
      }

      // Create a batch for adding new data
      WriteBatch batch = firestore.batch();
      for (var question in questions) {
        DocumentReference docRef = firestore.collection(category).doc();
        batch.set(docRef, question.toJson()); // Add new question to batch
      }

      // Commit the batch to add new data
      await batch.commit();
      log("Questions saved successfully in Firebase under category: $category.");
    } catch (e) {
      log("Error saving questions: $e");
    }
  }

  static Future<List<Level2RewardModel>> fetchQuestionsFromFirestore(
      String category) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // First, check if data exists in the local database
    List<Level2RewardModel> localQuestions = await _getLocalQuestions(category);

    if (localQuestions.isNotEmpty) {
      log("Fetched ${localQuestions.length} questions from local database.");
      return localQuestions; // Return local data if available
    }

    // If no data found in local database, fetch from Firestore
    try {
      QuerySnapshot snapshot = await firestore.collection(category).get();
      List<Level2RewardModel> questions = snapshot.docs
          .map((doc) =>
              Level2RewardModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      // Print each question in the required format
      for (var question in questions) {
        log("""
      Level2RewardModel(
        question: "${question.question}",
        correctAnswer: "${question.correctAnswer}",
        explanation: "${question.explanation}",
      ),
      """);
      }
      log("Fetched ${questions.length} questions from Firebase.");

      // Save the fetched questions to the local database for future use
      await _saveQuestionsToLocalDatabase(questions, category);

      return questions;
    } catch (e) {
      log("Error fetching questions: $e");
      return [];
    }
  }

  // Method to get questions from local database
  static Future<List<Level2RewardModel>> _getLocalQuestions(
      String category) async {
    // Fetch all questions from local database that belong to this category
    // You might want to add filtering based on the category in your database
    try {
      List<Level2RewardModel> localQuestions =
          await DatabaseHelper().getLevel2RewardData();
      // Print each question in the required format
      for (var question in localQuestions) {
        log("""
      Level2RewardModel(
        question: "${question.question}",
        correctAnswer: "${question.correctAnswer}",
        explanation: "${question.explanation}",
      ),
      """);
      }
      // Return the questions from the local DB
      return localQuestions;
    } catch (e) {
      log("error $e");
      return [];
    }
  }

  // Method to save questions to the local database
  static Future<void> _saveQuestionsToLocalDatabase(
      List<Level2RewardModel> questions, String category) async {
    try {
      // Save questions to local database
      await DatabaseHelper().saveLevel2RewardData(questions);
      log("Saved ${questions.length} questions to local database.");
    } catch (e) {
      log("Error saving questions to local database: $e");
    }
  }
//   void saveQuizData() {
//   FirebaseQuizService.saveQuestionsToFirestore(quizQuestions, "adFreeRewardQuiz");
// }
// void getQuizData() async {
//   List<QuizQuestion> fetchedQuestions =
//       await FirebaseQuizService.fetchQuestionsFromFirestore("adFreeRewardQuiz");

//   for (var question in fetchedQuestions) {
//     log("Question: ${question.unshuffledWords}, Answer: ${question.correctAnswer}");
//   }
// }

// void main() {
//   String question = "sun / rises / the / in / east / the";

//   // Extract words by splitting the string on spaces or slashes
//   List<String> words = question.split(RegExp(r'\s+|\/')).where((word) => word.isNotEmpty).toList();

//   // Print extracted words
//   for (var word in words) {
//     print(word);
//   }
// }

  // Split the question into words
//     List<String> words = question.split(RegExp(r'\s+|\/')).where((word) => word.isNotEmpty).toList();
}
