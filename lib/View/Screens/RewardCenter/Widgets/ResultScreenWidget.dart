import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../Controllers/RewardCenterControllers/RewardHomePageController.dart';
import '../../../../Controllers/RewardCenterControllers/RewardQuizController.dart';
import '../../../../core/Helper/AdsHelper/AdHelper.dart';
import '../../../../core/utils/colors.dart';
import '../../../../main.dart';
import '../../Homepage.dart';

class ResultScreen extends StatelessWidget {
  final height;
  final width;
  final RewardQuizController controller;
  final int quizLenght;
  final String level;
  const ResultScreen(
      {super.key,
      this.height,
      this.width,
      required this.controller,
      required this.quizLenght,
      required this.level});

  @override
  Widget build(BuildContext context) {
    final globleController = Get.find<Globletaskcontroller>();

    void setQuizStatus(bool status) {
      // Mark task as completed
      level == "level1"
          ? globleController.updateTaskCompleted(
              status, globleController.level1taskstatus)
          : level == "level2"
              ? globleController.updateTaskCompleted(
                  status, globleController.level2Taskstatus)
              : level == "level3"
                  ? globleController.updateTaskCompleted(
                      status, globleController.level3Taskstatus)
                  : null;
    }

    void setWinStatus(bool status) {
// Mark task as won
      // Mark task as completed
      level == "level1"
          ? globleController.updateTaskWin(
              status, globleController.level1Winstatus)
          : level == "level2"
              ? globleController.updateTaskWin(
                  status, globleController.level2Winstatus)
              : level == "level3"
                  ? globleController.updateTaskWin(
                      status, globleController.level3Winstatus)
                  : null;
    }

    String resultMessage;
    double percentage = controller.resultPercentage.value;

    if (percentage < 50) {
      resultMessage = 'Fail';
    } else if (percentage >= 50 && percentage < 70) {
      resultMessage = 'Average';
    } else if (percentage >= 70 && percentage < 80) {
      resultMessage = 'Good';
    } else if (percentage >= 80 && percentage < 90) {
      resultMessage = 'Very Good';
    } else {
      resultMessage = 'Excellent';
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            // padding: EdgeInsets.all(12),
            height: height * 0.30,
            width: width,
            decoration: BoxDecoration(
                color: mainClr,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(280),
                    bottomRight: Radius.circular(0))),
            child: percentage < 70
                ? Lottie.asset(
                    "assets/RewardCenter/result1.json",
                    height: height * 0.4,
                  )
                : Lottie.asset("assets/RewardCenter/result2.json",
                    height: height * 0.4, repeat: false),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                Text(
                  percentage < 70 ? "❌ Oops!" : "🎉 Congratulation!",
                  style: TextStyle(
                      color: percentage < 70 ? red : green,
                      fontSize: height * 0.030,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  percentage < 70
                      ? "Not this time, but keep trying!"
                      : "You're a true quiz champion!",
                  style: TextStyle(
                      color: percentage < 70 ? red : green,
                      fontSize: height * 0.025,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  percentage < 70
                      ? "You can play again to improve yourself and to win reward"
                      : "Knowledge is power, and you just proved it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: black,
                    fontSize: height * 0.020,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${controller.correctAnswersCount.value} / $quizLenght',
                        style: TextStyle(
                            fontSize: height * 0.035,
                            color: black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)} Points',
                        style:
                            TextStyle(fontSize: height * 0.025, color: black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.06),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () async {
                      if (InterstitialAdClass.interstitialAd != null &&
                          (!(Subscriptioncontroller.isMonthlypurchased.value ||
                              Subscriptioncontroller
                                  .isYearlypurchased.value))) {
                        InterstitialAdClass.showInterstitialAd(context);
                        InterstitialAdClass.count = 0;
                      }
                      setQuizStatus(true);
                      if (percentage >= 70) {
                        int? count;
                        if (level == "level1") {
                          count = 5;
                        } else if (level == "level2") {
                          count = 10;
                        } else if (level == "level3") {
                          count = 15;
                        }
                        setWinStatus(true);
                        if (count != null) {
                          askAILimit.creditReward(count);
                        }
                      } else {
                        setWinStatus(false);
                      }
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: mainClr,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        percentage < 70 ? "Try Again" : 'Claim Reward',
                        style: TextStyle(
                            fontSize: height * .022,
                            color: white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
