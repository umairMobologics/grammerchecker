import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/View/Screens/SplashScreen.dart';


class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  var isLastPage = false.obs;

  void onPageChanged(int index, int pageCount) {
    currentPage.value = index;
    isLastPage.value = index == pageCount - 1;
  }

  void nextPage(PageController controller,int pageCount) {
    if (currentPage.value < pageCount - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  void goToHome() {
    Get.to(() => SplashScreen());
  }
}
