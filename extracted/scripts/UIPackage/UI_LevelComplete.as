package UIPackage
{
   import LicPackage.AdHolder;
   import LicPackage.Lic;
   import LicPackage.LicDef;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.ui.Mouse;
   
   public class UI_LevelComplete extends UIScreenInstance
   {
      
      internal var b:Bitmap;
      
      internal var funcTimer:int = 0;
      
      public function UI_LevelComplete()
      {
         super();
      }
      
      override public function ExitScreen() : *
      {
         titleMC.removeEventListener(Event.ENTER_FRAME,this.updateBGFunction);
         titleMC.removeChild(this.b);
         this.b = null;
         UI.RemoveAllButtons();
         UI.RemoveGeneric();
         AdHolder.RemoveAd(titleMC.adHolder);
      }
      
      override public function RenderForTransition(param1:BitmapData) : void
      {
         this.b = new Bitmap(Game.copyScreenBD);
         titleMC.addChildAt(this.b,0);
         param1.draw(titleMC);
      }
      
      override public function InitScreen() : *
      {
         var _loc1_:Level = null;
         UI.StartAddButtons();
         onTransitionCompleteFunction = this.TransitionComplete;
         Mouse.show();
         MusicPlayer.StartStream("menus_music");
         _loc1_ = Levels.GetCurrent();
         titleMC = new GameOverScreen();
         this.funcTimer = 0;
         titleMC.addEventListener(Event.ENTER_FRAME,this.updateBGFunction,false,0,true);
         this.b = new Bitmap(Game.copyScreenBD);
         titleMC.addChildAt(this.b,0);
         UI.AddGeneric(titleMC);
         UI.AddAnimatedMCButton(titleMC.nextBtn,this.buttonNextPressed);
         UI.AddAnimatedMCButton(titleMC.menuBtn,this.buttonMenuPressed);
         UI.AddAnimatedMCButton(titleMC.retryBtn,this.buttonRetryPressed);
         Lic.AnimatedMCMoreGamesButton(titleMC.moreGamesBtn,"levelcomplete");
         Lic.PlayWithScoresButton(titleMC.buttonPlayWithHighcores);
         if(Levels.currentIndex == 39 || Levels.currentIndex == 40)
         {
            titleMC.nextBtn.visible = false;
         }
         Lic.WalkthroughButton(titleMC.walkthroughBtn);
         AdHolder.AddAd(titleMC.adHolder);
         titleMC.adHolder.visible = false;
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            titleMC.adHolder.visible = true;
         }
         Lic.SubmitScoreButton(titleMC.submitScore.buttonSubmitScore,titleMC.submitScore.buttonSubmitScoreName);
         titleMC.levelName.textDescription.text = _loc1_.name;
         titleMC.scoreText1.textDescription.text = "Kill Score:";
         titleMC.scoreText1.textBallsLost.text = Game.killScore;
         titleMC.scoreText2.textDescription.text = "Shot Bonus:";
         titleMC.scoreText2.textBallsLost.text = GameVars.currentShotBonus;
         titleMC.scoreText3.textDescription.text = "Level Score:";
         titleMC.scoreText3.textBallsLost.text = Game.endLevelScore;
         titleMC.levelrating.visible = false;
         if(Game.rating != 0)
         {
            titleMC.levelrating.visible = true;
         }
         titleMC.gotoAndStop(1);
      }
      
      internal function updateBGFunction(param1:Event) : *
      {
         --this.funcTimer;
         if(this.funcTimer <= 0)
         {
            this.funcTimer = 2;
            this.b.bitmapData.colorTransform(this.b.bitmapData.rect,new ColorTransform(1,1,1,1,0,-1,-1,0));
         }
      }
      
      internal function buttonNextPressed(param1:MouseEvent) : *
      {
         Levels.IncrementLevel();
         UI.StartTransition("gamescreen");
      }
      
      internal function buttonRetryPressed(param1:MouseEvent) : *
      {
         UI.StartTransition("gamescreen");
      }
      
      internal function buttonMenuPressed(param1:MouseEvent) : *
      {
         UI.StartTransition("levelselect");
      }
      
      internal function TransitionComplete() : *
      {
         titleMC.gotoAndPlay(1);
         onTransitionCompleteFunction = null;
      }
   }
}

