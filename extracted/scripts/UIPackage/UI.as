package UIPackage
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   
   public class UI
   {
      
      internal static var screenTemplates:Array;
      
      internal static var globalMC_help:MovieClip;
      
      internal static var globalMC_areYouSure:MovieClip;
      
      public static var lastCreatedScreen:MovieClip;
      
      internal static var titleMC:MovieClip;
      
      public static var currentScreen:UIScreenInstance;
      
      public static var nextScreen:UIScreenInstance;
      
      internal static var globalMC_transition:MovieClip;
      
      internal static var trans_screenA:MovieClip;
      
      internal static var trans_screenB:MovieClip;
      
      internal static var trans_completeFunction:Function;
      
      internal static var transScreenA_BD:BitmapData;
      
      internal static var transScreenB_BD:BitmapData;
      
      internal static var transScreenA_B:Bitmap;
      
      internal static var transScreenB_B:Bitmap;
      
      internal static var playMovieCallback:Function;
      
      internal static var playMovieButtonSkip:Boolean;
      
      internal static var playMovieLoop:Boolean;
      
      internal static var useFullTransition:Boolean = true;
      
      internal static var onTransitionCompleteFunction:Function = null;
      
      internal static var returnScreenName:String = "";
      
      internal static var screenA:MovieClip = null;
      
      internal static var screenB:MovieClip = null;
      
      public static var genericMC:MovieClip = null;
      
      internal static var addButtonList:Array = null;
      
      public static var isInTransition:Boolean = false;
      
      internal static var debugSkipMovies:Boolean = false;
      
      internal static var playMovieMC:MovieClip = null;
      
      public function UI()
      {
         super();
         InitOnce();
      }
      
      internal static function AddScreen(param1:MovieClip) : MovieClip
      {
         lastCreatedScreen = param1;
         return param1;
      }
      
      internal static function RemoveScreen(param1:MovieClip) : MovieClip
      {
         lastCreatedScreen = null;
         return param1;
      }
      
      public static function InitOnce() : *
      {
         screenA = null;
         screenB = null;
         lastCreatedScreen = null;
         trans_screenA = null;
         trans_screenB = null;
         currentScreen = null;
         screenTemplates = new Array();
         screenTemplates.push(new UIScreen("title",false,UI_TitleScreen,null));
         screenTemplates.push(new UIScreen("levelselect",false,UI_LevelSelect,null));
         screenTemplates.push(new UIScreen("levelcomplete",false,UI_LevelComplete,null));
         screenTemplates.push(new UIScreen("gamecomplete",false,UI_GameCompleteScreen,null));
         screenTemplates.push(new UIScreen("areyousure_cleardata",false,UI_AreYouSure_ClearData,null));
         screenTemplates.push(new UIScreen("levelfailed",false,UI_LevelFailedScreen,null));
         screenTemplates.push(new UIScreen("preparingscreen",false,UI_PreparingScreen,null));
         screenTemplates.push(new UIScreen("gamescreen",false,UI_GameScreen,null));
      }
      
      public static function RemoveGeneric() : *
      {
         genericMC.parent.removeChild(genericMC);
         genericMC = null;
      }
      
      public static function Generic_OptionsClicked(param1:MouseEvent) : *
      {
         Utils.trace("options clicked");
      }
      
      public static function AddGeneric(param1:MovieClip) : *
      {
         if(param1 == null)
         {
            return;
         }
         genericMC = new ui_hud();
         param1.addChild(genericMC);
         UI.InitSFXMuteButton(genericMC.sfxMuteBtn);
         UI.InitMusicMuteButton(genericMC.musicMuteBtn);
         Game.CalculateScore();
         genericMC.textScore.text = "Score: " + Game.currentScore;
         genericMC.textNumGolds.text = Game.numGolds + "/40";
      }
      
      public static function AddToButtonList(param1:MovieClip, param2:Function) : *
      {
         if(addButtonList == null)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.mc = param1;
         _loc3_.removeFunc = param2;
         addButtonList.push(_loc3_);
      }
      
      public static function RemoveAllButtons() : *
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Function = null;
         for each(_loc1_ in addButtonList)
         {
            _loc2_ = _loc1_.mc;
            _loc3_ = _loc1_.removeFunc;
            _loc3_(_loc2_);
         }
         addButtonList = null;
      }
      
      public static function StartAddButtons() : *
      {
         addButtonList = new Array();
      }
      
      internal static function GetUIScreenTemplateByName(param1:String) : *
      {
         var _loc2_:UIScreen = null;
         for each(_loc2_ in screenTemplates)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      internal static function TransitionMakeInstance(param1:String) : UIScreenInstance
      {
         var _loc2_:UIScreen = GetUIScreenTemplateByName(param1);
         var _loc3_:UIScreenInstance = new _loc2_.theClass();
         _loc3_.active = true;
         _loc3_.template = _loc2_;
         _loc3_.Start();
         return _loc3_;
      }
      
      internal static function RemoveOverlay() : *
      {
         nextScreen.Stop();
         Game.main.removeChild(nextScreen.titleMC);
         nextScreen = null;
      }
      
      public static function StartOverlay(param1:String) : *
      {
         nextScreen = TransitionMakeInstance(param1);
         Game.main.addChild(nextScreen.titleMC);
      }
      
      public static function StartTransitionImmediate(param1:String, param2:Function = null, param3:String = "") : *
      {
         returnScreenName = param3;
         trans_completeFunction = param2;
         if(currentScreen != null)
         {
            currentScreen.Stop();
            if(currentScreen.titleMC.parent != null)
            {
               currentScreen.titleMC.parent.removeChild(currentScreen.titleMC);
               currentScreen.titleMC = null;
            }
            currentScreen = null;
         }
         if(param1 == null)
         {
            trans_completeFunction();
         }
         else
         {
            nextScreen = TransitionMakeInstance(param1);
            currentScreen = nextScreen;
            nextScreen = null;
            Game.main.addChild(currentScreen.titleMC);
            currentScreen.OnComplete();
         }
      }
      
      public static function StartTransition(param1:String, param2:Function = null, param3:String = "") : *
      {
         returnScreenName = param3;
         trans_completeFunction = param2;
         if(useFullTransition == false)
         {
            if(currentScreen != null)
            {
               currentScreen.Stop();
               if(currentScreen.titleMC.parent != null)
               {
                  currentScreen.titleMC.parent.removeChild(currentScreen.titleMC);
                  currentScreen.titleMC = null;
               }
               currentScreen = null;
            }
            if(param1 == null)
            {
               trans_completeFunction();
            }
            else
            {
               nextScreen = TransitionMakeInstance(param1);
               currentScreen = nextScreen;
               nextScreen = null;
               Game.main.addChild(currentScreen.titleMC);
               currentScreen.OnComplete();
            }
         }
         else
         {
            isInTransition = true;
            transScreenA_BD = new BitmapData(Defs.displayarea_w,Defs.displayarea_h,false,0);
            transScreenB_BD = new BitmapData(Defs.displayarea_w,Defs.displayarea_h,false,0);
            transScreenA_B = new Bitmap(transScreenA_BD);
            transScreenB_B = new Bitmap(transScreenB_BD);
            if(currentScreen != null)
            {
               currentScreen.Stop();
               currentScreen.RenderForTransition(transScreenA_BD);
               if(currentScreen.titleMC.parent != null)
               {
                  currentScreen.titleMC.parent.removeChild(currentScreen.titleMC);
                  currentScreen.titleMC = null;
               }
               currentScreen = null;
            }
            if(param1 != null)
            {
               nextScreen = TransitionMakeInstance(param1);
               transScreenB_BD.draw(nextScreen.titleMC);
            }
            else
            {
               nextScreen = null;
            }
            globalMC_transition = new Transition();
            globalMC_transition.visible = true;
            Game.main.addChild(globalMC_transition);
            globalMC_transition.addEventListener(Event.ENTER_FRAME,TransitionEnterFrame,false,0,true);
            globalMC_transition.gotoAndPlay(1);
            globalMC_transition.cacheAsBitmap = true;
            globalMC_transition.screenA.addChild(transScreenA_B);
            globalMC_transition.screenB.addChild(transScreenB_B);
            Utils.trace("starting transition " + param1);
         }
      }
      
      internal static function TransitionEnterFrame(param1:Event) : *
      {
         if(globalMC_transition == null)
         {
            return;
         }
         if(globalMC_transition.currentFrame == globalMC_transition.totalFrames)
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            globalMC_transition.removeEventListener(Event.ENTER_FRAME,TransitionEnterFrame);
            globalMC_transition.stop();
            globalMC_transition.visible = false;
            if(trans_screenA != null)
            {
               globalMC_transition.screenA.removeChild(transScreenA_B);
               trans_screenA = null;
            }
            if(trans_screenB != null)
            {
               globalMC_transition.screenB.removeChild(transScreenB_B);
               Game.main.addChild(trans_screenB);
            }
            Game.main.removeChild(globalMC_transition);
            globalMC_transition = null;
            if(nextScreen != null)
            {
               Game.main.addChild(nextScreen.titleMC);
               currentScreen = nextScreen;
            }
            else if(trans_completeFunction != null)
            {
               trans_completeFunction();
            }
            if(currentScreen != null)
            {
               currentScreen.OnComplete();
            }
            isInTransition = false;
         }
      }
      
      public static function SetupAnimatedSFXMuteButton(param1:MovieClip) : *
      {
         param1.toggleIcon.visible = true;
         if(SoundPlayer.doSFX)
         {
            param1.toggleIcon.visible = false;
         }
      }
      
      public static function AddAnimatedSFXMuteButton(param1:MovieClip, param2:String = null) : *
      {
         if(param1 == null)
         {
            Utils.trace("add MCbutton button = null");
         }
         param1.helpText = param2;
         SetupAnimatedSFXMuteButton(param1);
         param1.gotoAndStop(1);
         param1.addEventListener(MouseEvent.ROLL_OVER,AnimatedSFXMuteButton_Over,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,AnimatedSFXMuteButton_Out,false,0,true);
         param1.useHandCursor = true;
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.CLICK,AnimatedSFXMuteButton_Click,false,0,true);
      }
      
      public static function RemoveAnimatedSFXMuteButton(param1:MovieClip) : *
      {
         param1.removeEventListener(MouseEvent.ROLL_OVER,AnimatedSFXMuteButton_Over);
         param1.removeEventListener(MouseEvent.ROLL_OUT,AnimatedSFXMuteButton_Out);
         param1.removeEventListener(MouseEvent.CLICK,AnimatedSFXMuteButton_Click);
      }
      
      public static function AnimatedSFXMuteButton_Click(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndPlay("clicked");
         SoundPlayer.ToggleMute();
         SetupAnimatedSFXMuteButton(param1.currentTarget as MovieClip);
      }
      
      public static function AnimatedSFXMuteButton_Over(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         param1.currentTarget.gotoAndPlay("over");
         if(param1.currentTarget.helpText != null)
         {
         }
      }
      
      public static function AnimatedSFXMuteButton_Out(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         param1.currentTarget.gotoAndPlay("out");
         if(param1.currentTarget.helpText != null)
         {
         }
      }
      
      public static function AddAnimatedMCButton(param1:MovieClip, param2:Function, param3:String = null) : *
      {
         if(param1 == null)
         {
            Utils.trace("add MCbutton button = null");
         }
         if(param2 == null)
         {
            Utils.trace("add MCbutton clickCallback = null");
         }
         param1.helpText = param3;
         param1.clickCallback = param2;
         param1.buttonAnimation.gotoAndStop(1);
         if(param1.buttonAnimation.buttonText != null)
         {
            param1.buttonAnimation.buttonText.buttonName.text = param1.buttonName.text;
            param1.buttonName.visible = false;
            param1.buttonAnimation.buttonText.visible = true;
            param1.buttonAnimation.buttonText.mouseEnabled = false;
            param1.buttonName.mouseEnabled = false;
         }
         param1.addEventListener(MouseEvent.ROLL_OVER,AnimatedMCButton_Over,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,AnimatedMCButton_Out,false,0,true);
         param1.useHandCursor = true;
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.CLICK,AnimatedMCButton_Click,false,0,true);
         AddToButtonList(param1,RemoveAnimatedMCButton);
      }
      
      public static function RemoveAnimatedMCButton(param1:MovieClip) : *
      {
         param1.removeEventListener(MouseEvent.ROLL_OVER,AnimatedMCButton_Over);
         param1.removeEventListener(MouseEvent.ROLL_OUT,AnimatedMCButton_Out);
         param1.removeEventListener(MouseEvent.CLICK,AnimatedMCButton_Click);
      }
      
      public static function AnimatedMCButton_Click(param1:MouseEvent) : *
      {
         param1.currentTarget.buttonAnimation.gotoAndPlay("clicked");
         param1.currentTarget.clickCallback(param1);
      }
      
      public static function AnimatedMCButton_Over(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         param1.currentTarget.buttonAnimation.gotoAndPlay("over");
      }
      
      public static function AnimatedMCButton_Out(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         param1.currentTarget.buttonAnimation.gotoAndPlay("out");
         if(param1.currentTarget.helpText != null)
         {
         }
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
      
      public static function AddMCButton(param1:MovieClip, param2:Function, param3:String = null) : *
      {
         if(param1 == null)
         {
            Utils.trace("add MCbutton button = null");
         }
         if(param2 == null)
         {
            Utils.trace("add MCbutton clickCallback = null");
         }
         param1.helpText = param3;
         param1.gotoAndStop(1);
         param1.addEventListener(MouseEvent.MOUSE_OVER,MCButton_Over,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,MCButton_Out,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,MCButton_Down,false,0,true);
         param1.useHandCursor = true;
         param1.buttonMode = true;
         param1.clickCallback = param2;
         param1.addEventListener(MouseEvent.MOUSE_UP,MCButton_Click,false,0,true);
         AddToButtonList(param1,RemoveMCButton);
      }
      
      public static function RemoveMCButton(param1:MovieClip) : *
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,MCButton_Over);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,MCButton_Out);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,MCButton_Down);
         param1.removeEventListener(MouseEvent.MOUSE_UP,MCButton_Click);
      }
      
      public static function MCButton_Click(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(1);
         param1.currentTarget.clickCallback(param1);
      }
      
      public static function MCButton_Over(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         if(param1.currentTarget.currentFrame != 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
         if(param1.currentTarget.helpText != null)
         {
         }
      }
      
      public static function MCButton_Out(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         param1.currentTarget.gotoAndStop(1);
         if(param1.currentTarget.helpText != null)
         {
         }
      }
      
      public static function MCButton_Down(param1:MouseEvent) : *
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         param1.currentTarget.gotoAndStop(3);
         SoundPlayer.Play("sfx_clickrelease");
      }
      
      public static function KeypressSFXMuteButton(param1:MovieClip) : *
      {
         param1.gotoAndStop(3);
         SoundPlayer.ToggleMute();
         param1.toggleIcon.visible = true;
         if(SoundPlayer.doSFX)
         {
            param1.toggleIcon.visible = false;
         }
      }
      
      public static function SetupSFXMuteButton(param1:MovieClip) : *
      {
         param1.toggleIcon.visible = true;
         if(SoundPlayer.doSFX)
         {
            param1.toggleIcon.visible = false;
         }
      }
      
      public static function InitSFXMuteButton(param1:MovieClip) : *
      {
         param1.gotoAndStop(1);
         param1.addEventListener(MouseEvent.MOUSE_OVER,SFXMuteButton_Over,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,SFXMuteButton_Out,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,SFXMuteButton_Down,false,0,true);
         param1.toggleIcon.visible = true;
         if(SoundPlayer.doSFX)
         {
            param1.toggleIcon.visible = false;
         }
         param1.useHandCursor = true;
         param1.buttonMode = true;
      }
      
      public static function SFXMuteButton_Over(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(2);
      }
      
      public static function SFXMuteButton_Out(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(1);
      }
      
      public static function SFXMuteButton_Down(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(3);
         SoundPlayer.ToggleMute();
         param1.currentTarget.toggleIcon.visible = true;
         if(SoundPlayer.doSFX)
         {
            param1.currentTarget.toggleIcon.visible = false;
         }
      }
      
      public static function KeypressMusicMuteButton(param1:MovieClip) : *
      {
         param1.gotoAndStop(3);
         MusicPlayer.ToggleMute();
         param1.toggleIcon.visible = true;
         if(MusicPlayer.doMusic)
         {
            param1.toggleIcon.visible = false;
         }
      }
      
      public static function SetupMusicMuteButton(param1:MovieClip) : *
      {
         param1.toggleIcon.visible = true;
         if(MusicPlayer.doMusic)
         {
            param1.toggleIcon.visible = false;
         }
      }
      
      public static function InitMusicMuteButton(param1:MovieClip) : *
      {
         param1.gotoAndStop(1);
         param1.addEventListener(MouseEvent.MOUSE_OVER,MusicMuteButton_Over,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,MusicMuteButton_Out,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,MusicMuteButton_Down,false,0,true);
         param1.toggleIcon.visible = true;
         if(MusicPlayer.doMusic)
         {
            param1.toggleIcon.visible = false;
         }
         param1.useHandCursor = true;
         param1.buttonMode = true;
      }
      
      public static function MusicMuteButton_Over(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(2);
      }
      
      public static function MusicMuteButton_Out(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(1);
      }
      
      public static function MusicMuteButton_Down(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(3);
         MusicPlayer.ToggleMute();
         param1.currentTarget.toggleIcon.visible = true;
         if(MusicPlayer.doMusic)
         {
            param1.currentTarget.toggleIcon.visible = false;
         }
      }
      
      internal static function PlayMovie_Click(param1:Event) : *
      {
         PlayMovie_Close();
      }
      
      internal static function PlayMovie_Close() : *
      {
         playMovieMC.stop();
         if(playMovieButtonSkip)
         {
            playMovieMC.removeEventListener(MouseEvent.CLICK,PlayMovie_Click);
         }
         playMovieMC.removeEventListener(Event.ENTER_FRAME,PlayMovie_EnterFrame);
         Game.main.removeChild(playMovieMC);
         playMovieMC = null;
         if(playMovieCallback != null)
         {
            playMovieCallback();
         }
      }
      
      public static function StopMovie() : *
      {
         if(playMovieMC == null)
         {
            return;
         }
         PlayMovie_Close();
      }
      
      internal static function PlayMovie_EnterFrame(param1:Event) : *
      {
         if(playMovieLoop)
         {
            return;
         }
         if(playMovieMC == null)
         {
            return;
         }
         if(playMovieMC.currentFrame == playMovieMC.totalFrames)
         {
         }
      }
      
      internal static function PlayMovie(param1:Object, param2:Function, param3:Boolean = false, param4:Boolean = false) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:Class = null;
         var _loc7_:* = undefined;
         playMovieButtonSkip = param3;
         playMovieLoop = param4;
         playMovieCallback = param2;
         if(debugSkipMovies)
         {
            if(playMovieCallback != null)
            {
               playMovieCallback();
            }
            return;
         }
         if(param1 is String)
         {
            _loc5_ = param1 as String;
            _loc6_ = getDefinitionByName(_loc5_) as Class;
            playMovieMC = new _loc6_() as MovieClip;
         }
         else if(param1 is MovieClip)
         {
            _loc7_ = param1 as MovieClip;
            playMovieMC = _loc7_;
         }
         playMovieMC.addEventListener(Event.ENTER_FRAME,PlayMovie_EnterFrame,false,0,true);
         if(playMovieButtonSkip)
         {
            playMovieMC.addEventListener(MouseEvent.CLICK,PlayMovie_Click,false,0,true);
         }
         Game.main.addChild(playMovieMC);
         playMovieMC.gotoAndPlay(1);
      }
   }
}

