import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/API/apiResponse.dart';
import 'package:grammer_checker_app/Controllers/limitedTokens/limitedTokens.dart';
import 'package:grammer_checker_app/utils/filertAiResponse.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CorrectorController extends GetxController {
  String aiGuidlines =
      '''You are a grammar corrector expert tasked with improving the provided text and explaining the corrections made. The text contains grammatical errors, spelling mistakes, and punctuation issues. Your task is to:

1. Thoroughly analyze the text for all grammatical mistakes, spelling errors, and punctuation issues.
2. Correct every mistake you find and rewrite the text, without leaving any errors unaddressed.
3. Ensure the corrected text retains the original tone and style, but is grammatically correct, clear, and well-structured.
4. Do not leave any errors uncorrected.
5. If the text contains a person/human name, leave the name as it is.
6. Provide the response in valid JSON format with two parts:
  "correctedText": This should contain only the corrected version of the text.
   "explanation": This should provide an explanation for each key change made, ensuring all quotes (`"`) are escaped as `\"` and newlines are handled correctly within the JSON.

The JSON structure should be:

{
  "correctedText": "Here is the corrected text",
  "explanation": "Here is the explanation of the corrections with properly escaped characters like \" and newline support."
}

Provided text:\n
''';

//   String aiGuidlines =
//       '''You are a grammar corrector expert tasked with improving the provided text. The text  contain grammatical errors, spelling mistakes, and punctuation issues. Your task is to thoroughly analyze and correct the text, following these steps:

// 1.Thoroughly analyze the text for all grammatical mistakes, spelling errors, and punctuation issues.
// 2.Correct every mistake you find and rewrite the text , without leaving any errors unaddressed.
// 3.Ensure the corrected text retains the original tone and style, but is grammatically correct, clear, and well-structured.
// 4.Do not leave any errors uncorrected.
// 5.If the text contains a person/human name, leave the name as it is.
// 6. Respond with only the corrected text without any headings, labels, or extra commentary.

// provided text:\n

// ''';
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
  final InAppReview inAppReview = InAppReview.instance;

  Rx<TextEditingController> controller = TextEditingController().obs;
  RxString outputText = ''.obs;
  RxString filterText = ''.obs;
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
      log("emoty..");
      showToast(context, 'Message cannot be empty');
      return '';
    }

    isloading.value = true;
    var finalText = "$aiGuidlines  ${controller.value.text}";
    log(finalText);

    try {
      var res = await APIs.makeGeminiRequest(finalText);
      log(res);

      // You can now set the outputText to include both parts separately

      // Check if the response is a valid JSON
      if (res.contains('JSON') ||
          res.contains('json') ||
          res.contains("```") ||
          res.contains('{')) {
        // Remove unwanted "JSON" word and backticks
        res = res
            .replaceAll('JSON', '')
            .replaceAll('```', '')
            .replaceAll('json', '');
        res = await filterResponse(res);

        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = jsonDecode(res);

        // Extract highlighted mistakes and corrected text
        highlightedMistakes.value = jsonResponse["explanation"];

        highlightedMistakes.value =
            await filterResponse(highlightedMistakes.value);
        log("Higlighted mistakes:     \n $highlightedMistakes");
        correctedText.value = jsonResponse["correctedText"];

        correctedText.value = await filterResponse(correctedText.value);
        log("corrected text:     \n $correctedText");
        filterText.value = correctedText.value;

        if (filterText.value.isNotEmpty) {
          outputText.value = filterText.value;
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
        } else {
          isresultLoaded.value = false;
          outputText.value = '';
        }
      } else {
        log("incorrect output");
        // showToast(context, "Invalid Response, try again");
        // Handle the case where the response is not valid JSON
        // showToast(context, 'Invalid response format from the API');
        outputText.value = ""; // Optionally set the raw response
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

  // Future<String> sendQuery2(
  //     BuildContext context, TokenLimitService askAILimit) async {
  //   speech.stop();
  //   outputText.value = '';
  //   isresultLoaded.value = false;

  //   if (controller.value.text.isEmpty) {
  //     showToast(context, 'Message cannot be empty');
  //     return '';
  //   }

  //   isloading.value = true;
  //   var finalText = "$aiGuidlines  ${controller.value.text}";
  //   log(finalText);

  //   try {
  //     final res = await APIs.makeGeminiRequest(finalText);
  //     log(res);

  //     // You can now set the outputText to include both parts separately

  //     outputText.value = await filterResponse(res);

  //     filterText.value = moreFilterResponse(outputText.value);
  //     log("filertred text${filterText.value}");

  //     if (outputText.value.isNotEmpty) {
  //       isresultLoaded.value = true;
  //       isCopyOutput.value = true;
  //       log("true! use feature");
  //       await askAILimit.useFeature();

  //       Future.delayed(
  //         Duration(seconds: 3),
  //         () async {
  //           if (await inAppReview.isAvailable()) {
  //             inAppReview.requestReview();
  //           }
  //         },
  //       );
  //     } else {
  //       isresultLoaded.value = false;
  //       outputText.value = '';
  //     }
  //   } catch (e) {
  //     // Handle any errors that occur during the API call or JSON parsing
  //     log('Error: $e');
  //   } finally {
  //     // outputText.value = ""; // Optionally set the raw response
  //     isloading.value = false;
  //     Navigator.of(context).pop(); // Close the loading dialog
  //   }

  //   return "";
  // }

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
            finalTimeout: Duration(seconds: 5));
        if (available.value) {
          isListening.value = true;
          await speech.listen(
            listenFor: const Duration(seconds: 15),
            pauseFor: const Duration(seconds: 5),
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

  // Helper function to check if a string is valid JSON
  bool _isValidJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}
