import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/customTextStyle.dart';

class featureCard extends StatelessWidget {
  const featureCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.SmallSize,
  });

  final bool SmallSize;
  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Expanded(
      child: FadeIn(
        duration: Duration(seconds: 3),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Ink(
            height: 130,
            // width: 2,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 3), // Shadow only at the bottom
                  ),
                ],
                color: white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: mainClr)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(height: mq.height * 0.077, child: icon),
                Expanded(
                  flex: 0,
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: customTextStyle(
                          fontSize: mq.height * 0.022,
                          fontWeight: FontWeight.bold,
                          color: black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
