Admob Air Native Extension

*Jun 16, 2019 - V4.1.0*
* Read Google's SDK internal changelog for your reference. [iOS](https://developers.google.com/admob/ios/rel-notes), [Android](https://developers.google.com/admob/android/rel-notes)
* min iOS version to support this ANE is 10.0+
* min Android API version to support this ANE is 19+
* Updated to [Android Admob SDK V17.2.0](https://developers.google.com/admob/android/rel-notes) You must update the dependency files to the [latest available version](https://github.com/myflashlab/common-dependencies-ANE). New dependencies are required beside the older ones:
```xml
<!-- ... older dependencies -->

<!-- new ones as follow must be added -->
<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.measurementBase</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.gass</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.gson</extensionID>
```
* Updated to [iOS Admob SDK V7.42.1](https://developers.google.com/admob/ios/rel-notes) You must update the .framework files in your *AIR SDK/lib/aot/stub/* from [this archive Firebase V5.20.2](https://dl.google.com/firebase/sdk/ios/5_20_2/Firebase-5.20.2.zip)
  * GoogleMobileAds.framework
  * FIRAnalyticsConnector.framework
  * FirebaseAnalytics.framework
  * FirebaseCore.framework
  * FirebaseCoreDiagnostics.framework
  * FirebaseInstanceID.framework
  * GoogleAppMeasurement.framework
  * GoogleUtilities.framework
  * nanopb.framework
* There's a [known bug in AIR SDK](https://tracker.adobe.com/#/view/AIR-4198557). To bypass compilation errors on the iOS side, follow [this video tutorial](https://www.youtube.com/watch?v=m4bwZRCvs2c). 
* Removed deprecated properties ```gender```, ```userBirthday``` and ```isDesignedForFamilies``` from ```AdRequest``` class.
* Added new properties ```maxAdContentRating``` and ```tagForUnderAgeOfConsent``` to ```AdRequest``` class.
```actionscript
// Values of newly added properties must be from below:
AdRequest.MAX_AD_CONTENT_RATING_G
AdRequest.MAX_AD_CONTENT_RATING_MA
AdRequest.MAX_AD_CONTENT_RATING_PG
AdRequest.MAX_AD_CONTENT_RATING_T

AdRequest.TAG_FOR_UNDER_AGE_OF_CONSENT_FALSE
AdRequest.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE
AdRequest.TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED
```
* If you are using Admob or DoubleClick, it must be decleard in the manifest .xml file:
```xml
<!-- On the Android side, under the <application> tag -->


<!-- If you are using Admob -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/> <!-- Replace with your own APPLICATION_ID -->

<!-- If you are using Double-Click -->
<meta-data
    android:name="com.google.android.gms.ads.AD_MANAGER_APP"
    android:value="true"/>



<!-- On the iOS side, under the <InfoAdditions> tag -->


<!-- If you are using Admob -->
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string> <!-- Replace with your own APPLICATION_ID -->

<!-- If you are using Double-Click -->
<key>GADIsAdManagerApp</key>
<true/>
```
* Added new event for rewarded videos ```AdMobEvents.METADATA_CHANGED```:
```actionscript
AdMob.api.rewardedVideo.addEventListener(AdMobEvents.METADATA_CHANGED, onMetadataChanged);

function onMetadataChanged(e:AdMobEvents):void
{
	trace("onMetadataChanged: " + e.metadata);
}
```
* Requesting a second rewarded ad while another rewarded ad is being presented is no longer allowed. Another ad can be requested after presentation is over in rewardBasedVideoAdDidClose.

*Dec 14, 2018 - V4.0.4*
* Fixed the issue when on some devices banner dimension was returned as 0x0.

*Nov 16, 2018 - V4.0.3*
* Works with OverrideAir ANE V5.6.1 or higher
* Works with ANELAB V1.1.26 or higher

*Oct 11, 2018 - V4.0.0*
* Added support for the DoubleClick API. Notice that in your app you can use only one platform. it's either Admob or DoubleClick. You will not be able to use them both at the same time.
* To use DoubleClick API, simply pass null as the second parameter when initializing the ANE. All the other methods are just like before.
```actionscript
AdMob.init(stage, null);
```

*Sep 20, 2018 - V3.1.0*
* Updated iOS SDK to V7.31.0 and Android SDK to V15.0.1
* SDK upgrades are synced with Firebase ANE V7.0.0
* Min AIR SDK 30+
* Deprecated ```userBirthday``` and ```gender``` properties on ```AdRequest``` class.
* Removed AndroidSupport dependency and added the following:
```xml
<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.arch</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.core</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.customtabs</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.v4</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.ads</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.ads.lite</extensionID>
<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.basement</extensionID>
```

*Jun 14, 2018 - V3.0.0*
* Added support for rewardVideo through ```AdMob.api.rewardedVideo```.
* Changed packaging of classes. From now on, you only need to import ```com.myflashlab.air.extensions.admob.*;``` to access all Admob related APIs.
* removed ```BannerEvents```. Instead use ```AdMobEvents```.
* on iOS only: When Ad load fails with ```AD_FAILED``` event, you can see the error message using ```event.msg```.

*May 21, 2018 - V2.7.0*
* Added support for NetworkExtras. This is especially useful for making your app [gdpr compliance](https://support.google.com/admob/answer/7666366)
* We can't give you legal advices but we updated the Admob ANE so you can make your app in alignment with the gdpr privacy. Based on your users consent, you must decide if Admob can show personalized Ads or non-personalized Ads.
```actionscript
/*
	Requesting Consent from European Users
	Based on users consent, you should set if your app should show
	personalized ads or not. By default, Admob shows personalized Ads.
	In case your user does not allow that, you should also make sure that
	shown ads are not personalized. You can do this like below:
	
	adRequest.extras = {npa:1}; // npa stands for "Non-Personalized Ads"
					
	For more information, read here:
	https://developers.google.com/admob/ios/eu-consent#forward_consent_to_the_google_mobile_ads_sdk
	https://developers.google.com/admob/android/eu-consent#forward_consent_to_the_google_mobile_ads_sdk
*/
``` 

*Apr 22, 2018 - V2.6.0*
* Updated iOS SDK to V7.29.0 and Android SDK to V12.0.1
* make sure you are using the [latest version of the dependency files.](https://github.com/myflashlab/common-dependencies-ANE)
* Copy the frameworks from [Firebase V4.11.0 iOS SDK package](https://dl.google.com/firebase/sdk/ios/4_11_0/Firebase-4.11.0.zip)
 - **GoogleMobileAds**
 - **FirebaseAnalytics**
 - **FirebaseCore**
 - **FirebaseCoreDiagnostics**
 - **FirebaseNanoPB**
 - **FirebaseInstanceID**
 - **GoogleToolboxForMac**
 - **nanopb**

*Dec 15, 2017 - V2.5.0*
* Updated iOS SDK to V7.25.0 and Android SDK to V11.6.0
* Optimized to be used with the [ANE-LAB software](https://github.com/myflashlab/ANE-LAB/)
* replace ```GoogleMobileAds.framework``` with the one found with [Firebase V4.6.0 iOS SDK package](https://dl.google.com/firebase/sdk/ios/4_6_0/Firebase-4.6.0.zip)
* Besides the **GoogleMobileAds.framework**, you also need to copy the following frameworks to ```YOUR_AIR_SDK/lib/aot/stub/```
 - **FirebaseAnalytics**
 - **FirebaseCore**
 - **FirebaseCoreDiagnostics**
 - **FirebaseNanoPB**
 - **FirebaseInstanceID**
 - **GoogleToolboxForMac**
 - **nanopb**
* make sure you are using the [latest version of the dependency files.](https://github.com/myflashlab/common-dependencies-ANE)

*Jul 19, 2017 - V2.2.0*
* Updated iOS Admob SDK to V7.21.0 and you need to add/update ```GoogleMobileAds.framework``` in your AIR SDK. Find it here: [Firebase SDK V4.0.3](https://dl.google.com/firebase/sdk/ios/4_0_3/Firebase-4.0.3.zip)
* When you downloaded the Firebase SDK package, also copy the following frameworks to your ```YOUR_AIR_SDK/lib/aot/stub/``` folder.
 - **FirebaseAnalytics**
 - **FirebaseCore**
 - **FirebaseCoreDiagnostics**
 - **FirebaseNanoPB**
 - **FirebaseInstanceID**
 - **GoogleToolboxForMac**
 * Updated Android SDK to V11.0.2 and you need to make sure you are using the [latest version of the dependency files.](https://github.com/myflashlab/common-dependencies-ANE)

*Mar 10, 2017 - V2.1.0*
* Updated iOS Admob SDK to V7.17.0 and you need to add/update ```GoogleMobileAds.framework``` in your AIR SDK. Find it here: [Firebase SDK V3.13.0](https://dl.google.com/firebase/sdk/ios/3_13_0/Firebase-3.13.0.zip)
* When you downloaded the Firebase SDK package, also copy the following frameworks to your ```YOUR_AIR_SDK/lib/aot/stub/``` folder.
 - **FirebaseAnalytics**
 - **FirebaseCore**
 - **FirebaseInstanceID**
 - **GoogleToolboxForMac**
* Updated Android SDK to V10.2.0 and you need to make sure you are using the [latest version of the dependency files.](https://github.com/myflashlab/common-dependencies-ANE)
 - **androidSupport.ane** V24.2.1
 - **overrideAir.ane** V4.0.0
 - **googlePlayServices_adsLite.ane** V10.2.0
 - **googlePlayServices_basement.ane** V10.2.0
* Even if you are building for iOS only, you still need to include the following ANE as the dependency ```overrideAir.ane V4.0.0```

*Nov 29, 2016 - V2.0.0*
* Min iOS version to support this ANE will be iOS 8.0+ from now on
* Updated iOS Admob SDK to V7.15.1 which is now a part of Firebase SDK V3.10.0
* To Add ```GoogleMobileAds.framework``` to your AIR SDK, you need to [download Firebase SDK V10.0.0](https://dl.google.com/firebase/sdk/ios/3_10_0/Firebase-3.10.0.zip) extract it, then go to folder AdMob and copy GoogleMobileAds.framework to ```YOUR_AIR_SDK/lib/aot/stub/``` folder.
* Updated Android Admob SDK to Google Play Services dependencies V10.0.0 All you have to do is to [download the latest dependency files](https://github.com/myflashlab/common-dependencies-ANE) as follow:
 - **androidSupport.ane** V24.2.1
 - **overrideAir.ane** V3.0.0
 - **googlePlayServices_adsLite.ane** V10.0.0
 - **googlePlayServices_basement.ane** V10.0.0

*Nov 11, 2016 - V1.1.0*
* Optimized for Android manual permissions if you are targeting AIR SDK 24+
* The following two dependencies need to be added to other ones also: androidSupport.ane and overrideAir.ane

*Jun 07, 2016 - V1.0.1*
* fixed a bug mentioned here: https://github.com/myflashlab/Admob-ANE/issues/2

*Jun 05, 2016 - V1.0.0*
* beginning of the journey!