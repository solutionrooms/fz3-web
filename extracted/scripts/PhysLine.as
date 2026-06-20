package
{
   import EditorPackage.ObjParameters;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PhysLine
   {
      
      public static const PRIMITIVE_LINE:String = "line";
      
      public static const PRIMITIVE_RECTANGLE:String = "rectangle";
      
      public static const PRIMITIVE_CIRCLE:String = "circle";
      
      public var index:int;
      
      public var id:String;
      
      public var type:int;
      
      public var points:Array;
      
      public var fill:int;
      
      public var fillScaleX:Number;
      
      public var fillScaleY:Number;
      
      public var centrex:Number;
      
      public var centrey:Number;
      
      public var fixed:Boolean;
      
      public var primitiveType:String;
      
      public var objParameters:ObjParameters;
      
      internal var boundingRectangle:Rectangle;
      
      internal var catmullRomLength:Number;
      
      internal var segmentLengths:Array;
      
      internal var segmentRatios:Array;
      
      public function PhysLine()
      {
         super();
         this.id = "";
         this.type = 0;
         this.points = new Array();
         this.fill = 0;
         this.fillScaleX = 1;
         this.fillScaleY = 1;
         this.fixed = true;
         this.objParameters = new ObjParameters();
         this.primitiveType = PRIMITIVE_LINE;
         this.objParameters.Add("line_physmaterial","average");
         this.objParameters.Add("line_fixed","true");
         this.objParameters.Add("line_function","InitGameObjLine_Wood");
         this.objParameters.Add("line_background_frame","1");
         this.objParameters.Add("editor_layer","1");
         this.centrex = 0;
         this.centrey = 0;
      }
      
      public static function inflateRectByPoint(param1:Rectangle, param2:Point) : void
      {
         var _loc3_:Number = NaN;
         _loc3_ = param2.x - param1.x;
         if(_loc3_ < 0)
         {
            param1.x += _loc3_;
            param1.width -= _loc3_;
         }
         else if(_loc3_ > param1.width)
         {
            param1.width = _loc3_;
         }
         _loc3_ = param2.y - param1.y;
         if(_loc3_ < 0)
         {
            param1.y += _loc3_;
            param1.height -= _loc3_;
         }
         else if(_loc3_ > param1.height)
         {
            param1.height = _loc3_;
         }
      }
      
      public function AddPoint(param1:Number, param2:Number) : *
      {
         this.points.push(new Point(param1,param2));
      }
      
      public function SetPointArray(param1:Array) : *
      {
         this.points = param1;
      }
      
      public function Clone() : PhysLine
      {
         var _loc2_:Point = null;
         var _loc1_:PhysLine = new PhysLine();
         _loc1_.id = this.id;
         _loc1_.type = this.type;
         _loc1_.fill = this.fill;
         _loc1_.fillScaleX = this.fillScaleX;
         _loc1_.fillScaleY = this.fillScaleY;
         _loc1_.centrex = this.centrex;
         _loc1_.centrey = this.centrey;
         _loc1_.fixed = this.fixed;
         for each(_loc2_ in this.points)
         {
            _loc1_.points.push(_loc2_.clone());
         }
         _loc1_.objParameters = this.objParameters.Clone();
         _loc1_.primitiveType = this.primitiveType;
         return _loc1_;
      }
      
      public function GetPoint(param1:int) : Point
      {
         return this.points[param1];
      }
      
      internal function CalcBoundingRectangle() : *
      {
         var _loc1_:Point = null;
         _loc1_ = this.points[0];
         this.boundingRectangle = new Rectangle(_loc1_.x,_loc1_.y,1,1);
         for each(_loc1_ in this.points)
         {
            inflateRectByPoint(this.boundingRectangle,_loc1_);
         }
      }
      
      public function PointInPoly(param1:Number, param2:Number) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc3_:int = 0;
         if(this.points.length == 2)
         {
            return this.PointOnLine(param1,param2,2);
         }
         this.CalcBoundingRectangle();
         if(this.boundingRectangle.contains(param1,param2) == false)
         {
            return false;
         }
         var _loc4_:int = int(this.points.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc5_ + 1;
            if(_loc6_ >= _loc4_)
            {
               _loc6_ = 0;
            }
            _loc7_ = this.points[_loc5_];
            _loc8_ = this.points[_loc6_];
            _loc9_ = _loc7_.x;
            _loc10_ = _loc7_.y;
            _loc11_ = _loc8_.x;
            _loc12_ = _loc8_.y;
            if(_loc12_ < _loc10_)
            {
               _loc9_ = _loc8_.x;
               _loc10_ = _loc8_.y;
               _loc11_ = _loc7_.x;
               _loc12_ = _loc7_.y;
            }
            if(param2 >= _loc10_ && param2 <= _loc12_)
            {
               _loc13_ = _loc12_ - _loc10_;
               _loc14_ = _loc11_ - _loc9_;
               _loc15_ = (param2 - _loc10_) / _loc13_;
               _loc16_ = _loc9_ + _loc14_ * _loc15_;
               if(param1 < _loc16_)
               {
                  _loc3_++;
               }
            }
            _loc5_++;
         }
         if((_loc3_ & 1) != 0)
         {
            return true;
         }
         return false;
      }
      
      public function PointOnLine(param1:Number, param2:Number, param3:Number = 1) : Boolean
      {
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc5_:Array = this.points;
         var _loc6_:int = int(this.points.length);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_ = _loc4_ + 1;
            if(_loc7_ >= _loc6_)
            {
               _loc7_ = 0;
            }
            _loc8_ = _loc5_[_loc4_];
            _loc9_ = _loc5_[_loc7_];
            _loc10_ = Collision.ClosestPointOnLine(_loc8_.x,_loc8_.y,_loc9_.x,_loc9_.y,param1,param2);
            if(_loc10_ >= 0 && _loc10_ <= 1)
            {
               if(Utils.DistBetweenPoints(param1,param2,Collision.closestX,Collision.closestY) < param3)
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      public function PointInConvexPoly(param1:Number, param2:Number) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc3_:int = int(this.points.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc4_ + 1;
            if(_loc5_ >= _loc3_)
            {
               _loc5_ = 0;
            }
            _loc6_ = this.points[_loc4_];
            _loc7_ = this.points[_loc5_];
            _loc8_ = new Point(_loc7_.x - _loc6_.x,_loc7_.y - _loc6_.y);
            _loc9_ = new Point(_loc7_.x - param1,_loc7_.y - param2);
            _loc10_ = Utils.DotProduct(_loc8_.x,_loc8_.y,_loc9_.x,_loc9_.y);
            if(_loc10_ < 0)
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public function CalculateLength(param1:Boolean = false) : Number
      {
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         this.segmentLengths = null;
         this.segmentRatios = null;
         var _loc2_:Number = 0;
         var _loc3_:* = this.GetNumPoints();
         var _loc4_:int = _loc3_;
         if(_loc3_ <= 1)
         {
            return 0;
         }
         if(param1 == false)
         {
            _loc3_--;
         }
         this.segmentLengths = new Array();
         this.segmentRatios = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc7_ = _loc5_ + 1;
            if(_loc7_ >= _loc4_)
            {
               _loc7_ = 0;
            }
            _loc8_ = Utils.DistBetweenPoints(this.points[_loc5_].x,this.points[_loc5_].y,this.points[_loc7_].x,this.points[_loc7_].y);
            _loc2_ += _loc8_;
            this.segmentLengths.push(_loc8_);
            _loc5_++;
         }
         for each(_loc6_ in this.segmentLengths)
         {
            _loc9_ = 1 / _loc2_ * _loc6_;
            this.segmentRatios.push(_loc9_);
         }
         return _loc2_;
      }
      
      public function CalculateCatmullRomLength() : *
      {
         var _loc2_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = this.GetNumPoints();
         if(_loc3_ < 4)
         {
            this.catmullRomLength = 0;
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < 1)
            {
               _loc5_ = this.GetPointOnCatmullRom(_loc4_,true);
               _loc1_.push(_loc5_);
               _loc4_ += 0.025;
            }
         }
         this.catmullRomLength = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length - 2)
         {
            _loc6_ = _loc1_[_loc2_];
            _loc7_ = _loc1_[_loc2_ + 1];
            this.catmullRomLength += Utils.DistBetweenPoints(_loc6_.x,_loc6_.y,_loc7_.x,_loc7_.y);
            _loc2_++;
         }
         _loc1_ = null;
      }
      
      public function PointOnCurve(param1:Number, param2:Point, param3:Point, param4:Point, param5:Point) : Point
      {
         var _loc6_:Point = new Point();
         var _loc7_:Number = param1 * param1;
         var _loc8_:Number = _loc7_ * param1;
         _loc6_.x = 0.5 * (2 * param3.x + (-param2.x + param4.x) * param1 + (2 * param2.x - 5 * param3.x + 4 * param4.x - param5.x) * _loc7_ + (-param2.x + 3 * param3.x - 3 * param4.x + param5.x) * _loc8_);
         _loc6_.y = 0.5 * (2 * param3.y + (-param2.y + param4.y) * param1 + (2 * param2.y - 5 * param3.y + 4 * param4.y - param5.y) * _loc7_ + (-param2.y + 3 * param3.y - 3 * param4.y + param5.y) * _loc8_);
         return _loc6_;
      }
      
      public function GetPointOnCatmullRom(param1:Number, param2:Boolean) : Point
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc3_:int = this.GetNumPoints();
         if(_loc3_ < 4)
         {
            return new Point(0,0);
         }
         var _loc4_:int = _loc3_;
         var _loc9_:Number = Number(_loc4_) * param1;
         if(_loc9_ >= _loc4_)
         {
            _loc9_ = _loc4_ - 1;
         }
         var _loc10_:int = _loc9_;
         if(param2)
         {
            _loc11_ = Utils.AddIntAndLoop(0,_loc3_ - 1,_loc10_,-1);
            _loc12_ = _loc10_;
            _loc13_ = Utils.AddIntAndLoop(0,_loc3_ - 1,_loc10_,1);
            _loc14_ = Utils.AddIntAndLoop(0,_loc3_ - 1,_loc10_,2);
         }
         else
         {
            _loc11_ = _loc10_ - 1;
            _loc12_ = _loc10_;
            _loc13_ = _loc10_ + 1;
            _loc14_ = _loc10_ + 2;
            if(_loc11_ < 0)
            {
               _loc11_ = 0;
            }
            if(_loc13_ > _loc3_ - 1)
            {
               _loc13_ = _loc3_ - 1;
            }
            if(_loc14_ > _loc3_ - 1)
            {
               _loc14_ = _loc3_ - 1;
            }
         }
         _loc5_ = this.points[_loc11_];
         _loc6_ = this.points[_loc12_];
         _loc7_ = this.points[_loc13_];
         _loc8_ = this.points[_loc14_];
         var _loc15_:int = _loc10_ + 1;
         var _loc16_:Number = 1 / Number(_loc4_) * _loc10_;
         var _loc17_:Number = 1 / Number(_loc4_) * _loc15_;
         var _loc18_:Number = 1 / (_loc17_ - _loc16_) * (param1 - _loc16_);
         return this.PointOnCurve(_loc18_,_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      public function DrawCatmullRom(param1:BitmapData, param2:uint, param3:Number, param4:Number) : *
      {
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc5_:int = this.GetNumPoints();
         if(_loc5_ < 4)
         {
            return;
         }
         _loc6_ = 0;
         while(_loc6_ < 1)
         {
            _loc7_ = this.GetPointOnCatmullRom(_loc6_,true);
            param1.setPixel32(_loc7_.x + param3,_loc7_.y + param4,param2);
            _loc6_ += 0.001;
         }
      }
      
      public function GetNumPoints() : int
      {
         return this.points.length;
      }
      
      public function GetInterpolatedPoint1(param1:Number, param2:Boolean) : Point
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Point = null;
         this.CalculateLength(param2);
         var _loc3_:int = int(this.points.length);
         if(param2)
         {
            _loc3_++;
         }
         var _loc4_:int = _loc3_ - 1;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = _loc6_ + 1;
            if(_loc7_ >= this.points.length)
            {
               _loc7_ = 0;
            }
            _loc8_ = Number(this.segmentRatios[_loc6_]);
            _loc9_ = _loc5_ + _loc8_;
            if(param1 >= _loc5_ && param1 <= _loc9_)
            {
               _loc10_ = Utils.ScaleTo(0,1,_loc5_,_loc9_,param1);
               _loc11_ = Utils.ScaleTo(this.points[_loc6_].x,this.points[_loc7_].x,0,1,_loc10_);
               _loc12_ = Utils.ScaleTo(this.points[_loc6_].y,this.points[_loc7_].y,0,1,_loc10_);
               return new Point(_loc11_,_loc12_);
            }
            _loc5_ += _loc8_;
            _loc6_++;
         }
         return new Point(0,0);
      }
      
      public function GetInterpolatedPoint(param1:Number, param2:Boolean, param3:Boolean = false) : Point
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Point = null;
         if(param3)
         {
            return this.GetPointOnCatmullRom(param1,param2);
         }
         if(param2 == true)
         {
            _loc4_ = int(this.points.length);
            _loc5_ = 1 / _loc4_;
            _loc6_ = Math.floor(_loc4_ * param1);
            _loc7_ = (_loc6_ + 1) % _loc4_;
            _loc8_ = _loc6_ * _loc5_;
            _loc9_ = (_loc6_ + 1) * _loc5_;
            _loc10_ = Utils.ScaleTo(this.points[_loc6_].x,this.points[_loc7_].x,_loc8_,_loc9_,param1);
            _loc11_ = Utils.ScaleTo(this.points[_loc6_].y,this.points[_loc7_].y,_loc8_,_loc9_,param1);
            return new Point(_loc10_,_loc11_);
         }
         _loc4_ = int(this.points.length);
         _loc5_ = 1 / (_loc4_ - 1);
         _loc6_ = Math.floor((_loc4_ - 1) * param1);
         _loc7_ = (_loc6_ + 1) % _loc4_;
         _loc8_ = _loc6_ * _loc5_;
         _loc9_ = (_loc6_ + 1) * _loc5_;
         _loc10_ = Utils.ScaleTo(this.points[_loc6_].x,this.points[_loc7_].x,_loc8_,_loc9_,param1);
         _loc11_ = Utils.ScaleTo(this.points[_loc6_].y,this.points[_loc7_].y,_loc8_,_loc9_,param1);
         return new Point(_loc10_,_loc11_);
      }
   }
}

