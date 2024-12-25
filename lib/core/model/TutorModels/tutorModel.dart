class TutorModel {
  String userName;
  String userGender;
  String selectedLevel;
  String nativeLanguage;
  List<String> learningPurposes;
  String tutorName;
  String tutorAvatar;
  String? customAvatar; // Store file path instead of the File object
  String uniqueTutorID; // Store file path instead of the File object

  TutorModel({
    required this.userName,
    required this.userGender,
    required this.selectedLevel,
    required this.nativeLanguage,
    required this.learningPurposes,
    required this.tutorName,
    required this.tutorAvatar,
    required this.customAvatar,
    required this.uniqueTutorID,
  });

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userGender': userGender,
      'selectedLevel': selectedLevel,
      'nativeLanguage': nativeLanguage,
      'learningPurposes': learningPurposes,
      'tutorName': tutorName,
      'tutorAvatar': tutorAvatar,
      'customAvatar': customAvatar,
      'uniqueTutorID': uniqueTutorID,
    };
  }

  // Create a model from JSON
  factory TutorModel.fromJson(Map<String, dynamic> json) {
    return TutorModel(
      userName: json['userName'],
      userGender: json['userGender'],
      selectedLevel: json['selectedLevel'],
      nativeLanguage: json['nativeLanguage'],
      learningPurposes: List<String>.from(json['learningPurposes']),
      tutorName: json['tutorName'],
      tutorAvatar: json['tutorAvatar'],
      customAvatar: json['customAvatar'],
      uniqueTutorID: json['uniqueTutorID'],
    );
  }

  // Convert from Map to TutorModel
  factory TutorModel.fromMap(Map<String, dynamic> map) {
    return TutorModel(
      userName: map['userName'] as String,
      userGender: map['userGender'] as String,
      selectedLevel: map['selectedLevel'] as String,
      nativeLanguage: map['nativeLanguage'] as String,
      learningPurposes: (map['learningPurposes'] as String)
          .split(','), // Assuming stored as CSV
      tutorName: map['tutorName'] as String,
      tutorAvatar: map['tutorAvatar'] as String,
      customAvatar: map['customAvatar'] as String?,
      uniqueTutorID: map['uniqueTutorID'] as String,
    );
  }
}
