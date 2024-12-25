import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

TextStyle customTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  TextDecoration? decoration,
  double? letterSpacing,
  double? wordSpacing,
  TextDecorationStyle? decorationStyle,
  TextBaseline? textBaseline,
  Color? backgroundColor,
  double? height,
}) {
  return TextStyle(
    color: color ?? black,
    fontSize: fontSize ?? 17.h,
    fontWeight: fontWeight ?? FontWeight.normal,
    fontStyle: fontStyle,
    decoration: decoration,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decorationStyle: decorationStyle,
    textBaseline: textBaseline,
    backgroundColor: backgroundColor,
    height: height,
  );
}

Widget buttontext(mq) {
  return Text(
    "generate".tr,
    style: customTextStyle(
        fontSize: mq.height * 0.025, color: white, fontWeight: FontWeight.bold),
  );
}
