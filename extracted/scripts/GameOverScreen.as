package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol496")]
   public dynamic class GameOverScreen extends MovieClip
   {
      
      public var buttonPlayWithHighcores:SimpleButton;
      
      public var moreGamesBtn:MovieClip;
      
      public var retryBtn:MovieClip;
      
      public var submitScore:MovieClip;
      
      public var walkthroughBtn:SimpleButton;
      
      public var levelrating:MovieClip;
      
      public var nextBtn:MovieClip;
      
      public var levelName:MovieClip;
      
      public var scoreText1:MovieClip;
      
      public var scoreText2:MovieClip;
      
      public var scoreText3:MovieClip;
      
      public var adHolder:MovieClip;
      
      public var menuBtn:MovieClip;
      
      public function GameOverScreen()
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

