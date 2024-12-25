import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FinishFormProgress.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/CreateTutorForm/FromPAgeView.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/AppBarWidget.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Widgets/CustomButton.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

import '../../../../core/utils/PickImage_gallery_camera.dart';
import '../../../../core/utils/alert_dialogs.dart';
import '../Widgets/AvatarWidget.dart';

class TutorAvatar extends StatefulWidget {
  final PageController pageController;
  const TutorAvatar({super.key, required this.pageController});

  @override
  State<TutorAvatar> createState() => _TutorAvatarState();
}

class _TutorAvatarState extends State<TutorAvatar> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(
              pageController: widget.pageController,
            ),
            //whats your name
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      SizedBox(height: mq.height * 0.02),
                      Text(
                        textAlign: TextAlign.center,
                        "Let's Setup Your Tutor",
                        style: TextStyle(color: black, fontSize: 30.h),
                      ),
                      SizedBox(height: mq.height * 0.01),
                      Text(
                        textAlign: TextAlign.center,
                        "You can also select customized avatar for you tutor",
                        style: TextStyle(color: black, fontSize: 18.h),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: mq.height * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                textAlign: TextAlign.start,
                "Enter your tutor name",
                style: TextStyle(
                    color: black, fontSize: 18.h, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: mq.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: 0.1), // Shadow color
                      // spreadRadius: 2, // How far the shadow spreads
                      blurRadius: 1, // How soft the shadow is
                      offset: Offset(2, 4), // X and Y offsets
                    ),
                  ],
                  color: Colors.white, // Background color
                ),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
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
                    hintText: "e.g. Grammar Tutor",
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(color: grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                textAlign: TextAlign.start,
                "Choose your tutor avatar",
                style: TextStyle(
                    color: black, fontSize: 18.h, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: mq.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 150.h,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(
                    () => Row(
                      children: [
                        // Add custom avatar option
                        InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              var customAvatar = await getImagefromGallery();
                              if (customAvatar != null) {
                                formController.selectedAvatar.value = "";
                                formController.setCustomAvatar(customAvatar);
                              }
                              log("Image is selected");
                            },
                            child: // Check if a custom avatar is set
                                formController.customAvatar.value != null
                                    ? Container(
                                        height: 140,
                                        width: 140,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: mainClr,
                                            width: 2,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              formController
                                                  .customAvatar.value!,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Icon(
                                                  Icons.check_box_rounded,
                                                  color: mainClr),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 100,
                                        width: 100,
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black54),
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo_outlined),
                                            Text("Add custom"),
                                          ],
                                        ),
                                      )),
                        // SizedBox(width: mq.width * 0.02),

                        // Avatar options
                        ...[
                          "assets/tutorIcons/tutor1.png",
                          "assets/tutorIcons/tutor2.png",
                          "assets/tutorIcons/tutor3.png",
                          "assets/tutorIcons/tutor4.png",
                          "assets/tutorIcons/tutor5.png"
                        ].map((avatar) {
                          return Obx(() => GestureDetector(
                                onTap: () {
                                  formController.selectAvatar(avatar);
                                  formController.customAvatar.value = null;
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: mq.width * 0.02),
                                  child: AvatarWidget(
                                    image: avatar,
                                    isSelected:
                                        formController.selectedAvatar.value ==
                                            avatar,
                                  ),
                                ),
                              ));
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            if (controller.text.isEmpty) {
              showException("Please enter avatar name", context, color: red);
            } else if (formController.selectedAvatar.isEmpty &&
                formController.customAvatar.value == null) {
              showException("Please select your avatar", context, color: red);
            } else {
              formController.tutorName.value = controller.text;
              await formController.saveTutorData();
              Get.off(() => ProgressScreen(
                    data: formController.tutorData.value!,
                  ));
            }
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
