import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/AskAiCOntroller.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/Controllers/limitedTokens/limitedTokens.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/View/Widgets/CustomButton.dart';
import 'package:grammer_checker_app/View/Widgets/CustomInputContainer.dart';
import 'package:grammer_checker_app/View/Widgets/noInternetWidget.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/LoadingDialouge.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
import 'package:grammer_checker_app/utils/permissiionHandler.dart';
import 'package:grammer_checker_app/utils/sharetext.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class AskAIScreen extends StatefulWidget {
  const AskAIScreen({super.key});

  @override
  _AskAIScreenState createState() => _AskAIScreenState();
}

class _AskAIScreenState extends State<AskAIScreen> {
  final AskAiController textController = Get.put(AskAiController());
  final TTSController ttsController = Get.put(TTSController());
  final ScrollController _scrollController = ScrollController();
  final TokenLimitService askAILimit = TokenLimitService(featureName: 'askai');

// load ad
  NativeAd? nativeAd3;
  bool isAdLoaded = false;
  loadNativeAd() async {
    try {
      nativeAd3 = NativeAd(
        factoryId: "small",
        adUnitId: AdHelper.nativeAd,
        listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: const AdRequest(),
      );

      nativeAd3!.load();
    } catch (e, stackTrace) {
      nativeAd3 = null;
      log('Error loading ad: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }
  // var ads = Get.put(AdController());
  // NativeAd? nativeAd3;

  // void loadNative() async {
  //   if (nativeAd3 == null) {
  //     nativeAd3 ??= await loadNativeAd();
  //   }
  // }

  //load ad
  BannerAd? bannerAd;
  bool isLoaded = false;

  /// Loads a banner ad.
  void loadAd() {
    try {
      bannerAd = BannerAd(
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
            debugPrint('BannerAd failed to load: $err');
            // Dispose the ad here to free resources.
            ad.dispose();
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) {},
        ),
      )..load();
    } catch (e, stackTrace) {
      bannerAd = null;
      log('Error loading ad: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  void disposeBannerAd() {
    if (bannerAd != null) {
      bannerAd!.dispose();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    if (bannerAd == null) {
      loadAd();
    }
    FirebaseAnalytics.instance.logScreenView(screenName: "Ask AI Screen");
  }

  @override
  void initState() {
    super.initState();
    // Listen for changes in isresultLoaded

    PermissionHandler.requestPermissions();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (InterstitialAdClass.interstitialAd == null) {
        InterstitialAdClass.createInterstitialAd();
      }
      if (nativeAd3 == null) {
        loadNativeAd();
      }
    });
    textController.isresultLoaded.listen((isLoaded) {
      if (isLoaded) {
        // Scroll to the bottom after the first frame is built

        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
        );
      }
    });
  }

  void disposeAd() {
    if (nativeAd3 != null) {
      nativeAd3?.dispose();
      nativeAd3 = null;
      // ads.isAdLoaded.value = false;
      log(" native ad dispose ghfhgfg");
    }
  }

  @override
  void dispose() {
    disposeAd();
    disposeBannerAd();
    textController.cleardata();
    ttsController.stop();

    _scrollController.dispose(); // Dispose the ScrollController

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "askai".tr,
                            style: customTextStyle(
                                fontSize: mq.height * 0.028,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (textController.outputText.value.isNotEmpty) {
                                InterstitialAdClass.count += 1;
                                if (InterstitialAdClass.count ==
                                        InterstitialAdClass.totalLimit &&
                                    (!Subscriptioncontroller
                                            .isMonthlypurchased.value &&
                                        !Subscriptioncontroller
                                            .isYearlypurchased.value)) {
                                  InterstitialAdClass.showInterstitialAd(
                                      context);
                                }
                                shareText(textController.outputText.value);
                              } else {
                                showToast(context, "Nothing to share");
                              }
                            },
                            child: SvgPicture.asset("assets/Icons/share.svg"))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  SizedBox(
                    height: mq.height * 0.1,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 2,
                      shadowColor: mainClr,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        width: mq.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: mainClr)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "hint".tr,
                              style: customTextStyle(
                                  fontSize: mq.height * 0.020, color: green),
                            ),
                            // const Icon(
                            //   CupertinoIcons.info_circle_fill,
                            //   color: orange,
                            // ),
                            DefaultTextStyle(
                              style: TextStyle(
                                fontSize: mq.height * 0.022,
                                fontFamily: 'Horizon',
                                color: black,
                              ),
                              child: Expanded(
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    RotateAnimatedText('eg2'.tr,
                                        textStyle:
                                            customTextStyle(color: orange),
                                        duration: const Duration(seconds: 3),
                                        textAlign: TextAlign.left),
                                    RotateAnimatedText('eg3'.tr,
                                        textStyle:
                                            customTextStyle(color: green),
                                        duration: const Duration(seconds: 3),
                                        textAlign: TextAlign.left),
                                    RotateAnimatedText('eg4'.tr,
                                        textStyle:
                                            customTextStyle(color: black),
                                        duration: const Duration(seconds: 3),
                                        textAlign: TextAlign.left),
                                    RotateAnimatedText('eg5'.tr,
                                        textStyle:
                                            customTextStyle(color: deepPurple),
                                        duration: const Duration(seconds: 3),
                                        textAlign: TextAlign.left),
                                    RotateAnimatedText('eg6'.tr,
                                        textStyle: customTextStyle(color: cyan),
                                        duration: const Duration(seconds: 3),
                                        textAlign: TextAlign.left),
                                    RotateAnimatedText('eg7'.tr,
                                        textStyle:
                                            customTextStyle(color: brown),
                                        duration: const Duration(seconds: 3),
                                        textAlign: TextAlign.left),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.01,
                  ),
                  Obx(
                    () => CustomInputContainer(
                      hintText: textController.isListening.value
                          ? "listining".tr
                          : "typehere".tr,
                      textController: textController,
                      onMicPressed: () async {
                        if (await Permission.microphone.isGranted) {
                          textController.listen();
                        } else {
                          PermissionHandler.showAlertDialog(
                              context, 'Microphone');
                        }
                      },
                      onCopyPressed: () {
                        if (textController.controller.value.text.isNotEmpty) {
                          copyToClipboard(
                              context, textController.controller.value.text);
                        }
                        // Implement copy button functionality here
                        log('Copy icon pressed');
                      },
                      onSubmitted: () {
                        !textController.isloading.value
                            ? () {
                                log("hit");
                                textController.sendQuery(context, askAILimit);
                              }
                            : () {};
                      },
                    ),
                  ),
                  Obx(() => !Subscriptioncontroller.isMonthlypurchased.value &&
                          !Subscriptioncontroller.isYearlypurchased.value
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          margin: EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  "${askAILimit.usageCount.value} ",
                                  style: customTextStyle(
                                      fontSize: mq.height * 0.020),
                                ),
                                Text(
                                  "freeLimitText".tr,
                                  style: customTextStyle(
                                      fontSize: mq.height * 0.020),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                        () => PremiumScreen(isSplash: false));
                                  },
                                  child: Text(
                                    "goPremium".tr,
                                    style: customTextStyle(
                                        fontSize: mq.height * 0.020,
                                        fontWeight: FontWeight.bold,
                                        color: red),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox()),
                  SizedBox(height: mq.height * 0.01),
                  Obx(
                    () => CustomButton(
                        mq: mq,
                        ontap: !textController.isloading.value
                            ? () async {
                                focusNode.unfocus();

                                if (liveInternet
                                    .checkConnectivityResult.value) {
                                  showNoInternetDialog(context, mq);
                                } else {
                                  //  log("${textController.controller.value.text.length}");
                                  //    log(textController.controller.value.text);
                                  if (textController
                                      .controller.value.text.isNotEmpty) {
                                    //check weather to use token or not

                                    if (askAILimit.canUseFeature()) {
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

                                      isSelectable.value = false;
                                      log("hit");
                                      textController.sendQuery(
                                          context, askAILimit);
                                      if (textController
                                          .controller.value.text.isNotEmpty) {
                                        showLoadingDialog(context, mq);
                                      }

                                      // Proceed with using the "Ask AI" feature
                                    } else {
                                      log("false! buy premium");
                                      askAILimit
                                          .navigateToPremiumScreen(context);
                                    }
                                  } else {
                                    showToast(context, 'empty'.tr);
                                  }
                                }
                              }
                            : () {},
                        text: buttontext(mq)),
                  ),
                  SizedBox(height: mq.height * 0.02),
                  Obx(
                    () => textController.isresultLoaded.value
                        ? CustomOutputContainer(
                            textController: textController,
                            ttsController: ttsController,
                            onSpeak: () {
                              if (textController.outputText.value.isNotEmpty) {
                                if (ttsController.isSpeaking.value) {
                                  ttsController.pause();
                                } else {
                                  ttsController
                                      .speak(textController.outputText.value);
                                }
                              } else {
                                log("not text");
                              }
                            },
                            onCopy: () {
                              if (textController.outputText.value.isNotEmpty) {
                                Clipboard.setData(ClipboardData(
                                    text: textController.outputText.value));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('copy'.tr),
                                  ),
                                );
                              }
                            },
                          )
                        : SizedBox(
                            height: mq.height * 0.2,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 10,
                  color: white,
                ),
                Obx(() => !textController.isresultLoaded.value
                    ? isAdLoaded &&
                            nativeAd3 != null &&
                            !InterstitialAdClass.isInterAddLoaded.value &&
                            !AppOpenAdManager.isOpenAdLoaded.value &&
                            (!Subscriptioncontroller.isMonthlypurchased.value &&
                                !Subscriptioncontroller.isYearlypurchased.value)
                        ? Container(
                            decoration: BoxDecoration(
                                color: white, border: Border.all(color: black)),
                            height: 150,
                            width: double.infinity,
                            child: AdWidget(ad: nativeAd3!))
                        : const SizedBox()
                    : const SizedBox()),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: StatefulBuilder(builder: (context, setState) {
        log("************* is relsult loaded is : ${textController.isresultLoaded.value}");
        return Obx(() => textController.isresultLoaded.value &&
                isLoaded &&
                bannerAd != null &&
                !InterstitialAdClass.isInterAddLoaded.value &&
                !AppOpenAdManager.isOpenAdLoaded.value &&
                (!Subscriptioncontroller.isMonthlypurchased.value &&
                    !Subscriptioncontroller.isYearlypurchased.value)
            ? Container(
                child: AdWidget(ad: bannerAd!),
                width: bannerAd!.size.width.toDouble(),
                height: bannerAd!.size.height.toDouble(),
                alignment: Alignment.center,
              )
            : SizedBox());
      }),
    );
  }
}
