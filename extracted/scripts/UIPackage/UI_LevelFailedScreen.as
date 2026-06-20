package UIPackage
{
   import LicPackage.Lic;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.ui.Mouse;
   
   public class UI_LevelFailedScreen extends UIScreenInstance
   {
      
      internal var b:Bitmap;
      
      internal var funcTimer:int = 0;
      
      public function UI_LevelFailedScreen()
      {
         super();
      }
      
      override public function ExitScreen() : *
      {
         titleMC.removeEventListener(Event.ENTER_FRAME,this.updateBGFunction);
         this.b.bitmapData = null;
         titleMC.removeChild(this.b);
         this.b = null;
         UI.RemoveAllButtons();
      }
      
      override public function RenderForTransition(param1:BitmapData) : void
      {
         this.b = new Bitmap(Game.copyScreenBD);
         titleMC.addChildAt(this.b,0);
         param1.draw(titleMC);
      }
      
      override public function InitScreen() : *
      {
         UI.StartAddButtons();
         onTransitionCompleteFunction = this.TransitionComplete;
         Mouse.show();
         MusicPlayer.StartStream("menus_music");
         var _loc1_:Level = Levels.GetCurrent();
         titleMC = new LevelFailedScreen();
         this.funcTimer = 0;
         titleMC.addEventListener(Event.ENTER_FRAME,this.updateBGFunction,false,0,true);
         this.b = new Bitmap(Game.copyScreenBD);
         titleMC.addChildAt(this.b,0);
         UI.AddAnimatedMCButton(titleMC.menuBtn,this.buttonMenuPressed);
         UI.AddAnimatedMCButton(titleMC.retryBtn,this.buttonRetryPressed);
         Lic.WalkthroughButton(titleMC.walkthroughBtn);
         titleMC.gotoAndStop(1);
      }
      
      internal function updateBGFunction(param1:Event) : *
      {
         if(this.b == null)
         {
            return;
         }
         if(this.b.bitmapData == null)
         {
            return;
         }
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

