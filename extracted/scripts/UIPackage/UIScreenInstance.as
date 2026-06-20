package UIPackage
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class UIScreenInstance
   {
      
      internal var template:UIScreen;
      
      internal var active:Boolean;
      
      internal var titleMC:MovieClip;
      
      internal var onTransitionCompleteFunction:Function = null;
      
      public function UIScreenInstance()
      {
         super();
      }
      
      public function GetMC() : MovieClip
      {
         return this.titleMC;
      }
      
      public function Start() : *
      {
         this.onTransitionCompleteFunction = null;
         this.InitScreen();
      }
      
      public function Stop() : *
      {
         this.ExitScreen();
      }
      
      public function OnComplete() : *
      {
         if(this.onTransitionCompleteFunction != null)
         {
            this.onTransitionCompleteFunction();
         }
      }
      
      public function RenderForTransition(param1:BitmapData) : void
      {
         param1.draw(this.titleMC);
      }
      
      public function InitScreen() : *
      {
      }
      
      public function ExitScreen() : *
      {
      }
   }
}

