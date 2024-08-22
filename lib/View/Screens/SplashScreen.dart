import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/SplashAnimation.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/View/Screens/Onboarding/OnboardingScreen.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
// load ad
  var ads = Get.put(AdController());
  NativeAd? nativeAd3;

  void loadNative() async {
    ads.isAdLoaded.value = false;
    if (nativeAd3 == null) {
      nativeAd3 ??= await ads.loadNativeAd();
    }
  }

  var animation = Get.put(SplashAnimation());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadNative();

    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
  }

  void disposeads() {
    nativeAd3?.dispose();
    nativeAd3 = null;
    log("native splash dosposed");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeads();
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
                                if (InterstitialAdClass.interstitialAd !=
                                        null &&
                                    (!Subscriptioncontroller
                                            .isMonthlypurchased.value &&
                                        !Subscriptioncontroller
                                            .isYearlypurchased.value)) {
                                  InterstitialAdClass.showInterstitialAd(
                                      context);
                                  InterstitialAdClass.count = 0;
                                }

                                if (!Subscriptioncontroller
                                        .isMonthlypurchased.value &&
                                    !Subscriptioncontroller
                                        .isYearlypurchased.value) {
                                  Get.to(() => const PremiumScreen(
                                        isSplash: true,
                                      ));
                                } else {
                                  if (initScreen == 0 || initScreen == null) {
                                    Get.to(() => OnboardingScreen());
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
                                    "Start",
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
      bottomNavigationBar: Obx(
        () => (!Subscriptioncontroller.isMonthlypurchased.value &&
                    !Subscriptioncontroller.isYearlypurchased.value) &&
                ads.isAdLoaded.value &&
                nativeAd3 != null
            ? Container(
                decoration: BoxDecoration(border: Border.all(color: black)),
                height: 150,
                width: double.infinity,
                child: AdWidget(ad: nativeAd3!))
            : Container(
                color: Colors.transparent,
                height: 0,
                width: double.infinity,
              ),
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
