import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenLimitService extends GetxController {
  RxInt usageCount = 10.obs; // Start with 10
  bool isPremium = false;
  final String featureName;
  static const int initialUsage = 10;

  TokenLimitService({required this.featureName}) {
    _loadUsageData();
  }

  String get usageCountKey => '${featureName}_usage_count';
  String get lastUsedTimestampKey => '${featureName}_last_used_timestamp';

  Future<void> _loadUsageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedUsageCount = prefs.getInt(usageCountKey) ?? initialUsage;
    int? lastUsedTimestamp = prefs.getInt(lastUsedTimestampKey);

    if (lastUsedTimestamp != null && _has24HoursPassed(lastUsedTimestamp)) {
      usageCount.value =
          initialUsage; // Reset the usage count to 10 if 24 hours have passed
      await _saveUsageData(initialUsage, DateTime.now().day);
      log("A day is passed and token were refreshed");
    } else {
      usageCount.value = savedUsageCount;
      log("remaining tokens ${usageCount.value}");
    }
  }

  bool _has24HoursPassed(int lastTimestamp) {
    int currentDay = DateTime.now().day;
    log("current : $currentDay and lasttime is : $lastTimestamp");
    if (currentDay != lastTimestamp) {
      return true;
    }
    return false;
  }

  Future<void> _saveUsageData(int count, int timestamp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(usageCountKey, count);
    await prefs.setInt(lastUsedTimestampKey, timestamp);
  }

  bool canUseFeature() {
    if (Subscriptioncontroller.isMonthlypurchased.value ||
        Subscriptioncontroller.isYearlypurchased.value) {
      log("premium usage");
      return true;
    }
    log("free usage");
    return usageCount.value > 0;
  }

  Future<void> useFeature() async {
    if (usageCount.value > 0) {
      usageCount.value--;
      await _saveUsageData(usageCount.value, DateTime.now().day);
    }
  }

  void navigateToPremiumScreen(BuildContext context) {
    if (usageCount.value <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Daily Limit Reached'),
            content: Text(
                'Upgrade to premium to get unlimited prompts and more features.'),
            actions: <Widget>[
              // TextButton(
              //   child: Text('Cancel'),
              //   onPressed: () {
              //     Navigator.of(context).pop(); // Close the dialog
              //   },
              // ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(mainClr)),
                  child: Text(
                    '👑 Buy Premium',
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Get.to(() => PremiumScreen(
                        isSplash: false)); // Navigate to the premium screen
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
