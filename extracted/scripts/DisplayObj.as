package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class DisplayObj
   {
      
      internal var frames:Vector.<DisplayObjFrame>;
      
      public var frame:int;
      
      internal var flags:int;
      
      internal var labels:Vector.<Object>;
      
      internal var name:String;
      
      public var origMC:MovieClip;
      
      internal var mat:Matrix = new Matrix();
      
      public function DisplayObj(param1:MovieClip, param2:Number, param3:int)
      {
         super();
         this.labels = new Vector.<Object>();
         this.flags = param3;
         this.frame = 0;
         if(param1 != null)
         {
            this.CreateBitmapsFromMovieClip(param1,this.flags);
            this.name = param1.name;
         }
         this.origMC = param1;
      }
      
      public function CreateFont(param1:TextFormat) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:Bitmap = null;
         var _loc9_:BitmapData = null;
         var _loc11_:TextField = null;
         var _loc12_:* = undefined;
         this.frames = new Vector.<DisplayObjFrame>();
         var _loc6_:Matrix = new Matrix();
         var _loc10_:Array = this.CreateAsciiStringTable();
         _loc2_ = 0;
         while(_loc2_ < _loc10_.length)
         {
            _loc11_ = new TextField();
            _loc11_.textColor = 4294967295;
            _loc11_.selectable = false;
            _loc11_.embedFonts = true;
            _loc11_.autoSize = TextFieldAutoSize.LEFT;
            _loc11_.x = 0;
            _loc11_.y = 0;
            _loc11_.text = _loc10_[_loc2_];
            _loc11_.setTextFormat(param1);
            _loc12_ = new DisplayObjFrame();
            _loc7_ = _loc11_.getBounds(null);
            _loc6_.identity();
            _loc6_.translate(-_loc7_.x,-_loc7_.y);
            _loc12_.xoffset = 0;
            _loc12_.yoffset = 0;
            _loc9_ = new BitmapData(_loc7_.width,_loc7_.height,true,0);
            _loc9_.draw(_loc11_,_loc6_,null,null,null,true);
            _loc12_.bitmapData = _loc9_;
            _loc12_.sourceRect = new Rectangle(0,0,_loc9_.width,_loc9_.height);
            _loc12_.point = new Point(0,0);
            this.frames.push(_loc12_);
            _loc2_++;
         }
      }
      
      public function CreateBitmapsFromMovieClip(param1:MovieClip, param2:int, param3:Function = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Rectangle = null;
         var _loc10_:Bitmap = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Bitmap = null;
         var _loc13_:BitmapData = null;
         var _loc14_:DisplayObjFrame = null;
         var _loc15_:Object = null;
         this.frames = new Vector.<DisplayObjFrame>();
         var _loc8_:Matrix = new Matrix();
         param1.gotoAndStop(1);
         _loc4_ = 0;
         while(_loc4_ < param1.totalFrames)
         {
            if(param3 != null)
            {
               param3(param1);
            }
            if(param1.currentFrameLabel != null)
            {
               _loc15_ = new Object();
               _loc15_.labelName = param1.currentFrameLabel;
               _loc15_.frameIndex = _loc4_;
               this.labels.push(_loc15_);
            }
            _loc14_ = new DisplayObjFrame();
            _loc9_ = param1.getRect(null);
            _loc9_.x = Math.floor(_loc9_.x);
            _loc9_.y = Math.floor(_loc9_.y);
            _loc9_.width = Math.ceil(_loc9_.width);
            _loc9_.height = Math.ceil(_loc9_.height);
            _loc6_ = _loc9_.left;
            _loc7_ = _loc9_.top;
            _loc8_.identity();
            _loc8_.translate(-_loc6_,-_loc7_);
            _loc14_.xoffset = Number(_loc6_);
            _loc14_.yoffset = Number(_loc7_);
            if(param1.width != 0 && param1.height != 0)
            {
               _loc11_ = new BitmapData(_loc9_.width,_loc9_.height,true,0);
               _loc11_.draw(param1,_loc8_);
               _loc14_.bitmapData = _loc11_;
               _loc14_.sourceRect = new Rectangle(0,0,_loc11_.width,_loc11_.height);
            }
            else
            {
               _loc14_.bitmapData = null;
               _loc14_.sourceRect = new Rectangle(0,0,1,1);
            }
            _loc14_.point = new Point(0,0);
            this.frames.push(_loc14_);
            param1.nextFrame();
            _loc4_++;
         }
      }
      
      public function DisposeOf() : *
      {
         var _loc1_:DisplayObjFrame = null;
         for each(_loc1_ in this.frames)
         {
            _loc1_.Remove();
         }
         this.origMC = null;
      }
      
      public function CreateBlankBitmapsFromMovieClip(param1:MovieClip, param2:int, param3:Function = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Rectangle = null;
         var _loc10_:Bitmap = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Bitmap = null;
         var _loc13_:BitmapData = null;
         var _loc14_:DisplayObjFrame = null;
         var _loc15_:Object = null;
         this.frames = new Vector.<DisplayObjFrame>();
         var _loc8_:Matrix = new Matrix();
         param1.gotoAndStop(1);
         _loc4_ = 0;
         while(_loc4_ < param1.totalFrames)
         {
            if(param3 != null)
            {
               param3(param1);
            }
            if(param1.currentFrameLabel != null)
            {
               _loc15_ = new Object();
               _loc15_.labelName = param1.currentFrameLabel;
               _loc15_.frameIndex = _loc4_;
               this.labels.push(_loc15_);
            }
            _loc14_ = new DisplayObjFrame();
            _loc9_ = param1.getRect(null);
            _loc9_.x = Math.floor(_loc9_.x);
            _loc9_.y = Math.floor(_loc9_.y);
            _loc9_.width = Math.ceil(_loc9_.width);
            _loc9_.height = Math.ceil(_loc9_.height);
            _loc6_ = _loc9_.left;
            _loc7_ = _loc9_.top;
            _loc8_.identity();
            _loc8_.translate(-_loc6_,-_loc7_);
            _loc14_.xoffset = Number(_loc6_);
            _loc14_.yoffset = Number(_loc7_);
            if(param1.width != 0 && param1.height != 0)
            {
               _loc14_.sourceRect = new Rectangle(0,0,1,1);
               _loc14_.bitmapData = null;
            }
            else
            {
               _loc14_.bitmapData = null;
               _loc14_.sourceRect = new Rectangle(0,0,1,1);
            }
            _loc14_.point = new Point(0,0);
            this.frames.push(_loc14_);
            param1.nextFrame();
            _loc4_++;
         }
      }
      
      public function CreateSingleBitmapdataFrame(param1:int, param2:Function = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Rectangle = null;
         var _loc9_:Bitmap = null;
         var _loc10_:BitmapData = null;
         var _loc11_:Bitmap = null;
         var _loc12_:BitmapData = null;
         var _loc7_:Matrix = new Matrix();
         this.origMC.gotoAndStop(param1 + 1);
         if(param2 != null)
         {
            param2(this.origMC);
         }
         var _loc13_:DisplayObjFrame = this.frames[param1];
         _loc8_ = this.origMC.getRect(null);
         _loc8_.x = Math.floor(_loc8_.x);
         _loc8_.y = Math.floor(_loc8_.y);
         _loc8_.width = Math.ceil(_loc8_.width);
         _loc8_.height = Math.ceil(_loc8_.height);
         _loc5_ = _loc8_.left;
         _loc6_ = _loc8_.top;
         _loc7_.identity();
         _loc7_.translate(-_loc5_,-_loc6_);
         _loc13_.xoffset = Number(_loc5_);
         _loc13_.yoffset = Number(_loc6_);
         if(this.origMC.width != 0 && this.origMC.height != 0)
         {
            _loc10_ = new BitmapData(_loc8_.width,_loc8_.height,true,0);
            _loc10_.draw(this.origMC,_loc7_);
            _loc13_.bitmapData = _loc10_;
            _loc13_.sourceRect = new Rectangle(0,0,_loc10_.width,_loc10_.height);
         }
         else
         {
            _loc13_.bitmapData = null;
            _loc13_.sourceRect = new Rectangle(0,0,1,1);
         }
         _loc13_.point = new Point(0,0);
      }
      
      public function GetBitmapData(param1:int) : BitmapData
      {
         var _loc2_:DisplayObjFrame = this.frames[param1];
         return _loc2_.bitmapData;
      }
      
      public function GetWidth(param1:int) : int
      {
         var _loc2_:DisplayObjFrame = this.frames[param1];
         return _loc2_.bitmapData.width;
      }
      
      public function GetHeight(param1:int) : int
      {
         var _loc2_:DisplayObjFrame = this.frames[param1];
         return _loc2_.bitmapData.height;
      }
      
      public function GetNumFrames() : int
      {
         return this.frames.length;
      }
      
      public function GetLabelAtThisFrame(param1:int) : String
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.labels)
         {
            if(_loc2_.frameIndex == param1)
            {
               return _loc2_.labelName;
            }
         }
         return "";
      }
      
      public function GetFrameIndexLabel(param1:String) : int
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.labels)
         {
            if(_loc2_.labelName == param1)
            {
               return _loc2_.frameIndex;
            }
         }
         Utils.trace("Error finding label " + param1 + " in dobj " + this.name);
         return 0;
      }
      
      public function DoesFrameIndexLabelExist(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.labels)
         {
            if(_loc2_.labelName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function RenderAtRotScaled_Vector(param1:int, param2:BitmapData, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:ColorTransform = null, param8:Boolean = false, param9:Boolean = false) : *
      {
         this.origMC.gotoAndStop(param1 + 1);
         this.mat.identity();
         if(param9)
         {
            this.mat.scale(-1,1);
         }
         this.mat.rotate(param6);
         this.mat.scale(param5,param5);
         this.mat.translate(param3,param4);
         param2.draw(this.origMC,this.mat,null,null,null,param8);
      }
      
      public function RenderAtRotScaled(param1:int, param2:BitmapData, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:ColorTransform = null, param8:Boolean = false) : *
      {
         var _loc9_:DisplayObjFrame = this.frames[param1];
         _loc9_.RenderAtRotScaled(param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function RenderAtRotScaled_Xflip(param1:int, param2:BitmapData, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:ColorTransform = null, param8:Boolean = false) : *
      {
         var _loc9_:DisplayObjFrame = this.frames[param1];
         _loc9_.RenderAtRotScaled_Xflip(param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function RenderAtRotScaledWithOffset(param1:int, param2:BitmapData, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:ColorTransform = null, param8:Boolean = false, param9:Number = 0, param10:Number = 0) : *
      {
         var _loc11_:DisplayObjFrame = this.frames[param1];
         _loc11_.RenderAtRotScaledWithOffset(param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public function RenderAtRotScaledAdditive(param1:int, param2:BitmapData, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:ColorTransform = null, param8:Boolean = false) : *
      {
         var _loc9_:DisplayObjFrame = this.frames[param1];
         _loc9_.RenderAtRotScaledAdditive(param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function RenderAt(param1:int, param2:BitmapData, param3:Number, param4:Number) : *
      {
         var _loc5_:DisplayObjFrame = this.frames[param1];
         _loc5_.RenderAt(param2,param3,param4);
      }
      
      public function RenderAtXFlip(param1:int, param2:BitmapData, param3:Number, param4:Number) : *
      {
         var _loc5_:DisplayObjFrame = this.frames[param1];
         _loc5_.RenderAtXFlip(param2,param3,param4);
      }
      
      public function HitTestRotScaled(param1:int, param2:BitmapData, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:ColorTransform = null, param8:Boolean = false) : Boolean
      {
         var _loc9_:DisplayObjFrame = this.frames[param1];
         return _loc9_.HitTestRotScaled(param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function GetMaxFrames() : int
      {
         return this.frames.length;
      }
      
      public function SetFrame(param1:int) : *
      {
         this.frame = param1;
         if(this.frame < 0)
         {
            this.frame = 0;
         }
         if(this.frame >= this.frames.length)
         {
            this.frame = this.frames.length - 1;
         }
      }
      
      internal function CreateAsciiStringTable() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push("");
         _loc1_.push(" ");
         _loc1_.push("!");
         _loc1_.push("\'");
         _loc1_.push("#");
         _loc1_.push("$");
         _loc1_.push("%");
         _loc1_.push("&");
         _loc1_.push("\'");
         _loc1_.push("(");
         _loc1_.push(")");
         _loc1_.push("*");
         _loc1_.push("+");
         _loc1_.push(",");
         _loc1_.push("-");
         _loc1_.push(".");
         _loc1_.push("/");
         _loc1_.push("0");
         _loc1_.push("1");
         _loc1_.push("2");
         _loc1_.push("3");
         _loc1_.push("4");
         _loc1_.push("5");
         _loc1_.push("6");
         _loc1_.push("7");
         _loc1_.push("8");
         _loc1_.push("9");
         _loc1_.push(":");
         _loc1_.push(";");
         _loc1_.push("<");
         _loc1_.push("=");
         _loc1_.push(">");
         _loc1_.push("?");
         _loc1_.push("@");
         _loc1_.push("A");
         _loc1_.push("B");
         _loc1_.push("C");
         _loc1_.push("D");
         _loc1_.push("E");
         _loc1_.push("F");
         _loc1_.push("G");
         _loc1_.push("H");
         _loc1_.push("I");
         _loc1_.push("J");
         _loc1_.push("K");
         _loc1_.push("L");
         _loc1_.push("M");
         _loc1_.push("N");
         _loc1_.push("O");
         _loc1_.push("P");
         _loc1_.push("Q");
         _loc1_.push("R");
         _loc1_.push("S");
         _loc1_.push("T");
         _loc1_.push("U");
         _loc1_.push("V");
         _loc1_.push("W");
         _loc1_.push("X");
         _loc1_.push("Y");
         _loc1_.push("Z");
         _loc1_.push("[");
         _loc1_.push("\\");
         _loc1_.push("]");
         _loc1_.push("^");
         _loc1_.push("_");
         _loc1_.push("\'");
         _loc1_.push("a");
         _loc1_.push("b");
         _loc1_.push("c");
         _loc1_.push("d");
         _loc1_.push("e");
         _loc1_.push("f");
         _loc1_.push("g");
         _loc1_.push("h");
         _loc1_.push("i");
         _loc1_.push("j");
         _loc1_.push("k");
         _loc1_.push("l");
         _loc1_.push("m");
         _loc1_.push("n");
         _loc1_.push("o");
         _loc1_.push("p");
         _loc1_.push("q");
         _loc1_.push("r");
         _loc1_.push("s");
         _loc1_.push("t");
         _loc1_.push("u");
         _loc1_.push("v");
         _loc1_.push("w");
         _loc1_.push("x");
         _loc1_.push("y");
         _loc1_.push("z");
         _loc1_.push("{");
         _loc1_.push("|");
         _loc1_.push("}");
         _loc1_.push("~");
         return _loc1_;
      }
   }
}

