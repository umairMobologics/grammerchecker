package com.ai_grammarcheckker_grammarcorrector_articlewriterai

import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {



        super.configureFlutterEngine(flutterEngine)



        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine, "listTile", ListTileNativeAdFactory(this))
        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine, "small", NativeAdFactorySmall(this))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine,"listTile")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine,"small")
    }


}
