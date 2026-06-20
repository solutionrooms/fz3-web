package
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   internal class DisplayObjFrame
   {
      
      public static var mat:Matrix = new Matrix();
      
      public static var colTrans:ColorTransform = new ColorTransform();
      
      public var bitmapData:BitmapData;
      
      public var xoffset:Number;
      
      public var yoffset:Number;
      
      public var sourceRect:Rectangle;
      
      public var point:Point;
      
      public function DisplayObjFrame()
      {
         super();
      }
      
      public function Remove() : *
      {
         if(this.bitmapData != null)
         {
            this.bitmapData.dispose();
            this.bitmapData = null;
            this.sourceRect = null;
            this.point = null;
         }
      }
      
      public function RenderAt(param1:BitmapData, param2:Number, param3:Number) : void
      {
         this.point.x = param2 + this.xoffset;
         this.point.y = param3 + this.yoffset;
         param1.copyPixels(this.bitmapData,this.sourceRect,this.point,null,null,true);
      }
      
      public function RenderAtXFlip(param1:BitmapData, param2:Number, param3:Number) : void
      {
         mat.identity();
         mat.translate(this.xoffset,this.yoffset);
         mat.scale(-1,1);
         mat.translate(param2,param3);
         if(this.bitmapData != null)
         {
            param1.draw(this.bitmapData,mat,null,null,null,true);
         }
      }
      
      public function HitTestRotScaled(param1:BitmapData, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:ColorTransform = null, param7:Boolean = false) : Boolean
      {
         return param1.hitTest(new Point(0,0),255,this.bitmapData,new Point(param2 + this.xoffset,param3 + this.yoffset),255);
      }
      
      public function RenderAtRotScaledWithOffset(param1:BitmapData, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:ColorTransform = null, param7:Boolean = false, param8:Number = 0, param9:Number = 0) : void
      {
         mat.identity();
         mat.translate(this.xoffset,this.yoffset);
         mat.rotate(param5);
         mat.translate(-this.xoffset,-this.yoffset);
         mat.translate(param8,param9);
         mat.scale(param4,param4);
         mat.translate(-param8,-param9);
         mat.translate(param2 + this.xoffset * param4,param3 + this.yoffset * param4);
         if(this.bitmapData != null)
         {
            param1.draw(this.bitmapData,mat,param6,null,null,param7);
         }
      }
      
      public function RenderAtRotScaled(param1:BitmapData, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:ColorTransform = null, param7:Boolean = false) : void
      {
         mat.identity();
         mat.translate(this.xoffset,this.yoffset);
         mat.rotate(param5);
         mat.translate(-this.xoffset,-this.yoffset);
         mat.scale(param4,param4);
         mat.translate(param2 + this.xoffset * param4,param3 + this.yoffset * param4);
         if(this.bitmapData != null)
         {
            param1.draw(this.bitmapData,mat,param6,null,null,param7);
         }
      }
      
      public function RenderAtRotScaled_Xflip(param1:BitmapData, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:ColorTransform = null, param7:Boolean = false) : void
      {
         param5 = -param5;
         mat.identity();
         mat.translate(this.xoffset,this.yoffset);
         mat.rotate(param5);
         mat.translate(-this.xoffset,-this.yoffset);
         mat.scale(param4,param4);
         mat.translate(this.xoffset * param4,this.yoffset * param4);
         mat.scale(-1,1);
         mat.translate(param2,param3);
         if(this.bitmapData != null)
         {
            param1.draw(this.bitmapData,mat,param6,null,null,param7);
         }
      }
      
      public function RenderAtRotScaledAdditive(param1:BitmapData, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:ColorTransform = null, param7:Boolean = false) : void
      {
         mat.identity();
         mat.translate(this.xoffset,this.yoffset);
         mat.rotate(param5);
         mat.translate(-this.xoffset,-this.yoffset);
         mat.scale(param4,param4);
         mat.translate(param2 + this.xoffset * param4,param3 + this.yoffset * param4);
         if(this.bitmapData != null)
         {
            param1.draw(this.bitmapData,mat,null,BlendMode.ADD,null,param7);
         }
      }
      
      public function RenderAtRotScaled_SourceRect(param1:BitmapData, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:ColorTransform = null, param7:Boolean = false, param8:Rectangle = null, param9:int = 0, param10:int = 0) : void
      {
         mat.identity();
         mat.translate(this.xoffset,this.yoffset);
         mat.rotate(param5);
         mat.translate(-this.xoffset,-this.yoffset);
         mat.scale(param4,param4);
         mat.translate(param2 + (this.xoffset - param9) * param4,param3 + (this.yoffset - param10) * param4);
         param8.x = param2;
         param8.y = param3;
         if(this.bitmapData != null)
         {
            param1.draw(this.bitmapData,mat,param6,null,param8,param7);
         }
      }
   }
}

