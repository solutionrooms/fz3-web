package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EditMode_Map extends EditMode_Base
   {
      
      internal var mapper_transparency:int = 5;
      
      internal var mapper_currentCell:int = 1;
      
      internal var mapper_brushType:int = 0;
      
      internal var brushes:Array;
      
      internal var mapCols:Array;
      
      internal var mapColNames:Array;
      
      internal var fillList:Array;
      
      internal var fillList1:Array;
      
      internal var fillOrigCell:int;
      
      public function EditMode_Map()
      {
         super();
      }
      
      override public function InitOnce() : void
      {
         var _loc1_:Array = null;
         this.mapCols = new Array();
         this.mapColNames = new Array();
         this.mapCols.push(0);
         this.mapColNames.push("blank");
         this.mapCols.push(16776960);
         this.mapColNames.push("rough01");
         this.mapCols.push(16711935);
         this.mapColNames.push("water");
         this.mapCols.push(65535);
         this.mapColNames.push("cliff");
         this.mapCols.push(255);
         this.mapColNames.push("undefined");
         this.mapCols.push(16776960);
         this.mapColNames.push("undefined");
         this.mapCols.push(16711935);
         this.mapColNames.push("undefined");
         this.mapCols.push(16777215);
         this.mapColNames.push("undefined");
         this.mapCols.push(16711680);
         this.mapColNames.push("undefined");
         this.brushes = new Array();
         _loc1_ = new Array();
         _loc1_.push(new Point(0,0));
         this.brushes.push(_loc1_);
         _loc1_ = new Array();
         _loc1_.push(new Point(0,0));
         _loc1_.push(new Point(1,0));
         _loc1_.push(new Point(0,1));
         _loc1_.push(new Point(1,1));
         this.brushes.push(_loc1_);
         _loc1_ = new Array();
         _loc1_.push(new Point(0,0));
         _loc1_.push(new Point(-1,0));
         _loc1_.push(new Point(1,0));
         _loc1_.push(new Point(0,1));
         _loc1_.push(new Point(0,-1));
         this.brushes.push(_loc1_);
         _loc1_ = new Array();
         _loc1_.push(new Point(-1,0));
         _loc1_.push(new Point(0,0));
         _loc1_.push(new Point(1,0));
         _loc1_.push(new Point(-1,1));
         _loc1_.push(new Point(0,1));
         _loc1_.push(new Point(1,1));
         _loc1_.push(new Point(-1,-1));
         _loc1_.push(new Point(0,-1));
         _loc1_.push(new Point(1,-1));
         this.brushes.push(_loc1_);
         this.mapper_currentCell = 1;
         this.mapper_brushType = 0;
         this.mapper_transparency = 2;
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         super.OnMouseDown(param1);
         this.Mapper_PlotCell(this.mapper_currentCell);
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseWheel(param1:int) : void
      {
         if(param1 > 0)
         {
            this.Mapper_IncCurrentCell();
         }
         if(param1 < 0)
         {
            this.Mapper_DecCurrentCell();
         }
      }
      
      override public function Update() : void
      {
         super.Update();
         if(KeyReader.Down(KeyReader.KEY_1) == true)
         {
            this.Mapper_PlotCell(0);
         }
         if(KeyReader.Pressed(KeyReader.KEY_2) == true)
         {
            this.Mapper_DecCurrentCell();
         }
         if(KeyReader.Pressed(KeyReader.KEY_3) == true)
         {
            this.Mapper_IncCurrentCell();
         }
         if(KeyReader.Pressed(KeyReader.KEY_4) == true)
         {
            this.Mapper_Fill(this.mapper_currentCell);
         }
         if(KeyReader.Pressed(KeyReader.KEY_5) == true)
         {
            this.Mapper_CycleBrush();
         }
         if(KeyReader.Pressed(KeyReader.KEY_6) == true)
         {
            this.Mapper_CycleTransparency();
         }
      }
      
      override public function Render(param1:BitmapData) : void
      {
         super.Render(param1);
         param1.fillRect(Defs.screenRect,4282668390);
         PhysEditor.RenderBackground(param1);
         PhysEditor.Editor_RenderObjects();
         PhysEditor.Editor_RenderMiniMap();
         PhysEditor.Editor_RenderLines();
         this.Mapper_RenderMap();
         this.Mapper_RenderCursor();
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         var _loc3_:String = null;
         var _loc4_:Level = GetCurrentLevel();
         _loc3_ = "ScrollPos: " + Math.round(PhysEditor.scrollX) + " " + Math.round(PhysEditor.scrollY);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "CursorPos: " + int(MouseControl.x + PhysEditor.scrollX) + " " + int(MouseControl.y + PhysEditor.scrollY);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "Offset / Size: " + _loc4_.mapMinX + "," + _loc4_.mapMinY + "   " + (_loc4_.mapMaxX - _loc4_.mapMinX + 1) + "," + (_loc4_.mapMaxY - _loc4_.mapMinY + 1);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "1: Erase cell(s)";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "2/3: Current Piece: " + int(this.mapper_currentCell + 1) + " / " + this.mapCols.length + "  (" + this.mapColNames[this.mapper_currentCell] + ")   ";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "4: Fill ";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "5: Brush: " + int(this.mapper_brushType + 1) + " / " + this.brushes.length;
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "6: Display : " + this.mapper_transparency + " / 5";
         return int(param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_));
      }
      
      internal function mapper_ExpandMap(param1:int, param2:int) : *
      {
         var _loc3_:Array = null;
         var _loc11_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc4_:Level = GetCurrentLevel();
         var _loc5_:int = _loc4_.mapMinX;
         var _loc6_:int = _loc4_.mapMaxX;
         var _loc7_:int = _loc4_.mapMinY;
         var _loc8_:int = _loc4_.mapMaxY;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param1 < _loc4_.mapMinX)
         {
            _loc5_ = param1;
         }
         if(param2 < _loc4_.mapMinY)
         {
            _loc7_ = param2;
         }
         if(param1 > _loc4_.mapMaxX)
         {
            _loc6_ = param1;
         }
         if(param2 > _loc4_.mapMaxY)
         {
            _loc8_ = param2;
         }
         _loc9_ = _loc5_ - _loc4_.mapMinX;
         _loc10_ = _loc7_ - _loc4_.mapMinY;
         var _loc12_:int = _loc6_ - _loc5_ + 1;
         var _loc13_:int = _loc8_ - _loc7_ + 1;
         var _loc14_:int = _loc4_.mapMaxX - _loc4_.mapMinX + 1;
         var _loc15_:int = _loc4_.mapMaxY - _loc4_.mapMinY + 1;
         _loc3_ = new Array(_loc12_ * _loc13_);
         _loc11_ = 0;
         while(_loc11_ < _loc12_ * _loc13_)
         {
            _loc3_[_loc11_] = 0;
            _loc11_++;
         }
         _loc16_ = 0;
         while(_loc16_ < _loc15_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc14_)
            {
               _loc18_ = int(_loc4_.map[_loc17_ + _loc16_ * _loc14_]);
               _loc3_[_loc17_ - _loc9_ + (_loc16_ - _loc10_) * _loc12_] = _loc18_;
               _loc17_++;
            }
            _loc16_++;
         }
         _loc4_.mapMinX = _loc5_;
         _loc4_.mapMaxX = _loc6_;
         _loc4_.mapMinY = _loc7_;
         _loc4_.mapMaxY = _loc8_;
         _loc4_.map = _loc3_;
      }
      
      internal function Mapper_IncCurrentCell() : *
      {
         ++this.mapper_currentCell;
         if(this.mapper_currentCell >= this.mapCols.length)
         {
            this.mapper_currentCell = 0;
         }
      }
      
      internal function Mapper_CycleTransparency() : *
      {
         ++this.mapper_transparency;
         if(this.mapper_transparency >= 6)
         {
            this.mapper_transparency = 0;
         }
      }
      
      internal function Mapper_CycleBrush() : *
      {
         ++this.mapper_brushType;
         if(this.mapper_brushType >= this.brushes.length)
         {
            this.mapper_brushType = 0;
         }
      }
      
      internal function Mapper_DecCurrentCell() : *
      {
         --this.mapper_currentCell;
         if(this.mapper_currentCell < 0)
         {
            this.mapper_currentCell = this.mapCols.length - 1;
         }
      }
      
      internal function Mapper_Fill(param1:int) : *
      {
         var _loc6_:Object = null;
         var _loc2_:Level = GetCurrentLevel();
         var _loc3_:int = MouseControl.x;
         var _loc4_:int = MouseControl.y;
         _loc3_ += PhysEditor.scrollX;
         _loc4_ += PhysEditor.scrollY;
         _loc3_ /= _loc2_.mapCellW;
         _loc4_ /= _loc2_.mapCellH;
         this.fillList = new Array();
         this.fillOrigCell = this.Mapper_GetCell(_loc3_,_loc4_);
         this.Mapper_PutCell(_loc3_,_loc4_,param1);
         this.Mapper_PutFillCell(_loc3_ - 1,_loc4_,param1,this.fillList);
         this.Mapper_PutFillCell(_loc3_ + 1,_loc4_,param1,this.fillList);
         this.Mapper_PutFillCell(_loc3_,_loc4_ - 1,param1,this.fillList);
         this.Mapper_PutFillCell(_loc3_,_loc4_ + 1,param1,this.fillList);
         var _loc5_:Boolean = false;
         do
         {
            this.fillList1 = new Array();
            for each(_loc6_ in this.fillList)
            {
               this.Mapper_PutFillCell(_loc6_.x - 1,_loc6_.y,param1,this.fillList1);
               this.Mapper_PutFillCell(_loc6_.x + 1,_loc6_.y,param1,this.fillList1);
               this.Mapper_PutFillCell(_loc6_.x,_loc6_.y - 1,param1,this.fillList1);
               this.Mapper_PutFillCell(_loc6_.x,_loc6_.y + 1,param1,this.fillList1);
            }
            if(this.fillList1.length != 0)
            {
               this.fillList = this.fillList1;
            }
            else
            {
               _loc5_ = true;
            }
         }
         while(_loc5_ == false);
      }
      
      internal function Mapper_PutFillCell(param1:int, param2:int, param3:int, param4:Array) : *
      {
         var _loc5_:Level = GetCurrentLevel();
         if(param1 < _loc5_.mapMinX)
         {
            return;
         }
         if(param2 < _loc5_.mapMinY)
         {
            return;
         }
         if(param1 > _loc5_.mapMaxX)
         {
            return;
         }
         if(param2 > _loc5_.mapMaxY)
         {
            return;
         }
         var _loc6_:int = _loc5_.mapMaxX - _loc5_.mapMinX + 1;
         param1 -= _loc5_.mapMinX;
         param2 -= _loc5_.mapMinY;
         var _loc7_:int = int(_loc5_.map[param1 + param2 * _loc6_]);
         if(_loc7_ != this.fillOrigCell)
         {
            return;
         }
         _loc5_.map[param1 + param2 * _loc6_] = param3;
         param1 += _loc5_.mapMinX;
         param2 += _loc5_.mapMinY;
         var _loc8_:Object = new Object();
         _loc8_.x = param1;
         _loc8_.y = param2;
         param4.push(_loc8_);
      }
      
      internal function Mapper_GetCell(param1:int, param2:int) : int
      {
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = _loc3_.mapMaxX - _loc3_.mapMinX + 1;
         param1 -= _loc3_.mapMinX;
         param2 -= _loc3_.mapMinY;
         return _loc3_.map[param1 + param2 * _loc4_];
      }
      
      internal function Mapper_PutCell(param1:int, param2:int, param3:int) : *
      {
         var _loc4_:Level = GetCurrentLevel();
         var _loc5_:int = _loc4_.mapMaxX - _loc4_.mapMinX + 1;
         param1 -= _loc4_.mapMinX;
         param2 -= _loc4_.mapMinY;
         _loc4_.map[param1 + param2 * _loc5_] = param3;
      }
      
      internal function Mapper_PlotCell(param1:int) : *
      {
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Array = this.brushes[this.mapper_brushType];
         var _loc3_:Level = GetCurrentLevel();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = MouseControl.x;
            _loc6_ = MouseControl.y;
            _loc5_ += PhysEditor.scrollX;
            _loc6_ += PhysEditor.scrollY;
            _loc5_ /= _loc3_.mapCellW;
            _loc6_ /= _loc3_.mapCellH;
            _loc5_ += _loc4_.x;
            _loc6_ += _loc4_.y;
            if(_loc5_ < _loc3_.mapMinX || _loc5_ > _loc3_.mapMaxX || _loc6_ < _loc3_.mapMinY || _loc6_ > _loc3_.mapMaxY)
            {
               this.mapper_ExpandMap(_loc5_,_loc6_);
            }
            _loc7_ = _loc3_.mapMaxX - _loc3_.mapMinX + 1;
            _loc5_ -= _loc3_.mapMinX;
            _loc6_ -= _loc3_.mapMinY;
            _loc3_.map[_loc5_ + _loc6_ * _loc7_] = param1;
         }
      }
      
      internal function Mapper_RenderMap() : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         if(this.mapper_transparency == 0)
         {
            return;
         }
         var _loc1_:Number = Utils.ScaleTo(0,1,0,5,this.mapper_transparency);
         var _loc2_:Level = GetCurrentLevel();
         var _loc5_:Rectangle = new Rectangle(0,0,_loc2_.mapCellW - 1,_loc2_.mapCellH - 1);
         var _loc6_:int = _loc2_.mapMaxX - _loc2_.mapMinX + 1;
         var _loc7_:int = _loc2_.mapMaxY - _loc2_.mapMinY + 1;
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc8_ = int(_loc2_.map[_loc3_ * _loc6_ + _loc4_]);
               if(_loc8_ != 0)
               {
                  _loc5_.x = (_loc4_ + _loc2_.mapMinX) * _loc2_.mapCellW - PhysEditor.scrollX;
                  _loc5_.y = (_loc3_ + _loc2_.mapMinY) * _loc2_.mapCellH - PhysEditor.scrollY;
                  PhysEditor.FillRectangle(_loc5_,this.mapCols[_loc8_],0,_loc1_);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      internal function Mapper_RenderCursor() : *
      {
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:Array = this.brushes[this.mapper_brushType];
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = MouseControl.x;
            _loc5_ = MouseControl.y;
            _loc4_ += PhysEditor.scrollX;
            _loc5_ += PhysEditor.scrollY;
            _loc4_ /= _loc1_.mapCellW;
            _loc5_ /= _loc1_.mapCellH;
            _loc4_ += _loc3_.x;
            _loc5_ += _loc3_.y;
            _loc4_ *= _loc1_.mapCellW;
            _loc5_ *= _loc1_.mapCellH;
            _loc4_ -= PhysEditor.scrollX;
            _loc5_ -= PhysEditor.scrollY;
            PhysEditor.RenderRectangle(new Rectangle(_loc4_,_loc5_,_loc1_.mapCellW - 1,_loc1_.mapCellH - 1),4294934656,2);
         }
      }
   }
}

