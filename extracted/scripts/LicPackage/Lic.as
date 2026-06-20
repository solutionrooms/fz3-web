package LicPackage
{
   import CPMStar.*;
   import Playtomic.*;
   import UIPackage.UI;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import mochi.as3.*;
   
   public class Lic
   {
      
      public static var intro:MovieClip;
      
      internal static var showSecondaryIntroCallback:Function;
      
      internal static var showIntroCallback:Function;
      
      internal static var oldFrameRate:int;
      
      internal static var twitterString:String;
      
      internal static var tinyLoader:URLLoader;
      
      internal static var submitScoreCallback:Function;
      
      internal static var getHighScoreFunction:Function;
      
      internal static var highScore_Textfield:TextField;
      
      internal static var highScore_Button:SimpleButton;
      
      internal static var agi:*;
      
      internal static var highscore_callback:Function;
      
      internal static var kongregate:*;
      
      private static var callback:Function;
      
      public static var Playtomic_SubmitScore_CB:Function = null;
      
      internal static var moreGamesText:Array = new Array("More Games","Free Games","Other Games","Great Games","Play More","Puzzle Games");
      
      internal static var moreGamesTextLinks:Array = new Array("","","","","","http://www.kongregate.com/puzzle-games");
      
      internal static var submitScoreName:String = "Your Name";
      
      internal static var kong_isLoaded:Boolean = false;
      
      public function Lic()
      {
         super();
      }
      
      public static function Playtomic_IsActive() : Boolean
      {
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            return true;
         }
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE)
         {
            return true;
         }
         return false;
      }
      
      public static function Playtomic_CustomMetric(param1:String, param2:String = null) : void
      {
         if(Playtomic_IsActive() == false)
         {
            return;
         }
         Log.CustomMetric(param1,param2);
      }
      
      public static function Playtomic_LevelMetric(param1:String, param2:* = null) : void
      {
         if(Playtomic_IsActive() == false)
         {
            return;
         }
         Log.LevelCounterMetric(param1,param2);
      }
      
      public static function Playtomic_LogPlay() : void
      {
         if(Playtomic_IsActive() == false)
         {
            return;
         }
         Log.Play();
      }
      
      public static function Playtomic_ForceSend() : void
      {
         if(Playtomic_IsActive() == false)
         {
            return;
         }
         Log.ForceSend();
      }
      
      public static function Playtomic_Log() : void
      {
         if(Playtomic_IsActive() == false)
         {
            return;
         }
         Utils.trace("initialising playtomic: " + LicDef.GetStage().root.loaderInfo.loaderURL);
         Log.View(LicDef.Playtomic_id,LicDef.Playtomic_GUID,LicDef.Playtomic_APIKey,LicDef.GetStage().root.loaderInfo.loaderURL);
      }
      
      public static function Playtomic_Link(param1:String, param2:String, param3:String = "") : void
      {
         if(Playtomic_IsActive() == false)
         {
            navigateToURL(new URLRequest(param1),"_blank");
         }
         else
         {
            Link.Open(param1,param2,param3);
         }
      }
      
      public static function Playtomic_GetScoreComplete(param1:Array, param2:int, param3:Response) : *
      {
         if(Playtomic_SubmitScore_CB != null)
         {
            Playtomic_SubmitScore_CB(param1,param2,param3);
         }
      }
      
      public static function Playtomic_SubmitScore_Complete(param1:Response) : *
      {
         if(Playtomic_SubmitScore_CB != null)
         {
            Playtomic_SubmitScore_CB(param1);
         }
      }
      
      public static function Playtomic_SubmitScore(param1:String, param2:int, param3:String, param4:Function = null) : *
      {
         Playtomic_SubmitScore_CB = param4;
         if(Playtomic_IsActive() == false)
         {
            return;
         }
         Utils.trace("Submitting " + param2 + " to " + param3);
         if(param1 == "")
         {
            param1 = "undefined";
         }
         var _loc5_:PlayerScore = new PlayerScore(param1,param2);
         Leaderboards.Save(_loc5_,param3,Playtomic_SubmitScore_Complete,{
            "allowduplicates":false,
            "highest":false
         });
      }
      
      public static function Playtomic_GetScores(param1:String, param2:Function) : *
      {
         Playtomic_SubmitScore_CB = param2;
         if(Playtomic_IsActive() == false)
         {
            return;
         }
         Utils.trace("STARTIGN GET SCORES for " + param1);
         Leaderboards.List(param1,Playtomic_GetScoreComplete,{"highest":false});
      }
      
      internal static function AuthorLinkPressed(param1:MouseEvent) : void
      {
         if(LicDef.authorLinks.length == 0)
         {
            return;
         }
         var _loc2_:int = Utils.RandBetweenInt(0,LicDef.authorLinks.length - 1);
         _loc2_ = Utils.LimitNumber(0,LicDef.authorLinks.length - 1,_loc2_);
         DoLink(LicDef.authorLinks[_loc2_]);
      }
      
      public static function GetLicensor() : int
      {
         return LicDef.licensor;
      }
      
      public static function InitFromMain() : void
      {
         InitHighscores();
      }
      
      public static function GetCurrentSku() : LicSku
      {
         return LicDef.GetSku(LicDef.GetLicensor());
      }
      
      public static function ShowIntro(param1:Function) : void
      {
         showIntroCallback = param1;
         if(GetCurrentSku().secondaryIntroName != "")
         {
            showSecondaryIntroCallback = showIntroCallback;
            showIntroCallback = ShowSecondaryIntro;
         }
         if(LicDef.IsOnCorrectSite() == false)
         {
            ShowSitelockedScreen();
            return;
         }
         if(GetCurrentSku().introName != "")
         {
            AddIntro(GetCurrentSku().introName,GetCurrentSku().introFPS);
         }
         else
         {
            showIntroCallback();
         }
      }
      
      public static function ShowSecondaryIntro() : void
      {
         if(GetCurrentSku().secondaryIntroName != "")
         {
            AddSecondaryIntro(GetCurrentSku().secondaryIntroName);
         }
         else
         {
            showIntroCallback();
         }
      }
      
      internal static function AddIntro(param1:String, param2:int = 0) : *
      {
         var _loc3_:LicSku = GetCurrentSku();
         var _loc4_:Class = getDefinitionByName(param1) as Class;
         var _loc5_:MovieClip = new _loc4_() as MovieClip;
         oldFrameRate = LicDef.GetStage().stage.frameRate;
         if(param2 != 0)
         {
            LicDef.GetStage().stage.frameRate = param2;
         }
         intro = _loc5_;
         LicDef.GetStage().addChild(intro);
         intro.x = Defs.displayarea_w / 2;
         intro.y = Defs.displayarea_h / 2;
         intro.useHandCursor = true;
         intro.buttonMode = true;
         intro.addEventListener(Event.ENTER_FRAME,AddIntro_EnterFrame,false,0,true);
         if(_loc3_.linkURL != "")
         {
            intro.addEventListener(MouseEvent.CLICK,ClickedLinkURL,false,0,true);
         }
         if(_loc3_.scaleIntroToStage)
         {
            if(Defs.displayarea_w < 640)
            {
               intro.scaleX = intro.scaleY = 640 / intro.width;
            }
         }
         intro.gotoAndPlay(1);
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
      
      internal static function AddIntro_EnterFrame(param1:Event) : *
      {
         var _loc2_:LicSku = null;
         if(intro == null)
         {
            return;
         }
         if(intro.totalFrames == intro.currentFrame)
         {
            LicDef.GetStage().stage.frameRate = oldFrameRate;
            _loc2_ = GetCurrentSku();
            if(_loc2_.linkURL != "")
            {
               intro.removeEventListener(MouseEvent.CLICK,ClickedLinkURL);
            }
            intro.stop();
            intro.removeEventListener(Event.ENTER_FRAME,AddIntro_EnterFrame);
            LicDef.GetStage().removeChild(intro);
            intro = null;
            if(showIntroCallback != null)
            {
               showIntroCallback();
            }
         }
      }
      
      internal static function AddSecondaryIntro(param1:String) : *
      {
         var _loc2_:LicSku = GetCurrentSku();
         var _loc3_:Class = getDefinitionByName(param1) as Class;
         intro = new _loc3_() as MovieClip;
         LicDef.GetStage().addChild(intro);
         intro.x = Defs.displayarea_w / 2;
         intro.y = Defs.displayarea_h / 2;
         intro.useHandCursor = true;
         intro.buttonMode = true;
         intro.mouseEnabled = true;
         intro.addEventListener(Event.ENTER_FRAME,AddSecondaryIntro_EnterFrame,false,0,true);
         if(_loc2_.secondaryIntroLinkURL != "")
         {
            intro.addEventListener(MouseEvent.CLICK,SecondaryIntro_Clicked,false,0,true);
         }
         intro.gotoAndPlay(1);
      }
      
      internal static function SecondaryIntro_Clicked(param1:MouseEvent) : *
      {
         var _loc2_:LicSku = GetCurrentSku();
         DoLink(_loc2_.secondaryIntroLinkURL);
      }
      
      public static function DoLink(param1:String, param2:String = "") : *
      {
         var _loc3_:String = param1;
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            _loc3_ += LicDef.referralString;
         }
         Playtomic_Link(_loc3_,param2);
      }
      
      internal static function AddSecondaryIntro_EnterFrame(param1:Event) : *
      {
         var _loc2_:LicSku = null;
         if(intro.totalFrames == intro.currentFrame)
         {
            _loc2_ = GetCurrentSku();
            if(_loc2_.secondaryIntroLinkURL != "")
            {
               intro.removeEventListener(MouseEvent.CLICK,SecondaryIntro_Clicked);
            }
            intro.stop();
            intro.removeEventListener(Event.ENTER_FRAME,AddSecondaryIntro_EnterFrame);
            LicDef.GetStage().removeChild(intro);
            intro = null;
            if(showSecondaryIntroCallback != null)
            {
               showSecondaryIntroCallback();
            }
         }
      }
      
      internal static function ShowSitelockedScreen() : *
      {
         intro = new SitelockedScreen();
         intro.x = 0;
         intro.y = 0;
         LicDef.GetStage().addChild(intro);
         intro.addEventListener(MouseEvent.CLICK,SitelockScreen_Clicked);
      }
      
      internal static function SitelockScreen_Clicked(param1:MouseEvent) : *
      {
      }
      
      public static function Link_Walkthrough(param1:MouseEvent, param2:String = "intro") : *
      {
      }
      
      public static function Link_TurboNukeRegister(param1:MouseEvent, param2:String = "intro") : *
      {
         navigateToURL(new URLRequest("http://www.turbonuke.com/login.php"),"_self");
      }
      
      public static function Link_TurboNuke(param1:MouseEvent, param2:String = "intro") : *
      {
         navigateToURL(new URLRequest("http://www.turbonuke.com?gamereferral=" + LicDef.referralName),"_blank");
      }
      
      public static function AuthorButton(param1:SimpleButton) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:LicSku = GetCurrentSku();
         if(_loc2_.allowAuthorLink == false)
         {
            param1.visible = false;
            return;
         }
         param1.addEventListener(MouseEvent.CLICK,AuthorLinkPressed,false,0,true);
      }
      
      public static function PlayWithScoresButton(param1:SimpleButton) : *
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:LicSku = GetCurrentSku();
         param1.visible = false;
         if(LicDef.GetDomain() == "notdoppler.com")
         {
            return;
         }
         if(_loc2_.playWithScoresURL == null)
         {
            return;
         }
         if(_loc2_.playWithScoresURL == "")
         {
            return;
         }
         param1.visible = true;
         UI.AddButton(param1,PlayWithScoresButton_Clicked);
      }
      
      public static function PlayWithScoresButton_Clicked(param1:MouseEvent) : *
      {
         var _loc2_:LicSku = GetCurrentSku();
         DoLink(_loc2_.playWithScoresURL,"play_with_scores");
      }
      
      internal static function HasMoreGamesButton() : Boolean
      {
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            return false;
         }
         var _loc1_:LicSku = GetCurrentSku();
         return _loc1_.showMoreGamesButton;
      }
      
      public static function ResetAnimatedMCMoreGamesButton(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(HasMoreGamesButton() == false)
         {
            param1.visible = false;
            return;
         }
         var _loc2_:LicSku = GetCurrentSku();
         if(_loc2_.linkURL == "")
         {
            param1.visible = false;
            return;
         }
         param1.moreGamesOverrideIndex = Utils.RandBetweenInt(0,moreGamesText.length - 1);
         param1.buttonName.text = moreGamesText[param1.moreGamesOverrideIndex];
      }
      
      public static function AnimatedMCMoreGamesButton(param1:MovieClip, param2:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(HasMoreGamesButton() == false)
         {
            param1.visible = false;
            return;
         }
         var _loc3_:LicSku = GetCurrentSku();
         if(_loc3_.linkURL == "")
         {
            param1.visible = false;
            return;
         }
         param1.moreGamesOverrideIndex = Utils.RandBetweenInt(0,moreGamesText.length - 1);
         if(LicDef.GetLicensor() != LicDef.LICENSOR_KONGREGATE && LicDef.GetLicensor() != LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            param1.moreGamesOverrideIndex = 0;
         }
         param1.buttonName.text = moreGamesText[param1.moreGamesOverrideIndex];
         if(LicDef.GetLicensor() == LicDef.LICENSOR_ANDKON)
         {
            param1.buttonName.text = "ANDKON ARCADE";
            param1.moreGamesOverrideIndex = 0;
         }
         UI.AddAnimatedMCButton(param1,MoreGamesButtonMCPressed);
      }
      
      internal static function MoreGamesButtonMCPressed(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.moreGamesOverrideIndex == -1)
         {
            ClickedLinkURL(param1);
         }
         else if(_loc2_.moreGamesOverrideIndex < 0 || _loc2_.moreGamesOverrideIndex >= moreGamesTextLinks.length)
         {
            ClickedLinkURL(param1);
         }
         else
         {
            _loc3_ = moreGamesTextLinks[_loc2_.moreGamesOverrideIndex];
            if(_loc3_ == "")
            {
               ClickedLinkURL(param1);
            }
            else
            {
               DoLink(_loc3_,moreGamesText[_loc2_.moreGamesOverrideIndex]);
            }
         }
      }
      
      public static function MCMoreGamesButton(param1:MovieClip, param2:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(HasMoreGamesButton() == false)
         {
            param1.visible = false;
            return;
         }
         var _loc3_:LicSku = GetCurrentSku();
         if(_loc3_.linkURL == "")
         {
            param1.visible = false;
            return;
         }
         param1.moreGamesOverrideIndex = Utils.RandBetweenInt(0,moreGamesText.length - 1);
         param1.buttonName.text = moreGamesText[param1.moreGamesOverrideIndex];
         param1.buttonName.mouseEnabled = false;
         UI.AddMCButton(param1,MoreGamesButtonMCPressed);
      }
      
      public static function MoreGamesButton(param1:SimpleButton, param2:String) : void
      {
         var _loc5_:Class = null;
         var _loc6_:SimpleButton = null;
         if(param1 == null)
         {
            return;
         }
         if(HasMoreGamesButton() == false)
         {
            param1.visible = false;
            return;
         }
         var _loc3_:LicSku = GetCurrentSku();
         if(_loc3_.linkURL == "")
         {
            param1.visible = false;
            return;
         }
         var _loc4_:MovieClip = new MovieClip();
         param1.parent.addChild(_loc4_);
         _loc4_.x = param1.x;
         _loc4_.y = param1.y;
         param1.parent.removeChild(param1);
         _loc4_.addChild(param1);
         param1.x = 0;
         param1.y = 0;
         if(LicDef.GetLicensor() == LicDef.LICENSOR_ANDKON)
         {
            _loc5_ = getDefinitionByName("buttonMoreGamesAndkon") as Class;
            _loc6_ = new _loc5_() as SimpleButton;
            param1.parent.addChild(_loc6_);
            _loc6_.x = param1.x;
            _loc6_.y = param1.y;
            _loc6_.scaleX = param1.scaleX;
            _loc6_.scaleY = param1.scaleY;
            param1.parent.removeChild(param1);
            param1 = _loc6_;
         }
         _loc4_.moreGamesOverrideIndex = -1;
         _loc4_.addEventListener(MouseEvent.CLICK,MoreGamesButtonMCPressed,false,0,true);
         _loc4_._from = param2;
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
            else
            {
               Utils.trace("Lic: MainLogo Error. Null child found. (not a button?)");
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
            else
            {
               Utils.trace("Lic: MainLogo Error. Null child found. (not a button?)");
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
            else
            {
               Utils.trace("Lic: MainLogo Error. Can\'t find logo: " + _loc2_.mainLogoName);
            }
         }
      }
      
      public static function AnimatedMCWalkthroughButton(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.visible = false;
         var _loc2_:LicSku = GetCurrentSku();
         if(_loc2_.walkthroughURL == "")
         {
            return;
         }
         UI.AddAnimatedMCButton(param1,WalkthroughButtonPressed);
         param1.visible = true;
      }
      
      public static function WalkthroughButton(param1:SimpleButton) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.visible = false;
         var _loc2_:LicSku = GetCurrentSku();
         if(_loc2_.walkthroughURL == "")
         {
            return;
         }
         param1.visible = true;
         param1.addEventListener(MouseEvent.CLICK,WalkthroughButtonPressed,false,0,true);
      }
      
      internal static function WalkthroughButtonPressed(param1:MouseEvent) : void
      {
         var _loc2_:LicSku = GetCurrentSku();
         DoLink(_loc2_.walkthroughURL);
      }
      
      internal static function FacebookButton(param1:SimpleButton) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.visible = false;
         var _loc2_:LicSku = GetCurrentSku();
         if(_loc2_.facebookFunction == null)
         {
            return;
         }
         param1.visible = true;
         param1.addEventListener(MouseEvent.CLICK,_loc2_.facebookFunction,false,0,true);
      }
      
      internal static function TwitterButton(param1:SimpleButton, param2:String = "") : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.visible = false;
         var _loc3_:LicSku = GetCurrentSku();
         if(_loc3_.twitterFunction == null)
         {
            return;
         }
         twitterString = param2;
         param1.visible = true;
         param1.addEventListener(MouseEvent.CLICK,_loc3_.twitterFunction,false,0,true);
      }
      
      public static function TwitterButtonPressed(param1:MouseEvent) : *
      {
         TwitterPost();
      }
      
      internal static function TwitterPost() : void
      {
         tinyLoader = new URLLoader();
         tinyLoader.dataFormat = URLLoaderDataFormat.TEXT;
         tinyLoader.addEventListener(Event.COMPLETE,TwitterPost_gotTinyURL);
         tinyLoader.load(new URLRequest("http://tinyurl.com/api-create.php?url=http://www.turbonuke.com&referral=twitter"));
      }
      
      internal static function TwitterPost_gotTinyURL(param1:Event) : void
      {
         var _loc2_:String = "http://twitter.com/home?status=Look out for Turbo Nuke" + encodeURIComponent(tinyLoader.data);
         navigateToURL(new URLRequest(_loc2_),"_blank");
      }
      
      internal static function RetrieveHighScore(param1:int) : *
      {
         return 1000;
      }
      
      public static function SubmitScoreButton(param1:SimpleButton, param2:TextField, param3:Function = null) : void
      {
         getHighScoreFunction = RetrieveHighScore;
         highScore_Textfield = param2;
         highScore_Button = param1;
         submitScoreCallback = param3;
         highScore_Button.visible = false;
         highScore_Textfield.visible = false;
         if(LicDef.GetLicensor() == LicDef.LICENSOR_MOUSEBREAKER)
         {
            highScore_Button.visible = true;
            highScore_Textfield.visible = true;
            highScore_Textfield.text = submitScoreName;
            highScore_Button.addEventListener(MouseEvent.CLICK,SubmitScore_Clicked_Callback,false,0,true);
         }
         if(GetLicensor() == LicDef.LICENSOR_ARMORGAMES)
         {
            highScore_Button.visible = true;
            highScore_Textfield.visible = false;
            highScore_Textfield.text = submitScoreName;
            highScore_Button.addEventListener(MouseEvent.CLICK,SubmitScore_Clicked_Callback,false,0,true);
         }
      }
      
      internal static function SubmitScore_Clicked_Callback(param1:MouseEvent) : *
      {
         highScore_Button.visible = false;
         highScore_Textfield.visible = false;
         var _loc2_:int = RetrieveHighScore(0);
         submitScoreName = highScore_Textfield.text;
         if(GetLicensor() == LicDef.LICENSOR_MOUSEBREAKER)
         {
            SubmitScore_MouseBreaker(_loc2_,highScore_Textfield.text,SubmitScore_Complete_Callback);
         }
         if(GetLicensor() == LicDef.LICENSOR_ARMORGAMES)
         {
            SubmitScore_ArmorGames(_loc2_,SubmitScore_Complete_Callback);
         }
      }
      
      internal static function SubmitScore_Complete_Callback(param1:MouseEvent) : *
      {
         if(submitScoreCallback != null)
         {
            submitScoreCallback();
         }
      }
      
      internal static function ScoreSubmitted() : *
      {
      }
      
      public static function InitHighscores() : *
      {
         if(LicDef.GetLicensor() == LicDef.LICENSOR_ARMORGAMES || LicDef.GetLicensor() == LicDef.LICENSOR_ARMORGAMES_VIRAL)
         {
            InitHighScores_ArmorGames();
         }
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            InitHighScores_Kongregate();
         }
      }
      
      internal static function InitHighScores_ArmorGames() : void
      {
         var _loc1_:String = "http://agi.armorgames.com/assets/agi/AGI.swf";
         Security.allowDomain(_loc1_);
         Security.allowInsecureDomain(_loc1_);
         var _loc2_:URLRequest = new URLRequest(_loc1_);
         var _loc3_:Loader = new Loader();
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,InitHighScores_ArmorGames_LoadComplete);
         _loc3_.load(_loc2_);
      }
      
      internal static function InitHighScores_ArmorGames_LoadComplete(param1:Event) : void
      {
         agi = param1.currentTarget.content;
         LicDef.GetStage().addChild(agi);
         agi.init(LicDef.armorHighScore_devKey,LicDef.armorHighScore_gameKey);
      }
      
      internal static function SubmitScore_ArmorGames(param1:int, param2:Function = null) : *
      {
         highscore_callback = param2;
         LicDef.GetStage().addChild(agi);
         agi.initAGUI({"onClose":SubmitHighscore_ArmorGames_CloseHandler});
         agi.showScoreboardSubmit(param1);
      }
      
      internal static function ViewScore_ArmorGames(param1:Function = null) : *
      {
         highscore_callback = param1;
         LicDef.GetStage().addChild(agi);
         agi.initAGUI({"onClose":SubmitHighscore_ArmorGames_CloseHandler});
         agi.showScoreboardList();
      }
      
      internal static function SubmitHighscore_ArmorGames_CloseHandler() : void
      {
         LicDef.GetStage().removeChild(agi);
         if(highscore_callback != null)
         {
            highscore_callback(null);
         }
      }
      
      internal static function InitHighScores_Kongregate() : *
      {
         var _loc1_:Object = LicDef.GetStage().stage.loaderInfo.loader;
         var _loc2_:Object = LoaderInfo(LicDef.GetStage().stage.loaderInfo).parameters;
         var _loc3_:String = _loc2_.api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
         kong_isLoaded = false;
         var _loc4_:URLRequest = new URLRequest(_loc3_);
         var _loc5_:Loader = new Loader();
         _loc5_.contentLoaderInfo.addEventListener(Event.COMPLETE,kong_loadComplete);
         _loc5_.load(_loc4_);
         LicDef.GetStage().stage.addChild(_loc5_);
      }
      
      internal static function kong_loadComplete(param1:Event) : void
      {
         kongregate = param1.target.content;
         kongregate.services.connect();
         kong_isLoaded = true;
      }
      
      public static function Kongregate_IsGuest() : Boolean
      {
         if(LicDef.IsAtKongregate() == false)
         {
            return true;
         }
         if(kong_isLoaded == false)
         {
            return true;
         }
         return kongregate.stats.isGuest();
      }
      
      public static function Kongregate_GetUserName() : String
      {
         if(LicDef.IsAtKongregate() == false)
         {
            return "UserName";
         }
         if(kong_isLoaded == false)
         {
            return "UserName";
         }
         return kongregate.services.getUsername();
      }
      
      public static function Kongregate_SubmitStat(param1:Number, param2:String) : *
      {
         if(LicDef.IsAtKongregate() == false)
         {
            return;
         }
         if(kong_isLoaded == false)
         {
            return;
         }
         Utils.trace("Kong Stat: " + param2 + "  " + param1);
         kongregate.stats.submit(param2,param1);
      }
      
      public static function SubmitScore_MouseBreaker(param1:int, param2:String, param3:Function = null) : void
      {
         callback = param3;
         Utils.trace("calling SubmitScore_MouseBreaker with score " + param1 + " and name: " + param2);
         var _loc4_:String = "http://www.mousebreaker.com/games/flamingzombooka3/highscores_flamingzombooka3.php?" + int(Math.random() * 100000);
         var _loc5_:URLRequest = new URLRequest(_loc4_);
         var _loc6_:URLVariables = new URLVariables();
         _loc6_.score = param1;
         _loc6_.username = param2;
         _loc5_.data = _loc6_;
         _loc5_.method = URLRequestMethod.POST;
         var _loc7_:URLLoader = new URLLoader(_loc5_);
         _loc7_.addEventListener(Event.COMPLETE,SubmitScore_MouseBreaker_Complete);
         _loc7_.dataFormat = URLLoaderDataFormat.VARIABLES;
      }
      
      internal static function SubmitScore_MouseBreaker_Complete(param1:Event) : *
      {
         callback();
      }
   }
}

