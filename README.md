# Admob ANE V3.0.0 for Android+iOS
Admob ANE is supported on Android and iOS with 100% identical ActionScript API with a super easy interface so you can focus on your game logic while your app is earning more for you the smart way!

**Main Features:**
* Supporting Banner, Interstitial and Rewarded Video Ads
* Having control over all required EventListeners 
* Being able to position the banner Ads by pixels
* Optimized for [Firebase ANEs](https://github.com/myflashlab/Firebase-ANE/)

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/admob/package-detail.html)  
[How to get started? **read here**](https://github.com/myflashlab/Admob-ANE/wiki)

Demo ANE can be used for test reasons only. [Download the demo ANE from here](https://github.com/myflashlab/Admob-ANE/tree/master/AIR/lib).

# AIR Usage - Banner Ad

```actionscript
import com.myflashlab.air.extensions.admob.*;

// initialize AdMob and pass in the Adobe AIR Stage and your AdmMob ApplicationCode
if(AdMob.os == AdMob.ANDROID) AdMob.init(stage, "ca-app-pub-9002001127208746~3709582175");
else if(AdMob.os == AdMob.IOS) AdMob.init(stage, "ca-app-pub-9002001127208746~3709582176");

// Add general listeners for the Ads
AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, 				onAdClosed);
AdMob.api.addEventListener(AdMobEvents.AD_FAILED, 				onAdFailed);
AdMob.api.addEventListener(AdMobEvents.AD_LEFT_APP, 			onAdLeftApp);
AdMob.api.addEventListener(AdMobEvents.AD_LOADED, 				onAdLoaded);
AdMob.api.addEventListener(AdMobEvents.AD_OPENED, 				onAdOpened);

// listen to the banner Ad to get its final width/height in pixels so you can place it anywhere you like in your Air app
AdMob.api.banner.addEventListener(AdMobEvents.SIZE_MEASURED, 	onBannerAdSizeReceived);

// to create a banner Ad, first you need to initialize a new banner with your unitId and prefered banner size
AdMob.api.banner.init("ca-app-pub-930840122057342/5256142323", ApiBannerAds.BANNER);

// then you should create a new Ad request
var adRequest:AdRequest = new AdRequest();

/*
	You may customize your Ad requests in many different ways. Read here to learn more about Ad Requests
	http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/admob/AdRequest.html
	
	Yet, one of the handy options is the adRequest.testDevices property which allows you to pass an Array of all
	your test devices so you can safely test your Ads before going live. If you don't know how you can receive your
	device's ID, read here for Android:
	https://firebase.google.com/docs/admob/android/targeting#test_ads
	or here for iOS:
	https://firebase.google.com/docs/admob/ios/targeting#test_ads
	
	For the best practice usage of banner Ads, read here:
	https://support.google.com/admob/answer/6128877?hl=en


	>> IMPORTANT <<
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

// Now that you have the Ad request ready, simply load your banner! That simple.
AdMob.api.banner.loadAd(adRequest);

// If you wish to change the position of the loaded banner, which is (0, 0) by default, you should listen for AdMobEvents.AD_LOADED
private function onAdLoaded(e:AdMobEvents):void
{
	if (e.adType == AdMob.AD_TYPE_BANNER)
	{
		// place the Ad at the center of your game, or anywhere else you wish!
		AdMob.api.banner.x = stage.stageWidth / 2 - AdMob.api.banner.width / 2;
		AdMob.api.banner.y = stage.stageHeight / 2 - AdMob.api.banner.height / 2;
	}
} 
```

# AIR Usage - Interstitial Ad

```actionscript
import com.myflashlab.air.extensions.admob.*;

// initialize AdMob and pass in the Adobe AIR Stage and your AdmMob ApplicationCode
if(AdMob.os == AdMob.ANDROID) AdMob.init(stage, "ca-app-pub-9002001127208746~3709582175");
else if(AdMob.os == AdMob.IOS) AdMob.init(stage, "ca-app-pub-9002001127208746~3709582176");

// Add general listeners for the Ads
AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, 				onAdClosed);
AdMob.api.addEventListener(AdMobEvents.AD_FAILED, 				onAdFailed);
AdMob.api.addEventListener(AdMobEvents.AD_LEFT_APP, 			onAdLeftApp);
AdMob.api.addEventListener(AdMobEvents.AD_LOADED, 				onAdLoaded);
AdMob.api.addEventListener(AdMobEvents.AD_OPENED, 				onAdOpened);

/*
	One thing you should remember about interstitial Ads, is that you should load them first,
	wait for them to be loaded, then show them when appropriate. For the best practice usage of
	interstitial Ads, read here: https://support.google.com/admob/answer/6066980?hl=en
*/

// The first step is to initialize a new interstitial Ad with your unitId that you have created in your Admob console.
AdMob.api.interstitial.init("ca-app-pub-9476398060240162/1457820116");

// then create a new Ad request just like how you did for the Banner Ads
var adRequest:AdRequest = new AdRequest();

// And then load it!
AdMob.api.interstitial.loadAd(adRequest);

// now, you must wait for the banner to load before you can show it.
private function onAdLoaded(e:AdMobEvents):void
{
	if (e.adType == AdMob.AD_TYPE_INTERSTITIAL)
	{
		// Your Ad is ready to be shown. show it whenever you like!
		if(AdMob.api.interstitial.isLoaded)
		{
			AdMob.api.interstitial.show();
		}
	}
}
```

# AIR Usage - RewardedVideo Ad

```actionscript
import com.myflashlab.air.extensions.admob.*;

// initialize AdMob and pass in the Adobe AIR Stage and your AdmMob ApplicationCode
if(AdMob.os == AdMob.ANDROID) AdMob.init(stage, "ca-app-pub-9002001127208746~3709582175");
else if(AdMob.os == AdMob.IOS) AdMob.init(stage, "ca-app-pub-9002001127208746~3709582176");

// Add general listeners for the Ads
AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, 				onAdClosed);
AdMob.api.addEventListener(AdMobEvents.AD_FAILED, 				onAdFailed);
AdMob.api.addEventListener(AdMobEvents.AD_LEFT_APP, 			onAdLeftApp);
AdMob.api.addEventListener(AdMobEvents.AD_LOADED, 				onAdLoaded);
AdMob.api.addEventListener(AdMobEvents.AD_OPENED, 				onAdOpened);

// listen to the RewardVideo Ad events
AdMob.api.rewardedVideo.addEventListener(AdMobEvents.AD_BEGIN_PLAYING, onAdBeginPlayiing);
AdMob.api.rewardedVideo.addEventListener(AdMobEvents.AD_END_PLAYING, onAdEndPlayiing);
AdMob.api.rewardedVideo.addEventListener(AdMobEvents.AD_DELIVER_REWARD, onDeliverReward);

// then create a new Ad request just like how you did for the Banner Ads
var adRequest:AdRequest = new AdRequest();

AdMob.api.rewardedVideo.loadAd(adRequest, "ca-app-pub-9202401623205742/3427670519");

// now, you must wait for the banner to load before you can show it.
private function onAdLoaded(e:AdMobEvents):void
{
	if (e.adType == AdMob.AD_TYPE_REWARDED_VIDEO)
	{
		// Your Ad is ready to be shown. show it whenever you like!
		if(AdMob.api.rewardedVideo.isReady)
		{
			AdMob.api.rewardedVideo.show();
		}
	}
}

private function onDeliverReward(e:AdMobEvents):void
{
	trace("onDeliverReward Type: " + e.rewardType + " amount: " + e.rewardAmount);
}
```

# AIR .xml manifest

```xml
<!--
FOR ANDROID:
-->
<manifest android:installLocation="auto">
	
	<uses-permission android:name="android.permission.INTERNET" />
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	
	<!--The new Permission thing on Android works ONLY if you are targetting Android SDK 23 or higher-->
	<uses-sdk android:targetSdkVersion="23"/>
	
	<application>
		
		<activity>
			<intent-filter>
				<action android:name="android.intent.action.MAIN" />
				<category android:name="android.intent.category.LAUNCHER" />
			</intent-filter>
			<intent-filter>
				<action android:name="android.intent.action.VIEW" />
				<category android:name="android.intent.category.BROWSABLE" />
				<category android:name="android.intent.category.DEFAULT" />
			</intent-filter>
		</activity>
		
		<!-- Include the AdActivity configChanges and themes. -->
        <activity
            android:name="com.google.android.gms.ads.AdActivity"
            android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|uiMode|screenSize|smallestScreenSize"
            android:theme="@android:style/Theme.Translucent" />
			
		<meta-data
            android:name="com.google.android.gms.version"
            android:value="@integer/google_play_services_version" />
		
	</application>
</manifest>





<!--
FOR iOS:
-->
	<InfoAdditions>
		<!--iOS 8.0 or higher can support this ANE-->
		<key>MinimumOSVersion</key>
		<string>8.0</string>
		
		<key>NSAppTransportSecurity</key>
		<dict>
			<key>NSAllowsArbitraryLoads</key>
			<true/>
		</dict>
		
	</InfoAdditions>



	
<!--
Embedding the ANE:
-->
  <extensions>
	
	<!-- download the dependency ANEs from https://github.com/myflashlab/common-dependencies-ANE -->
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.ads.lite</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.basement</extensionID>
	
	<!-- And finally embed the main Admob ANE -->
	<extensionID>com.myflashlab.air.extensions.admob</extensionID>
	
  </extensions>
-->
```

# Requirements 
1. Android API 15 or higher
2. iOS SDK 8.0 or higher
3. AIR SDK 29 or higher
4. This ANE is dependent on **androidSupport.ane**, **overrideAir.ane**, **googlePlayServices_adsLite.ane** and **googlePlayServices_basement.ane** You need to add these ANEs to your project too. [Download them from here:](https://github.com/myflashlab/common-dependencies-ANE)
5. To compile on iOS, you will need to add the [GoogleMobileAds framework](https://dl.google.com/firebase/sdk/ios/4_11_0/Firebase-4.11.0.zip) to your AIR SDK.

# Commercial Version
http://www.myflashlabs.com/product/firebase-admob-air-native-extension/

![Admob ANE](https://www.myflashlabs.com/wp-content/uploads/2016/06/product_adobe-air-ane-extension-admob-1-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[How to get started with Admob?](https://github.com/myflashlab/Admob-ANE/wiki)

# Changelog
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
