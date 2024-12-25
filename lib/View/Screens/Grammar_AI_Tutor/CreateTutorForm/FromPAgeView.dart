import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Controller/TutorController.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/EnglishLevel.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/LearningPurpose.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/UserGender.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/getName.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/selectTutorAvater.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/userLanguage.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';

var formController = Get.put(TutorFormController());

class CreateAiTutorForm extends StatefulWidget {
  const CreateAiTutorForm({super.key});

  @override
  State<CreateAiTutorForm> createState() => _CreateAiTutorFormState();
}

class _CreateAiTutorFormState extends State<CreateAiTutorForm> {
  final pageController = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        formController.clearAll();
      },
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainClr,
      body: PageView(
        // pageSnapping: false,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal, // or Axis.vertical
        children: [
          UserName(
            pageController: pageController,
          ),
          UserGender(pageController: pageController),
          EnglishLevel(pageController: pageController),
          userLanguage(
            pageController: pageController,
          ),
          LearningPurpose(
            pageController: pageController,
          ),
          TutorAvatar(
            pageController: pageController,
          )
        ],
      ),
    );
  }
}
