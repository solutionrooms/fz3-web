package
{
   import LicPackage.AdHolder;
   import LicPackage.LicAds;
   import LicPackage.LicDef;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.utils.getDefinitionByName;
   
   public class Preloader extends MovieClip
   {
      
      public function Preloader()
      {
         super();
         if(!stage)
         {
         }
         LicDef.InitFromPreloader(this);
         AdHolder.InitOnce(this.Poop0);
      }
      
      internal function Poop0() : *
      {
         LicAds.ShowAd(this.Poop1);
      }
      
      internal function Poop1() : *
      {
         addEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
      }
      
      private function ioError(param1:IOErrorEvent) : void
      {
      }
      
      private function progress(param1:ProgressEvent) : void
      {
      }
      
      private function checkFrame(param1:Event) : void
      {
         if(currentFrame == totalFrames)
         {
            stop();
            this.loadingFinished1();
         }
      }
      
      private function loadingFinished1() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.loadingFinished2();
      }
      
      private function loadingFinished2() : void
      {
         this.startup();
      }
      
      private function loadingFinished() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.startup();
      }
      
      private function startup() : void
      {
         var _loc1_:Class = getDefinitionByName("Main") as Class;
         addChild(new _loc1_() as DisplayObject);
      }
   }
}

