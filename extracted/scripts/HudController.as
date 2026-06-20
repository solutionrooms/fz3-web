package
{
   import LicPackage.Lic;
   import UIPackage.UI;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   
   public class HudController
   {
      
      internal var hudMC:MovieClip;
      
      public function HudController()
      {
         super();
      }
      
      internal function UpdateScore() : *
      {
      }
      
      internal function UpdateCannonPower(param1:int) : *
      {
      }
      
      internal function UpdateMultiplier() : *
      {
      }
      
      internal function UpdateTime() : *
      {
      }
      
      internal function SetupMuteButtons() : *
      {
         UI.SetupSFXMuteButton(this.hudMC.backbit.sfxMuteBtn);
         UI.SetupMusicMuteButton(this.hudMC.backbit.musicMuteBtn);
         UI.RemoveAnimatedMCButton(this.hudMC.buttonMoreGames);
         Lic.AnimatedMCMoreGamesButton(this.hudMC.buttonMoreGames,"hud");
      }
      
      internal function Hide() : *
      {
         this.hudMC.visible = false;
      }
      
      internal function Show() : *
      {
         this.hudMC.visible = true;
      }
      
      internal function InitForLevel() : *
      {
         this.hudMC.textBonusBestKillStreak.visible = false;
         this.hudMC.textBonusBestKillStreakA.visible = false;
         this.hudMC.textBonusKillStreak.visible = false;
         this.hudMC.textBonusKillStreakA.visible = false;
         this.hudMC.textBonusKills.visible = false;
         this.hudMC.buttonContinue.visible = false;
         this.hudMC.backbit.visible = true;
         if(Levels.GetCurrent().name == "Dancing")
         {
            this.hudMC.textBonusBestKillStreak.visible = true;
            this.hudMC.textBonusKillStreak.visible = true;
            this.hudMC.textBonusBestKillStreakA.visible = true;
            this.hudMC.textBonusKillStreakA.visible = true;
            this.hudMC.textBonusKills.visible = true;
            this.hudMC.buttonContinue.visible = true;
            this.hudMC.backbit.visible = false;
         }
      }
      
      internal function InitOnce() : *
      {
         this.hudMC = new hud();
         this.hudMC.visible = true;
         Lic.AnimatedMCMoreGamesButton(this.hudMC.buttonMoreGames,"hud");
         Lic.AnimatedMCWalkthroughButton(this.hudMC.walkthroughBtn);
         UI.AddMCButton(this.hudMC.backbit.menuBtn,this.ButtonMenuPressed);
         UI.AddMCButton(this.hudMC.backbit.restartBtn,this.ButtonRestartPressed);
         UI.AddAnimatedMCButton(this.hudMC.buttonContinue,this.ButtonContinuePressed);
         UI.InitSFXMuteButton(this.hudMC.backbit.sfxMuteBtn);
         UI.InitMusicMuteButton(this.hudMC.backbit.musicMuteBtn);
      }
      
      public function ShowFastForward(param1:Boolean) : *
      {
         this.hudMC.buttonFastForward.visible = param1;
      }
      
      internal function ButtonContinuePressed(param1:MouseEvent) : *
      {
         Game.EndLevel();
         Game.StopLevel();
         Levels.currentIndex = 39;
         Game.copyScreenBD.copyPixels(Game.main.screenBD,Game.copyScreenBD.rect,Defs.pointZero);
         Game.copyScreenBD.applyFilter(Game.copyScreenBD,Game.copyScreenBD.rect,Defs.pointZero,new BlurFilter(4,4,3));
         UI.StartTransitionImmediate("levelcomplete");
      }
      
      internal function ButtonMenuPressed(param1:MouseEvent) : *
      {
         if(PauseMenu.IsPaused() == false)
         {
            PauseMenu.Pause();
         }
      }
      
      internal function ButtonRestartPressed(param1:MouseEvent) : *
      {
         Game.RestartLevel();
      }
      
      internal function UpdateKeyPresses() : *
      {
         if(PauseMenu.IsPaused() == false)
         {
            if(KeyReader.Pressed(KeyReader.KEY_P))
            {
               PauseMenu.Pause();
            }
         }
         if(KeyReader.Pressed(KeyReader.KEY_R))
         {
            this.ButtonRestartPressed(null);
         }
         if(KeyReader.Pressed(KeyReader.KEY_N))
         {
            UI.KeypressSFXMuteButton(this.hudMC.backbit.sfxMuteBtn);
         }
         if(KeyReader.Pressed(KeyReader.KEY_M))
         {
            UI.KeypressMusicMuteButton(this.hudMC.backbit.musicMuteBtn);
         }
      }
      
      internal function Update() : *
      {
         this.UpdateKeyPresses();
         this.hudMC.LevelNameText.text = Levels.GetCurrent().name;
         this.hudMC.backbit.textShotBonus.text = GameVars.currentShotBonus;
         if(Game.usedebug)
         {
            this.hudMC.LevelNameText.text = Levels.currentIndex + 1 + " " + Levels.GetCurrent().name;
         }
         this.hudMC.textBonusKills.text = "Clown Kills: " + GameVars.numBonusKills;
         this.hudMC.textBonusBestKillStreak.text = GameVars.numBonusBestKillStreak;
         this.hudMC.textBonusKillStreak.text = GameVars.numBonusKillStreak;
      }
      
      internal function helpPressed(param1:MouseEvent) : *
      {
         Game.pause = true;
      }
      
      internal function logoPressed(param1:MouseEvent) : *
      {
      }
      
      internal function walkthroughPressed(param1:MouseEvent) : *
      {
      }
      
      internal function ButtonPausePressed(param1:MouseEvent) : *
      {
         if(PauseMenu.IsPaused() == false)
         {
            PauseMenu.Pause();
         }
      }
   }
}

