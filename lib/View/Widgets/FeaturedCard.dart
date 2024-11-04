import 'package:flutter/material.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';

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
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          color: white,
          shadowColor: mainClr,
          child: Container(
            height: 130,
            // width: 2,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: mainClr)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(height: mq.height * 0.08, child: icon),
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
