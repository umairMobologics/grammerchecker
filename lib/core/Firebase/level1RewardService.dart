import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../databaseHelper/LocalDatabase.dart';
import '../model/RewardCenterModels/Level1RewardModel.dart';

class Level1RewardService {
  static Future<void> saveQuestionsToFirestore(
      List<Level1RewardModel> questions, String category) async {
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

  static Future<List<Level1RewardModel>> fetchQuestionsFromFirestore(
      String category) async {
    // First, check if data exists in the local database
    List<Level1RewardModel> localQuestions = await _getLocalQuestions(category);

    if (localQuestions.isNotEmpty) {
      log("Fetched ${localQuestions.length} questions from local database.");
      return localQuestions; // Return local data if available
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // If no data found in local database, fetch from Firestore
    try {
      QuerySnapshot snapshot = await firestore.collection(category).get();
      List<Level1RewardModel> questions = snapshot.docs
          .map((doc) =>
              Level1RewardModel.fromJson(doc.data() as Map<String, dynamic>))
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
      log("Fetched ${questions.length} questions from firebase");

      // Save the fetched questions to the local database for future use
      await _saveQuestionsToLocalDatabase(questions, category);

      return questions;
    } catch (e) {
      log("Error fetching questions: $e");
      return [];
    }
  }

  // Method to get questions from local database
  static Future<List<Level1RewardModel>> _getLocalQuestions(
      String category) async {
    // Fetch all questions from local database that belong to this category
    // You might want to add filtering based on the category in your database
    try {
      List<Level1RewardModel> localQuestions =
          await DatabaseHelper().getLevel1RewardData();
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
      List<Level1RewardModel> questions, String category) async {
    try {
      // Save questions to local database
      await DatabaseHelper().saveLevel1RewardData(questions);
      log("Saved ${questions.length} questions to local database ");
    } catch (e) {
      log("Error saving questions to local database: $e");
    }
  }
}
