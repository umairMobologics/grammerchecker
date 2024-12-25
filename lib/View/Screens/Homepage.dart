import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammar_checker_app_updated/Controllers/limitedTokens/limitedTokens.dart';
import 'package:grammar_checker_app_updated/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammar_checker_app_updated/View/Screens/GrammarCourse/CourseScreen.dart';
import 'package:grammar_checker_app_updated/View/Screens/RewardCenter/RewardHomePage.dart';
import 'package:grammar_checker_app_updated/View/Screens/quiz/quiz_screen.dart';
import 'package:grammar_checker_app_updated/View/Widgets/FeaturedCard.dart';
import 'package:grammar_checker_app_updated/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammar_checker_app_updated/core/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammar_checker_app_updated/core/utils/ShimarEffectAD.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/customTextStyle.dart';
import 'package:grammar_checker_app_updated/main.dart';
import 'package:lottie/lottie.dart';

import '../../Controllers/InAppPurchases/isPremiumCheck.dart';

final TokenLimitService askAILimit = TokenLimitService(featureName: 'limits');

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (InterstitialAdClass.interstitialAd == null && ispremium()) {
        InterstitialAdClass.createInterstitialAd();
      }
      // ads.isAdLoaded.value = false;
      // nativeAd3 ??= ads.loadNativeAd();
      if (nativeAd3 == null && ispremium()) {
        loadNativeAd();
      }
    });
    FirebaseAnalytics.instance.logScreenView(screenName: "home page");
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
    var mq = MediaQuery.of(context).size;
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'exitapp'.tr,
                style:
                    customTextStyle(color: black, fontSize: mq.height * 0.030),
              ),
              content: Text(
                'exitappdes'.tr,
                style:
                    customTextStyle(color: black, fontSize: mq.height * 0.020),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  //return false when click on "NO"
                  child: Text(
                    'no'.tr,
                    style: TextStyle(color: red, fontSize: mq.height * 0.020),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    SystemNavigator.pop();
                  },
                  //return true when click on "Yes"
                  child: Text(
                    'yes'.tr,
                    style: TextStyle(color: red, fontSize: mq.height * 0.020),
                  ),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return SafeArea(
      child: PopScope(
          onPopInvoked: (didPop) {
            showExitPopup();
          },
          child: Scaffold(
            backgroundColor: white,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5),
                      child: SlideInLeft(
                        duration: Duration(seconds: 2),
                        child: InkWell(
                          onTap: () {
                            if (InterstitialAdClass.interstitialAd != null &&
                                ispremium()) {
                              InterstitialAdClass.showInterstitialAd(context);
                              InterstitialAdClass.count = 0;
                            }

                            Get.to(() => RewardScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  mainClr,
                                  Color.fromARGB(255, 79, 149, 255)
                                      .withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mainClr.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Lottie.asset(
                                        "assets/RewardCenter/rewardCenter2.json",
                                        height: 40,
                                        width: 40,
                                        repeat: true,
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Boost Your Learning!",
                                              textAlign: TextAlign.start,
                                              style: customTextStyle(
                                                fontSize: mq.height * 0.025,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Learn Grammar by Playing Games",
                                              textAlign: TextAlign.start,
                                              style: customTextStyle(
                                                fontSize: mq.height * 0.016,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: white),
                                  child: Text(
                                    "Play Game",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: mq.height * 0.020,
                                        color: mainClr),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.005),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          featureCard(
                            SmallSize: false,
                            icon: SvgPicture.asset(
                              "assets/ob2.svg",
                            ),
                            onPressed: () {
                              InterstitialAdClass.count += 1;
                              if (InterstitialAdClass.count >=
                                      InterstitialAdClass.totalLimit &&
                                  InterstitialAdClass.interstitialAd != null &&
                                  ispremium()) {
                                InterstitialAdClass.showInterstitialAd(context);
                              }
                              page.value = 3;
                            },
                            text: "correctorhome".tr,
                          ),
                          SizedBox(width: mq.width * 0.04),
                          featureCard(
                            SmallSize: true,
                            icon: SvgPicture.asset(
                              "assets/ob1.svg",
                            ),
                            onPressed: () {
                              InterstitialAdClass.count += 1;
                              if (InterstitialAdClass.count >=
                                      InterstitialAdClass.totalLimit &&
                                  InterstitialAdClass.interstitialAd != null &&
                                  ispremium()) {
                                InterstitialAdClass.showInterstitialAd(context);
                              }
                              page.value = 1;
                            },
                            text: "paraphrase".tr,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mq.height * 0.015,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          featureCard(
                            SmallSize: true,
                            icon: Image.asset(
                              "assets/course.png",
                            ),
                            onPressed: () {
                              InterstitialAdClass.count += 1;
                              if (InterstitialAdClass.count >=
                                      InterstitialAdClass.totalLimit &&
                                  InterstitialAdClass.interstitialAd != null &&
                                  ispremium()) {
                                InterstitialAdClass.showInterstitialAd(context);
                              }
                              Get.to(() => CourseScreen());
                            },
                            text: "learnGrammar".tr,
                          ),
                          SizedBox(width: mq.width * 0.04),
                          featureCard(
                            SmallSize: false,
                            icon: SvgPicture.asset(
                              "assets/ob4.svg",
                            ),
                            onPressed: () {
                              InterstitialAdClass.count += 1;
                              if (InterstitialAdClass.count >=
                                      InterstitialAdClass.totalLimit &&
                                  InterstitialAdClass.interstitialAd != null &&
                                  ispremium()) {
                                InterstitialAdClass.showInterstitialAd(context);
                              }
                              page.value = 0;
                            },
                            text: "askai".tr,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: mq.height * 0.015),
                    Obx(() => ispremium() &&
                            !InterstitialAdClass.isInterAddLoaded.value &&
                            !AppOpenAdManager.isOpenAdLoaded.value &&
                            isAdLoaded &&
                            nativeAd3 != null
                        ? Container(
                            decoration: BoxDecoration(
                                color: white, border: Border.all(color: black)),
                            height: 135,
                            width: double.infinity,
                            child: AdWidget(ad: nativeAd3!))
                        : (Subscriptioncontroller.isMonthlypurchased.value ||
                                Subscriptioncontroller
                                    .isWeeklypurchased.value ||
                                Subscriptioncontroller.isYearlypurchased.value)
                            ? SizedBox()
                            : ShimmarrNativeSmall(mq: mq, height: 135)),
                    // SizedBox(height: mq.height * 0.015),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10),
                      child: SlideInUp(
                        duration: Duration(seconds: 2),
                        child: InkWell(
                          onTap: () => Get.to(() => QuizScreen()),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  mainClr,
                                  Color.fromARGB(255, 79, 149, 255)
                                      .withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mainClr.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "English Grammar Test",
                                        textAlign: TextAlign.center,
                                        style: customTextStyle(
                                          fontSize: mq.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Begin the English Grammar Test to improve your grammar skills.",
                                        textAlign: TextAlign
                                            .left, // Align text to the left
                                        maxLines: 2,
                                        overflow: TextOverflow
                                            .ellipsis, // Add ellipsis for long text
                                        style: customTextStyle(
                                          fontSize: mq.height * 0.018,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: white),
                                  child: Text(
                                    "Let's GO",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: mq.height * 0.020,
                                        color: mainClr),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SlideInUp(
                    //   duration: Duration(seconds: 2),
                    //   child: Container(
                    //     width: double.infinity,
                    //     padding: EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12),
                    //       color: mainClr,
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Text(
                    //           "English Grammar Test",
                    //           style: customTextStyle(
                    //               fontSize: mq.height * 0.025,
                    //               fontWeight: FontWeight.bold,
                    //               color: white),
                    //         ),
                    //         SizedBox(height: mq.height * 0.01),
                    //         Text(
                    //           "Begin the English Grammar Test to assess and improve your grammar skills.",
                    //           textAlign: TextAlign.center,
                    //           style: customTextStyle(
                    //               // fontSize: mq.height * 0.018,

                    //               // fontWeight: FontWeight.bold,
                    //               color: white),
                    //         ),
                    //         SizedBox(height: mq.height * 0.02),
                    //         InkWell(
                    //           onTap: () => Get.to(() => QuizScreen()),
                    //           child: Container(
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(12),
                    //                 color: white,
                    //               ),
                    //               padding: EdgeInsets.all(12),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     "Let's GO",
                    //                     style: customTextStyle(
                    //                         fontSize: mq.height * 0.025,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: mainClr),
                    //                   ),
                    //                   Icon(
                    //                     Icons.arrow_forward_ios,
                    //                     color: mainClr,
                    //                     size: 20,
                    //                   )
                    //                 ],
                    //               )),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            // bottomNavigationBar: Obx(() =>
            //     (!(Subscriptioncontroller.isMonthlypurchased.value ||
            //                 Subscriptioncontroller.isYearlypurchased.value)) &&
            //             !InterstitialAdClass.isInterAddLoaded.value &&
            //             !AppOpenAdManager.isOpenAdLoaded.value &&
            //             isAdLoaded &&
            //             nativeAd3 != null
            //         ? Container(
            //             decoration: BoxDecoration(
            //                 color: white, border: Border.all(color: black)),
            //             height: 135,
            //             width: double.infinity,
            //             child: AdWidget(ad: nativeAd3!))
            //         : (Subscriptioncontroller.isMonthlypurchased.value ||
            //                 Subscriptioncontroller.isYearlypurchased.value)
            //             ? SizedBox()
            //             : ShimmarrNativeSmall(mq: mq, height: 135)),
          )),
    );
  }
}
