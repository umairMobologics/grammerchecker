import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';

class HeaderWidget extends StatelessWidget {
  double height;
  String text;
  HeaderWidget({super.key, required this.height, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      // clipper: MovieTicketClipper(),
      child: Container(
        color: mainClr,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: white,
                  size: height * .03,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * .027,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Get.to(() => PremiumScreen(
                        isSplash: false,
                      ));
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "👑",
                      style: TextStyle(fontSize: 25),
                    )),
              ),
              // IconButton(
              //     onPressed: () async {
              //       // FirebaseCourseServices.saveLevelToFirestore(
              //       //     level7, "level7");
              //     },
              //     icon: const Icon(
              //       Icons.add,
              //       color: Colors.red,
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
