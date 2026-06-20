package
{
   import com.adobe.images.PNGEncoder;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   
   public class Screenshot
   {
      
      internal static var currentDrawScreenAbsoluteRectangle:Rectangle;
      
      internal static var bitmaps:Array;
      
      public function Screenshot()
      {
         super();
      }
      
      public static function Level_Dump() : *
      {
         GameVars.takingADump = true;
         Debug.StartImmediateTimer();
         var _loc1_:Rectangle = Game.boundingRectangle.clone();
         var _loc2_:BitmapData = new BitmapData(_loc1_.width,_loc1_.height,false,0);
         Game.camera.PushPos();
         Game.camera.x = _loc1_.x;
         Game.camera.y = _loc1_.y;
         GameObjects.Render(_loc2_);
         Game.camera.PopPos();
         GameVars.takingADump = false;
         var _loc3_:FileReference = new FileReference();
         _loc3_.addEventListener(Event.COMPLETE,Level_Dump_OneComplete);
         var _loc4_:Level = Levels.GetCurrent();
         var _loc5_:String = _loc4_.name;
         _loc5_ = _loc5_.replace(" ","_");
         _loc5_ = _loc5_.replace("/","_");
         var _loc6_:String = "screenshot_level_" + (Levels.currentIndex + 1) + "__" + _loc5_ + ".png";
         var _loc7_:ByteArray = PNGEncoder.encode(_loc2_);
         _loc3_.save(_loc7_,_loc6_);
         Utils.trace("saved level screenshot " + _loc6_ + "  " + _loc1_);
      }
      
      internal static function Level_Dump_OneComplete(param1:Event) : *
      {
         Debug.StopImmediateTimer("Level_Dump");
      }
   }
}

