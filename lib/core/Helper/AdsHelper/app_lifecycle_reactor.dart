import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/main.dart';

import 'AdHelper.dart';
import 'AppOpenAdManager.dart';

RxBool shouldShowOpenAd = true.obs; // Flag to control ad display

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    if (appState == AppState.foreground) {
      if (shouldShowOpenAd.value &&
          InterstitialAdClass.isInterAddLoaded.value == false &&
          (!(Subscriptioncontroller.isMonthlypurchased.value ||
              Subscriptioncontroller.isYearlypurchased.value))) {
        log("ad is going to be shown $shouldShowOpenAd");
        appOpenAdManager.showAdIfAvailable();
      }
    }
  }
}
