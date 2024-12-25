import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/core/Firebase/FIrebaseCourseServices.dart';
import 'package:grammar_checker_app_updated/core/model/CourseModel.dart';

class GrammarController extends GetxController {
  var grammarData = Rxn<GrammarLevel>();
  var isLoading = false.obs;
  var currentPageIndex = 0.obs;
  PageController pageController = PageController();

  Future<void> fetchGrammarData(String level) async {
    try {
      isLoading.value = true;
      var data = await FirebaseCourseServices.fetchLevelFromFirestore(
          level); // Pass the correct level
      grammarData.value = data;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  void goToNextPage() {
    if (currentPageIndex.value < grammarData.value!.modules.length) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      currentPageIndex.value++;
    }
  }

  void goToPreviousPage() {
    if (currentPageIndex.value > 0) {
      pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      currentPageIndex.value--;
    }
  }
}
