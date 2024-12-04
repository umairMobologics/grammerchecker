import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/Controllers/TTS_Controller.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';

class CorrecterContainerBox extends StatelessWidget {
  final String originalText;
  final String outputText;
  final Widget icon;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onSpeakPressed;
  final VoidCallback? onSharePressed;
  final VoidCallback? onExplainPressed;

  final TextStyle style;
  final TTSController ttsController;

  const CorrecterContainerBox({
    super.key,
    required this.icon,
    this.onCopyPressed,
    this.onSpeakPressed,
    required this.ttsController,
    required this.style,
    required this.originalText,
    required this.outputText,
    this.onSharePressed,
    this.onExplainPressed,
  });

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final diff = calculateDifferences(originalText, outputText);

    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      shadowColor: mainClr,
      child: Container(
        height: mq.height * 0.35,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: mainClr),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: mq.height *
                        0.28, // Constrain the height to allow scrolling
                    child: SingleChildScrollView(
                      child: RichText(
                        text: TextSpan(
                          children: diff,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: mq.width * 0.02,
                ),
                icon
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    onSpeakPressed != null
                        ? Obx(
                            () => InkWell(
                                onTap: onSpeakPressed,
                                child: ttsController.isSpeaking.value
                                    ? AvatarGlow(
                                        glowColor: mainClr,
                                        glowRadiusFactor: 0.3,
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        repeat: true,
                                        child: SvgPicture.asset(
                                          "assets/Icons/speak.svg",
                                          height: mq.height * 0.040,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        "assets/Icons/speak.svg",
                                        height: mq.height * 0.040,
                                      )),
                          )
                        : const SizedBox(),
                    SizedBox(width: mq.width * 0.04),
                    onSpeakPressed != null
                        ? Obx(() => ttsController.isSpeaking.value
                            ? InkWell(
                                onTap: () {
                                  ttsController.stop();
                                },
                                child: Icon(
                                  Icons.stop,
                                  color: red,
                                  size: mq.height * 0.030,
                                ))
                            : const SizedBox())
                        : const SizedBox()
                  ],
                ),
                SizedBox(width: mq.width * 0.01),
                Row(
                  children: [
                    InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onExplainPressed ?? () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'See explanation',
                            style: TextStyle(color: mainClr),
                          ),
                        )),
                    onCopyPressed != null
                        ? InkWell(
                            onTap: onCopyPressed,
                            child: SvgPicture.asset(
                              "assets/Icons/copy.svg",
                              height: mq.height * 0.040,
                            ),
                          )
                        : const SizedBox(),
                    onSharePressed != null
                        ? InkWell(
                            onTap: onSharePressed,
                            child: SvgPicture.asset(
                              "assets/Icons/share.svg",
                              height: mq.height * 0.045,
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<TextSpan> calculateDifferences(String original, String corrected) {
  final originalWords = original.split(' ');
  final correctedWords = corrected.split(' ');

  List<TextSpan> spans = [];
  int i = 0;
  int j = 0;

  while (i < originalWords.length || j < correctedWords.length) {
    if (i < originalWords.length && j < correctedWords.length) {
      final originalWord = originalWords[i];
      final correctedWord = correctedWords[j];

      if (originalWord != correctedWord) {
        // spans.add(TextSpan(
        //   text: '$originalWord ',
        //   style: TextStyle(
        //     color: Colors.red,
        //     decoration: TextDecoration.lineThrough,
        //   ),
        // ));
        spans.add(TextSpan(
          text: '$correctedWord ',
          style: TextStyle(color: Colors.green),
        ));
        i++;
        j++;
      } else {
        spans.add(TextSpan(
          text: '$originalWord ',
          style: TextStyle(color: Colors.black),
        ));
        i++;
        j++;
      }
    } else if (i < originalWords.length) {
      // spans.add(TextSpan(
      //   text: '${originalWords[i]} ',
      //   style: TextStyle(
      //       color: Colors.red, decoration: TextDecoration.lineThrough),
      // ));
      i++;
    } else if (j < correctedWords.length) {
      spans.add(TextSpan(
        text: '${correctedWords[j]} ',
        style: TextStyle(color: Colors.green),
      ));
      j++;
    }
  }

  return spans;
}

Widget buildHighlightedText(String original, String corrected) {
  final originalWords = original.split(' ');
  final correctedWords = corrected.split(' ');

  List<TextSpan> spans = [];

  int i = 0;
  int j = 0;

  while (i < originalWords.length || j < correctedWords.length) {
    if (i < originalWords.length && j < correctedWords.length) {
      final originalWord = originalWords[i];
      final correctedWord = correctedWords[j];

      if (originalWord != correctedWord) {
        spans.add(TextSpan(
          text: '$originalWord ',
          style: TextStyle(
            color: Colors.red,
            decoration: TextDecoration.lineThrough,
          ),
        ));
        spans.add(TextSpan(
          text: '$correctedWord ',
          style: TextStyle(color: Colors.green),
        ));
      } else {
        spans.add(TextSpan(
          text: '$originalWord ',
          style: TextStyle(color: Colors.black),
        ));
        j++; // Move to the next word in corrected
      }

      i++; // Move to the next word in original
    } else if (j < correctedWords.length) {
      // Extra words in corrected
      spans.add(TextSpan(
        text: '${correctedWords[j]} ',
        style: TextStyle(color: Colors.green),
      ));
      j++;
    } else {
      // Extra words in original
      spans.add(TextSpan(
        text: '${originalWords[i]} ',
        style: TextStyle(
            color: Colors.red, decoration: TextDecoration.lineThrough),
      ));
      i++;
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: RichText(
      text: TextSpan(
        children: spans,
      ),
    ),
  );
}
