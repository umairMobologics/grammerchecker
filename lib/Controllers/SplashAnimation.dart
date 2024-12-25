import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashAnimation extends GetxController {
  late AnimationController controller;

  RxBool splashScreenButtonShown = false.obs;
  RxDouble width = 0.0.obs;

  void updateWidth(double newWidth) {
    width.value = newWidth;
  }

  void showSplashScreenButton() {
    splashScreenButtonShown.value = true;
  }
}
