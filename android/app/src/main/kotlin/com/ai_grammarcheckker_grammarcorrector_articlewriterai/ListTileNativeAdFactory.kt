package com.ai_grammarcheckker_grammarcorrector_articlewriterai

import com.google.android.gms.ads.VideoController
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView

class ListTileNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
    
    override fun createNativeAd(nativeAd: NativeAd, customOptions: Map<String, Any>?): NativeAdView {
        val adView = LayoutInflater.from(context).inflate(R.layout.list_tile_native_ad, null) as NativeAdView
        val mediaView = adView.findViewById<MediaView>(R.id.ad_media)
        adView.mediaView = mediaView

        // Set other ad assets.
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.iconView = adView.findViewById(R.id.ad_app_icon)
 


        // Populate views with ad content.
        (adView.headlineView as TextView).text = nativeAd.headline
        mediaView.mediaContent = nativeAd.mediaContent

        // Handle optional fields
        (adView.bodyView as TextView).apply {
            text = nativeAd.body ?: run {
                visibility = View.INVISIBLE
                null
            }
        }

        (adView.callToActionView as Button).apply {
            text = nativeAd.callToAction ?: run {
                visibility = View.INVISIBLE
                null
            }
        }

        (adView.iconView as ImageView).apply {
            nativeAd.icon?.let {
                setImageDrawable(it.drawable)
                visibility = View.VISIBLE
            } ?: run {
                visibility = View.GONE
            }
        }

        // Set the native ad to the ad view.
        adView.setNativeAd(nativeAd)

        // Handle video controller
        val vc = nativeAd.mediaContent?.videoController
        vc?.setVideoLifecycleCallbacks(object : VideoController.VideoLifecycleCallbacks() {
            override fun onVideoEnd() {
                super.onVideoEnd()
                // Handle video end event
            }
        })

        return adView
    }
}
