import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TTSController extends GetxController {
  late FlutterTts _flutterTts;
  var isSpeaking = false.obs;

  @override
  void onInit() {
    super.onInit();
    _flutterTts = FlutterTts();
    _flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });
    _flutterTts.setErrorHandler((msg) {
      isSpeaking.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: $msg',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
    setvoice();
  }

  void setvoice() async {
    log("voice seted");
    _flutterTts.setLanguage("en-US"); // Sets the spoken language to English
    // await _flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      isSpeaking.value = true;
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    isSpeaking.value = false;
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    isSpeaking.value = false;
  }
}
