import 'dart:convert';
import 'dart:developer';

import 'package:grammar_checker_app_updated/core/model/CourseModel.dart';
import 'package:grammar_checker_app_updated/core/model/QuizModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/RewardCenterModels/Level1RewardModel.dart';
import '../model/RewardCenterModels/level2RewardModel.dart';
import '../model/RewardCenterModels/level3RewardModel.dart';
import '../model/TutorModels/tutorModel.dart';

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
      version: 6,
      onCreate: (db, version) {
        // Create existing tables
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

        // Create new courses table
        db.execute(
          '''
          CREATE TABLE courses (
            level_id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT
          )
        ''',
        );

        // Create new table for Level1RewardModel
        db.execute(
          '''
          CREATE TABLE level1_rewards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unshuffledCharacters TEXT,
            correctAnswer TEXT,
            explanation TEXT
          )
        ''',
        );

        // Create new table for Level2RewardModel
        db.execute(
          '''
          CREATE TABLE level2_rewards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unshuffledWords TEXT,
            correctAnswer TEXT,
            explanation TEXT
          )
        ''',
        );

        // Create new table for Level3RewardModel
        db.execute(
          '''
          CREATE TABLE level3_rewards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unshuffledWords TEXT,
            options TEXT,
            correctAnswer TEXT,
            explanation TEXT
          )
        ''',
        );
        // Create other tables here if needed
        db.execute('''
          CREATE TABLE tutors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userName TEXT,
            userGender TEXT,
            selectedLevel TEXT,
            nativeLanguage TEXT,
            learningPurposes TEXT,
            tutorName TEXT,
            tutorAvatar TEXT,
            customAvatar TEXT,
            uniqueTutorID TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle database upgrade
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
        if (oldVersion < 5) {
          db.execute(
            '''
            CREATE TABLE courses (
              level_id TEXT PRIMARY KEY,
              title TEXT,
              content TEXT
            )
          ''',
          );
        }
        if (oldVersion < 6) {
          // Create other tables here if needed
          db.execute('''
          CREATE TABLE tutors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userName TEXT,
            userGender TEXT,
            selectedLevel TEXT,
            nativeLanguage TEXT,
            learningPurposes TEXT,
            tutorName TEXT,
            tutorAvatar TEXT,
            customAvatar TEXT,
            uniqueTutorID TEXT
          )
        ''');
        }

        if (oldVersion < 7) {
          // Create new table for Level1RewardModel
          db.execute(
            '''
          CREATE TABLE level1_rewards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unshuffledCharacters TEXT,
            correctAnswer TEXT,
            explanation TEXT
          )
        ''',
          );

          // Create new table for Level2RewardModel
          db.execute(
            '''
          CREATE TABLE level2_rewards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unshuffledWords TEXT,
            correctAnswer TEXT,
            explanation TEXT
          )
        ''',
          );

          // Create new table for Level3RewardModel
          db.execute(
            '''
          CREATE TABLE level3_rewards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unshuffledWords TEXT,
            options TEXT,
            correctAnswer TEXT,
            explanation TEXT
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
      log("data deleted from $tableName");
    });
  }

  // Save a tutor to the database
  Future<void> saveTutor(TutorModel tutor) async {
    try {
      final db = await database;

      // Convert learning purposes list to a comma-separated string
      final learningPurposes = tutor.learningPurposes.join(',');

      await db.insert(
        'tutors',
        {
          'userName': tutor.userName,
          'userGender': tutor.userGender,
          'selectedLevel': tutor.selectedLevel,
          'nativeLanguage': tutor.nativeLanguage,
          'learningPurposes': learningPurposes,
          'tutorName': tutor.tutorName,
          'tutorAvatar': tutor.tutorAvatar,
          'customAvatar': tutor.customAvatar, // Save file path
          'uniqueTutorID': tutor.uniqueTutorID, // Save file path
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log("tutor added to local Db successfully");
    } catch (e) {
      log("error while addign $e");
    }
  }

  // Fetch all tutors from the database
  Future<List<TutorModel>> fetchAllTutors() async {
    final db = await database;
    final result = await db.query('tutors');
    log("result: ${result.length}");
    return result.map((data) {
      return TutorModel(
        userName: data['userName'] as String,
        userGender: data['userGender'] as String,
        selectedLevel: data['selectedLevel'] as String,
        nativeLanguage: data['nativeLanguage'] as String,
        learningPurposes: (data['learningPurposes'] as String).split(','),
        tutorName: data['tutorName'] as String,
        tutorAvatar: data['tutorAvatar'] as String,
        customAvatar: data['customAvatar'] != null
            ? data['customAvatar'] as String
            : null,
        uniqueTutorID: data['uniqueTutorID'] as String,
      );
    }).toList();
  }

  Stream<List<TutorModel>> tutorsStream() async* {
    final db = await database;
    yield* Stream.periodic(const Duration(seconds: 1), (_) async {
      final List<Map<String, dynamic>> maps = await db.query('tutors');

      return maps.map((map) => TutorModel.fromMap(map)).toList();
    }).asyncMap((event) async => await event);
  }

  // Delete a specific tutor by ID
  Future<int> deleteTutor(String ConversationID) async {
    final db = await database;
    return await db.delete(
      'tutors',
      where: 'uniqueTutorID = ?',
      whereArgs: [ConversationID],
    );
  }

  // Save Level1RewardModel data to the database
  Future<void> saveLevel1RewardData(List<Level1RewardModel> rewardList) async {
    final db = await database;
    try {
      await clearTable('level1_rewards'); // Clear existing data
      for (var reward in rewardList) {
        await db.insert(
          'level1_rewards',
          {
            'unshuffledCharacters': reward.question,
            'correctAnswer': reward.correctAnswer,
            'explanation': reward.explanation,
          },
        );
      }
      log('Level 1 Reward Data saved successfully');
    } catch (e) {
      log('Error saving level 1 reward data: $e');
    }
  }

  // Fetch Level1RewardModel data from the database
  Future<List<Level1RewardModel>> getLevel1RewardData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('level1_rewards');
    return List.generate(maps.length, (i) {
      return Level1RewardModel.fromMap(maps[i]);
    });
  }

  // Save Level2RewardModel data to the database
  Future<void> saveLevel2RewardData(List<Level2RewardModel> rewardList) async {
    final db = await database;
    try {
      await clearTable('level2_rewards'); // Clear existing data
      for (var reward in rewardList) {
        await db.insert(
          'level2_rewards',
          {
            'unshuffledWords': reward.question,
            'correctAnswer': reward.correctAnswer,
            'explanation': reward.explanation,
          },
        );
      }
      log('Level 2 Reward Data saved successfully');
    } catch (e) {
      log('Error saving level 2 reward data: $e');
    }
  }

  // Fetch Level2RewardModel data from the database
  Future<List<Level2RewardModel>> getLevel2RewardData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('level2_rewards');
    return List.generate(maps.length, (i) {
      return Level2RewardModel.fromMap(maps[i]);
    });
  }

  // Save Level3RewardModel data to the database
  Future<void> saveLevel3RewardData(List<Level3RewardModel> rewardList) async {
    final db = await database;
    try {
      await clearTable('level3_rewards'); // Clear existing data
      for (var reward in rewardList) {
        await db.insert(
          'level3_rewards',
          {
            'unshuffledWords': reward.question,
            'options': reward.options,
            'correctAnswer': reward.correctAnswer,
            'explanation': reward.explanation,
          },
        );
      }
      log('Level 3 Reward Data saved successfully');
    } catch (e) {
      log('Error saving level 3 reward data: $e');
    }
  }

  // Fetch Level3RewardModel data from the database
  Future<List<Level3RewardModel>> getLevel3RewardData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('level3_rewards');
    return List.generate(maps.length, (i) {
      return Level3RewardModel.fromMap(maps[i]);
    });
  }

  // Save list of QuizModel objects to vocabulary table
  Future<void> saveWordToDatabase(List<QuizModel> wordDetailsList) async {
    final Database db = await database;
    try {
      await clearTable('vocabulary');
      for (var wordDetails in wordDetailsList) {
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
      }
      log('Save successful');
    } catch (e) {
      log('Error saving to database: $e');
    }
  }

  Future<List<QuizModel>> getAllWordsFromDatabase() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vocabulary');
    return List.generate(maps.length, (i) {
      return QuizModel.fromMap(maps[i]);
    });
  }

  Future<void> saveGrammarLevelToDatabase(
      GrammarLevel data, String level) async {
    final db = await database;
    try {
      // Convert the entire GrammarLevel object to a JSON string
      String jsonData = jsonEncode(data.toJson());

      // Insert or update the course
      await db.insert(
        'courses',
        {'title': level, 'content': jsonData},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('Grammar level saved successfully');
    } catch (e) {
      print('Error saving grammar level to database: $e');
    }
  }

  Future<GrammarLevel?> getGrammarLevelFromDatabase(String title) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'courses',
      where: 'title = ?',
      whereArgs: [title],
    );

    if (maps.isNotEmpty) {
      // Decode the JSON string from the 'content' field
      Map<String, dynamic> data = jsonDecode(maps.first['content']);
      return GrammarLevel.fromMap(data);
    } else {
      return null; // No data found
    }
  }

  // New methods for completion dates
  Future<void> addCompletionDate(DateTime date) async {
    final db = await database;
    await db.insert('completion_dates', {'date': date.toIso8601String()});
  }

  Future<List<DateTime>> getCompletionDates() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('completion_dates');
    return List.generate(maps.length, (i) {
      return DateTime.parse(maps[i]['date']);
    });
  }
}