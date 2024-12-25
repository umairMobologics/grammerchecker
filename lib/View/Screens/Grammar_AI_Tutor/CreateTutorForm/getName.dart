import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FromPAgeView.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/core/utils/alert_dialogs.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';

class UserName extends StatefulWidget {
  final PageController pageController;
  const UserName({super.key, required this.pageController});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            //cancle button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Ink(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        (Icons.cancel),
                        color: black,
                        size: 35,
                      )),
                )
              ],
            ),

            //whats your name
            Column(
              children: [
                SvgPicture.asset("assets/tutorIcons/nameIcon.svg"),
                SizedBox(height: mq.height * 0.02),
                const Text(
                  textAlign: TextAlign.center,
                  "What's your name?",
                  style: TextStyle(color: black, fontSize: 30),
                ),
                SizedBox(height: mq.height * 0.01),
                const Text(
                  textAlign: TextAlign.center,
                  "Introduce yourself to your tutor",
                  style: TextStyle(color: black, fontSize: 15),
                ),
                SizedBox(height: mq.height * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.1), // Shadow color
                          // spreadRadius: 2, // How far the shadow spreads
                          blurRadius: 1, // How soft the shadow is
                          offset: Offset(2, 4), // X and Y offsets
                        ),
                      ],
                      color: Colors.white, // Background color
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      // autofocus: true,
                      onSubmitted: (value) {
                        controller.text = value;
                        log(controller.text);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onChanged: (value) {
                        controller.text = value;
                        log(controller.text);
                      },
                      cursorColor: black,
                      controller: controller,
                      textAlign: TextAlign.start, // Align text to the start
                      style: const TextStyle(color: black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.profile_circled,
                          color: grey,
                        ),
                        hintText: "Enter your name here...",
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                        hintStyle: TextStyle(color: grey),
                      ),
                    ),
                  ),
                ),
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
            if (controller.text.isEmpty) {
              showException("Please enter your name first", context,
                  color: red);
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
              //save Username
              formController.setUsername(controller.text);

              widget.pageController.animateToPage(1,
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
