import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/View/Screens/quiz/startQuizScreen.dart';
import 'package:grammer_checker_app/View/Widgets/header_screends.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/core/utils/ShimarEffectAD.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:grammer_checker_app/core/utils/theme.dart';
import 'package:grammer_checker_app/main.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // load ad
  NativeAd? nativeAd3;
  bool isAdLoaded = false;
  loadNativeAd() async {
    try {
      nativeAd3 = NativeAd(
        factoryId: "listTile",
        adUnitId: AdHelper.nativeAd,
        listener: NativeAdListener(onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          setState(() {
            isAdLoaded = false;
            nativeAd3 = null;
          });
        }),
        request: const AdRequest(),
      );

      nativeAd3!.load();
    } catch (e, stackTrace) {
      setState(() {
        isAdLoaded = false;
        nativeAd3 = null;
      });
      log('Error loading ad: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (nativeAd3 == null) {
      loadNativeAd();
    }
  }

  void disposeAd() {
    if (nativeAd3 != null) {
      nativeAd3?.dispose();
      nativeAd3 = null;
      // ads.isAdLoaded.value = false;
      log(" native ad dispose");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeAd();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(height: height, text: "Grammar Test"),
            SizedBox(height: height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildQuizButton(
                    context,
                    title: 'Basic Level',
                    description: 'Test your basic English grammar skills.',
                    icon: Icons.school,
                    onPressed: () {
                      // Navigate to Intermediate Quiz
                      Get.to(() => const StartNewQuizScreen(
                            difficulty_level: "Easy",
                          ));
                      // QuizRefereshDialouge(
                      //     context, MediaQuery.of(context).size);
                    },
                  ),
                  SizedBox(height: height * 0.03),
                  _buildQuizButton(
                    context,
                    title: 'Intermediate Level',
                    description: 'Challenge yourself with intermediate test.',
                    icon: Icons.grade_outlined,
                    onPressed: () {
                      // Navigate to Intermediate Quiz
                      Get.to(() => const StartNewQuizScreen(
                            difficulty_level: "Intermediate",
                          ));
                    },
                  ),
                  SizedBox(height: height * 0.03),
                  _buildQuizButton(
                    context,
                    title: 'Expert Level',
                    description: 'Master the advanced skills.',
                    icon: Icons.airline_stops_sharp,
                    onPressed: () {
                      // Navigate to Expert Quiz
                      // Navigate to Intermediate Quiz
                      Get.to(() => const StartNewQuizScreen(
                            difficulty_level: "Hard",
                          ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => (!Subscriptioncontroller
                      .isMonthlypurchased.value &&
                  !Subscriptioncontroller.isYearlypurchased.value) &&
              isAdLoaded &&
              nativeAd3 != null
          ? Container(
              decoration:
                  BoxDecoration(color: white, border: Border.all(color: black)),
              height: 350,
              width: double.infinity,
              child: AdWidget(ad: nativeAd3!))
          : (Subscriptioncontroller.isMonthlypurchased.value ||
                  Subscriptioncontroller.isYearlypurchased.value)
              ? SizedBox()
              : ShimmarrNativeLarge(mq: mq, height: 300)),
    );
  }

  Widget _buildQuizButton(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required VoidCallback onPressed}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(width * .03),
        decoration: BoxDecoration(
            color: mainClr, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(icon, size: height * 0.04, color: AppColors.white),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: height * 0.030,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  // SizedBox(height: height * 0.01),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.017,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, size: 30, color: AppColors.white)
          ],
        ),
      ),
    );
  }
}
