import 'package:flutter/material.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: () {
            pageController.previousPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear);
          },
          child: Ink(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              (Icons.arrow_back),
              color: black,
              size: 30,
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: () {
            Navigator.pop(context);
          },
          child: Ink(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              (Icons.cancel_sharp),
              color: black,
              size: 35,
            ),
          ),
        )
      ],
    );
  }
}
