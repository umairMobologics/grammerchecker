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
    getVoices();
  }

  void getVoices() async {
    List voices = await _flutterTts.getVoices as List;
    voices.forEach((element) {});
  }

  void setvoice() async {
    log("voice set");
    _flutterTts.setLanguage("en-US"); // Sets the spoken language to English
    await _flutterTts.setVoice({
      "name": "Daniel",
      "locale": "en-GB"
    }); // Change the voice to a male voice
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      _flutterTts.setLanguage("en-US");
      // await _flutterTts
      //     .setVoice({'name': 'en-us-x-iol-local', 'locale': 'en-US'});

      await _flutterTts
          .setVoice({'name': 'en-us-x-tpf-local', 'locale': 'en-US'});
      // await _flutterTts
      //     .setVoice({'name': 'ur-pk-x-cfn-local', 'locale': 'ur-PK'});
      // await _flutterTts
      //     .setVoice({'name': 'ja-jp-x-htm-network', 'locale': 'ja-JP'});

      await _flutterTts.setVolume(1.0);

      await _flutterTts.setPitch(1.0);
      // _flutterTts.setLanguage("en-US"); // Sets the spoken language to English
      // await _flutterTts.setVoice({"name": "Daniel", "locale": "en-GB"});
      // _flutterTts.setSpeechRate(0.5);
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
