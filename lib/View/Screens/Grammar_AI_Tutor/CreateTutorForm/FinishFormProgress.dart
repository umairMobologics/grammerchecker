import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/core/model/TutorModels/tutorModel.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';
import 'package:grammar_checker_app_updated/main.dart';

import '../../../../Controllers/InAppPurchases/isPremiumCheck.dart';
import '../../../../core/Helper/AdsHelper/AdHelper.dart';
import '../../../../core/utils/colors.dart';
import '../Controller/progressController.dart';
import '../TutorDashBoardList.dart';

class ProgressScreen extends StatefulWidget {
  final TutorModel data;

  ProgressScreen({super.key, required this.data});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ProgressController controller = Get.put(ProgressController());
  initState() {
    super.initState();
    FirebaseAnalytics.instance
        .logScreenView(screenName: "Tutor Created Screen");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create AI Tutor"),
          centerTitle: true,
        ),
        backgroundColor: white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Progress Indicator
              SizedBox(height: mq.height * 0.05),
              Obx(
                () => SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: controller.progress.value / 100,
                        strokeWidth: 6,
                        color: mainClr,
                      ),
                      Center(
                        child: SizedBox(
                          height: 150.h, // This constrains both types of images
                          child: widget.data.customAvatar != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional rounding
                                  child: Image.file(
                                    File(widget.data.customAvatar ?? ''),
                                    height: 120.h, // Constrain height
                                    width: 120.h, // Constrain width
                                    fit: BoxFit
                                        .cover, // Ensures the image fits well
                                  ),
                                )
                              : Image.asset(
                                  widget.data.tutorAvatar,
                                  height: 150.h, // Constrain height
                                  width: 150.h, // Constrain width
                                  fit: BoxFit
                                      .contain, // Ensures the image fits well
                                ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${controller.progress.value}%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              // Current Message
              Obx(() => Text(
                    controller.messages[controller.currentMessageIndex.value],
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )),
              SizedBox(height: 30),
              // Task Progress List
              Obx(() => Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              controller.completedSteps[index]
                                  ? Icons.check_circle
                                  : Icons.circle,
                              color: controller.completedSteps[index]
                                  ? green
                                  : Colors.grey,
                            ),
                            SizedBox(width: 10),
                            Text(
                              controller.messages[index],
                              style: TextStyle(
                                color: controller.completedSteps[index]
                                    ? mainClr
                                    : Colors.black,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  )),
            ],
          ),
        ),
        bottomNavigationBar: // Finish Button
            Obx(() => controller.isFinished.value
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if (InterstitialAdClass.interstitialAd != null &&
                            ispremium()) {
                          InterstitialAdClass.showInterstitialAd(context);
                          InterstitialAdClass.count = 0;
                        }
                        //     MaterialPageRoute(builder: (context) => const UserName()));
                        Get.off(() => TutorList(
                              isbottom: false,
                            ));
                      },
                      child: CustomButton(
                        text: "Start Tutoring",
                        color: white,
                        width: double.infinity,
                      ),
                    ),
                  )
                : SizedBox.shrink()),
      ),
    );
  }
}
