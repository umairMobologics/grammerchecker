import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/Controllers/TrannslatorController.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/app_lifecycle_reactor.dart';
import 'package:grammer_checker_app/View/Widgets/CustomButton.dart';
import 'package:grammer_checker_app/View/Widgets/CustomInputContainer.dart';
import 'package:grammer_checker_app/View/Widgets/noInternetWidget.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/LoadingDialouge.dart';
import 'package:grammer_checker_app/utils/PickImage_gallery_camera.dart';
import 'package:grammer_checker_app/utils/ShimarEffectAD.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
import 'package:grammer_checker_app/utils/permissiionHandler.dart';
import 'package:grammer_checker_app/utils/sharetext.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TranslatorController textController = Get.put(TranslatorController());
  final TTSController ttsController = Get.put(TTSController());
  final ScrollController _scrollController = ScrollController();
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
            setState(() {
              isLoaded = false;
              bannerAd = null;
            });
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
      setState(() {
        isLoaded = false;
        bannerAd = null;
      });
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

    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
    if (nativeAd3 == null) {
      loadNativeAd();
    }
    if (bannerAd == null) {
      loadAd();
    }
    FirebaseAnalytics.instance.logScreenView(screenName: "Translator Screen");
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
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
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
                              "translator".tr,
                              style: customTextStyle(
                                  fontSize: mq.height * 0.028,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: mq.height * 0.01),
                      Obx(
                        () => Row(
                          children: [
                            CustomDropdown(
                              items: textController.languageCodes.keys
                                  .map<PopupMenuItem<String>>((String key) {
                                return PopupMenuItem<String>(
                                  value: key,
                                  child: Text(key),
                                );
                              }).toList(),
                              selectedValue:
                                  textController.sourceLanguage.value,
                              onChanged: (String? newValue) {
                                textController.sourceLanguage.value = newValue!;
                                // Update the source language code based on the selected language
                                textController.sourceLanguageCode.value =
                                    textController.languageCodes[
                                            textController.sourceLanguage] ??
                                        'en';
                                log(textController.sourceLanguageCode.value);
                              },
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: () {
                                textController.switchLanguages();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: SvgPicture.asset(
                                  "assets/Icons/swap.svg",
                                  height: mq.height * 0.03,
                                  color: mainClr,
                                ),
                              ),
                            ),
                            CustomDropdown(
                              items: textController.languageCodes.keys
                                  .map<PopupMenuItem<String>>((String key) {
                                return PopupMenuItem<String>(
                                  value: key,
                                  child: Text(key),
                                );
                              }).toList(),
                              selectedValue:
                                  textController.targetLanguage.value,
                              onChanged: (String? newValue) {
                                textController.targetLanguage.value = newValue!;
                                // Update the source language code based on the selected language
                                textController.targetLanguageCode.value =
                                    textController.languageCodes[
                                            textController.targetLanguage] ??
                                        'en';
                                log(textController.targetLanguage.value);
                              },
                            ),
                          ],
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
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            textController.speech.stop();
                            textController.isListening.value = false;
                            if (ttsController.isSpeaking.value) {
                              ttsController.pause();
                            }
                            // Implement gallery button functionality here
                            if (!isOperationInProgress.value) {
                              shouldShowOpenAd.value = false;
                              Future<bool> result =
                                  pickImageFromGallery(textController);
                              if (await result) {
                              } else {
                                log("message");
                              }
                            }
                          },
                          onCameraPressed: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            textController.speech.stop();
                            textController.isListening.value = false;
                            if (ttsController.isSpeaking.value) {
                              ttsController.pause();
                            }
                            // Listen for changes in isresultLoaded
                            if (await PermissionHandler.checkPermissions(
                                Permission.camera)) {
                              // Implement gallery button functionality here
                              if (!isOperationInProgress.value) {
                                shouldShowOpenAd.value = false;
                                Future<bool> result =
                                    pickImageFromCamera(textController);
                                if (await result) {}
                                shouldShowOpenAd.value = true;
                              }
                            } else {
                              PermissionHandler.showAlertDialog(
                                  context, 'Camera');
                            }
                          },
                          onMicPressed: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            if (ttsController.isSpeaking.value) {
                              ttsController.pause();
                            }
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
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            textController.speech.stop();
                            textController.isListening.value = false;
                            if (textController
                                .controller.value.text.isNotEmpty) {
                              log("copy length iss : *** ${textController.isCopyLength.value}");
                              if (textController.controller.value.text !=
                                  textController.isCopyLength.value) {
                                copyToClipboard(context,
                                    textController.controller.value.text);
                                textController.isCopyLength.value =
                                    textController.controller.value.text;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('alreadycopy'.tr),
                                  ),
                                );
                              }
                            }
                            // Implement copy button functionality here
                          },
                          onSubmitted: () {},
                        ),
                      ),
                      SizedBox(height: mq.height * 0.02),
                      Obx(
                        () => CustomButton(
                            mq: mq,
                            ontap: !textController.isloading.value
                                ? () {
                                    focusNode.unfocus();
                                    textController.isListening.value = false;
                                    if (liveInternet
                                        .checkConnectivityResult.value) {
                                      showNoInternetDialog(context, mq);
                                    } else {
                                      if (textController
                                          .controller.value.text.isNotEmpty) {
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

                                        log("hit");
                                        textController.translateText(
                                          context,
                                          textController
                                              .sourceLanguageCode.value,
                                          textController
                                              .targetLanguageCode.value,
                                        );
                                        showLoadingDialog(context, mq);
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
                                  textController.speech.stop();
                                  textController.isListening.value = false;
                                  if (textController
                                      .outputText.value.isNotEmpty) {
                                    if (ttsController.isSpeaking.value) {
                                      ttsController.pause();
                                    } else {
                                      ttsController.speak(
                                          textController.outputText.value);
                                    }
                                  } else {
                                    log("not text");
                                  }
                                },
                                onCopy: () {
                                  if (textController
                                          .outputText.value.isNotEmpty &&
                                      textController.isCopyOutput.value) {
                                    copyToClipboard(context,
                                        textController.outputText.value);
                                    textController.isCopyOutput.value = false;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('alreadycopy'.tr),
                                      ),
                                    );
                                  }
                                },
                                onSharePressed: () {
                                  if (ttsController.isSpeaking.value) {
                                    ttsController.pause();
                                  }
                                  if (textController
                                      .outputText.value.isNotEmpty) {
                                    shareText(textController.outputText.value);
                                  }
                                },
                              )
                            : SizedBox(
                                height: mq.height * 0.2,
                              ),
                      ),
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
                        ? (!Subscriptioncontroller.isMonthlypurchased.value &&
                                    !Subscriptioncontroller
                                        .isYearlypurchased.value) &&
                                isAdLoaded &&
                                nativeAd3 != null
                            ? Container(
                                decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(color: black)),
                                height: 150,
                                width: double.infinity,
                                child: AdWidget(ad: nativeAd3!))
                            : (Subscriptioncontroller
                                        .isMonthlypurchased.value ||
                                    Subscriptioncontroller
                                        .isYearlypurchased.value)
                                ? SizedBox()
                                : ShimmarrNativeSmall(mq: mq, height: 135)
                        : const SizedBox()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: StatefulBuilder(builder: (context, setState) {
        log("************* is relsult loaded is : ${textController.isresultLoaded.value}");
        return Obx(() => textController.isresultLoaded.value
            ? isLoaded &&
                    bannerAd != null &&
                    !InterstitialAdClass.isInterAddLoaded.value &&
                    !AppOpenAdManager.isOpenAdLoaded.value &&
                    (!Subscriptioncontroller.isMonthlypurchased.value &&
                        !Subscriptioncontroller.isYearlypurchased.value)
                ? Container(
                    decoration: BoxDecoration(
                        color: white, border: Border.all(color: black)),
                    child: AdWidget(ad: bannerAd!),
                    width: bannerAd!.size.width.toDouble(),
                    height: bannerAd!.size.height.toDouble(),
                    alignment: Alignment.center,
                  )
                : (Subscriptioncontroller.isMonthlypurchased.value ||
                        Subscriptioncontroller.isYearlypurchased.value)
                    ? SizedBox()
                    : ShimmarrEffectBanner(mq: mq, height: 50)
            : SizedBox());
      }),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final List<PopupMenuItem<String>> items;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 2,
        shadowColor: mainClr,
        child: Container(
          height: mq.height * 0.07,
          // padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: mainClr),
          ),
          child: PopupMenuButton<String>(
              color: white,
              itemBuilder: (context) {
                return items;
              },
              onSelected: onChanged,
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    selectedValue,
                    style: customTextStyle(fontSize: mq.height * 0.020),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              )),
        ),
      ),
    );
  }
}
