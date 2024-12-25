import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FromPAgeView.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/core/utils/alert_dialogs.dart';
import 'package:grammar_checker_app_updated/core/utils/customTextStyle.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

import '../../../../core/utils/colors.dart';
import '../Widgets/AppBarWidget.dart';

class UserGender extends StatefulWidget {
  final PageController pageController;
  const UserGender({super.key, required this.pageController});

  @override
  State<UserGender> createState() => _UserGenderState();
}

class _UserGenderState extends State<UserGender> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            //cancle button
            AppBarWidget(
              pageController: widget.pageController,
            ),
            //whats your name

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SvgPicture.asset("assets/tutorIcons/genderIcon.svg"),
                  SizedBox(height: mq.height * 0.02),
                  const Text(
                    textAlign: TextAlign.center,
                    "Select Your gender",
                    style: TextStyle(color: black, fontSize: 30),
                  ),
                  SizedBox(height: mq.height * 0.1),
                ],
              ),
            ),

            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Male Selection Container
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          formController.isMaleSelected.value = true;
                          formController.isFemaleSelected.value = false;
                          formController.userGender.value = "Male";
                        },
                        child: Stack(
                          children: [
                            // Main Container
                            Column(
                              children: [
                                Image.asset(
                                  "assets/tutorIcons/maleIcon.png",
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "Male",
                                  style: customTextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: black,
                                    fontSize: 22.h,
                                  ),
                                ),
                              ],
                            ),
                            // Tick Icon (only visible when selected)
                            if (formController.isMaleSelected.value)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(
                                  Icons.check_box_rounded,
                                  color: white,
                                  size: 24.h,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    // Female Selection Container
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          formController.isMaleSelected.value = false;
                          formController.isFemaleSelected.value = true;
                          formController.userGender.value = "Female";
                        },
                        child: Stack(
                          children: [
                            // Main Container
                            Column(
                              children: [
                                Image.asset(
                                  "assets/tutorIcons/femaleIcon.png",
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "Female",
                                  style: customTextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: black,
                                    fontSize: 22.h,
                                  ),
                                ),
                              ],
                            ),
                            // Tick Icon (only visible when selected)
                            if (formController.isFemaleSelected.value)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(
                                  Icons.check_box_rounded,
                                  color: white,
                                  size: 24.h,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (formController.userGender.isEmpty) {
              showException("Please select gender", context, color: red);
            } else {
              widget.pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear);
            }
          },
          child: const CustomButton(
            text: "Continue",
          ),
        ),
      )),
    );
  }
}
