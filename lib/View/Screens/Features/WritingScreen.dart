import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/Controllers/WritingController.dart';
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

class WritingAssistentScreen extends StatefulWidget {
  const WritingAssistentScreen({super.key});

  @override
  _WritingAssistentScreenState createState() => _WritingAssistentScreenState();
}

class _WritingAssistentScreenState extends State<WritingAssistentScreen> {
  final WritingController textController = Get.put(WritingController());
  final TTSController ttsController = Get.put(TTSController());
  final ScrollController _scrollController = ScrollController();
  var ads = Get.put(AdController());
  NativeAd? nativeAd3;

  void loadNative() async {
    ads.isAdLoaded.value = false;
    if (nativeAd3 == null) {
      nativeAd3 ??= await ads.loadNativeAd();
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
        loadNative();
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

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "writingAss".tr,
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
                                InterstitialAdClass.showInterstitialAd(context);
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
                        if (await result) {}
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
                        copyToClipboard(
                            context, textController.controller.value.text);
                      }
                      // Implement copy button functionality here
                    },
                    onSubmitted: () {
                      !textController.isloading.value
                          ? () {
                              log("hit");
                              textController.sendQuery(context);
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

                              if (liveInternet.checkConnectivityResult.value) {
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

                                  isSelectable.value = false;
                                  log("hit");
                                  textController.sendQuery(context);

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
                            if (textController.outputText.value.isNotEmpty) {
                              if (ttsController.isSpeaking.value) {
                                ttsController.pause();
                              } else {
                                ttsController
                                    .speak(textController.outputText.value);
                              }
                            } else {}
                          },
                          onCopy: () {
                            if (textController.outputText.value.isNotEmpty) {
                              copyToClipboard(
                                  context, textController.outputText.value);
                            }
                          },
                        )
                      : const SizedBox(),
                ),
              ]),
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
    // bottomNavigationBar: Obx(() => !textController.isresultLoaded.value
    //     ? !InterstitialAdClass.isInterAddLoaded.value &&
    //             !AppOpenAdManager.isOpenAdLoaded.value &&
    //             isLoaded &&
    //             _bannerAd2 != null
    //         ? Container(
    //             decoration: BoxDecoration(
    //                 // color: Colors.green,
    //                 border: Border.all(
    //               // color: Colors.deepPurpleAccent,
    //               width: 0,
    //             )),
    //             width: _bannerAd2!.size.width.toDouble(),
    //             height: _bannerAd2!.size.height.toDouble(),
    //             child: AdWidget(ad: _bannerAd2!),
    //           )
    //         : SizedBox()
    //     : const SizedBox()));
  }
}
