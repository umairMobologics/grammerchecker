import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AdHelper.dart';

import '../../../main.dart';

class RewardedAdHelper {
  static RewardedAd? rewardedAd;
  static int attemptFailed = 0;

  /// Load the rewarded ad with timeout
  static Future<void> loadRewardedAd(
      {Duration timeout = const Duration(seconds: 10)}) async {
    final Completer<void> completer = Completer();

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          attemptFailed = 0;
          rewardedAd = ad;
          log("Rewarded ad loaded successfully");
          completer.complete();
        },
        onAdFailedToLoad: (err) {
          attemptFailed++;
          debugPrint("Failed to load rewarded ad: ${err.message}");
          rewardedAd = null;
          completer.complete();
        },
      ),
    );

    // Wait for the ad to load or timeout
    await completer.future.timeout(timeout, onTimeout: () {
      debugPrint("Ad loading timed out");
    });
  }

  /// Show the rewarded ad
  static Future<void> showRewardedAd({
    required BuildContext context,
    required VoidCallback onRewardEarned,
    VoidCallback? onAdFailedToLoad,
    VoidCallback? onAdDismissed,
  }) async {
    if (!Subscriptioncontroller.isMonthlypurchased.value &&
        !Subscriptioncontroller.isYearlypurchased.value) {
      // Show a loading indicator while waiting for the ad
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Check if the ad is already loaded, if not, try to load it
      if (rewardedAd == null && attemptFailed < 3) {
        log("attenot faild $attemptFailed");
        await loadRewardedAd();
      } else {
        log("failded attempt reached");
      }

      // Dismiss the loading dialog
      Navigator.of(context).pop();

      // If the ad is ready, show it
      if (rewardedAd != null) {
        rewardedAd!.show(
          onUserEarnedReward: (ad, reward) {
            debugPrint("User earned reward: ${reward.amount}");
            onRewardEarned();
          },
        );

        rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            debugPrint("Ad dismissed");
            rewardedAd = null;
            // onAdDismissed?.call();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            debugPrint("Ad failed to show: ${error.message}");
            rewardedAd = null;
            // onAdFailedToLoad?.call();
          },
        );
      } else {
        // If ad is not available, execute fallback logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Ad not available. Please try again later")),
        );
      }
    } else {
      log("premium subscribe go On without ad ****");
      onRewardEarned();
    }
  }
}
