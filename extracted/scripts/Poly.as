package
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Poly
   {
      
      public static const polytype_PATH:* = 0;
      
      public static const polytype_WALL:* = 1;
      
      public static const polytype_TRIGGER:* = 2;
      
      public static const polytype_ZONE:* = 3;
      
      public static const polytype_OVERLAY:* = 4;
      
      public static const polytype_FLOOR:* = 5;
      
      public static const polytype_CEILING:* = 6;
      
      internal var boundingRectangle:Rectangle;
      
      internal var active:Boolean;
      
      internal var type:int;
      
      internal var name:String;
      
      internal var lineList:Array;
      
      internal var pointList:Array;
      
      internal var hitCallback:Object;
      
      internal var param0:String;
      
      internal var param1:String;
      
      internal var iparam0:int;
      
      internal var typeName:String;
      
      internal var subTypeName:String;
      
      internal var closed:Boolean;
      
      internal var catmullRomLength:Number;
      
      public function Poly(param1:String, param2:int, param3:Number, param4:Number)
      {
         super();
         this.lineList = new Array();
         this.active = true;
         this.type = param2;
         this.name = param1;
         this.boundingRectangle = null;
         this.hitCallback = null;
         this.closed = false;
         this.pointList = new Array();
         this.pointList.push(new Point(param3,param4));
      }
      
      public static function FindAllByType(param1:int, param2:Array) : Array
      {
         var _loc4_:Poly = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param2)
         {
            if(_loc4_.type == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function FindByName(param1:String, param2:Array) : Poly
      {
         var _loc3_:Poly = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function FindIndexByName(param1:String, param2:Array) : int
      {
         var _loc4_:Poly = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param2)
         {
            if(_loc4_.name == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public static function MakeSplineFromPointList(param1:Array) : Poly
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc6_:int = 0;
         _loc2_ = param1[0];
         var _loc4_:Poly = new Poly("",0,_loc2_.x,_loc2_.y);
         var _loc5_:int = int(param1.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_ - 1)
         {
            _loc2_ = param1[_loc6_];
            _loc3_ = param1[_loc6_ + 1];
            _loc4_.AddLine(_loc2_.x,_loc2_.y,_loc3_.x,_loc3_.y);
            _loc6_++;
         }
         _loc4_.Finish(false);
         _loc4_.CalculateCatmullRomLength();
         return _loc4_;
      }
      
      public function AddLine(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc6_:Rectangle = null;
         var _loc5_:Line = new Line(param1,param2,param3,param4);
         this.lineList.push(_loc5_);
         this.pointList.push(new Point(param3,param4));
         if(this.boundingRectangle == null)
         {
            this.boundingRectangle = _loc5_.boundingRect;
         }
         else
         {
            _loc6_ = this.boundingRectangle.clone();
            this.boundingRectangle = _loc6_.union(_loc5_.boundingRect);
         }
      }
      
      public function Finish(param1:Boolean) : *
      {
         var _loc2_:Line = null;
         var _loc3_:Line = null;
         var _loc4_:Line = null;
         var _loc5_:Rectangle = null;
         if(param1)
         {
            _loc2_ = this.lineList[0];
            _loc3_ = this.lineList[this.lineList.length - 1];
            _loc4_ = new Line(_loc3_.x1,_loc3_.y1,_loc2_.x0,_loc2_.y0);
            this.lineList.push(_loc4_);
            _loc5_ = this.boundingRectangle.clone();
            this.boundingRectangle = _loc5_.union(_loc4_.boundingRect);
         }
         this.closed = param1;
      }
      
      public function OffsetFromStartPoint() : *
      {
         var _loc3_:int = 0;
         var _loc4_:Line = null;
         var _loc1_:* = -this.pointList[0].x;
         var _loc2_:* = -this.pointList[0].y;
         _loc3_ = 0;
         while(_loc3_ < this.pointList.length)
         {
            this.pointList[_loc3_].x += _loc1_;
            this.pointList[_loc3_].y += _loc2_;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.lineList.length)
         {
            _loc4_ = this.lineList[_loc3_];
            _loc4_.x0 += _loc1_;
            _loc4_.x1 += _loc1_;
            _loc4_.y0 += _loc2_;
            _loc4_.y1 += _loc2_;
            _loc3_++;
         }
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
               _loc5_ = this.GetPointOnCatmullRom(_loc4_);
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
      
      internal function PointOnCurve(param1:Number, param2:Point, param3:Point, param4:Point, param5:Point) : Point
      {
         var _loc6_:Point = new Point();
         var _loc7_:Number = param1 * param1;
         var _loc8_:Number = _loc7_ * param1;
         _loc6_.x = 0.5 * (2 * param3.x + (-param2.x + param4.x) * param1 + (2 * param2.x - 5 * param3.x + 4 * param4.x - param5.x) * _loc7_ + (-param2.x + 3 * param3.x - 3 * param4.x + param5.x) * _loc8_);
         _loc6_.y = 0.5 * (2 * param3.y + (-param2.y + param4.y) * param1 + (2 * param2.y - 5 * param3.y + 4 * param4.y - param5.y) * _loc7_ + (-param2.y + 3 * param3.y - 3 * param4.y + param5.y) * _loc8_);
         return _loc6_;
      }
      
      public function GetPointOnCatmullRom(param1:Number) : Point
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc2_:int = this.GetNumPoints();
         if(_loc2_ < 4)
         {
            return new Point(0,0);
         }
         var _loc3_:int = _loc2_ - 1;
         var _loc8_:Number;
         var _loc9_:int = _loc8_ = Number(_loc3_) * param1;
         var _loc10_:int = _loc9_ - 1;
         var _loc11_:int = _loc9_;
         var _loc12_:int = _loc9_ + 1;
         var _loc13_:int = _loc9_ + 2;
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(_loc12_ > _loc2_ - 1)
         {
            _loc12_ = _loc2_ - 1;
         }
         if(_loc13_ > _loc2_ - 1)
         {
            _loc13_ = _loc2_ - 1;
         }
         _loc4_ = this.pointList[_loc10_];
         _loc5_ = this.pointList[_loc11_];
         _loc6_ = this.pointList[_loc12_];
         _loc7_ = this.pointList[_loc13_];
         var _loc14_:int = _loc9_ + 1;
         var _loc15_:Number = 1 / Number(_loc3_) * _loc9_;
         var _loc16_:Number = 1 / Number(_loc3_) * _loc14_;
         var _loc17_:Number = 1 / (_loc16_ - _loc15_) * (param1 - _loc15_);
         return this.PointOnCurve(_loc17_,_loc4_,_loc5_,_loc6_,_loc7_);
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
            _loc7_ = this.GetPointOnCatmullRom(_loc6_);
            param1.setPixel32(_loc7_.x + param3,_loc7_.y + param4,param2);
            _loc6_ += 0.001;
         }
      }
      
      public function GetNumPoints() : int
      {
         return this.pointList.length;
      }
      
      public function GetNumLines() : int
      {
         return this.lineList.length;
      }
      
      public function GetLine(param1:int) : Line
      {
         return this.lineList[param1];
      }
      
      public function GetCatmullRomLength() : Number
      {
         return this.catmullRomLength;
      }
      
      public function GetPoint(param1:int) : Point
      {
         return new Point(this.pointList[param1].x,this.pointList[param1].y);
      }
      
      public function GetPointNormal(param1:int) : Point
      {
         return new Point(this.lineList[param1].nx,this.lineList[param1].ny);
      }
   }
}

