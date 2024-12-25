import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/core/utils/conversationID.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/databaseHelper/LocalDatabase.dart';
import '../../../../core/model/TutorModels/tutorModel.dart';

class TutorFormController extends GetxController {
  final DatabaseHelper _db = DatabaseHelper();
  // User information
  var userName = "".obs;
  var userGender = "".obs;
  var isMaleSelected = false.obs;
  var isFemaleSelected = false.obs;
  var englishLevel = <String>[
    "Beginner",
    "Basic",
    "Intermediate",
    "Advanced",
    "Professional",
  ].obs;
  // Observable to track selected level
  var selectedLevel = ''.obs;
  var selectedlanguage = ''.obs;
  var learningPurposeList = <String>[
    "🏛️- Culture",
    "🎓- Education",
    "👨‍👩‍👧- Family & Friend",
    "📈- Self Improvment",
    "✈️- Travel",
    "🛠️- Work",
  ].obs;
  // Observable to track selected level
  var selectedPurposes = <String>[].obs; // List of selected purposes
  var tutorName = "".obs; //tutor anme
  var selectedAvatar = ''.obs; // Observable to track the selected avatar
  var customAvatar = Rxn<File>(); // Observable for the custom avatar
  // Observable for the model
  var tutorData = Rxn<TutorModel>();

  // Method to set a custom avatar
  void setCustomAvatar(File? avatar) {
    customAvatar.value = avatar;
  }

  // Set username
  void setUsername(String name) {
    userName.value = name;
  }

  // Set user gender
  void setUserGender(String gender) {
    userGender.value = gender;
  }

  // Method to select a english level
  void selectEnglishLevel(String level) {
    selectedLevel.value = level;
  }

  // Method to select a english language
  void selectLanguage(String language) {
    selectedlanguage.value = language;
  }

  // Set tutor name
  void setTutorname(String name) {
    tutorName.value = name;
  }

  // Method to select an avatar
  void selectAvatar(String avatar) {
    selectedAvatar.value = avatar;
  }

  // Save data to the model and convert it to JSON
  void saveFormData(TutorModel data) {
    // Convert model to JSON
    final jsonData = data.toJson();
  }

  // Save custom avatar to local directory and get its path
  Future<String?> saveCustomAvatar(File avatar) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final avatarPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_avatar.png';
      final savedFile = await avatar.copy(avatarPath);
      return savedFile.path;
    } catch (e) {
      print("Error saving custom avatar: $e");
      return null;
    }
  }

  // Save form data to the model
  Future<void> saveTutorData() async {
    final customAvatarPath = customAvatar.value != null
        ? await saveCustomAvatar(customAvatar.value!)
        : null;

    String conversationId = tutorName + generateUniqueString();

    final data = TutorModel(
        userName: userName.value,
        userGender: userGender.value,
        selectedLevel: selectedLevel.value,
        nativeLanguage: selectedlanguage.value,
        learningPurposes: selectedPurposes.toList(),
        tutorName: tutorName.value,
        tutorAvatar: selectedAvatar.isNotEmpty ? selectedAvatar.value : "",
        customAvatar: customAvatarPath,
        uniqueTutorID: conversationId);

    tutorData.value = data;
    await _db.saveTutor(data);
    // Fetch all tutors
    final tutors = await _db.fetchAllTutors();
    log("list of tutor are ${tutors.length}");
    for (var t in tutors) {
      log("${t.customAvatar}");
    }
  }

  void clearAll() {
    // User information
    userName = "".obs;
    userGender = "".obs;
    isMaleSelected = false.obs;
    isFemaleSelected = false.obs;
    selectedLevel = "".obs;
    selectedlanguage = ''.obs;
    selectedPurposes = <String>[].obs; // List of selected purposes
    tutorName = "".obs; //tutor anme
    selectedAvatar = ''.obs; // Observable to track the selected avatar
    customAvatar = Rxn<File>(null); // Observable for the custom avatar

    //Girlfriend information
  }
}
