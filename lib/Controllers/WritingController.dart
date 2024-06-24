import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/API/api.dart';
import 'package:grammer_checker_app/utils/filertAiResponse.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
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

 Original text : 
""";

// Send the prompt along with the user's query to the Chat API

  Rx<TextEditingController> controller = TextEditingController().obs;
  RxString outputText = ''.obs;
  RxBool isresultLoaded = false.obs;
  RxInt charCount = 0.obs;
  RxBool isloading = false.obs;
  RxString highlightedMistakes = ''.obs;
  RxString correctedText = ''.obs;

  void clearText() {
    controller.value.text = '';
    charCount.value = controller.value.text.length;
  }

  void cleardata() {
    controller.value.text = '';
    outputText.value = '';
    isresultLoaded.value = false;
    isListening.value = false;
    speech.stop();
  }

  late stt.SpeechToText speech;
  var isListening = false.obs;
  RxBool available = false.obs;

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
  }

  Future<String> sendQuery(BuildContext context) async {
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

//listen to voice
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
        );
        if (available.value) {
          isListening.value = true;
          await speech.listen(
            listenFor: const Duration(seconds: 15),
            pauseFor: const Duration(seconds: 15),
            onResult: (val) {
              controller.value.text = val.recognizedWords;
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
