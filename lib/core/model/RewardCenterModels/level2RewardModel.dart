class Level2RewardModel {
  final String question; // The shuffled sentence
  final String correctAnswer; // The correct rearranged sentence
  final String explanation; // Optional explanation

  Level2RewardModel({
    required this.question,
    required this.correctAnswer,
    required this.explanation,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'unshuffledWords': question,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  // Create object from Firestore JSON
  factory Level2RewardModel.fromJson(Map<String, dynamic> json) {
    return Level2RewardModel(
      question: json['unshuffledWords'],
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'] ?? '',
    );
  }

  // Create object from map (local database or Firestore snapshot)
  factory Level2RewardModel.fromMap(Map<String, dynamic> map) {
    return Level2RewardModel(
      question: map['unshuffledWords'] ?? '',
      correctAnswer: map['correctAnswer'] ?? '',
      explanation: map['explanation'] ?? '',
    );
  }
}
