package LicPackage
{
   import CPMStar.*;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.AsyncErrorEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   
   public class AdHolder
   {
      
      internal static var currentAd:MovieClip;
      
      internal static var currentPreAd:MovieClip;
      
      internal static var initOnceCompleteCallback:Function;
      
      internal static var urlXMLLoader:URLLoader;
      
      internal static var urlLoader:Loader;
      
      internal static var loadList:Array;
      
      internal static var loadIndex:int;
      
      internal static var ad:DisplayObject;
      
      internal static var items:Vector.<AdItem> = null;
      
      internal static var pread_items:Vector.<AdItem> = null;
      
      public static var adIndex:int = 0;
      
      internal static var AD_URL:String = "http://ads.turbonuke.com/Ads_FlamingZombooka3.php";
      
      public function AdHolder()
      {
         super();
      }
      
      public static function IsLoadedPreAdAvailable() : Boolean
      {
         if(pread_items.length == 0)
         {
            return false;
         }
         if(pread_items[0].urlLoaded == false)
         {
            return false;
         }
         return true;
      }
      
      internal static function MakeIntersitialItemAndTestAdFilters() : AdItem
      {
         var _loc1_:AdItem = new AdItem("Intersitial","intersitial","","");
         if(LicDef.GetCurrentSku().adtype != LicDef.ADTYPE_CPMSTAR)
         {
            _loc1_ = new AdItem("OtherGames","othergames","","");
         }
         if(LicAds.FilterAdForSites())
         {
            _loc1_ = new AdItem("OtherGames","othergames","","");
         }
         return _loc1_;
      }
      
      public static function InitOnce(param1:Function) : *
      {
         initOnceCompleteCallback = param1;
         items = new Vector.<AdItem>();
         pread_items = new Vector.<AdItem>();
         adIndex = -1;
         currentAd = null;
         currentPreAd = null;
         if(LicDef.IsAtKongregate())
         {
            items.push(new AdItem("OtherGames","othergames","",""));
            items.push(new AdItem("OtherGames","othergames","",""));
            items.push(new AdItem("OtherGames","othergames","",""));
            DoCompletedCallback();
         }
         else
         {
            items.push(new AdItem("OtherGames","othergames","",""));
            items.push(new AdItem("OtherGames","othergames","",""));
            items.push(new AdItem("OtherGames","othergames","",""));
            if(LoadCustomAdXML() == false)
            {
               DoCompletedCallback();
            }
         }
      }
      
      internal static function GetAdItemByName(param1:String) : AdItem
      {
         var _loc2_:AdItem = null;
         for each(_loc2_ in items)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      internal static function AddLoadedAdsFromXML(param1:XML) : *
      {
         var _loc2_:AdItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:String = null;
         loadList = new Array();
         items = new Vector.<AdItem>();
         _loc3_ = param1.ad.length();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.ad[_loc4_];
            _loc6_ = XmlHelper.GetAttrString(_loc5_.@id,"");
            _loc7_ = true;
            if(_loc6_ == "OtherGames")
            {
               items.push(new AdItem("OtherGames","othergames","",""));
            }
            else if(_loc6_ == "Intersitial")
            {
               items.push(MakeIntersitialItemAndTestAdFilters());
            }
            else if(_loc6_ == "CycloRacers")
            {
               items.push(new AdItem("CycloRacers","cycloracers","http://www.turbonuke.com/cyclomaniacsracers.php",""));
            }
            else
            {
               _loc8_ = XmlHelper.GetAttrString(_loc5_.@swfurl,"");
               _loc9_ = XmlHelper.GetAttrString(_loc5_.@clickurl,"");
               if(_loc8_ != "")
               {
                  _loc2_ = new AdItem(_loc6_,"othergames",_loc9_,_loc8_);
                  _loc2_.url = "";
                  items.push(_loc2_);
                  loadList.push(_loc2_);
               }
            }
            _loc4_++;
         }
         _loc3_ = param1.pread.length();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.pread[_loc4_];
            _loc6_ = XmlHelper.GetAttrString(_loc5_.@id,"");
            _loc7_ = true;
            _loc8_ = XmlHelper.GetAttrString(_loc5_.@swfurl,"");
            _loc9_ = XmlHelper.GetAttrString(_loc5_.@clickurl,"");
            if(_loc8_ != "")
            {
               _loc2_ = new AdItem(_loc6_,"othergames",_loc9_,_loc8_);
               _loc2_.url = "";
               pread_items.push(_loc2_);
               loadList.push(_loc2_);
            }
            _loc4_++;
         }
         if(loadList != null && loadList.length >= 1)
         {
            LoadNextCustomAd();
         }
         else
         {
            DoCompletedCallback();
         }
      }
      
      public static function LoadCustomAdXML() : Boolean
      {
         var url:String;
         var request:URLRequest;
         if(LicDef.IsRemoteAdLoadingAllowed() == false)
         {
            return false;
         }
         if(LicAds.ShouldTryLoadAdXML() == false)
         {
            return false;
         }
         url = AD_URL;
         request = new URLRequest(url);
         try
         {
            urlXMLLoader = new URLLoader();
            urlXMLLoader.addEventListener(Event.COMPLETE,LoadCustomAdXMLa_Complete);
            urlXMLLoader.addEventListener(ErrorEvent.ERROR,LoadCustomAdXMLa_Error);
            urlXMLLoader.addEventListener(AsyncErrorEvent.ASYNC_ERROR,CustomAdXML_onError1);
            urlXMLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,CustomAdXML_onError2);
            urlXMLLoader.addEventListener(IOErrorEvent.IO_ERROR,CustomAdXML_onError3);
            urlXMLLoader.load(request);
         }
         catch(e:ErrorEvent)
         {
            Utils.traceerror("caught error " + e);
            return false;
         }
         return true;
      }
      
      private static function LoadCustomAdXMLa_Error(param1:Error) : *
      {
         Utils.traceerror("LoadCustomAdXMLa_Error " + param1.message);
         DoCompletedCallback();
      }
      
      private static function LoadCustomAdXMLa_Complete(param1:Event) : *
      {
         var xml:XML;
         var e:Event = param1;
         var s:String = urlXMLLoader.data;
         XML.ignoreWhitespace = true;
         xml = null;
         try
         {
            xml = new XML(s);
         }
         catch(e:Error)
         {
            Utils.traceerror("XML error: " + e.message);
            xml = null;
         }
         if(xml != null)
         {
            AddLoadedAdsFromXML(xml);
         }
         else
         {
            DoCompletedCallback();
         }
         urlXMLLoader.removeEventListener(Event.COMPLETE,LoadCustomAdXMLa_Complete);
         urlXMLLoader.removeEventListener(ErrorEvent.ERROR,LoadCustomAdXMLa_Error);
         urlXMLLoader.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,CustomAdXML_onError1);
         urlXMLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,CustomAdXML_onError2);
         urlXMLLoader.removeEventListener(IOErrorEvent.IO_ERROR,CustomAdXML_onError3);
         urlXMLLoader = null;
      }
      
      internal static function DoCompletedCallback() : *
      {
         var _loc1_:Function = initOnceCompleteCallback;
         initOnceCompleteCallback = null;
         if(_loc1_ != null)
         {
            _loc1_();
         }
      }
      
      private static function CustomAdXML_onError(param1:Error) : *
      {
         Utils.trace("ACustom Ad XML Loading Error: " + param1.message);
         DoCompletedCallback();
      }
      
      private static function CustomAdXML_onError1(param1:AsyncErrorEvent) : *
      {
         Utils.trace("BCustom Ad XML Loading Error: " + param1.error.message);
         DoCompletedCallback();
      }
      
      private static function CustomAdXML_onError2(param1:SecurityErrorEvent) : *
      {
         Utils.trace("CCustom Ad XML Loading Error: " + param1);
         DoCompletedCallback();
      }
      
      private static function CustomAdXML_onError3(param1:IOErrorEvent) : *
      {
         Utils.trace("DCustom Ad XML Loading Error: " + param1.text);
         DoCompletedCallback();
      }
      
      internal static function IsAdADuplicate(param1:int) : AdItem
      {
         var _loc4_:AdItem = null;
         if(param1 == 0)
         {
            return null;
         }
         var _loc2_:AdItem = loadList[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc4_ = loadList[_loc3_];
            if(_loc2_.CompareSwfUrlWith(_loc4_))
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function LoadNextCustomAd() : *
      {
         var _loc2_:AdItem = null;
         var _loc3_:LoaderContext = null;
         var _loc4_:String = null;
         var _loc1_:AdItem = loadList[loadIndex];
         if(_loc1_ != null)
         {
            if(IsAdADuplicate(loadIndex) != null)
            {
               _loc2_ = IsAdADuplicate(loadIndex);
               _loc1_.urlLoaded = true;
               Utils.trace("ad is duplicate: " + _loc1_.swfurl);
               _loc1_.type = "custom";
               _loc1_.url = _loc1_.original_url;
               _loc1_.loader = _loc2_.loader;
               ++loadIndex;
               if(loadIndex < loadList.length)
               {
                  LoadNextCustomAd();
               }
               else
               {
                  DoCompletedCallback();
               }
            }
            else if(_loc1_.swfurl != "")
            {
               _loc3_ = new LoaderContext();
               Security.allowDomain("*");
               Security.allowInsecureDomain("*");
               _loc3_.checkPolicyFile = true;
               _loc3_.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
               _loc1_.loader = new Loader();
               _loc1_.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,LoadNextCustomAd_Complete);
               _loc1_.loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR,onError);
               _loc1_.loader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onError);
               _loc1_.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
               _loc1_.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
               _loc4_ = _loc1_.swfurl;
               _loc1_.loader.load(new URLRequest(_loc4_),_loc3_);
               Utils.trace("loading ad " + _loc4_);
            }
         }
      }
      
      private static function LoadNextCustomAd_Complete(param1:Event) : *
      {
         var _loc2_:AdItem = loadList[loadIndex];
         _loc2_.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,LoadNextCustomAd_Complete);
         _loc2_.loader.contentLoaderInfo.removeEventListener(ErrorEvent.ERROR,onError);
         _loc2_.loader.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,onError);
         _loc2_.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
         _loc2_.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
         _loc2_.urlLoaded = true;
         Utils.trace("ad loaded: " + _loc2_.swfurl);
         _loc2_.type = "custom";
         _loc2_.url = _loc2_.original_url;
         ++loadIndex;
         if(loadIndex < loadList.length)
         {
            LoadNextCustomAd();
         }
         else
         {
            DoCompletedCallback();
         }
      }
      
      private static function onError(param1:IOErrorEvent) : *
      {
         Utils.traceerror("JJJ Custom Ad Loading Error:" + param1.text);
         DoCompletedCallback();
      }
      
      public static function RemoveAd(param1:MovieClip) : *
      {
         var _loc2_:AdItem = null;
         if(currentAd != null)
         {
            _loc2_ = items[adIndex];
            if(_loc2_.type == "othergames")
            {
               param1.removeChild(currentAd);
            }
            else if(_loc2_.type == "intersitial")
            {
               RemoveIntersitialMC();
               param1.removeChild(currentAd);
            }
            else if(_loc2_.type == "custom")
            {
               if(_loc2_.urlLoaded == false)
               {
                  param1.removeChild(currentAd);
               }
               else
               {
                  RemoveCustomMC(param1);
               }
            }
            else if(_loc2_.type == "cycloracers")
            {
               param1.removeChild(currentAd);
            }
            else if(_loc2_.type == "blank")
            {
               param1.removeChild(currentAd);
            }
            if(_loc2_.url != "")
            {
               currentAd.removeEventListener(MouseEvent.CLICK,AdClicked);
            }
            currentAd = null;
         }
      }
      
      internal static function getVisibleBounds(param1:DisplayObject) : Rectangle
      {
         var _loc2_:Matrix = new Matrix();
         _loc2_.tx = -param1.getBounds(null).x;
         _loc2_.ty = -param1.getBounds(null).y;
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc3_.draw(param1,_loc2_);
         var _loc4_:Rectangle = _loc3_.getColorBoundsRect(4294967295,0,false);
         _loc3_.dispose();
         return _loc4_;
      }
      
      public static function AddAd(param1:MovieClip) : *
      {
         currentAd = GetAd();
         if(currentAd != null)
         {
            param1.addChild(currentAd);
         }
      }
      
      public static function GetAd() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(items.length == 0)
         {
            items.push(new AdItem("OtherGames","othergames","",""));
         }
         ++adIndex;
         if(adIndex >= items.length)
         {
            adIndex = 0;
         }
         var _loc2_:AdItem = items[adIndex];
         if(_loc2_.type == "othergames")
         {
            _loc1_ = OtherGames.GetOtherGamesMC();
         }
         if(_loc2_.type == "intersitial")
         {
            _loc1_ = GetIntersitialMC();
         }
         if(_loc2_.type == "cycloracers")
         {
            _loc1_ = GetCycloRacersMC();
         }
         if(_loc2_.type == "custom")
         {
            _loc1_ = GetCustomMC();
         }
         if(_loc2_.type == "blank")
         {
            _loc1_ = GetBlankMC();
         }
         if(_loc2_.url != "")
         {
            _loc1_.addEventListener(MouseEvent.CLICK,AdClicked);
            _loc1_.buttonMode = true;
            _loc1_.useHandCursor = true;
         }
         return _loc1_;
      }
      
      public static function AdClicked(param1:MouseEvent) : *
      {
         var _loc2_:AdItem = items[adIndex];
         if(_loc2_ != null)
         {
            if(_loc2_.url != "")
            {
               navigateToURL(new URLRequest(_loc2_.url),"_blank");
            }
         }
      }
      
      public static function PreAdClicked(param1:MouseEvent) : *
      {
         var _loc2_:AdItem = pread_items[0];
         if(_loc2_ != null)
         {
            if(_loc2_.url != "")
            {
               navigateToURL(new URLRequest(_loc2_.url),"_blank");
            }
         }
      }
      
      internal static function GetCycloRacersMC() : MovieClip
      {
         return new ad_banner_cycloracers();
      }
      
      internal static function GetBlankMC() : MovieClip
      {
         return new MovieClip();
      }
      
      internal static function RemoveCustomMC(param1:MovieClip) : *
      {
         param1.removeChild(currentAd);
      }
      
      internal static function GetCustomMC() : MovieClip
      {
         var _loc1_:AdItem = items[adIndex];
         if(_loc1_.urlLoaded == false)
         {
            return GetBlankMC();
         }
         return _loc1_.loader.content as MovieClip;
      }
      
      internal static function GetPreAdItem() : AdItem
      {
         if(pread_items == null)
         {
            return null;
         }
         if(pread_items.length == 0)
         {
            return null;
         }
         return pread_items[0];
      }
      
      internal static function GetPreAdCustomMC() : MovieClip
      {
         var _loc1_:AdItem = pread_items[0];
         if(_loc1_.urlLoaded == false)
         {
            return GetBlankMC();
         }
         return _loc1_.loader.content as MovieClip;
      }
      
      internal static function RemoveIntersitialMC() : *
      {
         if(ad != null)
         {
            currentAd.removeChild(ad);
         }
         ad = null;
      }
      
      internal static function GetIntersitialMC() : MovieClip
      {
         return GetIntersitialMC_CPMStar();
      }
      
      internal static function GetIntersitialMC_CPMStar() : MovieClip
      {
         var _loc1_:MovieClip = null;
         var _loc2_:String = null;
         var _loc4_:int = 0;
         var _loc3_:int = int(LicDef.CPMStarIntersitialsSpotIDs.length);
         if(_loc3_ == 1)
         {
            _loc2_ = LicDef.CPMStarIntersitialsSpotIDs[0];
         }
         if(_loc3_ == 2)
         {
            _loc4_ = Utils.RandBetweenInt(0,1000);
            if(_loc4_ < 500)
            {
               _loc2_ = LicDef.CPMStarIntersitialsSpotIDs[0];
            }
            else
            {
               _loc2_ = LicDef.CPMStarIntersitialsSpotIDs[1];
            }
         }
         _loc1_ = new MovieClip();
         ad = new AdLoader(_loc2_);
         _loc1_.addChild(ad);
         ad.x = 0;
         ad.y = 0;
         Utils.trace("showing intersitial ");
         return _loc1_;
      }
   }
}

