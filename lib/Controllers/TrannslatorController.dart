import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class TranslatorController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
  }

  // Define a map to store language names and their corresponding language codes
  Map<String, String> languageCodes = {
    "Afrikaans": "af",
    "Albanian": "sq",
    "Amharic": "am",
    "Arabic": "ar",
    "Armenian": "hy",
    "Azerbaijani": "az",
    "Basque": "eu",
    "Belarusian": "be",
    "Bengali": "bn",
    "Bosnian": "bs",
    "Bulgarian": "bg",
    "Catalan": "ca",
    "Cebuano": "ceb",
    "Chichewa": "ny",
    "Corsican": "co",
    "Croatian": "hr",
    "Czech": "cs",
    "Danish": "da",
    "Dutch": "nl",
    "English": "en",
    "Esperanto": "eo",
    "Estonian": "et",
    "Filipino": "tl",
    "Finnish": "fi",
    "French": "fr",
    "Frisian": "fy",
    "Galician": "gl",
    "Georgian": "ka",
    "German": "de",
    "Greek": "el",
    "Gujarati": "gu",
    "Haitian Creole": "ht",
    "Hausa": "ha",
    "Hawaiian": "haw",
    "Hebrew": "iw",
    "Hindi": "hi",
    "Hmong": "hmn",
    "Hungarian": "hu",
    "Icelandic": "is",
    "Igbo": "ig",
    "Indonesian": "id",
    "Irish": "ga",
    "Italian": "it",
    "Japanese": "ja",
    "Javanese": "jw",
    "Kannada": "kn",
    "Kazakh": "kk",
    "Khmer": "km",
    "Korean": "ko",
    "Kurdish (Kurmanji)": "ku",
    "Kyrgyz": "ky",
    "Lao": "lo",
    "Latin": "la",
    "Latvian": "lv",
    "Lithuanian": "lt",
    "Luxembourgish": "lb",
    "Macedonian": "mk",
    "Malagasy": "mg",
    "Malay": "ms",
    "Malayalam": "ml",
    "Maltese": "mt",
    "Maori": "mi",
    "Marathi": "mr",
    "Mongolian": "mn",
    "Myanmar (Burmese)": "my",
    "Nepali": "ne",
    "Norwegian": "no",
    "Pashto": "ps",
    "Persian": "fa",
    "Polish": "pl",
    "Portuguese": "pt",
    "Punjabi": "pa",
    "Romanian": "ro",
    "Russian": "ru",
    "Samoan": "sm",
    "Scots Gaelic": "gd",
    "Serbian": "sr",
    "Sesotho": "st",
    "Shona": "sn",
    "Sindhi": "sd",
    "Sinhala": "si",
    "Slovak": "sk",
    "Slovenian": "sl",
    "Somali": "so",
    "Spanish": "es",
    "Sundanese": "su",
    "Swahili": "sw",
    "Swedish": "sv",
    "Tajik": "tg",
    "Tamil": "ta",
    "Telugu": "te",
    "Thai": "th",
    "Turkish": "tr",
    "Ukrainian": "uk",
    "Urdu": "ur",
    "Uzbek": "uz",
    "Vietnamese": "vi",
    "Welsh": "cy",
    "Xhosa": "xh",
    "Yiddish": "yi",
    "Yoruba": "yo",
    "Zulu": "zu"
  };

  // Define variables to store selected languages and language codes
  final InAppReview inAppReview = InAppReview.instance;
  RxString sourceLanguageCode = 'en'.obs;
  RxString targetLanguageCode = 'ur'.obs;
  RxString sourceLanguage = 'English'.obs;
  RxString targetLanguage = 'Urdu'.obs;
  void switchLanguages() {
    RxString temp = sourceLanguage.value.obs;
    sourceLanguage.value = targetLanguage.value;
    targetLanguage.value = temp.value;
    RxString temp2 = sourceLanguageCode.value.obs;
    sourceLanguageCode.value = targetLanguageCode.value;
    targetLanguageCode.value = temp2.value;
    update();
  }

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

  Future<String> translateText(
      BuildContext context, String sourceLang, String targetLang) async {
    log(targetLang);
    isresultLoaded.value = false;
    final translator = GoogleTranslator();

    if (controller.value.text.isEmpty) {
      showToast(context, "Message cannot be empty");
      return '';
    }

    isloading.value = true;

    try {
      final translation = await translator.translate(
        controller.value
            .text, // Assuming controller.value.text holds the text to be translated
        to: targetLang,
      );

      outputText.value = translation.toString();
      log(outputText.value);
      isresultLoaded.value = true;
      Future.delayed(
        Duration(seconds: 3),
        () async {
          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
          }
        },
      );

      return outputText.value;
    } catch (e) {
      log("Translation error: $e");
      showToast(context, "An error occurred during translation");
      isresultLoaded.value = false;
      return '';
    } finally {
      isloading.value = false;
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }

  late stt.SpeechToText speech;
  RxBool isListening = false.obs;

  RxBool available = false.obs;

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
