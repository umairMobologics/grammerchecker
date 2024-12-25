import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Controller/CharScreenController.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/TutorDashBoardList.dart';
import 'package:grammar_checker_app_updated/core/model/TutorModels/tutorModel.dart';
import 'package:grammar_checker_app_updated/core/utils/alert_dialogs.dart';

import '../../../../core/utils/colors.dart';

class Aboutscreen extends StatefulWidget {
  final TutorModel tutorModel;
  final ChatController controller;
  const Aboutscreen(
      {super.key, required this.tutorModel, required this.controller});

  @override
  State<Aboutscreen> createState() => _AboutscreenState();
}

class _AboutscreenState extends State<Aboutscreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Tutor"),
        backgroundColor: mainClr,
        elevation: 0,
        iconTheme: const IconThemeData(color: white),
      ),
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: mq.height * 0.02),
            InkWell(
              borderRadius: BorderRadius.circular(80),
              onTap: () {
                //showFullImage
              },
              child: CircleAvatar(
                maxRadius: 80,
                backgroundImage: widget.tutorModel.customAvatar != null
                    ? FileImage(File(widget.tutorModel.customAvatar!))
                    : AssetImage(widget.tutorModel.tutorAvatar),
              ),
            ),
            SizedBox(height: mq.height * 0.02),
            Text(
              widget.tutorModel.tutorName.toUpperCase(),
              style: const TextStyle(
                  color: black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: mq.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showClearChatDialog(
                        context,
                        "Are you sure?",
                        "Clear chat history and make a fresh start with the character.",
                        () {
                          // log("Cleared");
                          widget.controller.clearConversation(
                              widget.tutorModel.uniqueTutorID);
                          widget.controller..messageCount.value = 0;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: black),
                          color: white),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Clear Chat History",
                            style: TextStyle(
                                color: black, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            CupertinoIcons.delete_left_fill,
                            color: black,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.02),
                  InkWell(
                    onTap: () {
                      showClearChatDialog(context, "Are you sure?",
                          "The character will be deleted permanently", () {
                        widget.controller.deleteConversation(
                            widget.tutorModel.uniqueTutorID);
                        widget.controller.messageCount.value = 0;
                        widget.controller
                            .deleteGirlfriend(widget.tutorModel.uniqueTutorID);
                        Get.offAll(() => BottomNavBarScreen());
                        Get.to(() => TutorList(isbottom: true));
                      }, yes: "Delete Character");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: black),
                          color: white),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Erase Character",
                            style: TextStyle(
                                color: red, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            CupertinoIcons.delete,
                            color: red,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mq.height * 0.02),
            const Divider()
          ],
        ),
      ),
    );
  }
}

class ChatAIAboutScreen extends StatelessWidget {
  final String chatid;
  const ChatAIAboutScreen({super.key, required this.chatid});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlign,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      (Icons.arrow_back),
                      color: black,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                const Text(
                  "Clear Conversation",
                  style: TextStyle(color: black),
                )
              ],
            ),
            SizedBox(height: mq.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showClearChatDialog(
                        context,
                        "Are you sure?",
                        "Clear chat history and make a fresh start with the character.",
                        () {
                          // log("Cleared");
                          // context
                          //     .read<ChatProvider>()
                          //     .clearConversation(chatid);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: black),
                          color: white),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Clear Chat History",
                            style: TextStyle(
                                color: black, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            CupertinoIcons.delete_left_fill,
                            color: black,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.02),
                ],
              ),
            ),
            SizedBox(height: mq.height * 0.02),
            const Divider()
          ],
        ),
      ),
    );
  }
}
