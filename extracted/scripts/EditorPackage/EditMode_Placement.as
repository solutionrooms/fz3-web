package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EditMode_Placement extends EditMode_Base
   {
      
      public function EditMode_Placement()
      {
         super();
      }
      
      override public function EnterMode() : void
      {
      }
      
      override public function InitOnce() : void
      {
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         var _loc5_:PhysObj = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:LevelObj_Instance = null;
         var _loc9_:PhysObj = null;
         var _loc10_:Point = null;
         var _loc11_:int = 0;
         super.OnMouseDown(param1);
         PhysEditor.UndoTakeSnapshot();
         var _loc2_:Array = PhysEditor.GetCurrentLevelInstances();
         var _loc3_:Number = mxs;
         var _loc4_:Number = mys;
         for each(_loc6_ in PhysEditor.currentPieceList)
         {
            _loc5_ = Game.objectDefs.GetByIndex(_loc6_.id);
            _loc7_ = _loc5_.name;
            if(KeyReader.Down(KeyReader.KEY_1))
            {
               _loc10_ = PhysEditor.SnapToObjects(mxs,mys);
               if(_loc10_ != null)
               {
                  Utils.trace("snapped to point :" + mxs + " " + mys + "   ->   " + _loc10_.x + " " + _loc10_.y);
                  _loc3_ = _loc10_.x;
                  _loc4_ = _loc10_.y;
               }
            }
            _loc8_ = Levels.CreateLevelObjInstanceAt(_loc7_,_loc3_ + _loc6_.xoff,_loc4_ + _loc6_.yoff,_loc6_.rot,_loc6_.scale,"",_loc6_.initParams);
            _loc9_ = Game.objectDefs.FindByName(_loc7_);
            if(_loc9_ != null)
            {
               _loc8_.objParameters.ClearAll();
               _loc11_ = 0;
               while(_loc11_ < _loc5_.instanceParams.length)
               {
                  _loc8_.objParameters.Add(_loc5_.instanceParams[_loc11_],_loc5_.instanceParamsDefaults[_loc11_]);
                  _loc11_++;
               }
            }
            _loc2_.push(_loc8_);
            PhysEditor.SetCurrentLevelInstances(_loc2_);
         }
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseWheel(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         if(KeyReader.Down(KeyReader.KEY_SHIFT))
         {
            _loc2_ = 1;
            if(KeyReader.Down(KeyReader.KEY_CONTROL) == false)
            {
               _loc2_ *= 10;
            }
            _loc3_ = 0;
            if(param1 > 0)
            {
               _loc3_ = _loc2_;
            }
            if(param1 < 0)
            {
               _loc3_ = -_loc2_;
            }
            PhysEditor.UndoTakeSnapshot();
            this.CurrenPiece_AddRot(_loc3_);
         }
         else if(KeyReader.Down(KeyReader.KEY_CONTROL))
         {
            _loc2_ = 0.1;
            _loc3_ = 0;
            if(param1 > 0)
            {
               _loc3_ = _loc2_;
            }
            if(param1 < 0)
            {
               _loc3_ = -_loc2_;
            }
            PhysEditor.UndoTakeSnapshot();
            this.CurrenPiece_AddScale(_loc3_);
         }
         else
         {
            if(param1 > 0)
            {
               this.IncCurrentPiece();
            }
            if(param1 < 0)
            {
               this.DecCurrentPiece();
            }
         }
      }
      
      override public function Update() : void
      {
         var _loc1_:LevelObj_Instance = null;
         var _loc2_:Number = NaN;
         if(KeyReader.Down(KeyReader.KEY_P) == true)
         {
            _loc1_ = PhysEditor.HitTestPhysObjGraphics(mx,my);
            if(_loc1_)
            {
               PhysEditor.ClearCurrentPieces();
               PhysEditor.AddCurrentPiece(Game.objectDefs.FindIndexByName(_loc1_.typeName),0,0,0,_loc1_.x,_loc1_.y,_loc1_.objParameters.ToString());
            }
         }
         if(KeyReader.Down(KeyReader.KEY_SHIFT) == true)
         {
            if(KeyReader.Pressed(KeyReader.KEY_UP))
            {
               PhysEditor.UndoTakeSnapshot();
               this.IncCurrentPiece();
            }
            if(KeyReader.Pressed(KeyReader.KEY_DOWN))
            {
               PhysEditor.UndoTakeSnapshot();
               this.DecCurrentPiece();
            }
            _loc2_ = 1;
            if(KeyReader.Down(KeyReader.KEY_CONTROL) == false)
            {
               _loc2_ *= 10;
            }
            if(KeyReader.Down(KeyReader.KEY_LEFT))
            {
               PhysEditor.UndoTakeSnapshot();
               this.CurrenPiece_AddRot(-_loc2_);
            }
            if(KeyReader.Down(KeyReader.KEY_RIGHT))
            {
               PhysEditor.UndoTakeSnapshot();
               this.CurrenPiece_AddRot(_loc2_);
            }
         }
      }
      
      override public function Render(param1:BitmapData) : void
      {
         var _loc2_:PhysObj = null;
         var _loc3_:Object = null;
         var _loc4_:Point = null;
         super.Render(param1);
         param1.fillRect(Defs.screenRect,4282668390);
         PhysEditor.RenderBackground(param1);
         PhysEditor.Editor_RenderObjects();
         PhysEditor.Editor_RenderJoints(param1);
         PhysEditor.Editor_RenderMiniMap();
         PhysEditor.Editor_RenderLines();
         for each(_loc3_ in PhysEditor.currentPieceList)
         {
            _loc2_ = Game.objectDefs.GetByIndex(_loc3_.id);
            _loc4_ = PhysEditor.GetMapPos(mxs + _loc3_.xoff,mys + _loc3_.yoff);
            PhysObj.RenderAt(_loc2_,_loc4_.x,_loc4_.y,_loc3_.rot,_loc3_.scale * PhysEditor.zoom,param1,PhysEditor.linesScreen.graphics,true);
         }
         PhysEditor.Editor_RenderGrid(param1);
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         var _loc4_:Object = null;
         var _loc5_:PhysObj = null;
         var _loc3_:String = "";
         for each(_loc4_ in PhysEditor.currentPieceList)
         {
            _loc5_ = Game.objectDefs.GetByIndex(_loc4_.id);
            _loc3_ += _loc5_.name + " ";
         }
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "ScrollPos: " + Math.round(PhysEditor.scrollX) + " " + Math.round(PhysEditor.scrollY);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "CursorPos: " + int(MouseControl.x + PhysEditor.scrollX) + " " + int(MouseControl.y + PhysEditor.scrollY);
         param2 += PhysEditor.AddInfoText("a",param1,param2,_loc3_);
         _loc3_ = "P: Pick a piece";
         return int(param2 + PhysEditor.AddInfoText("a",param1,param2,_loc3_));
      }
      
      internal function CurrenPiece_AddScale(param1:Number) : *
      {
         var _loc2_:Object = null;
         for each(_loc2_ in PhysEditor.currentPieceList)
         {
            _loc2_.scale += Number(param1);
         }
      }
      
      internal function CurrenPiece_AddRot(param1:Number) : *
      {
         var _loc2_:Object = null;
         for each(_loc2_ in PhysEditor.currentPieceList)
         {
            _loc2_.rot += Number(param1);
         }
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
      }
   }
}

