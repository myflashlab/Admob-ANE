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
	
	import com.myflashlab.air.extensions.admob.AdMob;
	import com.myflashlab.air.extensions.admob.AdRequest;
	import com.myflashlab.air.extensions.admob.banner.ApiBannerAds;
	import com.myflashlab.air.extensions.admob.events.AdMobEvents;
	import com.myflashlab.air.extensions.admob.events.BannerEvents;
	
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
		}
		
		private function handleDeactivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
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
		
		private function myDebuggerDelegate($ane:String, $class:String, $msg:String):void
		{
			trace($ane+"("+$class+") "+$msg);
		}
		
		private function init():void
		{
			// remove this line in production build or pass null as the delegate
			OverrideAir.enableDebugger(myDebuggerDelegate);
			
			// initialize AdMob and pass in the Adobe Air Stage and your AdmMob ApplicationCode
			AdMob.init(stage, "ca-app-pub-9872578950174042~5422482125");
			
			// Add general listeners for the Ads
			AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, 				onAdClosed);
			AdMob.api.addEventListener(AdMobEvents.AD_FAILED, 				onAdFailed);
			AdMob.api.addEventListener(AdMobEvents.AD_LEFT_APP, 			onAdLeftApp);
			AdMob.api.addEventListener(AdMobEvents.AD_LOADED, 				onAdLoaded);
			AdMob.api.addEventListener(AdMobEvents.AD_OPENED, 				onAdOpened);
			
			// listen to the banner Ad to get its final width/height in pixels so you can place it anywhere you like in your Air app
			AdMob.api.banner.addEventListener(BannerEvents.SIZE_MEASURED, 	onBannerAdSizeReceived);
			
			
			
			
			
			
			
			
			
			
			
			
			//----------------------------------------------------------------------
			var btn0:MySprite = createBtn("1) init Banner", 0xDFE4FF);
			btn0.addEventListener(MouseEvent.CLICK, initBanner);
			_list.add(btn0);
			
			function initBanner(e:MouseEvent):void
			{
				AdMob.api.banner.init("ca-app-pub-45212548785225/215478996521", ApiBannerAds.BANNER); // unitId for Android
				//AdMob.api.banner.init("ca-app-pub-45212548785225/215478893028", ApiBannerAds.BANNER); // unitId for iOS
			}
			//----------------------------------------------------------------------
			var btn1:MySprite = createBtn("2) load Banner", 0xDFE4FF);
			btn1.addEventListener(MouseEvent.CLICK, loadBanner);
			_list.add(btn1);
			
			function loadBanner(e:MouseEvent):void
			{
				var adRequest:AdRequest = new AdRequest();
				adRequest.testDevices = [
				"282D9A2CD27F130F1C75346BBE5E59CE", // nexus 5x
				"D4898953B533540143C1AF9542A3901D", // Samsung Tablet
				"01633B9B5053A47AC8E3344D1A8664BF", // sony XperiaZ
				"b715a5fb533b76abc927f1df81ccc15d", // iPhone5
				"c8f6556cdbc458d0e12ce46ea6a6d913"  // iPhone6+
				];
				adRequest.gender = AdRequest.GENDER_UNKNOWN;
				// optionaly you may set other request params
				
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
				AdMob.api.interstitial.init("ca-app-pub-45212548785225/452154789320"); // unitId for Android
				//AdMob.api.interstitial.init("ca-app-pub-45212548785225/124801259720"); // unitId for iOS
			}
			//----------------------------------------------------------------------
			var btn4:MySprite = createBtn("2) load Interstitial then show it", 0xFF9900);
			btn4.addEventListener(MouseEvent.CLICK, loadInterstitial);
			_list.add(btn4);
			
			function loadInterstitial(e:MouseEvent):void
			{
				var adRequest:AdRequest = new AdRequest();
				adRequest.testDevices = [
				"282D9A2CD27F130F1C75346BBE5E59CE", // nexus 5x
				"D4898953B533540143C1AF9542A3901D", // Samsung Tablet
				"01633B9B5053A47AC8E3344D1A8664BF", // sony XperiaZ
				"b715a5fb533b76abc927f1df81ccc15d", // iPhone5
				"c8f6556cdbc458d0e12ce46ea6a6d913"  // iPhone6+
				];
				adRequest.gender = AdRequest.GENDER_UNKNOWN;
				// optionaly you may set other request params
				
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
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			onResize();
		}
		
		private function onAdClosed(e:AdMobEvents):void
		{
			C.log("onAdClosed > " + e.adType); // AdMob.AD_TYPE_*
		}
		
		private function onAdFailed(e:AdMobEvents):void
		{
			C.log("onAdFailed > " + e.adType); // AdMob.AD_TYPE_*
			C.log("onAdFailed > " + e.errorCode); // AdMob.ERROR_CODE_*
		}
		
		private function onAdLeftApp(e:AdMobEvents):void
		{
			C.log("onAdLeftApp > " + e.adType); // AdMob.AD_TYPE_*
		}
		
		private function onAdLoaded(e:AdMobEvents):void
		{
			C.log("onAdLoaded > " + e.adType); // AdMob.AD_TYPE_*
			
			if (e.adType == AdMob.AD_TYPE_BANNER)
			{
				AdMob.api.banner.x = stage.stageWidth / 2 - AdMob.api.banner.width / 2;
				AdMob.api.banner.y = stage.stageHeight / 2 - AdMob.api.banner.height / 2;
				
			}
			else if (e.adType == AdMob.AD_TYPE_INTERSTITIAL)
			{
				AdMob.api.interstitial.show();
				
				//AdMob.api.interstitial.isLoaded;
			}
		}
		
		private function onAdOpened(e:AdMobEvents):void
		{
			C.log("onAdOpened > " + e.adType); // AdMob.AD_TYPE_*
		}
		
		private function onBannerAdSizeReceived(e:BannerEvents):void
		{
			// NOTE: do not try to set the position of the Ad here! wait for the AdMobEvents.AD_LOADED event first!
			
			C.log("onBannerAdSizeReceived");
			C.log("width = " + e.width); // OR AdMob.api.banner.width
			C.log("height = " + e.height); // OR AdMob.api.banner.height
			
			
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