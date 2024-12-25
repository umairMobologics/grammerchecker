import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammar_checker_app_updated/Controllers/SplashAnimation.dart';
import 'package:grammar_checker_app_updated/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammar_checker_app_updated/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammar_checker_app_updated/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';

import '../../Controllers/InAppPurchases/isPremiumCheck.dart';
import '../../core/Firebase/FirebaseQuizService.dart';
import '../../core/Helper/AdsHelper/AppOpenAdManager.dart';
import '../../core/databaseHelper/quizStatus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  var animation = Get.put(SplashAnimation());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    FirebaseAnalytics.instance.logScreenView(screenName: "Splash Screen");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    animation.dispose();
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
                    Obx(
                      () => animation.splashScreenButtonShown.value
                          ? SizedBox()
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

class PercentProgressIndicator extends StatefulWidget {
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
  State<PercentProgressIndicator> createState() =>
      _PercentProgressIndicatorState();
}

class _PercentProgressIndicatorState extends State<PercentProgressIndicator> {
  AppOpenAd? appOpenAd;
  bool isLoaded = false;

  loadOpenAppAd() async {
    try {
      AppOpenAd.load(
        adUnitId: "ca-app-pub-9800935656438737/1708647032",
        // orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            setState(() {
              appOpenAd = ad;
              isLoaded = true;
            });
            log("openapp ad is loaded");
          },
          onAdFailedToLoad: (error) {},
        ),
      );
    } catch (e, stackTrace) {
      appOpenAd = null;
      log('Error loading ad: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  void showOpenAppAd() {
    isOpenAdLoadedsplash.value = true;
    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        isOpenAdLoadedsplash.value = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        appOpenAd = null;
        Future.delayed(const Duration(seconds: 3)).then((value) {
          isOpenAdLoadedsplash.value = false;
        });
      },
      onAdDismissedFullScreenContent: (ad) {
        isOpenAdLoadedsplash.value = false;
        ad.dispose();
        appOpenAd = null;
      },
      onAdWillDismissFullScreenContent: (ad) {
        isOpenAdLoadedsplash.value = false;
        ad.dispose();
        appOpenAd = null;
      },
    );
    appOpenAd!.show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (ispremium()) {
      loadOpenAppAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the progress width and splash screen button visibility
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.animationController.updateWidth(widget.percent * widget.width);
      });
      await Future.delayed(const Duration(seconds: 5), () {
        widget.animationController.showSplashScreenButton();
      });

      await QuizCompletionStatus.markQuiz();
      FetchQuizDataController().initializeQuizQuestions();
      // FetchQuizDataController().refreshQuizData();
      if (isLoaded && appOpenAd != null && ispremium()) {
        log("show openApp Ad ");
        showOpenAppAd();
      } else {
        InterstitialAdClass.count = 3;
      }

      if (ispremium()) {
        Get.to(() => const PremiumScreen(
              isSplash: true,
            ));
      } else {
        Get.off(() => const BottomNavBarScreen());
      }
    });

    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.backgroundColor,
          ),
        ),
        Obx(() {
          return AnimatedContainer(
            duration: const Duration(seconds: 4),
            width: widget.animationController.width.value,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.progressColor,
            ),
          );
        }),
      ],
    );
  }
}
