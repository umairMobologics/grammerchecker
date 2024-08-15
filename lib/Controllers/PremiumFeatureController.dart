import 'package:get/get.dart';

RxString selectedPlan = ''.obs;

class PremiumFeatureController extends GetxController {
  void changeSelectedPlan(String id) {
    selectedPlan.value = id;
  }
}
