import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:grammer_checker_app/utils/colors.dart';


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
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
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


 Widget buttontext(mq)
 {

 return Text(
            "generate".tr,
            style: customTextStyle(
                fontSize: mq.height * 0.025,
                color: white,
                fontWeight: FontWeight.bold),
          );
 }