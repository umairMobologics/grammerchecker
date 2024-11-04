import 'dart:developer';

import 'package:get/get.dart';

import '../databaseHelper/QuizDatabase.dart';
import '../model/QuizModel.dart';

class StartQuizController extends GetxController {
  var isLoading = false.obs;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final List<QuizModel> multipleChoice = <QuizModel>[].obs;
  List<QuizModel> filteredQuizQuestions = <QuizModel>[].obs;

  var currentQuestionIndex = 0.obs;
  var selectedOption = Rxn<String>();
  var isQuizCompleted = false.obs;
  var correctAnswersCount = 0.obs;
  var resultPercentage = 0.0.obs;

  var isCorrectAnswerSelected = false.obs;
  var correctAnswer = ''.obs;
  var isOptionSelected = false.obs;

  void selOption(String option, String correctOption) {
    if (!isOptionSelected.value) {
      selectedOption.value = option;
      correctAnswer.value = correctOption;
      isCorrectAnswerSelected.value = (option == correctOption);
      isOptionSelected.value = true; // Lock further selections
    }
  }

  void resetSelection() {
    selectedOption.value = '';
    isCorrectAnswerSelected.value = false;
    correctAnswer.value = '';
    isOptionSelected.value = false; // Allow selection on new question
  }

  Future<void> initializeQuizQuestions() async {
    isLoading.value = true;
    List<QuizModel> words = await _databaseHelper.getAllWordsFromDatabase();
    if (words.isNotEmpty) {
      log("data found");
      multipleChoice.clear();
      multipleChoice.addAll(words);
      multipleChoice.shuffle();
    } else {
      multipleChoice.clear();
      log("No data found in db");
    }
    isLoading.value = false;
  }

  List<QuizModel> getQuestionsByDifficulty(String difficulty) {
    return multipleChoice
        .where((quiz) => quiz.difficultyLevel == difficulty)
        .toList();
  }

  void nextQuestion(List<QuizModel> listChoice) {
    if (selectedOption.value != null) {
      if (selectedOption.value ==
          listChoice[currentQuestionIndex.value].correctAnswer) {
        correctAnswersCount.value++;
      }

      if (currentQuestionIndex.value < listChoice.length - 1) {
        currentQuestionIndex.value++;
        selectedOption.value = null;
      } else {
        result(listChoice);
        isQuizCompleted.value = true;
      }
    }
  }

  void selectOption(String option) {
    selectedOption.value = option;
  }

  void result(List<QuizModel> listChoice) {
    resultPercentage.value =
        correctAnswersCount.value * 100 / listChoice.length;
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    selectedOption.value = null;
    isQuizCompleted.value = false;
    correctAnswersCount.value = 0;
  }

  void clearAllFields() {
    isLoading.value = false;
    currentQuestionIndex.value = 0;
    selectedOption.value = null;
    isQuizCompleted.value = false;
    correctAnswersCount.value = 0;
    resultPercentage.value = 0.0;
    isCorrectAnswerSelected.value = false;
    correctAnswer.value = '';
    isOptionSelected.value = false;
    multipleChoice.clear();
  }
}
