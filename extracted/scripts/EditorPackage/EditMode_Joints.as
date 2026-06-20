package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EditMode_Joints extends EditMode_Base
   {
      
      internal var addlineActive:Boolean;
      
      internal var newLineType:int;
      
      internal var hoveredLine:PhysLine;
      
      internal var selectedJoint:PhysObj_Joint;
      
      internal var copiedParameters:ObjParameters;
      
      internal var currentJoint:PhysObj_Joint = null;
      
      internal var subMode:String;
      
      public function EditMode_Joints()
      {
         super();
      }
      
      override public function EnterMode() : void
      {
         PhysEditor.CursorText_Show();
         PhysEditor.CursorText_Set("");
         this.SetSubMode("null");
         this.selectedJoint = null;
         this.hoveredLine = null;
      }
      
      override public function InitOnce() : void
      {
         this.copiedParameters = null;
      }
      
      public function UpdateJoints_ObjectDeleted(param1:String) : *
      {
         var _loc4_:PhysObj_Joint = null;
         if(param1 == "")
         {
            return;
         }
         var _loc2_:Array = GetCurrentLevelJoints();
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.obj0Name == param1 || _loc4_.obj1Name == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         for each(_loc4_ in _loc3_)
         {
            _loc2_.splice(_loc2_.indexOf(_loc4_),1);
         }
      }
      
      public function UpdateJoints_ObjectMoved(param1:String, param2:Number, param3:Number) : *
      {
         var _loc5_:PhysObj_Joint = null;
         if(param1 == "")
         {
            return;
         }
         var _loc4_:Array = GetCurrentLevelJoints();
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.type == PhysObj_Joint.Type_Distance)
            {
               if(_loc5_.obj0Name == param1)
               {
                  _loc5_.dist_pos0.x += param2;
                  _loc5_.dist_pos0.y += param3;
               }
               if(_loc5_.obj1Name == param1)
               {
                  _loc5_.dist_pos1.x += param2;
                  _loc5_.dist_pos1.y += param3;
               }
            }
         }
      }
      
      internal function RemoveAllJoints() : *
      {
         PhysEditor.GetCurrentLevel().joints = new Array();
      }
      
      internal function GetJointAtPosition(param1:int, param2:int) : PhysObj_Joint
      {
         var _loc4_:PhysObj_Joint = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:Array = GetCurrentLevelJoints();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.type == PhysObj_Joint.Type_Rev)
            {
               _loc5_ = Utils.DistBetweenPoints(param1,param2,_loc4_.rev_pos.x,_loc4_.rev_pos.y);
               if(_loc5_ < 10)
               {
                  return _loc4_;
               }
            }
            if(_loc4_.type == PhysObj_Joint.Type_Distance)
            {
               _loc5_ = Utils.DistBetweenPoints(param1,param2,_loc4_.dist_pos0.x,_loc4_.dist_pos0.y);
               if(_loc5_ < 10)
               {
                  return _loc4_;
               }
               _loc5_ = Utils.DistBetweenPoints(param1,param2,_loc4_.dist_pos1.x,_loc4_.dist_pos1.y);
               if(_loc5_ < 10)
               {
                  return _loc4_;
               }
               _loc6_ = Collision.ClosestPointOnLine(_loc4_.dist_pos0.x,_loc4_.dist_pos0.y,_loc4_.dist_pos1.x,_loc4_.dist_pos1.y,param1,param2);
               if(_loc6_ >= 0 && _loc6_ <= 1)
               {
                  if(Utils.DistBetweenPoints(param1,param2,Collision.closestX,Collision.closestY) < 2)
                  {
                     return _loc4_;
                  }
               }
            }
            if(_loc4_.type == PhysObj_Joint.Type_Prismatic)
            {
               _loc6_ = Collision.ClosestPointOnLine(_loc4_.prism_pos.x,_loc4_.prism_pos.y,_loc4_.prism_pos1.x,_loc4_.prism_pos1.y,param1,param2);
               if(_loc6_ >= 0 && _loc6_ <= 1)
               {
                  if(Utils.DistBetweenPoints(param1,param2,Collision.closestX,Collision.closestY) < 2)
                  {
                     return _loc4_;
                  }
               }
            }
         }
         return null;
      }
      
      internal function RemoveJoint(param1:PhysObj_Joint) : *
      {
         var _loc2_:Array = GetCurrentLevelJoints();
         if(_loc2_.indexOf(param1) != -1)
         {
            _loc2_.splice(_loc2_.indexOf(param1),1);
         }
      }
      
      internal function AddRevoluteJoint(param1:Number, param2:Number) : PhysObj_Joint
      {
         var _loc3_:PhysObj_Joint = new PhysObj_Joint();
         _loc3_.SetType(PhysObj_Joint.Type_Rev);
         _loc3_.rev_pos = new Point(param1,param2);
         var _loc4_:Array = GetCurrentLevelJoints();
         _loc4_.push(_loc3_);
         Utils.trace("added revolute joint " + param1 + " " + param2);
         return _loc3_;
      }
      
      internal function AddPrismaticJoint(param1:Number, param2:Number) : PhysObj_Joint
      {
         var _loc3_:PhysObj_Joint = new PhysObj_Joint();
         _loc3_.SetType(PhysObj_Joint.Type_Prismatic);
         _loc3_.prism_pos = new Point(param1,param2);
         _loc3_.prism_pos1 = new Point(param1,param2);
         var _loc4_:Array = GetCurrentLevelJoints();
         _loc4_.push(_loc3_);
         Utils.trace("added prismatic joint " + param1 + " " + param2);
         return _loc3_;
      }
      
      internal function AddDistanceJoint() : PhysObj_Joint
      {
         var _loc1_:PhysObj_Joint = new PhysObj_Joint();
         _loc1_.SetType(PhysObj_Joint.Type_Distance);
         var _loc2_:Array = GetCurrentLevelJoints();
         _loc2_.push(_loc1_);
         Utils.trace("added distance joint");
         return _loc1_;
      }
      
      internal function CopyParameters(param1:PhysObj_Joint) : *
      {
         if(param1 == null)
         {
            return;
         }
         this.copiedParameters = param1.objParameters.Clone();
      }
      
      internal function PasteParameters(param1:PhysObj_Joint) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(this.copiedParameters == null)
         {
            return;
         }
         param1.objParameters = this.copiedParameters.Clone();
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:LevelObj_Instance = null;
         var _loc3_:PhysLine = null;
         var _loc4_:PhysObj_Joint = null;
         super.OnMouseDown(param1);
         if(this.subMode == "delete")
         {
            PhysEditor.UndoTakeSnapshot();
            _loc4_ = this.GetJointAtPosition(mxs,mys);
            if(_loc4_ != null)
            {
               this.RemoveJoint(_loc4_);
               this.SetSubMode("null");
            }
         }
         else if(this.subMode == "copy")
         {
            _loc4_ = this.GetJointAtPosition(mxs,mys);
            if(_loc4_ != null)
            {
               this.CopyParameters(_loc4_);
               this.SetSubMode("null");
            }
         }
         else if(this.subMode == "paste")
         {
            _loc4_ = this.GetJointAtPosition(mxs,mys);
            if(_loc4_ != null)
            {
               this.PasteParameters(_loc4_);
               this.SetSubMode("null");
            }
         }
         else if(this.subMode == "newrev")
         {
            PhysEditor.UndoTakeSnapshot();
            this.currentJoint = this.AddRevoluteJoint(mxs,mys);
            this.SetSubMode("firstrev");
         }
         else if(this.subMode == "newprism")
         {
            PhysEditor.UndoTakeSnapshot();
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
            this.currentJoint = this.AddPrismaticJoint(mxs,mys);
            if(_loc2_)
            {
               if(_loc2_.id == "")
               {
                  _loc2_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj0Name = _loc2_.id;
               this.SetSubMode("secondprism");
            }
            else if(_loc3_ != null)
            {
               if(_loc3_.id == "")
               {
                  _loc3_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj0Name = _loc3_.id;
               this.SetSubMode("secondprism");
            }
            else
            {
               this.SetSubMode("secondprism");
            }
         }
         else if(this.subMode == "secondprism")
         {
            PhysEditor.UndoTakeSnapshot();
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
            if(_loc2_)
            {
               if(_loc2_.id == "")
               {
                  _loc2_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj1Name = _loc2_.id;
               this.SetSubMode("firstprismaxis");
            }
            else if(_loc3_ != null)
            {
               if(_loc3_.id == "")
               {
                  _loc3_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj1Name = _loc3_.id;
               this.SetSubMode("firstprismaxis");
            }
            else
            {
               this.SetSubMode("firstprismaxis");
            }
         }
         else if(this.subMode == "firstprismaxis")
         {
            this.currentJoint.prism_pos = new Point(mxs,mys);
            this.SetSubMode("secondprismaxis");
         }
         else if(this.subMode == "secondprismaxis")
         {
            this.currentJoint.prism_pos1 = new Point(mxs,mys);
            this.SetSubMode("null");
         }
         else if(this.subMode == "newdist")
         {
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
            if(_loc2_)
            {
               PhysEditor.UndoTakeSnapshot();
               this.currentJoint = this.AddDistanceJoint();
               if(_loc2_.id == "")
               {
                  _loc2_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj0Name = _loc2_.id;
               this.currentJoint.dist_pos0.x = mxs;
               this.currentJoint.dist_pos0.y = mys;
               this.currentJoint.obj1Name = _loc2_.id;
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
               this.SetSubMode("seconddist");
            }
            else if(_loc3_ != null)
            {
               PhysEditor.UndoTakeSnapshot();
               this.currentJoint = this.AddDistanceJoint();
               if(_loc3_.id == "")
               {
                  _loc3_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj0Name = _loc3_.id;
               this.currentJoint.dist_pos0.x = mxs;
               this.currentJoint.dist_pos0.y = mys;
               this.currentJoint.obj1Name = _loc3_.id;
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
               this.SetSubMode("seconddist");
            }
            else
            {
               PhysEditor.UndoTakeSnapshot();
               this.currentJoint = this.AddDistanceJoint();
               this.currentJoint.dist_pos0.x = mxs;
               this.currentJoint.dist_pos0.y = mys;
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
               this.SetSubMode("seconddist");
            }
         }
         else if(this.subMode == "firstrev")
         {
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
            if(_loc2_)
            {
               if(_loc2_.id == "")
               {
                  _loc2_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj0Name = _loc2_.id;
               this.SetSubMode("secondrev");
            }
            else if(_loc3_ != null)
            {
               if(_loc3_.id == "")
               {
                  _loc3_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj0Name = _loc3_.id;
               Utils.trace("picked line 1 " + _loc3_.id);
               this.SetSubMode("secondrev");
            }
            else
            {
               this.SetSubMode("secondrev");
            }
         }
         else if(this.subMode == "secondrev")
         {
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
            if(_loc2_)
            {
               if(_loc2_.id == "")
               {
                  _loc2_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj1Name = _loc2_.id;
               this.SetSubMode("null");
            }
            else if(_loc3_ != null)
            {
               if(_loc3_.id == "")
               {
                  _loc3_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj1Name = _loc3_.id;
               Utils.trace("picked line 2 " + _loc3_.id);
               this.SetSubMode("null");
            }
            else
            {
               this.SetSubMode("null");
            }
         }
         else
         {
            this.selectedJoint = this.GetJointAtPosition(mxs,mys);
            if(this.selectedJoint != null)
            {
               EditParams.AddParameterListBox(this.selectedJoint.objParameters);
            }
            else
            {
               EditParams.ClearParameterListBox();
            }
         }
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:LevelObj_Instance = null;
         var _loc3_:PhysLine = null;
         super.OnMouseUp(param1);
         if(this.subMode == "seconddist")
         {
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
            if(_loc2_)
            {
               if(_loc2_.id == "")
               {
                  _loc2_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj1Name = _loc2_.id;
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
               this.SetSubMode("null");
            }
            else if(_loc3_ != null)
            {
               if(_loc3_.id == "")
               {
                  _loc3_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj1Name = _loc3_.id;
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
               this.SetSubMode("null");
            }
            else
            {
               this.currentJoint.obj1Name = "";
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
               this.SetSubMode("null");
            }
         }
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:LevelObj_Instance = null;
         var _loc3_:PhysLine = null;
         super.OnMouseMove(param1);
         this.hoveredLine = null;
         this.hoveredLine = PhysEditor.HitTestLineArea(mxs,mys);
         var _loc4_:Level = GetCurrentLevel();
         if(param1.buttonDown == false)
         {
            if(this.subMode == "newdist")
            {
               _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
               _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
               if(_loc2_)
               {
                  PhysEditor.CursorText_Set("[DIST] First Object: Obj: " + _loc2_.typeName);
               }
               else if(_loc3_ != null)
               {
                  PhysEditor.CursorText_Set("[DIST] First Object: Poly");
               }
               else
               {
                  PhysEditor.CursorText_Set("[DIST] First Object: BG");
               }
            }
            else if(this.subMode == "firstrev")
            {
               _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
               _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
               if(_loc2_)
               {
                  PhysEditor.CursorText_Set("First Object: Obj: " + _loc2_.typeName);
               }
               else if(_loc3_ != null)
               {
                  PhysEditor.CursorText_Set("First Object: Poly");
               }
               else
               {
                  PhysEditor.CursorText_Set("First Object: BG");
               }
            }
            else if(this.subMode == "secondrev")
            {
               _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
               _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
               if(_loc2_)
               {
                  PhysEditor.CursorText_Set("Second Object: Obj: " + _loc2_.typeName);
               }
               else if(_loc3_ != null)
               {
                  PhysEditor.CursorText_Set("Second Object: Poly");
               }
               else
               {
                  PhysEditor.CursorText_Set("Second Object: BG");
               }
            }
            return;
         }
         if(this.subMode == "seconddist")
         {
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            _loc3_ = PhysEditor.HitTestLineArea(mxs,mys);
            if(_loc2_)
            {
               PhysEditor.CursorText_Set("[DIST] Second Object: Obj: " + _loc2_.typeName);
            }
            else if(_loc3_ != null)
            {
               PhysEditor.CursorText_Set("[DIST] Second Object: Poly");
            }
            else
            {
               PhysEditor.CursorText_Set("[DIST] Second Object: BG");
            }
         }
         if(this.subMode == "seconddist")
         {
            _loc2_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            if(_loc2_)
            {
               if(_loc2_.id == "")
               {
                  _loc2_.id = PhysEditor.CreateNewUniqueID();
               }
               this.currentJoint.obj1Name = _loc2_.id;
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
            }
            else
            {
               this.currentJoint.obj1Name = "";
               this.currentJoint.dist_pos1.x = mxs;
               this.currentJoint.dist_pos1.y = mys;
            }
         }
      }
      
      override public function OnMouseWheel(param1:int) : void
      {
      }
      
      internal function SetSubMode(param1:String) : *
      {
         this.subMode = param1;
         if(param1 == "newprism")
         {
            PhysEditor.CursorText_Set("new prismatic joint - first object");
         }
         if(param1 == "secondprism")
         {
            PhysEditor.CursorText_Set("prism select second object");
         }
         if(param1 == "firstprismaxis")
         {
            PhysEditor.CursorText_Set("prism select axis point A");
         }
         if(param1 == "secondprismaxis")
         {
            PhysEditor.CursorText_Set("prism select axis point A");
         }
         if(param1 == "seconddist")
         {
            PhysEditor.CursorText_Set("second dist point");
         }
         if(param1 == "firstrev")
         {
            PhysEditor.CursorText_Set("first object");
         }
         if(param1 == "secondrev")
         {
            PhysEditor.CursorText_Set("second object");
         }
         if(param1 == "null")
         {
            PhysEditor.CursorText_Set("");
         }
         if(param1 == "newrev")
         {
            PhysEditor.CursorText_Set("new revolute joint");
         }
         if(param1 == "newdist")
         {
            PhysEditor.CursorText_Set("new distance joint");
         }
         if(param1 == "delete")
         {
            PhysEditor.CursorText_Set("delete joint");
         }
         if(param1 == "copy")
         {
            PhysEditor.CursorText_Set("copy parameters");
         }
         if(param1 == "paste")
         {
            PhysEditor.CursorText_Set("paste parameters");
         }
      }
      
      override public function Update() : void
      {
         super.Update();
         if(this.subMode == "null" || this.subMode == "newdist" || this.subMode == "newrev" || this.subMode == "delete" || this.subMode == "copy" || this.subMode == "paste")
         {
            if(KeyReader.Down(KeyReader.KEY_C))
            {
               this.SetSubMode("copy");
            }
            else if(KeyReader.Down(KeyReader.KEY_V))
            {
               this.SetSubMode("paste");
            }
            else if(KeyReader.Pressed(KeyReader.KEY_D))
            {
               this.SetSubMode("newdist");
            }
            else if(!KeyReader.Down(KeyReader.KEY_D))
            {
               if(KeyReader.Down(KeyReader.KEY_R))
               {
                  this.SetSubMode("newrev");
               }
               else if(KeyReader.Down(KeyReader.KEY_P))
               {
                  this.SetSubMode("newprism");
               }
               else if(KeyReader.Down(KeyReader.KEY_DELETE) || KeyReader.Down(KeyReader.KEY_SQUIGGLE))
               {
                  this.SetSubMode("delete");
               }
               else
               {
                  this.SetSubMode("null");
               }
            }
         }
         if(KeyReader.Pressed(KeyReader.KEY_TAB) && KeyReader.Down(KeyReader.KEY_CONTROL))
         {
            PhysEditor.UndoTakeSnapshot();
            this.RemoveAllJoints();
         }
      }
      
      override public function Render(param1:BitmapData) : void
      {
         super.Render(param1);
         param1.fillRect(Defs.screenRect,4282668390);
         PhysEditor.RenderBackground(param1);
         PhysEditor.Editor_RenderObjects();
         PhysEditor.Editor_RenderJoints(param1);
         PhysEditor.Editor_RenderMiniMap();
         PhysEditor.Editor_RenderLines(false);
         PhysEditor.HighlightLinePoly(this.hoveredLine);
         PhysEditor.Editor_RenderGrid(param1);
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         var _loc3_:String = null;
         _loc3_ = "R: Add Revolute Joint";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "D: Add Distance Joint";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "P: Add Prismatic Joint";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "DEL: Delete Joint";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "C: Copy parameters";
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "V: Paste parameters";
         return int(param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_));
      }
   }
}

