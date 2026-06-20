package LicPackage
{
   import CPMStar.*;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Security;
   import flash.utils.Timer;
   import mochi.as3.*;
   import org.flashdevelop.utils.FlashConnect;
   
   public class LicAds
   {
      
      public static var intro:MovieClip;
      
      public static var cx:int;
      
      public static var cy:int;
      
      internal static var showAdFinishedCallback:Function;
      
      private static var cpmStarLoadTimer:int;
      
      private static var cpmStarLoaderCounter:int;
      
      private static var cpmStarTimer:Timer;
      
      internal static var abs:Object;
      
      internal static var oldFrameRate:int = 0;
      
      private static var ad:DisplayObject = null;
      
      public function LicAds()
      {
         super();
      }
      
      public static function GetLicensor() : int
      {
         return LicDef.GetLicensor();
      }
      
      public static function GetSku(param1:int) : LicSku
      {
         return LicDef.GetSku(param1);
      }
      
      public static function GetCurrentSku() : LicSku
      {
         return LicDef.GetSku(LicDef.GetLicensor());
      }
      
      public static function IsAtGames1() : Boolean
      {
         var _loc1_:String = LicDef.GetDomain();
         if(_loc1_ == "games1.com")
         {
            return true;
         }
         return false;
      }
      
      public static function IsAtNotDoppler() : Boolean
      {
         var _loc1_:String = LicDef.GetDomain();
         if(_loc1_ == "notdoppler.com")
         {
            return true;
         }
         return false;
      }
      
      public static function IsAtKiba() : Boolean
      {
         var _loc1_:String = LicDef.GetDomain();
         if(_loc1_ == "spielaffe.de")
         {
            return true;
         }
         if(_loc1_ == "kibagames.com")
         {
            return true;
         }
         if(_loc1_ == "kraloyun.com")
         {
            return true;
         }
         if(_loc1_ == "juegosmonitos.com")
         {
            return true;
         }
         if(_loc1_ == "jeuxsinge.fr")
         {
            return true;
         }
         if(_loc1_ == "giochiscimmia.it")
         {
            return true;
         }
         if(_loc1_ == "kaisergames.de")
         {
            return true;
         }
         return false;
      }
      
      public static function ShouldTryLoadAdXML() : Boolean
      {
         var _loc1_:String = LicDef.GetDomain();
         if(_loc1_ == "kongregate.com")
         {
            return false;
         }
         if(_loc1_ == "3366.com")
         {
            return false;
         }
         if(_loc1_ == "7k7k.com")
         {
            return false;
         }
         if(_loc1_ == "4399.com")
         {
            return false;
         }
         return true;
      }
      
      public static function FilterAdForSites() : Boolean
      {
         var _loc1_:String = LicDef.GetDomain();
         if(_loc1_ == "kongregate.com")
         {
            return true;
         }
         if(_loc1_ == "agame.com")
         {
            return true;
         }
         if(_loc1_ == "armorgames.com")
         {
            return true;
         }
         if(_loc1_ == "flashgamelicense.com")
         {
            return true;
         }
         if(_loc1_ == "gamesheep.com")
         {
            return true;
         }
         if(_loc1_ == "ejocuri.ro")
         {
            return true;
         }
         if(_loc1_ == "ejocurigratis.ro")
         {
            return true;
         }
         if(_loc1_ == "jaludo.com")
         {
            return true;
         }
         if(IsAtKiba())
         {
            return true;
         }
         if(IsAtGames1())
         {
            return true;
         }
         return false;
      }
      
      public static function ShowAd(param1:Function) : *
      {
         oldFrameRate = 0;
         intro = null;
         cx = Defs.displayarea_w / 2;
         cy = Defs.displayarea_h / 2;
         showAdFinishedCallback = param1;
         var _loc2_:int = GetCurrentSku().adtype;
         if(AdHolder.IsLoadedPreAdAvailable() && _loc2_ != LicDef.ADTYPE_NONE)
         {
            Utils.trace("showing turbonuke pre-ad");
            ShowTurboNukeAd();
         }
         else if(_loc2_ == LicDef.ADTYPE_NONE)
         {
            ShowNoAd();
         }
         else if(_loc2_ == LicDef.ADTYPE_MOCHI_VC)
         {
            ShowNoAd();
         }
         else if(_loc2_ == LicDef.ADTYPE_MOCHI)
         {
            ShowMochiAd_Preload();
         }
         else if(_loc2_ == LicDef.ADTYPE_CPMSTAR)
         {
            if(FilterAdForSites() == false)
            {
               ShowCPMStarAd();
            }
            else
            {
               ShowNoAd();
            }
         }
         else if(_loc2_ == LicDef.ADTYPE_ARMOR_BROADCAST_SYSTEM)
         {
            ShowArmorBroadcastSystemAd();
         }
      }
      
      internal static function CPMStarLoadingEventCallback(param1:Event) : void
      {
         var _loc2_:* = LicDef.GetStage().stage.loaderInfo.bytesTotal;
         var _loc3_:* = LicDef.GetStage().stage.loaderInfo.bytesLoaded;
         var _loc4_:Number = 1 / _loc2_ * _loc3_;
         RenderLoaderBar(_loc4_);
         if(_loc3_ >= _loc2_)
         {
            LicDef.GetStage().removeEventListener(Event.ENTER_FRAME,CPMStarLoadingEventCallback);
            ++cpmStarLoaderCounter;
            CPMStarCompleteCallback();
         }
      }
      
      internal static function CPMStarCompleteCallback() : void
      {
         if(cpmStarLoaderCounter >= 2)
         {
            if(intro.loaderBar != null)
            {
               intro.loaderBar.visible = false;
            }
            intro.buttonSkipCPMStarAd.visible = true;
         }
      }
      
      internal static function CPMStarTimerCallback(param1:TimerEvent) : void
      {
         ++cpmStarLoadTimer;
         if(cpmStarLoadTimer >= LicDef.CPMStarFixedTime)
         {
            ++cpmStarLoaderCounter;
            cpmStarTimer.stop();
            CPMStarCompleteCallback();
         }
         else
         {
            cpmStarTimer.start();
         }
      }
      
      internal static function RenderLoaderBar(param1:Number) : void
      {
         var _loc2_:int = 0;
         if(intro == null)
         {
            return;
         }
         if(intro.loaderBar != null)
         {
            _loc2_ = ScaleTo(1,intro.loaderBar.totalFrames,0,1,param1);
            Utils.trace("preloader " + _loc2_);
            intro.loaderBar.gotoAndStop(_loc2_);
         }
      }
      
      public static function ScaleTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         var _loc6_:Number = param4 - param3;
         var _loc7_:Number = param2 - param1;
         var _loc8_:Number = 1 / _loc6_ * (param5 - param3);
         return _loc7_ * _loc8_ + param1;
      }
      
      public static function RandBetweenInt(param1:int, param2:int) : int
      {
         var _loc3_:int = Math.random() * (param2 - param1 + 1);
         return int(_loc3_ + param1);
      }
      
      internal static function AddIntroScreenAndSetUpButtons() : *
      {
         intro = new CPMStarLoaderScreen();
         intro.x = 0;
         intro.y = 0;
         LicDef.GetStage().addChild(intro);
         MainLogoButton(intro.mainLogo);
         AddButton(intro.buttonSkipCPMStarAd,buttonSkipCPMStarAdPressed);
         Lic.AuthorButton(intro.turboBtn);
         intro.buttonSkipCPMStarAd.visible = false;
      }
      
      public static function ShowTurboNukeAd() : void
      {
         AddIntroScreenAndSetUpButtons();
         var _loc1_:AdItem = AdHolder.GetPreAdItem();
         if(_loc1_ != null)
         {
            ad = AdHolder.GetPreAdCustomMC();
            intro.adBox.addChild(ad);
            if(_loc1_.url != "")
            {
               intro.adBox.addEventListener(MouseEvent.CLICK,AdHolder.PreAdClicked);
               intro.adBox.buttonMode = true;
               intro.adBox.useHandCursor = true;
            }
         }
         cpmStarLoaderCounter = 0;
         LicDef.GetStage().addEventListener(Event.ENTER_FRAME,CPMStarLoadingEventCallback);
         cpmStarTimer = new Timer(1000);
         cpmStarTimer.addEventListener(TimerEvent.TIMER,CPMStarTimerCallback);
         cpmStarTimer.start();
      }
      
      public static function ShowCPMStarAd() : void
      {
         var _loc1_:String = null;
         var _loc3_:int = 0;
         AddIntroScreenAndSetUpButtons();
         var _loc2_:int = int(LicDef.CPMStarContentSpotIDs.length);
         if(_loc2_ == 1)
         {
            _loc1_ = LicDef.CPMStarContentSpotIDs[0];
         }
         if(_loc2_ == 2)
         {
            _loc3_ = RandBetweenInt(0,1000);
            if(_loc3_ < 500)
            {
               _loc1_ = LicDef.CPMStarContentSpotIDs[0];
            }
            else
            {
               _loc1_ = LicDef.CPMStarContentSpotIDs[1];
            }
         }
         ad = new AdLoader(_loc1_);
         intro.adBox.addChild(ad);
         cpmStarLoadTimer = 0;
         cpmStarLoaderCounter = 0;
         LicDef.GetStage().addEventListener(Event.ENTER_FRAME,CPMStarLoadingEventCallback);
         cpmStarTimer = new Timer(1000);
         cpmStarTimer.addEventListener(TimerEvent.TIMER,CPMStarTimerCallback);
         cpmStarTimer.start();
      }
      
      public static function ShowArmorBroadcastSystemAd() : *
      {
         var _loc2_:* = undefined;
         AddIntroScreenAndSetUpButtons();
         var _loc1_:String = "http://agi.armorgames.com/assets/agi/ABS.swf";
         Security.allowDomain(_loc1_);
         var _loc3_:URLRequest = new URLRequest(_loc1_);
         var _loc4_:Loader = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,ArmorBroadcastSystem_loadComplete);
         _loc4_.load(_loc3_);
         LicDef.CPMStarFixedTime = 0;
         cpmStarLoadTimer = 0;
         cpmStarLoaderCounter = 0;
         LicDef.GetStage().addEventListener(Event.ENTER_FRAME,CPMStarLoadingEventCallback);
         cpmStarTimer = new Timer(1000);
         cpmStarTimer.addEventListener(TimerEvent.TIMER,CPMStarTimerCallback);
         cpmStarTimer.start();
      }
      
      internal static function ArmorBroadcastSystem_loadComplete(param1:Event) : void
      {
         abs = param1.currentTarget.content;
         intro.adBox.addChild(abs);
         abs.show();
      }
      
      public static function ShowMochiAd_Preload() : *
      {
         LicDef.GetStage().stop();
         AddIntroScreenAndSetUpButtons();
         cpmStarLoadTimer = 0;
         cpmStarLoaderCounter = 1;
         ShowMochiAd();
      }
      
      internal static function ShowMochiAd_Preload_LoadingEventCallback(param1:Event) : *
      {
         var _loc2_:* = LicDef.GetStage().stage.loaderInfo.bytesTotal;
         var _loc3_:* = LicDef.GetStage().stage.loaderInfo.bytesLoaded;
         var _loc4_:Number = 1 / _loc2_ * _loc3_;
         RenderLoaderBar(_loc4_);
         if(_loc3_ >= _loc2_)
         {
            LicDef.GetStage().removeEventListener(Event.ENTER_FRAME,ShowMochiAd_Preload_LoadingEventCallback);
            LicDef.GetStage().play();
            if(showAdFinishedCallback != null)
            {
               showAdFinishedCallback();
            }
         }
      }
      
      public static function ShowMochiAd() : *
      {
         MochiAd.showPreGameAd({
            "clip":LicDef.GetStage(),
            "id":LicDef.MochiAdID,
            "res":LicDef.MochiAdRes,
            "ad_finished":MochiAdFinished
         });
      }
      
      public static function MochiAdFinished() : *
      {
         LicDef.GetStage().removeChild(intro);
         intro = null;
         if(showAdFinishedCallback != null)
         {
            showAdFinishedCallback();
         }
         LicDef.GetStage().play();
         FlashConnect.trace("HERE Mochi Ad Finished");
      }
      
      public static function ShowNoAd() : void
      {
         AddIntroScreenAndSetUpButtons();
         intro.adBox.visible = false;
         cpmStarLoadTimer = 0;
         cpmStarLoaderCounter = 1;
         LicDef.GetStage().addEventListener(Event.ENTER_FRAME,CPMStarLoadingEventCallback);
      }
      
      internal static function RemoveMainLogoButton(param1:MovieClip) : void
      {
         var _loc3_:SimpleButton = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:LicSku = GetCurrentSku();
         var _loc4_:int = param1.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.getChildAt(_loc5_) as SimpleButton;
            if(_loc3_ != null)
            {
               _loc3_.visible = false;
            }
            _loc5_++;
         }
      }
      
      public static function MainLogoButton(param1:MovieClip) : void
      {
         var _loc3_:SimpleButton = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:LicSku = GetCurrentSku();
         var _loc4_:int = param1.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.getChildAt(_loc5_) as SimpleButton;
            if(_loc3_ != null)
            {
               _loc3_.visible = false;
            }
            _loc5_++;
         }
         if(_loc2_.mainLogoName != "")
         {
            _loc3_ = param1.getChildByName(_loc2_.mainLogoName) as SimpleButton;
            if(_loc3_ != null)
            {
               _loc3_.visible = true;
               if(_loc2_.linkURL != "")
               {
                  if(_loc2_.mainLogoLinkURL != "")
                  {
                     _loc3_.addEventListener(MouseEvent.CLICK,ClickedMainLogoURL,false,0,true);
                  }
                  else
                  {
                     _loc3_.addEventListener(MouseEvent.CLICK,ClickedLinkURL,false,0,true);
                  }
               }
               else
               {
                  _loc3_.useHandCursor = false;
               }
            }
         }
      }
      
      internal static function ClickedLinkURL(param1:MouseEvent) : *
      {
         var _loc2_:LicSku = GetCurrentSku();
         DoLink(_loc2_.linkURL);
      }
      
      internal static function ClickedMainLogoURL(param1:MouseEvent) : *
      {
         var _loc2_:LicSku = GetCurrentSku();
         DoLink(_loc2_.mainLogoLinkURL);
      }
      
      public static function DoLink(param1:String) : *
      {
         var _loc2_:String = param1 + LicDef.referralString;
         Utils.trace("DoLink:  " + _loc2_);
         navigateToURL(new URLRequest(_loc2_),"_blank");
      }
      
      public static function Link_TurboNuke(param1:MouseEvent, param2:String = "intro") : *
      {
         navigateToURL(new URLRequest("http://www.turbonuke.com?gamereferral=" + LicDef.referralName),"_blank");
      }
      
      public static function AddButton(param1:SimpleButton, param2:Function) : *
      {
         if(param1 == null)
         {
            Utils.trace("add button button = null");
         }
         if(param2 == null)
         {
            Utils.trace("add button clickCallback = null");
         }
         param1.addEventListener(MouseEvent.CLICK,param2,false,0,true);
      }
      
      internal static function buttonSkipCPMStarAdPressed(param1:MouseEvent) : void
      {
         if(ad != null)
         {
            intro.adBox.removeChild(ad);
         }
         LicDef.GetStage().removeChild(intro);
         intro = null;
         if(showAdFinishedCallback != null)
         {
            showAdFinishedCallback();
         }
      }
   }
}

