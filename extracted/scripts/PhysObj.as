package
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PhysObj
   {
      
      internal static var renderPoint:Point = new Point();
      
      internal static var renderMatrix:Matrix = new Matrix();
      
      internal static var p0:Point = new Point();
      
      internal static var p1:Point = new Point();
      
      public var bodies:Array;
      
      public var joints:Array;
      
      public var graphics:Array;
      
      public var instanceParams:Array;
      
      public var instanceParamsDefaults:Array;
      
      public var name:String;
      
      public var displayInLibrary:Boolean;
      
      public var editorRenderFunctionName:String;
      
      public var initFunctionName:String;
      
      public var initFunctionParameters:String;
      
      public var libraryClass:String;
      
      public var hasPhysics:Boolean;
      
      internal var sfx_break:String;
      
      internal var sfx_hit:String;
      
      internal var zombooka_HitDamage:Number;
      
      internal var zombooka_SuperHitDamage:Number;
      
      internal var zombooka_greatkill:Boolean;
      
      internal var zombooka_hitZombieSound:String;
      
      internal var zombooka_hitMissileSound:String;
      
      public function PhysObj()
      {
         super();
      }
      
      public static function RenderAt(param1:PhysObj, param2:Number, param3:Number, param4:Number, param5:Number, param6:BitmapData, param7:Graphics = null, param8:Boolean = false, param9:Rectangle = null) : *
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Matrix = null;
         var _loc15_:PhysObj_Body = null;
         var _loc16_:PhysObj_Graphic = null;
         var _loc18_:Object = null;
         var _loc19_:DisplayObj = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:BitmapData = null;
         var _loc28_:Number = NaN;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:PhysObj_Shape = null;
         var _loc32_:Number = NaN;
         var _loc33_:Array = null;
         var _loc34_:int = 0;
         var _loc10_:Boolean = param8;
         var _loc11_:Number = param5;
         _loc12_ = param2;
         _loc13_ = param3;
         var _loc17_:Array = new Array();
         for each(_loc15_ in param1.bodies)
         {
            for each(_loc16_ in _loc15_.graphics)
            {
               _loc18_ = new Object();
               _loc18_.graphic = _loc16_;
               _loc18_.x = _loc15_.pos.x;
               _loc18_.y = _loc15_.pos.y;
               _loc17_.push(_loc18_);
            }
         }
         for each(_loc16_ in param1.graphics)
         {
            _loc18_ = new Object();
            _loc18_.graphic = _loc16_;
            _loc18_.x = 0;
            _loc18_.y = 0;
            _loc17_.push(_loc18_);
         }
         for each(_loc18_ in _loc17_)
         {
            _loc16_ = _loc18_.graphic;
            _loc19_ = GraphicObjects.GetDisplayObjByIndex(_loc16_.graphicID);
            _loc20_ = Number(_loc18_.x);
            _loc21_ = Number(_loc18_.y);
            if(_loc19_.GetBitmapData(_loc16_.frame) != null)
            {
               if(param9 != null)
               {
                  _loc22_ = _loc19_.GetWidth(_loc16_.frame);
                  _loc23_ = _loc19_.GetHeight(_loc16_.frame);
                  _loc24_ = param9.width / _loc22_;
                  _loc25_ = param9.height / _loc23_;
                  _loc26_ = _loc24_;
                  if(_loc25_ < _loc24_)
                  {
                     _loc26_ = _loc25_;
                  }
                  _loc12_ -= param9.width / 2;
                  _loc13_ -= param9.height / 2;
                  _loc12_ += _loc20_;
                  _loc13_ += _loc21_;
                  _loc27_ = _loc19_.GetBitmapData(_loc16_.frame);
                  renderMatrix.identity();
                  renderMatrix.scale(_loc26_,_loc26_);
                  renderMatrix.translate(_loc12_,_loc13_);
                  if(_loc27_ != null)
                  {
                     param6.draw(_loc27_,renderMatrix,null,null,null,true);
                  }
               }
               else
               {
                  _loc28_ = Utils.DegToRad(param4 + _loc16_.rot);
                  renderPoint.x = _loc16_.offset.x;
                  renderPoint.y = _loc16_.offset.y;
                  if(_loc11_ != 1 || _loc28_ != 0)
                  {
                     renderPoint.x += _loc20_;
                     renderPoint.y += _loc21_;
                     renderMatrix.identity();
                     renderMatrix.rotate(Utils.DegToRad(param4));
                     renderPoint = renderMatrix.transformPoint(renderPoint);
                     _loc12_ = param2 + renderPoint.x;
                     _loc13_ = param3 + renderPoint.y;
                     GraphicObjects.GetDisplayObjByIndex(_loc16_.graphicID).RenderAtRotScaled(_loc16_.frame,param6,_loc12_,_loc13_,_loc11_,_loc28_);
                  }
                  else
                  {
                     renderPoint.x += _loc20_;
                     renderPoint.y += _loc21_;
                     _loc12_ = param2 + renderPoint.x;
                     _loc13_ = param3 + renderPoint.y;
                     GraphicObjects.GetDisplayObjByIndex(_loc16_.graphicID).RenderAt(_loc16_.frame,param6,_loc12_,_loc13_);
                  }
               }
            }
         }
         for each(_loc15_ in param1.bodies)
         {
            if(_loc10_)
            {
               if(param7 != null)
               {
                  renderMatrix.identity();
                  _loc28_ = Utils.DegToRad(param4);
                  if(_loc28_ != 0)
                  {
                     renderMatrix.rotate(_loc28_);
                  }
                  if(_loc11_ != 1)
                  {
                     renderMatrix.scale(_loc11_,_loc11_);
                  }
                  for each(_loc31_ in _loc15_.shapes)
                  {
                     if(_loc31_.type == PhysObj_Shape.Type_Circle)
                     {
                        _loc32_ = _loc31_.circle_radius * _loc11_;
                        RenderCircle(param7,param2 + _loc31_.circle_pos.x + _loc15_.pos.x,param3 + _loc31_.circle_pos.y + _loc15_.pos.y,_loc32_,4294967295,2);
                     }
                     if(_loc31_.type == PhysObj_Shape.Type_Poly)
                     {
                        _loc33_ = _loc31_.poly_points;
                        _loc34_ = int(_loc31_.poly_points.length);
                        _loc29_ = 0;
                        while(_loc29_ < _loc34_)
                        {
                           _loc30_ = _loc29_ + 1;
                           if(_loc30_ >= _loc34_)
                           {
                              _loc30_ = 0;
                           }
                           p0.x = _loc33_[_loc29_].x;
                           p0.y = _loc33_[_loc29_].y;
                           p1.x = _loc33_[_loc30_].x;
                           p1.y = _loc33_[_loc30_].y;
                           p0.x += _loc15_.pos.x;
                           p1.x += _loc15_.pos.x;
                           p0.y += _loc15_.pos.y;
                           p1.y += _loc15_.pos.y;
                           p0 = renderMatrix.transformPoint(p0);
                           p1 = renderMatrix.transformPoint(p1);
                           p0.x += param2;
                           p1.x += param2;
                           p0.y += param3;
                           p1.y += param3;
                           RenderLine(param7,p0.x,p0.y,p1.x,p1.y,4294967295,2);
                           _loc29_++;
                        }
                     }
                  }
               }
            }
         }
      }
      
      internal static function RenderCircle(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:uint, param6:Number = 1, param7:Number = 1) : *
      {
         param1.lineStyle(param6,param5,param7);
         param1.drawCircle(param2,param3,param4);
      }
      
      internal static function RenderLine(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:Number = 1, param8:Number = 1) : *
      {
         param1.lineStyle(param7,param6,param8);
         param1.moveTo(param2,param3);
         param1.lineTo(param4,param5);
      }
      
      internal static function RenderRectangle(param1:Graphics, param2:Rectangle, param3:uint, param4:Number = 1, param5:Number = 1) : *
      {
         RenderLine(param1,param2.left,param2.top,param2.right,param2.top,param3,param4,param5);
         RenderLine(param1,param2.left,param2.bottom,param2.right,param2.bottom,param3,param4,param5);
         RenderLine(param1,param2.left,param2.top,param2.left,param2.bottom,param3,param4,param5);
         RenderLine(param1,param2.right,param2.top,param2.right,param2.bottom,param3,param4,param5);
      }
      
      public static function RenderOutline(param1:PhysObj, param2:Number, param3:Number, param4:Number, param5:Graphics) : *
      {
         var _loc6_:PhysObj_Graphic = null;
         var _loc8_:PhysObj_Body = null;
         var _loc9_:DisplayObj = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Rectangle = null;
         var _loc7_:Array = new Array();
         for each(_loc8_ in param1.bodies)
         {
            for each(_loc6_ in _loc8_.graphics)
            {
               _loc7_.push(_loc6_);
            }
         }
         for each(_loc6_ in param1.graphics)
         {
            _loc7_.push(_loc6_);
         }
         for each(_loc6_ in _loc7_)
         {
            _loc9_ = GraphicObjects.GetDisplayObjByIndex(_loc6_.graphicID);
            _loc10_ = _loc9_.GetWidth(_loc6_.frame);
            _loc11_ = _loc9_.GetHeight(_loc6_.frame);
            _loc12_ = new Rectangle(param2 + _loc6_.offset.x,param3 + _loc6_.offset.y,_loc10_,_loc11_);
            RenderRectangle(param5,_loc12_,16736384,2);
         }
      }
      
      internal function GetGraphic(param1:XML) : PhysObj_Graphic
      {
         var _loc2_:PhysObj_Graphic = new PhysObj_Graphic();
         _loc2_.goInitFuntion = param1.@gameobjfunction;
         _loc2_.goInitFuntionVarString = param1.@gameobjvars;
         _loc2_.graphicName = param1.@clip;
         _loc2_.graphicID = 0;
         _loc2_.frame = XmlHelper.GetAttrInt(param1.@frame) - 1;
         _loc2_.offset = this.PointFromString(param1.@pos);
         _loc2_.zoffset = XmlHelper.GetAttrNumber(param1.@zoffset,0);
         _loc2_.hasShadow = XmlHelper.GetAttrBoolean(param1.@shadow,true);
         _loc2_.rot = Number(param1.@rot);
         _loc2_.Calculate();
         return _loc2_;
      }
      
      internal function GetSfx(param1:XML) : *
      {
         this.sfx_break = "";
         this.sfx_hit = "";
         if(param1 == null)
         {
            return;
         }
         this.sfx_break = XmlHelper.GetAttrString(param1.@broken,"");
         this.sfx_hit = XmlHelper.GetAttrString(param1.@hit,"");
      }
      
      internal function GetGameSpecific(param1:XML) : *
      {
         this.zombooka_HitDamage = 0;
         this.zombooka_SuperHitDamage = 0;
         this.zombooka_greatkill = false;
         this.zombooka_hitZombieSound = "";
         this.zombooka_hitMissileSound = "";
         if(param1 == null)
         {
            return;
         }
         this.zombooka_HitDamage = XmlHelper.GetAttrNumber(param1.@hitdamage,0);
         this.zombooka_SuperHitDamage = XmlHelper.GetAttrNumber(param1.@superhitdamage,0);
         this.zombooka_greatkill = XmlHelper.GetAttrBoolean(param1.@greatkill,0);
         this.zombooka_hitZombieSound = XmlHelper.GetAttrString(param1.@hitzombiesound,"");
         this.zombooka_hitMissileSound = XmlHelper.GetAttrString(param1.@hitmissilesound,"");
      }
      
      public function FromXml(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PhysObj_Graphic = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc9_:XML = null;
         var _loc10_:PhysObj_Body = null;
         var _loc11_:XML = null;
         var _loc12_:PhysObj_Shape = null;
         var _loc13_:Point = null;
         var _loc14_:XML = null;
         var _loc15_:PhysObj_Joint = null;
         this.bodies = new Array();
         this.joints = new Array();
         this.graphics = new Array();
         this.instanceParams = new Array();
         this.instanceParamsDefaults = new Array();
         this.name = param1.@name;
         this.displayInLibrary = XmlHelper.GetAttrBoolean(param1.@inlibrary,false);
         this.initFunctionName = XmlHelper.GetAttrString(param1.@initfunction,null);
         this.editorRenderFunctionName = XmlHelper.GetAttrString(param1.@editorrender,null);
         this.initFunctionParameters = XmlHelper.GetAttrString(param1.@initparams,"");
         this.libraryClass = XmlHelper.GetAttrString(param1.@libclass,"");
         this.hasPhysics = XmlHelper.GetAttrBoolean(param1.@hasphysics,true);
         this.GetSfx(param1.sfx[0]);
         this.GetGameSpecific(param1.zombooka[0]);
         _loc2_ = 0;
         while(_loc2_ < param1.parameter.length())
         {
            _loc6_ = param1.parameter[_loc2_];
            this.instanceParams.push(XmlHelper.GetAttrString(_loc6_.@name,""));
            this.instanceParamsDefaults.push(XmlHelper.GetAttrString(_loc6_.@§default§,""));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.graphic.length())
         {
            _loc7_ = param1.graphic[_loc3_];
            this.graphics.push(this.GetGraphic(_loc7_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.body.length())
         {
            _loc9_ = param1.body[_loc2_];
            _loc10_ = new PhysObj_Body();
            _loc10_.name = _loc9_.@name;
            _loc10_.fixed = this.BooleanFromString(_loc9_.@fixed);
            _loc10_.sensor = this.BooleanFromString(_loc9_.@sensor);
            _loc10_.pos = this.PointFromString(_loc9_.@pos);
            _loc10_.linearDamping = 0;
            _loc10_.angularDamping = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc9_.graphic.length())
            {
               _loc7_ = _loc9_.graphic[_loc3_];
               _loc10_.graphics.push(this.GetGraphic(_loc7_));
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc9_.shape.length())
            {
               _loc11_ = _loc9_.shape[_loc3_];
               _loc12_ = new PhysObj_Shape();
               _loc12_.name = _loc11_.@name;
               _loc8_ = _loc11_.@type;
               _loc13_ = this.PointFromString(_loc11_.@col);
               _loc12_.collisionCategory = XmlHelper.GetAttrInt(_loc13_.x);
               _loc12_.collisionMask = XmlHelper.GetAttrInt(_loc13_.y);
               _loc12_.materialName = XmlHelper.GetAttrString(_loc11_.@material,"");
               _loc12_.density = XmlHelper.GetAttrNumber(_loc11_.@density);
               _loc12_.friction = XmlHelper.GetAttrNumber(_loc11_.@friction);
               _loc12_.restitution = XmlHelper.GetAttrNumber(_loc11_.@restitution);
               if(_loc8_ == "circle")
               {
                  _loc12_.type = PhysObj_Shape.Type_Circle;
                  _loc12_.circle_pos = this.PointFromString(_loc11_.@pos);
                  _loc12_.circle_radius = XmlHelper.GetAttrNumber(_loc11_.@radius);
               }
               else if(_loc8_ == "poly")
               {
                  _loc12_.type = PhysObj_Shape.Type_Poly;
                  _loc12_.poly_points = this.PointArrayFromString(_loc11_.@vertices);
                  _loc12_.poly_rot = Utils.DegToRad(XmlHelper.GetAttrNumber(_loc11_.@rot));
               }
               _loc12_.Caclulate();
               _loc10_.shapes.push(_loc12_);
               _loc3_++;
            }
            this.bodies.push(_loc10_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.joint.length())
         {
            _loc14_ = param1.joint[_loc2_];
            _loc15_ = new PhysObj_Joint();
            _loc15_.name = _loc14_.@name;
            _loc15_.obj0Name = _loc14_.@body0;
            _loc15_.obj1Name = _loc14_.@body1;
            _loc8_ = _loc14_.@type;
            if(_loc8_ == "rev")
            {
               _loc15_.type = PhysObj_Joint.Type_Rev;
               _loc15_.rev_pos = this.PointFromString(_loc14_.@pos);
               _loc15_.rev_enableLimit = this.BooleanFromString(_loc14_.@enablelimit);
               _loc15_.rev_lowerAngle = Utils.DegToRad(XmlHelper.GetAttrNumber(_loc14_.@lowerangle));
               _loc15_.rev_upperAngle = Utils.DegToRad(XmlHelper.GetAttrNumber(_loc14_.@upperangle));
               _loc15_.rev_enableMotor = this.BooleanFromString(_loc14_.@enablemotor);
               _loc15_.rev_motorSpeed = Number(_loc14_.@motorspeed);
               _loc15_.rev_maxMotorTorque = Number(_loc14_.@maxmotortorque);
            }
            else if(_loc8_ == "distance")
            {
               _loc15_.type = PhysObj_Joint.Type_Distance;
               _loc15_.dist_pos0 = this.PointFromString(_loc14_.@pos);
               _loc15_.dist_pos1 = this.PointFromString(_loc14_.@pos1);
            }
            else if(_loc8_ == "mouse")
            {
               _loc15_.type = PhysObj_Joint.Type_Mouse;
            }
            else if(_loc8_ == "prismatic")
            {
               _loc15_.type = PhysObj_Joint.Type_Prismatic;
               _loc15_.prism_pos = this.PointFromString(_loc14_.@pos);
               _loc15_.prism_enableLimit = this.BooleanFromString(_loc14_.@enablelimit);
               _loc15_.prism_lowerTranslation = Number(_loc14_.@lowertranslation);
               _loc15_.prism_upperTranslation = Number(_loc14_.@uppertranslation);
               _loc15_.prism_enableMotor = this.BooleanFromString(_loc14_.@enablemotor);
               _loc15_.prism_axisangle = Number(_loc14_.@axisangle) - Number(90);
               _loc15_.prism_motorSpeed = Number(_loc14_.@motorspeed);
               _loc15_.prism_maxMotorForce = Number(_loc14_.@maxmotorforce);
            }
            this.joints.push(_loc15_);
            _loc2_++;
         }
      }
      
      internal function PointFromString(param1:String) : Point
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:Point = new Point(0,0);
         if(_loc2_.length != 2)
         {
            return _loc3_;
         }
         _loc3_.x = Number(_loc2_[0]);
         _loc3_.y = Number(_loc2_[1]);
         return _loc3_;
      }
      
      internal function PointArrayFromString(param1:String) : Array
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
      
      internal function BooleanFromString(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         param1 = param1.toUpperCase();
         if(param1 == "1")
         {
            _loc2_ = true;
         }
         if(param1 == "TRUE")
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function JointIndexFromName(param1:String) : int
      {
         var _loc3_:PhysObj_Joint = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.joints.length)
         {
            _loc3_ = this.joints[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function BodyIndexFromName(param1:String) : int
      {
         var _loc3_:PhysObj_Body = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.bodies.length)
         {
            _loc3_ = this.bodies[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function BodyFromName(param1:String) : PhysObj_Body
      {
         var _loc3_:PhysObj_Body = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.bodies.length)
         {
            _loc3_ = this.bodies[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

