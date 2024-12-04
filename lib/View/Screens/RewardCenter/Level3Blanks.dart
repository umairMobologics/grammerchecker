import 'dart:async';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/Widgets/tootlTip.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/utils/isIntroCheck.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/rewardedAdHelper.dart';
import 'package:grammer_checker_app/core/utils/ShimarEffectAD.dart';

import '../../../Controllers/RewardCenterControllers/RewardQuizController.dart';
import '../../../core/Helper/AdsHelper/AdHelper.dart';
import '../../../core/Helper/AdsHelper/AppOpenAdManager.dart';
import '../../../core/model/RewardCenterModels/level3RewardModel.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/customTextStyle.dart';
import '../../../core/utils/snackbar.dart';
import '../../../main.dart';
import 'Widgets/ResultScreenWidget.dart';
import 'utils/Dialouges/ProfetureDialouge.dart';
import 'utils/Dialouges/levelIntroDialouges.dart';

class Level3BlanksScreen extends StatefulWidget {
  @override
  State<Level3BlanksScreen> createState() => _Level3BlanksScreenState();
}

class _Level3BlanksScreenState extends State<Level3BlanksScreen> {
  final RewardQuizController controller = Get.put(RewardQuizController());

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
    super.initState();

    // ads.isAdLoaded.value = false;
    // nativeAd3 ??= ads.loadNativeAd();
    if (nativeAd3 == null) {
      loadNativeAd();
    }
    RewardedAdHelper.attemptFailed = 0;
    RewardedAdHelper.loadRewardedAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LevelIntroDialog.showLevel3Dialouge(
        context,
        () {
          Navigator.pop(context);
          checkIntro();
        },
      );
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

  void checkIntro() async {
    bool _hasSeenIntro = await checkIfIntroShown("level3IntroCheck");
    log("intro value is $_hasSeenIntro");
    if (_hasSeenIntro) {
      Intro.of(context).start(
        reset: false,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeAd();
    RewardedAdHelper.rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.level3Question.isEmpty) {
        controller.fetchLevel3Questions(controller.level3category);
      }
    });
    List<String> options = [];
    var mq = MediaQuery.sizeOf(context);
    Intro intro = Intro.of(context);
    return ValueListenableBuilder(
      valueListenable: intro.statusNotifier,
      builder: (context, value, child) => PopScope(
        canPop: !value.isOpen,
        onPopInvoked: (didPop) {
          if (!didPop) {
            intro.dispose();
          }
        },
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            title: Text(controller.isQuizCompleted.value
                ? "Reward Completed"
                : "Reward Quiz"),
            actions: [
              Obx(() => !controller.isQuizCompleted.value
                  ? SlideInUp(
                      child: Image.asset(
                        "assets/RewardCenter/boyEmoji.png",
                        height: mq.height * 0.1,
                      ),
                    )
                  : SizedBox()),
              SizedBox(width: mq.width * 0.04),
              Obx(
                () => controller.currentPageIndex.value == 1
                    ? InkWell(
                        onTap: () {
                          Intro.of(context).start(
                            reset: true,
                          );
                        },
                        child: const Icon(Icons.info),
                      )
                    : SizedBox(),
              )
            ],
          ),
          body: Obx(() {
            // Show loading indicator if the data is being fetched
            if (controller.isLoading.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerEffectReward(
                        height: mq.height * 0.03,
                        width: mq.width * 0.6,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10.0, // Horizontal spacing
                        runSpacing: 10.0, // Vertical spacing
                        children: List.generate(5, (index) {
                          return ShimmerEffectReward(
                            height: 50.0,
                            width: 100.0,
                            borderRadius: BorderRadius.circular(60.0),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      ShimmerEffectReward(
                        height: 80.0,
                        width: mq.width * 0.9,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      Spacer(),
                      ShimmerEffectReward(
                        height: 50.0,
                        width: mq.width * 0.9,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (controller.isQuizCompleted.value) {
              return ResultScreen(
                height: mq.height,
                width: mq.width,
                controller: controller,
                quizLenght: controller.level3Question.length,
                level: "level3",
              );
            }

            // If no questions are available, show an empty state message
            if (controller.level3Question.isEmpty) {
              return Center(child: Text("No questions availablesda."));
            }
            // ElevatedButton(
            //     onPressed: () {
            //       Level3RewardService.saveQuestionsToFirestore(
            //           Level3RewardQuestions, controller.level3category);
            //     },
            //     child: Text("add data"))
            return PageView.builder(
              controller: controller.pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Disables page snapping
              itemCount: controller.level3Question.length,
              itemBuilder: (context, index) {
                Level3RewardModel question = controller.level3Question[index];
                log("${controller.level3Question.length}");
                if (controller.tempWords.isEmpty) {
                  options = question.options
                      .split('/')
                      .where((word) => word.isNotEmpty)
                      .toList();
                  controller.WordLength.value = options.length;

                  log("Options are  ${options}");
                  controller.tempWords.value = options;
                } else {
                  print("****************** refresh again");
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideInDown(
                          child: Text(
                            '${index + 1}/${controller.level3Question.length}: Fill in the blanks and make correct sentence.',
                            style: TextStyle(
                              fontSize: mq.height * 0.020,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        // Display the shuffled question
                        // Display the shuffled question
                        Obx(() => controller.tempWords.isNotEmpty
                            ? FlipInX(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: index == 0
                                      ? IntroStepBuilder(
                                          order: 1,
                                          text:
                                              'Read the question carefully and try to figure out the answer.',
                                          builder: (context, key) => Text(
                                            key: key,
                                            "Question:  ${question.question}",
                                            style: TextStyle(
                                                fontSize: mq.height * 0.020,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Text(
                                          "Question:  ${question.question}",
                                          style: TextStyle(
                                              fontSize: mq.height * 0.020,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              )
                            : SizedBox()),

                        Obx(() => controller.tempWords.isNotEmpty
                            ? FlipInX(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: index == 0
                                      ? IntroStepBuilder(
                                          order: 2,
                                          text: 'Choose your option wisely.\n'
                                              'You can also change option anytime before submitting.',
                                          builder: (context, key) => Text(
                                            key: key,
                                            "Options:",
                                            style: TextStyle(
                                                fontSize: mq.height * 0.020,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Text(
                                          "Options:",
                                          style: TextStyle(
                                              fontSize: mq.height * 0.020,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              )
                            : SizedBox()),

                        Obx(
                          () => Wrap(
                            spacing: 10.0, // Horizontal spacing between words
                            runSpacing: 10.0, // Vertical spacing between words

                            alignment: WrapAlignment.start,
                            children: controller.tempWords.map((word) {
                              return GestureDetector(
                                onTap: () {
                                  // Remove the word from the list and update UI

                                  controller.addWordToSequenceLevel3(word);

                                  controller.outputText.value = controller
                                      .updateQuestion(question.question, word);
                                  log("message ${controller.outputText}${controller.selectedWords.first}");
                                },
                                child: FadeInUp(
                                  child: Container(
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: mainClr.withOpacity(0.5)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 1,
                                              offset: Offset(0, 1))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: Text(
                                      word,
                                      style:
                                          TextStyle(color: black, fontSize: 16),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 15),
                        FlipInX(
                          delay: Duration(seconds: 1),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(60)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/RewardCenter/girlEmoji.png",
                                  height: mq.height * 0.06,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Hint: ",
                                          style: customTextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        "${question.explanation}",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                Obx(() => controller.selectedWords.length !=
                                        controller.tempWords.length
                                    ? index == 0
                                        ? IntroStepBuilder(
                                            order: 3,
                                            text:
                                                'Tap on this to see a clue for your current question.',
                                            builder: (context, key) =>
                                                getClueWidget(
                                                    key: key,
                                                    context: context,
                                                    question: question),
                                          )
                                        : getClueWidget(
                                            key: null,
                                            context: context,
                                            question: question)
                                    : SizedBox()),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: mainClr.withOpacity(0.5),
                        ),
                        SizedBox(height: 20),
                        // Display the selected words in sequence

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Option chossed:",
                            style: TextStyle(
                                fontSize: mq.height * 0.020,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: mq.height * 0.02),
                        Obx(() => controller.selectedWords.isNotEmpty
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: black),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(2.0),
                                  child: Center(
                                    child: Obx(() {
                                      // Use RichText to style the selected option
                                      // Use a regular expression to split the text only at the exact match
                                      final parts = controller.getSplitString(
                                          controller.outputText.value,
                                          controller.selectedWords.first);

                                      return RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                          children: [
                                            TextSpan(text: parts[0]),
                                            if (controller
                                                .selectedWords.isNotEmpty)
                                              TextSpan(
                                                text: controller
                                                    .selectedWords.first,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            if (parts.length > 1)
                                              TextSpan(text: parts[1]),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ))
                            : Container(
                                height: 40,
                                width: double.infinity,
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                              )),
                        SizedBox(height: mq.height * 0.04),
                        // Button to confirm if all words are in correct order
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Obx(
                            () => controller.selectedWords.length >= 1
                                ? InkWell(
                                    onTap: () async {
                                      intro.dispose();
                                      if (controller.currentPageIndex.value <
                                          controller.level3Question.length) {
                                        String useranswer =
                                            controller.selectedWords.first;
                                        bool isCorrect =
                                            await controller.checkAnswer(
                                                useranswer,
                                                question.correctAnswer);
                                        showFeedback(isCorrect,
                                            "answer"); // For SnackBar
                                        controller.selectedWords.clear();
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        controller.goToNextPagelevel3();
                                      } else {
                                        String useranswer =
                                            controller.selectedWords.first;
                                        bool isCorrect =
                                            await controller.checkAnswer(
                                                useranswer,
                                                question.correctAnswer);
                                        showFeedback(isCorrect,
                                            "answer"); // For SnackBar
                                        controller.isQuizCompleted.value = true;
                                        controller.level3Result(
                                            controller.level3Question);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: mainClr),
                                      child: Obx(
                                        () => Text(
                                          controller.currentPageIndex.value <
                                                  controller
                                                      .level3Question.length
                                              ? "Save & Next"
                                              : "Done",
                                          style: TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                : index == 0
                                    ? IntroStepBuilder(
                                        order: 4,
                                        text:
                                            'Tap on this to save and move to next question',
                                        builder: (context, key) => Container(
                                          key: key,
                                          padding: EdgeInsets.all(12),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: grey),
                                          child: Text(
                                            "Save & Next",
                                            style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(12),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: grey),
                                        child: Text(
                                          "Save & Next",
                                          style: TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                          ),
                        )
                        // _buildNavigationButtons(controller),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
          bottomNavigationBar: Obx(() =>
              (!(Subscriptioncontroller.isMonthlypurchased.value ||
                          Subscriptioncontroller.isYearlypurchased.value)) &&
                      !InterstitialAdClass.isInterAddLoaded.value &&
                      !AppOpenAdManager.isOpenAdLoaded.value &&
                      isAdLoaded &&
                      nativeAd3 != null
                  ? Container(
                      decoration: BoxDecoration(
                          color: white, border: Border.all(color: black)),
                      height: 150,
                      width: double.infinity,
                      child: AdWidget(ad: nativeAd3!))
                  : (Subscriptioncontroller.isMonthlypurchased.value ||
                          Subscriptioncontroller.isYearlypurchased.value)
                      ? SizedBox()
                      : ShimmarrNativeSmall(mq: mq, height: 135)),
        ),
      ),
    );
  }

  InkWell getClueWidget(
      {GlobalKey<State<StatefulWidget>>? key,
      required BuildContext context,
      required Level3RewardModel question}) {
    return InkWell(
        key: key,
        onTap: () {
          if ((!(Subscriptioncontroller.isMonthlypurchased.value ||
              Subscriptioncontroller.isYearlypurchased.value))) {
            showDialog(
              context: context,
              builder: (_) => ProFeatureDialog(
                onWatchAdTap: () {
                  Navigator.of(context).pop();
                  print("Watch Ad button tapped!");
                  RewardedAdHelper.showRewardedAd(
                    context: context,
                    onRewardEarned: () {
                      // Show clue or next hint here
                      String word = question.correctAnswer;
                      controller.addWordToSequenceLevel3(word);

                      controller.outputText.value = controller.updateQuestion(
                        question.question,
                        word,
                      );
                      log("Clue shown: ${controller.outputText}");
                    },
                    onAdFailedToLoad: () {
                      // Handle the case when no ad is available
                      log("No ad available. Showing clue directly.");
                      String word = question.correctAnswer;
                      controller.addWordToSequenceLevel3(word);

                      controller.outputText.value = controller.updateQuestion(
                        question.question,
                        word,
                      );
                    },
                  );
                },
                onGetProTap: () {
                  Get.to(() => PremiumScreen(isSplash: false));
                  print("Get Pro button tapped!");
                },
              ),
            );
          } else {
            // Show clue or next hint here
            String word = question.correctAnswer;
            controller.addWordToSequenceLevel3(word);

            controller.outputText.value = controller.updateQuestion(
              question.question,
              word,
            );
            log("Clue shown: ${controller.outputText}");
          }
        },
        child: TooltipWidget());
  }
}
