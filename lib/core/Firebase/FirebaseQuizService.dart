import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grammer_checker_app/core/databaseHelper/QuizDatabase.dart';
import 'package:grammer_checker_app/core/model/QuizModel.dart';
import 'package:grammer_checker_app/data/sendQuizRequest.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchQuizDataController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Timestamp key for Shared Preferences
  static const String _localTimestampKey = 'local_timestamp';
//****************************************************************************************************************************************
  Future<void> initializeQuizQuestions() async {
    // Check local database
    try {
      List<QuizModel> localQuizzes =
          await _databaseHelper.getAllWordsFromDatabase();
      if (localQuizzes.isNotEmpty) {
        log("Data found in local database");
        quizController.multipleChoice.clear();
        quizController.multipleChoice.addAll(localQuizzes);
        quizController.multipleChoice.shuffle();
        // Use local data
        return;
      }

      log("No local data found, checking Firebase...");

      // No local data, check Firebase Firestore
      final CollectionReference quizCollection =
          _firestore.collection('quizData');
      final DocumentSnapshot quizDataDoc =
          await quizCollection.doc('quizList').get();
      final DocumentSnapshot timestampDoc =
          await quizCollection.doc('quizTimestamp').get();

      if (quizDataDoc.exists && timestampDoc.exists) {
        log("Data found in Firebase");

        // Cast quizDataDoc.data() to Map<String, dynamic>? before accessing 'quizzes'
        List<QuizModel> firebaseQuizzes =
            ((quizDataDoc.data() as Map<String, dynamic>)['quizzes'] as List)
                .map((data) => QuizModel.fromMap(data as Map<String, dynamic>))
                .toList();

        String firebaseTimestamp = timestampDoc['timestamp'];

        // Save data and timestamp locally
        await _databaseHelper.saveWordToDatabase(firebaseQuizzes);
        await _updateLocalTimestamp(firebaseTimestamp);
        quizController.initializeQuizQuestions();

        return;
      }

      log("No data found in Firebase. Fetching from API...");

      // No data in Firebase, request from API
      List<QuizModel> apiQuizzes = await QuizAPI.fetchQUIZResponse();
      if (apiQuizzes.isNotEmpty) {
        String currentTimestamp = _generateCurrentTimestamp();

        // Save API data to both local database and Firebase
        await _databaseHelper.saveWordToDatabase(apiQuizzes);
        quizController.initializeQuizQuestions();
        await quizCollection
            .doc('quizList')
            .set({'quizzes': apiQuizzes.map((q) => q.toMap()).toList()});
        await quizCollection
            .doc('quizTimestamp')
            .set({'timestamp': currentTimestamp});

        // Save timestamp locally
        await _updateLocalTimestamp(currentTimestamp);
      } else {
        initializeQuizQuestions();
      }
    } on Exception catch (e) {
      // TODO
      log("Exception in initializeQuizQuestions: $e");
    } catch (e, stackTrace) {
      log("Error in initializeQuizQuestions: $e");
      log("Stack trace: $stackTrace");
    }
  }

  //refresh quiz data**********************************************************************************************************************
  Future<void> refreshQuizData() async {
    // Step 1: Clear local database
    try {
      await _databaseHelper.clearTable('vocabulary');
      log('Local quiz database cleared.');

      // Step 2: Retrieve Firebase timestamp and data
      final CollectionReference quizCollection =
          _firestore.collection('quizData');
      final DocumentSnapshot quizDataDoc =
          await quizCollection.doc('quizList').get();
      final DocumentSnapshot timestampDoc =
          await quizCollection.doc('quizTimestamp').get();

      if (timestampDoc.exists) {
        String firebaseTimestamp = timestampDoc['timestamp'];
        String localTimestamp = await _getLocalTimestamp();

        if (firebaseTimestamp == localTimestamp) {
          // Step 3a: Timestamps match - call API
          log("Timestamps match. Fetching data from API.");

          // Fetch data from API
          List<QuizModel> apiQuizzes = await QuizAPI.fetchQUIZResponse();
          if (apiQuizzes.isNotEmpty) {
            String currentTimestamp = _generateCurrentTimestamp();

            // Save API data to Firebase and local database
            await _updateFirebaseData(apiQuizzes, currentTimestamp);
            await _databaseHelper.saveWordToDatabase(apiQuizzes);
            // Save timestamp locally
            await _updateLocalTimestamp(currentTimestamp);
            quizController.initializeQuizQuestions();

            log("API data saved to Firebase and local database.");
            // CustomSnackbar.showSnackbar(
            //     "A new grammar test has been generated", SnackPosition.TOP);
          } else {
            refreshQuizData();
          }
        } else {
          // Step 3b: Timestamps do not match - fetch data from Firebase
          log("Timestamps do not match. Fetching updated data from Firebase.");

          // Cast quizDataDoc.data() to Map<String, dynamic>? before accessing 'quizzes'
          List<QuizModel> firebaseQuizzes = ((quizDataDoc.data()
                  as Map<String, dynamic>)['quizzes'] as List)
              .map((data) => QuizModel.fromMap(data as Map<String, dynamic>))
              .toList();
          // Save data and timestamp locally
          await _databaseHelper.saveWordToDatabase(firebaseQuizzes);
          await _updateLocalTimestamp(firebaseTimestamp);
          quizController.initializeQuizQuestions();
          log("Firebase data saved to local database and local timestamp updated.");
          // CustomSnackbar.showSnackbar(
          //     "A new grammar test has been generated", SnackPosition.TOP);
        }
      } else {
        log("Error: Firebase timestamp document does not exist.");
      }
    } on Exception catch (e) {
      // TODO
      log("Exception in refreshQuizData: $e");
    } catch (e, stackTrace) {
      log("Error in refreshQuizData: $e");
      log("Stack trace: $stackTrace");
    }
  }

// Helper function to update Firebase with new quiz data and timestamp*************************************************************************
  Future<void> _updateFirebaseData(
      List<QuizModel> quizzes, String timestamp) async {
    final CollectionReference quizCollection =
        _firestore.collection('quizData');

    // Save quiz list and timestamp to Firebase********************************************************************
    await quizCollection
        .doc('quizList')
        .set({'quizzes': quizzes.map((quiz) => quiz.toMap()).toList()});
    await quizCollection.doc('quizTimestamp').set({'timestamp': timestamp});

    log("Firebase data and timestamp updated.");
  }

// Helper function to retrieve local timestamp from SharedPreferences********************************************************************
  Future<String> _getLocalTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('quiz_timestamp') ?? '';
  }

// Helper function to update local timestamp in SharedPreferences********************************************************************
  Future<void> _updateLocalTimestamp(String timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_timestamp', timestamp);
    log("Local timestamp updated to $timestamp.");
  }

  // Helper function to generate current timestamp in 'yyyyMMddHHmmss' format********************************************************************
  String _generateCurrentTimestamp() {
    return DateFormat('yyyyMMddHHmmss').format(DateTime.now());
  }
}
