package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.System;
   
   public class EditMode_ObjCol extends EditMode_Base
   {
      
      internal var addlineActive:Boolean;
      
      internal var newLineType:int;
      
      internal var objLines:Array;
      
      internal var subMode:String;
      
      internal var currentLineIndex:int;
      
      internal var currentPointIndex:int;
      
      internal var scaleCentreX:Number;
      
      internal var scaleCentreY:Number;
      
      internal var scalePositions:Array;
      
      public function EditMode_ObjCol()
      {
         super();
      }
      
      override public function EnterMode() : void
      {
         PhysEditor.CursorText_Show();
         PhysEditor.CursorText_Set("");
         this.SetSubMode("null");
         this.objLines = new Array();
         PhysEditor.scrollX = 0;
         PhysEditor.scrollY = 0;
      }
      
      override public function InitOnce() : void
      {
         this.currentLineIndex = -1;
         this.currentPointIndex = -1;
         this.addlineActive = false;
         this.newLineType = 0;
         var _loc1_:Level = GetCurrentLevel();
         this.currentLineIndex = 0;
         this.objLines = new Array();
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         super.OnMouseDown(param1);
         if(this.subMode == "pick")
         {
            this.Lines_SelectLine(mxs,mys);
         }
         else if(this.subMode == "scaleline")
         {
            PhysEditor.UndoTakeSnapshot();
            this.Lines_StartScale(mxs,mys);
         }
         else
         {
            if(this.subMode == "newline")
            {
               PhysEditor.UndoTakeSnapshot();
               this.addlineActive = true;
               this.currentPointIndex = -1;
               this.Lines_NewLine();
               this.Lines_AddPoint(mxs,mys);
               return;
            }
            if(this.subMode == "dragpoint")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_SelectPoint(mxs,mys);
            }
            else if(this.subMode == "dragline")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_SelectPoint(mxs,mys);
            }
            else if(this.subMode == "selectpoint")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_SelectPoint(mxs,mys);
            }
            else if(this.subMode == "deleteline")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_SelectLine(mxs,mys);
               this.Lines_DeleteSelectedLine();
            }
            else if(this.subMode == "deletepoint")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_DeletePoint(mxs,mys);
            }
            else if(this.subMode == "insertpoint")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_InsertPointAtMousePos(mxs,mys);
            }
            else if(this.subMode == "insertafter")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_InsertPoint(mxs,mys);
            }
            else if(this.addlineActive)
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_AddPoint(mxs,mys);
            }
         }
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         super.OnMouseUp(param1);
         if(this.subMode == "scaleline")
         {
            _loc2_ = 1 + (mxs - this.scaleCentreX) * 0.001;
            this.Lines_Scale(_loc2_);
         }
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.OnMouseMove(param1);
         var _loc2_:Level = GetCurrentLevel();
         if(param1.buttonDown == false)
         {
            return;
         }
         if(this.subMode == "dragpoint")
         {
            if(this.currentPointIndex != -1)
            {
               _loc3_ = this.objLines[this.currentLineIndex].points[this.currentPointIndex];
               _loc3_.x = mxs;
               _loc3_.y = mys;
            }
         }
         if(this.subMode == "dragline")
         {
            if(this.currentPointIndex != -1)
            {
               _loc3_ = this.objLines[this.currentLineIndex].points[this.currentPointIndex];
               _loc4_ = mxs - _loc3_.x;
               _loc5_ = mys - _loc3_.y;
               for each(_loc3_ in this.objLines[this.currentLineIndex].points)
               {
                  _loc3_.x += _loc4_;
                  _loc3_.y += _loc5_;
               }
            }
         }
         else if(this.subMode == "scaleline")
         {
            _loc6_ = 1 + (mxs - this.scaleCentreX) * 0.001;
            this.Lines_Scale(_loc6_);
         }
      }
      
      override public function OnMouseWheel(param1:int) : void
      {
      }
      
      internal function SetSubMode(param1:String) : *
      {
         this.subMode = param1;
         if(param1 == "null")
         {
            PhysEditor.CursorText_Set("");
         }
         if(param1 == "pick")
         {
            PhysEditor.CursorText_Set("pick line");
         }
         if(param1 == "addpoint")
         {
            PhysEditor.CursorText_Set("add point");
         }
         if(param1 == "newline")
         {
            PhysEditor.CursorText_Set("new line");
         }
         if(param1 == "dragpoint")
         {
            PhysEditor.CursorText_Set("drag point");
         }
         if(param1 == "dragline")
         {
            PhysEditor.CursorText_Set("drag line");
         }
         if(param1 == "deleteline")
         {
            PhysEditor.CursorText_Set("delete line");
         }
         if(param1 == "deletepoint")
         {
            PhysEditor.CursorText_Set("delete point");
         }
         if(param1 == "insertpoint")
         {
            PhysEditor.CursorText_Set("insert on line");
         }
         if(param1 == "selectpoint")
         {
            PhysEditor.CursorText_Set("select point");
         }
         if(param1 == "scaleline")
         {
            PhysEditor.CursorText_Set("scale line");
         }
         if(param1 == "insertafter")
         {
            PhysEditor.CursorText_Set("insert after selected");
         }
      }
      
      override public function Update() : void
      {
         super.Update();
         if(KeyReader.Down(KeyReader.KEY_T))
         {
            this.SetSubMode("scaleline");
         }
         else if(KeyReader.Down(KeyReader.KEY_L))
         {
            this.SetSubMode("pick");
         }
         else if(KeyReader.Down(KeyReader.KEY_N))
         {
            this.SetSubMode("newline");
         }
         else if(KeyReader.Down(KeyReader.KEY_SHIFT))
         {
            this.SetSubMode("dragpoint");
         }
         else if(KeyReader.Down(KeyReader.KEY_CONTROL))
         {
            this.SetSubMode("dragline");
         }
         else if(KeyReader.Down(KeyReader.KEY_DELETE) || KeyReader.Down(KeyReader.KEY_SQUIGGLE))
         {
            this.SetSubMode("deleteline");
         }
         else if(KeyReader.Down(KeyReader.KEY_D))
         {
            this.SetSubMode("deletepoint");
         }
         else if(KeyReader.Down(KeyReader.KEY_S))
         {
            this.SetSubMode("insertpoint");
         }
         else if(KeyReader.Down(KeyReader.KEY_Q))
         {
            this.SetSubMode("selectpoint");
         }
         else if(KeyReader.Down(KeyReader.KEY_A))
         {
            this.SetSubMode("insertafter");
         }
         else if(this.addlineActive)
         {
            this.SetSubMode("addpoint");
         }
         else
         {
            this.SetSubMode("null");
         }
         var _loc1_:Level = GetCurrentLevel();
         if(KeyReader.Pressed(KeyReader.KEY_9))
         {
            this.addlineActive = this.addlineActive == false;
         }
         if(KeyReader.Pressed(KeyReader.KEY_8))
         {
            PhysEditor.UndoTakeSnapshot();
            this.Lines_ChangeType();
            return;
         }
         if(KeyReader.Pressed(KeyReader.KEY_R))
         {
            PhysEditor.UndoTakeSnapshot();
            this.Lines_Reverse();
            return;
         }
         if(KeyReader.Pressed(KeyReader.KEY_I))
         {
            PhysEditor.UndoTakeSnapshot();
            this.Lines_EnterID();
            return;
         }
         if(KeyReader.Pressed(KeyReader.KEY_LEFTSQUAREBRACKET))
         {
            this.Lines_ScrollToFirstPointOfSelectedLine();
         }
         if(KeyReader.Pressed(KeyReader.KEY_RIGHTSQUAREBRACKET))
         {
            this.Lines_ScrollToLastPointOfSelectedLine();
         }
         if(KeyReader.Pressed(KeyReader.KEY_1))
         {
            this.DecCurrentPiece();
         }
         if(KeyReader.Pressed(KeyReader.KEY_2))
         {
            this.IncCurrentPiece();
         }
         if(KeyReader.Pressed(KeyReader.KEY_P))
         {
            this.PrintOut();
         }
      }
      
      internal function PrintOut() : *
      {
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc14_:String = null;
         var _loc1_:Point = this.ObjCol_GetCentrePos();
         var _loc2_:Point = new Point();
         var _loc4_:String = "";
         if(this.objLines.length == 0)
         {
            return;
         }
         var _loc5_:PhysLine = this.objLines[0];
         var _loc8_:Array = _loc5_.points;
         var _loc9_:int = int(_loc8_.length);
         var _loc10_:int = 100000;
         var _loc11_:int = _loc9_ / _loc10_;
         var _loc12_:int = _loc9_ % _loc10_;
         var _loc13_:* = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc11_)
         {
            _loc14_ = "vertices =\"";
            _loc7_ = 0;
            while(_loc7_ < _loc10_)
            {
               _loc2_ = _loc8_[_loc13_++];
               _loc14_ += int(_loc2_.x - _loc1_.x) + "," + int(_loc2_.y - _loc1_.y);
               if(_loc7_ != _loc10_ - 1)
               {
                  _loc14_ += ", ";
               }
               _loc7_++;
            }
            _loc3_ = _loc14_ += "\"";
            _loc4_ += _loc3_;
            Utils.trace(_loc3_);
            _loc6_++;
         }
         if(_loc12_ != 0)
         {
            _loc14_ = "vertices =\"";
            _loc7_ = 0;
            while(_loc7_ < _loc12_)
            {
               _loc2_ = _loc8_[_loc13_++];
               _loc14_ += int(_loc2_.x - _loc1_.x) + "," + int(_loc2_.y - _loc1_.y);
               if(_loc7_ != _loc12_ - 1)
               {
                  _loc14_ += ", ";
               }
               _loc7_++;
            }
            _loc3_ = _loc14_ += "\"";
            _loc4_ += _loc3_;
            Utils.trace(_loc3_);
         }
         System.setClipboard(_loc4_);
      }
      
      internal function DecCurrentPiece() : *
      {
         var _loc1_:Object = null;
         for each(_loc1_ in PhysEditor.currentPieceList)
         {
            --_loc1_.id;
            if(_loc1_.id < 0)
            {
               _loc1_.id = Game.objectDefs.GetNum() - 1;
            }
         }
         this.GetObjectLines();
      }
      
      internal function IncCurrentPiece() : *
      {
         var _loc1_:Object = null;
         for each(_loc1_ in PhysEditor.currentPieceList)
         {
            ++_loc1_.id;
            if(_loc1_.id > Game.objectDefs.GetNum() - 1)
            {
               _loc1_.id = 0;
            }
         }
         this.GetObjectLines();
      }
      
      internal function GetObjectLines() : *
      {
         this.objLines = new Array();
      }
      
      internal function PreviousPiece() : *
      {
         Utils.trace("PreviousPiece not implemented yet");
      }
      
      internal function NextPiece() : *
      {
         Utils.trace("NextPiece not implemented yet");
      }
      
      override public function Render(param1:BitmapData) : void
      {
         super.Render(param1);
         param1.fillRect(Defs.screenRect,4282668390);
         this.RenderCurrentPiece(param1);
         this.Editor_RenderObjectCollisionLines(false);
         PhysEditor.Editor_RenderLineToCursor();
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         var _loc3_:String = null;
         var _loc4_:PhysLine = null;
         _loc3_ = "I: Line ID: ";
         if(this.currentLineIndex != -1)
         {
            _loc4_ = GetCurrentLevel().lines[this.currentLineIndex];
            _loc3_ += _loc4_.id;
         }
         else
         {
            _loc3_ += "NONE";
         }
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "L: Select Line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "DEL: Delete Line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "D: Delete Point";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "SHIFT Drag Point";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "CTRL Drag Line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "N: New line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "S: Insert Point On Line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "Q: Select Point";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "A: Insert Point After";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "T: Scale Line (drag)";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "8: Change Type";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "R: Reverse Line Direction";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "[ and ]: Move to first / last point of selected line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "ScrollPos: " + Math.round(PhysEditor.scrollX) + " " + Math.round(PhysEditor.scrollY);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "CursorPos: " + int(MouseControl.x + PhysEditor.scrollX - this.ObjCol_GetCentrePos().x) + " " + int(MouseControl.y + PhysEditor.scrollY - this.ObjCol_GetCentrePos().y);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         if(this.currentLineIndex != -1)
         {
            _loc4_ = GetCurrentLevel().lines[this.currentLineIndex];
            _loc3_ = "Type: " + PhysEditor.GetLineTypeString(_loc4_.type);
            param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         }
         return param2;
      }
      
      internal function Lines_EnterID() : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:PhysLine = this.objLines[this.currentLineIndex];
         PhysEditor.AddTextEntry(100,100,"line id ",_loc2_.id,this.Lines_EnterID_Done);
      }
      
      internal function Lines_EnterID_Done(param1:String) : *
      {
         var _loc2_:Level = GetCurrentLevel();
         var _loc3_:PhysLine = this.objLines[this.currentLineIndex];
         _loc3_.id = param1;
      }
      
      internal function Lines_Reverse() : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:Array = this.objLines[this.currentLineIndex].points;
         var _loc3_:Array = _loc2_.reverse();
         this.objLines[this.currentLineIndex].points = _loc3_;
      }
      
      internal function Lines_AddPoint(param1:Number, param2:Number) : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:Point = new Point(param1,param2);
         var _loc5_:Array = this.objLines[this.currentLineIndex].points;
         _loc5_.push(_loc4_);
         this.objLines[this.currentLineIndex].points = _loc5_;
      }
      
      internal function Lines_InsertPointAtMousePos(param1:Number, param2:Number) : *
      {
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc3_:Level = GetCurrentLevel();
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc4_:* = this.objLines[this.currentLineIndex].points.length;
         var _loc5_:Array = this.objLines[this.currentLineIndex].points;
         _loc6_ = 0;
         while(_loc6_ < _loc4_ - 1)
         {
            _loc7_ = _loc5_[_loc6_];
            _loc8_ = _loc5_[_loc6_ + 1];
            _loc9_ = Collision.ClosestPointOnLine(_loc7_.x,_loc7_.y,_loc8_.x,_loc8_.y,param1,param2);
            if(_loc9_ >= 0 && _loc9_ <= 1)
            {
               if(Utils.DistBetweenPoints(param1,param2,Collision.closestX,Collision.closestY) < 2)
               {
                  this.currentPointIndex = _loc6_;
                  this.Lines_InsertPointOnCurrentLine(param1,param2);
                  return;
               }
            }
            _loc6_++;
         }
      }
      
      internal function Lines_InsertPointOnCurrentLine(param1:Number, param2:Number) : *
      {
         var _loc4_:Array = null;
         var _loc5_:Point = null;
         var _loc3_:Level = GetCurrentLevel();
         if(this.currentLineIndex != -1 && this.currentPointIndex != -1)
         {
            _loc4_ = this.objLines[this.currentLineIndex].points;
            if(this.currentPointIndex == _loc4_.length - 1)
            {
               return;
            }
            _loc5_ = new Point(param1,param2);
            _loc4_.splice(this.currentPointIndex + 1,0,_loc5_);
            this.currentPointIndex += 1;
         }
      }
      
      internal function Lines_InsertPoint(param1:Number, param2:Number) : *
      {
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         var _loc5_:int = this.currentLineIndex;
         var _loc6_:int = this.currentPointIndex;
         if(_loc5_ == -1 || _loc6_ == -1)
         {
            return;
         }
         var _loc7_:Array = this.objLines[_loc5_].points;
         if(_loc6_ == _loc7_.length - 1)
         {
            return;
         }
         var _loc8_:Point = _loc7_[_loc6_].clone();
         var _loc9_:Point = _loc7_[_loc6_ + 1].clone();
         var _loc10_:Point = new Point(param1,param2);
         _loc7_.splice(_loc6_ + 1,0,_loc10_);
         this.objLines[_loc5_].points = _loc7_;
         ++this.currentPointIndex;
      }
      
      internal function Lines_DeleteSelectedLine() : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:PhysLine = null;
         var _loc1_:Level = GetCurrentLevel();
         if(this.currentLineIndex != -1)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            for each(_loc4_ in this.objLines)
            {
               if(_loc3_ != this.currentLineIndex)
               {
                  _loc2_.push(_loc4_.Clone());
               }
               _loc3_++;
            }
            this.objLines = _loc2_;
            this.currentPointIndex = -1;
            this.currentLineIndex = -1;
         }
      }
      
      internal function Lines_DeletePoint(param1:Number, param2:Number) : *
      {
         var _loc7_:PhysLine = null;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         var _loc5_:int = -1;
         var _loc6_:int = -1;
         for each(_loc7_ in this.objLines)
         {
            _loc8_ = 0;
            for each(_loc9_ in _loc7_.points)
            {
               if(Utils.DistBetweenPoints(_loc9_.x,_loc9_.y,param1,param2) < 3)
               {
                  _loc5_ = _loc4_;
                  _loc6_ = _loc8_;
               }
               _loc8_++;
            }
            _loc4_++;
         }
         if(_loc5_ != -1 && _loc6_ != -1)
         {
            _loc10_ = this.objLines[_loc5_].points;
            _loc11_ = new Array();
            _loc12_ = 0;
            while(_loc12_ < _loc10_.length)
            {
               if(_loc12_ != _loc6_)
               {
                  _loc11_.push(_loc10_[_loc12_].clone());
               }
               _loc12_++;
            }
            this.objLines[_loc5_].points = _loc11_;
            _loc13_ = new Array();
            for each(_loc7_ in this.objLines)
            {
               if(_loc7_.points.length != 0)
               {
                  _loc13_.push(_loc7_.Clone());
               }
               else
               {
                  this.currentLineIndex = -1;
               }
            }
            this.objLines = _loc13_;
            this.currentPointIndex = -1;
         }
      }
      
      internal function Lines_ScrollToFirstPointOfSelectedLine() : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:Array = this.objLines[this.currentLineIndex].points;
         var _loc3_:Point = _loc2_[0];
         PhysEditor.scrollX = _loc3_.x - Defs.displayarea_w * 0.5;
         PhysEditor.scrollY = _loc3_.y - Defs.displayarea_h * 0.5;
      }
      
      internal function Lines_ScrollToLastPointOfSelectedLine() : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:Array = this.objLines[this.currentLineIndex].points;
         var _loc3_:Point = _loc2_[_loc2_.length - 1];
         PhysEditor.scrollX = _loc3_.x - Defs.displayarea_w * 0.5;
         PhysEditor.scrollY = _loc3_.y - Defs.displayarea_h * 0.5;
      }
      
      internal function Lines_ChangeType() : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:PhysLine = this.objLines[this.currentLineIndex];
         ++_loc2_.type;
         if(_loc2_.type >= PhysEditor.lineTypes.length)
         {
            _loc2_.type = 0;
         }
         this.newLineType = _loc2_.type;
      }
      
      internal function Lines_NewLine() : *
      {
         var _loc1_:PhysLine = new PhysLine();
         _loc1_.type = this.newLineType;
         var _loc2_:Level = GetCurrentLevel();
         this.objLines.push(_loc1_);
         this.currentLineIndex = this.objLines.length - 1;
         Utils.trace("New line " + this.currentLineIndex);
      }
      
      internal function Lines_SelectLine(param1:Number, param2:Number) : *
      {
         var _loc5_:PhysLine = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Number = NaN;
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         this.currentLineIndex = -1;
         for each(_loc5_ in this.objLines)
         {
            _loc7_ = _loc5_.points;
            _loc8_ = int(_loc5_.points.length);
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc9_ = _loc6_ + 1;
               if(_loc9_ >= _loc8_)
               {
                  _loc9_ = 0;
               }
               _loc10_ = _loc7_[_loc6_];
               _loc11_ = _loc7_[_loc9_];
               _loc12_ = Collision.ClosestPointOnLine(_loc10_.x,_loc10_.y,_loc11_.x,_loc11_.y,param1,param2);
               if(_loc12_ >= 0 && _loc12_ <= 1)
               {
                  if(Utils.DistBetweenPoints(param1,param2,Collision.closestX,Collision.closestY) < 2)
                  {
                     this.currentLineIndex = _loc4_;
                     this.currentPointIndex = -1;
                     return;
                  }
               }
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      internal function Lines_SelectLineByPoint(param1:Number, param2:Number) : *
      {
         var _loc5_:PhysLine = null;
         var _loc6_:Point = null;
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         this.currentLineIndex = -1;
         for each(_loc5_ in this.objLines)
         {
            for each(_loc6_ in _loc5_.points)
            {
               if(Utils.DistBetweenPoints(_loc6_.x,_loc6_.y,param1,param2) < 3)
               {
                  this.currentLineIndex = _loc4_;
                  this.currentPointIndex = -1;
                  return;
               }
            }
            _loc4_++;
         }
      }
      
      internal function Lines_MovePoints(param1:Number, param2:Number) : *
      {
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:Array = this.objLines[this.currentLineIndex].points;
         var _loc5_:Number = 100;
         for each(_loc7_ in _loc4_)
         {
            _loc6_ = Utils.DistBetweenPoints(_loc7_.x,_loc7_.y,param1,param2);
            if(_loc6_ < _loc5_)
            {
               _loc6_ = _loc5_ - _loc6_;
               _loc6_ = Utils.ScaleTo(0,5,0,_loc5_,_loc6_);
               if(_loc7_.y < param2)
               {
                  _loc7_.y -= _loc6_;
               }
               else if(_loc7_.y > param2)
               {
                  _loc7_.y += _loc6_;
               }
            }
         }
      }
      
      internal function Lines_Subdivide(param1:Number, param2:Number) : *
      {
         var _loc7_:PhysLine = null;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:Point = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         if(this.currentLineIndex == -1 || this.currentPointIndex == -1)
         {
            return;
         }
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         var _loc5_:int = -1;
         var _loc6_:int = -1;
         for each(_loc7_ in this.objLines)
         {
            _loc8_ = 0;
            for each(_loc9_ in _loc7_.points)
            {
               if(Utils.DistBetweenPoints(_loc9_.x,_loc9_.y,param1,param2) < 3)
               {
                  _loc5_ = _loc4_;
                  _loc6_ = _loc8_;
               }
               _loc8_++;
            }
            _loc4_++;
         }
         if(_loc5_ != -1 && _loc6_ != -1)
         {
            if(_loc6_ == this.currentPointIndex)
            {
               return;
            }
            _loc10_ = this.currentPointIndex;
            _loc11_ = _loc6_;
            if(_loc11_ < _loc10_)
            {
               _loc16_ = _loc10_;
               _loc11_ = _loc10_;
               _loc10_ = _loc16_;
            }
            _loc12_ = new Array();
            _loc14_ = this.objLines[_loc5_].points;
            _loc13_ = _loc10_;
            while(_loc13_ < _loc11_)
            {
               _loc17_ = _loc14_[_loc13_].clone();
               _loc18_ = _loc14_[_loc13_ + 1].clone();
               _loc19_ = new Point((_loc17_.x + _loc18_.x) / 2,(_loc17_.y + _loc18_.y) / 2);
               _loc12_.push(_loc19_);
               _loc12_.push(_loc18_);
               _loc13_++;
            }
            _loc15_ = new Array();
            _loc13_ = 0;
            while(_loc13_ <= _loc10_)
            {
               _loc15_.push(_loc14_[_loc13_].clone());
               _loc13_++;
            }
            for each(_loc19_ in _loc12_)
            {
               _loc15_.push(_loc19_.clone());
            }
            _loc13_ = _loc11_ + 1;
            while(_loc13_ < _loc14_.length)
            {
               _loc15_.push(_loc14_[_loc13_].clone());
               _loc13_++;
            }
            this.objLines[_loc5_].points = _loc15_;
         }
      }
      
      internal function Lines_StartScale(param1:Number, param2:Number) : *
      {
         var _loc4_:Point = null;
         this.scaleCentreX = param1;
         this.scaleCentreY = param2;
         this.scalePositions = new Array();
         var _loc3_:Level = GetCurrentLevel();
         if(this.currentLineIndex != -1)
         {
            for each(_loc4_ in this.objLines[this.currentLineIndex].points)
            {
               this.scalePositions.push(_loc4_.clone());
            }
         }
      }
      
      internal function Lines_Scale(param1:Number) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Level = GetCurrentLevel();
         if(this.currentLineIndex != -1)
         {
            _loc3_ = 0;
            while(_loc3_ < this.objLines[this.currentLineIndex].points.length)
            {
               _loc4_ = this.scalePositions[_loc3_];
               _loc5_ = this.scaleCentreX + (_loc4_.x - this.scaleCentreX) * param1;
               _loc6_ = this.scaleCentreY + (_loc4_.y - this.scaleCentreY) * param1;
               this.objLines[this.currentLineIndex].points[_loc3_] = new Point(_loc5_,_loc6_);
               _loc3_++;
            }
         }
      }
      
      internal function Lines_SelectPoint(param1:Number, param2:Number) : *
      {
         var _loc5_:PhysLine = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         this.currentPointIndex = -1;
         for each(_loc5_ in this.objLines)
         {
            _loc6_ = 0;
            for each(_loc7_ in _loc5_.points)
            {
               if(Utils.DistBetweenPoints(_loc7_.x,_loc7_.y,param1,param2) < 3)
               {
                  this.currentLineIndex = _loc4_;
                  this.currentPointIndex = _loc6_;
                  return;
               }
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      internal function Editor_RenderObjectCollisionLines(param1:Boolean = false) : *
      {
         var _loc2_:Point = null;
         var _loc8_:PhysLine = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         _loc2_ = new Point();
         var _loc3_:Point = new Point();
         var _loc4_:Rectangle = new Rectangle();
         var _loc5_:Level = GetCurrentLevel();
         var _loc6_:BitmapData = Game.main.screenBD;
         var _loc7_:int = 0;
         for each(_loc8_ in this.objLines)
         {
            _loc9_ = _loc8_.points;
            if(_loc7_ == this.currentLineIndex && param1)
            {
               _loc14_ = MouseControl.x;
               _loc15_ = MouseControl.y;
               _loc9_ = new Array();
               for each(_loc2_ in _loc8_.points)
               {
                  _loc9_.push(_loc2_.clone());
               }
               _loc9_.push(new Point(_loc14_ + PhysEditor.scrollX,_loc15_ + PhysEditor.scrollY));
            }
            _loc10_ = 0;
            _loc11_ = false;
            if((_loc10_ & PhysEditor.LM_LINK) != 0)
            {
               _loc11_ = true;
            }
            _loc12_ = 16777215;
            _loc13_ = 1;
            if(_loc7_ == this.currentLineIndex)
            {
               _loc13_ = 2;
            }
            if(_loc9_.length >= 2)
            {
               _loc16_ = 0;
               while(_loc16_ < _loc9_.length - 1)
               {
                  _loc2_ = _loc9_[_loc16_];
                  _loc3_ = _loc9_[_loc16_ + 1];
                  PhysEditor.RenderLine(_loc2_.x - PhysEditor.scrollX,_loc2_.y - PhysEditor.scrollY,_loc3_.x - PhysEditor.scrollX,_loc3_.y - PhysEditor.scrollY,_loc12_,_loc13_,1,_loc11_);
                  _loc16_++;
               }
               if((_loc10_ & PhysEditor.LM_LINK) != 0)
               {
                  _loc2_ = _loc9_[_loc9_.length - 1];
                  _loc3_ = _loc9_[0];
                  PhysEditor.RenderLine(_loc2_.x - PhysEditor.scrollX,_loc2_.y - PhysEditor.scrollY,_loc3_.x - PhysEditor.scrollX,_loc3_.y - PhysEditor.scrollY,_loc12_,_loc13_,1,_loc11_);
               }
            }
            if((_loc10_ & PhysEditor.LM_FILL) != 0)
            {
               PhysEditor.FillPoly(_loc9_,_loc12_,0.1);
            }
            _loc16_ = 0;
            while(_loc16_ < _loc9_.length)
            {
               _loc12_ = 4294901760;
               if(_loc7_ == this.currentLineIndex && this.currentPointIndex == _loc16_)
               {
                  _loc12_ = 4294967040;
               }
               _loc17_ = 2;
               _loc18_ = 4;
               if(_loc7_ == PhysEditor.hoverLineIndex && PhysEditor.hoverPointIndex == _loc16_)
               {
                  _loc17_ = 3;
                  _loc18_ = 6;
               }
               _loc4_.x = _loc9_[_loc16_].x - _loc17_ - PhysEditor.scrollX;
               _loc4_.y = _loc9_[_loc16_].y - _loc17_ - PhysEditor.scrollY;
               _loc4_.width = _loc18_;
               _loc4_.height = _loc18_;
               PhysEditor.RenderRectangle(_loc4_,_loc12_);
               _loc16_++;
            }
            _loc7_++;
         }
      }
      
      internal function ObjCol_GetCentrePos() : Point
      {
         var _loc1_:Number = Defs.displayarea_w / 2;
         var _loc2_:Number = Defs.displayarea_h / 2;
         return new Point(_loc1_,_loc2_);
      }
      
      public function RenderCurrentPiece(param1:BitmapData) : void
      {
         var _loc2_:PhysObj = null;
         var _loc4_:Object = null;
         var _loc3_:Point = this.ObjCol_GetCentrePos().clone();
         _loc3_.x -= PhysEditor.scrollX;
         _loc3_.y -= PhysEditor.scrollY;
         if(PhysEditor.currentPieceList.length == 1)
         {
            param1.fillRect(Defs.screenRect,4282668390);
            _loc4_ = PhysEditor.currentPieceList[0];
            _loc2_ = Game.objectDefs.GetByIndex(_loc4_.id);
            PhysObj.RenderAt(_loc2_,_loc3_.x,_loc3_.y,0,1,param1,PhysEditor.linesScreen.graphics,false);
         }
         Utils.RenderDotLine(param1,_loc3_.x - 10,_loc3_.y,_loc3_.x + 10,_loc3_.y,100,16711680);
         Utils.RenderDotLine(param1,_loc3_.x,_loc3_.y - 10,_loc3_.x,_loc3_.y + 10,100,16711680);
      }
   }
}

