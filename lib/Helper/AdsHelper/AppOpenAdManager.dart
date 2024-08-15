import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'AdHelper.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  static RxBool isOpenAdLoaded = false.obs;

  static bool isLoaded = false;

  void loadAd() {
    AppOpenAd.load(

      adUnitId: AdHelper.openAppAd,
      // orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {

          _appOpenAd = ad;
          isLoaded = true;
          log("openapp ad is loaded");
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      loadAd();
      return;
    }
    isOpenAdLoaded.value = true;
    log("open ad show is : ${isOpenAdLoaded.value}");
    InterstitialAdClass.count=0;
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        isOpenAdLoaded.value = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
       
        isOpenAdLoaded.value = false;
         log("open ad show is failed : ${isOpenAdLoaded.value}");
        ad.dispose();
        _appOpenAd = null;
         loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        // Provider.of<WidgetProvider>(context, listen: false)
        //     .toggleOpenAppAdToFalse();
        isOpenAdLoaded.value = false;
         log("open ad show is dismissed : ${isOpenAdLoaded.value}");
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }

}

