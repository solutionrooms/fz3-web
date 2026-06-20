package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class EditMode_Lines extends EditMode_Base
   {
      
      internal var addlineActive:Boolean;
      
      internal var newLineType:int;
      
      internal var hoveredLineIndex:int;
      
      internal var dragPoint:Point;
      
      internal var lastLineSelectedIndex:int;
      
      internal var copiedParameters:ObjParameters;
      
      internal var subMode:String;
      
      public var currentLineIndex:int;
      
      public var currentPointIndex:int;
      
      internal var scaleCentreX:Number;
      
      internal var scaleCentreY:Number;
      
      internal var scalePositions:Array;
      
      internal var rotateCentreX:Number;
      
      internal var rotateCentreY:Number;
      
      internal var rotatePositions:Array;
      
      public function EditMode_Lines()
      {
         super();
      }
      
      internal function CopyParameters() : *
      {
         var _loc1_:PhysLine = this.GetCurrentLine();
         if(_loc1_ == null)
         {
            return;
         }
         this.copiedParameters = _loc1_.objParameters.Clone();
      }
      
      internal function PasteParameters() : *
      {
         var _loc1_:PhysLine = this.GetCurrentLine();
         if(_loc1_ == null)
         {
            return;
         }
         if(this.copiedParameters == null)
         {
            return;
         }
         PhysEditor.UndoTakeSnapshot();
         _loc1_.objParameters = this.copiedParameters.Clone();
      }
      
      override public function EnterMode() : void
      {
         PhysEditor.CursorText_Show();
         PhysEditor.CursorText_Set("");
         this.SetSubMode("null");
         this.hoveredLineIndex = -1;
      }
      
      override public function InitOnce() : void
      {
         this.currentLineIndex = -1;
         this.currentPointIndex = -1;
         this.addlineActive = false;
         this.newLineType = 0;
         var _loc1_:Level = GetCurrentLevel();
         this.currentLineIndex = _loc1_.lines.length - 1;
         this.hoveredLineIndex = -1;
         this.lastLineSelectedIndex = -1;
         this.dragPoint = new Point(0,0);
         this.copiedParameters = null;
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:PhysLine = null;
         super.OnMouseDown(param1);
         if(this.subMode == "pick")
         {
            this.Lines_SelectLineByArea(mxs,mys);
            if(this.currentLineIndex == -1)
            {
               this.Lines_SelectLine(mxs,mys);
            }
            _loc2_ = this.Lines_GetLineByIndex(this.currentLineIndex);
            this.lastLineSelectedIndex = this.currentLineIndex;
            if(_loc2_ != null)
            {
               EditParams.AddParameterListBox(_loc2_.objParameters);
            }
            else
            {
               EditParams.ClearParameterListBox();
            }
         }
         else if(this.subMode == "copyparameters")
         {
            this.Lines_SelectLineByArea(mxs,mys);
            this.CopyParameters();
         }
         else if(this.subMode == "pasteparameters")
         {
            this.Lines_SelectLineByArea(mxs,mys);
            this.PasteParameters();
         }
         else if(this.subMode == "scaleline")
         {
            this.Lines_SelectLineByArea(mxs,mys);
            this.Lines_StartScale(mxs,mys);
         }
         else if(this.subMode == "rotateline")
         {
            this.Lines_SelectLineByArea(mxs,mys);
            this.Lines_StartRotate(mxs,mys);
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
               _loc2_ = this.Lines_GetLineByIndex(this.currentLineIndex);
               EditParams.AddParameterListBox(_loc2_.objParameters);
               return;
            }
            if(this.subMode == "newrectangle")
            {
               PhysEditor.UndoTakeSnapshot();
               this.addlineActive = true;
               this.currentPointIndex = -1;
               this.Lines_NewRect();
               _loc2_ = this.Lines_GetLineByIndex(this.currentLineIndex);
               EditParams.AddParameterListBox(_loc2_.objParameters);
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
               this.Lines_SelectLineByArea(mxs,mys);
               this.dragPoint = new Point(mxs,mys);
            }
            else if(this.subMode == "selectpoint")
            {
               if(this.GetCurrentLinePrimitiveType() == PhysLine.PRIMITIVE_LINE)
               {
                  PhysEditor.UndoTakeSnapshot();
                  this.Lines_SelectPoint(mxs,mys);
               }
            }
            else if(this.subMode == "deleteline")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_SelectLineByArea(mxs,mys);
               if(this.currentLineIndex == this.lastLineSelectedIndex)
               {
                  this.lastLineSelectedIndex = -1;
               }
               this.Lines_DeleteSelectedLine();
            }
            else if(this.subMode == "duplicate")
            {
               PhysEditor.UndoTakeSnapshot();
               this.Lines_SelectLineByArea(mxs,mys);
               if(this.currentLineIndex == this.lastLineSelectedIndex)
               {
                  this.lastLineSelectedIndex = -1;
               }
               this.Lines_DuplicateSelectedLine();
            }
            else if(this.subMode == "deletepoint")
            {
               if(this.GetCurrentLinePrimitiveType() == PhysLine.PRIMITIVE_LINE)
               {
                  PhysEditor.UndoTakeSnapshot();
                  this.Lines_DeletePoint(mxs,mys);
               }
            }
            else if(this.subMode == "insertpoint")
            {
               if(this.GetCurrentLinePrimitiveType() == PhysLine.PRIMITIVE_LINE)
               {
                  PhysEditor.UndoTakeSnapshot();
                  this.Lines_InsertPointAtMousePos(mxs,mys);
               }
            }
            else if(this.subMode == "insertafter")
            {
               if(this.GetCurrentLinePrimitiveType() == PhysLine.PRIMITIVE_LINE)
               {
                  PhysEditor.UndoTakeSnapshot();
                  this.Lines_InsertPoint(mxs,mys);
               }
            }
            else if(this.addlineActive)
            {
               if(this.GetCurrentLinePrimitiveType() == PhysLine.PRIMITIVE_LINE)
               {
                  PhysEditor.UndoTakeSnapshot();
                  this.Lines_AddPoint(mxs,mys);
                  Utils.trace("adding point at " + mxs + " " + mys);
               }
            }
         }
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         super.OnMouseUp(param1);
         if(this.subMode == "scaleline")
         {
            _loc2_ = 1 + (mxs - this.scaleCentreX) * 0.005;
            this.Lines_Scale(_loc2_);
         }
      }
      
      internal function GetHoveredLine() : *
      {
         var _loc1_:int = this.currentLineIndex;
         var _loc2_:int = this.currentPointIndex;
         this.Lines_SelectLineByArea(mxs,mys);
         if(this.currentLineIndex == -1)
         {
            this.Lines_SelectLine(mxs,mys);
         }
         this.hoveredLineIndex = this.currentLineIndex;
         this.currentLineIndex = _loc1_;
         this.currentPointIndex = _loc2_;
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc3_:PhysLine = null;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         super.OnMouseMove(param1);
         var _loc2_:Level = GetCurrentLevel();
         this.hoveredLineIndex = -1;
         if(this.subMode == "pick" && param1.buttonDown == false)
         {
            this.GetHoveredLine();
         }
         if(this.subMode == "dragline" && param1.buttonDown == false)
         {
            this.GetHoveredLine();
         }
         if(this.subMode == "scaleline" && param1.buttonDown == false)
         {
            this.GetHoveredLine();
         }
         if(this.subMode == "rotateline" && param1.buttonDown == false)
         {
            this.GetHoveredLine();
         }
         if(param1.buttonDown == false)
         {
            return;
         }
         if(this.subMode == "newrectangle")
         {
            PhysEditor.UndoTakeSnapshot();
            this.Lines_DragRect(mxs,mys);
         }
         if(this.subMode == "dragpoint")
         {
            if(this.currentPointIndex != -1)
            {
               _loc3_ = _loc2_.lines[this.currentLineIndex];
               if(_loc3_.primitiveType == PhysLine.PRIMITIVE_LINE)
               {
                  _loc4_ = _loc3_.points[this.currentPointIndex];
                  _loc4_.x = mxs;
                  _loc4_.y = mys;
               }
               if(_loc3_.primitiveType == PhysLine.PRIMITIVE_RECTANGLE)
               {
                  _loc4_ = _loc3_.points[this.currentPointIndex];
                  if(this.currentPointIndex == 0)
                  {
                     if(mxs < _loc3_.points[2].x && mys < _loc3_.points[2].y)
                     {
                        _loc4_.x = mxs;
                        _loc4_.y = mys;
                        _loc3_.points[1].y = mys;
                        _loc3_.points[3].x = mxs;
                     }
                  }
                  if(this.currentPointIndex == 2)
                  {
                     if(mxs > _loc3_.points[0].x && mys > _loc3_.points[0].y)
                     {
                        _loc4_.x = mxs;
                        _loc4_.y = mys;
                        _loc3_.points[1].x = mxs;
                        _loc3_.points[3].y = mys;
                     }
                  }
               }
            }
         }
         if(this.subMode == "dragline")
         {
            _loc5_ = mxs - this.dragPoint.x;
            _loc6_ = mys - this.dragPoint.y;
            for each(_loc4_ in _loc2_.lines[this.currentLineIndex].points)
            {
               _loc4_.x += _loc5_;
               _loc4_.y += _loc6_;
            }
            this.dragPoint = new Point(mxs,mys);
         }
         else if(this.subMode == "scaleline")
         {
            _loc7_ = 1 + (mxs - this.scaleCentreX) * 0.005;
            this.Lines_Scale(_loc7_);
         }
         else if(this.subMode == "rotateline")
         {
            _loc8_ = (mxs - this.rotateCentreX) * 0.005;
            this.Lines_Rotate(_loc8_);
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
         if(param1 == "newrectangle")
         {
            PhysEditor.CursorText_Set("new rectangle");
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
         if(param1 == "duplicate")
         {
            PhysEditor.CursorText_Set("duplicate line");
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
         if(param1 == "rotateline")
         {
            PhysEditor.CursorText_Set("rotate line");
         }
         if(param1 == "insertafter")
         {
            PhysEditor.CursorText_Set("insert after selected");
         }
         if(param1 == "copyparameters")
         {
            PhysEditor.CursorText_Set("copy parameters");
         }
         if(param1 == "pasteparameters")
         {
            PhysEditor.CursorText_Set("paste parameters");
         }
      }
      
      override public function Update() : void
      {
         super.Update();
         if(KeyReader.Pressed(KeyReader.KEY_TAB) && KeyReader.Down(KeyReader.KEY_CONTROL))
         {
            PhysEditor.UndoTakeSnapshot();
            PhysEditor.GetCurrentLevel().lines = new Array();
            this.currentLineIndex = -1;
            this.currentPointIndex = -1;
         }
         if(KeyReader.Down(KeyReader.KEY_T))
         {
            this.SetSubMode("scaleline");
         }
         else if(KeyReader.Down(KeyReader.KEY_Y))
         {
            this.SetSubMode("rotateline");
         }
         else if(KeyReader.Down(KeyReader.KEY_L))
         {
            this.SetSubMode("pick");
         }
         else if(KeyReader.Down(KeyReader.KEY_N))
         {
            this.SetSubMode("newline");
         }
         else if(KeyReader.Down(KeyReader.KEY_M))
         {
            this.SetSubMode("newrectangle");
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
         else if(KeyReader.Down(KeyReader.KEY_X))
         {
            this.SetSubMode("deletepoint");
         }
         else if(KeyReader.Down(KeyReader.KEY_D))
         {
            this.SetSubMode("duplicate");
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
         else if(KeyReader.Down(KeyReader.KEY_C))
         {
            this.SetSubMode("copyparameters");
         }
         else if(KeyReader.Down(KeyReader.KEY_V))
         {
            this.SetSubMode("pasteparameters");
         }
         else if(this.addlineActive)
         {
            if(this.currentLineIndex != -1)
            {
               if(this.GetCurrentLine().primitiveType == PhysLine.PRIMITIVE_LINE)
               {
                  this.SetSubMode("addpoint");
               }
               else
               {
                  this.SetSubMode("null");
               }
            }
            else
            {
               this.SetSubMode("null");
            }
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
      }
      
      override public function Render(param1:BitmapData) : void
      {
         super.Render(param1);
         param1.fillRect(Defs.screenRect,4282668390);
         PhysEditor.RenderBackground(param1);
         PhysEditor.Editor_RenderObjects();
         PhysEditor.Editor_RenderMiniMap();
         PhysEditor.Editor_RenderJoints(param1);
         PhysEditor.Editor_RenderLines(true);
         PhysEditor.Editor_RenderLineToCursor();
         var _loc2_:PhysLine = GetCurrentLevel().GetLineByIndex(this.hoveredLineIndex);
         PhysEditor.HighlightLinePoly(_loc2_);
         PhysEditor.Editor_RenderGrid(param1);
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
         _loc3_ = "X: Delete Point";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "D: Duplicate Poly";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "SHIFT Drag Point";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "CTRL Drag Line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "N: New line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "M: Make Box";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "S: Insert Point On Line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "Q: Select Point";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "A: Insert Point After";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "T: Scale Line (drag)";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "Y: Rotate Line (drag)";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "8: Change Type";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "9: Toggle addline display";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "R: Reverse Line Direction";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "[ and ]: Move to first / last point of selected line";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "ScrollPos: " + PhysEditor.scrollX + " " + PhysEditor.scrollY;
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "CursorPos: " + int(MouseControl.x + PhysEditor.scrollX) + " " + int(MouseControl.y + PhysEditor.scrollY);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         if(this.currentLineIndex != -1)
         {
            _loc4_ = GetCurrentLevel().lines[this.currentLineIndex];
            _loc3_ = "Type: " + PhysEditor.GetLineTypeString(_loc4_.type);
            param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         }
         return param2;
      }
      
      internal function GetCurrentLinePrimitiveType() : String
      {
         if(this.GetCurrentLine() == null)
         {
            return "";
         }
         return this.GetCurrentLine().primitiveType;
      }
      
      internal function GetCurrentLine() : PhysLine
      {
         if(this.currentLineIndex == -1)
         {
            return null;
         }
         var _loc1_:Level = GetCurrentLevel();
         return _loc1_.lines[this.currentLineIndex];
      }
      
      internal function Lines_EnterID() : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:PhysLine = _loc1_.lines[this.currentLineIndex];
         PhysEditor.AddTextEntry(100,100,"line id ",_loc2_.id,this.Lines_EnterID_Done);
      }
      
      internal function Lines_EnterID_Done(param1:String) : *
      {
         var _loc2_:Level = GetCurrentLevel();
         var _loc3_:PhysLine = _loc2_.lines[this.currentLineIndex];
         _loc3_.id = param1;
      }
      
      internal function Lines_Reverse() : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:Array = _loc1_.lines[this.currentLineIndex].points;
         var _loc3_:Array = _loc2_.reverse();
         _loc1_.lines[this.currentLineIndex].points = _loc3_;
      }
      
      internal function Lines_AddPoint(param1:Number, param2:Number) : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:Point = new Point(param1,param2);
         var _loc5_:Array = _loc3_.lines[this.currentLineIndex].points;
         _loc5_.push(_loc4_);
         _loc3_.lines[this.currentLineIndex].points = _loc5_;
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
         var _loc4_:* = _loc3_.lines[this.currentLineIndex].points.length;
         var _loc5_:Array = _loc3_.lines[this.currentLineIndex].points;
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
            _loc4_ = _loc3_.lines[this.currentLineIndex].points;
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
         var _loc7_:Array = _loc3_.lines[_loc5_].points;
         if(_loc6_ == _loc7_.length - 1)
         {
            return;
         }
         var _loc8_:Point = _loc7_[_loc6_].clone();
         var _loc9_:Point = _loc7_[_loc6_ + 1].clone();
         var _loc10_:Point = new Point(param1,param2);
         _loc7_.splice(_loc6_ + 1,0,_loc10_);
         _loc3_.lines[_loc5_].points = _loc7_;
         ++this.currentPointIndex;
      }
      
      internal function Lines_DuplicateSelectedLine() : *
      {
         var _loc2_:PhysLine = null;
         var _loc3_:PhysLine = null;
         var _loc4_:Point = null;
         var _loc1_:Level = GetCurrentLevel();
         if(this.currentLineIndex != -1)
         {
            _loc2_ = _loc1_.lines[this.currentLineIndex];
            _loc3_ = _loc2_.Clone();
            _loc3_.id = "";
            for each(_loc4_ in _loc3_.points)
            {
               _loc4_.x += 10;
               _loc4_.y += 10;
            }
            _loc1_.lines.push(_loc3_);
            this.currentLineIndex = _loc1_.lines.length - 1;
         }
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
            for each(_loc4_ in _loc1_.lines)
            {
               if(_loc3_ != this.currentLineIndex)
               {
                  _loc2_.push(_loc4_.Clone());
               }
               _loc3_++;
            }
            _loc1_.lines = _loc2_;
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
         for each(_loc7_ in _loc3_.lines)
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
            _loc10_ = _loc3_.lines[_loc5_].points;
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
            _loc3_.lines[_loc5_].points = _loc11_;
            _loc13_ = new Array();
            for each(_loc7_ in _loc3_.lines)
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
            _loc3_.lines = _loc13_;
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
         var _loc2_:Array = _loc1_.lines[this.currentLineIndex].points;
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
         var _loc2_:Array = _loc1_.lines[this.currentLineIndex].points;
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
         var _loc2_:PhysLine = _loc1_.lines[this.currentLineIndex];
         ++_loc2_.type;
         if(_loc2_.type >= PhysEditor.lineTypes.length)
         {
            _loc2_.type = 0;
         }
         this.newLineType = _loc2_.type;
      }
      
      internal function Lines_DragRect(param1:int, param2:int) : *
      {
         if(this.currentLineIndex == -1)
         {
            return;
         }
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:PhysLine = _loc3_.lines[this.currentLineIndex];
         if(_loc4_.points.length != 4)
         {
            return;
         }
         _loc4_.points[2].x = param1;
         _loc4_.points[2].y = param2;
         _loc4_.points[1].x = param1;
         _loc4_.points[3].y = param2;
      }
      
      internal function Lines_NewRect() : *
      {
         var _loc1_:PhysLine = new PhysLine();
         _loc1_.type = this.newLineType;
         var _loc2_:Level = GetCurrentLevel();
         var _loc3_:Number = 0;
         _loc1_.primitiveType = PhysLine.PRIMITIVE_RECTANGLE;
         _loc1_.AddPoint(mxs,mys);
         _loc1_.AddPoint(mxs + _loc3_,mys);
         _loc1_.AddPoint(mxs + _loc3_,mys + _loc3_);
         _loc1_.AddPoint(mxs,mys + _loc3_);
         var _loc4_:PhysLine = GetCurrentLevel().GetLineByIndex(this.lastLineSelectedIndex);
         if(_loc4_ != null)
         {
            _loc1_.objParameters = _loc4_.objParameters.Clone();
         }
         _loc2_.lines.push(_loc1_);
         this.currentLineIndex = _loc2_.lines.length - 1;
         this.currentPointIndex = 2;
         Utils.trace("New line " + this.currentLineIndex);
      }
      
      internal function Lines_NewLine() : *
      {
         var _loc1_:PhysLine = GetCurrentLevel().GetLineByIndex(this.lastLineSelectedIndex);
         var _loc2_:PhysLine = new PhysLine();
         if(_loc1_ != null)
         {
            _loc2_.objParameters = _loc1_.objParameters.Clone();
         }
         _loc2_.type = this.newLineType;
         var _loc3_:Level = GetCurrentLevel();
         _loc3_.lines.push(_loc2_);
         this.currentLineIndex = _loc3_.lines.length - 1;
         Utils.trace("New line " + this.currentLineIndex);
         this.lastLineSelectedIndex = this.currentLineIndex;
      }
      
      internal function Lines_GetLineByIndex(param1:int) : PhysLine
      {
         if(param1 == -1)
         {
            return null;
         }
         var _loc2_:Level = GetCurrentLevel();
         return _loc2_.lines[param1];
      }
      
      public function Lines_SelectLine(param1:Number, param2:Number) : *
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
         for each(_loc5_ in _loc3_.lines)
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
         for each(_loc5_ in _loc3_.lines)
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
      
      internal function Lines_SelectLineByArea(param1:Number, param2:Number) : *
      {
         var _loc5_:PhysLine = null;
         var _loc6_:int = 0;
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         this.currentLineIndex = -1;
         for each(_loc5_ in _loc3_.lines)
         {
            _loc6_ = 0;
            if(_loc5_.objParameters.GetParam("editor_layer") != "")
            {
               _loc6_ = _loc5_.objParameters.GetValueInt("editor_layer") - 1;
            }
            if(PhysEditor.IsLayerVisible(_loc6_) == true)
            {
               if(_loc5_.PointInPoly(param1,param2))
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
         var _loc4_:Array = _loc3_.lines[this.currentLineIndex].points;
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
         for each(_loc7_ in _loc3_.lines)
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
            _loc14_ = _loc3_.lines[_loc5_].points;
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
            _loc3_.lines[_loc5_].points = _loc15_;
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
            for each(_loc4_ in _loc3_.lines[this.currentLineIndex].points)
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
            while(_loc3_ < _loc2_.lines[this.currentLineIndex].points.length)
            {
               _loc4_ = this.scalePositions[_loc3_];
               _loc5_ = this.scaleCentreX + (_loc4_.x - this.scaleCentreX) * param1;
               _loc6_ = this.scaleCentreY + (_loc4_.y - this.scaleCentreY) * param1;
               _loc2_.lines[this.currentLineIndex].points[_loc3_] = new Point(_loc5_,_loc6_);
               _loc3_++;
            }
         }
      }
      
      internal function Lines_StartRotate(param1:Number, param2:Number) : *
      {
         var _loc4_:Point = null;
         var _loc3_:PhysLine = GetCurrentLevel().GetLineByIndex(this.currentLineIndex);
         if(_loc3_ == null)
         {
            return;
         }
         this.rotateCentreX = param1;
         this.rotateCentreY = param2;
         this.rotatePositions = new Array();
         for each(_loc4_ in _loc3_.points)
         {
            this.rotatePositions.push(_loc4_.clone());
         }
      }
      
      internal function Lines_Rotate(param1:Number) : *
      {
         var _loc5_:Point = null;
         var _loc2_:PhysLine = GetCurrentLevel().GetLineByIndex(this.currentLineIndex);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(-this.rotateCentreX,-this.rotateCentreY);
         _loc3_.rotate(param1);
         _loc3_.translate(this.rotateCentreX,this.rotateCentreY);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.points.length)
         {
            _loc5_ = _loc3_.transformPoint(this.rotatePositions[_loc4_]);
            _loc2_.points[_loc4_] = _loc5_.clone();
            _loc4_++;
         }
      }
      
      internal function Lines_SelectPoint(param1:Number, param2:Number) : *
      {
         var _loc5_:PhysLine = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         this.currentPointIndex = -1;
         for each(_loc5_ in _loc3_.lines)
         {
            _loc6_ = 0;
            if(_loc5_.primitiveType == PhysLine.PRIMITIVE_LINE)
            {
               for each(_loc7_ in _loc5_.points)
               {
                  if(Utils.DistBetweenPoints(_loc7_.x,_loc7_.y,param1,param2) < 3 * (1 / PhysEditor.zoom))
                  {
                     this.currentLineIndex = _loc4_;
                     this.currentPointIndex = _loc6_;
                     return;
                  }
                  _loc6_++;
               }
            }
            if(_loc5_.primitiveType == PhysLine.PRIMITIVE_RECTANGLE)
            {
               _loc8_ = 0;
               while(_loc8_ <= 2)
               {
                  _loc7_ = _loc5_.points[_loc8_];
                  if(Utils.DistBetweenPoints(_loc7_.x,_loc7_.y,param1,param2) < 3)
                  {
                     this.currentLineIndex = _loc4_;
                     this.currentPointIndex = _loc6_;
                     return;
                  }
                  _loc6_ += 2;
                  _loc8_ += 2;
               }
            }
            _loc4_++;
         }
      }
   }
}

