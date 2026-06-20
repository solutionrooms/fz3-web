package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol209")]
   public dynamic class Transition extends MovieClip
   {
      
      public var screenA:MovieClip;
      
      public var screenB:MovieClip;
      
      public function Transition()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.screenA.cacheAsBitmap = true;
         this.screenB.cacheAsBitmap = true;
      }
   }
}

