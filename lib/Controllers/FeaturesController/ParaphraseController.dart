import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/Controllers/limitedTokens/limitedTokens.dart';
import 'package:grammer_checker_app/core/utils/filertAiResponse.dart';
import 'package:grammer_checker_app/core/utils/snackbar.dart';
import 'package:grammer_checker_app/data/apiResponse.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class WritingController extends GetxController {
  String aiGuidlines = """
Enhance the following below text by addressing the following aspects:
- Correct any grammatical errors.
- Fix spelling and punctuation mistakes.
- Refine sentence structure for better readability and flow.
- Ensure clarity and conciseness by removing redundant words or phrases.
- Maintain the original tone and style of the text.
- Don't use complicated words which are unable to understand.
- Ensure logical flow and coherence throughout the text.\n\n

write down the text only. do not add any headings, labels, or extra commentary.\n
 

""";

// Send the prompt along with the user's query to the Chat API

  Rx<TextEditingController> controller = TextEditingController().obs;
  RxString outputText = ''.obs;
  RxBool isresultLoaded = false.obs;
  RxInt charCount = 0.obs;
  RxBool isloading = false.obs;
  RxString highlightedMistakes = ''.obs;
  RxString correctedText = ''.obs;
  RxString isCopyLength = ''.obs;
  RxBool isCopyOutput = false.obs;

  void clearText() {
    controller.value.text = '';
    charCount.value = controller.value.text.length;
  }

  void cleardata() {
    controller.value.text = '';
    outputText.value = '';
    isresultLoaded.value = false;
    isListening.value = false;
    charCount.value = 0;
    speech.stop();
  }

  late stt.SpeechToText speech;
  var isListening = false.obs;
  RxBool available = false.obs;
  final InAppReview inAppReview = InAppReview.instance;
  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
  }

  Future<String> sendQuery(
      BuildContext context, TokenLimitService askAILimit) async {
    outputText.value = '';
    isresultLoaded.value = false;

    if (controller.value.text.isEmpty) {
      showToast(context, 'Message cannot be empty');
      return '';
    }

    isloading.value = true;
    var finalText = "$aiGuidlines  ${controller.value.text}";
    log(finalText);

    try {
      final res = await APIs.makeGeminiRequest(finalText);
      log(res);

      outputText.value = filterResponse(res);
      if (outputText.value.isNotEmpty) {
        isresultLoaded.value = true;
        isCopyOutput.value = true;
        log("true! use feature");
        await askAILimit.useFeature();

        Future.delayed(
          Duration(seconds: 3),
          () async {
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
          },
        );
      }
    } catch (e) {
      isresultLoaded.value = true;
      log('Error during API request: $e');
      // showToast(context, 'An error occurred: $e');
    } finally {
      isloading.value = false;
      Navigator.of(context).pop(); // Close the loading dialog
    }

    return outputText.value;
  }

  void listen() async {
    if (!isListening.value) {
      try {
        available.value = await speech.initialize(
            onStatus: (val) {
              log('onStatus: $val');
              if (val == "notListening" || val == "done") {
                isListening.value = false;
              } else if (val == "listening") {
                isListening.value = true;
              }
            },
            onError: (val) {
              log('onError: $val');
              isListening.value = false;
              // Get.snackbar(
              //   'Error',
              //   'An error occurred: ${val.errorMsg}',
              //   snackPosition: SnackPosition.BOTTOM,
              // );
            },
            finalTimeout: Duration(seconds: 5));
        if (available.value) {
          isListening.value = true;
          await speech.listen(
            listenFor: const Duration(seconds: 15),
            pauseFor: const Duration(seconds: 15),
            onResult: (val) {
              controller.value.text = val.recognizedWords;
              val.recognizedWords.length < 1000
                  ? charCount.value = val.recognizedWords.length
                  : charCount.value = 1000;
            },
          );
        }
      } catch (e) {
        isListening.value = false;
        speech.stop();
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      isListening.value = false;
      speech.stop();
    }
  }
}
