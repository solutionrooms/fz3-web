package
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.flashdevelop.utils.FlashConnect;
   import org.flashdevelop.utils.TraceLevel;
   
   public class Utils
   {
      
      public static var paramNames:Array;
      
      public static var paramValues:Array;
      
      public static var minutesString:String = "";
      
      public static var secondsString:String = "";
      
      public static var miliString:String = "";
      
      public function Utils()
      {
         super();
      }
      
      public static function trace(param1:String) : *
      {
         if(Game.debugPrint)
         {
            FlashConnect.trace(param1,TraceLevel.DEBUG);
         }
      }
      
      public static function traceerror(param1:String) : *
      {
         if(Game.debugPrintError)
         {
            FlashConnect.trace(param1,TraceLevel.ERROR);
         }
      }
      
      public static function ShuffleIntList(param1:Array, param2:int = 100) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc5_ = Utils.RandBetweenInt(0,_loc3_ - 1);
            _loc6_ = Utils.RandBetweenInt(0,_loc3_ - 1);
            _loc7_ = int(param1[_loc5_]);
            param1[_loc5_] = param1[_loc6_];
            param1[_loc6_] = _loc7_;
            _loc4_++;
         }
         return param1;
      }
      
      public static function AddLeadingZeroes(param1:int, param2:int) : String
      {
         if(param1 < 10)
         {
            return "0" + param1.toString();
         }
         return param1.toString();
      }
      
      public static function RemoveWhiteSpace(param1:String) : String
      {
         return param1.replace(" ","");
      }
      
      public static function PointArrayFromString(param1:String) : Array
      {
         var _loc4_:int = 0;
         var _loc6_:Point = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = param1.split(",");
         if(_loc3_.length < 2 || _loc3_.length % 2 == 1)
         {
            return _loc2_;
         }
         var _loc5_:int = _loc3_.length / 2;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new Point(0,0);
            _loc6_.x = Number(_loc3_[_loc4_ * 2 + 0]);
            _loc6_.y = Number(_loc3_[_loc4_ * 2 + 1]);
            _loc2_.push(_loc6_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function HexArrayFromString(param1:String) : Array
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         if(param1.length == 0)
         {
            return _loc2_;
         }
         var _loc4_:int = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = int(param1.charAt(_loc3_));
            _loc2_.push(_loc5_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function rgbToHex(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16);
         var _loc3_:String = "00000" + _loc2_;
         var _loc4_:int = _loc3_.length;
         _loc3_ = _loc3_.substring(_loc4_ - 6,_loc4_);
         return _loc3_.toUpperCase();
      }
      
      public static function CounterToSecondsString(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = param1 / int(Defs.fps);
         var _loc4_:int = param1 % int(Defs.fps);
         _loc2_ += _loc3_.toString() + ":";
         var _loc5_:Number = 100 / Defs.fps * Number(_loc4_);
         return _loc2_ + Math.floor(_loc5_).toString();
      }
      
      public static function CounterToMinutesSecondsString(param1:int) : String
      {
         var _loc2_:String = "";
         param1 /= Defs.fps;
         var _loc3_:int = param1 / int(60);
         var _loc4_:int = param1 % int(60);
         _loc2_ += _loc3_.toString() + ":";
         var _loc5_:Number = Number(_loc4_);
         return _loc2_ + Math.floor(_loc5_).toString();
      }
      
      public static function CounterToMinutesSecondsMilisecondsString(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = param1 % Defs.fps;
         _loc3_ = 100 * _loc3_ / Defs.fps;
         param1 /= Defs.fps;
         var _loc4_:int = param1 / int(60);
         var _loc5_:int = param1 % int(60);
         if(_loc5_ < 10)
         {
            secondsString = "0".concat(_loc5_.toString());
         }
         else
         {
            secondsString = _loc5_.toString();
         }
         minutesString = _loc4_.toString();
         if(_loc3_ < 10)
         {
            miliString = "0".concat(_loc3_.toString());
         }
         else
         {
            miliString = _loc3_.toString();
         }
         _loc2_.concat(minutesString);
         _loc2_.concat(":");
         _loc2_.concat(secondsString);
         _loc2_.concat(":");
         _loc2_.concat(miliString);
         return _loc2_;
      }
      
      public static function AddIntAndLoop(param1:int, param2:int, param3:int, param4:int) : Number
      {
         param3 += param4;
         var _loc5_:int = param2 - param1 + 1;
         if(param3 > param2)
         {
            param3 -= _loc5_;
         }
         if(param3 < param1)
         {
            param3 += _loc5_;
         }
         return param3;
      }
      
      public static function LimitNumber(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param3 < param1)
         {
            param3 = param1;
         }
         if(param3 > param2)
         {
            param3 = param2;
         }
         return param3;
      }
      
      public static function LoopNumber(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:int = param2 - param1 + 1;
         if(param3 < param1)
         {
            param3 += _loc4_;
         }
         if(param3 > param2)
         {
            param3 -= _loc4_;
         }
         return param3;
      }
      
      public static function ScaleToAndLimit(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         var _loc6_:Number = param4 - param3;
         var _loc7_:Number = param2 - param1;
         var _loc8_:Number = 1 / _loc6_ * (param5 - param3);
         _loc8_ = _loc7_ * _loc8_ + param1;
         if(_loc8_ < param1)
         {
            _loc8_ = param1;
         }
         if(_loc8_ > param2)
         {
            _loc8_ = param2;
         }
         return _loc8_;
      }
      
      public static function ScaleToPreLimit(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         if(param5 < param3)
         {
            param5 = param3;
         }
         if(param5 > param4)
         {
            param5 = param4;
         }
         var _loc6_:Number = param4 - param3;
         var _loc7_:Number = param2 - param1;
         var _loc8_:Number = 1 / _loc6_ * (param5 - param3);
         return _loc7_ * _loc8_ + param1;
      }
      
      public static function ScaleTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         var _loc6_:Number = param4 - param3;
         var _loc7_:Number = param2 - param1;
         var _loc8_:Number = 1 / _loc6_ * (param5 - param3);
         return _loc7_ * _loc8_ + param1;
      }
      
      public static function ScaleBetween(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = (param2 - param1) * param3;
         return param1 + _loc4_;
      }
      
      public static function LineLength(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = param3 - param1;
         var _loc6_:Number = param4 - param2;
         return Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
      }
      
      public static function NumberToString2DP(param1:Number) : String
      {
         var _loc4_:int = 0;
         var _loc2_:String = DP2(param1).toString();
         var _loc3_:int = _loc2_.lastIndexOf(".");
         if(_loc3_ == -1)
         {
            _loc2_.concat(".00");
         }
         else
         {
            _loc4_ = _loc2_.length;
            if(_loc3_ == _loc4_ - 1)
            {
               _loc2_.concat("0");
            }
         }
         return _loc2_;
      }
      
      public static function DP2(param1:Number) : Number
      {
         return Math.ceil(param1 * 100) / 100;
      }
      
      public static function DP1(param1:Number) : Number
      {
         return Math.ceil(param1 * 10) / 10;
      }
      
      internal static function RandSetSeed(param1:int) : *
      {
         SeededRandom.SetSeed(param1);
      }
      
      internal static function RandBetweenFloat_Seeded(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = SeededRandom.GetNumber() * (param2 - param1);
         return _loc3_ + param1;
      }
      
      internal static function RandBetweenInt_Seeded(param1:int, param2:int) : int
      {
         var _loc3_:int = SeededRandom.GetNumber() * (param2 - param1 + 1);
         return int(_loc3_ + param1);
      }
      
      public static function RandBetweenFloat(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.random() * (param2 - param1);
         return _loc3_ + param1;
      }
      
      public static function RandBetweenInt(param1:int, param2:int) : int
      {
         var _loc3_:int = Math.random() * (param2 - param1 + 1);
         return int(_loc3_ + param1);
      }
      
      public static function RandBool() : Boolean
      {
         return RandBetweenInt(0,99) < 50;
      }
      
      public static function DotProduct(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 * param3 + param2 * param4;
      }
      
      public static function CrossProductAng(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.cos(param1);
         var _loc4_:Number = Math.sin(param1);
         var _loc5_:Number = Math.cos(param2);
         var _loc6_:Number = Math.sin(param2);
         return CrossProduct(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      public static function CrossProduct(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 * param4 - param3 * param2;
      }
      
      public static function SideOfLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         var _loc7_:Number = CrossProduct(param3 - param1,param4 - param2,param5 - param1,param6 - param2);
         if(_loc7_ < 0)
         {
            return false;
         }
         return true;
      }
      
      public static function DotProductAng(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.cos(param1);
         var _loc4_:Number = Math.sin(param1);
         var _loc5_:Number = Math.cos(param2);
         var _loc6_:Number = Math.sin(param2);
         return _loc3_ * _loc5_ + _loc4_ * _loc6_;
      }
      
      public static function RandCirclePosition(param1:Number) : Point
      {
         var _loc2_:Number = Math.random() * (Math.PI * 2);
         var _loc3_:Number = Math.cos(_loc2_) * Utils.RandBetweenFloat(0,param1);
         var _loc4_:Number = Math.sin(_loc2_) * Utils.RandBetweenFloat(0,param1);
         return new Point(_loc3_,_loc4_);
      }
      
      public static function RandCircle() : Number
      {
         return Math.random() * (Math.PI * 2);
      }
      
      public static function RadToDeg(param1:Number) : Number
      {
         return 360 / (Math.PI * 2) * param1;
      }
      
      public static function DegToRad(param1:Number) : Number
      {
         return Math.PI * 2 / 360 * param1;
      }
      
      public static function RenderDotLine(param1:BitmapData, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:uint) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = param6;
         var _loc10_:Number = (param4 - param2) / Number(_loc9_);
         var _loc11_:Number = (param5 - param3) / Number(_loc9_);
         param1.setPixel32(int(param2),int(param3),param7);
         var _loc12_:Number = param2;
         var _loc13_:Number = param3;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            param2 += _loc10_;
            param3 += _loc11_;
            param1.setPixel32(int(param2),int(param3),param7);
            _loc8_++;
         }
      }
      
      public static function RenderRectangle(param1:BitmapData, param2:Rectangle, param3:uint) : void
      {
         RenderDotLine(param1,param2.left,param2.top,param2.right,param2.top,100,param3);
         RenderDotLine(param1,param2.left,param2.bottom,param2.right,param2.bottom,100,param3);
         RenderDotLine(param1,param2.left,param2.top,param2.left,param2.bottom,100,param3);
         RenderDotLine(param1,param2.right,param2.top,param2.right,param2.bottom,100,param3);
      }
      
      public static function RenderCircle(param1:BitmapData, param2:Number, param3:Number, param4:Number, param5:uint) : void
      {
         var _loc8_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc6_:int = 50;
         var _loc7_:Number = Math.PI * 2 / _loc6_;
         var _loc9_:Number = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc10_ = param2 + Math.cos(_loc9_) * param4;
            _loc11_ = param3 + Math.sin(_loc9_) * param4;
            _loc9_ += _loc7_;
            param1.setPixel32(int(_loc10_),int(_loc11_),param5);
            _loc8_++;
         }
      }
      
      public static function DistBetweenPoints(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = param3 - param1;
         var _loc6_:Number = param4 - param2;
         return Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
      }
      
      public static function GetLength(param1:Number, param2:Number) : Number
      {
         return param1 * param1 + param2 * param2;
      }
      
      public static function Dist2BetweenPoints(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = param3 - param1;
         var _loc6_:Number = param4 - param2;
         return _loc5_ * _loc5_ + _loc6_ * _loc6_;
      }
      
      public static function NormalizeRot(param1:Number) : Number
      {
         while(param1 < 0)
         {
            param1 += Math.PI * 2;
         }
         while(param1 > Math.PI * 2)
         {
            param1 -= Math.PI * 2;
         }
         return param1;
      }
      
      public static function PrintParams() : void
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         while(_loc1_ < paramNames.length)
         {
            _loc2_ = paramNames[_loc1_] + " " + paramValues[_loc1_];
            Utils.trace(_loc2_);
            _loc1_++;
         }
      }
      
      public static function GetParams(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         paramNames = new Array();
         paramValues = new Array();
         if(param1 == null)
         {
            return;
         }
         if(param1 == "")
         {
            return;
         }
         var _loc2_:Array = param1.split(",");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.split("=");
            paramNames.push(_loc4_[0]);
            paramValues.push(_loc4_[1]);
         }
      }
      
      public static function GetParamExists(param1:String) : Boolean
      {
         var _loc2_:int = paramNames.indexOf(param1);
         if(_loc2_ != -1)
         {
            return true;
         }
         return false;
      }
      
      public static function GetParam(param1:String, param2:String = "") : String
      {
         var _loc3_:int = paramNames.indexOf(param1);
         if(_loc3_ != -1)
         {
            return paramValues[_loc3_];
         }
         return param2;
      }
      
      public static function GetParamString(param1:String, param2:String = "") : String
      {
         var _loc3_:int = paramNames.indexOf(param1);
         if(_loc3_ != -1)
         {
            return paramValues[_loc3_];
         }
         return param2;
      }
      
      public static function GetParamNumber(param1:String, param2:Number = 0) : Number
      {
         var _loc3_:int = paramNames.indexOf(param1);
         if(_loc3_ != -1)
         {
            return Number(paramValues[_loc3_]);
         }
         return param2;
      }
      
      public static function GetParamInt(param1:String, param2:Number = 0) : int
      {
         var _loc3_:int = paramNames.indexOf(param1);
         if(_loc3_ != -1)
         {
            return int(paramValues[_loc3_]);
         }
         return param2;
      }
      
      public static function GetParamBool(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:int = paramNames.indexOf(param1);
         if(_loc3_ != -1)
         {
            _loc4_ = paramValues[_loc3_];
            if(_loc4_ == "true")
            {
               return true;
            }
            return false;
         }
         return param2;
      }
      
      public static function ChangeParam(param1:String, param2:String) : *
      {
         var _loc3_:int = paramNames.indexOf(param1);
         if(_loc3_ != -1)
         {
            paramValues[_loc3_] = param2;
         }
      }
      
      public static function MakeParamString() : *
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < paramNames.length)
         {
            _loc1_ += paramNames[_loc2_];
            _loc1_ += "=";
            _loc1_ += paramValues[_loc2_];
            if(_loc2_ != paramNames.length - 1)
            {
               _loc1_ += ",";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function qsort(param1:Vector.<Number>, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(param3 - param2 > 4)
         {
            _loc4_ = param3 + param2 >> 1;
            if(param1[param2] > param1[_loc4_])
            {
               _loc7_ = param1[param2];
               param1[param2] = param1[_loc4_];
               param1[_loc4_] = _loc7_;
            }
            if(param1[param2] > param1[param3])
            {
               _loc7_ = param1[param2];
               param1[param2] = param1[param3];
               param1[param3] = _loc7_;
            }
            if(param1[param2] > param1[param3])
            {
               _loc7_ = param1[_loc4_];
               param1[_loc4_] = param1[param3];
               param1[param3] = _loc7_;
            }
            _loc5_ = param3 - 1;
            _loc7_ = param1[_loc4_];
            param1[_loc4_] = param1[_loc5_];
            param1[_loc5_] = _loc7_;
            _loc4_ = param2;
            _loc8_ = param1[_loc5_];
            while(true)
            {
               while(param1[++_loc4_] < _loc8_)
               {
               }
               while(param1[--_loc5_] > _loc8_)
               {
               }
               if(_loc5_ < _loc4_)
               {
                  break;
               }
               _loc7_ = param1[_loc4_];
               param1[_loc4_] = param1[_loc5_];
               param1[_loc5_] = _loc7_;
            }
            _loc7_ = param1[_loc4_];
            param1[_loc4_] = param1[_loc6_ = param3 - 1];
            param1[_loc6_] = _loc7_;
            qsort(param1,param2,_loc5_);
            qsort(param1,_loc4_ + 1,param3);
         }
      }
   }
}

