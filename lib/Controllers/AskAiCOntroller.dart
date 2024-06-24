import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/API/api.dart';
import 'package:grammer_checker_app/utils/filertAiResponse.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AskAiController extends GetxController {
  Rx<TextEditingController> controller = TextEditingController().obs;
  RxString outputText =''.obs;
  RxBool isresultLoaded = false.obs;
  RxInt  charCount = 0.obs;
  RxBool isloading = false.obs;

  void clearText() {
    controller.value.text = '';
    charCount.value=  controller.value.text.length;
  }



Future<String> sendQuery(BuildContext context) async {
  outputText.value = '';
  isresultLoaded.value = false;

  if (controller.value.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message cannot be empty'),
      ),
    );
    return '';
  }

  isloading.value = true;

  try {
    final res = await APIs.makeGeminiRequest(controller.value.text);
  
    

    outputText.value = filterResponse(res);
  log(outputText.value);
    if (outputText.value.isNotEmpty) {
      isresultLoaded.value = true;
    }
  } catch (e) {
    log('Error during API request: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $e'),
      ),
    );
  } finally {
    isloading.value = false;
      Navigator.of(context).pop(); // Close the loading dialog
  }

  return outputText.value;
}


  // mic funcationality
  late stt.SpeechToText speech;
  var isListening = false.obs;
  RxBool available = false.obs;

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
  }

  void cleardata()
  {
    controller.value.text ='';
     outputText.value ='';
      isresultLoaded.value=false;
      isListening.value=false;
      speech.stop();
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
        );

        if (available.value) {
          isListening.value = true;
          await speech.listen(
            onDevice: false,
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
