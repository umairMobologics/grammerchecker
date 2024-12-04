import 'dart:developer';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Controllers/InAppPurchases/inappPurchaseController.dart';
import 'package:grammer_checker_app/Controllers/QuizController/QuizController.dart';
import 'package:grammer_checker_app/View/Screens/SplashScreen.dart';
import 'package:grammer_checker_app/core/Helper/RemoteConfig/remoteConfigs.dart';
import 'package:grammer_checker_app/core/Helper/checkInternetConnectivity.dart';
import 'package:grammer_checker_app/core/Localization/Languages.dart';
import 'package:grammer_checker_app/core/localNotificationServices/AwesomeNotifications.dart';
// import 'package:grammer_checker_app/firebase_options.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:grammer_checker_app/core/utils/customTextStyle.dart';
import 'package:grammer_checker_app/firebase_options.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Locale?> getSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');
  String? countryCode = prefs.getString('countryCode');

  if (languageCode != null && countryCode != null) {
    return Locale(languageCode, countryCode);
  }
  return null;
}

final StartQuizController quizController =
    Get.put(StartQuizController(), permanent: true);
final liveInternet = Get.put(NetworkController(), permanent: true);
InAppPurchaseController Subscriptioncontroller =
    Get.put(InAppPurchaseController(InAppPurchase.instance), permanent: true)
      ..initialize();

// import 'package:shared_preferences/shared_preferences.dart';
int? initScreen;
var isSelectable = false.obs;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
//for getting languages
  Locale? savedLocale = await getSavedLocale();

  //local notification
  await AwesomeNotificationServices.notificationConfiguration();
  // final NotificationService notificationService = NotificationService();
  // await notificationService.initNotification();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  await Subscriptioncontroller.restorePurchases();

//crashlytics and analytics

  //remote configurations
  try {
    RemoteConfig.initConfig();
  } catch (e) {
    log("got some error");
  }
  //analytics
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // set observer
  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  //crashlytics
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((v) {
    // runApp(
    //   DevicePreview(
    //       enabled: !kReleaseMode,
    //       builder: (context) => MyApp(savedLocale: savedLocale)),
    // ); // Wrap your app

    runApp(MyApp(savedLocale: savedLocale));
  });
}

class MyApp extends StatefulWidget {
  final Locale? savedLocale;
  const MyApp({super.key, this.savedLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    @override
    void initState() {
      super.initState();
      DependencyInjection.init();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        locale: widget.savedLocale ?? Get.deviceLocale,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        // locale: const Locale('zh', 'Pk'),
        translations: Languages(), // This provides the translations
        fallbackLocale:
            const Locale('en', 'US'), // This sets the fallback locale
        title: "Ai Grammar Checker",
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(0.82)),
            child: child!,
          );
        },
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              // centerTitle: true,
              backgroundColor: mainClr,
              iconTheme: const IconThemeData(color: white),
              // backgroundColor: white,

              elevation: 2,
              titleTextStyle: customTextStyle(
                color: white,
                fontSize: MediaQuery.of(context).size.height * 0.030,
                fontWeight: FontWeight.w500,
              )),
        ),
        //   initialRoute: initScreen == 0 || initScreen == null ? "onboard" : "home",
        //   routes: {
        //     "home": (context) => const SplashScreen(),
        //     "onboard": (context) => OnboardingScreen(),
        //   },
        // );

        home: SplashScreen());
  }
}
