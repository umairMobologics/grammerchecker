import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  //load ad
  var ads = Get.put(AdController());
  NativeAd? nativeAd3;

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
        ads.isAdLoaded.value = false;
        nativeAd3 ??= ads.loadNativeAd();
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
    nativeAd3?.dispose();
    nativeAd3 = null;
    // ads.isAdLoaded.value = false;
    log(" native ad dispose");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      disposeAd();
      textController.cleardata();
      ttsController.stop();

      _scrollController.dispose(); // Dispose the ScrollController
    });

    super.dispose();
  }

  // BannerAd? _bannerAd2;
  // bool isLoaded = false;

  // loadBannerAd() async {
  //   try {
  //     _bannerAd2 = BannerAd(
  //       adUnitId: AdHelper.bannerAd,
  //       request: const AdRequest(
  //         // Request a collapsible banner ad
  //         nonPersonalizedAds:
  //             true, // Optional: Set to true to disable personalized ads (recommended for EU users)
  //         extras: {
  //           'collapsible': 'bottom', // Place the collapsible ad at the bottom
  //         },
  //       ),
  //       size: AdSize.banner,
  //       listener: BannerAdListener(
  //         // Called when an ad is successfully received.
  //         onAdLoaded: (ad) {
  //           log('$ad loaded.');

  //           setState(() {
  //             isLoaded = true;
  //           });
  //         },
  //         // Called when an ad request failed.
  //         onAdFailedToLoad: (ad, err) {
  //           log('BannerAd failed to load: $err');
  //           // Dispose the ad here to free resources.
  //           ad.dispose();
  //           log('$ad loaded.');

  //           setState(() {
  //             isLoaded = false;
  //           });
  //         },
  //       ),
  //     )..load();
  //   } catch (e) {
  //     setState(() {
  //       log("erorrrrr*********** $e");
  //       _bannerAd2 = null;
  //       isLoaded = false;
  //     });
  //   }
  // }

  // void loadAd() async {
  //   if (_bannerAd2 == null) {
  //     log("homepage banner called");
  //     await loadBannerAd();
  //   } else {
  //     log("not loaded");
  //   }
  // }

  // void disposeBanner() {
  //   if (_bannerAd2 != null) {
  //     log("banner ad disposed");
  //     _bannerAd2!.dispose();
  //     _bannerAd2 = null;
  //     isLoaded = false;
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Listen for changes in isresultLoaded
  //   PermissionHandler.requestPermissions();
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) {
  //       if (InterstitialAdClass.interstitialAd == null) {
  //         InterstitialAdClass.createInterstitialAd();
  //       }
  //       loadAd();
  //     },
  //   );
  //   textController.isresultLoaded.listen((isLoaded) {
  //     if (isLoaded) {
  //       // Scroll to the bottom after the first frame is built
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (_scrollController.hasClients) {
  //           _scrollController.animateTo(
  //             _scrollController.position.maxScrollExtent,
  //             duration: const Duration(milliseconds: 300),
  //             curve: Curves.easeOut,
  //           );
  //         }
  //       });
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     disposeBanner();
  //     textController.cleardata();
  //     ttsController.stop();

  //     _scrollController.dispose(); // Dispose the ScrollController
  //   });

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: white,
        body: SafeArea(
          child: SingleChildScrollView(
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
                          selectedValue: textController.sourceLanguage.value,
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
                          selectedValue: textController.targetLanguage.value,
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
                          PermissionHandler.showAlertDialog(context, 'Camera');
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
                                isSelectable.value = false;
                                log("hit");
                                textController.translateText(
                                  context,
                                  textController.sourceLanguageCode.value,
                                  textController.targetLanguageCode.value,
                                );
                              }
                            : () {};
                      },
                    ),
                  ),
                  SizedBox(height: mq.height * 0.02),
                  Obx(
                    () => CustomButton(
                        mq: mq,
                        ontap: !textController.isloading.value
                            ? () {
                                focusNode.unfocus();

                                if (liveInternet
                                    .checkConnectivityResult.value) {
                                  showNoInternetDialog(context, mq);
                                } else {
                                  if (textController
                                      .controller.value.text.isNotEmpty) {
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

                                    log("hit");
                                    textController.translateText(
                                      context,
                                      textController.sourceLanguageCode.value,
                                      textController.targetLanguageCode.value,
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
                  Obx(() => textController.isresultLoaded.value
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
                      : const SizedBox())
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(() => !textController.isresultLoaded.value
            ? ads.isAdLoaded.value &&
                    nativeAd3 != null &&
                    !InterstitialAdClass.isInterAddLoaded.value &&
                    !AppOpenAdManager.isOpenAdLoaded.value &&
                    (!Subscriptioncontroller.isMonthlypurchased.value &&
                        !Subscriptioncontroller.isYearlypurchased.value)
                ? Container(
                    decoration: BoxDecoration(border: Border.all(color: black)),
                    height: 150,
                    width: double.infinity,
                    child: AdWidget(ad: nativeAd3!))
                : const SizedBox()
            : const SizedBox()));
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
