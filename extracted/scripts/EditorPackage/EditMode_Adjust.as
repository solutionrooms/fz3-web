package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EditMode_Adjust extends EditMode_Base
   {
      
      public var currentAdjustObject:LevelObj_Instance;
      
      public var currentAdjustObjectList:Vector.<LevelObj_Instance>;
      
      public var currentAdjustObjectListOffsets:Vector.<Point>;
      
      public var currentAdjustObject_mouseX:int = 0;
      
      public var currentAdjustObjectParam:int = 0;
      
      public var dragRectX0:int;
      
      public var dragRectX1:int;
      
      public var dragRectY0:int;
      
      public var dragRectY1:int;
      
      internal var copiedParameters:ObjParameters = null;
      
      internal var subMode:String;
      
      public function EditMode_Adjust()
      {
         super();
      }
      
      override public function EnterMode() : void
      {
         PhysEditor.CursorText_Show();
         PhysEditor.CursorText_Set("");
         this.SetSubMode("null");
         this.currentAdjustObjectList = new Vector.<LevelObj_Instance>();
         this.currentAdjustObjectListOffsets = new Vector.<Point>();
         this.currentAdjustObject = null;
         this.currentAdjustObjectList.splice(0,this.currentAdjustObjectList.length);
      }
      
      override public function InitOnce() : void
      {
         this.currentAdjustObjectList = new Vector.<LevelObj_Instance>();
         this.currentAdjustObjectListOffsets = new Vector.<Point>();
         this.currentAdjustObject = null;
         this.currentAdjustObjectList.splice(0,this.currentAdjustObjectList.length);
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:LevelObj_Instance = null;
         var _loc4_:LevelObj_Instance = null;
         super.OnMouseDown(param1);
         var _loc2_:Number = 1 / PhysEditor.zoom;
         Utils.trace("HERE MouseDown");
         _loc3_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
         if(_loc3_)
         {
            if(this.IsInList(_loc3_))
            {
               PhysEditor.UndoTakeSnapshot();
               this.currentAdjustObject_mouseX = int(mx);
               this.currentAdjustObjectListOffsets.splice(0,this.currentAdjustObjectListOffsets.length);
               for each(_loc4_ in this.currentAdjustObjectList)
               {
                  this.currentAdjustObjectListOffsets.push(new Point(int(mxs - _loc4_.x),int(mys - _loc4_.y)));
               }
               if(KeyReader.Down(KeyReader.KEY_CONTROL))
               {
                  this.ToggleInList(_loc3_);
               }
            }
            else
            {
               if(KeyReader.Down(KeyReader.KEY_CONTROL))
               {
                  this.ToggleInList(_loc3_);
               }
               else
               {
                  this.ClearList();
                  this.AddToList(_loc3_);
               }
               EditParams.AddParameterListBox(_loc3_.objParameters);
            }
         }
         else
         {
            this.ClearList();
            EditParams.ClearParameterListBox();
         }
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:LevelObj_Instance = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Array = null;
         super.OnMouseUp(param1);
         if(editSubMode == 4)
         {
            _loc3_ = this.GetDragRectangle();
            _loc4_ = GetCurrentLevelInstances();
            for each(_loc2_ in _loc4_)
            {
               if(_loc3_.containsPoint(new Point(_loc2_.x,_loc2_.y)))
               {
                  this.AddToList(_loc2_);
               }
            }
            editSubMode = 0;
         }
         editSubMode = 0;
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc4_:LevelObj_Instance = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:LevelObj_Instance = null;
         super.OnMouseMove(param1);
         var _loc2_:Number = 1 / PhysEditor.zoom;
         var _loc3_:Number = 1;
         if(param1.buttonDown)
         {
            if(editSubMode == 1)
            {
               _loc5_ = 0;
               for each(_loc4_ in this.currentAdjustObjectList)
               {
                  _loc6_ = _loc4_.x;
                  _loc7_ = _loc4_.y;
                  _loc4_.x = mxs;
                  _loc4_.y = mys;
                  _loc4_.x -= this.currentAdjustObjectListOffsets[_loc5_].x;
                  _loc4_.y -= this.currentAdjustObjectListOffsets[_loc5_].y;
                  PhysEditor.editModeObj_Joints.UpdateJoints_ObjectMoved(_loc4_.id,_loc4_.x - _loc6_,_loc4_.y - _loc7_);
                  _loc5_++;
               }
            }
            else if(editSubMode == 2)
            {
               _loc8_ = mx - this.currentAdjustObject_mouseX;
               for each(_loc4_ in this.currentAdjustObjectList)
               {
                  _loc4_.scale += _loc8_ * 0.01;
               }
               this.currentAdjustObject_mouseX = mx;
            }
            else if(editSubMode == 3)
            {
               _loc8_ = mx - this.currentAdjustObject_mouseX;
               for each(_loc4_ in this.currentAdjustObjectList)
               {
                  _loc4_.rot += _loc8_ * 1;
               }
               this.currentAdjustObject_mouseX = mx;
            }
            else if(editSubMode == 4)
            {
               this.dragRectX1 = mx + PhysEditor.scrollX;
               this.dragRectY1 = my + PhysEditor.scrollY;
            }
            else if(editSubMode == 0)
            {
               _loc4_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
               if(_loc4_)
               {
                  if(this.IsInList(_loc4_))
                  {
                     PhysEditor.UndoTakeSnapshot();
                     this.currentAdjustObject_mouseX = int(mx);
                     this.currentAdjustObjectListOffsets.splice(0,this.currentAdjustObjectListOffsets.length);
                     for each(_loc9_ in this.currentAdjustObjectList)
                     {
                        this.currentAdjustObjectListOffsets.push(new Point(int(mxs - _loc9_.x),int(mys - _loc9_.y)));
                     }
                     if(this.subMode == "dragscale")
                     {
                        editSubMode = 2;
                     }
                     else if(this.subMode == "dragrot")
                     {
                        editSubMode = 3;
                     }
                     else
                     {
                        editSubMode = 1;
                     }
                  }
               }
               else
               {
                  editSubMode = 4;
                  this.dragRectX0 = mx + PhysEditor.scrollX;
                  this.dragRectY0 = my + PhysEditor.scrollY;
                  this.dragRectX1 = mx + PhysEditor.scrollX;
                  this.dragRectY1 = my + PhysEditor.scrollY;
                  this.ClearList();
                  EditParams.ClearParameterListBox();
               }
            }
         }
      }
      
      override public function OnMouseWheel(param1:int) : void
      {
         var _loc2_:* = 0;
         if(this.currentAdjustObject != null)
         {
            if(param1 > 0)
            {
               PhysEditor.UndoTakeSnapshot();
               _loc2_ = Game.objectDefs.FindIndexByName(this.currentAdjustObject.typeName);
               if(++_loc2_ >= Game.objectDefs.GetNum())
               {
                  _loc2_ = 0;
               }
               this.currentAdjustObject.typeName = Game.objectDefs.GetByIndex(_loc2_).name;
            }
            if(param1 < 0)
            {
               PhysEditor.UndoTakeSnapshot();
               _loc2_ = Game.objectDefs.FindIndexByName(this.currentAdjustObject.typeName);
               _loc2_--;
               if(_loc2_ < 0)
               {
                  _loc2_ = int(Game.objectDefs.GetNum() - 1);
               }
               this.currentAdjustObject.typeName = Game.objectDefs.GetByIndex(_loc2_).name;
            }
         }
      }
      
      override public function Update() : void
      {
         var _loc1_:LevelObj_Instance = null;
         var _loc2_:LevelObj_Instance = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = 0;
         super.Update();
         if(KeyReader.Down(KeyReader.KEY_S))
         {
            this.SetSubMode("dragscale");
         }
         else if(KeyReader.Down(KeyReader.KEY_R))
         {
            this.SetSubMode("dragrot");
         }
         else
         {
            this.SetSubMode("null");
         }
         if(KeyReader.Pressed(KeyReader.KEY_TAB) && KeyReader.Down(KeyReader.KEY_CONTROL))
         {
            PhysEditor.UndoTakeSnapshot();
            PhysEditor.GetCurrentLevel().instances = new Array();
         }
         if(KeyReader.Down(KeyReader.KEY_L))
         {
            if(this.currentAdjustObjectList.length >= 1)
            {
               PhysEditor.ClearCurrentPieces();
               _loc2_ = this.currentAdjustObjectList[0];
               for each(_loc1_ in this.currentAdjustObjectList)
               {
                  PhysEditor.AddCurrentPiece(Game.objectDefs.FindIndexByName(_loc1_.typeName),_loc1_.rot,_loc1_.x - _loc2_.x,_loc1_.y - _loc2_.y,_loc1_.x,_loc1_.y);
               }
            }
         }
         if(KeyReader.Down(KeyReader.KEY_C))
         {
            this.CopyParameters();
         }
         if(KeyReader.Down(KeyReader.KEY_V))
         {
            this.PasteParameters();
         }
         if(this.currentAdjustObject == null)
         {
            if(this.currentAdjustObjectList.length != 0)
            {
               for each(_loc1_ in this.currentAdjustObjectList)
               {
               }
            }
         }
         if(this.currentAdjustObjectList.length != 1)
         {
            if(KeyReader.Pressed(KeyReader.KEY_DELETE) || KeyReader.Pressed(KeyReader.KEY_SQUIGGLE))
            {
               PhysEditor.UndoTakeSnapshot();
               for each(var _loc11_ in this.currentAdjustObjectList)
               {
                  _loc1_ = _loc11_;
                  _loc11_;
                  PhysEditor.RemoveFromLevelInstances(_loc1_);
               }
               this.currentAdjustObjectList.splice(0,this.currentAdjustObjectList.length);
            }
         }
         if(this.currentAdjustObject != null)
         {
            _loc3_ = 1;
            _loc4_ = 1;
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            if(KeyReader.Down(KeyReader.KEY_CONTROL))
            {
               _loc3_ = _loc3_ * 10;
               _loc4_ = _loc4_ * 10;
            }
            if(KeyReader.Down(KeyReader.KEY_SHIFT))
            {
               if(KeyReader.Down(KeyReader.KEY_LEFT))
               {
                  _loc6_ = -_loc3_;
               }
               if(KeyReader.Down(KeyReader.KEY_RIGHT))
               {
                  _loc6_ = _loc3_;
               }
               if(KeyReader.Down(KeyReader.KEY_UP))
               {
                  _loc7_ = -_loc3_;
               }
               if(KeyReader.Down(KeyReader.KEY_DOWN))
               {
                  _loc7_ = _loc3_;
               }
               if(_loc6_ != 0 || _loc7_ != 0)
               {
                  PhysEditor.UndoTakeSnapshot();
               }
               this.currentAdjustObject.x = this.currentAdjustObject.x + _loc6_;
               this.currentAdjustObject.y = this.currentAdjustObject.y + _loc7_;
            }
            if(KeyReader.Down(KeyReader.KEY_4))
            {
               this.currentAdjustObject.scale = this.currentAdjustObject.scale - 0.01;
            }
            if(KeyReader.Down(KeyReader.KEY_5))
            {
               this.currentAdjustObject.scale = this.currentAdjustObject.scale + 0.01;
            }
            if(KeyReader.Down(KeyReader.KEY_6))
            {
               _loc5_ = -_loc4_;
            }
            if(KeyReader.Down(KeyReader.KEY_7))
            {
               _loc5_ = _loc4_;
            }
            if(KeyReader.Pressed(KeyReader.KEY_8))
            {
               _loc8_ = Game.objectDefs.FindIndexByName(this.currentAdjustObject.typeName);
               _loc8_--;
               if(_loc8_ < 0)
               {
                  _loc8_ = int(Game.objectDefs.GetNum() - 1);
               }
               this.currentAdjustObject.typeName = Game.objectDefs.GetByIndex(_loc8_).name;
            }
            if(KeyReader.Pressed(KeyReader.KEY_9))
            {
               _loc8_ = Game.objectDefs.FindIndexByName(this.currentAdjustObject.typeName);
               var _temp_22:* = _loc8_;
               _loc8_ = _temp_22 + 1;
               _temp_22;
               if(_loc8_ >= Game.objectDefs.GetNum())
               {
                  _loc8_ = 0;
               }
               this.currentAdjustObject.typeName = Game.objectDefs.GetByIndex(_loc8_).name;
            }
            if(_loc5_ != 0)
            {
               PhysEditor.UndoTakeSnapshot();
            }
            this.currentAdjustObject.rot = this.currentAdjustObject.rot + _loc5_;
            if(KeyReader.Pressed(KeyReader.KEY_DELETE) || KeyReader.Pressed(KeyReader.KEY_SQUIGGLE))
            {
               PhysEditor.UndoTakeSnapshot();
               PhysEditor.editModeObj_Joints.UpdateJoints_ObjectDeleted(this.currentAdjustObject.id);
               PhysEditor.RemoveFromLevelInstances(this.currentAdjustObject);
               this.currentAdjustObject = null;
            }
            if(KeyReader.Pressed(KeyReader.KEY_I))
            {
               PhysEditor.UndoTakeSnapshot();
               this.CurrentAdjustObject_EnterID();
            }
         }
      }
      
      internal function CopyParameters() : *
      {
         var _loc1_:LevelObj_Instance = null;
         if(this.currentAdjustObjectList.length == 1)
         {
            _loc1_ = this.currentAdjustObjectList[0];
            this.copiedParameters = _loc1_.objParameters.Clone();
         }
      }
      
      internal function PasteParameters() : *
      {
         var _loc1_:LevelObj_Instance = null;
         if(this.copiedParameters == null)
         {
            return;
         }
         if(this.currentAdjustObjectList.length == 1)
         {
            PhysEditor.UndoTakeSnapshot();
            _loc1_ = this.currentAdjustObjectList[0];
            _loc1_.objParameters = this.copiedParameters.Clone();
            EditParams.ClearParameterListBox();
            EditParams.AddParameterListBox(_loc1_.objParameters);
         }
      }
      
      override public function Render(param1:BitmapData) : void
      {
         var _loc2_:Rectangle = null;
         super.Render(param1);
         param1.fillRect(Defs.screenRect,4282668390);
         PhysEditor.RenderBackground(param1);
         this.Editor_RenderObjects_AdjustMode(param1);
         PhysEditor.Editor_RenderJoints(param1);
         PhysEditor.Editor_RenderMiniMap();
         PhysEditor.Editor_RenderLines();
         if(this.currentAdjustObject != null)
         {
         }
         PhysEditor.Editor_RenderGrid(param1);
         if(editSubMode == 4)
         {
            _loc2_ = this.GetDragRectangle().clone();
            _loc2_.x = _loc2_.x - PhysEditor.scrollX;
            _loc2_.y = _loc2_.y - PhysEditor.scrollY;
            PhysEditor.FillRectangle(_loc2_,16777215,1,0.4);
            PhysEditor.RenderRectangle(_loc2_,16777215,1,1);
         }
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         var _loc3_:String = null;
         _loc3_ = "I: Object ID: ";
         if(this.currentAdjustObject == null)
         {
            _loc3_ = _loc3_ + "NONE";
         }
         else
         {
            _loc3_ = _loc3_ + this.currentAdjustObject.id;
         }
         param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "Object type: ";
         if(this.currentAdjustObject == null)
         {
            _loc3_ = _loc3_ + "NONE";
         }
         else
         {
            _loc3_ = _loc3_ + this.currentAdjustObject.typeName;
         }
         param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "P: Change selected parameter";
         param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "E: Edit current parameter";
         param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         if(this.currentAdjustObject != null)
         {
            _loc3_ = "DEL: Delete Selected";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "Shift + Arrows: Move Piece";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "6/7: Rotate: ";
            _loc3_ = _loc3_ + this.currentAdjustObject.rot;
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "4/5: Scale: ";
            _loc3_ = _loc3_ + this.currentAdjustObject.scale;
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "8/9: Change block type";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "Click to drag pos";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "[+S]=Scale, [+C]=Rotation";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "L: Copy piece(s)";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "C: Copy Parameters";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
            _loc3_ = "V: Paste Parameters";
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         }
         if(this.currentAdjustObject != null)
         {
            _loc3_ = "Pos: " + this.currentAdjustObject.x + " " + this.currentAdjustObject.y + "     Rot: " + this.currentAdjustObject.rot;
            param2 = param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         }
         return param2;
      }
      
      internal function Editor_RenderObjects_AdjustMode(param1:BitmapData) : *
      {
         var _loc3_:LevelObj_Instance = null;
         var _loc4_:PhysObj = null;
         var _loc5_:Point = null;
         var _loc6_:Boolean = false;
         var _loc7_:Editor_GameRenderer = null;
         var _loc2_:Array = GetCurrentLevelInstances();
         if(PhysEditor.objectZSortMode)
         {
            _loc2_ = PhysEditor.SortInstancesByZ(_loc2_);
         }
         for each(var _loc10_ in _loc2_)
         {
            _loc3_ = _loc10_;
            _loc10_;
            _loc4_ = Game.objectDefs.FindByName(_loc3_.typeName);
            _loc5_ = PhysEditor.GetMapPos(_loc3_.x,_loc3_.y);
            _loc6_ = true;
            if(this.IsInList(_loc3_))
            {
               if(PhysEditor.updateTimer & 2)
               {
                  _loc6_ = false;
               }
            }
            if(_loc6_)
            {
               if(_loc4_.editorRenderFunctionName != null)
               {
                  _loc7_ = new Editor_GameRenderer();
                  _loc7_[_loc4_.editorRenderFunctionName](_loc4_,_loc3_);
               }
               else
               {
                  PhysObj.RenderAt(_loc4_,_loc5_.x,_loc5_.y,_loc3_.rot,_loc3_.scale * PhysEditor.zoom,param1,PhysEditor.linesScreen.graphics,true);
               }
            }
         }
      }
      
      internal function GetDragRectangle() : Rectangle
      {
         var _loc1_:int = this.dragRectX0;
         var _loc2_:int = this.dragRectX1;
         var _loc3_:int = this.dragRectY0;
         var _loc4_:int = this.dragRectY1;
         if(this.dragRectX1 < this.dragRectX0)
         {
            _loc1_ = this.dragRectX1;
            _loc2_ = this.dragRectX0;
         }
         if(this.dragRectY1 < this.dragRectY0)
         {
            _loc3_ = this.dragRectY1;
            _loc4_ = this.dragRectY0;
         }
         return new Rectangle(_loc1_,_loc3_,_loc2_ - _loc1_,_loc4_ - _loc3_);
      }
      
      internal function IsInList(param1:LevelObj_Instance) : Boolean
      {
         var _loc2_:int = this.currentAdjustObjectList.indexOf(param1);
         return _loc2_ != -1;
      }
      
      internal function ClearList() : *
      {
         this.currentAdjustObjectList.splice(0,this.currentAdjustObjectList.length);
         this.SetSingleCurrentAdjustObject();
      }
      
      internal function ToggleInList(param1:LevelObj_Instance) : *
      {
         if(this.IsInList(param1))
         {
            this.RemoveFromList(param1);
         }
         else
         {
            this.AddToList(param1);
         }
      }
      
      internal function AddToList(param1:LevelObj_Instance) : *
      {
         this.currentAdjustObjectList.push(param1);
         this.SetSingleCurrentAdjustObject();
      }
      
      internal function SetSingleCurrentAdjustObject() : *
      {
         if(this.currentAdjustObjectList.length == 1)
         {
            this.currentAdjustObject = this.currentAdjustObjectList[0];
         }
         else
         {
            this.currentAdjustObject = null;
         }
      }
      
      internal function RemoveFromList(param1:LevelObj_Instance) : *
      {
         var _loc2_:int = this.currentAdjustObjectList.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.currentAdjustObjectList.splice(_loc2_,1);
         }
         this.SetSingleCurrentAdjustObject();
      }
      
      internal function CurrentAdjustObject_EnterID() : *
      {
         if(this.currentAdjustObject == null)
         {
            return;
         }
         PhysEditor.AddTextEntry(100,100,"object ID ",this.currentAdjustObject.id,this.CurrentAdjustObject_EnterID_Done);
      }
      
      internal function CurrentAdjustObject_EnterID_Done(param1:String) : *
      {
         Utils.trace("here " + param1);
         this.currentAdjustObject.id = param1;
      }
      
      internal function SetSubMode(param1:String) : *
      {
         this.subMode = param1;
         if(param1 == "null")
         {
            PhysEditor.CursorText_Set("");
         }
         if(param1 == "dragrot")
         {
            PhysEditor.CursorText_Set("drag to rotate");
         }
         if(param1 == "dragscale")
         {
            PhysEditor.CursorText_Set("drag to scale");
         }
      }
   }
}

