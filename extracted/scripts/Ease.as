package
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class Ease
   {
      
      public function Ease()
      {
         super();
      }
      
      internal static function DebugOut(param1:String) : *
      {
         Utils.trace(param1);
      }
      
      public static function Linear(param1:Number) : Number
      {
         return param1;
      }
      
      public static function Spring_Out(param1:Number) : Number
      {
         var _loc2_:Number = 3;
         var _loc3_:Number = (1 - param1) * 1;
         var _loc4_:Number = Math.PI * 2 * _loc2_;
         var _loc5_:Number = -Math.PI * 0.5;
         var _loc6_:Number = Utils.ScaleTo(_loc5_,_loc4_,0,1,param1);
         _loc6_ = Math.sin(_loc6_) * _loc3_;
         return _loc6_ + 1;
      }
      
      public static function Power_In(param1:Number, param2:Number = 2) : Number
      {
         var _loc3_:Number = param1;
         var _loc4_:int = 0;
         while(_loc4_ < param2 - 1)
         {
            _loc3_ *= param1;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function Power_Out(param1:Number, param2:Number = 2) : Number
      {
         var _loc3_:Number = 1 - param1;
         var _loc4_:Number = _loc3_;
         var _loc5_:int = 0;
         while(_loc5_ < param2 - 1)
         {
            _loc4_ *= _loc3_;
            _loc5_++;
         }
         return 1 - _loc4_;
      }
      
      public static function Power_InOut(param1:Number, param2:Number = 2) : Number
      {
         if(param1 < 0.5)
         {
            return Power_In(param1 * 2,param2) * 0.5;
         }
         return 0.5 + Power_Out((param1 - 0.5) * 2,param2) * 0.5;
      }
      
      public static function Render(param1:BitmapData, param2:Function, param3:int, param4:int, param5:int = 45, param6:Number = 45) : *
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         param1.fillRect(new Rectangle(param3,param4,param5,param6),4278190080);
         var _loc7_:Number = 0;
         while(_loc7_ <= 1)
         {
            _loc8_ = param2(_loc7_);
            _loc9_ = param3 + param5 * _loc7_;
            _loc10_ = param4 + param6 - param6 * _loc8_;
            param1.setPixel32(_loc9_,_loc10_,4294967295);
            _loc7_ += 0.01;
         }
      }
   }
}

