import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/ChatScreen/ChatScreen.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FromPAgeView.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/ShimarMessageLoading.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/tutorAnimation.dart';
import 'package:grammar_checker_app_updated/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammar_checker_app_updated/core/databaseHelper/LocalDatabase.dart';
import 'package:grammar_checker_app_updated/core/model/TutorModels/tutorModel.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

import '../../../Controllers/InAppPurchases/isPremiumCheck.dart';
import '../../../core/Helper/AdsHelper/AdHelper.dart';
import '../../../core/Helper/AdsHelper/AppOpenAdManager.dart';
import '../../../core/utils/ShimarEffectAD.dart';
import '../../../main.dart';

class TutorList extends StatefulWidget {
  final bool isbottom;
  TutorList({super.key, required this.isbottom});

  @override
  _TutorListState createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  late Stream<List<TutorModel>> tutorStream;

  List<TutorModel> tutors = [];
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
    disposeAd();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tutorStream = DatabaseHelper().tutorsStream();
    if (nativeAd3 == null && ispremium()) {
      loadNativeAd();
    }
    FirebaseAnalytics.instance.logScreenView(screenName: "Tutor List Screen");
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: widget.isbottom
            ? null
            : InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: white,
                ),
              ),
        backgroundColor: mainClr,
        title: const Text(
          "Your Tutors",
          style: TextStyle(
              fontSize: 30, color: white, fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              Get.to(() => PremiumScreen(isSplash: false));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white54)),
              child: const Row(
                children: [
                  Text(
                    "👑",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "PRO",
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<TutorModel>>(
              stream: tutorStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: ShimmerMessageList());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                    "Something went wrong, try again",
                    style: TextStyle(color: black),
                  ));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              Get.to(() => TutorList(
                                    isbottom: false,
                                  ));
                            },
                            child: tutorAnimationImage(
                              height: mq.height * 0.2,
                            )),
                        SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          "Create your own AI customized tutors",
                          style: TextStyle(color: black),
                        ),
                      ],
                    )),
                  );
                } else {
                  tutors = snapshot.data!.reversed.toList();
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 5),
                    physics: const ClampingScrollPhysics(),
                    itemCount: tutors.length,
                    itemBuilder: (context, index) {
                      final oneTutor = tutors[index];
                      return MessageCard(mq: mq, index: index, tutor: oneTutor);
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Get.off(() => CreateAiTutorForm());
              },
              child: Container(
                width: double.infinity,
                child: CustomButton(
                  text: "Create New Tutor",
                  color: white,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => ispremium() &&
              !InterstitialAdClass.isInterAddLoaded.value &&
              !AppOpenAdManager.isOpenAdLoaded.value &&
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
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.mq,
    required this.index,
    required this.tutor,
  });

  final Size mq;
  final int index;
  final TutorModel tutor; // Girlfriend data passed here

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      child: Column(
        children: [
          InkWell(
            // highlightColor: grey,
            onTap: () {
              // context.read<ChatProvider>().messageCount = 0;
              Get.to(() => Chatscreen(
                    index: index,
                    isFirstTime: false,
                    tutor: tutor,
                  ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              height: mq.height * 0.1,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left section: Profile image and text
                  Row(
                    children: [
                      // Profile image
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: tutor.customAvatar != null
                                ? FileImage(File(tutor.customAvatar!))
                                : AssetImage(tutor.tutorAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: mq.width * 0.02),
                      // Column with the name and status message
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Girlfriend's name with ellipsis if text is too long
                          SizedBox(
                            width: mq.width * 0.3, // Adjust width as needed
                            child: Text(
                              tutor.tutorName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.h,
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Status message with ellipsis if text is too long
                          SizedBox(
                            width: mq.width * 0.55, // Adjust width as needed

                            child: Text(
                              "Tap to chat with your tutor ${tutor.learningPurposes.toList().join(", ")}",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13.h),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // The green dot at the right side
                  Icon(
                    Icons.arrow_forward_ios,
                    color: mainClr,
                    size: 20,
                  ),
                  // const Text(
                  //   ".",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     color: Colors.green,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
