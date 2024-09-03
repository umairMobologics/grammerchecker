// import 'dart:developer';

// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:grammer_checker_app/Controllers/CorrectorController.dart';
// import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
// import 'package:grammer_checker_app/utils/colors.dart';
// import 'package:grammer_checker_app/utils/customTextStyle.dart';
// import 'package:grammer_checker_app/utils/sharetext.dart';
// import 'package:grammer_checker_app/utils/snackbar.dart';
// import 'package:in_app_review/in_app_review.dart';

// class CorrectorDetails extends StatefulWidget {
//   const CorrectorDetails(
//       {super.key, required this.mistaletext, required this.correctedText});
//   final String mistaletext;
//   final String correctedText;

//   @override
//   State<CorrectorDetails> createState() => _CorrectorDetailsState();
// }

// class _CorrectorDetailsState extends State<CorrectorDetails> {
//   final CorrectorController textController = Get.put(CorrectorController());
//   final InAppReview inAppReview = InAppReview.instance;
//   final TTSController ttsController = Get.put(TTSController());
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     Future.delayed(
//       Duration(seconds: 3),
//       () async {
//         if (await inAppReview.isAvailable()) {
//           inAppReview.requestReview();
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ttsController.stop();
//     });

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var mq = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: SvgPicture.asset("assets/appbarTitle.svg",
//             height: mq.height * 0.035),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: textController.isresultLoaded.value
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "corrections".tr,
//                                 style: customTextStyle(
//                                     fontSize: mq.height * 0.028,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Obx(() => textController
//                                       .outputText.value.isNotEmpty
//                                   ? InkWell(
//                                       onTap: () {
//                                         shareText(
//                                             textController.outputText.value);
//                                       },
//                                       child: SvgPicture.asset(
//                                           "assets/Icons/share.svg"))
//                                   : InkWell(
//                                       onTap: () {
//                                         showToast(context, "Nothing to share");
//                                       },
//                                       child: SvgPicture.asset(
//                                           "assets/Icons/share.svg")))
//                             ])),
//                     SizedBox(height: mq.height * 0.02),
//                     CustomContainerBox(
//                       icon: SvgPicture.asset(
//                         "assets/Icons/cross.svg",
//                         height: mq.height * 0.040,
//                       ),
//                       style: customTextStyle(fontSize: mq.height * 0.020),
//                       text: textController.parseAndStyleText(
//                           widget.mistaletext, Colors.red, Colors.black),
//                       ttsController: ttsController,
//                     ),
//                     SizedBox(
//                       height: mq.height * 0.02,
//                     ),
//                     CustomContainerBox(
//                       icon: SvgPicture.asset(
//                         "assets/Icons/true.svg",
//                         height: mq.height * 0.040,
//                       ),
//                       onCopyPressed: () {
//                         textController.outputText.value.isNotEmpty
//                             ? copyToClipboard(
//                                 context, textController.outputText.value)
//                             : log("message");
//                       },
//                       onSpeakPressed: () {
//                         if (widget.correctedText.isNotEmpty) {
//                           if (ttsController.isSpeaking.value) {
//                             ttsController.pause();
//                           } else {
//                             ttsController.speak(widget.correctedText);
//                           }
//                         } else {
//                           log("not text");
//                         }
//                       },
//                       style: customTextStyle(fontSize: mq.height * 0.020),
//                       text: textController.parseAndStyleText(
//                           widget.correctedText, Colors.green, Colors.black),
//                       ttsController: ttsController,
//                     )
//                   ],
//                 )
//               : const SizedBox(),
//         ),
//       ),
//     );
//   }
// }
