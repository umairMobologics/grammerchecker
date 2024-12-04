class Level3RewardModel {
  final String question; // The shuffled sentence
  final String options; // The shuffled sentence
  final String correctAnswer; // The correct rearranged sentence
  final String explanation; // Optional explanation

  Level3RewardModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'unshuffledWords': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  // Create object from Firestore JSON
  factory Level3RewardModel.fromJson(Map<String, dynamic> json) {
    return Level3RewardModel(
      question: json['unshuffledWords'],
      options: json['options'],
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'] ?? '',
    );
  }

  // Create object from map (local database or Firestore snapshot)
  factory Level3RewardModel.fromMap(Map<String, dynamic> map) {
    return Level3RewardModel(
      question: map['unshuffledWords'] ?? '',
      options: map['options'] ?? '',
      correctAnswer: map['correctAnswer'] ?? '',
      explanation: map['explanation'] ?? '',
    );
  }
}
