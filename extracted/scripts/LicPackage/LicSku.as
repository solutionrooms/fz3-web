package LicPackage
{
   public class LicSku
   {
      
      public var secondaryIntroFunction:Function;
      
      public var introFunction:Function;
      
      public var id:int;
      
      public var name:String;
      
      public var sitelocks:Array;
      
      public var blackList:Array;
      
      public var adtype:int;
      
      public var mainLogoName:String;
      
      public var mainLogoLinkURL:String;
      
      public var facebookFunction:Function;
      
      public var twitterFunction:Function;
      
      public var scaleIntroToStage:Boolean;
      
      public var allowAuthorLink:Boolean;
      
      public var showMoreGamesButton:Boolean;
      
      public var initFunction:Function;
      
      public var allowIntersitialAd:Boolean;
      
      public var introName:String;
      
      public var introFPS:int;
      
      public var secondaryIntroName:String;
      
      public var secondaryIntroLinkURL:String;
      
      public var linkURL:String;
      
      public var walkthroughURL:String;
      
      public var playWithScoresURL:String;
      
      public var allowRemoteAdLoading:Boolean;
      
      public function LicSku(param1:int, param2:String)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.introFunction = null;
         this.secondaryIntroFunction = null;
         this.sitelocks = new Array();
         this.blackList = new Array();
         this.adtype = 0;
         this.mainLogoName = "";
         this.twitterFunction = null;
         this.facebookFunction = null;
         this.scaleIntroToStage = false;
         this.allowAuthorLink = true;
         this.showMoreGamesButton = true;
         this.initFunction = null;
         this.allowIntersitialAd = false;
         this.introName = "";
         this.secondaryIntroName = "";
         this.secondaryIntroLinkURL = "";
         this.linkURL = "";
         this.walkthroughURL = "";
         this.playWithScoresURL = "";
         this.mainLogoLinkURL = "";
         this.allowRemoteAdLoading = false;
         this.introFPS = Defs.fps;
      }
      
      public function AddSiteLock(param1:String, param2:Boolean = false) : void
      {
         this.sitelocks.push(param1);
      }
      
      public function AddBlackList(param1:String, param2:Boolean = false) : void
      {
         this.blackList.push(param1);
      }
   }
}

