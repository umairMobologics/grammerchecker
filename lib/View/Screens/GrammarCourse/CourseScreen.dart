import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/View/Screens/GrammarCourse/StartGrammarCourse.dart';
import 'package:grammer_checker_app/View/Widgets/header_screends.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/core/utils/ShimarEffectAD.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:grammer_checker_app/core/utils/theme.dart';
import 'package:grammer_checker_app/main.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List levels = [
    'level1',
    'level2',
    'level3',
    'level4',
    'level5',
    'level6',
    'level7',
  ];
  List displayLevels = [
    'Level 1',
    'Level 2',
    'Level 3',
    'Level 4',
    'Level 5',
    'Level 6',
    'Level 7',
  ];
  List levelsDescription = [
    'Learn About Parts of speech',
    'Basic Sentence Structure and Tenses',
    'Verb Forms and Extended Tenses',
    'Sentence Types and Structure',
    'Advanced Tenses and Verb Forms',
    'Punctuation and Common Sentence Errors',
    'Advanced Grammar and Usage',
  ];

  // load ad
  NativeAd? nativeAd3;
  bool isAdLoaded = false;
  loadNativeAd() async {
    try {
      nativeAd3 = NativeAd(
        factoryId: "small",
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
      body: Column(
        children: [
          HeaderWidget(height: height, text: "Grammar Course"),
          Expanded(
            child: Bounce(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0, // Add spacing between rows
                  // crossAxisSpacing: 8.0, // Add spacing between columns
                  childAspectRatio:
                      1.8, // Set aspect ratio to control item width/height
                ),
                itemCount: levels.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildQuizButton(
                    context,
                    title: displayLevels[index],
                    description: levelsDescription[index],
                    // icon: Icons.school,
                    onPressed: () {
                      // Navigate to Intermediate Quiz
                      Get.to(() => GrammarScreen(
                            level: levels[index],
                          ));
                      // QuizRefereshDialouge(
                      //     context, MediaQuery.of(context).size);
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Obx(() => (!(Subscriptioncontroller
                      .isMonthlypurchased.value ||
                  Subscriptioncontroller.isYearlypurchased.value)) &&
              isAdLoaded &&
              nativeAd3 != null
          ? Container(
              decoration:
                  BoxDecoration(color: white, border: Border.all(color: black)),
              height: 150,
              width: double.infinity,
              child: AdWidget(ad: nativeAd3!))
          : (Subscriptioncontroller.isMonthlypurchased.value ||
                  Subscriptioncontroller.isYearlypurchased.value)
              ? SizedBox()
              : ShimmarrNativeSmall(mq: mq, height: 135)),
    );
  }

  Widget _buildQuizButton(BuildContext context,
      {required String title,
      required String description,
      IconData? icon,
      required VoidCallback onPressed}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return FadeIn(
      duration: Duration(seconds: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Ink(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: mainClr,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 3.7,
                    offset: Offset(1, 1))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: height * 0.030,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
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
      ),
    );
  }
}
