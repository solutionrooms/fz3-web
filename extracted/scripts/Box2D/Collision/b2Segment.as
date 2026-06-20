package Box2D.Collision
{
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   
   public class b2Segment
   {
      
      public var p1:b2Vec2 = new b2Vec2();
      
      public var p2:b2Vec2 = new b2Vec2();
      
      public function b2Segment()
      {
         super();
      }
      
      public function TestSegment(param1:Array, param2:b2Vec2, param3:b2Segment, param4:Number) : Boolean
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc5_:b2Vec2 = param3.p1;
         var _loc6_:Number = param3.p2.x - _loc5_.x;
         var _loc7_:Number = param3.p2.y - _loc5_.y;
         var _loc8_:Number = this.p2.x - this.p1.x;
         var _loc9_:Number;
         var _loc10_:Number = _loc9_ = this.p2.y - this.p1.y;
         var _loc11_:Number = -_loc8_;
         var _loc12_:Number = 100 * Number.MIN_VALUE;
         var _loc13_:Number = -(_loc6_ * _loc10_ + _loc7_ * _loc11_);
         if(_loc13_ > _loc12_)
         {
            _loc14_ = _loc5_.x - this.p1.x;
            _loc15_ = _loc5_.y - this.p1.y;
            _loc16_ = _loc14_ * _loc10_ + _loc15_ * _loc11_;
            if(0 <= _loc16_ && _loc16_ <= param4 * _loc13_)
            {
               _loc17_ = -_loc7_ * _loc15_ + _loc7_ * _loc14_;
               if(-_loc12_ * _loc13_ <= _loc17_ && _loc17_ <= _loc13_ * (1 + _loc12_))
               {
                  _loc16_ /= _loc13_;
                  _loc18_ = Math.sqrt(_loc10_ * _loc10_ + _loc11_ * _loc11_);
                  _loc10_ /= _loc18_;
                  _loc11_ /= _loc18_;
                  param1[0] = _loc16_;
                  param2.Set(_loc10_,_loc11_);
                  return true;
               }
            }
         }
         return false;
      }
      
      public function Extend(param1:b2AABB) : void
      {
         this.ExtendForward(param1);
         this.ExtendBackward(param1);
      }
      
      public function ExtendForward(param1:b2AABB) : void
      {
         var aabb:b2AABB = param1;
         var dX:Number = this.p2.x - this.p1.x;
         var dY:Number = this.p2.y - this.p1.y;
         var greaterthan0:* = function(param1:*):*
         {
            return param1 > 0;
         };
         var lambda:Number = Math.min(dX > 0 ? (aabb.upperBound.x - this.p1.x) / dX : (dX < 0 ? (aabb.lowerBound.x - this.p1.x) / dX : Number.POSITIVE_INFINITY),dY > 0 ? (aabb.upperBound.y - this.p1.y) / dY : (dY < 0 ? (aabb.lowerBound.y - this.p1.y) / dY : Number.POSITIVE_INFINITY));
         this.p2.x = this.p1.x + dX * lambda;
         this.p2.y = this.p1.y + dY * lambda;
      }
      
      public function ExtendBackward(param1:b2AABB) : void
      {
         var dY:Number = NaN;
         var lambda:Number = NaN;
         var aabb:b2AABB = param1;
         var dX:Number = -this.p2.x + this.p1.x;
         dY = -this.p2.y + this.p1.y;
         var greaterthan0:* = function(param1:*):*
         {
            return param1 > 0;
         };
         lambda = Math.min(dX > 0 ? (aabb.upperBound.x - this.p2.x) / dX : (dX < 0 ? (aabb.lowerBound.x - this.p2.x) / dX : Number.POSITIVE_INFINITY),dY > 0 ? (aabb.upperBound.y - this.p2.y) / dY : (dY < 0 ? (aabb.lowerBound.y - this.p2.y) / dY : Number.POSITIVE_INFINITY));
         this.p1.x = this.p2.x + dX * lambda;
         this.p1.y = this.p2.y + dY * lambda;
      }
   }
}

