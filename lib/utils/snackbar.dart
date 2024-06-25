import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSnackbar(String message, SnackPosition pos) {
    Get.snackbar(
      'Message!',
      message,
      snackPosition: pos,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.grey[800],
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
        content: Text(text.tr),
      ),);
    

}


// Usage example:
// CustomSnackbar.showSnackbar('This is a custom snackbar!');
