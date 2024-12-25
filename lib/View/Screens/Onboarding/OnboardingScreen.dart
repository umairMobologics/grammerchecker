import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammar_checker_app_updated/controllers/OnBoardingController.dart';
import 'package:grammar_checker_app_updated/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammar_checker_app_updated/core/utils/ShimarEffectAD.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/customTextStyle.dart';
import 'package:grammar_checker_app_updated/core/utils/rippleEffect.dart';
import 'package:grammar_checker_app_updated/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Controllers/InAppPurchases/isPremiumCheck.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController controller = Get.put(OnboardingController());

  final List<String> images = [
    "assets/ob1.svg",
    "assets/ob2.svg",
    "assets/ob5.svg",
    "assets/ob3.svg",
  ];

  final List<String> titles = ["ob1", "ob2", "ob4", "ob3"];

  final List<String> descriptions = ["obdes1", "obdes2", "obdes4", "obdes3"];
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

  void disposeAd() {
    if (nativeAd3 != null) {
      nativeAd3?.dispose();
      nativeAd3 = null;
      // ads.isAdLoaded.value = false;
      log(" native ad dispose");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (nativeAd3 == null && ispremium()) {
      loadNativeAd();
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
    PageController pageController = PageController();

    return Scaffold(
      backgroundColor: white,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              onPageChanged: (index) =>
                  controller.onPageChanged(index, images.length),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: SvgPicture.asset(images[index])),
                  ],
                );
              },
            ),
          ),
          Container(
            height: mq.height * 0.35,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400, // Shadow color with opacity
                    spreadRadius: 1, // Spread radius
                    blurRadius: 20, // Blur radius
                    offset:
                        const Offset(0, -3), // Offset in the x and y direction
                  ),
                ],
                color: white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: mq.height * 0.03),
                  child: Obx(
                    () => Column(
                      children: [
                        Text(
                            textAlign: TextAlign.center,
                            titles[controller.currentPage.value].tr,
                            style: customTextStyle(
                                fontSize: mq.height * 0.024,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: mq.width * 0.02),
                          child: Text(
                            textAlign: TextAlign.center,
                            descriptions[controller.currentPage.value].tr,
                            style: customTextStyle(fontSize: mq.height * 0.020),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: pageController,
                      count: 4,
                      effect: const WormEffect(
                        activeDotColor: mainClr,
                        dotColor: Colors.grey,
                        dotHeight: 8,
                        dotWidth: 16,
                        // type: WormType.underground,
                      ),
                    ),
                    Obx(
                      () {
                        return RippleEffect(
                          borderRadius: BorderRadius.circular(12),
                          rippleColor: grey,
                          onTap: controller.isLastPage.value
                              ? () {
                                  controller.goToHome();
                                }
                              : () => controller.nextPage(
                                  pageController, images.length),
                          child: Ink(
                            padding: const EdgeInsets.all(18),
                            width: mq.width * 0.23,
                            decoration: BoxDecoration(
                                color: mainClr,
                                borderRadius: BorderRadius.circular(12)),
                            child: Icon(
                              controller.isLastPage.value
                                  ? Icons.done
                                  : Icons.arrow_forward_ios,
                              color: white,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Obx(() => ispremium() &&
              isAdLoaded &&
              nativeAd3 != null
          ? Container(
              decoration:
                  BoxDecoration(color: white, border: Border.all(color: black)),
              height: 135,
              width: double.infinity,
              child: AdWidget(ad: nativeAd3!))
          : (Subscriptioncontroller.isMonthlypurchased.value ||
                  Subscriptioncontroller.isWeeklypurchased.value ||
                  Subscriptioncontroller.isYearlypurchased.value)
              ? SizedBox()
              : ShimmarrNativeSmall(mq: mq, height: 135)),
    );
  }
}

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    super.key,
    required this.image1,
    required this.title1,
    required this.des1,
  });

  final String image1;
  final String title1;
  final String des1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(image1),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                  textAlign: TextAlign.center,
                  title1,
                  style: customTextStyle(
                      fontSize: size.height * 0.024,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: size.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Text(
                  textAlign: TextAlign.center,
                  des1,
                  style: customTextStyle(fontSize: size.height * 0.020),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.05,
        )
      ],
    );
  }
}
