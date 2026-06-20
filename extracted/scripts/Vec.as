package
{
   import flash.geom.Point;
   
   public class Vec
   {
      
      public var rot:Number;
      
      public var speed:Number;
      
      public function Vec()
      {
         super();
         this.rot = 0;
         this.speed = 0;
      }
      
      public function SetFromDxDy(param1:Number, param2:Number) : *
      {
         this.speed = Math.sqrt(param1 * param1 + param2 * param2);
         this.rot = Math.atan2(param2,param1);
      }
      
      public function Set(param1:Number, param2:Number) : *
      {
         this.rot = param1;
         this.speed = param2;
      }
      
      public function SetAng(param1:Number) : *
      {
         this.rot = param1;
      }
      
      public function NearRot(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = this.rot - param1;
         var _loc4_:Number = Math.abs(_loc3_);
         if(_loc3_ > Math.PI)
         {
            if(param1 < this.rot)
            {
               param1 += Math.PI * 2;
            }
            else
            {
               param1 -= Math.PI * 2;
            }
            _loc3_ = this.rot - param1;
         }
         if(Math.abs(_loc3_) <= param2)
         {
            return true;
         }
         return false;
      }
      
      public function Add(param1:Vec) : *
      {
         var _loc2_:Number = Math.cos(this.rot) * this.speed;
         var _loc3_:Number = Math.sin(this.rot) * this.speed;
         var _loc4_:Number = Math.cos(param1.rot) * param1.speed;
         var _loc5_:Number = Math.sin(param1.rot) * param1.speed;
         var _loc6_:Number = _loc2_ + _loc4_;
         var _loc7_:Number = _loc3_ + _loc5_;
         this.rot = Math.atan2(_loc7_,_loc6_);
         this.speed = Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
      }
      
      public function GetUnitTangent() : Point
      {
         var _loc1_:Number = this.rot + Math.PI * 0.5;
         return new Point(Math.cos(_loc1_),Math.sin(_loc1_));
      }
      
      public function X() : Number
      {
         return Math.cos(this.rot) * this.speed;
      }
      
      public function Y() : Number
      {
         return Math.sin(this.rot) * this.speed;
      }
      
      public function UnitX() : Number
      {
         return Math.cos(this.rot);
      }
      
      public function UnitY() : Number
      {
         return Math.sin(this.rot);
      }
      
      public function AddRot(param1:Number) : void
      {
         this.rot += param1;
         this.NormalizeRot();
      }
      
      public function dotRot(param1:Number) : Number
      {
         var _loc2_:Number = Math.cos(this.rot);
         var _loc3_:Number = Math.sin(this.rot);
         var _loc4_:Number = Math.cos(param1);
         var _loc5_:Number = Math.sin(param1);
         return _loc2_ * _loc4_ + _loc3_ * _loc5_;
      }
      
      internal function NormalizeRot() : void
      {
         while(this.rot < 0)
         {
            this.rot += Math.PI * 2;
         }
         while(this.rot > Math.PI * 2)
         {
            this.rot -= Math.PI * 2;
         }
      }
      
      internal function RotateToRequiredRot(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Boolean
      {
         var _loc6_:Number = Math.atan2(param5 - param3,param4 - param2);
         var _loc7_:Number = _loc6_ + Math.PI / 2;
         var _loc8_:Number = Utils.DotProduct(Math.cos(this.rot),Math.sin(this.rot),Math.cos(_loc7_),Math.sin(_loc7_));
         if(this.NearRot(_loc6_,param1))
         {
            this.rot = _loc6_;
            return true;
         }
         if(_loc8_ < 0)
         {
            this.AddRot(param1);
         }
         else
         {
            this.AddRot(-param1);
         }
         return false;
      }
   }
}

