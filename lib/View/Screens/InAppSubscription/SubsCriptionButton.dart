import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/Controllers/InAppPurchases/PremiumFeatureController.dart';

import '../../../Controllers/InAppPurchases/inappPurchaseController.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/snackbar.dart';

class SubsCriptionButton extends StatelessWidget {
  const SubsCriptionButton({
    super.key,
    required this.controller,
    required this.premiumC,
    required this.mq,
  });

  final InAppPurchaseController controller;
  final PremiumFeatureController premiumC;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (controller.productDetailsList.isNotEmpty) {
            if (selectedPlan.isNotEmpty) {
              if (selectedPlan == "grammarchecker_weekly" &&
                  !controller.isWeeklypurchased.value) {
                controller.buy(selectedPlan.value);
              } else if (selectedPlan == "grammarchecker_monthly" &&
                  !controller.isMonthlypurchased.value) {
                controller.buy(selectedPlan.value);
              } else if (selectedPlan == "grammarchecker_yearly" &&
                  !controller.isYearlypurchased.value) {
                controller.buy(selectedPlan.value);
              } else {
                CustomSnackbar.showSnackbar(
                    "You have already subscribed this plan",
                    SnackPosition.BOTTOM);
              }
            } else {
              // Safely access the first item in the list
              final selectedProduct = controller.monthlyProduct != null
                  ? controller.monthlyProduct
                  : null;

              if (selectedProduct != null) {
                premiumC.changeSelectedPlan(selectedProduct.id);

                log("else Selected plan is ${selectedPlan}");
                if (selectedPlan == "grammarchecker_weekly" &&
                    !controller.isWeeklypurchased.value) {
                  controller.buy(selectedPlan.value);
                } else if (selectedPlan == "grammarchecker_monthly" &&
                    !controller.isMonthlypurchased.value) {
                  controller.buy(selectedPlan.value);
                } else if (selectedPlan == "grammarchecker_yearly" &&
                    !controller.isYearlypurchased.value) {
                  controller.buy(selectedPlan.value);
                } else {
                  CustomSnackbar.showSnackbar(
                      "You have already subscribed to this plan",
                      SnackPosition.BOTTOM);
                }
              }
            }
          }
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              // color: Color.fromARGB(255, 45, 194, 181),
              color: mainClr,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: mainClr)),
          child: Center(
              child: Text(
            selectedPlan.value == "grammarchecker_weekly" &&
                    controller.isWeeklypurchased.value
                ? "Subscribed"
                : selectedPlan.value == "grammarchecker_monthly" &&
                        controller.isMonthlypurchased.value
                    ? "Subscribed"
                    : selectedPlan.value == "grammarchecker_yearly" &&
                            controller.isYearlypurchased.value
                        ? "Subscribed"
                        : controller.isWeeklyFreeTrial.value
                            ? "Start Free Trial"
                            : controller.isMonthlyFreeTrial.value
                                ? "Start Free Trial"
                                : controller.isYearlyFreeTrial.value
                                    ? "Start Free Trial"
                                    : "Subscribe",
            style: TextStyle(
                color: white,
                fontSize: mq.height * 0.025,
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
