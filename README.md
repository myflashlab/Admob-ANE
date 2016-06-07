# Admob ANE V1.0.1 for Android+iOS
Admob ANE is supported on Android and iOS with 100% identical ActionScript API with a super easy interface so you can focus on your game logic while your app is earning more for you the smart way!

**Main Features:**
* Supporting Banner and Interstitial Ads
* Having control over all required EventListeners 
* Being able to position the Ads by pixels

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/admob/package-detail.html)  
[How to get started? **read here**](https://github.com/myflashlab/Admob-ANE/wiki)

**NOTICE**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/Admob-ANE/tree/master/FD/lib)

# Air Usage - Banner Ad
```actionscript
import com.myflashlab.air.extensions.admob.AdMob;
import com.myflashlab.air.extensions.admob.AdRequest;
import com.myflashlab.air.extensions.admob.banner.ApiBannerAds;
import com.myflashlab.air.extensions.admob.events.AdMobEvents;
import com.myflashlab.air.extensions.admob.events.BannerEvents;

// initialize AdMob and pass in the Adobe Air Stage and your AdmMob ApplicationCode
AdMob.init(stage, "ca-app-pub-9002001127208746~3709582175");

// Add general listeners for the Ads
AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, 				onAdClosed);
AdMob.api.addEventListener(AdMobEvents.AD_FAILED, 				onAdFailed);
AdMob.api.addEventListener(AdMobEvents.AD_LEFT_APP, 			onAdLeftApp);
AdMob.api.addEventListener(AdMobEvents.AD_LOADED, 				onAdLoaded);
AdMob.api.addEventListener(AdMobEvents.AD_OPENED, 				onAdOpened);

// listen to the banner Ad to get its final width/height in pixels
AdMob.api.banner.addEventListener(BannerEvents.SIZE_MEASURED, 	onBannerAdSizeReceived);

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

# Air Usage - Interstitial Ad
```actionscript
import com.myflashlab.air.extensions.admob.AdMob;
import com.myflashlab.air.extensions.admob.AdRequest;
import com.myflashlab.air.extensions.admob.events.AdMobEvents;

// initialize AdMob and pass in the Adobe Air Stage and your AdmMob ApplicationCode
AdMob.init(stage, "ca-app-pub-9002001127208746~3709582175");

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

# Air .xml manifest
```xml
<!--
FOR ANDROID:
-->
<manifest android:installLocation="auto">
	
	<uses-permission android:name="android.permission.INTERNET" />
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	
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
		<!--iOS 7.0 or higher can support this ANE-->
		<key>MinimumOSVersion</key>
		<string>7.0</string>
		
		<!-- Required for iOS 9 support, read more about this here: https://firebase.google.com/docs/admob/ios/ios9 -->
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
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.ads.lite</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.basement</extensionID>
	
	<!-- And finally embed the main Admob ANE -->
    <extensionID>com.myflashlab.air.extensions.admob</extensionID>
	
  </extensions>
-->
```

# Requirements 
1. Android API 15 or higher
2. iOS SDK 7.0 or higher
3. Air SDK 22 or higher
4. This ANE is dependent on **googlePlayServices_adsLite.ane** and **googlePlayServices_basement.ane** You need to add these ANEs to your project too. [Download them from here:](https://github.com/myflashlab/common-dependencies-ANE)
5. To compile on iOS, you will need to add the GoogleMobileAds framework to your Air SDK.
  - download GAD_FRAMEWORKS.zip package from our github and extract it on your computer.
  - you will find GoogleMobileAds.framework. just copy it as they are and go to your AdobeAir SDK.
  - when in your Air SDK, go to "\lib\aot\stub". here you will find all the iOS frameworks provided by Air SDK by default.
  - paste the GAD frameworks you had copied into this folder and you are ready to build your project.

# Commercial Version
http://www.myflashlabs.com/product/firebase-admob-air-native-extension/

![Admob ANE](http://www.myflashlabs.com/wp-content/uploads/2016/06/product_adobe-air-ane-extension-admob-1-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[How to get started with Admob?](https://github.com/myflashlab/Admob-ANE/wiki)

# Changelog
*Jun 07, 2016 - V1.0.1*
* fixed a bug mentioned here: https://github.com/myflashlab/Admob-ANE/issues/2


*Jun 05, 2016 - V1.0.0*
* beginning of the journey!
