package 
{
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.text.modules.MySprite;
	import com.luaye.console.C;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.setTimeout;
	
	import com.myflashlab.air.extensions.admob.*;
	import com.myflashlab.air.extensions.dependency.OverrideAir;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/1/2016 5:41 PM
	 */
	public class Demo extends Sprite 
	{
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		private var _isAppInBackground:Boolean;
		
		public function Demo():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 20;
			C.width = 250;
			C.height = 150;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>AdMob ANE for Adobe Air V"+AdMob.VERSION+"</font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			C.log("iOS is crazy with understanding stageWidth and stageHeight, you already now that :)");
			C.log("So, we should wait a couple of seconds before initializing Admob to make sure the stage dimention is stable before passing it through the ANE.");
			setTimeout(init, 4000);
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			_isAppInBackground = false;
		}
		
		private function handleDeactivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			_isAppInBackground = true;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.y = 150 * (1 / DeviceInfo.dpiScaleMultiplier);
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
			
			if (AdMob.api && AdMob.api.banner)
			{
				// check if the banner ad is available?
				if (AdMob.api.banner.width > 0)
				{
					AdMob.api.banner.x = (stage.stageWidth / 2 - AdMob.api.banner.width / 2);
					AdMob.api.banner.y = stage.stageHeight / 2 - AdMob.api.banner.height / 2;
				}
			}
		}
		
		private function init():void
		{
			// Remove OverrideAir debugger in production builds
			OverrideAir.enableDebugger(function ($ane:String, $class:String, $msg:String):void
			{
				trace($ane+" ("+$class+") "+$msg);
			});
			
			// initialize AdMob and pass in the AIR Stage and your AdmMob ApplicationCode
			// pass null as the second parameter if you want to use DoubleClick API instead
			if(OverrideAir.os == OverrideAir.ANDROID) AdMob.init(stage, "ca-app-pub-3940256099942544~3347511713");
			else if(OverrideAir.os == OverrideAir.IOS)AdMob.init(stage, "ca-app-pub-3940256099942544~1458002511");
			
			// Add general listeners for the Ads
			AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, 				onAdClosed);
			AdMob.api.addEventListener(AdMobEvents.AD_FAILED, 				onAdFailed);
			AdMob.api.addEventListener(AdMobEvents.AD_LEFT_APP, 			onAdLeftApp);
			AdMob.api.addEventListener(AdMobEvents.AD_LOADED, 				onAdLoaded);
			AdMob.api.addEventListener(AdMobEvents.AD_OPENED, 				onAdOpened);
			
			// listen to the banner Ad to get its final width/height in pixels so you can place it anywhere you like in your Air app
			AdMob.api.banner.addEventListener(AdMobEvents.SIZE_MEASURED, 	onBannerAdSizeReceived);
			
			// listen to the RewardVideo Ad events
			AdMob.api.rewardedVideo.addEventListener(AdMobEvents.AD_BEGIN_PLAYING, onAdBeginPlayiing);
			AdMob.api.rewardedVideo.addEventListener(AdMobEvents.AD_END_PLAYING, onAdEndPlayiing);
			AdMob.api.rewardedVideo.addEventListener(AdMobEvents.AD_DELIVER_REWARD, onDeliverReward);
			AdMob.api.rewardedVideo.addEventListener(AdMobEvents.METADATA_CHANGED, onMetadataChanged);
			
			
			
			
			
			
			
			
			
			
			
			//----------------------------------------------------------------------
			var btn0:MySprite = createBtn("1) init Banner", 0xDFE4FF);
			btn0.addEventListener(MouseEvent.CLICK, initBanner);
			_list.add(btn0);
			
			function initBanner(e:MouseEvent):void
			{
				if(OverrideAir.os == OverrideAir.ANDROID) AdMob.api.banner.init("ca-app-pub-3940256099942544/6300978111", ApiBannerAds.ADAPTIVE_BANNER);
				else if(OverrideAir.os == OverrideAir.IOS)AdMob.api.banner.init("ca-app-pub-3940256099942544/2934735716", ApiBannerAds.ADAPTIVE_BANNER);
			}
			//----------------------------------------------------------------------
			var btn1:MySprite = createBtn("2) load Banner", 0xDFE4FF);
			btn1.addEventListener(MouseEvent.CLICK, loadBanner);
			_list.add(btn1);
			
			function loadBanner(e:MouseEvent):void
			{
				var adRequest:AdRequest = new AdRequest();
				adRequest.testDevices = [
				"282D9A2CD27F130F1C75646BBE5E59CE", // nexus 5x
				"D4898953B533540143C3AF9542A3901D", // Samsung Tablet
				"01633B9B5053A45AC8E3344D1A8664BF", // sony XperiaZ
				"b715a5fb533b76abc927f1df81ccc15d", // iPhone5
				"c8f6556cdbc458d0e14ce46ea6a6d913", // iPhone6+
				"7907F39B7194BFF36F1FCE72233A4FBB", // Huawei
				"c60b7dbf46f3245f5237c48f8eb1a100"  // iPhoneX
				];
				
				// make sure to set request params based on your app environment...
//				adRequest.maxAdContentRating = AdRequest.MAX_AD_CONTENT_RATING_T;
//				adRequest.tagForUnderAgeOfConsent = AdRequest.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE;
//				adRequest.tagForChildDirectedTreatment = true;
				
				// optionally you may set other request params
				
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
				
				AdMob.api.banner.loadAd(adRequest);
			}
			//----------------------------------------------------------------------
			var btn2:MySprite = createBtn("3) dispose Banner", 0xDFE4FF);
			btn2.addEventListener(MouseEvent.CLICK, disposeBanner);
			_list.add(btn2);
			
			function disposeBanner(e:MouseEvent):void
			{
				AdMob.api.banner.dispose();
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			//----------------------------------------------------------------------
			var btn3:MySprite = createBtn("1) init Interstitial", 0xFF9900);
			btn3.addEventListener(MouseEvent.CLICK, initInterstitial);
			_list.add(btn3);
			
			function initInterstitial(e:MouseEvent):void
			{
				if(OverrideAir.os == OverrideAir.ANDROID) AdMob.api.interstitial.init("ca-app-pub-3940256099942544/1033173712");
				else if(OverrideAir.os == OverrideAir.IOS)AdMob.api.interstitial.init("ca-app-pub-3940256099942544/4411468910");
			}
			//----------------------------------------------------------------------
			var btn4:MySprite = createBtn("2) load Interstitial then show it", 0xFF9900);
			btn4.addEventListener(MouseEvent.CLICK, loadInterstitial);
			_list.add(btn4);
			
			function loadInterstitial(e:MouseEvent):void
			{
				var adRequest:AdRequest = new AdRequest();
				adRequest.testDevices = [
				"282D9A2CD27F130F1C75646BBE5E59CE", // nexus 5x
				"D4898953B533540143C3AF9542A3901D", // Samsung Tablet
				"01633B9B5053A45AC8E3344D1A8664BF", // sony XperiaZ
				"b715a5fb533b76abc927f1df81ccc15d", // iPhone5
				"c8f6556cdbc458d0e14ce46ea6a6d913", // iPhone6+
				"7907F39B7194BFF36F1FCE72233A4FBB", // Huawei
				"c60b7dbf46f3245f5237c48f8eb1a100"  // iPhoneX
				];
				
				// make sure to set request params based on your app environment...
//				adRequest.maxAdContentRating = AdRequest.MAX_AD_CONTENT_RATING_T;
//				adRequest.tagForUnderAgeOfConsent = AdRequest.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE;
//				adRequest.tagForChildDirectedTreatment = true;
				
				// optionally you may set other request params
				
				AdMob.api.interstitial.loadAd(adRequest);
			}
			//----------------------------------------------------------------------
			var btn5:MySprite = createBtn("3) dispose Interstitial", 0xFF9900);
			btn5.addEventListener(MouseEvent.CLICK, disposeInterstitial);
			_list.add(btn5);
			
			function disposeInterstitial(e:MouseEvent):void
			{
				AdMob.api.interstitial.dispose();
			}
			//----------------------------------------------------------------------
			
			
			
			
			
			
			
			
			
			
			
			
			
			//----------------------------------------------------------------------
			var btn10:MySprite = createBtn("Load Rewarded Video then show it", 0x990000);
			btn10.addEventListener(MouseEvent.CLICK, loadRewardedVideo);
			_list.add(btn10);
			
			function loadRewardedVideo(e:MouseEvent):void
			{
				var adRequest:AdRequest = new AdRequest();
				adRequest.testDevices = [
					"282D9A2CD27F130F1C75646BBE5E59CE", // nexus 5x
					"D4898953B533540143C3AF9542A3901D", // Samsung Tablet
					"01633B9B5053A45AC8E3344D1A8664BF", // sony XperiaZ
					"b715a5fb533b76abc927f1df81ccc15d", // iPhone5
					"c8f6556cdbc458d0e14ce46ea6a6d913", // iPhone6+
					"7907F39B7194BFF36F1FCE72233A4FBB", // Huawei
					"c60b7dbf46f3245f5237c48f8eb1a100"  // iPhoneX
				];
				
				// make sure to set request params based on your app environment...
//				adRequest.maxAdContentRating = AdRequest.MAX_AD_CONTENT_RATING_T;
//				adRequest.tagForUnderAgeOfConsent = AdRequest.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE;
//				adRequest.tagForChildDirectedTreatment = true;
				
				// optionally you may set other request params
				
				if(OverrideAir.os == OverrideAir.ANDROID) AdMob.api.rewardedVideo.loadAd(adRequest, "ca-app-pub-3940256099942544/5224354917");
				else if(OverrideAir.os == OverrideAir.IOS)AdMob.api.rewardedVideo.loadAd(adRequest, "ca-app-pub-3940256099942544/1712485313");
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			onResize();
		}
		
		private function onAdClosed(e:AdMobEvents):void
		{
			trace("onAdClosed > " + e.adType); // AdMob.AD_TYPE_*
		}
		
		private function onAdFailed(e:AdMobEvents):void
		{
			trace("onAdFailed adType > " + e.adType); // AdMob.AD_TYPE_*
			trace("onAdFailed errorCode > " + e.errorCode); // AdMob.ERROR_CODE_*
			trace("onAdFailed msg > " + e.msg);
		}
		
		private function onAdLeftApp(e:AdMobEvents):void
		{
			trace("onAdLeftApp > " + e.adType); // AdMob.AD_TYPE_*
		}
		
		private function onAdLoaded(e:AdMobEvents):void
		{
			trace("onAdLoaded > " + e.adType); // AdMob.AD_TYPE_*
			
			if (e.adType == AdMob.AD_TYPE_BANNER)
			{
				AdMob.api.banner.x = stage.stageWidth / 2 - AdMob.api.banner.width / 2;
				AdMob.api.banner.y = stage.stageHeight / 2 - AdMob.api.banner.height / 2;
			}
			else if(e.adType == AdMob.AD_TYPE_INTERSTITIAL)
			{
				AdMob.api.interstitial.show();
			}
			else if(e.adType == AdMob.AD_TYPE_REWARDED_VIDEO)
			{
				if(_isAppInBackground)
				{
					C.log("should not play the video when app is in background")
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
		
		private function onAdOpened(e:AdMobEvents):void
		{
			C.log("onAdOpened > " + e.adType); // AdMob.AD_TYPE_*
		}
		
		private function onBannerAdSizeReceived(e:AdMobEvents):void
		{
			// NOTE: do not try to set the position of the Ad here! wait for the AdMobEvents.AD_LOADED event first!
			
			trace("onBannerAdSizeReceived");
			trace("width = " + e.width); // OR AdMob.api.banner.width
			trace("height = " + e.height); // OR AdMob.api.banner.height
		}
		
		private function onAdBeginPlayiing(e:AdMobEvents):void
		{
			trace("onAdBeginPlayiing");
		}
		
		private function onAdEndPlayiing(e:AdMobEvents):void
		{
			trace("onAdEndPlayiing");
		}
		
		private function onDeliverReward(e:AdMobEvents):void
		{
			trace("onDeliverReward Type: " + e.rewardType + " amount: " + e.rewardAmount);
		}
		
		private function onMetadataChanged(e:AdMobEvents):void
		{
			trace("onMetadataChanged: " + e.metadata);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String, $bgColor:uint=0xDFE4FF):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = $bgColor;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = $bgColor;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}