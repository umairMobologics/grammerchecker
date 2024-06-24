import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/Controllers/AskAiCOntroller.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/View/Widgets/CustomButton.dart';
import 'package:grammer_checker_app/View/Widgets/CustomInputContainer.dart';
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
  
 var ads = Get.put(AdController());
      NativeAd? nativeAd3;
      

  @override
  void initState() {
    super.initState();
    // Listen for changes in isresultLoaded
    
    PermissionHandler.requestPermissions();
      WidgetsBinding.instance.addPostFrameCallback((_) {
           if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
          ads.isAdLoaded.value = false;
    nativeAd3 ??= ads.loadNativeAd();

        
        },);
    textController.isresultLoaded.listen((isLoaded) {
      if (isLoaded) {
        // Scroll to the bottom after the first frame is built
        
          WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
         

        
        },);
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
      body: SingleChildScrollView(
        controller: _scrollController  ,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "askai".tr,
                      style: customTextStyle(
                          fontSize: mq.height * 0.028,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                        onTap: () {
                          
                          if (textController.outputText.value.isNotEmpty) {
                                InterstitialAdClass.count += 1;
                  if (InterstitialAdClass.count ==
                      InterstitialAdClass.totalLimit) {
      
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
                                    textStyle: customTextStyle(color: orange),
                                    duration: const Duration(seconds: 3),
                                    textAlign: TextAlign.left),
                                RotateAnimatedText('eg3'.tr,
                                    textStyle: customTextStyle(color: green),
                                    duration: const Duration(seconds: 3),
                                    textAlign: TextAlign.left),
                                RotateAnimatedText('eg4'.tr,
                                    textStyle: customTextStyle(color: black),
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
                                    textStyle: customTextStyle(color: brown),
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
                   if(await Permission.microphone.isGranted)
                    {
                       textController.listen();
                    }
                    else
                    {
                     PermissionHandler.showAlertDialog(context,'Microphone');
                    }
                  },
                  onCopyPressed: () {
                    if (textController.controller.value.text.isNotEmpty) {
                      copyToClipboard(context, textController.controller.value.text);
                    }
                    // Implement copy button functionality here
                    log('Copy icon pressed');
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
                        //  log("${textController.controller.value.text.length}");
                        //    log(textController.controller.value.text);
                             if(textController.controller.value.text.isNotEmpty)
                      {
                          InterstitialAdClass.count += 1;
                  if (InterstitialAdClass.count ==
                      InterstitialAdClass.totalLimit) {
      
                    InterstitialAdClass.showInterstitialAd(context);
                  }
                      }
                              isSelectable.value=false;
                            log("hit");
                            textController.sendQuery(context);
                             showLoadingDialog(context,mq);
                          
                          }
                        : () {},
                    text:  buttontext(mq)),
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
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () =>  !textController.isresultLoaded.value
                    ? ads.isAdLoaded.value && nativeAd3 != null &&  !InterstitialAdClass.isInterAddLoaded.value && !AppOpenAdManager.isOpenAdLoaded.value
            ? SizedBox(
              
               height: 150,
               width: double.infinity,
                child: AdWidget(ad: nativeAd3!))
            : const SizedBox() : const SizedBox()
      )
    );
  }
}
