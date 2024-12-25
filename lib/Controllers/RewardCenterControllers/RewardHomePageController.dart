import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globletaskcontroller extends GetxController {
  // Observable variables for UI tracking
  RxBool isLevel1Completed = false.obs;
  RxBool isLevel1Win = false.obs;

  RxBool isLevel2Completed = false.obs;
  RxBool isLevel2Win = false.obs;

  RxBool isLevel3Completed = false.obs;
  RxBool isLevel3Win = false.obs;

//tasks ids
  String level1taskstatus = "level1Task";
  String level1Winstatus = "level1FreeWin";
  String level2Taskstatus = "level2Taskstatus";
  String level2Winstatus = "level2Winstatus";
  String level3Taskstatus = "level3taskstatus";
  String level3Winstatus = "level3Winstatus";

  RxString displayText = "You Lose".obs; // Initial text

  void _startAutoAnimation() {
    // Automatically switch the text every 2 seconds
    Future.delayed(Duration(seconds: 2), _toggleText);
  }

  void _toggleText() {
    displayText.value = displayText == "You Lose" ? "Try Again" : "You Lose";

    // Continue the infinite loop
    _startAutoAnimation();
  }

  @override
  void onInit() {
    super.onInit();
    // Load initial values from SharedPreferences
    loadLevel1Status();
    loadLevel2Status();
    loadLevel3Status();
    _startAutoAnimation();
  }

  // Save the boolean values to SharedPreferences
  Future<void> _saveToLocalStorage(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Load boolean values from SharedPreferences
  Future<bool> _getFromLocalStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false; // Default to false if not found
  }

  // Update `istaskCompleted` in controller and save to local storage
  Future<void> updateTaskCompleted(bool value, String key) async {
    key == level1taskstatus
        ? isLevel1Completed.value = value
        : key == level2Taskstatus
            ? isLevel2Completed.value = value
            : isLevel3Completed.value = value;
    await _saveToLocalStorage(key, value);
  }

  // Update `istaskWin` in controller and save to local storage
  Future<void> updateTaskWin(bool value, String key) async {
    key == level1Winstatus
        ? isLevel1Win.value = value
        : key == level2Winstatus
            ? isLevel2Win.value = value
            : isLevel3Win.value = value;
    await _saveToLocalStorage(key, value);
  }

  // Load initial task status values
  Future<void> loadLevel1Status() async {
    isLevel1Completed.value = await _getFromLocalStorage(level1taskstatus);
    isLevel1Win.value = await _getFromLocalStorage(level1Winstatus);
    log("level 1 status $isLevel1Completed $isLevel1Win");
  }

  // Load initial task status values
  Future<void> loadLevel2Status() async {
    isLevel2Completed.value = await _getFromLocalStorage(level2Taskstatus);
    isLevel2Win.value = await _getFromLocalStorage(level2Winstatus);
    log("level2 status $isLevel2Completed $isLevel2Win");
  }

  // Load initial task status values
  Future<void> loadLevel3Status() async {
    isLevel3Completed.value = await _getFromLocalStorage(level3Taskstatus);
    isLevel3Win.value = await _getFromLocalStorage(level3Winstatus);
    log("level3 status $isLevel3Completed $isLevel3Win");
  }
}
