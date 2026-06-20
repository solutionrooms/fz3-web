package LicPackage
{
   import flash.display.MovieClip;
   
   public class LicDef
   {
      
      public static var domain:String;
      
      public static var stg:MovieClip;
      
      internal static var skus:Array;
      
      public static const LICENSOR_DEVELOPMENT:int = 0;
      
      public static const LICENSOR_NOBRANDING:int = 1;
      
      public static const LICENSOR_LONGANIMALS:int = 2;
      
      public static const LICENSOR_LONGANIMALS_SITELOCKED:int = 3;
      
      public static const LICENSOR_ROBOTJAM:int = 4;
      
      public static const LICENSOR_TURBONUKE:int = 5;
      
      public static const LICENSOR_KONGREGATE:int = 6;
      
      public static const LICENSOR_KONGREGATE_ONSITE:int = 7;
      
      public static const LICENSOR_ANDKON:int = 8;
      
      public static const LICENSOR_ARMORGAMES:int = 9;
      
      public static const LICENSOR_ARMORGAMES_VIRAL:int = 10;
      
      public static const LICENSOR_MOUSEBREAKER:int = 11;
      
      public static const LICENSOR_ADDICTINGGAMES:int = 12;
      
      public static const ADTYPE_NONE:int = 0;
      
      public static const ADTYPE_MOCHI:int = 1;
      
      public static const ADTYPE_MOCHI_VC:int = 2;
      
      public static const ADTYPE_CPMSTAR:int = 3;
      
      public static const ADTYPE_ARMOR_BROADCAST_SYSTEM:int = 4;
      
      public static var MochiAdID:String = "a4225d18663ab451";
      
      public static var MochiAdRes:String = "640x480";
      
      public static var primary_sponsor:int = LICENSOR_KONGREGATE;
      
      public static var licensor:int = LICENSOR_ARMORGAMES;
      
      public static var armorHighScore_devKey:String = "57e6ffa35f343197fbd276da0a94ccbb";
      
      public static var armorHighScore_gameKey:String = "flaming-zombooka-3";
      
      public static var Playtomic_id:int = 4877;
      
      public static var Playtomic_GUID:String = "86cc2a26876a4b03";
      
      public static var Playtomic_APIKey:String = "9256fb730a5b48b2b696885aeb47b8";
      
      public static var referralName:String = "flamingzombooka3";
      
      public static var referralString:String = "?haref=flamingzombooka3&src=spon-puzzle-flamingzombooka3-site-x";
      
      public static var authorLinks:Array = new Array();
      
      public static var CPMStarContentSpotIDs:Array = new Array();
      
      public static var CPMStarIntersitialsSpotIDs:Array = new Array();
      
      public static var CPMStarFixedTime:int = 10;
      
      public static var localTest:Boolean = false;
      
      public static var kongregateEmbedFlag:Boolean = true;
      
      authorLinks.push("http://www.turbonuke.com");
      CPMStarContentSpotIDs.push(String("5877Q517DE101"));
      
      public function LicDef()
      {
         super();
      }
      
      public static function GetCurrentSku() : LicSku
      {
         return GetSku(licensor);
      }
      
      public static function GetSku(param1:int) : LicSku
      {
         var _loc2_:LicSku = null;
         for each(_loc2_ in skus)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      internal static function IsOnCorrectSite() : Boolean
      {
         var _loc2_:String = null;
         if(localTest == true)
         {
            return true;
         }
         var _loc1_:LicSku = GetSku(licensor);
         if(_loc1_.sitelocks.length == 0)
         {
            return true;
         }
         for each(_loc2_ in _loc1_.sitelocks)
         {
            if(_loc2_ == domain)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function GetLicensor() : int
      {
         return licensor;
      }
      
      public static function InitFromPreloader(param1:MovieClip) : *
      {
         InitSkus();
         stg = param1;
         domain = GetDomain();
         kongregateEmbedFlag = stg.stage.loaderInfo.parameters.kongregate;
         SkuModify();
      }
      
      public static function GetStage() : MovieClip
      {
         return stg;
      }
      
      public static function GetDomain() : String
      {
         var _loc1_:String = stg.loaderInfo.url;
         var _loc2_:Number = _loc1_.indexOf("://") + 3;
         var _loc3_:Number = _loc1_.indexOf("/",_loc2_);
         var _loc4_:String = _loc1_.substring(_loc2_,_loc3_);
         var _loc5_:Number = _loc4_.lastIndexOf(".") - 1;
         var _loc6_:Number = _loc4_.lastIndexOf(".",_loc5_) + 1;
         return _loc4_.substring(_loc6_,_loc4_.length);
      }
      
      internal static function SkuModify() : void
      {
         if(LicDef.localTest == true)
         {
            return;
         }
         if(licensor == LICENSOR_KONGREGATE && IsAtKongregate())
         {
            licensor = LICENSOR_KONGREGATE_ONSITE;
         }
         if(IsOnCorrectSite() == false)
         {
            licensor = primary_sponsor;
         }
      }
      
      public static function IsRemoteAdLoadingAllowed() : Boolean
      {
         return GetCurrentSku().allowRemoteAdLoading;
      }
      
      public static function IsAtKongregate() : Boolean
      {
         if(domain == "kongregate.com" && kongregateEmbedFlag)
         {
            return true;
         }
         return false;
      }
      
      public static function InitSkus() : void
      {
         var _loc1_:LicSku = null;
         skus = new Array();
         _loc1_ = new LicSku(LICENSOR_DEVELOPMENT,"Development");
         _loc1_.AddSiteLock("longanimalsgames.com");
         _loc1_.AddSiteLock("flashgamelicense.com");
         _loc1_.AddSiteLock("turbonuke.com");
         _loc1_.AddSiteLock("");
         _loc1_.showMoreGamesButton = true;
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_TURBONUKE,"TurboNUKE");
         _loc1_.AddSiteLock("turbonuke.com");
         _loc1_.AddSiteLock("");
         _loc1_.introName = "Intro_TurboNuke";
         _loc1_.mainLogoName = "turbonuke";
         _loc1_.linkURL = "http://www.turbonuke.com";
         _loc1_.adtype = ADTYPE_CPMSTAR;
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_KONGREGATE,"Kongregate");
         _loc1_.introName = "Intro_Kongregate";
         _loc1_.mainLogoName = "kongregate";
         _loc1_.linkURL = "http://www.kongregate.com";
         _loc1_.adtype = ADTYPE_CPMSTAR;
         _loc1_.allowIntersitialAd = false;
         _loc1_.playWithScoresURL = "http://www.kongregate.com/games/turboNuke/flaming-zombooka-3-carnival";
         _loc1_.walkthroughURL = "http://www.kongregate.com/games/turboNuke/flaming-zombooka-3-walkthrough";
         _loc1_.secondaryIntroName = "Intro_TurboNuke";
         _loc1_.secondaryIntroLinkURL = "http://www.turbonuke.com";
         _loc1_.allowRemoteAdLoading = true;
         _loc1_.allowAuthorLink = true;
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_KONGREGATE_ONSITE,"Kongregate OnSite");
         _loc1_.introName = "Intro_Kongregate";
         _loc1_.mainLogoName = "kongregate";
         _loc1_.walkthroughURL = "http://www.kongregate.com/games/turboNuke/flaming-zombooka-3-walkthrough";
         _loc1_.allowIntersitialAd = false;
         _loc1_.secondaryIntroName = "Intro_TurboNuke";
         _loc1_.secondaryIntroLinkURL = "http://www.turbonuke.com";
         _loc1_.allowAuthorLink = true;
         _loc1_.allowRemoteAdLoading = false;
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_ANDKON,"Andkon");
         _loc1_.AddSiteLock("andkon.com");
         _loc1_.introName = "Intro_Andkon";
         _loc1_.mainLogoName = "andkon";
         _loc1_.linkURL = "http://www.andkon.com/arcade/";
         _loc1_.walkthroughURL = "walkthrough.html";
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_ARMORGAMES,"Armor Games");
         _loc1_.AddSiteLock("armorgames.com");
         _loc1_.introName = "Intro_ArmorGames";
         _loc1_.adtype = ADTYPE_ARMOR_BROADCAST_SYSTEM;
         _loc1_.mainLogoName = "armorGames";
         _loc1_.linkURL = "http://www.armorgames.com";
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_NOBRANDING,"No branding");
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_MOUSEBREAKER,"MouseBreaker");
         _loc1_.AddSiteLock("mousebreaker.com");
         _loc1_.mainLogoName = "mousebreaker";
         _loc1_.showMoreGamesButton = false;
         _loc1_.introName = "Intro_MouseBreaker";
         _loc1_.allowAuthorLink = false;
         _loc1_.walkthroughURL = "http://www.mousebreaker.com/games/flamingzombooka3walkthrough/playgame";
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_ADDICTINGGAMES,"Addicting Games");
         _loc1_.introName = "Intro_AddictingGames";
         _loc1_.mainLogoName = "addictingGames";
         _loc1_.linkURL = "http://www.addictinggames.com";
         _loc1_.AddSiteLock("addictinggames.com");
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_LONGANIMALS,"LongAnimals");
         _loc1_.adtype = ADTYPE_CPMSTAR;
         _loc1_.mainLogoName = "longAnimals";
         _loc1_.linkURL = "http://www.longanimalsgames.com";
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_LONGANIMALS_SITELOCKED,"LongAnimalsSitelocked");
         _loc1_.AddSiteLock("longanimalsgames.com");
         _loc1_.AddSiteLock("longanimals.com");
         _loc1_.mainLogoName = "longAnimals";
         _loc1_.linkURL = "http://www.longanimalsgames.com";
         skus.push(_loc1_);
         _loc1_ = new LicSku(LICENSOR_ROBOTJAM,"RobotJam");
         _loc1_.AddSiteLock("robotjam.com");
         _loc1_.AddSiteLock("robotjamgames.com");
         _loc1_.introName = "Intro_RobotJam";
         _loc1_.scaleIntroToStage = true;
         _loc1_.mainLogoName = "robotJam";
         _loc1_.linkURL = "http://www.robotjamgames.com";
         _loc1_.adtype = ADTYPE_CPMSTAR;
         skus.push(_loc1_);
      }
   }
}

