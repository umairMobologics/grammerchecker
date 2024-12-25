import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FromPAgeView.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/AppBarWidget.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/core/utils/alert_dialogs.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

class LearningPurpose extends StatefulWidget {
  final PageController pageController;
  const LearningPurpose({super.key, required this.pageController});

  @override
  State<LearningPurpose> createState() => _LearningPurposeState();
}

class _LearningPurposeState extends State<LearningPurpose> {
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
                  "WHY DO  YOU WANT TO ",
                  style: TextStyle(color: black, fontSize: 30.h),
                ),
                SizedBox(height: mq.height * 0.01),
                Text(
                  textAlign: TextAlign.center,
                  "improve your English?",
                  style: TextStyle(color: black, fontSize: 18.h),
                ),
                SizedBox(height: mq.height * 0.05),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Obx(() => Column(
                        children: List.generate(
                          formController.learningPurposeList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                String selectedPurpose =
                                    formController.learningPurposeList[index];

                                // If already selected, remove it, else add it
                                if (formController.selectedPurposes
                                    .contains(selectedPurpose)) {
                                  formController.selectedPurposes
                                      .remove(selectedPurpose);
                                } else {
                                  formController.selectedPurposes
                                      .add(selectedPurpose);
                                }
                                log("total slected items are: ${formController.selectedPurposes}");
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50.v, vertical: 10),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 1,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: formController.selectedPurposes
                                            .contains(formController
                                                .learningPurposeList[index])
                                        ? mainClr
                                        : Colors.black12, // Default border
                                    width: formController.selectedPurposes
                                            .contains(formController
                                                .learningPurposeList[index])
                                        ? 1.5
                                        : 0.5,
                                  ),
                                ),
                                child: Text(
                                  formController.learningPurposeList[index],
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
            if (formController.selectedPurposes.isEmpty) {
              showException("Please select atleast 1 purpose", context,
                  color: red);
            } else {
              widget.pageController.animateToPage(5,
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
