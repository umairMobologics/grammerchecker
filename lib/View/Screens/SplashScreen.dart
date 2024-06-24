import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/Controllers/SplashAnimation.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
         BannerAd? _anchoredAdaptiveAd;
  bool isLoaded = false;

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      log('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      // TODO: replace these test ad units with your own ad unit.
      adUnitId: AdHelper.bannerAd,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // log('$ad loaded: ');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            isLoaded = true;
          });
        },

        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // log('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  var animation = Get.put(
    SplashAnimation());
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
    animation.controller = AnimationController(
  /// [AnimationController]s can be created with `vsync: this` because of
  /// [TickerProviderStateMixin].
  vsync: this,
  duration: const Duration(seconds: 6),
)
  ..addListener(() {
    setState(() {});
  });
Timer(const Duration(seconds: 6), () {
  animation.splashScreenButtonShown.value = true;
});
animation.controller.repeat();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _anchoredAdaptiveAd!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          SizedBox(
            width: mq.width,
            height: mq.height,
            child: SvgPicture.asset(
              "assets/splashbg.svg",
              fit: BoxFit.cover,
            ),
          ),
          Center(child: SvgPicture.asset("assets/appName.svg")),
          // Positioned(
          //   bottom: mq.height*0.1,
          //   child: Container(height: mq.height*0.05,
          //   width: mq.width*0.30,
          //   decoration: BoxDecoration(color: mainClr,borderRadius: BorderRadius.circular(10),

          //   ),
          //   child: Center(child: Text("Start", style: customTextStyle(fontSize: mq.height*0.030,color: white,fontWeight: FontWeight.bold),)),

          //   ),
          // ),

          Positioned(
            bottom: mq.height * 0.1,
            child: Obx(
              () => InkWell(
                  onTap: () {
                              
                    if (InterstitialAdClass.interstitialAd!=null) {

                      InterstitialAdClass.showInterstitialAd(context);
                      InterstitialAdClass.count=0;
                    }
                                  Get.to(()=>const BottomNavBarScreen());
                  },
                  child: animation.splashScreenButtonShown.value
                      ? Container(
                          height: mq.height * 0.05,
                          width: mq.width * 0.30,
                          decoration: BoxDecoration(
                            color: mainClr,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            "start".tr,
                            style: customTextStyle(
                                fontSize: mq.height * 0.030,
                                color: white,
                                fontWeight: FontWeight.bold),
                          )),
                        )
                      : SizedBox(
                          height: mq.height * 0.01,
                          width: mq.width * 0.90,
                          child: LinearProgressIndicator(
                            value: animation.controller.value,
                            semanticsLabel: 'Linear progress indicator',
                            color: mainClr,
                          ),
                        )),
            ),
          )
        ],
      ),
      bottomNavigationBar: _anchoredAdaptiveAd != null && isLoaded && InterstitialAdClass.count !=
    InterstitialAdClass.totalLimit ?
  Container(
    decoration: BoxDecoration(
      // color: Colors.green,
      border: Border.all(
        color: Colors.deepPurpleAccent,
        width:0,
      )
    ),
    width: _anchoredAdaptiveAd!.size.width.toDouble(),
    height: _anchoredAdaptiveAd!.size.height.toDouble(),
    child: AdWidget(ad: _anchoredAdaptiveAd!),
  ) : null
    
    );
  }
}
