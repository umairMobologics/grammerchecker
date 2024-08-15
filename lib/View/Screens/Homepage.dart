import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
//load ad
  // var ads = Get.put(AdController());
  // NativeAd? nativeAd3;

//load ad
  BannerAd? _bannerAd2;
  bool isLoaded = false;

  loadBannerAd() async {
    try {
      _bannerAd2 = BannerAd(
        adUnitId: AdHelper.bannerAd,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            log('$ad loaded.');

            setState(() {
              isLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            log('BannerAd failed to load: $err');
            // Dispose the ad here to free resources.
            ad.dispose();
            log('$ad loaded.');

            setState(() {
              isLoaded = false;
            });
          },
        ),
      )..load();
    } catch (e) {
      setState(() {
        log("erorrrrr*********** $e");
        _bannerAd2 = null;
        isLoaded = false;
      });
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
      loadAd();
    });
  }

  void loadAd() async {
    if (_bannerAd2 == null) {
      log("homepage banner called");
      await loadBannerAd();
    } else {
      log("not loaded");
    }
  }

  void disposeAd() {
    if (_bannerAd2 != null) {
      log("banner ad disposed");
      _bannerAd2!.dispose();
      _bannerAd2 = null;
      isLoaded = false;
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
                            height: mq.height * 0.20,
                            mq: mq,
                            width: mq.width * 0.50,
                          ),
                          featureCard(
                            SmallSize: true,
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
                            height: mq.height * 0.20,
                            mq: mq,
                            width: mq.width * 0.30,
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
                            height: mq.height * 0.20,
                            mq: mq,
                            width: mq.width * 0.30,
                          ),
                          featureCard(
                            SmallSize: false,
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
                            text: "writer".tr,
                            height: mq.height * 0.20,
                            mq: mq,
                            width: mq.width * 0.50,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Obx(() =>
                !InterstitialAdClass.isInterAddLoaded.value &&
                        !AppOpenAdManager.isOpenAdLoaded.value &&
                        isLoaded &&
                        (!Subscriptioncontroller.isMonthlypurchased.value &&
                            !Subscriptioncontroller.isYearlypurchased.value) &&
                        _bannerAd2 != null
                    ? Container(
                        decoration: BoxDecoration(
                            // color: Colors.green,
                            border: Border.all(
                          // color: Colors.deepPurpleAccent,
                          width: 0,
                        )),
                        width: _bannerAd2!.size.width.toDouble(),
                        height: _bannerAd2!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd2!),
                      )
                    : SizedBox())));
  }
}

class featureCard extends StatelessWidget {
  const featureCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.mq,
    required this.SmallSize,
  });
  final mq;
  final height;
  final width;
  final bool SmallSize;
  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: mainClr,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: mainClr)),
          child: SmallSize
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: icon),
                    // SizedBox(height: mq.height * 0.01),
                    Expanded(
                      flex: 0,
                      child: Text(
                        text,
                        style: customTextStyle(
                            fontSize: mq.height * 0.022,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.02),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        text,
                        style: customTextStyle(
                            fontSize: mq.height * 0.022,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    ),
                    SizedBox(width: mq.width * 0.02),
                    Expanded(flex: 2, child: icon),
                  ],
                ),
        ),
      ),
    );
  }
}
