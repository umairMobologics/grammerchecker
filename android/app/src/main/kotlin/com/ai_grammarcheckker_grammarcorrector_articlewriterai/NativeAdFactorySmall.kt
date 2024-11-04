package com.ai_grammarcheckker_grammarcorrector_articlewriterai

import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactorySmall(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(nativeAd: NativeAd, customOptions: Map<String, Any>?): NativeAdView {
        val nativeAdView = LayoutInflater.from(context).inflate(R.layout.small_template, null) as NativeAdView

        // Icon
        nativeAdView.iconView = nativeAdView.findViewById(R.id.native_ad_icon)
        val iconView = nativeAdView.iconView as? ImageView
        val icon = nativeAd.icon // Fetch the icon
        if (icon != null) {
            iconView?.setImageDrawable(icon.drawable)
            iconView?.visibility = View.VISIBLE
        } else {
            iconView?.visibility = View.GONE
        }

        // Button
        nativeAdView.callToActionView = nativeAdView.findViewById(R.id.native_ad_button)
        val callToActionView = nativeAdView.callToActionView as? Button
        if (nativeAd.callToAction != null) {
            callToActionView?.text = nativeAd.callToAction
            callToActionView?.visibility = View.VISIBLE
        } else {
            callToActionView?.visibility = View.INVISIBLE
        }

        // Headline
        nativeAdView.headlineView = nativeAdView.findViewById(R.id.native_ad_headline)
        val headlineView = nativeAdView.headlineView as TextView
        headlineView.text = nativeAd.headline

        // Body View
        nativeAdView.bodyView = nativeAdView.findViewById(R.id.native_ad_body)
        val bodyView = nativeAdView.bodyView as? TextView
        if (nativeAd.body != null) {
            bodyView?.text = nativeAd.body
            bodyView?.visibility = View.VISIBLE
        } else {
            bodyView?.visibility = View.INVISIBLE
        }

        // Rating Bar
        nativeAdView.starRatingView = nativeAdView.findViewById(R.id.native_ad_rating)
        val starRatingView = nativeAdView.starRatingView as? RatingBar
        val starRating = nativeAd.starRating // Fetch the star rating
        if (starRating != null) {
            starRatingView?.rating = starRating.toFloat() // Ensure to check that starRating is not null
            starRatingView?.visibility = View.VISIBLE
        } else {
            starRatingView?.visibility = View.INVISIBLE
        }

        nativeAdView.setNativeAd(nativeAd)
        return nativeAdView
    }
}

