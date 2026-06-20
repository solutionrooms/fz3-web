package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol499")]
   public dynamic class LevelFailedScreen extends MovieClip
   {
      
      public var walkthroughBtn:SimpleButton;
      
      public var retryBtn:MovieClip;
      
      public var menuBtn:MovieClip;
      
      public function LevelFailedScreen()
      {
         super();
         addFrameScript(28,this.frame29);
      }
      
      internal function frame29() : *
      {
         stop();
      }
   }
}

