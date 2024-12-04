import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/core/databaseHelper/quizStatus.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:grammer_checker_app/core/utils/customTextStyle.dart';
import 'package:lottie/lottie.dart';

import '../Firebase/FirebaseQuizService.dart';

showLoadingDialog(BuildContext context, Size mq) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevents the dialog from being dismissed manually
    builder: (BuildContext context) {
      return PopScope(
        canPop: false, // Prevents the back button from closing the dialog
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: mq.height * 0.12,
            // color: red,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/l.json", height: mq.height * 0.08),
                Text("Please wait...",
                    style: TextStyle(
                        fontSize: mq.height * 0.020,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );
    },
  );
}

QuizRefereshDialouge(BuildContext context, double height) {
  return showDialog(
    context: context,
    barrierDismissible:
        false, // Prevents the dialog from being dismissed manually
    builder: (BuildContext context) {
      return PopScope(
        canPop: false, // Prevents the back button from closing the dialog
        child: Dialog(
          backgroundColor: white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: height * 0.4,
            // color: red,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SvgPicture.asset("assets/Icons/quizReward.svg",
                        height: height * 0.15),
                  ),
                  Text(
                      "Congratulations 🎉 on completing your all tests 🏅\nA new test is generated for you shortly.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: height * 0.020,
                          fontWeight: FontWeight.bold)),
                  // Expanded(child: SizedBox(height: mq.height * 0.02)),
                  InkWell(
                    onTap: () async {
                      await QuizCompletionStatus.resetQuizAsFalse();
                      FetchQuizDataController().refreshQuizData();
                      Get.offAll(() => BottomNavBarScreen());
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: mainClr,
                        ),
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Got it!",
                              style: customTextStyle(
                                  fontSize: height * 0.018,
                                  fontWeight: FontWeight.bold,
                                  color: white),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<bool> onBackFromRewardScreen(BuildContext context, Size mq) async {
  return await showDialog(
        //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Exit Quiz",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Are you sure you want to exit the quiz? Your current progress will be lost, and the quiz will reset.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel exit
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  log("tapp");
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      ) ??
      false; //if showDialouge had returned null, then return false
}
