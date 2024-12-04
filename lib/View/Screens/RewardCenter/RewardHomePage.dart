import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/RewardCenterControllers/RewardHomePageController.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/Level2Sentences.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/Level3Blanks.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/level1Words.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:lottie/lottie.dart';

import '../../../core/Helper/AdsHelper/AppOpenAdManager.dart';
import '../../../core/Helper/AdsHelper/rewardedAdHelper.dart';
import '../../../core/utils/ShimarEffectAD.dart';
import '../../../core/utils/snackbar.dart';
import '../../../main.dart';

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  var globleController = Get.put(Globletaskcontroller());
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
    super.initState();

    // ads.isAdLoaded.value = false;
    // nativeAd3 ??= ads.loadNativeAd();
    if (nativeAd3 == null) {
      loadNativeAd();
    }

    RewardedAdHelper.loadRewardedAd();
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
    disposeAd();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Rewards & Achievements"),
        backgroundColor: mainClr,
        // actions: [
        //   // InkWell(
        //   //     onTap: () {
        //   //       DatabaseHelper().clearTable("level1_rewards");
        //   //       DatabaseHelper().clearTable("level2_rewards");
        //   //       DatabaseHelper().clearTable("level3_rewards");
        //   //     },
        //   //     child: Icon(Icons.delete))
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeIn(
                duration: Duration(seconds: 3),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [mainClr, Colors.grey.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/RewardCenter/rewardHome.svg",
                        height: mq.height * 0.25,
                      ),
                      Positioned(
                        bottom: 5,
                        child: Lottie.asset(
                          "assets/RewardCenter/rewardLottie.json",
                          height: mq.height * 0.19,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => SlideInLeft(
                  child: RewardContainer(
                      onTap: () {
                        InterstitialAdClass.count += 1;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.totalLimit &&
                            InterstitialAdClass.interstitialAd != null &&
                            (!(Subscriptioncontroller
                                    .isMonthlypurchased.value ||
                                Subscriptioncontroller
                                    .isYearlypurchased.value))) {
                          InterstitialAdClass.showInterstitialAd(context);
                        }
                        // if (globleController.isLevel1Completed.value &&
                        //     globleController.isLevel1Win.value) {
                        //   CustomSnackbar.showSnackbar(
                        //       "You already finished the game",
                        //       SnackPosition.TOP,
                        //       color: green);
                        // } else {
                        //   Get.to(() => Level1WordsScreen());
                        // }
                        Get.to(
                          () => Intro(
                            buttonBuilder: (order) {
                              return IntroButtonConfig(
                                  text: order == 4 ? 'Done' : 'Next',
                                  fontSize: 20,
                                  height: 30,
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          order == 4 ? green : mainClr,
                                      padding: EdgeInsets.all(5),
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w500)));
                            },
                            child: Level1WordsScreen(),
                          ),
                        );
                      },
                      mq: mq,
                      // svgAsset: "assets/RewardCenter/rewardContainer.svg",
                      svgAsset: globleController.isLevel1Completed.value
                          ? globleController.isLevel1Win.value
                              ? "assets/RewardCenter/rewardContainer.svg"
                              : "assets/RewardCenter/rewardGreyContainer.svg"
                          : "assets/RewardCenter/rewardGreyContainer.svg",
                      title: "Level 1",
                      textClr: globleController.isLevel1Completed.value
                          ? globleController.isLevel1Win.value
                              ? white
                              : black54
                          : black54,
                      description:
                          "Complete this word game and earn 5 free credits.",
                      icon: SvgPicture.asset(
                          globleController.isLevel1Completed.value
                              ? globleController.isLevel1Win.value
                                  ? "assets/RewardCenter/done.svg"
                                  : "assets/RewardCenter/tryAgain.svg"
                              : "assets/RewardCenter/start.svg",
                          height: mq.height * 0.06),
                      iconText: globleController.isLevel1Completed.value
                          ? globleController.isLevel1Win.value
                              ? Text(
                                  "You Won",
                                  style: TextStyle(
                                      color: white,
                                      fontSize: mq.height * 0.018,
                                      fontWeight: FontWeight.bold),
                                )
                              : Obx(
                                  () => FadeIn(
                                    duration: Duration(seconds: 2),
                                    key: ValueKey<String>(globleController
                                        .displayText
                                        .value), // Unique key for each animation
                                    child: Text(
                                      globleController.displayText.value,
                                      style: TextStyle(
                                          fontSize: mq.height * 0.018,
                                          color: red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                          : Text(
                              "Start Now",
                              style: TextStyle(
                                  color: green,
                                  fontSize: mq.height * 0.018,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Obx(
                () => SlideInUp(
                  child: RewardContainer(
                      onTap: () {
                        InterstitialAdClass.count += 1;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.totalLimit &&
                            InterstitialAdClass.interstitialAd != null &&
                            (!(Subscriptioncontroller
                                    .isMonthlypurchased.value ||
                                Subscriptioncontroller
                                    .isYearlypurchased.value))) {
                          InterstitialAdClass.showInterstitialAd(context);
                        }
                        if (globleController.isLevel2Completed.value &&
                            globleController.isLevel2Win.value) {
                          CustomSnackbar.showSnackbar(
                              "You already finished the game",
                              SnackPosition.TOP,
                              color: green);
                        } else {
                          Get.to(
                            () => Intro(
                              buttonBuilder: (order) {
                                return IntroButtonConfig(
                                    text: order == 4 ? 'Done' : 'Next',
                                    fontSize: 20,
                                    height: 30,
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            order == 4 ? green : mainClr,
                                        padding: EdgeInsets.all(5),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500)));
                              },
                              child: Level2SentenceScreen(),
                            ),
                          );
                        }
                      },
                      mq: mq,
                      // svgAsset: "assets/RewardCenter/rewardContainer.svg",
                      svgAsset: globleController.isLevel2Completed.value
                          ? globleController.isLevel2Win.value
                              ? "assets/RewardCenter/rewardContainer.svg"
                              : "assets/RewardCenter/rewardGreyContainer.svg"
                          : "assets/RewardCenter/rewardGreyContainer.svg",
                      title: "Level 2",
                      textClr: globleController.isLevel2Completed.value
                          ? globleController.isLevel2Win.value
                              ? white
                              : black54
                          : black54,
                      description:
                          "Earn 10 extra credits by completing sentence game",
                      icon: SvgPicture.asset(
                          globleController.isLevel2Completed.value
                              ? globleController.isLevel2Win.value
                                  ? "assets/RewardCenter/done.svg"
                                  : "assets/RewardCenter/tryAgain.svg"
                              : "assets/RewardCenter/start.svg",
                          height: mq.height * 0.06),
                      iconText: globleController.isLevel2Completed.value
                          ? globleController.isLevel2Win.value
                              ? Text(
                                  "You Won",
                                  style: TextStyle(
                                      color: white,
                                      fontSize: mq.height * 0.018,
                                      fontWeight: FontWeight.bold),
                                )
                              : Obx(
                                  () => FadeIn(
                                    duration: Duration(seconds: 2),
                                    key: ValueKey<String>(globleController
                                        .displayText
                                        .value), // Unique key for each animation
                                    child: Text(
                                      globleController.displayText.value,
                                      style: TextStyle(
                                          fontSize: mq.height * 0.018,
                                          fontWeight: FontWeight.bold,
                                          color: red),
                                    ),
                                  ),
                                )
                          : Text(
                              "Start Now",
                              style: TextStyle(
                                  color: green,
                                  fontSize: mq.height * 0.018,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Obx(
                () => SlideInRight(
                  child: RewardContainer(
                      onTap: () {
                        InterstitialAdClass.count += 1;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.totalLimit &&
                            InterstitialAdClass.interstitialAd != null &&
                            (!(Subscriptioncontroller
                                    .isMonthlypurchased.value ||
                                Subscriptioncontroller
                                    .isYearlypurchased.value))) {
                          InterstitialAdClass.showInterstitialAd(context);
                        }
                        if (globleController.isLevel3Completed.value &&
                            globleController.isLevel3Win.value) {
                          CustomSnackbar.showSnackbar(
                              "You already finished the game",
                              SnackPosition.TOP,
                              color: green);
                        } else {
                          Get.to(
                            () => Intro(
                              buttonBuilder: (order) {
                                return IntroButtonConfig(
                                    text: order == 4 ? 'Done' : 'Next',
                                    fontSize: 20,
                                    height: 30,
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            order == 4 ? green : mainClr,
                                        padding: EdgeInsets.all(5),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500)));
                              },
                              child: Level3BlanksScreen(),
                            ),
                          );
                        }
                      },
                      mq: mq,
                      // svgAsset: "assets/RewardCenter/rewardContainer.svg",
                      svgAsset: globleController.isLevel3Completed.value
                          ? globleController.isLevel3Win.value
                              ? "assets/RewardCenter/rewardContainer.svg"
                              : "assets/RewardCenter/rewardGreyContainer.svg"
                          : "assets/RewardCenter/rewardGreyContainer.svg",
                      title: "Level 3",
                      textClr: globleController.isLevel3Completed.value
                          ? globleController.isLevel3Win.value
                              ? white
                              : black54
                          : black54,
                      description:
                          "Complete fill in the blanks game and get 15 extra credits",
                      icon: SvgPicture.asset(
                          globleController.isLevel3Completed.value
                              ? globleController.isLevel3Win.value
                                  ? "assets/RewardCenter/done.svg"
                                  : "assets/RewardCenter/tryAgain.svg"
                              : "assets/RewardCenter/start.svg",
                          height: mq.height * 0.06),
                      iconText: globleController.isLevel3Completed.value
                          ? globleController.isLevel3Win.value
                              ? Text(
                                  "You Won",
                                  style: TextStyle(
                                      color: white,
                                      fontSize: mq.height * 0.018,
                                      fontWeight: FontWeight.bold),
                                )
                              : Obx(
                                  () => FadeIn(
                                    duration: Duration(seconds: 2),
                                    key: ValueKey<String>(globleController
                                        .displayText
                                        .value), // Unique key for each animation
                                    child: Text(
                                      globleController.displayText.value,
                                      style: TextStyle(
                                          fontSize: mq.height * 0.018,
                                          fontWeight: FontWeight.bold,
                                          color: red),
                                    ),
                                  ),
                                )
                          : Text(
                              "Start Now",
                              style: TextStyle(
                                  color: green,
                                  fontSize: mq.height * 0.018,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => (!(Subscriptioncontroller
                      .isMonthlypurchased.value ||
                  Subscriptioncontroller.isYearlypurchased.value)) &&
              !InterstitialAdClass.isInterAddLoaded.value &&
              !AppOpenAdManager.isOpenAdLoaded.value &&
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
}

class RewardContainer extends StatelessWidget {
  const RewardContainer({
    super.key,
    required this.mq,
    required this.svgAsset,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconText,
    required this.textClr,
    required this.onTap,
  });

  final Size mq;
  final String? svgAsset;
  final String title;
  final String description;
  final Widget icon;
  final Widget iconText;
  final Color textClr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (svgAsset != null) SvgPicture.asset(svgAsset!),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: textClr,
                                fontSize: mq.height * 0.035,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              color: textClr,
                              fontSize: mq.height * 0.016,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: icon,
                  )
                ],
              ),
              SizedBox(height: mq.height * 0.003),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: iconText,
              )
            ],
          ),
        ],
      ),
    );
  }
}
