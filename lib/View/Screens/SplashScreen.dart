import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/SplashAnimation.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/View/Screens/Onboarding/OnboardingScreen.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/core/utils/ShimarEffectAD.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:grammer_checker_app/core/utils/customTextStyle.dart';
import 'package:grammer_checker_app/main.dart';

import '../../core/Firebase/FirebaseQuizService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
// // load ad
//   var ads = Get.put(AdController());
//   NativeAd? nativeAd3;

//   void loadNative() async {
//     ads.isAdLoaded.value = false;
//     if (nativeAd3 == null) {
//       nativeAd3 ??= await ads.loadNativeAd();
//     }
//   }
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
            log("native splas loade d");
          });
        }, onAdFailedToLoad: (ad, error) {
          log("natve splash faled to load");
        }),
        request: const AdRequest(),
      );

      nativeAd3!.load();
    } catch (e, stackTrace) {
      nativeAd3 = null;
      log('Error loading ad: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  var animation = Get.put(SplashAnimation());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (nativeAd3 == null) {
      loadNativeAd();
    }
    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
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
    animation.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    FirebaseAnalytics.instance.logScreenView(screenName: "Splash Screen");
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        // alignment: Alignment.bottomCenter,
        // fit: StackFit.expand,
        children: [
          SizedBox(
            width: mq.width,
            height: mq.height,
            child: SvgPicture.asset(
              "assets/splashbg.svg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // color: red,
                height: mq.height * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(child: SvgPicture.asset("assets/appName.svg")),
                    // Positioned(
                    //   bottom: mq.height*0.1,
                    //   child: Container(height: mq.height*0.05,
                    //   width: mq.width*0.30,
                    //   decoration: BoxDecoration(color: mainClr,borderRadius: BorderRadius.circular(10),

                    //   ),
                    //   child: Center(child: Text("Start", style: customTextStyle(fontSize: mq.height*0.030,color: white,fontWeight: FontWeight.bold),)),

                    //   ),
                    // ),
                    // SizedBox(
                    //   height: mq.height * 0.1,
                    // ),
                    // SizedBox(
                    //   height: mq.height * 0.02,
                    // )

                    Obx(
                      () => animation.splashScreenButtonShown.value
                          ? InkWell(
                              onTap: () {
                                // await QuizCompletionStatus.markQuiz();
                                FetchQuizDataController()
                                    .initializeQuizQuestions();
                                // FetchQuizDataController().refreshQuizData();

                                if (initScreen == 0 || initScreen == null) {
                                  Get.to(() => OnboardingScreen());
                                } else {
                                  if (InterstitialAdClass.interstitialAd !=
                                          null &&
                                      (!(Subscriptioncontroller
                                              .isMonthlypurchased.value ||
                                          Subscriptioncontroller
                                              .isYearlypurchased.value))) {
                                    InterstitialAdClass.showInterstitialAd(
                                        context);
                                    InterstitialAdClass.count = 0;
                                  }
                                  if (!(Subscriptioncontroller
                                          .isMonthlypurchased.value ||
                                      Subscriptioncontroller
                                          .isYearlypurchased.value)) {
                                    Get.to(() => const PremiumScreen(
                                          isSplash: true,
                                        ));
                                  } else {
                                    Get.off(() => const BottomNavBarScreen());
                                  }
                                }
                              },
                              child: Material(
                                elevation: 15,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: mq.width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mq.width * 0.10,
                                      vertical: mq.height * 0.015),
                                  decoration: BoxDecoration(
                                      color: mainClr,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Text(
                                    "start".tr,
                                    style: customTextStyle(
                                        fontSize: mq.height * 0.025,
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            )
                          : Container(
                              height: 10,
                              child: PercentProgressIndicator(
                                animationController: animation,
                                width: mq.width * 0.9,
                                percent: 1.0,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
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
      // bottomNavigationBar: Obx(
      //   () => ads.isLoaded.value &&
      //           !InterstitialAdClass.isInterAddLoaded.value &&
      //           _anchoredAdaptiveAd != null
      //       ? Container(
      //           decoration: BoxDecoration(
      //               // color: Colors.green,
      //               border: Border.all(
      //             color: Colors.deepPurpleAccent,
      //             width: 0,
      //           )),
      //           width: _anchoredAdaptiveAd!.size.width.toDouble(),
      //           height: _anchoredAdaptiveAd!.size.height.toDouble(),
      //           child: AdWidget(ad: _anchoredAdaptiveAd!),
      //         )
      //       : const SizedBox(),
      // ),
    );
  }
}

class PercentProgressIndicator extends StatelessWidget {
  final double percent;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final double width;
  final double borderRadius;
  final SplashAnimation animationController;

  const PercentProgressIndicator({
    super.key,
    required this.percent,
    this.backgroundColor = Colors.white,
    this.progressColor = mainClr,
    this.height = 10,
    this.width = 300,
    this.borderRadius = 12,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the progress width and splash screen button visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        animationController.updateWidth(percent * width);
      });
      Future.delayed(const Duration(seconds: 5), () {
        animationController.showSplashScreenButton();
      });
    });

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor,
          ),
        ),
        Obx(() {
          return AnimatedContainer(
            duration: const Duration(seconds: 4),
            width: animationController.width.value,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: progressColor,
            ),
          );
        }),
      ],
    );
  }
}
