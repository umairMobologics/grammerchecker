
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/AdsHelper/app_lifecycle_reactor.dart';
import 'package:grammer_checker_app/Controllers/CorrectorController.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/View/Widgets/CustomButton.dart';
import 'package:grammer_checker_app/View/Widgets/CustomInputContainer.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/LoadingDialouge.dart';
import 'package:grammer_checker_app/utils/PickImage_gallery_camera.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
import 'package:grammer_checker_app/utils/permissiionHandler.dart';
import 'package:permission_handler/permission_handler.dart';

class CorrectorScreen extends StatefulWidget {
  const CorrectorScreen({super.key});

  @override
  _CorrectorScreenState createState() => _CorrectorScreenState();
}

class _CorrectorScreenState extends State<CorrectorScreen> {
  final CorrectorController textController =
      Get.put(CorrectorController());
     
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
                        "heading".tr,
                        style: customTextStyle(
                            fontSize: mq.height * 0.028,
                             fontWeight: FontWeight.bold
                            ),
                      ),
                    
                    ],
                  ),
                ),
                  SizedBox(
                    height: mq.height*0.042,
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                     AnimatedTextKit(
                              
                                repeatForever: true,
                                displayFullTextOnTap: true,
                                isRepeatingAnimation: false,
                    
                    
                          animatedTexts: [
                            TyperAnimatedText(   "headingdes".tr,
                      textStyle: customTextStyle(
                          fontSize: mq.height * 0.018,
                          ), speed: const Duration(milliseconds: 50)),
                           
                          ],
                              ),
                    
                                    ),
                  ),
              
          SizedBox(height: mq.height * 0.02),
                Obx(
                  ()=> CustomInputContainer(
                    hintText:  textController.isListening.value ? "listining".tr :  "typehere".tr,
                    textController: textController,
                     onGalleryPressed: () async {
                    // Implement gallery button functionality here
                    if (!isOperationInProgress.value) {
                       shouldShowOpenAd.value = false;
                     Future<bool> result = pickImageFromGallery(textController);
                     if( await result)
                     {
   
                    if (InterstitialAdClass.interstitialAd != null) {
                      InterstitialAdClass.showInterstitialAd(context);
                      InterstitialAdClass.count = 0;
                    }
                   
                     
                     }
                      else{
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
                   Future<bool> result =   pickImageFromCamera(textController);
                   if(await result)
                   {
                     if (InterstitialAdClass.interstitialAd != null) {
                      InterstitialAdClass.showInterstitialAd(context);
                      InterstitialAdClass.count = 0;
                    }
                    

                   }
                    else{
                      log("message");
                    }
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
                      PermissionHandler.showAlertDialog(context, 'Microphone');
                    }
                  },
                    onCopyPressed: () {
                       if(textController.controller.value.text.isNotEmpty)
                   {
                       Clipboard.setData(ClipboardData(text: textController.controller.value.text));
                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:Text('copy'.tr),
                                        ),
                                      );
                   }
                      // Implement copy button functionality here
                      log('Copy icon pressed');
                    },

                  onSubmitted: () {
                    !textController.isloading.value ? () {
                        log("hit");
                        textController.sendQuery(context);
                      } : (){};
                  },  
                  ),
                ),
                 SizedBox(height: mq.height * 0.02),
                 Obx(
                  () => CustomButton(
                      mq: mq,
                      ontap: !textController.isloading.value ? () {
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
                      } : (){},
                      text: buttontext(mq)),
                ),
                 SizedBox(height: mq.height * 0.02),
              
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar: Obx(
        () => ads.isAdLoaded.value && nativeAd3 != null &&  !InterstitialAdClass.isInterAddLoaded.value && !AppOpenAdManager.isOpenAdLoaded.value
            ? SizedBox(
              
               height: 150,
               width: double.infinity,
                child: AdWidget(ad: nativeAd3!))
            : const SizedBox(),
      )
    );
  }
}
