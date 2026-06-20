package objectZ3_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol864")]
   public dynamic class cycloHead_100 extends MovieClip
   {
      
      public var wigs:MovieClip;
      
      public function cycloHead_100()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.wigs.gotoAndStop(1 + Math.round(Math.random() * 4));
      }
   }
}

