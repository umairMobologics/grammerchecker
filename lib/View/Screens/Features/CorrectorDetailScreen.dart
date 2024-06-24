import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/Controllers/CorrectorController.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
import 'package:grammer_checker_app/utils/sharetext.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';

class CorrectorDetails extends StatefulWidget {
  const CorrectorDetails(
      {super.key, required this.mistaletext, required this.correctedText});
  final String mistaletext;
  final String correctedText;

  @override
  State<CorrectorDetails> createState() => _CorrectorDetailsState();
}

class _CorrectorDetailsState extends State<CorrectorDetails> {
  final ScrollController _scrollController = ScrollController();
  final CorrectorController textController = Get.put(CorrectorController());

  final TTSController ttsController = Get.put(TTSController());
   var ads = Get.put(AdController());
      NativeAd? nativeAd3;
      

  @override
  void initState() {
    super.initState();
    // Listen for changes in isresultLoaded
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
        });
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
      appBar: AppBar(
        title: SvgPicture.asset("assets/appbarTitle.svg",
            height: mq.height * 0.035),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: textController.isresultLoaded.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "corrections".tr,
                                style: customTextStyle(
                                    fontSize: mq.height * 0.028,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(() => textController
                                      .outputText.value.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        shareText(
                                            textController.outputText.value);
                                      },
                                      child: SvgPicture.asset(
                                          "assets/Icons/share.svg"))
                                  : InkWell(
                                      onTap: () {
                                        showToast(context, "Nothing to share");
                                      },
                                      child: SvgPicture.asset(
                                          "assets/Icons/share.svg")))
                            ])),
                    SizedBox(height: mq.height * 0.02),
                    CustomContainerBox(
                      icon: SvgPicture.asset(
                        "assets/Icons/cross.svg",
                        height: mq.height * 0.040,
                      ),
                    

                      style: customTextStyle(fontSize: mq.height * 0.020),
                      text: textController.parseAndStyleText(
                          widget.mistaletext, Colors.red, Colors.black),
                      ttsController: ttsController,
                    ),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    CustomContainerBox(
                      icon: SvgPicture.asset(
                        "assets/Icons/true.svg",
                        height: mq.height * 0.040,
                      ),
                      onCopyPressed: () {  textController.outputText.value.isNotEmpty ?
                       copyToClipboard(context, textController.outputText.value) : log("message");

                      },
                      onSpeakPressed: () {
                        if (widget.correctedText.isNotEmpty) {
                          if (ttsController.isSpeaking.value) {
                            ttsController.pause();
                          } else {
                            ttsController.speak(widget.correctedText);
                          }
                        } else {
                          log("not text");
                        }
                      },
                      style: customTextStyle(fontSize: mq.height * 0.020),
                      text: textController.parseAndStyleText(
                          widget.correctedText, Colors.green, Colors.black),
                      ttsController: ttsController,
                    )
                  ],
                )
              : const SizedBox(),
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

class CustomContainerBox extends StatelessWidget {
  final TextSpan text;
  final Widget icon;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onSpeakPressed;

  final TextStyle style;
  final TTSController ttsController;

  const CustomContainerBox({
    super.key,
    required this.text,
    required this.icon,
    this.onCopyPressed,
    this.onSpeakPressed,
    required this.ttsController,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      shadowColor: mainClr,
      child: Container(
        height: mq.height * 0.35,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: mainClr),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:  SizedBox(
                    height: mq.height * 0.28, // Constrain the height to allow scrolling
                    child: SingleChildScrollView(
                      child: SelectableText.rich(
                        textAlign: TextAlign.justify,
                        style: style,
                         text
                        
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: mq.width * 0.02,
                ),
                icon
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    onSpeakPressed != null
                        ? Obx(
                            () => InkWell(
                              onTap: onSpeakPressed,
                              child: ttsController.isSpeaking.value
                                      ? AvatarGlow(
                                          glowColor: mainClr,
                                          glowRadiusFactor: 0.3,
                                          duration: const Duration(
                                              milliseconds: 2000),
                                          repeat: true,
                                          child: SvgPicture.asset(
                                            "assets/Icons/speak.svg",
                                            height: mq.height * 0.040,
                                          ),
                                        )
                                      : SvgPicture.asset(
                                          "assets/Icons/speak.svg",
                                          height: mq.height * 0.040,
                                        )
                                 
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(width: mq.width * 0.04),
                    onSpeakPressed != null
                        ? Obx(() =>  ttsController.isSpeaking.value
                                ? InkWell(
                                    onTap: () {
                                      ttsController.stop();
                                    },
                                    child: Icon(
                                      Icons.stop,
                                      color: red,
                                      size: mq.height * 0.030,
                                    ))
                                : const SizedBox()
                        )
                        : const SizedBox()
                  ],
                ),
                SizedBox(width: mq.width * 0.01),
                onCopyPressed != null
                    ? InkWell(
                        onTap: onCopyPressed,
                        child: SvgPicture.asset(
                          "assets/Icons/copy.svg",
                          height: mq.height * 0.040,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
