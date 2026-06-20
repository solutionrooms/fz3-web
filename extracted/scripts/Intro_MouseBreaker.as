package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2116")]
   public dynamic class Intro_MouseBreaker extends MovieClip
   {
      
      public var exp:MovieClip;
      
      public function Intro_MouseBreaker()
      {
         super();
         addFrameScript(0,frame1,105,frame106);
      }
      
      internal function frame106() : *
      {
         MovieClip(parent).play();
         stop();
      }
      
      internal function frame1() : *
      {
      }
   }
}

