# Admob ANE for Android+iOS
Admob ANE supporting [DoubleClick](https://developers.google.com/ad-manager/mobile-ads-sdk/) and [Admob](https://developers.google.com/admob/) SDKs with 100% identical ActionScript API with a super easy interface so you can focus on your game logic while your app is earning more for you the smart way!

**Main Features:**
* Supporting Banner, Interstitial and Rewarded Video Ads
* Having control over all required EventListeners 
* Being able to position the banner Ads by pixels
* Optimized for [Firebase ANEs](https://github.com/myflashlab/Firebase-ANE/)
* DoubleClick SDK support

[find the latest **asdoc** for this ANE here.](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/admob/package-detail.html)  
[How to get started? **read here**](https://github.com/myflashlab/Admob-ANE/wiki)

# Test UnitIDs

**For DoubleClick**
* Android/iOS
	* banner: ```/6499/example/banner```
	* interstitial: ```/6499/example/interstitial```
	* rewarded-video: ```/6499/example/rewarded-video```

**For Admob**
* iOS:
	* appId for initializing the ANE: ```ca-app-pub-3940256099942544~1458002511```
	* banner: ```ca-app-pub-3940256099942544/2934735716```
	* interstitial: ```ca-app-pub-3940256099942544/4411468910```
	* rewarded-video: ```ca-app-pub-3940256099942544/1712485313```
* Android:
	* appId for initializing the ANE: ```ca-app-pub-3940256099942544~3347511713```
	* banner: ```ca-app-pub-3940256099942544/6300978111```
	* interstitial: ```ca-app-pub-3940256099942544/1033173712```
	* rewarded-video: ```ca-app-pub-3940256099942544/5224354917```

# AIR Usage - Banner Ad

```actionscript
import com.myflashlab.air.extensions.admob.*;
import com.myflashlab.air.extensions.dependency.OverrideAir;

// initialize AdMob and pass in the Adobe AIR Stage and your AdmMob ApplicationCode
if(OverrideAir.os == OverrideAir.ANDROID) AdMob.init(stage, "ca-app-pub-3940256099942544~3347511713");
else if(OverrideAir.os == OverrideAir.IOS)AdMob.init(stage, "ca-app-pub-3940256099942544~1458002511");

/*
	If you want to initialize DoubleClick SDK instead of admob, all you have to do is to pass null as the
	second parameter when initializing the ANE:

	AdMob.init(stage, null);
*/

// Add general listeners for the Ads
AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, 				onAdClosed);
AdMob.api.addEventListener(AdMobEvents.AD_FAILED, 				onAdFailed);
AdMob.api.addEventListener(AdMobEvents.AD_LEFT_APP, 			onAdLeftApp);
AdMob.api.addEventListener(AdMobEvents.AD_LOADED, 				onAdLoaded);
AdMob.api.addEventListener(AdMobEvents.AD_OPENED, 				onAdOpened);

// listen to the banner Ad to get its final width/height in pixels so you can place it anywhere you like in your Air app
AdMob.api.banner.addEventListener(AdMobEvents.SIZE_MEASURED, 	onBannerAdSizeReceived);

// to create a banner Ad, first you need to initialize a new banner with your unitId and prefered banner size
if(OverrideAir.os == OverrideAir.ANDROID) AdMob.api.banner.init("ca-app-pub-3940256099942544/6300978111", ApiBannerAds.BANNER);
else if(OverrideAir.os == OverrideAir.IOS)AdMob.api.banner.init("ca-app-pub-3940256099942544/2934735716", ApiBannerAds.BANNER);

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
import com.myflashlab.air.extensions.dependency.OverrideAir;

// initialize AdMob and pass in the Adobe AIR Stage and your AdmMob ApplicationCode
if(OverrideAir.os == OverrideAir.ANDROID) AdMob.init(stage, "ca-app-pub-3940256099942544~3347511713");
else if(OverrideAir.os == OverrideAir.IOS)AdMob.init(stage, "ca-app-pub-3940256099942544~1458002511");

/*
	If you want to initialize DoubleClick SDK instead of admob, all you have to do is to pass null as the
	second parameter when initializing the ANE:

	AdMob.init(stage, null);
*/

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
if(OverrideAir.os == OverrideAir.ANDROID) AdMob.api.interstitial.init("ca-app-pub-3940256099942544/1033173712");
else if(OverrideAir.os == OverrideAir.IOS)AdMob.api.interstitial.init("ca-app-pub-3940256099942544/4411468910");

// then create a new Ad request just like how you did for the Banner Ads
var adRequest:AdRequest = new AdRequest();

// And then load it!
AdMob.api.interstitial.loadAd(adRequest);

// now, you must wait for the banner to load before you can show it.
private function onAdLoaded(e:AdMobEvents):void
{
	if (e.adType == AdMob.AD_TYPE_INTERSTITIAL)
	{
		// Your Ad is ready to be shown. show it whenever you like; But not when your app is in background!
		if(_isAppInBackground)
		{
			trace("should not play the video when app is in background")
		}
		else
		{
			if(AdMob.api.interstitial.isLoaded)
			{
				AdMob.api.interstitial.show();
			}
		}
	}
}
```

# AIR Usage - RewardedVideo Ad

```actionscript
import com.myflashlab.air.extensions.admob.*;
import com.myflashlab.air.extensions.dependency.OverrideAir;

// initialize AdMob and pass in the Adobe AIR Stage and your AdmMob ApplicationCode
if(OverrideAir.os == OverrideAir.ANDROID) AdMob.init(stage, "ca-app-pub-3940256099942544~3347511713");
else if(OverrideAir.os == OverrideAir.IOS)AdMob.init(stage, "ca-app-pub-3940256099942544~1458002511");

/*
	If you want to initialize DoubleClick SDK instead of admob, all you have to do is to pass null as the
	second parameter when initializing the ANE:

	AdMob.init(stage, null);
*/

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

if(OverrideAir.os == OverrideAir.ANDROID) AdMob.api.rewardedVideo.loadAd(adRequest, "ca-app-pub-3940256099942544/5224354917");
else if(OverrideAir.os == OverrideAir.IOS)AdMob.api.rewardedVideo.loadAd(adRequest, "ca-app-pub-3940256099942544/1712485313");

// now, you must wait for the banner to load before you can show it.
private function onAdLoaded(e:AdMobEvents):void
{
	if (e.adType == AdMob.AD_TYPE_REWARDED_VIDEO)
	{
		// Your Ad is ready to be shown. show it whenever you like; But not when your app is in background!
		if(_isAppInBackground)
		{
			trace("should not play the video when app is in background")
		}
		else
		{
			if(AdMob.api.rewardedVideo.isReady)
			{
				AdMob.api.rewardedVideo.show();
			}
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
	<uses-sdk android:targetSdkVersion="28"/>
	
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


		<!-- If you are using Admob (must remove the Double-Click meta-data tag) -->
		<meta-data
			android:name="com.google.android.gms.ads.APPLICATION_ID"
			android:value="ca-app-pub-3940256099942544~3347511713"/> <!-- Replace with your own APPLICATION_ID -->

		<!-- If you are using Double-Click (must remove the Admob meta-data tag) -->
		<meta-data
		android:name="com.google.android.gms.ads.AD_MANAGER_APP"
		android:value="true"/>
		
	</application>
</manifest>





<!--
FOR iOS:
-->
	<InfoAdditions>
		<!--iOS 10.0 or higher can support this ANE-->
		<key>MinimumOSVersion</key>
		<string>10.0</string>
		
		<key>NSAppTransportSecurity</key>
		<dict>
			<key>NSAllowsArbitraryLoads</key>
			<true/>
		</dict>


		<!-- If you are using Admob (must remove GADIsAdManagerApp) -->
		<key>GADApplicationIdentifier</key>
		<string>ca-app-pub-3940256099942544~1458002511</string> <!-- Replace with your own APPLICATION_ID -->

		<!-- If you are using Double-Click (must remove GADApplicationIdentifier) -->
		<key>GADIsAdManagerApp</key>
		<true/>

		
	</InfoAdditions>



	
<!--
Embedding the ANE:
-->
  <extensions>
	
	<!-- dependency ANEs https://github.com/myflashlab/common-dependencies-ANE -->
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidx.arch</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidx.core</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidx.browser</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidx.lifecycle</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.ads</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.ads.lite</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.basement</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.measurementBase</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.gass</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.gson</extensionID>
	
	<!-- And finally embed the main Admob ANE -->
	<extensionID>com.myflashlab.air.extensions.admob</extensionID>
	
  </extensions>
-->
```

# Requirements 
1. Android API 19+
2. iOS SDK 10.0+
3. AIR SDK 30+
4. To compile on iOS, you will need to add the followng frameworks to your AIR SDK at location: ```AIR_SDK/lib/aot/stub```. Download them from [Firebase SDK V6.18.0](https://dl.google.com/firebase/sdk/ios/6_18_0/Firebase-6.18.0.zip).
* GoogleMobileAds.framework
* FIRAnalyticsConnector.framework
* FirebaseAnalytics.framework
* FirebaseCore.framework
* FirebaseCoreDiagnostics.framework
* FirebaseInstallations.framework
* FirebaseInstanceID.framework
* GoogleAppMeasurement.framework
* GoogleDataTransport.framework
* GoogleDataTransportCCTSupport.framework
* GoogleUtilities.framework
* nanopb.framework
* PromisesObjC.framework

# Commercial Version
https://www.myflashlabs.com/product/firebase-admob-air-native-extension/

[![Admob ANE](https://www.myflashlabs.com/wp-content/uploads/2016/06/product_adobe-air-ane-extension-admob-2018-595x738.jpg)](https://www.myflashlabs.com/product/firebase-admob-air-native-extension/)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[How to get started with Admob?](https://github.com/myflashlab/Admob-ANE/wiki)

# Premium Support #
[![Premium Support package](https://www.myflashlabs.com/wp-content/uploads/2016/06/professional-support.jpg)](https://www.myflashlabs.com/product/myflashlabs-support/)
If you are an [active MyFlashLabs club member](https://www.myflashlabs.com/product/myflashlabs-club-membership/), you will have access to our private and secure support ticket system for all our ANEs. Even if you are not a member, you can still receive premium help if you purchase the [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/).