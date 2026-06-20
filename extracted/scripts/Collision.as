package
{
   public class Collision
   {
      
      internal static var PolyCollision_LineHit:Line;
      
      public static var main:Main;
      
      public static var stats_numIntersections:int;
      
      public static var stats_numBBTests:int;
      
      public static var stats_numPolyCollisionTests:int;
      
      public static var closestX:Number = 0;
      
      public static var closestY:Number = 0;
      
      public static var closestInfiniteX:Number = 0;
      
      public static var closestInfiniteY:Number = 0;
      
      public static var IntersectionX:Number = 0;
      
      public static var IntersectionY:Number = 0;
      
      internal static var ProjectileList:Vector.<GameObj> = new Vector.<GameObj>();
      
      internal static var PhysObjList:Vector.<GameObj> = new Vector.<GameObj>();
      
      public function Collision()
      {
         super();
      }
      
      public static function PointInConvexPoly(param1:Number, param2:Number, param3:Array) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:Line = null;
         var _loc7_:Number = NaN;
         var _loc4_:int = int(param3.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param3[_loc5_];
            _loc7_ = DotProduct(_loc6_.x0 - param1,_loc6_.y0 - param2,_loc6_.nx,_loc6_.ny);
            if(_loc7_ < 0)
            {
               return false;
            }
            _loc5_++;
         }
         return true;
      }
      
      internal static function GameObjectInPolyBoundingBox(param1:GameObj, param2:Poly) : Boolean
      {
         var _loc3_:Number = param1.radius + 50;
         var _loc4_:Number = param1.xpos;
         var _loc5_:Number = param1.ypos;
         if(param2.boundingRectangle == null)
         {
            return false;
         }
         ++stats_numBBTests;
         if(_loc4_ < param2.boundingRectangle.left - _loc3_)
         {
            return false;
         }
         if(_loc4_ > param2.boundingRectangle.right + _loc3_)
         {
            return false;
         }
         if(_loc5_ < param2.boundingRectangle.top - _loc3_)
         {
            return false;
         }
         if(_loc5_ > param2.boundingRectangle.bottom + _loc3_)
         {
            return false;
         }
         return true;
      }
      
      internal static function DistBetween(param1:GameObj, param2:GameObj) : Number
      {
         var _loc3_:Number = param2.xpos - param1.xpos;
         var _loc4_:Number = param2.ypos - param1.ypos;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      internal static function Dist2Between(param1:GameObj, param2:GameObj) : Number
      {
         var _loc3_:Number = param2.xpos - param1.xpos;
         var _loc4_:Number = param2.ypos - param1.ypos;
         return _loc3_ * _loc3_ + _loc4_ * _loc4_;
      }
      
      internal static function DistBetweenPoints(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = param3 - param1;
         var _loc6_:Number = param4 - param2;
         return Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
      }
      
      internal static function Dist2BetweenPoints(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = param3 - param1;
         var _loc6_:Number = param4 - param2;
         return _loc5_ * _loc5_ + _loc6_ * _loc6_;
      }
      
      public static function ClosestPointOnLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         var _loc7_:Number = param5 - param1;
         var _loc8_:Number = param6 - param2;
         var _loc9_:Number = param3 - param1;
         var _loc10_:Number = param4 - param2;
         var _loc11_:Number = _loc9_ * _loc9_ + _loc10_ * _loc10_;
         var _loc12_:Number = _loc7_ * _loc9_ + _loc8_ * _loc10_;
         var _loc13_:Number = _loc12_ / _loc11_;
         closestInfiniteX = param1 + _loc9_ * _loc13_;
         closestInfiniteY = param2 + _loc10_ * _loc13_;
         var _loc14_:Number = _loc13_;
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         if(_loc13_ > 1)
         {
            _loc13_ = 1;
         }
         closestX = param1 + _loc9_ * _loc13_;
         closestY = param2 + _loc10_ * _loc13_;
         return _loc14_;
      }
      
      public static function LineLineIntersection(param1:Line, param2:Line) : Boolean
      {
         var _loc3_:Number = param1.x0;
         var _loc4_:Number = param1.y0;
         var _loc5_:Number = param1.x1;
         var _loc6_:Number = param1.y1;
         var _loc7_:Number = param2.x0;
         var _loc8_:Number = param2.y0;
         var _loc9_:Number = param2.x1;
         var _loc10_:Number = param2.y1;
         var _loc11_:Number = _loc5_ - _loc3_;
         var _loc12_:Number = _loc9_ - _loc7_;
         var _loc13_:Number = (_loc6_ - _loc4_) / _loc11_;
         var _loc14_:Number = (_loc10_ - _loc8_) / _loc12_;
         var _loc15_:Number = _loc4_ - _loc13_ * _loc3_;
         var _loc16_:Number = _loc8_ - _loc14_ * _loc7_;
         var _loc17_:Number = (_loc15_ - _loc16_) / (_loc14_ - _loc13_);
         var _loc18_:Number = _loc13_ * (_loc16_ - _loc15_) / (_loc13_ - _loc14_) + _loc15_;
         if(param1.boundingRect.contains(_loc17_,_loc18_))
         {
            if(param2.boundingRect.contains(_loc17_,_loc18_))
            {
               IntersectionX = _loc17_;
               IntersectionY = _loc18_;
               return true;
            }
         }
         return false;
      }
      
      internal static function DistToLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         ClosestPointOnLine(param1,param2,param3,param4,param5,param6);
         var _loc7_:Number = closestX - param5;
         var _loc8_:Number = closestY - param6;
         return Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
      }
      
      internal static function Dist2ToLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         ClosestPointOnLine(param1,param2,param3,param4,param5,param6);
         var _loc7_:Number = closestX - param5;
         var _loc8_:Number = closestY - param6;
         return _loc7_ * _loc7_ + _loc8_ * _loc8_;
      }
      
      internal static function SideOfLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         var _loc7_:Number = DotProduct(param3 - param1,param4 - param2,param5 - param1,param6 - param2);
         if(_loc7_ < 0)
         {
            return false;
         }
         return true;
      }
      
      internal static function SideOfLine1(param1:Line, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Number = DotProduct(param1.x1 - param1.x0,param1.y1 - param1.y0,param2 - param1.x0,param3 - param1.y0);
         if(_loc4_ < 0)
         {
            return false;
         }
         return true;
      }
      
      internal static function DotProduct(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 * param3 + param2 * param4;
      }
      
      internal static function Intersected(param1:GameObj, param2:Line, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc8_:int = 50;
         var _loc9_:Number = param1.oldxpos + param5 - param3;
         var _loc10_:Number = param1.oldypos + param6 - param4;
         _loc9_ /= Number(_loc8_);
         _loc10_ /= Number(_loc8_);
         var _loc11_:Number = param1.xpos + param5;
         var _loc12_:Number = param1.ypos + param6;
         var _loc13_:Number = param7 * param7;
         _loc14_ = 0;
         while(_loc14_ < _loc8_)
         {
            _loc11_ += _loc9_;
            _loc12_ += _loc10_;
            _loc15_ = Dist2ToLine(param2.x0,param2.y0,param2.x1,param2.y1,_loc11_,_loc12_);
            if(_loc15_ > _loc13_)
            {
               param1.xpos = _loc11_ - param5;
               param1.ypos = _loc12_ - param6;
               return;
            }
            _loc14_++;
         }
      }
      
      internal static function PolyCollision(param1:GameObj, param2:Poly, param3:Number, param4:Number, param5:Number) : Boolean
      {
         var _loc8_:Line = null;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc15_:Line = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:* = undefined;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Line = null;
         var _loc22_:Line = null;
         ++stats_numPolyCollisionTests;
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc11_:Number = param1.xpos + param3;
         var _loc12_:Number = param1.ypos + param4;
         var _loc13_:Number = param5;
         var _loc14_:Number = _loc13_ * _loc13_;
         for each(_loc15_ in param2.lineList)
         {
            _loc9_ = SideOfLine(_loc15_.x0,_loc15_.y0,_loc15_.x1,_loc15_.y1,_loc11_,_loc12_);
            if(_loc9_ == true)
            {
               _loc10_ = Dist2ToLine(_loc15_.x0,_loc15_.y0,_loc15_.x1,_loc15_.y1,_loc11_,_loc12_);
               if(_loc10_ < _loc14_)
               {
                  _loc6_.push(_loc15_);
                  _loc7_.push(_loc10_);
               }
            }
         }
         _loc18_ = _loc6_.length;
         _loc16_ = 0;
         while(_loc16_ < _loc18_ - 1)
         {
            _loc17_ = _loc16_;
            while(_loc17_ < _loc18_)
            {
               _loc19_ = Number(_loc7_[_loc16_]);
               _loc20_ = Number(_loc7_[_loc17_]);
               _loc21_ = _loc6_[_loc16_];
               _loc22_ = _loc6_[_loc17_];
               if(_loc20_ < _loc19_)
               {
                  _loc7_[_loc16_] = _loc20_;
                  _loc7_[_loc17_] = _loc19_;
                  _loc6_[_loc16_] = _loc22_;
                  _loc6_[_loc17_] = _loc21_;
               }
               _loc17_++;
            }
            _loc16_++;
         }
         _loc16_ = 0;
         if(_loc16_ >= _loc18_)
         {
            return false;
         }
         _loc8_ = _loc6_[_loc16_];
         _loc9_ = SideOfLine(_loc8_.x0,_loc8_.y0,_loc8_.x1,_loc8_.y1,_loc11_,_loc12_);
         if(_loc9_ == true)
         {
            _loc10_ = Dist2ToLine(_loc8_.x0,_loc8_.y0,_loc8_.x1,_loc8_.y1,_loc11_,_loc12_);
            if(_loc10_ < _loc14_)
            {
               ++stats_numIntersections;
               Intersected(param1,_loc8_,closestX,closestY,param3,param4,param5);
               PolyCollision_LineHit = _loc8_;
               return true;
            }
         }
         return true;
      }
      
      internal static function PlayerPickupCollision() : *
      {
         var _loc3_:GameObj = null;
         var _loc4_:GameObj = null;
         var _loc5_:Number = NaN;
         var _loc1_:Array = GameObjects.GetGameObjListByName("bug");
         var _loc2_:Array = new Array();
         for each(_loc3_ in GameObjects.objs)
         {
            if(_loc3_.active == true && _loc3_.colFlag_canBePickedUp)
            {
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc3_ in _loc1_)
         {
            for each(_loc4_ in _loc2_)
            {
               if(_loc4_.killed == false)
               {
                  _loc5_ = 10 + _loc4_.radius;
                  if(Utils.DistBetweenPoints(_loc3_.xpos,_loc3_.ypos,_loc4_.xpos,_loc4_.ypos) < _loc5_)
                  {
                     if(Boolean(_loc4_.onHitFunction))
                     {
                        _loc4_.onHitFunction(_loc3_);
                     }
                  }
               }
            }
         }
      }
      
      internal static function PlayerSwitchCollision() : *
      {
         var _loc4_:GameObj = null;
         var _loc5_:Array = null;
         var _loc6_:GameObj = null;
         var _loc1_:Array = GameObjects.GetGameObjListByName("bug");
         var _loc2_:Array = GameObjects.GetGameObjListByName("switch");
         var _loc3_:Number = 30;
         for each(_loc4_ in _loc1_)
         {
            for each(_loc6_ in _loc2_)
            {
               if(_loc6_.Switch_IsInContactList(_loc4_) == false)
               {
                  if(Utils.DistBetweenPoints(_loc4_.xpos,_loc4_.ypos,_loc6_.xpos,_loc6_.ypos) < _loc3_)
                  {
                     if(_loc6_.doSwitchFunction != null)
                     {
                        if(_loc6_.switchType == "2way")
                        {
                           _loc6_.Switch_AddToContactList(_loc4_);
                        }
                        if(_loc6_.doSwitchFunction())
                        {
                           Game.DoGameObjSwitch(_loc6_);
                        }
                     }
                  }
               }
            }
         }
         _loc5_ = new Array();
         for each(_loc6_ in _loc2_)
         {
            for each(_loc4_ in _loc6_.switchContactList)
            {
               if(Utils.DistBetweenPoints(_loc4_.xpos,_loc4_.ypos,_loc6_.xpos,_loc6_.ypos) >= _loc3_)
               {
                  _loc5_.push(_loc4_);
               }
            }
            for each(_loc4_ in _loc5_)
            {
               _loc6_.Switch_RemoveFromContactList(_loc4_);
            }
         }
      }
      
      internal static function ProjectileGoPhysObjCollision() : *
      {
         var _loc1_:GameObj = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:GameObj = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         for each(_loc1_ in ProjectileList)
         {
            _loc2_ = _loc1_.xpos;
            _loc3_ = _loc1_.ypos;
            for each(_loc4_ in PhysObjList)
            {
               _loc5_ = _loc4_.radius + 20;
               _loc6_ = _loc5_ * _loc5_;
               _loc7_ = _loc2_ - _loc4_.xpos;
               _loc8_ = _loc3_ - _loc4_.ypos;
               _loc7_ += _loc4_.colOffsetX;
               _loc8_ += _loc4_.colOffsetY;
               _loc9_ = _loc7_ * _loc7_ + _loc8_ * _loc8_;
               if(_loc9_ < _loc6_)
               {
                  if(_loc4_.onHitFunction != null)
                  {
                     _loc4_.onHitFunction(_loc1_);
                  }
               }
            }
         }
      }
      
      public static function MakeLists() : *
      {
         var _loc1_:GameObj = null;
         ProjectileList.splice(0,ProjectileList.length);
         PhysObjList.splice(0,PhysObjList.length);
         for each(_loc1_ in GameObjects.objs)
         {
            if(_loc1_.active && _loc1_.colFlag_isBall)
            {
               ProjectileList.push(_loc1_);
            }
            if(_loc1_.active && _loc1_.colFlag_isGoPhysObj && _loc1_.killed == false)
            {
               PhysObjList.push(_loc1_);
            }
         }
      }
      
      public static function Update() : *
      {
         stats_numIntersections = 0;
         stats_numBBTests = 0;
         stats_numPolyCollisionTests = 0;
         Debug.StartTimer("collision");
         Debug.EndTimer("collision");
      }
   }
}

