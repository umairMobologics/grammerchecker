import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/API/api.dart';
import 'package:grammer_checker_app/Controllers/limitedTokens/limitedTokens.dart';
import 'package:grammer_checker_app/utils/filertAiResponse.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CorrectorController extends GetxController {
  String aiGuidlines =
      '''You are a grammar corrector expert tasked with improving the provided text. The text  contain grammatical errors, spelling mistakes, and punctuation issues. Your task is to thoroughly analyze and correct the text, following these steps:

1.Thoroughly analyze the text for all grammatical mistakes, spelling errors, and punctuation issues.
2.Correct every mistake you find and rewrite the text , without leaving any errors unaddressed.
3.Ensure the corrected text retains the original tone and style, but is grammatically correct, clear, and well-structured.
4.Do not leave any errors uncorrected.
5.If the text contains a person/human name, leave the name as it is.
6. Respond with only the corrected text without any headings, labels, or extra commentary.

provided text:\n

''';
//   String aiGuidlines =
//       ''' You are a grammar corrector expert and you have assigned a below task. Below is the provided text,which may have incorrect grammer or mistakes. re-write the text and must follow these steps:

// 1. Analyze the text for grammatical mistakes.
// 2. Fix spelling and punctuation mistakes.
// 3. Maintain the original tone and style of the text.
// 4. Important!: Highlight each mistake from text by enclosing the words or phrases in large brackets [].
// 5. After highlighting the mistakes, provide a corrected version of the text.
// 6. Important!: Highlight each corrected word of correxted text by enclosing the words or phrases in curly brackets {}.
// 7. Ensure the corrected text is grammatically correct, clear, and well-structured.
// 8. Note: If the text contains a person/human name, then leave the name as it is.

// Please make sure to read all guidelines before answering. Respond only in JSON format. The format should be:

// {
//   "Highlighted Mistakes": "Text with mistakes highlighted including []",
//   "Corrected Text": "Text with corrections highlighted including {}"
// }

// Example:

// "John and me goes to the store. He dont like the store's layout, it was too cluttered. Their were many products but not much organization. I seen a lot of items that catch my eye. We buyed some fruits, vegetables, and breads. On our way back, John sayed he forget his wallet at home. We was worried about how to pay, but I remember I have some cash with me."

// Expected output:
// {
//   "Highlighted Mistakes": "John and [me] [goes] to the store. He [dont] like the store's layout, [it] was too cluttered. [Their] were many products but not much organization. I [seen] a lot of items that [catch] my eye. We [buyed] some fruits, vegetables, and [breads]. On our way back, John [sayed] he [forget] his wallet at home. We [was] worried about how to pay, but I [remember] I have some cash with me.",
//   "Corrected Text": "John and {I} {go} to the store. He {doesn't} like the store's layout; {it} was too cluttered. {There} were many products but not much organization. I {saw} a lot of items that {caught} my eye. We {bought} some fruits, vegetables, and {bread}. On our way back, John {said} he {forgot} his wallet at home. We {were} worried about how to pay, but I {remembered} I have some cash with me."
// }

// Here is the text in which you have to apply these rules also make sure dont skip the text,the response should be full:
// provided text:\n

// ''';

// Send the prompt along with the user's query to the Chat API

  Rx<TextEditingController> controller = TextEditingController().obs;
  RxString outputText = ''.obs;
  RxString filterText = ''.obs;
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
    charCount.value = 0;
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

  Future<String> sendQuery2(
      BuildContext context, TokenLimitService askAILimit) async {
    speech.stop();
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

      // You can now set the outputText to include both parts separately

      outputText.value = await filterResponse(res);

      filterText.value = moreFilterResponse(outputText.value);
      log("filertred text${filterText.value}");

      if (outputText.value.isNotEmpty) {
        isresultLoaded.value = true;
        log("true! use feature");
        await askAILimit.useFeature();
      } else {
        isresultLoaded.value = false;
        outputText.value = '';
      }
    } catch (e) {
      // Handle any errors that occur during the API call or JSON parsing
      log('Error: $e');
    } finally {
      // outputText.value = ""; // Optionally set the raw response
      isloading.value = false;
      Navigator.of(context).pop(); // Close the loading dialog
    }

    return "";
  }

  //listen voice
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
