import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';

class PriceCardController extends GetxController {
  var selectedIndex = 0.obs; // Observing the selected index

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}

class PriceCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool highlight;
  final VoidCallback onPressed;

  final int index; // Store index of the PriceCard
  final Color? color;

  const PriceCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    this.highlight = false,
    required this.onPressed,
    required this.index,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    var controller =
        Get.put(PriceCardController()); // Get the controller instance

    return Obx(
      () => GestureDetector(
        onTap: () {
          onPressed(); // Call the onPressed callback when tapped
          controller
              .updateSelectedIndex(index); // Update selected index when tapped
        },
        child: Card(
          color: white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: mainClr),
                color:
                    controller.selectedIndex.value == index ? mainClr : white,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: controller.selectedIndex.value == index
                              ? white
                              : black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: mainClr,
                              fontSize: 18,
                              color: controller.selectedIndex.value == index
                                  ? white
                                  : black,
                            ),
                          ),
                          // SizedBox(width: 10),
                          // SvgPicture.asset(
                          //   "assets/Icons/arrowNext.svg",
                          //   height: 18,
                          //   color: controller.selectedIndex.value == index
                          //       ? white
                          //       : mainClr,
                          // ),
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
                          style: TextStyle(
                            color: controller.selectedIndex.value == index
                                ? white
                                : black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (highlight)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      ),
    );
  }
}
