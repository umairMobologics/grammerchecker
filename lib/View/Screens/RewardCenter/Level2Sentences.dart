import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/Widgets/ResultScreenWidget.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/Widgets/tootlTip.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/utils/Dialouges/ProfetureDialouge.dart';
import 'package:grammer_checker_app/View/Screens/RewardCenter/utils/isIntroCheck.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/core/model/RewardCenterModels/level2RewardModel.dart';
import 'package:grammer_checker_app/core/utils/ShimarEffectAD.dart';

import '../../../Controllers/RewardCenterControllers/RewardHomePageController.dart';
import '../../../Controllers/RewardCenterControllers/RewardQuizController.dart';
import '../../../core/Helper/AdsHelper/rewardedAdHelper.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/snackbar.dart';
import '../../../main.dart';
import 'utils/Dialouges/levelIntroDialouges.dart';

class Level2SentenceScreen extends StatefulWidget {
  @override
  State<Level2SentenceScreen> createState() => _Level2SentenceScreenState();
}

class _Level2SentenceScreenState extends State<Level2SentenceScreen> {
  final RewardQuizController controller = Get.put(RewardQuizController());

  final globleController = Get.find<Globletaskcontroller>();

  void setQuizStatus(bool status) {
    // Mark task as completed
    globleController.updateTaskCompleted(
        status, globleController.level2Taskstatus);
  }

  void setTaskStatus(bool status) {
// Mark task as won
    globleController.updateTaskWin(status, globleController.level2Winstatus);
  }

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
    // Fetch data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.level2Question.isEmpty) {
        controller.fetchLevel2Questions(controller.level2category);
      }
    });

    RewardedAdHelper.attemptFailed = 0;
    RewardedAdHelper.loadRewardedAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LevelIntroDialog.showLevel2Dialouge(
        context,
        () {
          Navigator.pop(context);
          checkIntro();
        },
      );
    });
  }

  void checkIntro() async {
    bool _hasSeenIntro = await checkIfIntroShown("level2IntroCheck");
    log("intro value is $_hasSeenIntro");
    if (_hasSeenIntro) {
      Intro.of(context).start(
        reset: false,
      );
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
    // RewardedAdHelper.rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> totalwords = [];
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
                quizLenght: controller.level2Question.length,
                level: "level2",
              );
            }

            // If no questions are available, show an empty state message
            if (controller.level2Question.isEmpty) {
              return Center(child: Text("No questions available."));
            }

            return PageView.builder(
              controller: controller.pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Disables page snapping
              itemCount: controller.level2Question.length,
              itemBuilder: (context, index) {
                Level2RewardModel question = controller.level2Question[index];
                log("${controller.level2Question.length}");
                if (controller.tempWords.isEmpty) {
                  totalwords = question.question
                      .toLowerCase()
                      .split(RegExp(r'\s+|\/'))
                      .where((word) => word.isNotEmpty)
                      .toList();
                  controller.WordLength.value = totalwords.length;

                  log("word length is ${totalwords}");
                  controller.tempWords.value = totalwords;
                } else {
                  print("****************** refresh again");
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideInDown(
                          child: Text(
                            '${index + 1}/${controller.level2Question.length} Re-arrange the words and make correct sentence',
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
                                              'Tap on the box of words to move them to output box.\n'
                                              'the tapped box moves from shuffle to arrange',
                                          builder: (context, key) => Text(
                                            key: key,
                                            "Shuffle Words:",
                                            style: TextStyle(
                                                fontSize: mq.height * 0.020,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Text(
                                          "Shuffle Words:",
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
                                  controller.removeWordFromQuestion(word);
                                  controller.addWordToSequence(word);
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
                                      word.capitalize!,
                                      style:
                                          TextStyle(color: black, fontSize: 16),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 10),
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
                                  child: Text(
                                    "${question.explanation}",
                                  ),
                                ),
                                index == 0
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
                                        question: question),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: mainClr.withOpacity(0.5),
                        ),
                        // SizedBox(height: mq.height * 0.01),
                        // Display the selected words in sequence

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: index == 0
                              ? IntroStepBuilder(
                                  order: 2,
                                  text:
                                      'Tap on arrange box to remove it from here and add it back to shuffle section',
                                  builder: (context, key) => Text(
                                    key: key,
                                    "Arranged Word:",
                                    style: TextStyle(
                                        fontSize: mq.height * 0.020,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Text(
                                  "Arranged Word:",
                                  style: TextStyle(
                                      fontSize: mq.height * 0.020,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),

                        Obx(
                          () => controller.selectedWords.isNotEmpty
                              ? Wrap(
                                  spacing:
                                      10.0, // Horizontal spacing between words
                                  runSpacing:
                                      10.0, // Vertical spacing between words
                                  children:
                                      controller.selectedWords.map((word) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.removeWordFromSequence(word);
                                        controller.addWordToQuestion(word);
                                        controller.hintIndex.value--;
                                      },
                                      child: FadeInUp(
                                        child: Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: controller
                                                .getRandomColorForWord(word)
                                                .withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                          ),
                                          child: Text(
                                            word.capitalize!,
                                            style: TextStyle(
                                                color: black, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(5, (index) {
                                    // Fixed length of 5
                                    return Container(
                                      height: 40,
                                      width: 30,
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                      ),
                                    );
                                  }),
                                ),
                        ),

                        SizedBox(height: mq.height * 0.04),
                        // Selected Words as a String
                        Obx(
                          () => controller.selectedWords.isNotEmpty
                              ? Center(
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: black),
                                      borderRadius: BorderRadius.circular(12.0),
                                      // padding: EdgeInsets.symmetric(
                                      //     horizontal: 16, vertical: 8),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.grey[200],
                                      //   borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      controller.selectedWords
                                          .join(' ')
                                          .capitalizeFirst!, // Joining words as a string
                                      style: TextStyle(
                                          color: black,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: mq.height * 0.020),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ),
                        SizedBox(height: mq.height * 0.02),
                        // Button to confirm if all words are in correct order
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Obx(
                            () => controller.selectedWords.length >=
                                    controller.WordLength.value
                                ? InkWell(
                                    onTap: () async {
                                      if (controller.currentPageIndex.value <
                                          controller.level2Question.length) {
                                        String useranswer =
                                            controller.selectedWords.join(' ');
                                        bool isCorrect =
                                            await controller.checkAnswer(
                                                useranswer,
                                                question.correctAnswer);
                                        showFeedback(isCorrect,
                                            "sentence"); // For SnackBar
                                        controller.selectedWords.clear();
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        controller.hintIndex.value = 0;
                                        controller.goToNextPageLevel2();
                                      } else {
                                        String useranswer =
                                            controller.selectedWords.join(' ');
                                        bool isCorrect =
                                            await controller.checkAnswer(
                                                useranswer,
                                                question.correctAnswer);
                                        showFeedback(isCorrect,
                                            "sentence"); // For SnackBar
                                        controller.isQuizCompleted.value = true;
                                        controller.level2Result(
                                            controller.level2Question);
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
                                                      .level2Question.length
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
      required Level2RewardModel question}) {
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
                  // Split the correctAnswer into words
                  RewardedAdHelper.showRewardedAd(
                    context: context,
                    onRewardEarned: () {
                      // Show clue or next hint here
                      clueLogic(question);
                    },
                    onAdFailedToLoad: () {
                      // Handle the case when no ad is available
                      clueLogic(question);
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
            clueLogic(question);
          }
        },
        child: TooltipWidget());
  }

  void clueLogic(Level2RewardModel question) {
    List<String> words = question.correctAnswer.split(" ");
    if (controller.selectedWords.isNotEmpty) {
      log("new length is ${controller.selectedWords.length}");
      int i = 0;
      for (i; i < controller.selectedWords.length; i++) {
        words[i] = words[i].replaceAll(".", "");
        words[i] = words[i].toLowerCase();
        controller.selectedWords[i] =
            controller.selectedWords[i].replaceAll(".", "");
        controller.selectedWords[i] = controller.selectedWords[i].toLowerCase();

        if (words[i] == controller.selectedWords[i]) {
          log("matched");
          if (i == words.length - 1) {
            log("no hint available");
          } else if (i < words.length &&
              i == controller.selectedWords.length - 1) {
            words[i + 1] = words[i + 1].replaceAll(".", "");
            words[i + 1] = words[i + 1].toLowerCase();

            log("all matched *** add next hint");
            // Add the correct character to the selected list
            controller.selectedWords.add("${words[i + 1]}");

            // Remove the correct character from the question pool
            controller.removeWordFromQuestion(controller.selectedWords[i + 1]);
            break;
          }
        } else {
          log("unmatched at index ${i}");

          log("now the slected list is ${controller.selectedWords}");
          log("current index is $i");
          for (int j = controller.selectedWords.length - 1; j >= i; j--) {
            log("j = $j, ${controller.selectedWords[j]}");
            controller.addWordToQuestion(controller.selectedWords[j]);
            controller.selectedWords.removeAt(j);
          }

          controller.selectedWords.add("${words[i]}");

          controller.removeWordFromQuestion(controller.selectedWords[i]);

          break;
          // break;
        }
      }
    } else {
      // Get the next word to reveal
      String nextWord = words.first;
      nextWord = nextWord.replaceAll(".", "");
      nextWord = nextWord.toLowerCase();
      log("next word is $nextWord");
      controller.selectedWords.add(nextWord);
      controller.removeWordFromQuestion(nextWord);
    }
  }
}
