import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/utils/colors.dart';

class HeaderWidget extends StatelessWidget {
  double height;
  String text;
  HeaderWidget({super.key, required this.height, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      // clipper: MovieTicketClipper(),
      child: Container(
        width: double.infinity,
        height: height * .11,
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
              //       DatabaseHelper().clearTable("vocabulary");
              //       FetchQuizDataController().refreshQuizData();
              //     },
              //     icon: const Icon(
              //       Icons.delete,
              //       color: Colors.red,
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
