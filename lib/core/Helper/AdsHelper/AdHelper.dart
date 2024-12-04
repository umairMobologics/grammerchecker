import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// // Real Ids
// // Real Ids
// // Real Ids
// // Real Ids
// // Real Ids

class AdHelper {
  static String get interstitialAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9800935656438737/4892104414';
    } else if (Platform.isIOS) {
      return '';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get nativeAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9800935656438737/9589897329';
    } else if (Platform.isIOS) {
      return '';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get openAppAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9800935656438737/8533203626';
    } else if (Platform.isIOS) {
      return '';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get bannerAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9800935656438737/2836618845';
    } else if (Platform.isIOS) {
      return '';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get rewardedAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9800935656438737/2581555633';
    }
    // else if (Platform.isIOS) {
    //   return '';
    // }
    throw UnsupportedError("Unsupported platform");
  }
}

// //Test IDS
//Test IDS
//Test IDS
//Test IDS
// //Test IDS

// class AdHelper {
//   static String get CollapsableBanner {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/2014213617';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/2014213617';
//     }
//     throw UnsupportedError("Unsupported platform");
//   }

//   static String get interstitialAd {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/1033173712';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/4411468910';
//     }
//     throw UnsupportedError("Unsupported platform");
//   }

//   static String get nativeAd {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/2247696110';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/3986624511';
//     }
//     throw UnsupportedError("Unsupported platform");
//   }

//   static String get openAppAd {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/9257395921';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/5575463023';
//     }
//     throw UnsupportedError("Unsupported platform");
//   }

//   static String get bannerAd {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/6300978111';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/2934735716';
//     }
//     throw UnsupportedError("Unsupported platform");
//   }

//   static String get rewardedAd {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/5224354917';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/5224354917';
//     }
//     throw UnsupportedError("Unsupported platform");
//   }
// }

const int maxFailLoadAttempts = 3;

class InterstitialAdClass {
  static InterstitialAd? interstitialAd;
  static int _interstitialAdLoadAttempts = 0;
  static int count = 0;
  static int totalLimit = 3;
  static RxBool isInterAddLoaded = false.obs;

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          _interstitialAdLoadAttempts = 0;
          // log("interstitial ad is loaded , $count , $_interstitialAdLoadAttempts");
        },
        onAdFailedToLoad: (error) {
          _interstitialAdLoadAttempts += 1;
          interstitialAd = null;
          if (_interstitialAdLoadAttempts <= maxFailLoadAttempts) {
            // log("not loadedd, $_interstitialAdLoadAttempts");
            createInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd(BuildContext context) {
    if (interstitialAd != null) {
      isInterAddLoaded.value = true;
      InterstitialAdClass.count = 0;

      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        Future.delayed(const Duration(seconds: 1)).then((_) {
          InterstitialAdActive.isAdActiveNow = false;
          isInterAddLoaded.value = false;
        });
        InterstitialAdActive.isAdActiveNow = false;

        ad.dispose();
        createInterstitialAd();
      },

          // Update in the Code
          onAdShowedFullScreenContent: (ad) {
        // for checking InterstitialAd ads so that we can block app open add
        InterstitialAdActive.isAdActiveNow = true;
        isInterAddLoaded.value = true;
        // log("ad is showing ${isInterAddLoaded.value}");
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        isInterAddLoaded.value = false;
        ad.dispose();
        createInterstitialAd();
      });
      // log("show ad");
      interstitialAd!.show();
    }
  }
}

class InterstitialAdActive {
  static bool isAdActiveNow = false;
}
