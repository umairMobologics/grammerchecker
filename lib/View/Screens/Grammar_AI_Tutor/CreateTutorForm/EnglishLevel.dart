import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FromPAgeView.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/AppBarWidget.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/core/utils/alert_dialogs.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

class EnglishLevel extends StatefulWidget {
  final PageController pageController;
  const EnglishLevel({super.key, required this.pageController});

  @override
  State<EnglishLevel> createState() => _EnglishLevelState();
}

class _EnglishLevelState extends State<EnglishLevel> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              pageController: widget.pageController,
            ),
            //whats your name
            Column(
              children: [
                SizedBox(height: mq.height * 0.02),
                Text(
                  textAlign: TextAlign.center,
                  "How’s your English?",
                  style: TextStyle(color: black, fontSize: 30.h),
                ),
                SizedBox(height: mq.height * 0.01),
                Text(
                  textAlign: TextAlign.center,
                  "On a scale of 1--5",
                  style: TextStyle(color: black, fontSize: 18.h),
                ),
                SizedBox(height: mq.height * 0.05),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Obx(() => Column(
                        children: List.generate(
                          formController.englishLevel.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                formController.selectEnglishLevel(
                                    formController.englishLevel[index]);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50.v, vertical: 10),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 1,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: formController.selectedLevel.value ==
                                            formController.englishLevel[index]
                                        ? mainClr // Highlight selected item
                                        : Colors.black12, // Default border
                                    width: formController.selectedLevel.value ==
                                            formController.englishLevel[index]
                                        ? 1.5
                                        : 0.5,
                                  ),
                                ),
                                child: Text(
                                  "${index + 1}- ${formController.englishLevel[index]}",
                                  style: TextStyle(
                                    fontSize: 18.h,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (formController.selectedLevel.isEmpty) {
              showException("Please select your scale", context, color: red);
            } else {
              widget.pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear);
            }
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const UserName()));
          },
          child: CustomButton(
            text: "Continue",
            color: white,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
