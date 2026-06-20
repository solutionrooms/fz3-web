package
{
   import UIPackage.UI;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.ui.*;
   
   public class PauseMenu
   {
      
      internal static var active:Boolean;
      
      internal static var pauseMC:MovieClip;
      
      public function PauseMenu()
      {
         super();
      }
      
      public static function InitOnce() : void
      {
         active = false;
      }
      
      public static function Pause() : void
      {
         pauseMC = AddMovieClip(0,0,new PauseScreen());
         Game.main.addChild(pauseMC);
         UI.AddAnimatedMCButton(pauseMC.ButtonContinue,pressed_buttonContinue);
         UI.AddAnimatedMCButton(pauseMC.ButtonRestart,pressed_buttonRestartLevel);
         UI.AddAnimatedMCButton(pauseMC.ButtonQuit,pressed_buttonQuit);
         active = true;
      }
      
      internal static function SetTicks() : *
      {
         if(SoundPlayer.doSFX)
         {
            pauseMC.tickSFX.gotoAndStop(1);
         }
         else
         {
            pauseMC.tickSFX.gotoAndStop(2);
         }
         if(MusicPlayer.doMusic)
         {
            pauseMC.tickMusic.gotoAndStop(1);
         }
         else
         {
            pauseMC.tickMusic.gotoAndStop(2);
         }
      }
      
      public static function pressed_buttonSFX(param1:MouseEvent) : *
      {
         SoundPlayer.ToggleMute();
         SetTicks();
      }
      
      public static function pressed_buttonMusic(param1:MouseEvent) : *
      {
         MusicPlayer.ToggleMute();
         SetTicks();
      }
      
      public static function pressed_buttonQuit(param1:MouseEvent) : *
      {
         Game.EndLevel();
         Unpause();
         Game.StopLevel();
         UI.StartTransition("levelselect");
      }
      
      public static function pressed_buttonRestartLevel(param1:MouseEvent) : *
      {
         Game.EndLevel();
         Unpause();
         Game.StartLevelPlay();
      }
      
      public static function pressed_buttonHelp(param1:MouseEvent) : *
      {
      }
      
      public static function pressed_buttonContinue(param1:MouseEvent) : *
      {
         Unpause();
      }
      
      internal static function AddMovieClip(param1:Number, param2:Number, param3:MovieClip) : MovieClip
      {
         param3.x = param1;
         param3.y = param2;
         Game.main.addChild(param3);
         return param3;
      }
      
      public static function IsPaused() : Boolean
      {
         return active;
      }
      
      public static function Unpause() : void
      {
         active = false;
         Game.main.removeChild(pauseMC);
         pauseMC = null;
         KeyReader.InitOnce(Game.main.stage);
      }
   }
}

