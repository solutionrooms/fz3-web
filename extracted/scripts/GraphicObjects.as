package
{
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.Font;
   import flash.text.TextFormat;
   import flash.utils.getDefinitionByName;
   
   public class GraphicObjects
   {
      
      public static var gfx_font1:int;
      
      public static var gfx_fontblack:int;
      
      public static var gfx_font2:int;
      
      public static var gfx_font2black:int;
      
      internal static var graphicobjs:Vector.<DisplayObj>;
      
      internal static var nameList:Vector.<String>;
      
      internal static var nextID:int;
      
      internal static var loader:Loader;
      
      internal static var cb:Function;
      
      internal static var createZombie_count:int;
      
      public static var stringCharX:Number;
      
      public static var stringCharY:Number;
      
      public static var stringCharBitmapData:BitmapData;
      
      internal static var renderStringBD:BitmapData = null;
      
      internal static var renderStringRect:Rectangle = null;
      
      internal static var renderStringMatrix:Matrix = null;
      
      internal static var renderStringColorTransform:ColorTransform = null;
      
      public function GraphicObjects()
      {
         super();
      }
      
      public static function InitOnce(param1:Function) : void
      {
         cb = param1;
         graphicobjs = new Vector.<DisplayObj>();
         nameList = new Vector.<String>();
         nextID = 0;
         AddGraphics();
         cb();
      }
      
      internal static function AddGraphics() : void
      {
         gfx_font1 = AddFont(new Font20(),12,4294967295);
         gfx_fontblack = AddFont(new Font20(),12,0);
         gfx_font2 = AddFont(new Font20(),18,4294967295);
         gfx_font2black = AddFont(new Font20(),20,0);
         createZombie_count = 0;
      }
      
      public static function GetDisplayObjByIndex(param1:int) : DisplayObj
      {
         return graphicobjs[param1];
      }
      
      public static function GetDisplayObjByName(param1:String) : DisplayObj
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in nameList)
         {
            if(_loc3_ == param1)
            {
               return graphicobjs[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = Add(param1,0);
         if(_loc2_ != -1)
         {
            return graphicobjs[_loc2_];
         }
         return null;
      }
      
      public static function GetIndexByName(param1:String) : int
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in nameList)
         {
            if(_loc3_ == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return Add(param1,0);
      }
      
      public static function AddFont(param1:Font, param2:int, param3:uint) : int
      {
         var _loc4_:TextFormat = new TextFormat();
         _loc4_.font = param1.fontName;
         _loc4_.size = param2;
         _loc4_.color = param3;
         var _loc5_:* = nextID;
         ++nextID;
         var _loc6_:DisplayObj = new DisplayObj(null,0,0);
         _loc6_.CreateFont(_loc4_);
         nameList.push(_loc4_.font);
         graphicobjs.push(_loc6_);
         return _loc5_;
      }
      
      public static function Add1(param1:int, param2:DisplayObj, param3:String = "") : void
      {
         nameList.push(param3);
         graphicobjs.push(param2);
      }
      
      public static function Recreate(param1:String, param2:String, param3:int, param4:Function = null) : int
      {
         var _loc5_:int = GetIndexByName(param2);
         if(_loc5_ == -1)
         {
            return -1;
         }
         var _loc6_:Class = getDefinitionByName(param1) as Class;
         var _loc7_:MovieClip = new _loc6_() as MovieClip;
         if(param4 != null)
         {
            param4(_loc7_);
         }
         graphicobjs[_loc5_] = new DisplayObj(_loc7_,1,param3);
         return _loc5_;
      }
      
      public static function Create(param1:String, param2:String, param3:int, param4:Function = null) : int
      {
         var _loc5_:Class = getDefinitionByName(param1) as Class;
         var _loc6_:MovieClip = new _loc5_() as MovieClip;
         if(param4 != null)
         {
            param4(_loc6_);
         }
         var _loc7_:* = nextID;
         ++nextID;
         graphicobjs.push(new DisplayObj(_loc6_,1,param3));
         nameList.push(param2);
         return _loc7_;
      }
      
      public static function AddDobjEmptyBitmap(param1:String, param2:int, param3:int, param4:Boolean) : DisplayObj
      {
         var _loc5_:* = nextID;
         ++nextID;
         var _loc6_:DisplayObj = new DisplayObj(null,1,0);
         _loc6_.frames = new Vector.<DisplayObjFrame>();
         var _loc7_:DisplayObjFrame = new DisplayObjFrame();
         _loc7_.bitmapData = new BitmapData(param2,param3,param4,0);
         _loc7_.xoffset = 0;
         _loc7_.yoffset = 0;
         _loc7_.sourceRect = new Rectangle(0,0,param2,param3);
         _loc7_.point = new Point(0,0);
         _loc6_.frames.push(_loc7_);
         nameList.push(param1);
         graphicobjs.push(_loc6_);
         return _loc6_;
      }
      
      public static function Add(param1:String, param2:int, param3:String = null) : int
      {
         var _id:*;
         var classRef:Class;
         var mc:MovieClip = null;
         var mcName:String = param1;
         var flags:int = param2;
         var _instName:String = param3;
         if(_instName == null)
         {
            _instName = mcName;
         }
         _id = nextID;
         ++nextID;
         classRef = null;
         try
         {
            classRef = getDefinitionByName(mcName) as Class;
         }
         catch(e:Error)
         {
            classRef = null;
         }
         if(classRef != null)
         {
            mc = new classRef() as MovieClip;
            Add1(_id,new DisplayObj(mc,1,flags),_instName);
            mc = null;
            return _id;
         }
         Utils.traceerror("Graphic Objects - can\'t find obj: " + mcName);
         return -1;
      }
      
      public static function GetFrameIndexLabel(param1:int, param2:String) : int
      {
         var _loc4_:Object = null;
         var _loc3_:DisplayObj = graphicobjs[param1];
         for each(_loc4_ in _loc3_.labels)
         {
            if(_loc4_.labelName == param2)
            {
               return _loc4_.frameIndex;
            }
         }
         return 0;
      }
      
      public static function GetPixelAt(param1:int, param2:int, param3:int, param4:int) : uint
      {
         var _loc5_:BitmapData = graphicobjs[param1].frames[param2].bitmapData;
         return _loc5_.getPixel32(param3,param4);
      }
      
      public static function RenderNumberAt(param1:BitmapData, param2:int, param3:Number, param4:Number, param5:int) : *
      {
         var _loc8_:* = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:BitmapData = null;
         var _loc6_:Array = new Array();
         var _loc7_:int = param5;
         _loc8_ = 0;
         while(_loc8_ < 11)
         {
            _loc10_ = _loc7_ % 10;
            _loc6_.push(_loc10_);
            _loc7_ /= 10;
            _loc8_++;
         }
         var _loc9_:Boolean = false;
         _loc8_ = int(_loc6_.length - 1);
         while(_loc8_--)
         {
            _loc11_ = int(_loc6_[_loc8_]);
            if(_loc9_ == false && _loc11_ != 0)
            {
               _loc9_ = true;
            }
            if(_loc9_)
            {
               GetDisplayObjByIndex(param2).RenderAt(_loc11_ + 48,param1,param3,param4);
               _loc12_ = GetDisplayObjByIndex(param2).GetBitmapData(_loc11_ + 48);
               param3 += _loc12_.width;
            }
            _loc8_ >= 0;
         }
         return param3;
      }
      
      public static function InitRenderString() : *
      {
         if(renderStringBD != null)
         {
            return;
         }
         renderStringBD = new BitmapData(300,60,true,0);
         renderStringMatrix = new Matrix();
         renderStringColorTransform = new ColorTransform();
      }
      
      public static function RenderStringBD(param1:int, param2:String) : BitmapData
      {
         InitRenderString();
         renderStringRect = GetStringDimensions(param1,param2);
         renderStringBD.fillRect(new Rectangle(0,0,25,25),0);
         RenderStringAt(renderStringBD,param1,0,0,param2);
         return null;
      }
      
      public static function RenderStringBDAt(param1:BitmapData, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:Number = 1, param7:int = 0, param8:int = 0) : *
      {
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         if(param7 == 1)
         {
            _loc9_ -= renderStringRect.width / 2;
         }
         else if(param7 == 2)
         {
            _loc9_ -= renderStringRect.width;
         }
         if(param8 == 1)
         {
            _loc10_ -= renderStringRect.height / 2;
         }
         else if(param8 == 2)
         {
            _loc10_ -= renderStringRect.height;
         }
         var _loc11_:Number = param2 + _loc9_ * param4;
         var _loc12_:Number = param3 + _loc10_ * param4;
         if(param6 != 0 || param5 != 0 || param4 != 0)
         {
            renderStringMatrix.identity();
            if(param4 != 0)
            {
               renderStringMatrix.scale(param4,param4);
            }
            renderStringMatrix.translate(_loc11_,_loc12_);
            renderStringColorTransform.alphaMultiplier = 1;
            if(param6 != 0)
            {
               renderStringColorTransform.alphaMultiplier = param6;
               param1.draw(renderStringBD,renderStringMatrix,renderStringColorTransform);
            }
            else
            {
               param1.draw(renderStringBD,renderStringMatrix);
            }
         }
         else
         {
            param1.copyPixels(renderStringBD,renderStringRect,new Point(param2 + _loc9_,param3 + _loc10_),null,null,true);
         }
      }
      
      public static function GetStringDimensions(param1:int, param2:String) : Rectangle
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Rectangle = null;
         var _loc3_:Rectangle = new Rectangle(0,0,1,1);
         stringCharX = 0;
         stringCharY = 0;
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = int(param2.charCodeAt(_loc4_));
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            if(_loc5_ > 127)
            {
               _loc5_ = 127;
            }
            stringCharBitmapData = GetDisplayObjByIndex(param1).GetBitmapData(_loc5_);
            _loc6_ = stringCharBitmapData.rect.clone();
            _loc6_.x += stringCharX;
            _loc6_.y += stringCharY;
            _loc3_ = _loc3_.union(_loc6_);
            stringCharX += stringCharBitmapData.width - 3;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function RenderStringAt(param1:BitmapData, param2:int, param3:Number, param4:Number, param5:String, param6:Object = null, param7:int = 0) : *
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         stringCharX = param3;
         stringCharY = param4;
         _loc8_ = 0;
         while(_loc8_ < param5.length)
         {
            _loc9_ = int(param5.charCodeAt(_loc8_));
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            if(_loc9_ > 127)
            {
               _loc9_ = 127;
            }
            GetDisplayObjByIndex(param2 + 1).RenderAt(_loc9_,param1,stringCharX + 1,stringCharY + 1);
            GetDisplayObjByIndex(param2).RenderAt(_loc9_,param1,stringCharX,stringCharY);
            stringCharBitmapData = GetDisplayObjByIndex(param2).GetBitmapData(_loc9_);
            if(param6 != null)
            {
               param6();
            }
            else
            {
               stringCharX += stringCharBitmapData.width - 3;
               stringCharX += param7;
            }
            _loc8_++;
         }
      }
      
      public static function RenderCharCodeAt(param1:BitmapData, param2:int, param3:Number, param4:Number, param5:int) : *
      {
         var _loc6_:int = param5;
         GetDisplayObjByIndex(param2 + 1).RenderAt(_loc6_,param1,param3 + 1,param4 + 1);
         GetDisplayObjByIndex(param2).RenderAt(_loc6_,param1,param3,param4);
      }
      
      public static function GetStringOffsetTable(param1:int, param2:String, param3:int = 0) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc4_:Array = new Array();
         stringCharX = 0;
         stringCharY = 0;
         _loc5_ = 0;
         while(_loc5_ < param2.length)
         {
            _loc6_ = int(param2.charCodeAt(_loc5_));
            if(_loc6_ < 0)
            {
               _loc6_ = 0;
            }
            if(_loc6_ > 127)
            {
               _loc6_ = 127;
            }
            _loc7_ = new Object();
            _loc7_.x = stringCharX;
            _loc7_.y = stringCharY;
            _loc7_.a = _loc6_;
            _loc7_.s = param2.charAt(_loc5_);
            _loc4_.push(_loc7_);
            stringCharBitmapData = GetDisplayObjByIndex(param1).GetBitmapData(_loc6_);
            stringCharX += stringCharBitmapData.width - 3;
            stringCharX += param3;
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function GetStringWidth(param1:BitmapData, param2:int, param3:Number, param4:Number, param5:String, param6:Object = null, param7:int = 0) : int
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         stringCharX = param3;
         stringCharY = param4;
         var _loc8_:int = 0;
         _loc9_ = 0;
         while(_loc9_ < param5.length)
         {
            _loc10_ = int(param5.charCodeAt(_loc9_));
            if(_loc10_ < 0)
            {
               _loc10_ = 0;
            }
            if(_loc10_ > 127)
            {
               _loc10_ = 127;
            }
            stringCharBitmapData = GetDisplayObjByIndex(param2).GetBitmapData(_loc10_);
            if(param6 == null)
            {
               _loc8_ += stringCharBitmapData.width - 3;
               _loc8_ = _loc8_ + param7;
            }
            _loc9_++;
         }
         return _loc8_;
      }
      
      internal function InitFont(param1:Font, param2:int, param3:uint) : void
      {
         var _loc4_:TextFormat = null;
         _loc4_ = new TextFormat();
         _loc4_.font = param1.fontName;
         _loc4_.size = 12;
         _loc4_.color = 4294967295;
      }
   }
}

