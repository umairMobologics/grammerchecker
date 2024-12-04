import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/Controllers/globalVariablrController.dart';
import 'package:grammer_checker_app/View/Screens/Features/AskAi.dart';
import 'package:grammer_checker_app/View/Screens/Features/Corrector.dart';
import 'package:grammer_checker_app/View/Screens/Features/ParaphraseScreen.dart';
import 'package:grammer_checker_app/View/Screens/Features/Translator.dart';
import 'package:grammer_checker_app/View/Screens/Homepage.dart';
import 'package:grammer_checker_app/View/Screens/InAppSubscription/PremiumFeatureScreen.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AdHelper.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/AppOpenAdManager.dart';
import 'package:grammer_checker_app/core/Helper/AdsHelper/app_lifecycle_reactor.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:grammer_checker_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

RxInt page = 2.obs;

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  late AppLifecycleReactor _appLifecycleReactor;
  var gv = Get.put(Globlevariable()); // Initialize controller
  Future<void> saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');
  }

  List widgets = [
    const AskAIScreen(),
    const ParaphrasesScreen(),
    const Homepage(),
    const CorrectorScreen(),
    const TranslatorScreen(),
  ];
  static List pagesname = [
    'ASk AI screen',
    'Paraphraser Screen',
    'Homepage',
    'Corrector Screen',
    'Translator Screen'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    void changeLanguage(Locale locale) {
      Get.updateLocale(locale);
      saveLocale(locale);
    }

    var mq = MediaQuery.of(context).size;
    return PopScope(
      onPopInvoked: (didPop) {
        if (page.value != 2) {
          page.value = 2;
        }
      },
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SvgPicture.asset("assets/appbarTitle.svg",
              height: mq.height * 0.035),
          actions: [
            SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Get.to(() => PremiumScreen(
                      isSplash: false,
                    ));
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "👑",
                    style: TextStyle(fontSize: 25),
                  )),
            ),
            PopupMenuButton<Locale>(
              onSelected: (Locale locale) {
                InterstitialAdClass.count += 1;
                if (InterstitialAdClass.count ==
                        InterstitialAdClass.totalLimit &&
                    (!Subscriptioncontroller.isMonthlypurchased.value &&
                        !Subscriptioncontroller.isYearlypurchased.value)) {
                  InterstitialAdClass.showInterstitialAd(context);
                }

                changeLanguage(locale);
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: Locale('en', 'US'),
                    child: Text('English (US)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('ur', 'Pk'),
                    child: Text('Urdu (Pakistan)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('es', 'ES'),
                    child: Text('Spanish (Spain)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('zh', 'CN'),
                    child: Text('Chinese (China)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('ja', 'JP'),
                    child: Text('Japanese (Japan)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('de', 'DE'),
                    child: Text('German (Germany)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('fr', 'FR'),
                    child: Text('French (France)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('pt', 'PT'),
                    child: Text('Portuguese (Portugal)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('it', 'IT'),
                    child: Text('Italian (Italy)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('ar', 'SA'),
                    child: Text('Arabic (Saudi Arabia)'),
                  ),
                  const PopupMenuItem(
                    value: Locale('nl', 'NL'),
                    child: Text('Dutch (Netherlands)'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Obx(() => widgets[page.value]),
        backgroundColor: white,
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: (mq.height * 0.010),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 16.0,
                  color: const Color.fromARGB(255, 194, 200, 244)
                      .withOpacity(0.10),
                ),
              ],
            ),
            child: Material(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              color: mainClr,
              elevation: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),

                // clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Obx(
                  () => BottomNavigationBar(
                    onTap: !gv.isLoading.value
                        ? (tabIndex) async {
                            InterstitialAdClass.count += 1;
                            if (InterstitialAdClass.count ==
                                    InterstitialAdClass.totalLimit &&
                                (!Subscriptioncontroller
                                        .isMonthlypurchased.value &&
                                    !Subscriptioncontroller
                                        .isYearlypurchased.value)) {
                              InterstitialAdClass.showInterstitialAd(context);
                            }
                            log('current selected index $tabIndex');
                            page.value = tabIndex;

                            FirebaseAnalytics.instance.logEvent(
                                name: 'Pages_tracked',
                                parameters: {
                                  "Page name ": pagesname[tabIndex],
                                  "page index": tabIndex
                                }).then(
                              (value) {
                                log("Event sent Successfully ***********");
                              },
                            );
                          }
                        : null,
                    currentIndex: page.value,
                    selectedItemColor: mainClr,
                    unselectedItemColor: grey,
                    showUnselectedLabels: true,
                    items: [
                      BottomNavigationBarItem(
                        icon: page.value != 0
                            ? SvgPicture.asset(
                                "assets/Icons/askaiDark.svg",
                                height: mq.height * 0.038,
                              )
                            : SvgPicture.asset("assets/Icons/askai.svg",
                                height: mq.height * 0.038),
                        label: "ask".tr,
                      ),
                      BottomNavigationBarItem(
                        icon: page.value != 1
                            ? SvgPicture.asset(
                                "assets/Icons/writerDark.svg",
                                height: mq.height * 0.038,
                              )
                            : SvgPicture.asset("assets/Icons/writer.svg",
                                height: mq.height * 0.038),
                        label: "paraphrase".tr,
                      ),
                      BottomNavigationBarItem(
                        icon: page.value != 2
                            ? SvgPicture.asset(
                                "assets/Icons/homeDark.svg",
                                height: mq.height * 0.038,
                              )
                            : SvgPicture.asset("assets/Icons/home.svg",
                                height: mq.height * 0.038),
                        label: "home".tr,
                      ),
                      // BottomNavigationBarItem(
                      //   icon: Icon(EvaIcons.clockOutline),
                      //   label: "Recent",
                      // ),
                      BottomNavigationBarItem(
                        icon: page.value != 3
                            ? SvgPicture.asset(
                                "assets/Icons/correctorDark.svg",
                                height: mq.height * 0.038,
                              )
                            : SvgPicture.asset("assets/Icons/corrector.svg",
                                height: mq.height * 0.038),
                        label: "corrector".tr,
                      ),
                      BottomNavigationBarItem(
                        icon: page.value != 4
                            ? SvgPicture.asset(
                                "assets/Icons/translatorDark.svg",
                                height: mq.height * 0.038,
                              )
                            : SvgPicture.asset("assets/Icons/translator.svg",
                                height: mq.height * 0.038),
                        label: "translator".tr,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
