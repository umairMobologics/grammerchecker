import 'package:get/get.dart';

class ProgressController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startProgress();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var progress = 0.obs; // Observable for progress bar
  var currentMessageIndex = 0.obs; // Current text message index
  var completedSteps =
      [false, false, false, false, false].obs; // Completion of each task
  var isFinished = false.obs; // Flag to show finish button

  List<String> messages = [
    "Creating your personalized tutor...",
    "Analyzing your interests...",
    "Preparing the best path for your growth...",
    "Adjusting lessons to match your level...",
    "Finalizing your customized learning tutor..."
  ];

  void startProgress() async {
    clearAll();
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 60)); // Simulates loading
      progress.value = i;

      if (i == 20) {
        completedSteps[0] = true;
        currentMessageIndex.value = 1;
      } else if (i == 40) {
        completedSteps[1] = true;
        currentMessageIndex.value = 2;
      } else if (i == 60) {
        completedSteps[2] = true;
        currentMessageIndex.value = 3;
      } else if (i == 80) {
        completedSteps[3] = true;
        currentMessageIndex.value = 4;
      } else if (i == 100) {
        completedSteps[4] = true;
        isFinished.value = true; // Show finish button
      }
    }
  }

  void clearAll() {
    progress = 0.obs; // Observable for progress bar
    currentMessageIndex = 0.obs; // Current text message index
    completedSteps = [false, false, false, false, false].obs;
    isFinished = false.obs; // Flag to show finish button
  }
}
