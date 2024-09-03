import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/CorrectorController.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/Controllers/limitedTokens/limitedTokens.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/app_lifecycle_reactor.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/View/Widgets/CorrecterOutputBox.dart';
import 'package:grammer_checker_app/View/Widgets/CustomButton.dart';
import 'package:grammer_checker_app/View/Widgets/CustomInputContainer.dart';
import 'package:grammer_checker_app/View/Widgets/noInternetWidget.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/LoadingDialouge.dart';
import 'package:grammer_checker_app/utils/PickImage_gallery_camera.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
import 'package:grammer_checker_app/utils/permissiionHandler.dart';
import 'package:grammer_checker_app/utils/sharetext.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class CorrectorScreen extends StatefulWidget {
  const CorrectorScreen({super.key});

  @override
  _CorrectorScreenState createState() => _CorrectorScreenState();
}

class _CorrectorScreenState extends State<CorrectorScreen> {
  final CorrectorController textController = Get.put(CorrectorController());

  final TTSController ttsController = Get.put(TTSController());
  final ScrollController _scrollController = ScrollController();
  final TokenLimitService askAILimit =
      TokenLimitService(featureName: 'corrector');
  // var ads = Get.put(AdController());
  // NativeAd? nativeAd3;

  // void loadNative() async {
  //   ads.isAdLoaded.value = false;
  //   if (nativeAd3 == null) {
  //     nativeAd3 ??= await ads.loadNativeAd();
  //   }
  // }
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
              // isAdLoaded = true;
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
            // isLoaded = true;
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
  void initState() {
    super.initState();
    // Listen for changes in isresultLoaded

    PermissionHandler.requestPermissions();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (InterstitialAdClass.interstitialAd == null) {
          InterstitialAdClass.createInterstitialAd();
        }
        if (nativeAd3 == null) {
          loadNativeAd();
        }
      },
    );
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
      log(" native ad dispose");
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // add setCurrentScreeninstead of initState because might not always give you the
    // expected results because initState() is called before the widget
    // is fully initialized, so the screen might not be visible yet.
    if (bannerAd == null) {
      loadAd();
    }
    FirebaseAnalytics.instance.logScreenView(screenName: "Corrector Screen");
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "heading".tr,
                            style: customTextStyle(
                                fontSize: mq.height * 0.028,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: () {
                                if (textController
                                    .outputText.value.isNotEmpty) {
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
                      height: mq.height * 0.042,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          displayFullTextOnTap: true,
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText("headingdes".tr,
                                textStyle: customTextStyle(
                                  fontSize: mq.height * 0.018,
                                ),
                                speed: const Duration(milliseconds: 50)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.02),
                    Obx(
                      () => CustomInputContainer(
                        hintText: textController.isListening.value
                            ? "listining".tr
                            : "typehere".tr,
                        textController: textController,
                        onGalleryPressed: () async {
                          // Implement gallery button functionality here
                          if (!isOperationInProgress.value) {
                            shouldShowOpenAd.value = false;
                            Future<bool> result =
                                pickImageFromGallery(textController);
                            if (await result) {
                            } else {
                              log("message");
                            }
                            shouldShowOpenAd.value = true;
                          }
                        },
                        onCameraPressed: () async {
                          // Listen for changes in isresultLoaded
                          if (await PermissionHandler.checkPermissions(
                              Permission.camera)) {
                            // Implement gallery button functionality here
                            if (!isOperationInProgress.value) {
                              shouldShowOpenAd.value = false;
                              Future<bool> result =
                                  pickImageFromCamera(textController);
                              if (await result) {
                              } else {
                                log("message");
                              }
                              shouldShowOpenAd.value = true;
                            }
                          } else {
                            PermissionHandler.showAlertDialog(
                                context, 'Camera');
                          }
                        },
                        onMicPressed: () async {
                          // Listen for changes in isresultLoaded
                          if (await PermissionHandler.checkPermissions(
                              Permission.microphone)) {
                            textController.listen();
                          } else {
                            PermissionHandler.showAlertDialog(
                                context, 'Microphone');
                          }
                        },
                        onCopyPressed: () {
                          if (textController.controller.value.text.isNotEmpty) {
                            Clipboard.setData(ClipboardData(
                                text: textController.controller.value.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('copy'.tr),
                              ),
                            );
                          }
                          // Implement copy button functionality here
                          log('Copy icon pressed');
                        },
                        onSubmitted: () {
                          !textController.isloading.value
                              ? () {
                                  log("hit");
                                  textController.sendQuery2(
                                      context, askAILimit);
                                }
                              : () {};
                        },
                      ),
                    ),
                    Obx(() => !Subscriptioncontroller
                                .isMonthlypurchased.value &&
                            !Subscriptioncontroller.isYearlypurchased.value
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
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
                                    if (textController
                                        .controller.value.text.isNotEmpty) {
                                      //check weather to use token or not

                                      if (askAILimit.canUseFeature()) {
                                        if (InterstitialAdClass
                                                    .interstitialAd !=
                                                null &&
                                            (!Subscriptioncontroller
                                                    .isMonthlypurchased.value &&
                                                !Subscriptioncontroller
                                                    .isYearlypurchased.value)) {
                                          InterstitialAdClass
                                              .showInterstitialAd(context);
                                          InterstitialAdClass.count = 0;
                                        }

                                        isSelectable.value = false;
                                        log("hit");
                                        textController.sendQuery2(
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
                    Obx(() => textController.isresultLoaded.value
                        ? CorrecterContainerBox(
                            icon: SvgPicture.asset(
                              "assets/Icons/true.svg",
                              height: mq.height * 0.040,
                            ),
                            onCopyPressed: () {
                              textController.outputText.value.isNotEmpty
                                  ? copyToClipboard(
                                      context, textController.filterText.value)
                                  : log("message");
                            },
                            onSpeakPressed: () {
                              if (textController.outputText.isNotEmpty) {
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
                            style: customTextStyle(fontSize: mq.height * 0.020),
                            originalText: textController.controller.value.text,
                            outputText: textController.filterText.value,
                            ttsController: ttsController,
                          )
                        : SizedBox()),
                    SizedBox(height: mq.height * 0.02),
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
                              (!Subscriptioncontroller
                                      .isMonthlypurchased.value &&
                                  !Subscriptioncontroller
                                      .isYearlypurchased.value)
                          ? Container(
                              decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(color: black)),
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
      // bottomNavigationBar: Obx(() => textController.isresultLoaded.value
      //     ? isLoaded &&
      //             bannerAd != null &&
      //             !InterstitialAdClass.isInterAddLoaded.value &&
      //             !AppOpenAdManager.isOpenAdLoaded.value &&
      //         (!Subscriptioncontroller.isMonthlypurchased.value &&
      //             !Subscriptioncontroller.isYearlypurchased.value)
      //     ? Container(
      //         decoration: BoxDecoration(
      //             // color: Colors.green,
      //             border: Border.all(
      //           color: Colors.black,
      //           width: 0,
      //         )),
      //         width: bannerAd!.size.width.toDouble(),
      //         height: bannerAd!.size.height.toDouble(),
      //         child: AdWidget(ad: bannerAd!),
      //       )
      //     : const SizedBox()
      // : const SizedBox()),
    );
  }
}
