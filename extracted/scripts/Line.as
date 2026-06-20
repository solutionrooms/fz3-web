package
{
   import flash.geom.Rectangle;
   
   public class Line
   {
      
      public var x0:Number;
      
      public var y0:Number;
      
      public var x1:Number;
      
      public var y1:Number;
      
      public var nx:Number;
      
      public var ny:Number;
      
      public var dir:Number;
      
      public var normalDir:Number;
      
      public var length:Number;
      
      public var dx:Number;
      
      public var dy:Number;
      
      public var udx:Number;
      
      public var udy:Number;
      
      public var boundingRect:Rectangle;
      
      public function Line(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super();
         this.x0 = param1;
         this.y0 = param2;
         this.x1 = param3;
         this.y1 = param4;
         this.CalcNormal();
         this.CalcBoundingRect();
      }
      
      internal function CalcBoundingRect() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc1_ = this.x0;
         _loc2_ = this.x1;
         if(_loc1_ > _loc2_)
         {
            _loc1_ = this.x1;
            _loc2_ = this.x0;
         }
         _loc3_ = this.y0;
         _loc4_ = this.y1;
         if(_loc3_ > _loc4_)
         {
            _loc3_ = this.y1;
            _loc4_ = this.y0;
         }
         this.boundingRect = new Rectangle(_loc1_,_loc3_,_loc2_ - _loc1_ + 1,_loc4_ - _loc3_ + 1);
      }
      
      internal function CalcNormal() : void
      {
         this.dir = Math.atan2(this.y1 - this.y0,this.x1 - this.x0);
         this.normalDir = this.dir - Math.PI * 0.5;
         this.nx = Math.cos(this.normalDir);
         this.ny = Math.sin(this.normalDir);
         this.dx = this.x1 - this.x0;
         this.dy = this.y1 - this.y0;
         this.length = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
         this.udx = Math.cos(this.dir);
         this.udy = Math.sin(this.dir);
      }
   }
}

