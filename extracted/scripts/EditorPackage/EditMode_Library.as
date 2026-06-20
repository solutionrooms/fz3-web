package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EditMode_Library extends EditMode_Base
   {
      
      internal var pickerRectangle:Rectangle = new Rectangle(0,0,Defs.displayarea_w,Defs.displayarea_h);
      
      internal var boxNumW:Number = 5;
      
      internal var boxNumH:Number = 4;
      
      internal var boxSizeW:Number = Defs.displayarea_w / this.boxNumW;
      
      internal var boxSizeH:Number = Defs.displayarea_h / this.boxNumH;
      
      internal var library_page:int = 0;
      
      public var library_hoverPieceName:String = "";
      
      internal var libraryFilter:String = "";
      
      internal var libraryFilterIndex:int = 0;
      
      public var libraryFilters:Array;
      
      internal var librarySizeIndex:int;
      
      internal var numLibrarySizes:int;
      
      internal var librarySizes:Array;
      
      internal var libraryPieces:Array;
      
      public function EditMode_Library()
      {
         super();
      }
      
      override public function EnterMode() : void
      {
         PhysEditor.CursorText_Show();
         PhysEditor.CursorText_Set("");
      }
      
      override public function InitOnce() : void
      {
         this.InitLibraryFilter();
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         this.Library_PickPiece();
         PhysEditor.SetEditMode(PhysEditor.editMode_Placement);
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
         this.Library_GetHoverPieceName();
      }
      
      override public function OnMouseWheel(param1:int) : void
      {
         if(param1 > 0)
         {
            ++this.library_page;
            if(this.library_page >= this.GetNumLibraryPages())
            {
               this.library_page = 0;
            }
         }
         if(param1 < 0)
         {
            --this.library_page;
            if(this.library_page < 0)
            {
               this.library_page = this.GetNumLibraryPages() - 1;
            }
         }
      }
      
      override public function Update() : void
      {
         if(KeyReader.Pressed(KeyReader.KEY_DOWN))
         {
            ++this.library_page;
            if(this.library_page >= this.GetNumLibraryPages())
            {
               this.library_page = 0;
            }
         }
         if(KeyReader.Pressed(KeyReader.KEY_UP))
         {
            --this.library_page;
            if(this.library_page < 0)
            {
               this.library_page = this.GetNumLibraryPages() - 1;
            }
         }
         if(KeyReader.Pressed(KeyReader.KEY_1))
         {
            this.NextLibraryFilter();
         }
         if(KeyReader.Pressed(KeyReader.KEY_2))
         {
            this.NextLibrarySize();
         }
      }
      
      override public function Render(param1:BitmapData) : void
      {
         var _loc2_:String = null;
         var _loc12_:PhysObj = null;
         super.Render(param1);
         param1.fillRect(Defs.screenRect,4284498112);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.pickerRectangle.x;
         while(_loc3_ <= this.pickerRectangle.right)
         {
            PhysEditor.RenderLine(_loc3_,this.pickerRectangle.y,_loc3_,this.pickerRectangle.bottom,4282433600);
            _loc3_ += this.boxSizeW;
         }
         _loc3_ = this.pickerRectangle.y;
         while(_loc3_ <= this.pickerRectangle.bottom)
         {
            PhysEditor.RenderLine(this.pickerRectangle.x,_loc3_,this.pickerRectangle.right,_loc3_,4282433600);
            _loc3_ += this.boxSizeH;
         }
         var _loc5_:int = this.boxNumW * this.boxNumH;
         var _loc6_:int = this.library_page * _loc5_;
         var _loc7_:int = _loc6_ + (_loc5_ - 1);
         _loc3_ = this.pickerRectangle.left;
         _loc4_ = this.pickerRectangle.top;
         var _loc8_:int = Game.objectDefs.GetNum();
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         for each(_loc12_ in this.libraryPieces)
         {
            if(_loc9_ >= _loc6_ && _loc9_ <= _loc7_)
            {
               PhysObj.RenderAt(_loc12_,_loc3_ + this.boxSizeW / 2,_loc4_ + this.boxSizeH / 2,0,1,param1,PhysEditor.linesScreen.graphics,true,new Rectangle(_loc3_ + 8,_loc4_ + 8,this.boxSizeW - 16,this.boxSizeH - 16));
               _loc3_ += this.boxSizeW;
               if(++_loc10_ >= this.boxNumW)
               {
                  _loc3_ = 0;
                  _loc4_ += this.boxSizeH;
                  _loc10_ = 0;
               }
            }
            _loc9_++;
         }
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc12_:PhysObj = null;
         _loc3_ = "1: Filter [" + this.libraryFilter + "] " + int(this.libraryFilterIndex + 1) + "/" + this.libraryFilters.length;
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "2: Scale " + int(this.librarySizeIndex + 1) + "/" + this.numLibrarySizes;
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         var _loc5_:int = this.boxNumW * this.boxNumH;
         var _loc6_:int = this.library_page * _loc5_;
         var _loc7_:int = _loc6_ + (_loc5_ - 1);
         param1 = this.pickerRectangle.left;
         param2 = this.pickerRectangle.top;
         var _loc8_:int = Game.objectDefs.GetNum();
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         for each(_loc12_ in this.libraryPieces)
         {
            if(_loc9_ >= _loc6_ && _loc9_ <= _loc7_)
            {
               _loc3_ = _loc12_.name;
               PhysEditor.AddInfoText("a",param1 + 8,param2 + this.boxSizeH - 16,_loc3_);
               param1 += this.boxSizeW;
               if(++_loc10_ >= this.boxNumW)
               {
                  param1 = 0;
                  param2 += this.boxSizeH;
                  _loc10_ = 0;
               }
            }
            _loc9_++;
         }
         return _loc4_;
      }
      
      internal function Library_PickPiece() : *
      {
         var _loc1_:int = MouseControl.x;
         var _loc2_:int = MouseControl.y;
         _loc1_ -= this.pickerRectangle.left;
         _loc2_ -= this.pickerRectangle.top;
         var _loc3_:int = _loc1_ / this.boxSizeW;
         var _loc4_:int = _loc2_ / this.boxSizeH;
         var _loc5_:int = _loc3_ + _loc4_ * this.boxNumW;
         var _loc6_:int = this.boxNumW * this.boxNumH;
         _loc5_ += this.library_page * _loc6_;
         var _loc7_:int = this.libraryPieces.length - 1;
         if(_loc5_ > _loc7_)
         {
            _loc5_ = _loc7_;
         }
         var _loc8_:PhysObj = this.libraryPieces[_loc5_];
         PhysEditor.ClearCurrentPieces();
         PhysEditor.AddCurrentPiece(Game.objectDefs.FindIndexByName(_loc8_.name),0,0,0);
      }
      
      internal function Library_GetHoverPieceName() : *
      {
         this.library_hoverPieceName = "";
         var _loc1_:int = MouseControl.x;
         var _loc2_:int = MouseControl.y;
         _loc1_ -= this.pickerRectangle.left;
         _loc2_ -= this.pickerRectangle.top;
         var _loc3_:int = _loc1_ / this.boxSizeW;
         var _loc4_:int = _loc2_ / this.boxSizeH;
         var _loc5_:int = _loc3_ + _loc4_ * this.boxNumW;
         var _loc6_:int = this.boxNumW * this.boxNumH;
         _loc5_ += this.library_page * _loc6_;
         var _loc7_:int = this.libraryPieces.length - 1;
         if(_loc5_ > _loc7_)
         {
            _loc5_ = _loc7_;
         }
         var _loc8_:PhysObj = this.libraryPieces[_loc5_];
         this.library_hoverPieceName = _loc8_.name;
      }
      
      internal function DoesLibraryFilterListContain(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.libraryFilters)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      internal function InitLibraryFilter() : *
      {
         var _loc1_:PhysObj = null;
         var _loc2_:String = null;
         this.pickerRectangle = new Rectangle(0,60,Defs.displayarea_w,Defs.displayarea_h - 80);
         this.libraryFilterIndex = -1;
         this.libraryFilter = "";
         this.libraryFilters = new Array();
         this.libraryFilters.push("");
         this.librarySizeIndex = -1;
         this.librarySizes = new Array();
         this.librarySizes.push(new Point(4,3),new Point(5,4),new Point(7,5),new Point(9,7),new Point(12,10));
         this.numLibrarySizes = this.librarySizes.length;
         for each(_loc1_ in Game.objectDefs.list)
         {
            if(_loc1_.displayInLibrary)
            {
               if(this.DoesLibraryFilterListContain(_loc1_.libraryClass) == false)
               {
                  this.libraryFilters.push(_loc1_.libraryClass);
               }
            }
         }
         for each(_loc2_ in this.libraryFilters)
         {
            Utils.trace("filter: " + _loc2_);
         }
         this.NextLibraryFilter();
         this.NextLibrarySize();
      }
      
      internal function TestLibraryFilter(param1:String) : Boolean
      {
         if(this.libraryFilter == "")
         {
            return true;
         }
         if(this.libraryFilter == param1)
         {
            return true;
         }
         return false;
      }
      
      internal function NextLibrarySize() : *
      {
         ++this.librarySizeIndex;
         if(this.librarySizeIndex >= this.numLibrarySizes)
         {
            this.librarySizeIndex = 0;
         }
         var _loc1_:Point = this.librarySizes[this.librarySizeIndex];
         this.boxNumW = _loc1_.x;
         this.boxNumH = _loc1_.y;
         this.boxSizeW = this.pickerRectangle.width / this.boxNumW;
         this.boxSizeH = this.pickerRectangle.height / this.boxNumH;
         if(this.library_page > this.GetNumLibraryPages())
         {
            this.library_page = this.GetNumLibraryPages() - 1;
         }
         this.GetLibraryPieces();
      }
      
      internal function NextLibraryFilter() : *
      {
         ++this.libraryFilterIndex;
         if(this.libraryFilterIndex >= this.libraryFilters.length)
         {
            this.libraryFilterIndex = 0;
         }
         this.libraryFilter = this.libraryFilters[this.libraryFilterIndex];
         this.library_page = 0;
         this.GetLibraryPieces();
      }
      
      internal function GetLibraryPieces() : *
      {
         var _loc1_:PhysObj = null;
         this.libraryPieces = new Array();
         for each(_loc1_ in Game.objectDefs.list)
         {
            if(_loc1_.displayInLibrary && this.TestLibraryFilter(_loc1_.libraryClass))
            {
               this.libraryPieces.push(_loc1_);
            }
         }
      }
      
      internal function CountLibraryPieces() : int
      {
         var _loc2_:PhysObj = null;
         var _loc1_:int = 0;
         for each(_loc2_ in Game.objectDefs.list)
         {
            if(_loc2_.displayInLibrary && this.TestLibraryFilter(_loc2_.libraryClass))
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      internal function GetNumLibraryPages() : int
      {
         var _loc1_:int = this.boxNumW * this.boxNumH;
         var _loc2_:int = this.CountLibraryPieces();
         var _loc3_:int = _loc2_ / _loc1_;
         var _loc4_:int = _loc2_ % _loc1_;
         if(_loc4_ != 0)
         {
            _loc3_++;
         }
         return _loc3_;
      }
   }
}

