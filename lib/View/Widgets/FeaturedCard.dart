import 'package:flutter/material.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';

class featureCard extends StatelessWidget {
  const featureCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.mq,
    required this.SmallSize,
  });
  final mq;
  final height;
  final width;
  final bool SmallSize;
  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: mainClr,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: mainClr)),
          child: SmallSize
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: icon),
                    // SizedBox(height: mq.height * 0.01),
                    Expanded(
                      flex: 0,
                      child: Text(
                        text,
                        style: customTextStyle(
                            fontSize: mq.height * 0.022,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.02),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: icon),
                    SizedBox(width: mq.width * 0.02),
                    Expanded(
                      flex: 0,
                      child: Center(
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
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
    );
  }
}
