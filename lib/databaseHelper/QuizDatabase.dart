import 'dart:developer';

import 'package:grammer_checker_app/model/QuizModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'vocabulary.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE vocabulary (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            difficulty_level TEXT,
            quiz_question TEXT,
            multiple_choice_a TEXT,
            multiple_choice_b TEXT,
            multiple_choice_c TEXT,
            multiple_choice_d TEXT,
            correct_answer TEXT
          )
        ''',
        );
        db.execute(
          '''
          CREATE TABLE completion_dates (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL
          )
        ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {}
        if (oldVersion < 3) {
          db.execute(
            '''
            CREATE TABLE completion_dates (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT NOT NULL
            )
          ''',
          );
        }
      },
    );
  }

  Future<void> clearTable(String tableName) async {
    final db = await database;
    await db.delete(tableName).then((onValue) {
      log("data deleted");
    });
  }

  Future<void> saveWordToDatabase(List<QuizModel> wordDetailsList) async {
    final Database db = await database;

    try {
      // Clear the vocabulary table before inserting new data
      await clearTable('vocabulary');

      // Use a for-loop to iterate through each word details map
      for (var wordDetails in wordDetailsList) {
        log("word detaul $wordDetails");
        await db.insert(
          'vocabulary',
          {
            'difficulty_level': wordDetails.difficultyLevel,
            'quiz_question': wordDetails.quizQuestion,
            'multiple_choice_a': wordDetails.multipleChoiceA,
            'multiple_choice_b': wordDetails.multipleChoiceB,
            'multiple_choice_c': wordDetails.multipleChoiceC,
            'multiple_choice_d': wordDetails.multipleChoiceD,
            'correct_answer': wordDetails.correctAnswer,
          },
        );
        log('Word saved successfully: ${wordDetails.quizQuestion}');
      }
      log('Save successful');
    } catch (e) {
      log('Error saving to database: $e');
      // showToast(message: 'Failed to save');
    }
  }

  Future<List<QuizModel>> getAllWordsFromDatabase() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vocabulary');

    return List.generate(maps.length, (i) {
      return QuizModel.fromMap(maps[i]);
    });
  }

  Future<void> updateFavoriteStatus(int id, int favorite) async {
    final Database db = await database;
    await db.update(
      'vocabulary',
      {'favorite': favorite},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // New methods for completion dates

  Future<void> addCompletionDate(DateTime date) async {
    try {
      final db = await database;
      await db.insert('completion_dates', {'date': date.toIso8601String()});
      log('Save successful');
    } catch (e) {
      log('Unsuccess full');
    }
  }

  Future<List<DateTime>> getCompletionDates() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('completion_dates');

    return List.generate(maps.length, (i) {
      return DateTime.parse(maps[i]['date']);
    });
  }
}
