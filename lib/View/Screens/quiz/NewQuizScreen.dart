import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/databaseHelper/quizStatus.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/LoadingDialouge.dart';
import 'package:grammer_checker_app/utils/ShimarEffectAD.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:grammer_checker_app/utils/theme.dart';
import 'package:lottie/lottie.dart';

class StartNewQuizScreen extends StatefulWidget {
  final String difficulty_level;
  const StartNewQuizScreen({super.key, required this.difficulty_level});

  @override
  State<StartNewQuizScreen> createState() => _StartNewQuizScreenState();
}

class _StartNewQuizScreenState extends State<StartNewQuizScreen> {
  RxBool quizCompleteStatus = false.obs;
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
    if (quizController.multipleChoice.isEmpty &&
        !quizController.isLoading.value) {
      quizController.initializeQuizQuestions();
    }
    checkQuizStatus();
    if (nativeAd3 == null) {
      loadNativeAd();
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
    super.dispose();
    disposeAd();
  }

  checkQuizStatus() async {
    quizCompleteStatus.value =
        await QuizCompletionStatus.isQuizCompleted(widget.difficulty_level);
    log("Quiz COmpleted is : ${quizCompleteStatus.value}");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var mq = MediaQuery.sizeOf(context);
    var width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: white,
        body: Obx(() {
          if (quizCompleteStatus.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildHeader(height, width, "Test Finished"),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/Icons/quizCompleted.svg',
                          height: height * .2,
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          "The test has already been finished.",
                          style: customTextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.02),
                        InkWell(
                          onTap: () async {
                            if (await QuizCompletionStatus
                                .areAllQuizzesCompleted()) {
                              await QuizRefereshDialouge(context, height);
                            } else {
                              Get.back();
                            }
                          },
                          child: Container(
                              width: width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: mainClr,
                              ),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ok",
                                    style: customTextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: white),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox()
                ],
              ),
            );
          }
          if (quizController.isQuizCompleted.value) {
            return _buildResultScreen(context, height, width);
          }
          if (quizController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: mainClr,
              ),
            );
          } else {
            if (quizController.multipleChoice.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildHeader(height, width, "Grammar Test"),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/noQuiz.png"))),
                        ),
                        Text(
                          "No test Available right now",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: height * .022, color: black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox()
                ],
              );
            } else {
              String selectedDifficulty = widget
                  .difficulty_level; // Example difficulty, get this from user input or selection
              quizController.filteredQuizQuestions =
                  quizController.getQuestionsByDifficulty(selectedDifficulty);

              if (quizController.filteredQuizQuestions.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildHeader(height, width, "Grammar Test"),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/noQuiz.png"))),
                          ),
                          Text(
                            "No questions available for the selected difficulty.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: height * .022, color: black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox()
                  ],
                ));
              }

              final currentQuestion = quizController.filteredQuizQuestions[
                  quizController.currentQuestionIndex.value];

              return Column(
                children: [
                  buildHeader(height, width, "Test Started"),
                  SizedBox(height: height * .0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: black,
                              blurRadius: 6,
                              blurStyle: BlurStyle.outer,
                              spreadRadius: 0.3,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(12),
                                  value: (quizController
                                              .currentQuestionIndex.value +
                                          1) /
                                      quizController
                                          .filteredQuizQuestions.length,
                                  minHeight: height * .015,
                                  color: mainClr,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              Text(
                                '${quizController.currentQuestionIndex.value + 1}/${quizController.filteredQuizQuestions.length}',
                                style: TextStyle(
                                  fontSize: height * 0.018,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            '${quizController.currentQuestionIndex.value + 1}. ${currentQuestion.quizQuestion}',
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: height * 0.020,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(0),
                              children: [
                                _buildOption(currentQuestion.multipleChoiceA,
                                    currentQuestion.correctAnswer),
                                _buildOption(currentQuestion.multipleChoiceB,
                                    currentQuestion.correctAnswer),
                                _buildOption(currentQuestion.multipleChoiceC,
                                    currentQuestion.correctAnswer),
                                _buildOption(currentQuestion.multipleChoiceD,
                                    currentQuestion.correctAnswer),
                                SizedBox(height: height * 0.02),
                                quizController.isOptionSelected.value &&
                                        !quizController
                                            .isCorrectAnswerSelected.value
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.green.withOpacity(0.2)),
                                        child: Text.rich(TextSpan(children: [
                                          const TextSpan(
                                              text: "Correct Answer is: ",
                                              style: TextStyle(
                                                  color: AppColors.black)),
                                          TextSpan(
                                              text:
                                                  currentQuestion.correctAnswer,
                                              style: const TextStyle(
                                                color: Colors.green,
                                              )),
                                        ])),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (quizController.isOptionSelected.value) {
                                quizController.nextQuestion(
                                    quizController.filteredQuizQuestions);
                                quizController.resetSelection();
                              } else {
                                showToast(context, 'Please choose an option');
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: mainClr,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                'Next',
                                style: TextStyle(
                                    fontSize: height * .02,
                                    color: white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        }),
        bottomNavigationBar: Obx(() =>
            (!Subscriptioncontroller.isMonthlypurchased.value &&
                        !Subscriptioncontroller.isYearlypurchased.value) &&
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
    );
  }

  Widget _buildResultScreen(BuildContext context, double height, double width) {
    String resultMessage;
    double percentage = quizController.resultPercentage.value;

    if (percentage < 50) {
      resultMessage = 'Fail';
    } else if (percentage >= 50 && percentage < 70) {
      resultMessage = 'Average';
    } else if (percentage >= 70 && percentage < 80) {
      resultMessage = 'Good';
    } else if (percentage >= 80 && percentage < 90) {
      resultMessage = 'Very Good';
    } else {
      resultMessage = 'Excellent';
    }

    return Column(
      children: [
        buildHeader(height, width, "Test Completed"),
        SizedBox(height: height * 0.04),
        Card(
          elevation: 4,
          color: mainClr,
          margin: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              children: [
                Text(
                  'You answered ${quizController.correctAnswersCount.value} out of ${quizController.filteredQuizQuestions.length} questions correctly.',
                  style: TextStyle(fontSize: height * 0.025, color: white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Your percentage: ${percentage.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: height * 0.025, color: white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Your performance: $resultMessage',
                  style: TextStyle(
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.bold,
                      color: percentage < 50
                          ? Colors.red
                          : const Color.fromARGB(255, 48, 252, 55)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        Lottie.asset(
          percentage < 50 ? 'assets/fail.json' : 'assets/pass.json',
          height: height * .2,
        ),
        SizedBox(height: height * 0.02),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () async {
              await QuizCompletionStatus.markQuizAsCompleted(
                  widget.difficulty_level);
              quizController.resetSelection();

              quizController.clearAllFields();
              InterstitialAdClass.count += 1;
              if (InterstitialAdClass.count == InterstitialAdClass.totalLimit &&
                  (!Subscriptioncontroller.isMonthlypurchased.value &&
                      !Subscriptioncontroller.isYearlypurchased.value)) {
                InterstitialAdClass.showInterstitialAd(context);
              }
              if (await QuizCompletionStatus.areAllQuizzesCompleted()) {
                await QuizRefereshDialouge(context, height);
              } else {
                Get.back();
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: mainClr, borderRadius: BorderRadius.circular(12)),
              child: Text(
                'Done',
                style: TextStyle(
                    fontSize: height * .022,
                    color: white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption(String option, String correctOption) {
    return Obx(() {
      bool isSelected = quizController.selectedOption.value == option;
      bool isCorrect = quizController.isCorrectAnswerSelected.value &&
          option == correctOption;
      bool isIncorrect = isSelected && !isCorrect;

      return GestureDetector(
        onTap: () {
          if (!quizController.isOptionSelected.value) {
            quizController.selOption(option, correctOption);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            // color:
            border: Border.all(
              width: 2,
              color: isCorrect
                  ? Colors.green
                  : isIncorrect
                      ? Colors.red
                      : Colors.black54,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  option,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isCorrect
                        ? Colors.green
                        : isIncorrect
                            ? Colors.red
                            : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              if (isCorrect)
                const Icon(Icons.check_circle, color: Colors.green),
              if (isIncorrect)
                const Icon(Icons.cancel_outlined, color: Colors.red),
            ],
          ),
        ),
      );
    });
  }

  Widget buildHeader(double height, double width, String title) {
    return Container(
      width: double.infinity,
      height: height * .12,
      color: mainClr,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: height * .04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    if (await QuizCompletionStatus.areAllQuizzesCompleted()) {
                      await QuizRefereshDialouge(context, height);
                    } else {
                      Get.back();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: white,
                    size: height * .03,
                  ),
                ),
                // SizedBox(width: width * .22),
                Text(
                  title,
                  style: TextStyle(
                    color: white,
                    fontSize: height * .027,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(onPressed: () {}, icon: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
