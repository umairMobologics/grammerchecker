import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FromPAgeView.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/AppBarWidget.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/core/utils/alert_dialogs.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';
import 'package:language_picker/languages.dart';

class userLanguage extends StatefulWidget {
  final PageController pageController;
  const userLanguage({super.key, required this.pageController});

  @override
  State<userLanguage> createState() => _userLanguageState();
}

class _userLanguageState extends State<userLanguage> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    // Generate a list of all languages from the package
    final List<Language> allLanguages = Languages.defaultLanguages;

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
            SizedBox(height: mq.height * 0.02),
            Text(
              textAlign: TextAlign.center,
              "What’s your native language?",
              style: TextStyle(color: black, fontSize: 30.h),
            ),
            SizedBox(height: mq.height * 0.01),
            Text(
              textAlign: TextAlign.center,
              "Popular Languages",
              style: TextStyle(color: black, fontSize: 18.h),
            ),
            SizedBox(height: mq.height * 0.05),

            // Scrollable ListView
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                itemCount: allLanguages.length,
                itemBuilder: (context, index) {
                  final language = allLanguages[index];

                  return Obx(
                    () => GestureDetector(
                      onTap: () {
                        formController.selectLanguage(language.name);
                        log("Selected language: ${language.name}");
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: formController.selectedlanguage.value ==
                                  language.name
                              ? mainClr
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: formController.selectedlanguage.value ==
                                    language.name
                                ? mainClr
                                : Colors.black12,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          language.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: formController.selectedlanguage.value ==
                                    language.name
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (formController.selectedlanguage.isEmpty) {
              showException("Please select your scale", context, color: red);
            } else {
              widget.pageController.animateToPage(4,
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
