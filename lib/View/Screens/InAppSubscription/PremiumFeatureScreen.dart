// import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/Controllers/InAppPurchases/inappPurchaseController.dart';
import 'package:grammer_checker_app/Controllers/PremiumFeatureController.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/SubscriptionInfoScreen.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumScreen extends StatefulWidget {
  final bool isSplash;
  const PremiumScreen({super.key, required this.isSplash});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  InAppPurchaseController controller =
      Get.put(InAppPurchaseController(InAppPurchase.instance));
  final premiumC = Get.put(PremiumFeatureController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: mq.height * 0.35,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255), // White shade
                      mainClr,
                    ],
                  ),
                  // image: DecorationImage(
                  //     image: AssetImage("assets/ob1.png"), fit: BoxFit.cover),
                ),
                child: SafeArea(
                  child: Stack(
                    // alignment: Alignment.center,
                    children: [
                      CarouselSlider(
                          items: [
                            SvgPicture.asset("assets/ob1.svg"),
                            SvgPicture.asset("assets/ob2.svg"),
                            SvgPicture.asset("assets/ob3.svg"),
                          ],
                          options: CarouselOptions(
                            height: mq.height * 0.2,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.5,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1200),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.45,
                            // onPageChanged: callbackFunction,
                            scrollDirection: Axis.horizontal,
                          )),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              if (widget.isSplash) {
                                Get.off(() => BottomNavBarScreen());
                              } else {
                                Get.back();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: white),
                                  child: Icon(Icons.close, color: Colors.red)),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Upgrade to Premium & Get",
                              style: TextStyle(
                                  fontSize: mq.height * 0.025,
                                  color: mainClr,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Unlimited Access",
                              style: TextStyle(
                                  fontSize: mq.height * 0.030,
                                  color: black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      white,
                      Color.fromARGB(255, 255, 255, 255), // White shade
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      CarouselSlider(
                          items: [
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/Icons/askai.svg",
                              title: "Ask AI",
                              content: "Ask Ai everything",
                            ),
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/Icons/noAds.svg",
                              title: "No Ads",
                              content: "100% ad free experience",
                            ),
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/Icons/corrector.svg",
                              title: "Correct",
                              content: "Correct your grammer ",
                            ),
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/Icons/translator.svg",
                              title: "Translate",
                              content: "Translate to  languages",
                            ),
                          ],
                          options: CarouselOptions(
                            height: mq.height * 0.15,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.5,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1200),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            // onPageChanged: callbackFunction,
                            scrollDirection: Axis.horizontal,
                          )),
                      SizedBox(height: mq.height * 0.02),
                      Obx(
                        () => !controller.isloaded.value
                            ? controller.productDetailsList.isNotEmpty
                                ? Column(
                                    children: [
                                      PlanWidget(
                                        onPressed: () {
                                          String selectedPlan = controller
                                              .productDetailsList[0].id;
                                          if (selectedPlan.isNotEmpty) {
                                            if (selectedPlan ==
                                                    "grammarchecker_monthly" &&
                                                !controller
                                                    .isMonthlypurchased.value) {
                                              controller.buy(selectedPlan);
                                            } else {
                                              CustomSnackbar.showSnackbar(
                                                  "You have already subscribed this plan",
                                                  SnackPosition.BOTTOM);
                                            }
                                          }
                                        },
                                        title: "Monthly Plan",
                                        price:
                                            "${controller.productDetailsList[0].currencyCode} " +
                                                controller.productDetailsList[0]
                                                    .price,
                                        description: controller
                                            .productDetailsList[0].title,
                                      ),
                                      SizedBox(height: mq.height * 0.01),
                                      Instruction(),
                                      SizedBox(height: mq.height * 0.01),
                                      PlanWidget(
                                        onPressed: () {
                                          String selectedPlan = controller
                                              .productDetailsList[1].id;
                                          if (selectedPlan.isNotEmpty) {
                                            if (selectedPlan ==
                                                    "grammarchecker_yearly" &&
                                                !controller
                                                    .isYearlypurchased.value) {
                                              controller.buy(selectedPlan);
                                            } else {
                                              CustomSnackbar.showSnackbar(
                                                  "You have already subscribed this plan",
                                                  SnackPosition.BOTTOM);
                                            }
                                          }
                                        },
                                        title: "Yearly Plan",
                                        price:
                                            "${controller.productDetailsList[1].currencyCode} " +
                                                controller.productDetailsList[1]
                                                    .price,
                                        description: controller
                                            .productDetailsList[1].title,
                                      ),
                                      SizedBox(height: mq.height * 0.01),
                                      Instruction(),
                                      SizedBox(height: mq.height * 0.01),
                                    ],
                                  )
                                : Center(child: Text(controller.data.value))
                            : Center(child: CircularProgressIndicator()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Get.to(() => SubscriptionInfoScreen());
                              },
                              child: Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  color: mainClr,
                                  fontSize: mq.height * 0.018,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          TextButton(
                            onPressed: () {
                              _launchURL(Uri.parse(
                                  "https://support.google.com/googleplay/answer/7018481?co=GENIE.Platform%3DAndroid&hl=en"));
                            },
                            child: Text(
                              "How to unsubscribe?",
                              style: TextStyle(
                                color: mainClr,
                                fontSize: mq.height * 0.018,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: mq.height * 0.01),
            ],
          ),
        ));
  }
}

class Instruction extends StatelessWidget {
  const Instruction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        SvgPicture.asset(
          "assets/Icons/arrowNext.svg",
          height: 15,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "Cancel anytime atleast 24 hours before renewal",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

void _launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String content;
  const FeatureCard({
    super.key,
    required this.mq,
    required this.iconPath,
    required this.title,
    required this.content,
  });

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: mainClr),
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(36, 33, 149, 243)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(8)),
            child: SvgPicture.asset(
              iconPath,
              height: 30,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class PremiumScreen extends StatelessWidget {
//   const PremiumScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.close, color: Colors.grey),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: size.height * 0.3,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                       'assets/ob1.png'), // Replace with your image asset
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Upgrade to Premium & Get',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Unlimited Access',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       FeatureWidget(
//                         icon: Icons.message,
//                         title: 'Messages',
//                         description: 'Ask AI anything',
//                       ),
//                       FeatureWidget(
//                         icon: Icons.block,
//                         title: 'No Ads',
//                         description: '100% Ads free Experience',
//                       ),
//                       FeatureWidget(
//                         icon: Icons.translate,
//                         title: 'Translation',
//                         description: 'Translate in 100+ languages',
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   PlanWidget(
//                     title: 'Weekly Plan',
//                     price: 'Free',
//                     description:
//                         '3 Days Free Trial. Rs 500.00/week after trial ends.\nCancel anytime atleast 24 hours before renewal',
//                   ),
//                   PlanWidget(
//                     title: 'Monthly Plan',
//                     price: 'Free',
//                     description:
//                         '3 Days Free Trial. Rs 1,600.00/month after trial ends.\nCancel anytime atleast 24 hours before renewal',
//                   ),
//                   PlanWidget(
//                     title: 'Life Time Plan',
//                     price: 'Rs 4,500.00',
//                     description: '',
//                     highlight: true,
//                   ),
//                   SizedBox(height: 20),
//                   TextButton(
//                     onPressed: () {
//                       // Add your functionality here
//                     },
//                     child: Text(
//                       'Terms and Services',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Add your functionality here
//                     },
//                     child: Text(
//                       'How to unSubscribe?',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class FeatureWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.green),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class PlanWidget extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool highlight;
  final VoidCallback onPressed;

  const PlanWidget({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    this.highlight = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: mainClr),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainClr,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        SvgPicture.asset(
                          "assets/Icons/arrowNext.svg",
                          height: 18,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                if (highlight)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Save 70%',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
