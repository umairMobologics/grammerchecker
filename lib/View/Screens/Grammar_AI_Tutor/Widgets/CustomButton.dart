import 'package:flutter/material.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

import '../../../../core/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double? width;
  const CustomButton({super.key, required this.text, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 0,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: mainGraient,
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromARGB(255, 0, 0, 0).withAlpha(60),
        //     blurRadius: 6.0,
        //     spreadRadius: 0.0,
        //     offset: const Offset(
        //       0.0,
        //       3.0,
        //     ),
        //   ),
        // ],
        borderRadius: BorderRadius.circular(20),
        color: color ?? white,
      ),
      child: Text(
        textAlign: TextAlign.center,
        text,
        style: TextStyle(
            color: color ?? white, fontSize: 16.h, fontWeight: FontWeight.bold),
      ),
    );
  }
}
