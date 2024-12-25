class QuizModel {
  final int? id; // Database ID
  final String difficultyLevel;
  final String quizQuestion;
  final String multipleChoiceA;
  final String multipleChoiceB;
  final String multipleChoiceC;
  final String multipleChoiceD;
  final String correctAnswer;

  QuizModel({
    this.id,
    required this.difficultyLevel,
    required this.quizQuestion,
    required this.multipleChoiceA,
    required this.multipleChoiceB,
    required this.multipleChoiceC,
    required this.multipleChoiceD,
    required this.correctAnswer,
  });

  // Convert a VocabularyWord object to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'difficulty_level': difficultyLevel,
      'quiz_question': quizQuestion,
      'multiple_choice_a': multipleChoiceA,
      'multiple_choice_b': multipleChoiceB,
      'multiple_choice_c': multipleChoiceC,
      'multiple_choice_d': multipleChoiceD,
      'correct_answer': correctAnswer,
    };
  }

  // Create a VocabularyWord object from a Map retrieved from the database
  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'],
      difficultyLevel: map['difficulty_level'],
      quizQuestion: map['quiz_question'],
      multipleChoiceA: map['multiple_choice_a'],
      multipleChoiceB: map['multiple_choice_b'],
      multipleChoiceC: map['multiple_choice_c'],
      multipleChoiceD: map['multiple_choice_d'],
      correctAnswer: map['correct_answer'],
    );
  }
  // Factory constructor to create a QuizModel from a JSON map
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      difficultyLevel: json['Difficulty Level'],
      quizQuestion: json['Quiz Question'],
      multipleChoiceA: json['Multiple Choice A'],
      multipleChoiceB: json['Multiple Choice B'],
      multipleChoiceC: json['Multiple Choice C'],
      multipleChoiceD: json['Multiple Choice D'],
      correctAnswer: json['Correct Answer'],
    );
  }
}
