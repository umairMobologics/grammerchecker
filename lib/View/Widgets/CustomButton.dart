import 'package:flutter/material.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.mq,
    required this.text,
    required this.ontap,
  });

  final Size mq;
  final Widget text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: ontap,
      child: Container(
        width: double.infinity,
        height: mq.height * 0.06,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: mainClr),
        child: Center(child: text),
      ),
    );
  }
}
