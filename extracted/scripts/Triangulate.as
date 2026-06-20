package
{
   public class Triangulate
   {
      
      private const EPSILON:Number = 1e-10;
      
      public function Triangulate()
      {
         super();
      }
      
      public function process(param1:Array) : Array
      {
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = int(param1.length);
         if(_loc3_ < 3)
         {
            return null;
         }
         var _loc4_:Array = [];
         if(0 < this.area(param1))
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_[_loc5_] = _loc5_;
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_[_loc5_] = _loc3_ - 1 - _loc5_;
               _loc5_++;
            }
         }
         var _loc6_:* = _loc3_;
         var _loc7_:* = int(2 * _loc6_);
         _loc8_ = 0;
         _loc5_ = _loc6_ - 1;
         while(_loc6_ > 2)
         {
            if(0 >= _loc7_--)
            {
               return null;
            }
            _loc9_ = _loc5_;
            if(_loc6_ <= _loc9_)
            {
               _loc9_ = 0;
            }
            _loc5_ = _loc9_ + 1;
            if(_loc6_ <= _loc5_)
            {
               _loc5_ = 0;
            }
            _loc10_ = _loc5_ + 1;
            if(_loc6_ <= _loc10_)
            {
               _loc10_ = 0;
            }
            if(this.snip(param1,_loc9_,_loc5_,_loc10_,_loc6_,_loc4_))
            {
               _loc11_ = int(_loc4_[_loc9_]);
               _loc12_ = int(_loc4_[_loc5_]);
               _loc13_ = int(_loc4_[_loc10_]);
               _loc2_.push(param1[_loc11_]);
               _loc2_.push(param1[_loc12_]);
               _loc2_.push(param1[_loc13_]);
               _loc8_++;
               _loc14_ = _loc5_;
               _loc15_ = _loc5_ + 1;
               while(_loc15_ < _loc6_)
               {
                  _loc4_[_loc14_] = _loc4_[_loc15_];
                  _loc14_++;
                  _loc15_++;
               }
               _loc6_--;
               _loc7_ = int(2 * _loc6_);
            }
         }
         return _loc2_;
      }
      
      public function area(param1:Array) : Number
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:Number = 0;
         var _loc4_:int = _loc2_ - 1;
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ += param1[_loc4_].x * param1[_loc5_].y - param1[_loc5_].x * param1[_loc4_].y;
            _loc4_ = _loc5_++;
         }
         return _loc3_ * 0.5;
      }
      
      public function insideTriangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         _loc9_ = param5 - param3;
         _loc10_ = param6 - param4;
         _loc11_ = param1 - param5;
         _loc12_ = param2 - param6;
         _loc13_ = param3 - param1;
         _loc14_ = param4 - param2;
         _loc15_ = param7 - param1;
         _loc16_ = param8 - param2;
         _loc17_ = param7 - param3;
         _loc18_ = param8 - param4;
         _loc19_ = param7 - param5;
         _loc20_ = param8 - param6;
         _loc23_ = _loc9_ * _loc18_ - _loc10_ * _loc17_;
         _loc21_ = _loc13_ * _loc16_ - _loc14_ * _loc15_;
         _loc22_ = _loc11_ * _loc20_ - _loc12_ * _loc19_;
         return _loc23_ >= 0 && _loc22_ >= 0 && _loc21_ >= 0;
      }
      
      private function snip(param1:Array, param2:int, param3:int, param4:int, param5:int, param6:Array) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         _loc8_ = Number(param1[param6[param2]].x);
         _loc9_ = Number(param1[param6[param2]].y);
         _loc10_ = Number(param1[param6[param3]].x);
         _loc11_ = Number(param1[param6[param3]].y);
         _loc12_ = Number(param1[param6[param4]].x);
         _loc13_ = Number(param1[param6[param4]].y);
         if(this.EPSILON > (_loc10_ - _loc8_) * (_loc13_ - _loc9_) - (_loc11_ - _loc9_) * (_loc12_ - _loc8_))
         {
            return false;
         }
         _loc7_ = 0;
         while(_loc7_ < param5)
         {
            if(!(_loc7_ == param2 || _loc7_ == param3 || _loc7_ == param4))
            {
               _loc14_ = Number(param1[param6[_loc7_]].x);
               _loc15_ = Number(param1[param6[_loc7_]].y);
               if(this.insideTriangle(_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_))
               {
                  return false;
               }
            }
            _loc7_++;
         }
         return true;
      }
   }
}

