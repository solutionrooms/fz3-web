package
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2PrismaticJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class Debug
   {
      
      internal static var timerNames:Array;
      
      internal static var timerStartTimes:Array;
      
      internal static var timerTimes:Array;
      
      internal static var immediateTime:int;
      
      public static var debugMode:int = 0;
      
      public function Debug()
      {
         super();
         timerNames = new Array();
         timerStartTimes = new Array();
         timerTimes = new Array();
      }
      
      public static function IsSet(param1:int) : Boolean
      {
         if((debugMode & param1) == 0)
         {
            return false;
         }
         return true;
      }
      
      public static function StartImmediateTimer() : *
      {
         immediateTime = getTimer();
      }
      
      public static function StopImmediateTimer(param1:String) : *
      {
         var _loc2_:int = getTimer() - immediateTime;
         Utils.trace("Immediate Timer: " + _loc2_ + " - " + param1);
      }
      
      public static function StartTimers() : *
      {
         timerNames = new Array();
         timerTimes = new Array();
         timerStartTimes = new Array();
         StartTimer("total");
      }
      
      public static function StopTimers() : *
      {
         EndTimer("total");
      }
      
      public static function RenderTimers(param1:BitmapData) : *
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         if(IsSet(2) == false)
         {
            return;
         }
         var _loc2_:Number = Number(timerTimes[0]);
         var _loc3_:int = 80;
         var _loc4_:int = 50;
         _loc6_ = 0;
         while(_loc6_ < timerNames.length)
         {
            _loc7_ = 100 / _loc2_ * timerTimes[_loc6_];
            _loc5_ = "Timer " + timerNames[_loc6_] + " : " + timerTimes[_loc6_] + "   (" + int(_loc7_).toString() + "%";
            GraphicObjects.RenderStringAt(param1,GraphicObjects.gfx_font1,_loc4_,_loc3_,_loc5_);
            _loc3_ += 15;
            _loc6_++;
         }
      }
      
      public static function StartTimer(param1:String) : *
      {
         timerNames.push(param1);
         timerStartTimes.push(getTimer());
         timerTimes.push(getTimer());
      }
      
      public static function EndTimer(param1:String) : *
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in timerNames)
         {
            if(_loc3_ == param1)
            {
               timerTimes[_loc2_] = getTimer() - timerStartTimes[_loc2_];
            }
            _loc2_++;
         }
      }
      
      internal static function RenderLines(param1:BitmapData) : void
      {
         var _loc5_:PhysLine = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(Debug.IsSet(1) == false)
         {
            return;
         }
         var _loc2_:Number = Game.camera.x;
         var _loc3_:Number = Game.camera.y;
         var _loc4_:Level = Levels.GetCurrent();
         for each(_loc5_ in _loc4_.lines)
         {
            _loc7_ = int(_loc5_.points.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_ - 1)
            {
               _loc8_ = _loc5_.points[_loc6_ + 0].x - _loc2_;
               _loc9_ = _loc5_.points[_loc6_ + 0].y - _loc3_;
               _loc10_ = _loc5_.points[_loc6_ + 1].x - _loc2_;
               _loc11_ = _loc5_.points[_loc6_ + 1].y - _loc3_;
               if(_loc5_.type == 1)
               {
                  Utils.RenderDotLine(param1,_loc8_,_loc9_,_loc10_,_loc11_,1000,4294967040);
                  GraphicObjects.RenderStringAt(param1,GraphicObjects.gfx_font1,_loc8_,_loc9_,_loc6_.toString());
               }
               if(_loc5_.type == 2)
               {
                  Utils.RenderDotLine(param1,_loc8_,_loc9_,_loc10_,_loc11_,1000,4294902015);
               }
               _loc6_++;
            }
         }
      }
      
      internal static function RenderBox2D(param1:BitmapData) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:b2Body = null;
         var _loc7_:b2Shape = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         var _loc10_:b2Joint = null;
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         var _loc13_:b2PolygonShape = null;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:b2Vec2 = null;
         var _loc18_:b2Vec2 = null;
         var _loc19_:Matrix = null;
         var _loc20_:Point = null;
         var _loc21_:Point = null;
         var _loc22_:b2CircleShape = null;
         var _loc23_:Number = NaN;
         var _loc24_:b2DistanceJoint = null;
         var _loc25_:b2RevoluteJoint = null;
         var _loc26_:b2Body = null;
         var _loc27_:b2Body = null;
         var _loc28_:b2PrismaticJoint = null;
         if(Debug.IsSet(1) == false)
         {
            return;
         }
         _loc2_ = Game.camera.x;
         _loc3_ = Game.camera.y;
         _loc4_ = PhysicsBase.p2w;
         _loc6_ = PhysicsBase.world.GetBodyList();
         while(_loc6_)
         {
            _loc8_ = _loc6_.GetPosition();
            _loc9_ = _loc6_.GetAngle();
            _loc7_ = _loc6_.GetShapeList();
            while(_loc7_)
            {
               _loc11_ = _loc7_.GetType();
               _loc12_ = 4294901760;
               if(_loc7_.IsSensor())
               {
                  _loc12_ = 4278190335;
               }
               if(_loc11_ == b2Shape.e_polygonShape)
               {
                  _loc13_ = b2PolygonShape(_loc7_);
                  _loc14_ = _loc13_.GetVertices();
                  _loc15_ = _loc13_.GetVertexCount();
                  _loc5_ = 0;
                  while(_loc5_ < _loc15_)
                  {
                     _loc16_ = _loc5_ + 1;
                     if(_loc16_ >= _loc15_)
                     {
                        _loc16_ = 0;
                     }
                     _loc17_ = _loc14_[_loc5_].Copy();
                     _loc18_ = _loc14_[_loc16_].Copy();
                     _loc19_ = new Matrix();
                     _loc19_.rotate(_loc9_);
                     _loc20_ = new Point(_loc17_.x,_loc17_.y);
                     _loc21_ = new Point(_loc18_.x,_loc18_.y);
                     _loc20_ = _loc19_.transformPoint(_loc20_);
                     _loc21_ = _loc19_.transformPoint(_loc21_);
                     _loc17_.x = _loc20_.x;
                     _loc17_.y = _loc20_.y;
                     _loc18_.x = _loc21_.x;
                     _loc18_.y = _loc21_.y;
                     _loc17_.Add(_loc8_);
                     _loc18_.Add(_loc8_);
                     Utils.RenderDotLine(param1,_loc17_.x * _loc4_ - _loc2_,_loc17_.y * _loc4_ - _loc3_,_loc18_.x * _loc4_ - _loc2_,_loc18_.y * _loc4_ - _loc3_,500,_loc12_);
                     _loc5_++;
                  }
               }
               if(_loc11_ == b2Shape.e_circleShape)
               {
                  _loc22_ = b2CircleShape(_loc7_);
                  _loc22_.m_localPosition;
                  _loc23_ = _loc22_.GetRadius() * _loc4_;
                  Utils.RenderCircle(param1,(_loc8_.x + _loc22_.m_localPosition.x) * _loc4_ - _loc2_,(_loc8_.y + _loc22_.m_localPosition.y) * _loc4_ - _loc3_,_loc23_,_loc12_);
               }
               _loc7_ = _loc7_.GetNext();
            }
            _loc6_ = _loc6_.GetNext();
         }
         _loc10_ = PhysicsBase.world.GetJointList();
         while(_loc10_)
         {
            _loc11_ = _loc10_.GetType();
            if(_loc11_ == b2Joint.e_distanceJoint)
            {
               _loc24_ = b2DistanceJoint(_loc10_);
               _loc17_ = _loc24_.GetAnchor1();
               _loc18_ = _loc24_.GetAnchor2();
               Utils.RenderDotLine(param1,_loc17_.x * _loc4_ - _loc2_,_loc17_.y * _loc4_ - _loc3_,_loc18_.x * _loc4_ - _loc2_,_loc18_.y * _loc4_ - _loc3_,500,4294967040);
            }
            else if(_loc11_ == b2Joint.e_revoluteJoint)
            {
               _loc25_ = b2RevoluteJoint(_loc10_);
               _loc17_ = _loc25_.GetAnchor1();
               _loc26_ = _loc25_.GetBody1();
               if(_loc26_ != null)
               {
                  _loc18_ = _loc26_.GetPosition();
                  Utils.RenderDotLine(param1,_loc17_.x * _loc4_ - _loc2_,_loc17_.y * _loc4_ - _loc3_,_loc18_.x * _loc4_ - _loc2_,_loc18_.y * _loc4_ - _loc3_,500,4294902015);
               }
               _loc27_ = _loc25_.GetBody2();
               if(_loc27_ != null)
               {
                  _loc18_ = _loc27_.GetPosition();
                  Utils.RenderDotLine(param1,_loc17_.x * _loc4_ - _loc2_,_loc17_.y * _loc4_ - _loc3_,_loc18_.x * _loc4_ - _loc2_,_loc18_.y * _loc4_ - _loc3_,500,4294902015);
               }
            }
            else if(_loc11_ == b2Joint.e_prismaticJoint)
            {
               _loc28_ = b2PrismaticJoint(_loc10_);
               _loc17_ = _loc28_.GetAnchor1();
               _loc18_ = _loc28_.GetAnchor2();
               Utils.RenderDotLine(param1,_loc17_.x * _loc4_ - _loc2_,_loc17_.y * _loc4_ - _loc3_,_loc18_.x * _loc4_ - _loc2_,_loc18_.y * _loc4_ - _loc3_,500,4294967295);
            }
            _loc10_ = _loc10_.GetNext();
         }
      }
   }
}

