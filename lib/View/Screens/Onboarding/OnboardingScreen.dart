import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/controllers/OnBoardingController.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
import 'package:grammer_checker_app/utils/rippleEffect.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  final List<String> images = [
    "assets/ob1.svg",
    "assets/ob2.svg",
    "assets/ob3.svg",
  ];

  final List<String> titles = [
    "ob1",
    "ob2",
    "ob3",
  ];

  final List<String> descriptions = [
    "obdes1",
    "obdes2",
    "obdes3",
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    PageController pageController = PageController();

    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              onPageChanged: (index) =>
                  controller.onPageChanged(index, images.length),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(images[index]),
                  ],
                );
              },
            ),
          ),
          Container(
            height: size.height * 0.35,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400, // Shadow color with opacity
                    spreadRadius: 1, // Spread radius
                    blurRadius: 20, // Blur radius
                    offset:
                        const Offset(0, -3), // Offset in the x and y direction
                  ),
                ],
                color: white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.03),
                  child: Obx(
                    () => Column(
                      children: [
                        Text(
                            textAlign: TextAlign.center,
                            titles[controller.currentPage.value].tr,
                            style: customTextStyle(
                                fontSize: size.height * 0.024,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          child: Text(
                            textAlign: TextAlign.center,
                            descriptions[controller.currentPage.value].tr,
                            style:
                                customTextStyle(fontSize: size.height * 0.020),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      effect: const WormEffect(
                        activeDotColor: mainClr,
                        dotColor: Colors.grey,
                        dotHeight: 8,
                        dotWidth: 16,
                        // type: WormType.underground,
                      ),
                    ),
                    Obx(
                      () => RippleEffect(
                        borderRadius: BorderRadius.circular(12),
                        rippleColor: grey,
                        onTap: controller.isLastPage.value
                            ? controller.goToHome
                            : () => controller.nextPage(
                                pageController, images.length),
                        child: Ink(
                          padding: const EdgeInsets.all(18),
                          width: size.width * 0.23,
                          decoration: BoxDecoration(
                              color: mainClr,
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(
                            controller.isLastPage.value
                                ? Icons.done
                                : Icons.arrow_forward_ios,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    super.key,
    required this.image1,
    required this.title1,
    required this.des1,
  });

  final String image1;
  final String title1;
  final String des1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(image1),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                  textAlign: TextAlign.center,
                  title1,
                  style: customTextStyle(
                      fontSize: size.height * 0.024,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: size.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Text(
                  textAlign: TextAlign.center,
                  des1,
                  style: customTextStyle(fontSize: size.height * 0.020),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.05,
        )
      ],
    );
  }
}
