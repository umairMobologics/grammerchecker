import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/limitedTokens/limitedTokens.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/View/Screens/quiz/quiz_screen.dart';
import 'package:grammer_checker_app/View/Widgets/FeaturedCard.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/ShimarEffectAD.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';

final TokenLimitService askAILimit = TokenLimitService(featureName: 'limits');

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
// //load ad
//   var ads = Get.put(AdController());
//   NativeAd? nativeAd3;

//   void loadNative() async {
//     ads.isAdLoaded.value = false;
//     if (nativeAd3 == null) {
//       nativeAd3 ??= await ads.loadNativeAd();
//     }
//   }// load ad
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
      if (InterstitialAdClass.interstitialAd == null) {
        InterstitialAdClass.createInterstitialAd();
      }
      // ads.isAdLoaded.value = false;
      // nativeAd3 ??= ads.loadNativeAd();
      if (nativeAd3 == null) {
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

    return PopScope(
        onPopInvoked: (didPop) {
          showExitPopup();
        },
        child: Scaffold(
          backgroundColor: white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        featureCard(
                          SmallSize: false,
                          icon: SvgPicture.asset(
                            "assets/ob2.svg",
                          ),
                          onPressed: () {
                            InterstitialAdClass.count += 1;
                            if (InterstitialAdClass.count ==
                                    InterstitialAdClass.totalLimit &&
                                (!Subscriptioncontroller
                                        .isMonthlypurchased.value &&
                                    !Subscriptioncontroller
                                        .isYearlypurchased.value)) {
                              InterstitialAdClass.showInterstitialAd(context);
                            }
                            page.value = 3;
                          },
                          text: "corrector".tr,
                        ),
                        SizedBox(width: mq.width * 0.04),
                        featureCard(
                          SmallSize: true,
                          icon: SvgPicture.asset(
                            "assets/ob1.svg",
                          ),
                          onPressed: () {
                            InterstitialAdClass.count += 1;
                            if (InterstitialAdClass.count ==
                                    InterstitialAdClass.totalLimit &&
                                (!Subscriptioncontroller
                                        .isMonthlypurchased.value &&
                                    !Subscriptioncontroller
                                        .isYearlypurchased.value)) {
                              InterstitialAdClass.showInterstitialAd(context);
                            }
                            page.value = 1;
                          },
                          text: "paraphrase".tr,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        featureCard(
                          SmallSize: true,
                          icon: SvgPicture.asset(
                            "assets/ob3.svg",
                          ),
                          onPressed: () {
                            InterstitialAdClass.count += 1;
                            if (InterstitialAdClass.count ==
                                    InterstitialAdClass.totalLimit &&
                                (!Subscriptioncontroller
                                        .isMonthlypurchased.value &&
                                    !Subscriptioncontroller
                                        .isYearlypurchased.value)) {
                              InterstitialAdClass.showInterstitialAd(context);
                            }
                            page.value = 4;
                          },
                          text: "translator".tr,
                        ),
                        SizedBox(width: mq.width * 0.04),
                        featureCard(
                          SmallSize: false,
                          icon: SvgPicture.asset(
                            "assets/ob4.svg",
                          ),
                          onPressed: () {
                            InterstitialAdClass.count += 1;
                            if (InterstitialAdClass.count ==
                                    InterstitialAdClass.totalLimit &&
                                (!Subscriptioncontroller
                                        .isMonthlypurchased.value &&
                                    !Subscriptioncontroller
                                        .isYearlypurchased.value)) {
                              InterstitialAdClass.showInterstitialAd(context);
                            }
                            page.value = 0;
                          },
                          text: "askai".tr,
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * 0.02),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: mainClr,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "English Grammar Test",
                            style: customTextStyle(
                                fontSize: mq.height * 0.025,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                          SizedBox(height: mq.height * 0.01),
                          Text(
                            "Begin the English Grammar Test to assess and improve your grammar skills.",
                            textAlign: TextAlign.center,
                            style: customTextStyle(
                                // fontSize: mq.height * 0.018,

                                // fontWeight: FontWeight.bold,
                                color: white),
                          ),
                          SizedBox(height: mq.height * 0.02),
                          InkWell(
                            onTap: () => Get.to(() => QuizScreen()),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: white,
                                ),
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Let's GO",
                                      style: customTextStyle(
                                          fontSize: mq.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                          color: mainClr),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: mainClr,
                                      size: 20,
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )
                    // TextButton(
                    //     onPressed: () {
                    //       GoogleGenerativeServices.getText(
                    //           "hi,write me a love  letter dangerous terorists");
                    //     },
                    //     child: Text("new api test"))
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Obx(() =>
              (!Subscriptioncontroller.isMonthlypurchased.value &&
                          !Subscriptioncontroller.isYearlypurchased.value) &&
                      isAdLoaded &&
                      nativeAd3 != null
                  ? Container(
                      decoration: BoxDecoration(
                          color: white, border: Border.all(color: black)),
                      height: 150,
                      width: double.infinity,
                      child: AdWidget(ad: nativeAd3!))
                  : (Subscriptioncontroller.isMonthlypurchased.value ||
                          Subscriptioncontroller.isYearlypurchased.value)
                      ? SizedBox()
                      : ShimmarrNativeSmall(mq: mq, height: 135)),
        ));
  }
}
