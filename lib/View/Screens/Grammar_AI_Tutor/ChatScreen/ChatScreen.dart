import 'dart:developer';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammar_checker_app_updated/Controllers/InAppPurchases/isPremiumCheck.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/ChatScreen/AboutScreen.dart';
import 'package:grammar_checker_app_updated/View/Screens/Grammar_AI_Tutor/Controller/CharScreenController.dart';
import 'package:grammar_checker_app_updated/core/model/TutorModels/tutorModel.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/snackbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Controllers/TTS_Controller.dart';
import '../../../../core/Helper/AdsHelper/AdHelper.dart';
import '../../../../core/Helper/AdsHelper/AppOpenAdManager.dart';
import '../../../../core/model/TutorModels/MessageModel.dart';
import '../../../../core/utils/ShimarEffectAD.dart';
import '../../../../main.dart';
import '../../InAppSubscription/PremiumFeatureScreen.dart';
import '../Widgets/ModeifytextUI.dart';

class Chatscreen extends StatefulWidget {
  final int index;
  final bool isFirstTime;
  final TutorModel tutor; // Add this line to accept the girlfriend data

  const Chatscreen({
    super.key,
    required this.tutor,
    required this.index,
    required this.isFirstTime, // Accept girlfriend data
  });

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  var chatController = Get.put(ChatController());
  final TTSController ttsController = Get.put(TTSController());

  /// Loads a banner ad.
  BannerAd? bannerAd;
  bool isLoaded = false;
  void loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      log('Unable to get height of anchored banner.');
      return;
    }

    try {
      bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAd,
        request: const AdRequest(),
        size: size,
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            log('$ad loaded.');
            setState(() {
              isLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            // Dispose the ad here to free resources.
            ad.dispose();
            setState(() {
              isLoaded = false;
              bannerAd = null;
            });
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) {},
        ),
      )..load();
    } catch (e, stackTrace) {
      setState(() {
        isLoaded = false;
        bannerAd = null;
      });
      // log('Error loading ad: $e');
      // FirebaseCrashlytics.instance.recordEr
      //ror(e, stackTrace);
    }
  }

  void disposeBannerAd() {
    if (bannerAd != null) {
      bannerAd!.dispose();
      bannerAd = null;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (bannerAd == null) {
      loadAd();
    }
  }

  @override
  void initState() {
    super.initState();
    chatController.getWelcomeMessage(widget.tutor);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        chatController.scrollToBottom(scrollController);
      }
    });
    FirebaseAnalytics.instance.logScreenView(screenName: "Tutor Chat Screen");
  }

  @override
  void dispose() {
    scrollController.dispose();
    _messageController.dispose();
    chatController.spekingMsg.value = '';
    ttsController.stop();
    disposeBannerAd();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    // var chatProvider = Provider.of<ChatProvider>(context); // Get the provider

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          // resizeToAvoidBottomInset: true,
          backgroundColor: white,
          body: Column(
            children: [
              appBarWidget(mq, context),

              ValueListenableBuilder<Box<Conversation>>(
                  valueListenable:
                      Hive.box<Conversation>('conversations').listenable(),
                  builder: (context, box, _) {
                    final data = box.get(widget.tutor.uniqueTutorID);
                    // final data = box.values.toList().cast<Conversation>();
                    // final messages = data[0].messages;
                    if (data == null || data.messages.isEmpty) {
                      var messageObj = chatController;

                      var firstmsg = messageObj.createMessageObject(
                          "bot",
                          messageObj.greetingMessage.value,
                          true,
                          TimeOfDay.now().format(context));
                      messageObj.saveMessageToConversation(
                          firstmsg, widget.tutor.uniqueTutorID);
                      chatController.spekingMsg.value = firstmsg.message!;

                      // messageObj.setchatFirstMessage(message);

                      return const Expanded(child: SizedBox());
                    } else {
                      return Expanded(
                        flex: 6,
                        child: ListView.builder(
                          controller: scrollController,

                          padding: const EdgeInsets.all(10),
                          itemCount: data.messages
                              .length, // Use the messages from provider
                          itemBuilder: (context, index) {
                            chatController.messagesList = data.messages;
                            final message = data.messages[index];
                            return _buildChatBubble(
                              message.sender!,
                              message.message!,
                              message.isSender!,
                              message.time!,
                            );
                          },
                        ),
                      );
                    }
                  }),
              // Pass context for provider access
              _buildMessageInputField(context, chatController),
            ],
          ),
          bottomNavigationBar: StatefulBuilder(builder: (context, setState) {
            return Obx(() => !InterstitialAdClass.isInterAddLoaded.value &&
                    !AppOpenAdManager.isOpenAdLoaded.value &&
                    isLoaded &&
                    bannerAd != null &&
                    ispremium()
                ? Container(
                    decoration: BoxDecoration(
                        color: white, border: Border.all(color: black)),
                    child: AdWidget(ad: bannerAd!),
                    width: bannerAd!.size.width.toDouble(),
                    height: bannerAd!.size.height.toDouble(),
                    alignment: Alignment.center,
                  )
                : (Subscriptioncontroller.isMonthlypurchased.value ||
                        Subscriptioncontroller.isWeeklypurchased.value ||
                        Subscriptioncontroller.isYearlypurchased.value)
                    ? SizedBox()
                    : ShimmarrEffectBanner(mq: mq, height: 50));
          }),
          // bottomNavigationBar: _buildMessageInputField(context, chatController),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(
              mq.height * 0.2), // Adjust the offset as needed,
          floatingActionButton: Obx(() => FloatingActionButton.extended(
              backgroundColor: white,
              onPressed: () {
                if (ttsController.isSpeaking.value) {
                  ttsController.pause();
                } else {
                  ttsController.speak(chatController.spekingMsg.value);
                }
              },
              label: ttsController.isSpeaking.value
                  ? AvatarGlow(
                      glowColor: mainClr,
                      child: Icon(
                        Icons.record_voice_over,
                        color: mainClr,
                      ))
                  : Icon(
                      Icons.voice_over_off_sharp,
                      color: red,
                    )))),
    );
  }

  // Modify the input field to add a new message using the provider
  Widget _buildMessageInputField(
      BuildContext context, ChatController controller) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: white),
                controller: _messageController,
                decoration: InputDecoration(
                  fillColor: mainClr,
                  filled: true, // This enables the fill color
                  hintText: chatController.messageCount <= 0
                      ? "Say hi..."
                      : "Type your message...",
                  hintStyle: const TextStyle(color: white),
                  // prefixIconConstraints: const BoxConstraints(
                  //   maxHeight: 29,
                  //   maxWidth: 29,
                  // ),

                  // prefixIcon: InkWell(
                  //   onTap: () {
                  //     log("mic pressed");
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 8), // Adjust padding as needed
                  //     height: 29, // Set your desired height
                  //     width: 29, // Set your desired width
                  //     child: SvgPicture.asset(
                  //       "assets/tutorIcons/mic.svg",
                  //       height: 29, // Set your desired height
                  //       width: 29, // Set your desired width
                  //     ),
                  //   ),
                  // ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: mainClr), // Change this to your desired color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: mainClr), // Change this to your desired color
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onSubmitted: (value) async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // Add the new message
                  if (_messageController.text.isNotEmpty) {
                    // Add the new message
                    var messageText = _messageController.text;
                    InterstitialAdClass.count += 1;
                    if (InterstitialAdClass.interstitialAd != null &&
                        InterstitialAdClass.count >=
                            InterstitialAdClass.totalLimit) {
                      InterstitialAdClass.showInterstitialAd(context);
                      InterstitialAdClass.count = 0;
                    }
                    _messageController.clear(); // Clear the input field
                    var message = controller.createMessageObject(
                      widget.tutor.userName, // The sender
                      messageText, // The message content
                      false, // Assuming it's sent by Umair (you)
                      TimeOfDay.now().format(context), // The time
                    );
                    controller.saveMessageToConversation(
                        message, widget.tutor.uniqueTutorID);

                    // Increment the message counter
                    controller.messageCount++;

                    await controller.askQuestion(
                        context,
                        messageText,
                        widget.tutor.uniqueTutorID,
                        widget.tutor,
                        scrollController,
                        ttsController);
                    controller.scrollToBottom(scrollController);

                    log("mesage cpunter is now ${controller.messageCount}");

                    // // Add the static AI message after every 5–6 messages
                    // if (controller.messageCount % 5 == 0) {
                    //   var aimsg = controller.createMessageObject(
                    //       "Bot",
                    //       controller.premiumMessage,
                    //       true,
                    //       TimeOfDay.now().format(context));

                    //   controller.saveMessageToConversation(
                    //       aimsg, widget.tutor.uniqueTutorID);
                    //   controller.messageCount.value = 0;
                    // }
                  }
                },
              ),
            ),
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (_messageController.text.isNotEmpty) {
                  var messageText = _messageController.text;
                  InterstitialAdClass.count += 1;
                  if (InterstitialAdClass.interstitialAd != null &&
                      InterstitialAdClass.count >=
                          InterstitialAdClass.totalLimit) {
                    InterstitialAdClass.showInterstitialAd(context);
                    InterstitialAdClass.count = 0;
                  }
                  _messageController.clear();
                  var message = controller.createMessageObject(
                    widget.tutor.userName, // The sender
                    messageText, // The message content
                    false, // Assuming it's sent by Umair (you)
                    TimeOfDay.now().format(context), // The time
                  );
                  controller.saveMessageToConversation(
                      message, widget.tutor.uniqueTutorID);

                  // Increment the message counter
                  controller.messageCount++;
                  controller.scrollToBottom(scrollController);
                  await controller.askQuestion(
                      context,
                      messageText,
                      widget.tutor.uniqueTutorID,
                      widget.tutor,
                      scrollController,
                      ttsController);
                  controller.scrollToBottom(scrollController);

                  log("mesage cpunter is now ${controller.messageCount}");

                  // Add the static AI message after every 5–6 messages
                  // if (controller.messageCount % 5 == 0) {
                  //   var aimsg = controller.createMessageObject(
                  //     "Bot",
                  //     controller.premiumMessage,
                  //     true,
                  //     TimeOfDay.now().format(context),
                  //   );

                  //   controller.saveMessageToConversation(
                  //       aimsg, widget.tutor.uniqueTutorID);
                  //   controller.messageCount.value = 0;
                  // }
                } else {
                  showToast(
                    context,
                    "Message Cannot be empty",
                  );
                }
              },
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      color: mainClr, borderRadius: BorderRadius.circular(12)),
                  child: SvgPicture.asset("assets/tutorIcons/send.svg")),
            )
          ],
        ),
      ),
    );
  }

  Widget appBarWidget(Size mq, BuildContext context) {
    return Container(
      // height: 150,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      // color: black.withOpacity(0.7),
      decoration: BoxDecoration(gradient: mainGraient),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      // decoration: BoxDecoration(
                      //     color: grey.withOpacity(0.7),
                      //     borderRadius: BorderRadius.circular(100)),
                      child: const Center(
                          child: Icon(Icons.arrow_back, color: white))),
                ),
                SizedBox(
                  width: mq.width * 0.03,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: widget.tutor.customAvatar != null
                            ? FileImage(File(widget.tutor.customAvatar!))
                            : AssetImage(widget.tutor.tutorAvatar),
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(
                  width: mq.width * 0.02,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Aboutscreen(
                            tutorModel: widget.tutor,
                            controller: chatController,
                          ),
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.tutor.tutorName,
                            style: const TextStyle(color: white, fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Online",
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromARGB(255, 98, 255, 103),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Obx(
                        () => Text(
                          chatController.isLoading.value
                              ? "typing..."
                              : "Tap for more info",
                          style: const TextStyle(color: white54, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PremiumScreen(isSplash: false),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white54)),
                child: const Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "👑",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "PRO",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(
      String sender, String message, bool isSender, String time) {
    // Premium message text for comparison
    String premiumMessage =
        "Hello ${widget.tutor.userName} 🌟 Ready to take your English skills to the next level? Unlock our premium plan for exclusive lessons, personalized feedback, and more! Let's make learning fun and effective together. What do you say? 📚✨";

    return Align(
      alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isSender)
            Container(
              margin: const EdgeInsets.only(right: 5, top: 10),
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: widget.tutor.customAvatar != null
                        ? FileImage(File(widget.tutor.customAvatar!))
                        : AssetImage(widget.tutor.tutorAvatar),
                    fit: BoxFit.cover,
                  )),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: mq.width * .75),
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: isSender ? mainGraient : null,
              color: (isSender ? mainClr.withValues(alpha: 1.0) : white),
              boxShadow: !isSender
                  ? [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          spreadRadius: 0.1,
                          offset: const Offset(0, 2)),
                    ]
                  : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                isSender
                    ? MarkDownText(
                        message: message,
                      )
                    : Text(
                        message,
                        style: TextStyle(
                            fontSize: 16, color: isSender ? white : black),
                      ),
                Divider(
                  endIndent: 0,
                  indent: 0,
                  height: 8,
                  thickness: 0.5,
                ),
                // Show button only for premium message
                if (message.contains(premiumMessage))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PremiumScreen(isSplash: false),
                              )); // Navigate to premium screen
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: white),
                          child: Shimmer.fromColors(
                            baseColor: Colors.black.withOpacity(1.0),
                            highlightColor: yellow.withOpacity(0.4),
                            period: const Duration(seconds: 2),
                            child: // Text and icon remain fully visible
                                const Text(
                              "Unlock Premium",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 3),
                if (isSender)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(fontSize: 12, color: white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                chatController.spekingMsg.value = '';
                                chatController.spekingMsg.value = message;
                                if (ttsController.isSpeaking.value) {
                                  ttsController.stop();
                                } else {
                                  ttsController
                                      .speak(chatController.spekingMsg.value);
                                }
                              },
                              child: SvgPicture.asset(
                                "assets/Icons/speak.svg",
                                height: mq.height * 0.045,
                                colorFilter:
                                    ColorFilter.mode(white, BlendMode.srcIn),
                              )),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: message));
                                // showToast(context, "Copied to clipboard");
                                CustomSnackbar.showSnackbar(
                                    "Copied to clipboard", SnackPosition.TOP);
                              },
                              child: SvgPicture.asset(
                                "assets/tutorIcons/copy.svg",
                                height: mq.height * 0.030,
                                colorFilter:
                                    ColorFilter.mode(white, BlendMode.srcIn),
                              )),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (!isSender)
            Container(
              margin: const EdgeInsets.only(left: 5, top: 10),
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: mainClr,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }

// Widget _buildMessageInputField() {
//   return Padding(
//     padding: const EdgeInsets.all(8),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: "Type your message...",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.send, color: Colors.blue),
//           onPressed: () {
//             // Add functionality to send a message
//           },
//         ),
//       ],
//     ),
//   );
// }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offset;

  CustomFloatingActionButtonLocation(this.offset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        16.0;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        offset;
    return Offset(fabX, fabY);
  }
}
