package ui_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol574")]
   public dynamic class levelClip2_90 extends MovieClip
   {
      
      public var textLevelNumber:TextField;
      
      public var textExtra:TextField;
      
      public var clipSelected:SimpleButton;
      
      public var tick:MovieClip;
      
      public function levelClip2_90()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.tick.mouseEnabled = false;
      }
   }
}

