package
{
   import flash.geom.Point;
   
   public class Camera
   {
      
      internal static var shakeCamToX:Number = 0;
      
      internal static var shakeCamToY:Number = 0;
      
      internal static var shakeCamX:Number = 0;
      
      internal static var shakeCamY:Number = 0;
      
      internal static var shakeCamDX:Number = 0;
      
      internal static var shakeCamDY:Number = 0;
      
      internal static var shakeCamTimer:int = 50;
      
      internal static var shakeCamTimerMax:int = 50;
      
      internal var x:Number;
      
      internal var y:Number;
      
      internal var oldX:Number;
      
      internal var oldY:Number;
      
      internal var cx:Number;
      
      internal var cy:Number;
      
      internal var maxX:Number;
      
      internal var maxY:Number;
      
      internal var minX:Number;
      
      internal var minY:Number;
      
      internal var toDX:Number;
      
      internal var toDY:Number;
      
      internal var scale:Number;
      
      internal var savedx:Number;
      
      internal var savedy:Number;
      
      public function Camera()
      {
         super();
         this.Reset();
      }
      
      internal static function UpdateShakeCam(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         --shakeCamTimer;
         if(shakeCamTimer <= 0)
         {
            shakeCamTimer = Utils.RandBetweenInt(5,20);
            shakeCamTimerMax = shakeCamTimer;
            _loc2_ = Utils.ScaleTo(2,20,0,30,param1);
            shakeCamToX = Utils.RandBetweenFloat(-_loc2_,_loc2_);
            shakeCamToY = Utils.RandBetweenFloat(-_loc2_,_loc2_);
            shakeCamDX = (shakeCamToX - shakeCamX) / shakeCamTimer;
            shakeCamDY = (shakeCamToY - shakeCamY) / shakeCamTimer;
         }
         shakeCamX += shakeCamDX;
         shakeCamY += shakeCamDY;
      }
      
      public function PushPos() : *
      {
         this.savedx = this.x;
         this.savedy = this.y;
      }
      
      public function PopPos() : *
      {
         this.x = this.savedx;
         this.y = this.savedy;
      }
      
      public function ResetBounds() : *
      {
         this.minX = 12345678;
         this.maxX = 12345678;
         this.minY = 12345678;
         this.maxY = 12345678;
      }
      
      public function UpdatePosition(param1:Number, param2:Number, param3:Point) : *
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc10_:Number = NaN;
         this.oldX = this.x;
         this.oldY = this.y;
         var _loc6_:Number = 320;
         var _loc7_:Number = 240;
         this.cx = param1;
         this.cy = param2;
         var _loc8_:Number = Math.atan2(param3.y,param3.x);
         var _loc9_:Number = Utils.GetLength(param3.x,param3.y);
         if(_loc9_ < 3)
         {
            _loc4_ = 0;
            _loc5_ = 0;
         }
         else
         {
            _loc9_ = Utils.LimitNumber(3,10,_loc9_);
            _loc10_ = Utils.ScaleTo(0,150,0,30,_loc9_);
            _loc4_ = Math.cos(_loc8_) * _loc10_;
            _loc5_ = Math.sin(_loc8_) * _loc10_;
         }
         this.toDX += (_loc4_ - this.toDX) * 0.1;
         this.toDY += (_loc5_ - this.toDY) * 0.1;
         this.x = param1 - _loc6_ + this.toDX;
         this.y = param2 - _loc7_ + this.toDY;
         if(this.minX != 12345678 && this.minY != 12345678)
         {
            if(this.x < this.minX)
            {
               this.x = this.minX;
            }
            if(this.y < this.minY)
            {
               this.y = this.minY;
            }
            if(this.x > this.maxX - Defs.displayarea_w)
            {
               this.x = this.maxX - Defs.displayarea_w;
            }
            if(this.y > this.maxY - Defs.displayarea_h)
            {
               this.y = this.maxY - Defs.displayarea_h;
            }
         }
         this.scale = 1;
      }
      
      public function Reset() : *
      {
         this.x = 0;
         this.y = 0;
         this.oldX = 0;
         this.oldY = 0;
         this.cx = 0;
         this.cy = 0;
         this.maxX = this.minX = 0;
         this.maxY = this.minY = 0;
         this.toDX = this.toDY = 0;
         this.scale = 1;
      }
   }
}

