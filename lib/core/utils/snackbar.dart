import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSnackbar(String message, SnackPosition pos, {Color? color}) {
    Get.snackbar(
      'Message!',
      message,
      snackPosition: pos,
      duration: Duration(seconds: 3),
      backgroundColor: color ?? Colors.grey[800],
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      animationDuration: Duration(milliseconds: 300),
    );
  }
}

Future<void> copyToClipboard(BuildContext context, String text) {
  return Clipboard.setData(ClipboardData(text: text)).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('copy'.tr),
      ),
    );
  });
}

showToast(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void showFeedback(bool isCorrect) {
  final message = isCorrect
      ? "🎉 Great job! Your sentence is correct."
      : "❌ Oops! That's not correct.";
  final color = isCorrect ? Colors.green : Colors.red;

  Get.snackbar(
    'Message!',
    message,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 2),
    backgroundColor: color,
    colorText: Colors.white,
    borderRadius: 10,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    animationDuration: Duration(milliseconds: 300),
  );
}



// Usage example:
// CustomSnackbar.showSnackbar('This is a custom snackbar!');
