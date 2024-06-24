import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grammer_checker_app/Localization/Languages.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';
import 'package:grammer_checker_app/View/Screens/Onboarding/OnboardingScreen.dart';
import 'package:grammer_checker_app/firebase_options.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:grammer_checker_app/utils/customTextStyle.dart';
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

// import 'package:shared_preferences/shared_preferences.dart';
int? initScreen;
var isSelectable = false.obs;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
//for getting languages
  Locale? savedLocale = await getSavedLocale();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();

//crashlytics and analytics
 //analytics
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

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
    //   DevicePreview(  enabled: !kReleaseMode,
    // builder: (context) =>  MyApp(savedLocale: savedLocale)),
    // ); // Wrap your app

    runApp(MyApp(
      savedLocale: savedLocale,
    ));
  });
}

class MyApp extends StatelessWidget {
  final Locale? savedLocale;
  const MyApp({super.key, this.savedLocale});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: savedLocale ?? Get.deviceLocale,

      // locale: const Locale('zh', 'Pk'),
      translations: Languages(), // This provides the translations
      fallbackLocale: const Locale('en', 'US'), // This sets the fallback locale
      title: "AI Grammer Club",
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
      initialRoute: initScreen == 0 || initScreen == null ? "onboard" : "home",
      routes: {
        "home": (context) => const BottomNavBarScreen(),
        "onboard": (context) => OnboardingScreen(),
      },
    );
    // home:  const SplashScreen());
  }
}
