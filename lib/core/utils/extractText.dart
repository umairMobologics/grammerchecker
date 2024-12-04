import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> extractTextFromImage(File? img) async {
  
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    if (img != null) {
      final inputImage = InputImage.fromFilePath(img.path);
      final RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      String extractedText = '';
      for (TextBlock block in recognisedText.blocks) {
        // final Rect rect = block.boundingBox;
        // final List<Point<int>> cornerPoints = block.cornerPoints;
        // final String text = block.text;
        // final List<String> languages = block.recognizedLanguages;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            extractedText += '${element.text} ';
          }
          extractedText += '\n';
        }
      }
      textRecognizer.close();
      return extractedText;
    }
    textRecognizer.close();
    return "";
  }