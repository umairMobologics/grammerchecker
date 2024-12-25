import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammar_checker_app_updated/Controllers/CourseController/CourseController.dart';
import 'package:grammar_checker_app_updated/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammar_checker_app_updated/core/model/CourseModel.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/main.dart';

import '../../../Controllers/InAppPurchases/isPremiumCheck.dart';
import '../../../core/utils/ShimarEffectAD.dart';

class GrammarScreen extends StatefulWidget {
  final String level;
  const GrammarScreen({super.key, required this.level});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  final GrammarController controller = Get.put(GrammarController());
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (nativeAd3 == null && ispremium()) {
      loadNativeAd();
    }
    controller.fetchGrammarData(widget.level);
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
    // TODO: implement dispose
    super.dispose();
    disposeAd();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Grammar Learning"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.grammarData.value == null) {
          return Center(child: Text('No data available'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    // allowImplicitScrolling: false,
                    // pageSnapping: false,
                    // reverse: false,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disables page snapping
                    controller: controller.pageController,
                    itemCount: controller.grammarData.value!.modules.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildTitlePage(controller.grammarData.value!);
                      } else {
                        var module =
                            controller.grammarData.value!.modules[index - 1];
                        return _buildModulePage(module);
                      }
                    },
                    onPageChanged: (index) {
                      controller.currentPageIndex.value = index;
                    },
                  ),
                ),
                _buildNavigationButtons(controller),
              ],
            ),
          );
        }
      }),
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

  Widget _buildTitlePage(GrammarLevel introduction) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chapter: ${introduction.title}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "${introduction.comprehensiveExplanation}",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            "Importance",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "${introduction.importance}",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildModulePage(Module module) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${module.moduleTitle}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            "${module.lessonContent.explanation}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          for (var example in module.lessonContent.examples) ...[
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: grey.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "Example: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${example.sentence}")
                    ]),
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "Explanation: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${example.explanation}")
                    ]),
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(GrammarController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (controller.currentPageIndex.value > 0) {
                controller.goToPreviousPage();
              }
            },
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: controller.currentPageIndex.value > 0
                      ? mainClr
                      : grey.withOpacity(0.6)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    'Previous',
                    style: TextStyle(fontSize: 18, color: white),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              InterstitialAdClass.count += 1;
              if (InterstitialAdClass.count >= InterstitialAdClass.totalLimit &&
                  InterstitialAdClass.interstitialAd != null &&
                  ispremium()) {
                InterstitialAdClass.showInterstitialAd(context);
              }
              if (controller.currentPageIndex.value <
                  controller.grammarData.value!.modules.length) {
                controller.goToNextPage();
              } else {
                Get.back();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: controller.currentPageIndex.value <
                          controller.grammarData.value!.modules.length
                      ? mainClr
                      : green.withOpacity(0.9)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    controller.currentPageIndex.value <
                            controller.grammarData.value!.modules.length
                        ? 'Next'
                        : 'Done',
                    style: TextStyle(fontSize: 18, color: white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
