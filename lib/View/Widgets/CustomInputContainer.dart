import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';

final FocusNode focusNode = FocusNode();

class CustomInputContainer extends StatefulWidget {
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onMicPressed;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onSubmitted;
  // ignore: prefer_typing_uninitialized_variables
  final textController;
  final String hintText;

  const CustomInputContainer({
    super.key,
    this.onGalleryPressed,
    this.onCameraPressed,
    this.onMicPressed,
    this.onCopyPressed,
    this.textController,
    required this.hintText,
    this.onSubmitted,
  });

  @override
  State<CustomInputContainer> createState() => _CustomInputContainerState();
}

class _CustomInputContainerState extends State<CustomInputContainer> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        } else {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 2,
        shadowColor: mainClr,
        child: Container(
          height: mq.height * 0.30,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: mainClr),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Expanded(
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: widget.textController.charCount.value > 0
                              ? const EdgeInsets.only(top: 15)
                              : const EdgeInsets.all(0),
                          child: TextField(
                            focusNode: focusNode,
                            maxLines: 8,
                            minLines: 1,

                            // onSubmitted: textController.updateText,
                            onChanged: (value) {
                              // widget.textController.updateText(value);
                              if (value.length > 1000) {
                                widget.textController.controller.value.text =
                                    value.substring(0, 1000);
                              }

                              value.length < 1000
                                  ? widget.textController.charCount.value =
                                      value.length
                                  : widget.textController.charCount.value =
                                      1000;
                            },
                            controller: widget.textController.controller.value,
                            // TextEditingController.fromValue(
                            //   TextEditingValue(
                            //     text: widget.textController.text.value.text,
                            //     selection: TextSelection.collapsed(
                            //         offset:
                            //             widget.textController.text.value.text.length),
                            //   ),
                            // ),

                            onSubmitted: (value) {
                              !widget.textController.isloading.value
                                  ? () {
                                      widget.textController.sendQuery(context);
                                    }
                                  : () {};
                            },
                            decoration: InputDecoration(
                              hintText: widget.hintText.tr,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Obx(
                          () => widget.textController.controller.value.text
                                      .length >
                                  0
                              ? Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: widget.textController.clearText,
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: white,
                                      child: Icon(Icons.cancel_outlined,
                                          color: black),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.onGalleryPressed != null)
                        InkWell(
                          onTap: widget.onGalleryPressed,
                          child: SvgPicture.asset(
                            "assets/Icons/gallery.svg",
                            height: mq.height * 0.045,
                          ),
                        ),
                      if (widget.onGalleryPressed != null)
                        SizedBox(width: mq.width * 0.01),
                      if (widget.onCameraPressed != null)
                        InkWell(
                          onTap: widget.onCameraPressed,
                          child: SvgPicture.asset(
                            "assets/Icons/camera.svg",
                            height: mq.height * 0.045,
                          ),
                        ),
                      if (widget.onCameraPressed != null)
                        SizedBox(width: mq.width * 0.01),
                      if (widget.onMicPressed != null)
                        InkWell(
                          onTap: widget.onMicPressed,
                          child: Obx(() => widget
                                  .textController.isListening.value
                              ? AvatarGlow(
                                  animate:
                                      widget.textController.isListening.value,
                                  glowColor: mainClr,
                                  // endRadius: 75.0,
                                  // glowBorderRadius: BorderRadius.circular(75),
                                  duration: const Duration(milliseconds: 2000),
                                  // repeatPauseDuration: const Duration(milliseconds: 100),

                                  repeat: true,
                                  child: SvgPicture.asset(
                                    "assets/Icons/mic.svg",
                                    height: mq.height * 0.045,
                                  ))
                              : SvgPicture.asset(
                                  "assets/Icons/mic.svg",
                                  height: mq.height * 0.045,
                                )),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(
                        () => Text(
                          '${widget.textController.charCount.value}/1000',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: mq.width * 0.01),
                      InkWell(
                        onTap: widget.onCopyPressed ?? () {},
                        child: SvgPicture.asset(
                          "assets/Icons/copy.svg",
                          height: mq.height * 0.045,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOutputContainer extends StatefulWidget {
  const CustomOutputContainer(
      {super.key,
      this.textController,
      this.ttsController,
      this.onSpeak,
      this.onCopy});
  // ignore: prefer_typing_uninitialized_variables
  final textController;
  // ignore: prefer_typing_uninitialized_variables
  final ttsController;
  final VoidCallback? onSpeak;
  final VoidCallback? onCopy;

  @override
  State<CustomOutputContainer> createState() => _CustomOutputContainerState();
}

class _CustomOutputContainerState extends State<CustomOutputContainer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      shadowColor: mainClr,
      child: Container(
        height: mq.height * 0.3,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: mainClr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SizedBox(
                  height: mq.height * 0.20,
                  //  color: red,
                  child: Obx(
                    () => isSelectable.value
                        ? SelectableText(
                            widget.textController.outputText.value,
                            style: customTextStyle(
                              color: Colors.black,
                              fontSize: mq.height * 0.020,
                            ),
                          )
                        : NotificationListener<ScrollMetricsNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.extentAfter > 12) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear,
                                );
                              }
                              return true;
                            },
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              child: AnimatedTextKit(
                                key: ValueKey<bool>(
                                    widget.textController.isresultLoaded.value),
                                repeatForever: true,
                                displayFullTextOnTap: true,
                                isRepeatingAnimation: false,
                                onTap: () {
                                  isSelectable.value = true;
                                },
                                animatedTexts: [
                                  TyperAnimatedText(
                                    widget.textController.isresultLoaded.value
                                        ? widget.textController.outputText.value
                                        : "",
                                    textStyle: customTextStyle(
                                      color: Colors.black,
                                      fontSize: mq.height * 0.020,
                                    ),
                                    speed: const Duration(milliseconds: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    Obx(
                      () => InkWell(
                          onTap: widget.onSpeak,
                          child: widget.ttsController != null
                              ? widget.ttsController.isSpeaking.value
                                  ? AvatarGlow(
                                      glowColor: mainClr,
                                      // endRadius: 75.0,
                                      glowRadiusFactor: 0.3,
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      // repeatPauseDuration: const Duration(milliseconds: 100),

                                      repeat: true,
                                      child: SvgPicture.asset(
                                        "assets/Icons/speak.svg",
                                        height: mq.height * 0.045,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      "assets/Icons/speak.svg",
                                      height: mq.height * 0.045,
                                    )
                              : null),
                    ),
                    SizedBox(width: mq.width * 0.04),
                    Obx(() => widget.ttsController != null
                        ? widget.ttsController.isSpeaking.value
                            ? InkWell(
                                onTap: () {
                                  widget.ttsController.stop();
                                },
                                child: Icon(
                                  Icons.stop,
                                  color: red,
                                  size: mq.height * 0.030,
                                ))
                            : const SizedBox()
                        : const SizedBox())
                  ],
                ),
                SizedBox(width: mq.width * 0.01),
                InkWell(
                  onTap: widget.onCopy ?? () {},
                  child: SvgPicture.asset(
                    "assets/Icons/copy.svg",
                    height: mq.height * 0.045,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
