package
{
   import LicPackage.Lic;
   import UIPackage.UI;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class Main extends MovieClip
   {
      
      public static var theRoot:MovieClip;
      
      public static var theStage:Stage;
      
      private var ftime:Number;
      
      private var currentTime:Number = 0;
      
      public var screenBD:BitmapData;
      
      public var screenB:Bitmap;
      
      public var fps:Number;
      
      internal var framecounter:int = 0;
      
      internal var secondCounter:Number = 0;
      
      public function Main()
      {
         super();
         if(stage)
         {
            this.init(null);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.NewInit1);
         }
      }
      
      internal function NewInit1(param1:Event) : *
      {
         Lic.InitFromMain();
         Lic.Playtomic_Log();
         removeEventListener(Event.ADDED_TO_STAGE,this.NewInit1);
         Lic.ShowIntro(this.NewInit4);
      }
      
      internal function NewInit4() : *
      {
         theRoot = this;
         theStage = this.root.stage;
         this.SetEverythingUpOnce();
      }
      
      internal function init(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         theRoot = this;
         theStage = this.root.stage;
         this.SetEverythingUpOnce();
      }
      
      internal function InitDrawScreen() : void
      {
         this.screenBD = new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0);
         this.screenB = new Bitmap(this.screenBD);
      }
      
      internal function SetEverythingUpOnce() : void
      {
         if(stage == null)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         }
         else
         {
            this.SetEverythingUpOnce2();
         }
      }
      
      internal function addedToStage(param1:Event) : *
      {
         this.SetEverythingUpOnce2();
      }
      
      internal function SetEverythingUpOnce2() : void
      {
         GraphicObjects.InitOnce(this.SetEverythingUpOnce3);
      }
      
      internal function SetEverythingUpOnce3() : void
      {
         MusicPlayer.InitOnce();
         KeyReader.InitOnce(theStage);
         MouseControl.InitOnce(theStage);
         SoundPlayer.InitOnce();
         PauseMenu.InitOnce();
         Particles.InitOnce(Defs.maxParticles);
         GameObjects.InitOnce(Defs.maxGameObjects);
         UI.InitOnce();
         this.InitDrawScreen();
         ExternalData.Load(this.SetEverythingUpOnce4);
      }
      
      internal function SetEverythingUpOnce4() : *
      {
         this.ClearStage();
         Game.InitOnce(this);
         addEventListener(Event.ENTER_FRAME,this.MainLoop);
      }
      
      public function ClearStage() : *
      {
         var _loc1_:* = 0;
         _loc1_ = int(this.numChildren - 1);
         while(_loc1_ >= 0)
         {
            removeChildAt(_loc1_);
            _loc1_--;
         }
      }
      
      public function DisplayStageNames() : *
      {
         var _loc1_:* = 0;
         var _loc2_:DisplayObject = null;
         _loc1_ = int(this.numChildren - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = getChildAt(_loc1_);
            Utils.trace(_loc2_.name);
            _loc1_--;
         }
      }
      
      internal function Render() : *
      {
         this.x = 0;
         this.y = 0;
         Game.Render();
      }
      
      internal function calcFrameTime() : *
      {
         var _loc1_:Number = this.currentTime;
         this.currentTime = getTimer();
         if(this.currentTime < _loc1_)
         {
            _loc1_ = this.currentTime - 100;
         }
         if(this.currentTime > _loc1_ + 100 * 10)
         {
            _loc1_ = 100 * 10;
         }
         this.ftime = 1 / (1000 / Defs.fps) * (this.currentTime - _loc1_);
         ++this.framecounter;
         this.secondCounter += this.currentTime - _loc1_;
         if(this.secondCounter > 1000)
         {
            this.fps = Number(this.framecounter) / this.secondCounter * 1000;
            this.framecounter = 0;
            this.secondCounter = 0;
         }
         this.ftime = 1;
      }
      
      internal function RunLevel() : *
      {
         Game.UpdateGameplay();
         this.Render();
      }
      
      internal function MainLoop(param1:Event) : void
      {
         KeyReader.UpdateOncePerFrame();
         SoundPlayer.UpdateOncePerFrame();
         MusicPlayer.UpdateOncePerFrame();
         this.calcFrameTime();
         this.RunLevel();
      }
   }
}

