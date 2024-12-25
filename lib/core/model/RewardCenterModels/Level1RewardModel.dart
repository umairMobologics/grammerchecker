class Level1RewardModel {
  final String question; // The shuffled characters
  final String correctAnswer; // The correct rearranged word
  final String explanation; // Optional explanation

  Level1RewardModel({
    required this.question,
    required this.correctAnswer,
    required this.explanation,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'unshuffledCharacters': question,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  // Create object from Firestore JSON
  factory Level1RewardModel.fromJson(Map<String, dynamic> json) {
    return Level1RewardModel(
      question: json['unshuffledCharacters'],
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'] ?? '',
    );
  }

  // Create object from map (local database or Firestore snapshot)
  factory Level1RewardModel.fromMap(Map<String, dynamic> map) {
    return Level1RewardModel(
      question: map['unshuffledCharacters'] ?? '',
      correctAnswer: map['correctAnswer'] ?? '',
      explanation: map['explanation'] ?? '',
    );
  }
}
