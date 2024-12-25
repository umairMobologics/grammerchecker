import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grammar_checker_app_updated/core/databaseHelper/LocalDatabase.dart';
import 'package:grammar_checker_app_updated/core/model/CourseModel.dart';

class FirebaseCourseServices {
  //cave course to firebase
  static Future<void> saveLevelToFirestore(
      GrammarLevel level, String levelno) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('grammarCourses')
          .doc(levelno)
          .set(level.toJson());
      log("Level 1 data saved successfully in Firebase.");
    } catch (e) {
      log("Error saving level data: $e");
    }
  }

  // Combined function to retrieve from local database, else fetch from Firebase
  static Future<GrammarLevel?> fetchLevelFromFirestore(String levelId) async {
    final DatabaseHelper _dbHelper = DatabaseHelper();

    try {
      // Step 1: Check local database
      GrammarLevel? localLevel =
          await _dbHelper.getGrammarLevelFromDatabase(levelId);
      if (localLevel != null) {
        // Return if found locally
        log("found in local database");
        return localLevel;
      }

      // Step 2: If not found, fetch from Firebase Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot doc =
          await firestore.collection('grammarCourses').doc(levelId).get();

      if (doc.exists) {
        // Convert Firestore document data to GrammarLevel model
        GrammarLevel fetchedLevel =
            GrammarLevel.fromMap(doc.data() as Map<String, dynamic>);

        // Step 3: Save the fetched data to local database
        await _dbHelper.saveGrammarLevelToDatabase(fetchedLevel, levelId);

        // Return the fetched data
        return fetchedLevel;
      } else {
        throw 'Document not found!';
      }
    } catch (e) {
      throw 'Error retrieving course data: $e';
    }
  }

  static Future<void> printLevelData(String levelId) async {
    try {
      // Fetch the GrammarLevel data
      GrammarLevel? level =
          await FirebaseCourseServices.fetchLevelFromFirestore(levelId);

      if (level != null) {
        log("""
      GrammarLevel(
        title: "${level.title}",
        comprehensiveExplanation: "${level.comprehensiveExplanation}",
        importance: "${level.importance}",
        modules: [
          ${level.modules.map((module) => """
          Module(
            moduleTitle: "${module.moduleTitle}",
            lessonContent: LessonContent(
              explanation: "${module.lessonContent.explanation}",
              examples: [
                ${module.lessonContent.examples.map((example) => """
                Example(
                  sentence: "${example.sentence}",
                  explanation: "${example.explanation}",
                )
                """).join(",")}
              ],
            ),
          )
          """).join(",")}
        ],
      ),
      """);
      } else {
        log("No data found for levelId: $levelId");
      }
    } catch (e) {
      log("Error fetching and printing level data: $e");
    }
  }
}

// GrammarLevel? level1 = await fetchLevelFromFirestore();
// if (level1 != null) {
//   // Now you can display level1's data in the UI or save it locally
// }
