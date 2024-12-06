import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/core/Firebase/level2RewardService.dart';
import 'package:grammer_checker_app/core/model/RewardCenterModels/level2RewardModel.dart';

import '../../core/Firebase/level1RewardService.dart';
import '../../core/Firebase/level3RewardService.dart';
import '../../core/model/RewardCenterModels/Level1RewardModel.dart';
import '../../core/model/RewardCenterModels/level3RewardModel.dart';

class RewardQuizController extends GetxController {
  var isPop = false.obs;
  String level1category = "creditFreeRewardQuiz";
  String level2category = "adFreeRewardQuiz";
  String level3category = "level3RewardQuiz";
  var level1Question = <Level1RewardModel>[].obs;
  var level2Question = <Level2RewardModel>[].obs;
  var level3Question = <Level3RewardModel>[].obs;

  var selectedWords = <String>[].obs; // Store the selected words in order
  var isQuizCompleted = false.obs;
  var correctAnswersCount = 0.obs;
  var resultPercentage = 0.0.obs;

  var currentPageIndex = 1.obs;
  var WordLength = 0.obs;

  PageController pageController = PageController();
// Declare tempWords as an RxList
  RxList<String> tempWords = <String>[].obs;

  var isLoading = false.obs;

  final Random _random = Random();
  final Map<String, Color> _wordColors = {};

  Color getRandomColorForWord(String word) {
    if (!_wordColors.containsKey(word)) {
      _wordColors[word] = getRandomColor();
    }
    return _wordColors[word]!;
  }

  Color getRandomColor() {
    // Generate a random color
    return Color.fromARGB(
      255, // Full opacity
      _random.nextInt(256), // Red (0-255)
      _random.nextInt(256), // Green (0-255)
      _random.nextInt(256), // Blue (0-255)
    );
  }

  // Fetch questions from Firebase
  Future<void> fetchLevel3Questions(String category) async {
    try {
      isLoading.value = true;
      var fetchedQuestions =
          await Level3RewardService.fetchQuestionsFromFirestore(category);
      level3Question.assignAll(fetchedQuestions);
      // level3Question.removeRange(1, 18);
      if (level3Question.length > 20) {
        // Keep only the first 20 elements
        level3Question.value = level3Question.sublist(0, 20);
      }

      print("question length is ${level3Question.length}");
      print("${level3Question[0].question}");
    } catch (e) {
      print("Error fetching questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch questions from Firebase
  Future<void> fetchLevel2Questions(String category) async {
    try {
      isLoading.value = true;
      var fetchedQuestions =
          await Level2RewardService.fetchQuestionsFromFirestore(category);
      level2Question.assignAll(fetchedQuestions);
      // level2Question.removeRange(1, 18);
      if (level2Question.length > 20) {
        // Keep only the first 20 elements
        level2Question.value = level2Question.sublist(0, 20);
      }
      print("question length is ${level2Question.length}");
      print("${level2Question[0].question}");
    } catch (e) {
      print("Error fetching questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch questions from Firebase
  Future<void> fetchLevel1Questions(String category) async {
    try {
      isLoading.value = true;
      var fetchedQuestions =
          await Level1RewardService.fetchQuestionsFromFirestore(category);
      level1Question.assignAll(fetchedQuestions);
      // level1Question.removeRange(1, 18);
      if (level1Question.length > 20) {
        // Keep only the first 20 elements
        print("******************************More then 20 Items");
        level1Question.value = level1Question.sublist(0, 20);
      }
      print("question length is ${level1Question.length}");
      print("${level1Question[0].question}");
    } catch (e) {
      print("Error fetching questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Add word to selected sequence
  void addWordToSequence(String word) {
    selectedWords.add(word); // Add word to the selected sequence
  }

  // Add word to selected sequence
  void addWordToSequenceLevel3(String word) {
    selectedWords.clear();
    selectedWords.add(word); // Add word to the selected sequence
  }

  // Add word to selected sequence
  void addWordToQuestion(String word) {
    tempWords.add(word); // Add word to the selected sequence
    tempWords.shuffle();
  }

  // Remove word from selected sequence (undo)
  void removeWordFromSequence(String word) {
    selectedWords.remove(word); // Remove word from the selected sequence
  }

  // Remove word from selected sequence (undo)
  void removeWordFromQuestion(String word) {
    tempWords.remove(word); // Remove word from the selected sequence
  }

  // Check if the user has completed the sequence correctly
  bool checkAnswer(String useranswer, String correctedAnser) {
    print("user  answer $useranswer");
    // This can be customized to check against the correct answer
    useranswer.replaceAll(".", "");
    if (correctedAnser.contains(".")) {
      correctedAnser = correctedAnser.replaceAll(".", "");
    }
    useranswer = useranswer.capitalize!;
    correctedAnser = correctedAnser.capitalize!;
    if (useranswer == correctedAnser) {
      print("answer is corected");
      correctAnswersCount.value++;
      return true;
      // Show feedback
    } else {
      print("incorrect answer $correctedAnser");
      return false;
    }
    // You can compare selectedWords with the correct answer sequence here
    // If correct, show a success message; otherwise, show an error message
  }

  void goToNextPagelevel1() {
    if (currentPageIndex.value < level1Question.length) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    currentPageIndex.value++;
  }

  void goToNextPageLevel2() {
    if (currentPageIndex.value < level2Question.length) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    currentPageIndex.value++;
  }

  void goToNextPagelevel3() {
    if (currentPageIndex.value < level3Question.length) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    currentPageIndex.value++;
  }

  void level1Result(List<Level1RewardModel> totalQuestions) {
    resultPercentage.value =
        correctAnswersCount.value * 100 / totalQuestions.length;
  }

  void level2Result(List<Level2RewardModel> totalQuestions) {
    resultPercentage.value =
        correctAnswersCount.value * 100 / totalQuestions.length;
  }

  void level3Result(List<Level3RewardModel> totalQuestions) {
    resultPercentage.value =
        correctAnswersCount.value * 100 / totalQuestions.length;
  }

  RxString outputText = ''.obs;
  // Function to replace the blank with selected option
  String updateQuestion(String question, String selectedOption) {
    return question.replaceFirst("----", selectedOption);
  }

  List<String> getSplitString(String question, String selectedOption) {
    return outputText
        .split(RegExp(r'(\b' + RegExp.escape(selectedOption) + r'\b)'));
  }
}
