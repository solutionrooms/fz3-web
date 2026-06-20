package EditorPackage
{
   import fl.controls.List;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.*;
   
   public class PhysEditor
   {
      
      internal static var infoTextFormat:TextFormat;
      
      internal static var infoTextFormat_Cursor:TextFormat;
      
      internal static var infoMC:MovieClip;
      
      internal static var screenBD:BitmapData;
      
      internal static var screenB:Bitmap;
      
      internal static var editorMC:MovieClip;
      
      public static var linesScreen:MovieClip;
      
      internal static var currentPieceList:Array;
      
      internal static var lineTypes:Array;
      
      internal static var lineColors:Array;
      
      internal static var lineModes:Array;
      
      internal static var hoverLineIndex:int;
      
      internal static var hoverPointIndex:int;
      
      public static var zoom:Number;
      
      internal static var undoList:Array;
      
      internal static var layers:Vector.<EditorLayer>;
      
      internal static var editModeObj_Library:EditMode_Library;
      
      internal static var editModeObj_Placement:EditMode_Placement;
      
      public static var editModeObj_Adjust:EditMode_Adjust;
      
      internal static var editModeObj_Lines:EditMode_Lines;
      
      internal static var editModeObj_Map:EditMode_Map;
      
      internal static var editModeObj_Joints:EditMode_Joints;
      
      internal static var editModeObj_ObjCol:EditMode_ObjCol;
      
      internal static var editModeObj_PickPieceForLink:EditMode_PickPieceForLink;
      
      internal static var editModeObj_PickLineForLink:EditMode_PickLineForLink;
      
      internal static var cursorTF:TextField;
      
      internal static var tf:TextField;
      
      internal static var AddTextEntry_Callback:Function;
      
      internal static var entryMC:MovieClip;
      
      internal static var guideLines:Array;
      
      internal static var mx:int;
      
      internal static var my:int;
      
      internal static var sx:Number;
      
      internal static var sy:Number;
      
      internal static var mxs:int;
      
      internal static var mys:int;
      
      internal static const editMode_Placement:int = 0;
      
      internal static const editMode_Library:int = 1;
      
      internal static const editMode_Commands1:int = 4;
      
      internal static const editMode_Adjust:int = 5;
      
      internal static const editMode_Lines:int = 6;
      
      internal static const editMode_Joints:int = 7;
      
      internal static const editMode_GridCommands:int = 8;
      
      internal static const editMode_ObjCol:int = 9;
      
      internal static const editMode_Map:int = 10;
      
      internal static const editMode_PickPieceForLink:int = 11;
      
      internal static const editMode_PickLineForLink:int = 12;
      
      public static var currentLevel:int = 0;
      
      internal static var updateTimer:int = 0;
      
      public static var oldEditMode:int = 0;
      
      public static var editMode:int = 0;
      
      internal static var editSubMode:int = 0;
      
      internal static var prevEditMode:int = 0;
      
      internal static var scrollX:Number = 0;
      
      internal static var scrollY:Number = 0;
      
      internal static var renderMiniMap:Boolean = false;
      
      internal static var renderObjects:Boolean = true;
      
      internal static var gridsnap:int = 20;
      
      internal static var gridMode_active:Boolean = false;
      
      internal static var gridMode_renderGrid:Boolean = false;
      
      internal static var objectZSortMode:Boolean = false;
      
      internal static var currentModeObject:EditMode_Base = new EditMode_Base();
      
      internal static const LM_FILL:int = 1;
      
      internal static const LM_LINK:int = 2;
      
      internal static const LM_NORMALS:int = 4;
      
      internal static var firstTime:Boolean = true;
      
      internal static var pickedPieceForLink:LevelObj_Instance = null;
      
      public static var isEntering:Boolean = false;
      
      internal static var listBox:List = null;
      
      internal static var listBoxContainer:MovieClip = null;
      
      public function PhysEditor()
      {
         super();
      }
      
      internal static function SetEditMode(param1:int, param2:Boolean = true) : *
      {
         KeyReader.Reset();
         editMode = param1;
         editSubMode = 0;
         currentModeObject = new EditMode_Base();
         if(editMode == editMode_Library)
         {
            currentModeObject = editModeObj_Library;
         }
         if(editMode == editMode_Placement)
         {
            currentModeObject = editModeObj_Placement;
         }
         if(editMode == editMode_Adjust)
         {
            currentModeObject = editModeObj_Adjust;
         }
         if(editMode == editMode_Lines)
         {
            currentModeObject = editModeObj_Lines;
         }
         if(editMode == editMode_Map)
         {
            currentModeObject = editModeObj_Map;
         }
         if(editMode == editMode_ObjCol)
         {
            currentModeObject = editModeObj_ObjCol;
         }
         if(editMode == editMode_PickPieceForLink)
         {
            currentModeObject = editModeObj_PickPieceForLink;
         }
         if(editMode == editMode_PickLineForLink)
         {
            currentModeObject = editModeObj_PickLineForLink;
         }
         if(editMode == editMode_Joints)
         {
            currentModeObject = editModeObj_Joints;
         }
         if(param2)
         {
            EditParams.ClearParameterListBox();
         }
         currentModeObject.EnterMode();
      }
      
      public static function InitEditor(param1:Number, param2:Number) : void
      {
         if(firstTime)
         {
            InitEditorOnce();
         }
         Mouse.show();
         PhysicsBase.InitBox2D();
         GameObjects.ClearAll();
         updateTimer = 0;
         currentPieceList = new Array();
         AddCurrentPiece(0,0,0,0,0,0);
         currentLevel = Levels.currentIndex;
         zoom = 1;
         MouseControl.SetWheelHandler(EditorWheelHandler);
         undoList = new Array();
         linesScreen = new MovieClip();
         linesScreen.graphics.clear();
         hoverLineIndex = -1;
         hoverPointIndex = -1;
         scrollX = param1;
         scrollY = param2;
         AddDataGrid(0,300);
         editorMC = new MovieClip();
         editorMC.addEventListener(MouseEvent.MOUSE_DOWN,Editor_OnMouseDown);
         editorMC.addEventListener(MouseEvent.MOUSE_UP,Editor_OnMouseUp);
         editorMC.addEventListener(MouseEvent.MOUSE_MOVE,Editor_OnMouseMove);
         editorMC.addEventListener(Event.ENTER_FRAME,OnEnterFrame);
         screenBD = new BitmapData(Defs.displayarea_w,Defs.displayarea_h,false,16720435);
         screenB = new Bitmap(screenBD);
         infoMC = new MovieClip();
         ClearInfoMC();
         editorMC.addChild(screenB);
         editorMC.addChild(infoMC);
         Game.main.addChild(editorMC);
         InitInfoTextFormat();
         CursorText_Init();
         CursorText_Hide();
         SetEditMode(editMode);
      }
      
      public static function InitEditorOnce() : void
      {
         firstTime = false;
         Mouse.show();
         PhysicsBase.InitBox2D();
         GameObjects.ClearAll();
         updateTimer = 0;
         currentPieceList = new Array();
         AddCurrentPiece(0,0,0,0,0,0);
         currentLevel = Levels.currentIndex;
         layers = new Vector.<EditorLayer>();
         layers.push(new EditorLayer(0,"Layer 1"));
         layers.push(new EditorLayer(1,"Layer 2"));
         layers.push(new EditorLayer(2,"Layer 3"));
         layers.push(new EditorLayer(3,"Layer 4"));
         MouseControl.SetWheelHandler(EditorWheelHandler);
         editModeObj_Library = new EditMode_Library();
         editModeObj_Library.InitOnce();
         editModeObj_Placement = new EditMode_Placement();
         editModeObj_Placement.InitOnce();
         editModeObj_Adjust = new EditMode_Adjust();
         editModeObj_Adjust.InitOnce();
         editModeObj_Lines = new EditMode_Lines();
         editModeObj_Lines.InitOnce();
         editModeObj_Map = new EditMode_Map();
         editModeObj_Map.InitOnce();
         editModeObj_Joints = new EditMode_Joints();
         editModeObj_Joints.InitOnce();
         editModeObj_ObjCol = new EditMode_ObjCol();
         editModeObj_ObjCol.InitOnce();
         editModeObj_PickPieceForLink = new EditMode_PickPieceForLink();
         editModeObj_PickPieceForLink.InitOnce();
         editModeObj_PickLineForLink = new EditMode_PickLineForLink();
         editModeObj_PickLineForLink.InitOnce();
         lineTypes = new Array();
         lineColors = new Array();
         lineModes = new Array();
         lineTypes.push("polygon");
         lineColors.push(16777215);
         lineModes.push(LM_FILL | LM_NORMALS | LM_LINK);
         lineTypes.push("path");
         lineColors.push(2105599);
         lineModes.push(0);
         undoList = new Array();
         linesScreen = new MovieClip();
         linesScreen.graphics.clear();
         hoverLineIndex = -1;
         hoverPointIndex = -1;
         scrollX = 0;
         scrollY = 0;
         editMode = editMode_Placement;
      }
      
      public static function GetLayerName(param1:int) : String
      {
         return layers[param1].name;
      }
      
      public static function ToggleLayerVisibility(param1:int) : *
      {
         layers[param1].ToggleVisibility();
      }
      
      public static function ToggleLayerLocked(param1:int) : *
      {
         layers[param1].ToggleLocked();
      }
      
      public static function IsLayerVisible(param1:int) : Boolean
      {
         return layers[param1].IsVisible();
      }
      
      internal static function CloseEditor() : *
      {
         editorMC.removeEventListener(MouseEvent.MOUSE_DOWN,Editor_OnMouseDown);
         editorMC.removeEventListener(MouseEvent.MOUSE_UP,Editor_OnMouseUp);
         editorMC.removeEventListener(MouseEvent.MOUSE_MOVE,Editor_OnMouseMove);
         editorMC.removeEventListener(Event.ENTER_FRAME,OnEnterFrame);
         Game.main.removeChild(editorMC);
         editorMC.removeChild(screenB);
         editorMC.removeChild(infoMC);
         screenBD = null;
         screenB = null;
         infoMC = null;
         editorMC = null;
      }
      
      internal static function ClearInfoMC() : *
      {
         var _loc1_:* = 0;
         _loc1_ = int(infoMC.numChildren - 1);
         while(_loc1_ >= 0)
         {
            infoMC.removeChildAt(_loc1_);
            _loc1_--;
         }
      }
      
      internal static function OnEnterFrame(param1:Event) : *
      {
         var _loc2_:Graphics = Game.fillScreenMC.graphics;
         _loc2_.clear();
         RenderEditor();
      }
      
      internal static function GetLineTypeMode(param1:int) : int
      {
         if(param1 < 0)
         {
            return 0;
         }
         if(param1 >= lineModes.length)
         {
            return 0;
         }
         return lineModes[param1];
      }
      
      internal static function GetLineTypeColor(param1:int) : uint
      {
         if(param1 < 0)
         {
            return 16777215;
         }
         if(param1 >= lineColors.length)
         {
            return 16777215;
         }
         return lineColors[param1];
      }
      
      internal static function GetLineTypeString(param1:int) : String
      {
         if(param1 < 0)
         {
            return "UNDEFINED";
         }
         if(param1 >= lineTypes.length)
         {
            return "UNDEFINED";
         }
         return lineTypes[param1];
      }
      
      internal static function GetInstanceById(param1:String) : LevelObj_Instance
      {
         var _loc3_:LevelObj_Instance = null;
         var _loc2_:Array = GetCurrentLevelInstances();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      internal static function Editor_OnMouseDown(param1:MouseEvent) : void
      {
         currentModeObject.OnMouseDown(param1);
      }
      
      internal static function Editor_OnMouseUp(param1:MouseEvent) : void
      {
         currentModeObject.OnMouseUp(param1);
      }
      
      internal static function Editor_OnMouseMove(param1:MouseEvent) : void
      {
         currentModeObject.OnMouseMove(param1);
      }
      
      internal static function ClearCurrentPieces() : void
      {
         currentPieceList = new Array();
      }
      
      internal static function AddCurrentPiece(param1:int, param2:Number, param3:Number, param4:Number, param5:Number = 0, param6:Number = 0, param7:String = "") : *
      {
         var _loc8_:Object = new Object();
         _loc8_.id = param1;
         _loc8_.rot = Number(param2);
         _loc8_.xoff = Number(param3);
         _loc8_.yoff = Number(param4);
         _loc8_.origx = Number(param5);
         _loc8_.origy = Number(param6);
         _loc8_.scale = 1;
         _loc8_.initParams = param7;
         currentPieceList.push(_loc8_);
      }
      
      internal static function GetCurrentPieceInitialPos() : Point
      {
         if(currentPieceList.length == 0)
         {
            return new Point(0,0);
         }
         var _loc1_:Object = currentPieceList[0];
         return new Point(_loc1_.origx,_loc1_.origy);
      }
      
      public static function ClearEditorMode() : void
      {
         EditParams.ClearParameterListBox();
         KeyReader.Reset();
      }
      
      public static function UpdateEditor() : void
      {
         var _loc7_:PhysObj = null;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(isEntering)
         {
            return;
         }
         ++updateTimer;
         var _loc1_:int = MouseControl.x;
         var _loc2_:int = MouseControl.y;
         CursorText_SetPos(_loc1_,_loc2_);
         if(gridMode_active)
         {
            _loc1_ = Math.floor(_loc1_);
            _loc2_ = Math.floor(_loc2_);
            _loc1_ = int(_loc1_ / gridsnap) * int(gridsnap);
            _loc2_ = int(_loc2_ / gridsnap) * int(gridsnap);
         }
         var _loc3_:Number = scrollX;
         var _loc4_:Number = scrollY;
         if(gridMode_active)
         {
            _loc3_ = Math.floor(_loc3_);
            _loc4_ = Math.floor(_loc4_);
            _loc3_ = int(_loc3_ / gridsnap) * int(gridsnap);
            _loc4_ = int(_loc4_ / gridsnap) * int(gridsnap);
         }
         var _loc5_:int = _loc1_ + _loc3_;
         var _loc6_:int = _loc2_ + _loc4_;
         var _loc8_:Level = GetCurrentLevel();
         Lines_GetCurrentPointUnderCursor(_loc5_,_loc6_);
         if(KeyReader.Pressed(KeyReader.KEY_1))
         {
            ToggleLayerVisibility(0);
         }
         if(KeyReader.Pressed(KeyReader.KEY_2))
         {
            ToggleLayerVisibility(1);
         }
         if(KeyReader.Pressed(KeyReader.KEY_3))
         {
            ToggleLayerVisibility(2);
         }
         if(KeyReader.Pressed(KeyReader.KEY_4))
         {
            ToggleLayerVisibility(3);
         }
         if(KeyReader.Pressed(KeyReader.KEY_G))
         {
            gridMode_active = gridMode_active == false;
         }
         if(KeyReader.Pressed(KeyReader.KEY_BACKSPACE))
         {
            scrollX = 0;
            scrollY = 0;
            zoom = 1;
         }
         if(KeyReader.Pressed(KeyReader.KEY_F1))
         {
            SetEditMode(editMode_Placement);
         }
         if(KeyReader.Pressed(KeyReader.KEY_F2))
         {
            SetEditMode(editMode_Library);
         }
         if(KeyReader.Pressed(KeyReader.KEY_F3))
         {
            SetEditMode(editMode_Map);
         }
         if(KeyReader.Pressed(KeyReader.KEY_F4))
         {
            SetEditMode(editMode_ObjCol);
         }
         if(KeyReader.Pressed(KeyReader.KEY_F5))
         {
            SetEditMode(editMode_Adjust);
         }
         if(KeyReader.Pressed(KeyReader.KEY_F6))
         {
            SetEditMode(editMode_Lines);
         }
         if(KeyReader.Pressed(KeyReader.KEY_F7))
         {
            SetEditMode(editMode_Joints);
         }
         if(KeyReader.Pressed(KeyReader.KEY_F8))
         {
            ClearEditorMode();
            _loc10_ = ExportLevelAsXml();
            ExternalData.OutputString(_loc10_);
            return;
         }
         if(KeyReader.Pressed(KeyReader.KEY_F9))
         {
            ClearEditorMode();
            _loc10_ = ExportLevelAsXml();
            ExternalData.OutputString(_loc10_);
            CloseEditor();
            Game.StartLevelPlay();
            return;
         }
         var _loc9_:Number = 0;
         if(KeyReader.Down(KeyReader.KEY_MINUS))
         {
            _loc9_ = -0.1;
         }
         if(KeyReader.Down(KeyReader.KEY_EQUALS))
         {
            _loc9_ = 0.1;
         }
         if(_loc9_ != 0)
         {
            _loc11_ = 1 / zoom;
            _loc12_ = MouseControl.x;
            _loc13_ = MouseControl.y;
            scrollX += _loc12_ * _loc11_;
            scrollY += _loc13_ * _loc11_;
            zoom += _loc9_;
            zoom = Utils.LimitNumber(0.01,10,zoom);
            _loc11_ = 1 / zoom;
            scrollX -= _loc12_ * _loc11_;
            scrollY -= _loc13_ * _loc11_;
         }
         if(editMode == editMode_Commands1)
         {
            if(KeyReader.Pressed(KeyReader.KEY_9))
            {
               _loc10_ = ExportLevelAsXml();
               ExternalData.OutputString(_loc10_);
               CloseEditor();
               Game.StartLevelPlay();
               return;
            }
            if(KeyReader.Pressed(KeyReader.KEY_4))
            {
               KeyReader.ClearKey(KeyReader.KEY_4);
               _loc10_ = ExportLevelAsXml();
               ExternalData.OutputString(_loc10_);
               SetEditMode(prevEditMode);
               return;
            }
            if(KeyReader.Pressed(KeyReader.KEY_5))
            {
               KeyReader.ClearKey(KeyReader.KEY_5);
               ExportAllLevelsAsXml();
               SetEditMode(prevEditMode);
               return;
            }
            if(KeyReader.Pressed(KeyReader.KEY_SPACE))
            {
               SetEditMode(editMode_GridCommands);
            }
            return;
         }
         if(editMode == editMode_GridCommands)
         {
            if(KeyReader.Pressed(KeyReader.KEY_1))
            {
               gridMode_active = gridMode_active == false;
            }
            if(KeyReader.Pressed(KeyReader.KEY_2))
            {
               gridMode_renderGrid = gridMode_renderGrid == false;
            }
            if(KeyReader.Pressed(KeyReader.KEY_3))
            {
               objectZSortMode = objectZSortMode == false;
            }
            if(KeyReader.Pressed(KeyReader.KEY_4))
            {
               renderMiniMap = renderMiniMap == false;
            }
            if(KeyReader.Pressed(KeyReader.KEY_5))
            {
               renderObjects = renderObjects == false;
            }
            if(KeyReader.Pressed(KeyReader.KEY_SPACE))
            {
               SetEditMode(prevEditMode);
            }
            return;
         }
         if(KeyReader.Pressed(KeyReader.KEY_U))
         {
            DoUndo();
         }
         currentModeObject.Update();
         UpdateScroll();
      }
      
      internal static function EditorWheelHandler(param1:int) : *
      {
         currentModeObject.OnMouseWheel(param1);
      }
      
      internal static function Lines_GetCurrentPointUnderCursor(param1:Number, param2:Number) : *
      {
         var _loc5_:PhysLine = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc3_:Level = GetCurrentLevel();
         var _loc4_:int = 0;
         hoverLineIndex = -1;
         hoverPointIndex = -1;
         for each(_loc5_ in _loc3_.lines)
         {
            _loc6_ = 0;
            for each(_loc7_ in _loc5_.points)
            {
               if(Utils.DistBetweenPoints(_loc7_.x,_loc7_.y,param1,param2) < 3)
               {
                  hoverLineIndex = _loc4_;
                  hoverPointIndex = _loc6_;
                  return;
               }
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      internal static function UpdateScroll() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(KeyReader.Down(KeyReader.KEY_SHIFT) == false)
         {
            _loc1_ = 32;
            _loc2_ = 0;
            _loc3_ = 0;
            if(KeyReader.Down(KeyReader.KEY_CONTROL))
            {
               _loc1_ = 4;
            }
            if(KeyReader.Down(KeyReader.KEY_LEFT))
            {
               _loc2_ = -_loc1_;
            }
            if(KeyReader.Down(KeyReader.KEY_RIGHT))
            {
               _loc2_ = _loc1_;
            }
            if(KeyReader.Down(KeyReader.KEY_UP))
            {
               _loc3_ = -_loc1_;
            }
            if(KeyReader.Down(KeyReader.KEY_DOWN))
            {
               _loc3_ = _loc1_;
            }
            scrollX += _loc2_;
            scrollY += _loc3_;
         }
      }
      
      internal static function CursorText_Set(param1:String) : *
      {
         cursorTF.text = param1;
         cursorTF.setTextFormat(infoTextFormat_Cursor);
      }
      
      internal static function CursorText_Show() : *
      {
         cursorTF.visible = true;
      }
      
      internal static function CursorText_Hide() : *
      {
         cursorTF.visible = false;
      }
      
      internal static function CursorText_SetPos(param1:int, param2:int) : *
      {
         cursorTF.x = param1 + 10;
         cursorTF.y = param2 - 10;
      }
      
      internal static function CursorText_Init() : *
      {
         cursorTF = new TextField();
         cursorTF.type = TextFieldType.DYNAMIC;
         cursorTF.x = 300;
         cursorTF.y = 300;
         cursorTF.text = "cursor here";
         cursorTF.background = false;
         infoTextFormat_Cursor.align = TextFormatAlign.LEFT;
         cursorTF.autoSize = TextFieldAutoSize.LEFT;
         cursorTF.setTextFormat(infoTextFormat_Cursor);
         cursorTF.antiAliasType = AntiAliasType.ADVANCED;
         cursorTF.name = "cursorTF";
         cursorTF.selectable = false;
         cursorTF.mouseEnabled = false;
         editorMC.addChild(cursorTF);
      }
      
      internal static function AddInfoText(param1:String, param2:int, param3:int, param4:String, param5:String = "left", param6:String = null) : int
      {
         tf = new TextField();
         tf.type = TextFieldType.DYNAMIC;
         tf.x = param2;
         tf.y = param3;
         tf.text = param4;
         tf.background = false;
         if(param5 == "left")
         {
            infoTextFormat.align = TextFormatAlign.LEFT;
            tf.autoSize = TextFieldAutoSize.LEFT;
         }
         if(param5 == "right")
         {
            infoTextFormat.align = TextFormatAlign.RIGHT;
            tf.autoSize = TextFieldAutoSize.RIGHT;
         }
         tf.setTextFormat(infoTextFormat);
         tf.antiAliasType = AntiAliasType.ADVANCED;
         tf.name = param1;
         tf.selectable = false;
         tf.mouseEnabled = false;
         infoMC.addChild(tf);
         return tf.height - 6;
      }
      
      internal static function InitInfoTextFormat() : *
      {
         infoTextFormat = new TextFormat();
         infoTextFormat.size = 10;
         infoTextFormat.color = 16777215;
         infoTextFormat.font = "Arial";
         infoTextFormat_Cursor = new TextFormat();
         infoTextFormat_Cursor.size = 10;
         infoTextFormat_Cursor.color = 16777215;
         infoTextFormat_Cursor.font = "Arial";
      }
      
      internal static function RenderPanel_Editor() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         ClearInfoMC();
         _loc1_ = Defs.displayarea_w - 100;
         _loc2_ = Defs.displayarea_h - 20;
         var _loc5_:int = System.totalMemory / 1024;
         _loc3_ = "FPS: " + Utils.DP2(Game.main.fps).toString() + "  Mem: " + _loc5_;
         AddInfoText("fps",_loc1_,_loc2_,_loc3_,"right");
         _loc1_ = 10;
         _loc3_ = "Level: " + currentLevel + "   [ " + GetCurrentLevel().id + "  " + GetCurrentLevel().name + " ]";
         AddInfoText("level",_loc1_,_loc2_,_loc3_);
         _loc1_ = Defs.displayarea_w - 150;
         _loc2_ = 0;
         _loc3_ = "F1:Place | F2:Library | F3:Map | F4:ObjCol | F5:Adjust | F6:Lines | F7:Joints | F8:Save | F9:Save&Quit";
         AddInfoText("level",_loc1_,_loc2_,_loc3_,"right");
         _loc1_ = Defs.displayarea_w - 100;
         _loc2_ = 30;
         _loc3_ = GetLayerName(0) + " : " + (IsLayerVisible(0) ? "VIS" : "---");
         _loc2_ += AddInfoText("level",_loc1_,_loc2_,_loc3_,"right");
         _loc3_ = GetLayerName(1) + " : " + (IsLayerVisible(1) ? "VIS" : "---");
         _loc2_ += AddInfoText("level",_loc1_,_loc2_,_loc3_,"right");
         _loc3_ = GetLayerName(2) + " : " + (IsLayerVisible(2) ? "VIS" : "---");
         _loc2_ += AddInfoText("level",_loc1_,_loc2_,_loc3_,"right");
         _loc3_ = GetLayerName(3) + " : " + (IsLayerVisible(3) ? "VIS" : "---");
         _loc2_ += AddInfoText("level",_loc1_,_loc2_,_loc3_,"right");
         if(editMode == editMode_Commands1)
         {
            _loc3_ = "Editor: Mode = Commands1";
            _loc1_ = 10;
            _loc2_ = 10;
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            _loc1_ = 50;
            _loc2_ = 50;
            _loc3_ = "4: Export current level";
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            _loc3_ = "5: Export all levels";
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            _loc3_ = "9: Quit To Game";
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            return;
         }
         if(editMode == editMode_GridCommands)
         {
            _loc3_ = "Editor: Mode = Grid Commands / Misc";
            _loc1_ = 10;
            _loc2_ = 10;
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            _loc1_ = 50;
            _loc2_ = 50;
            _loc3_ = "1: Grid Active: " + gridMode_active;
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            _loc3_ = "2: Render Grid: " + gridMode_renderGrid;
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            _loc3_ = "3: Z Sort objects: " + objectZSortMode;
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            _loc3_ = "4: Minimap: " + renderMiniMap;
            _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
            return;
         }
         _loc3_ = "Editor: Mode = ";
         if(editMode == editMode_Placement)
         {
            _loc3_ += "Placement";
         }
         if(editMode == editMode_Map)
         {
            _loc3_ += "Mapper";
         }
         if(editMode == editMode_Library)
         {
            _loc3_ += "Library Page " + int(editModeObj_Library.library_page + 1).toString() + " / " + int(editModeObj_Library.GetNumLibraryPages()).toString() + "     " + editModeObj_Library.library_hoverPieceName;
         }
         if(editMode == editMode_ObjCol)
         {
            _loc3_ += "Object Collision";
         }
         if(editMode == editMode_Adjust)
         {
            _loc3_ += "Adjust";
         }
         if(editMode == editMode_Joints)
         {
            _loc3_ += "Joints";
         }
         if(editMode == editMode_Lines)
         {
            _loc3_ += "Lines";
         }
         if(editMode == editMode_PickPieceForLink)
         {
            _loc3_ += "Pick A Piece For Linkage";
         }
         if(editMode == editMode_PickLineForLink)
         {
            _loc3_ += "Pick A Line For Linkage";
         }
         _loc1_ = 10;
         _loc2_ = 10;
         _loc2_ += AddInfoText("a",_loc1_,_loc2_,_loc3_);
         _loc2_ = currentModeObject.RenderHud(_loc1_,_loc2_);
      }
      
      internal static function CheckIDForUniqueness(param1:String) : Boolean
      {
         var _loc4_:PhysLine = null;
         var _loc5_:LevelObj_Instance = null;
         var _loc2_:Boolean = false;
         var _loc3_:Level = GetCurrentLevel();
         for each(_loc4_ in _loc3_.lines)
         {
            if(_loc4_.id == param1)
            {
               _loc2_ = true;
            }
         }
         for each(_loc5_ in _loc3_.instances)
         {
            if(_loc5_.id == param1)
            {
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            Utils.trace("ERRRRROOORR: CheckIDForUniqueness");
            return false;
         }
         return true;
      }
      
      public static function CreateNewUniqueID() : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         do
         {
            _loc2_ = "uid_";
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               _loc2_ += Utils.RandBetweenInt(0,9);
               _loc3_++;
            }
            _loc1_ = CheckIDForUniqueness(_loc2_);
         }
         while(_loc1_ == false);
         return _loc2_;
      }
      
      public static function GetOrCreateUniqueLineID(param1:PhysLine) : String
      {
         if(param1.id == "")
         {
            param1.id = CreateNewUniqueID();
         }
         return param1.id;
      }
      
      public static function GetOrCreateUniqueObjectID(param1:LevelObj_Instance) : String
      {
         if(param1.id == "")
         {
            param1.id = CreateNewUniqueID();
         }
         return param1.id;
      }
      
      internal static function CurrentAdjustObject_ParameterPickObjectLink() : *
      {
         if(editModeObj_Adjust.currentAdjustObject == null)
         {
            return;
         }
         var _loc1_:PhysObj = Game.objectDefs.FindByName(editModeObj_Adjust.currentAdjustObject.typeName);
         var _loc2_:String = _loc1_.instanceParams[editModeObj_Adjust.currentAdjustObjectParam];
         var _loc3_:ObjParam = Game.objectParameters.GetObjectParamByName(_loc2_);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_.type != "objlink")
         {
            return;
         }
         SetEditMode(editMode_PickPieceForLink);
      }
      
      internal static function CurrentAdjustObject_ParameterPickLineLink() : *
      {
         if(editModeObj_Adjust.currentAdjustObject == null)
         {
            return;
         }
         var _loc1_:PhysObj = Game.objectDefs.FindByName(editModeObj_Adjust.currentAdjustObject.typeName);
         var _loc2_:String = _loc1_.instanceParams[editModeObj_Adjust.currentAdjustObjectParam];
         var _loc3_:ObjParam = Game.objectParameters.GetObjectParamByName(_loc2_);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_.type != "linelink")
         {
            return;
         }
         SetEditMode(editMode_PickLineForLink);
      }
      
      internal static function AddTextEntry(param1:int, param2:int, param3:String, param4:String, param5:Function) : *
      {
         var _loc6_:TextFormat = null;
         AddEntryMC();
         AddTextEntry_Callback = param5;
         _loc6_ = new TextFormat();
         _loc6_.size = 20;
         _loc6_.color = 0;
         tf = new TextField();
         tf.name = "tf";
         tf.type = TextFieldType.INPUT;
         entryMC.addChild(tf);
         tf.x = param1;
         tf.y = param2;
         tf.text = param4;
         tf.opaqueBackground = true;
         tf.background = true;
         tf.backgroundColor = 16777215;
         tf.multiline = false;
         tf.setTextFormat(_loc6_);
         tf.setSelection(0,tf.text.length);
         Game.main.stage.focus = tf;
         tf.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,false,0,true);
         isEntering = true;
      }
      
      internal static function AddDataGrid(param1:int, param2:int) : *
      {
      }
      
      internal static function PreventPropogationHandler(param1:MouseEvent) : *
      {
         param1.stopImmediatePropagation();
      }
      
      internal static function ParameterListBox_SetSelectedIndex() : *
      {
         if(listBoxContainer != null)
         {
            listBox.selectedIndex = editModeObj_Adjust.currentAdjustObjectParam;
         }
      }
      
      internal static function RemoveEntryMC() : *
      {
         if(entryMC != null)
         {
            entryMC.parent.removeChild(entryMC);
            entryMC = null;
         }
      }
      
      internal static function AddEntryMC() : *
      {
         RemoveEntryMC();
         entryMC = new MovieClip();
         entryMC.x = 0;
         entryMC.y = 0;
         entryMC.graphics.clear();
         entryMC.graphics.beginFill(16777215,0.5);
         entryMC.graphics.drawRect(entryMC.x,entryMC.y,Defs.displayarea_w,Defs.displayarea_h);
         entryMC.graphics.endFill();
         editorMC.addChild(entryMC);
         entryMC.addEventListener(MouseEvent.CLICK,PreventPropogationHandler);
         entryMC.addEventListener(MouseEvent.MOUSE_DOWN,PreventPropogationHandler);
         entryMC.addEventListener(MouseEvent.MOUSE_UP,PreventPropogationHandler);
      }
      
      internal static function keyDownHandler(param1:KeyboardEvent) : *
      {
         if(isEntering == false)
         {
            return;
         }
         var _loc2_:TextField = param1.currentTarget as TextField;
         if(param1.charCode == KeyReader.KEY_ENTER)
         {
            if(AddTextEntry_Callback != null)
            {
               AddTextEntry_Callback(_loc2_.text);
            }
            isEntering = false;
            Game.main.stage.focus = null;
            _loc2_.parent.removeChild(_loc2_);
            _loc2_ = null;
            RemoveEntryMC();
         }
         if(param1.charCode == KeyReader.KEY_ESCAPE)
         {
            Utils.trace("cancelled");
            isEntering = false;
            Game.main.stage.focus = null;
            _loc2_.parent.removeChild(_loc2_);
            _loc2_ = null;
            RemoveEntryMC();
         }
      }
      
      internal static function RenderEditor() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         linesScreen.graphics.clear();
         var _loc5_:BitmapData = screenBD;
         var _loc6_:int = MouseControl.x;
         var _loc7_:int = MouseControl.y;
         if(gridMode_active)
         {
            _loc6_ = Math.floor(_loc6_);
            _loc7_ = Math.floor(_loc7_);
            _loc6_ = int(_loc6_ / gridsnap) * int(gridsnap);
            _loc7_ = int(_loc7_ / gridsnap) * int(gridsnap);
         }
         var _loc8_:Number = scrollX;
         var _loc9_:Number = scrollY;
         if(gridMode_active)
         {
            _loc8_ = Math.floor(_loc8_);
            _loc9_ = Math.floor(_loc9_);
            _loc8_ = int(_loc8_ / gridsnap) * int(gridsnap);
            _loc9_ = int(_loc9_ / gridsnap) * int(gridsnap);
         }
         var _loc10_:int = _loc6_ + _loc8_;
         var _loc11_:int = _loc7_ + _loc9_;
         if(editMode == editMode_Commands1)
         {
            _loc5_.fillRect(Defs.screenRect,4285542592);
         }
         if(editMode == editMode_GridCommands)
         {
            _loc5_.fillRect(Defs.screenRect,4285542592);
         }
         currentModeObject.Render(_loc5_);
         _loc5_.draw(linesScreen);
         RenderPanel_Editor();
      }
      
      internal static function RenderBackground(param1:BitmapData) : *
      {
         var _loc2_:Point = GetMapPos(0,0);
         var _loc3_:Number = Defs.displayarea_w * zoom;
         var _loc4_:Number = Defs.displayarea_h * zoom;
         param1.fillRect(new Rectangle(_loc2_.x,_loc2_.y,_loc3_,_loc4_),0);
      }
      
      internal static function Editor_RenderGrid(param1:BitmapData) : *
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(gridMode_active == false)
         {
            return;
         }
         if(gridMode_renderGrid == false)
         {
            return;
         }
         var _loc2_:int = scrollX;
         var _loc3_:int = scrollY;
         _loc2_ = Math.floor(_loc2_);
         _loc3_ = Math.floor(_loc3_);
         _loc2_ = int(_loc2_ / gridsnap) * int(gridsnap);
         _loc3_ = int(_loc3_ / gridsnap) * int(gridsnap);
         var _loc4_:Number = 0;
         var _loc5_:Number = Defs.displayarea_w;
         var _loc6_:Number = 0;
         var _loc7_:Number = Defs.displayarea_h;
         var _loc8_:Graphics = linesScreen.graphics;
         _loc8_.lineStyle(1,4286611584,1);
         var _loc11_:Number = scrollX;
         var _loc12_:Number = scrollY;
         _loc9_ = _loc2_;
         while(_loc9_ < _loc2_ + Defs.displayarea_w)
         {
            _loc8_.moveTo(_loc9_ - _loc11_,_loc6_);
            _loc8_.lineTo(_loc9_ - _loc11_,_loc7_);
            _loc9_ += gridsnap;
         }
         _loc10_ = _loc3_;
         while(_loc10_ < _loc3_ + Defs.displayarea_h)
         {
            _loc8_.moveTo(_loc4_,_loc10_ - _loc12_);
            _loc8_.lineTo(_loc5_,_loc10_ - _loc12_);
            _loc10_ += gridsnap;
         }
      }
      
      internal static function SnapToObjects(param1:Number, param2:Number) : Point
      {
         var _loc3_:PhysObj = null;
         var _loc10_:PhysEd_GuideLine = null;
         var _loc11_:Point = null;
         if(currentPieceList.length != 1)
         {
            return null;
         }
         var _loc4_:Object = currentPieceList[0];
         _loc3_ = Game.objectDefs.GetByIndex(_loc4_.id);
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc5_:LevelObj_Instance = Levels.CreateLevelObjInstanceAt(_loc3_.name,param1 + _loc4_.xoff,param2 + _loc4_.yoff,_loc4_.rot,_loc4_.scale,"");
         Editor_GetNearbyGuidelines(null,param1,param2,20);
         var _loc6_:BitmapData = screenBD;
         var _loc7_:int;
         var _loc8_:Number = _loc7_ = 99999999;
         var _loc9_:Number = _loc7_;
         for each(_loc10_ in guideLines)
         {
            if(_loc10_.type == 1)
            {
               if(Math.abs(_loc10_.x0 - param1) < _loc8_)
               {
                  _loc8_ = _loc10_.x0;
               }
            }
            else if(Math.abs(_loc10_.y0 - param2) < _loc9_)
            {
               _loc9_ = _loc10_.y0;
            }
         }
         if(_loc8_ != _loc7_ && _loc9_ != _loc7_)
         {
            return new Point(_loc8_,_loc9_);
         }
         return null;
      }
      
      internal static function Editor_GetNearbyGuidelines(param1:LevelObj_Instance, param2:Number, param3:Number, param4:Number = 50) : *
      {
         var _loc6_:PhysObj_Body = null;
         var _loc7_:PhysObj_Shape = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc13_:LevelObj_Instance = null;
         var _loc14_:PhysObj = null;
         var _loc15_:Point = null;
         var _loc16_:Point = null;
         var _loc17_:PhysObj = null;
         var _loc18_:Point = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Boolean = false;
         var _loc22_:PhysEd_GuideLine = null;
         var _loc5_:Number = 3;
         var _loc10_:Array = GetCurrentLevelInstances();
         var _loc11_:Matrix = new Matrix();
         var _loc12_:Array = new Array();
         if(param1 != null)
         {
            _loc14_ = Game.objectDefs.FindByName(param1.typeName);
            if(_loc14_ != null)
            {
               for each(_loc6_ in _loc14_.bodies)
               {
                  for each(_loc7_ in _loc6_.shapes)
                  {
                     if(_loc7_.type == PhysObj_Shape.Type_Poly)
                     {
                        for each(_loc8_ in _loc7_.poly_points)
                        {
                           _loc11_.identity();
                           _loc11_.rotate(Utils.DegToRad(param1.rot));
                           _loc15_ = new Point(_loc8_.x,_loc8_.y);
                           _loc15_ = _loc11_.transformPoint(_loc15_);
                           _loc16_ = new Point(_loc15_.x + param1.x + _loc6_.pos.x,_loc15_.y + param1.y + _loc6_.pos.y);
                           _loc12_.push(_loc16_);
                        }
                     }
                  }
               }
            }
         }
         else
         {
            _loc12_.push(new Point(param2,param3));
         }
         guideLines = new Array();
         for each(_loc13_ in _loc10_)
         {
            if(_loc13_ != param1)
            {
               _loc17_ = Game.objectDefs.FindByName(_loc13_.typeName);
               if(_loc17_ != null)
               {
                  for each(_loc6_ in _loc17_.bodies)
                  {
                     for each(_loc7_ in _loc6_.shapes)
                     {
                        if(_loc7_.type == PhysObj_Shape.Type_Poly)
                        {
                           for each(_loc8_ in _loc7_.poly_points)
                           {
                              _loc11_.identity();
                              _loc11_.rotate(Utils.DegToRad(_loc13_.rot));
                              _loc15_ = new Point(_loc8_.x,_loc8_.y);
                              _loc15_ = _loc11_.transformPoint(_loc15_);
                              _loc18_ = new Point(_loc15_.x + _loc13_.x + _loc6_.pos.x,_loc15_.y + _loc13_.y + _loc6_.pos.y);
                              for each(_loc9_ in _loc12_)
                              {
                                 _loc19_ = Math.abs(_loc18_.x - _loc9_.x);
                                 _loc20_ = Math.abs(_loc18_.y - _loc9_.y);
                                 _loc21_ = false;
                                 if(_loc20_ < _loc5_ && _loc19_ < param4)
                                 {
                                    _loc21_ = false;
                                    if(Math.floor(_loc18_.y) == Math.floor(_loc9_.y))
                                    {
                                       _loc21_ = true;
                                    }
                                    _loc22_ = new PhysEd_GuideLine(_loc18_.x - 100,_loc18_.x + 100,_loc18_.y,0,_loc21_);
                                    guideLines.push(_loc22_);
                                 }
                                 if(_loc19_ < _loc5_ && _loc20_ < param4)
                                 {
                                    _loc21_ = false;
                                    if(Math.floor(_loc18_.x) == Math.floor(_loc9_.x))
                                    {
                                       _loc21_ = true;
                                    }
                                    _loc22_ = new PhysEd_GuideLine(_loc18_.y - 100,_loc18_.y + 100,_loc18_.x,1,_loc21_);
                                    guideLines.push(_loc22_);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      internal static function Editor_RenderNearbyGuidelines() : *
      {
         var _loc2_:PhysEd_GuideLine = null;
         var _loc3_:uint = 0;
         var _loc1_:BitmapData = screenBD;
         for each(_loc2_ in guideLines)
         {
            _loc3_ = 4294901760;
            if(_loc2_.level)
            {
               _loc3_ = 4278255615;
            }
            RenderLine(_loc2_.x0 - scrollX,_loc2_.y0 - scrollY,_loc2_.x1 - scrollX,_loc2_.y1 - scrollY,_loc3_);
         }
      }
      
      internal static function Editor_RenderMiniMap() : *
      {
         var _loc4_:LevelObj_Instance = null;
         var _loc5_:PhysObj = null;
         if(renderMiniMap == false)
         {
            return;
         }
         var _loc1_:Number = 1 / 20;
         var _loc2_:Array = GetCurrentLevelInstances();
         var _loc3_:BitmapData = screenBD;
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = Game.objectDefs.FindByName(_loc4_.typeName);
            if(_loc5_ != null)
            {
               PhysObj.RenderAt(_loc5_,_loc4_.x - scrollX,_loc4_.y - scrollY + 240 / _loc1_,_loc4_.rot,_loc4_.scale,_loc3_,linesScreen.graphics,false);
            }
         }
      }
      
      internal static function FillPoly(param1:Array, param2:uint, param3:Number) : *
      {
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         if(param1.length <= 2)
         {
            return;
         }
         var _loc4_:Graphics = linesScreen.graphics;
         _loc4_.lineStyle(null,null,null);
         _loc4_.beginFill(param2,param3);
         var _loc5_:int = 0;
         while(_loc5_ <= param1.length)
         {
            _loc6_ = _loc5_ % param1.length;
            _loc7_ = param1[_loc6_];
            if(_loc5_ == 0)
            {
               _loc4_.moveTo(_loc7_.x,_loc7_.y);
            }
            else
            {
               _loc4_.lineTo(_loc7_.x,_loc7_.y);
            }
            _loc5_++;
         }
         _loc4_.endFill();
      }
      
      internal static function RenderLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:Number = 1, param7:Number = 1, param8:Boolean = false) : *
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc9_:Number = 0;
         var _loc10_:Number = _loc9_ + Defs.displayarea_w;
         if(param1 > _loc10_ && param3 > _loc10_)
         {
            return;
         }
         if(param1 < _loc9_ && param3 < _loc9_)
         {
            return;
         }
         var _loc11_:Number = 0;
         var _loc12_:Number = _loc11_ + Defs.displayarea_h;
         if(param2 > _loc12_ && param4 > _loc12_)
         {
            return;
         }
         if(param2 < _loc11_ && param4 < _loc11_)
         {
            return;
         }
         var _loc13_:Graphics = linesScreen.graphics;
         _loc13_.lineStyle(param6,param5,param7);
         _loc13_.moveTo(param1,param2);
         _loc13_.lineTo(param3,param4);
         if(param8)
         {
            _loc14_ = (param1 + param3) * 0.5;
            _loc15_ = (param2 + param4) * 0.5;
            _loc16_ = Math.atan2(param4 - param2,param3 - param1) - Math.PI * 0.5;
            _loc17_ = _loc14_ + Math.cos(_loc16_) * 5;
            _loc18_ = _loc15_ + Math.sin(_loc16_) * 5;
            _loc13_.moveTo(_loc14_,_loc15_);
            _loc13_.lineTo(_loc17_,_loc18_);
         }
      }
      
      internal static function RenderRectangle(param1:Rectangle, param2:uint, param3:Number = 1, param4:Number = 1) : *
      {
         var _loc5_:Number = 0;
         var _loc6_:Number = _loc5_ + Defs.displayarea_w;
         if(param1.left > _loc6_)
         {
            return;
         }
         if(param1.right < _loc5_)
         {
            return;
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = _loc7_ + Defs.displayarea_h;
         if(param1.top > _loc8_)
         {
            return;
         }
         if(param1.bottom < _loc7_)
         {
            return;
         }
         RenderLine(param1.left,param1.top,param1.right,param1.top,param2,param3,param4);
         RenderLine(param1.left,param1.bottom,param1.right,param1.bottom,param2,param3,param4);
         RenderLine(param1.left,param1.top,param1.left,param1.bottom,param2,param3,param4);
         RenderLine(param1.right,param1.top,param1.right,param1.bottom,param2,param3,param4);
      }
      
      internal static function FillRectangle(param1:Rectangle, param2:uint, param3:Number = 1, param4:Number = 1) : *
      {
         var _loc5_:Number = 0;
         var _loc6_:Number = _loc5_ + Defs.displayarea_w;
         if(param1.left > _loc6_)
         {
            return;
         }
         if(param1.right < _loc5_)
         {
            return;
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = _loc7_ + Defs.displayarea_h;
         if(param1.top > _loc8_)
         {
            return;
         }
         if(param1.bottom < _loc7_)
         {
            return;
         }
         var _loc9_:Graphics = linesScreen.graphics;
         _loc9_.lineStyle(null,0,0);
         _loc9_.beginFill(param2,param4);
         _loc9_.moveTo(param1.left,param1.top);
         _loc9_.lineTo(param1.right,param1.top);
         _loc9_.lineTo(param1.right,param1.bottom);
         _loc9_.lineTo(param1.left,param1.bottom);
         _loc9_.endFill();
      }
      
      internal static function SortInstancesByZ(param1:Array) : Array
      {
         var _loc2_:LevelObj_Instance = null;
         var _loc3_:PhysObj = null;
         var _loc4_:PhysObj_Graphic = null;
         var _loc5_:PhysObj_Body = null;
         for each(_loc2_ in param1)
         {
            _loc2_.sortZ = 0;
            _loc3_ = Game.objectDefs.FindByName(_loc2_.typeName);
            for each(_loc4_ in _loc3_.graphics)
            {
               _loc2_.sortZ = _loc4_.zoffset;
            }
            for each(_loc5_ in _loc3_.bodies)
            {
               for each(_loc4_ in _loc5_.graphics)
               {
                  _loc2_.sortZ = _loc4_.zoffset;
               }
            }
         }
         param1.sortOn("sortZ",Array.NUMERIC | Array.DESCENDING);
         return param1;
      }
      
      internal static function Editor_RenderPickedObjectsHilight() : void
      {
         var _loc3_:Object = null;
         var _loc4_:PhysObj = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(renderObjects == false)
         {
            return;
         }
         var _loc1_:BitmapData = screenBD;
         var _loc2_:Point = GetCurrentPieceInitialPos();
         for each(_loc3_ in currentPieceList)
         {
            _loc4_ = Game.objectDefs.GetByIndex(_loc3_.id);
            if(_loc4_ != null)
            {
               _loc5_ = Number(_loc3_.origx);
               _loc6_ = Number(_loc3_.origy);
               PhysObj.RenderOutline(_loc4_,_loc5_ - scrollX,_loc6_ - scrollY,9,linesScreen.graphics);
            }
         }
      }
      
      public static function Editor_RenderJoints(param1:BitmapData) : *
      {
         var _loc3_:PhysObj_Joint = null;
         var _loc4_:Boolean = false;
         var _loc2_:Array = Levels.GetCurrentLevelJoints();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = true;
            if(editModeObj_Joints.selectedJoint == _loc3_)
            {
               if(PhysEditor.updateTimer & 1)
               {
                  _loc4_ = false;
               }
            }
            if(_loc4_ == true)
            {
               if(_loc3_.type == PhysObj_Joint.Type_Rev)
               {
                  RenderRevJoint(param1,_loc3_);
               }
               if(_loc3_.type == PhysObj_Joint.Type_Distance)
               {
                  RenderDistanceJoint(param1,_loc3_);
               }
               if(_loc3_.type == PhysObj_Joint.Type_Prismatic)
               {
                  RenderPrismaticJoint(param1,_loc3_);
               }
            }
         }
      }
      
      internal static function RenderRevJoint(param1:BitmapData, param2:PhysObj_Joint) : *
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:LevelObj_Instance = null;
         _loc3_ = GetMapPos(param2.rev_pos.x,param2.rev_pos.y);
         Utils.RenderCircle(param1,_loc3_.x,_loc3_.y,10,4294967295);
         if(param2.obj0Name != "")
         {
            _loc5_ = PhysEditor.GetInstanceById(param2.obj0Name);
            if(_loc5_ != null)
            {
               _loc4_ = GetMapPos(_loc5_.x,_loc5_.y);
               Utils.RenderDotLine(param1,_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y,100,4294901760);
               Utils.RenderCircle(param1,_loc4_.x,_loc4_.y,5 * zoom,4294967295);
            }
         }
         if(param2.obj1Name != "")
         {
            _loc5_ = PhysEditor.GetInstanceById(param2.obj1Name);
            if(_loc5_ != null)
            {
               _loc4_ = GetMapPos(_loc5_.x,_loc5_.y);
               _loc3_ = GetMapPos(param2.rev_pos.x,param2.rev_pos.y);
               Utils.RenderDotLine(param1,_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y,100,4294934528);
               Utils.RenderCircle(param1,_loc4_.x,_loc4_.y,5,4294967295);
            }
         }
      }
      
      internal static function RenderPrismaticJoint(param1:BitmapData, param2:PhysObj_Joint) : *
      {
         var _loc3_:Number = scrollX;
         var _loc4_:Number = scrollY;
         var _loc5_:Point = param2.prism_pos.clone();
         var _loc6_:Point = param2.prism_pos1.clone();
         Utils.RenderDotLine(param1,_loc5_.x - _loc3_,_loc5_.y - _loc4_,_loc6_.x - _loc3_,_loc6_.y - _loc4_,100,4294967295);
      }
      
      internal static function RenderDistanceJoint(param1:BitmapData, param2:PhysObj_Joint) : *
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         _loc3_ = GetMapPos(param2.dist_pos0.x,param2.dist_pos0.y);
         _loc4_ = GetMapPos(param2.dist_pos1.x,param2.dist_pos1.y);
         Utils.RenderDotLine(param1,_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y,100,4278255615);
         Utils.RenderCircle(param1,_loc3_.x,_loc3_.y,5,4278242508);
         Utils.RenderCircle(param1,_loc4_.x,_loc4_.y,5,4278242508);
      }
      
      internal static function Editor_RenderObjects() : *
      {
         var _loc3_:LevelObj_Instance = null;
         var _loc4_:PhysObj = null;
         var _loc5_:Editor_GameRenderer = null;
         var _loc6_:Point = null;
         if(renderObjects == false)
         {
            return;
         }
         var _loc1_:Array = GetCurrentLevelInstances();
         if(objectZSortMode)
         {
            _loc1_ = SortInstancesByZ(_loc1_);
         }
         var _loc2_:BitmapData = screenBD;
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = Game.objectDefs.FindByName(_loc3_.typeName);
            if(_loc4_ != null)
            {
               if(_loc4_.editorRenderFunctionName != null)
               {
                  _loc5_ = new Editor_GameRenderer();
                  _loc5_[_loc4_.editorRenderFunctionName](_loc4_,_loc3_);
               }
               else
               {
                  _loc6_ = GetMapPos(_loc3_.x,_loc3_.y);
                  PhysObj.RenderAt(_loc4_,_loc6_.x,_loc6_.y,_loc3_.rot,_loc3_.scale * zoom,_loc2_,linesScreen.graphics,true);
               }
            }
         }
      }
      
      public static function ExportAllLevelsAsXml() : *
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         var _loc3_:int = currentLevel;
         _loc2_ = 0;
         while(_loc2_ < Levels.list.length)
         {
            currentLevel = _loc2_;
            _loc1_ += ExportLevelAsXml();
            _loc1_ += "\n\n";
            _loc2_++;
         }
         currentLevel = _loc3_;
         ExternalData.OutputString(_loc1_);
      }
      
      public static function UndoTakeSnapshot() : *
      {
         var _loc6_:PhysLine = null;
         var _loc7_:Array = null;
         var _loc8_:LevelObj_Instance = null;
         var _loc9_:PhysObj_Joint = null;
         var _loc10_:PhysLine = null;
         var _loc11_:LevelObj_Instance = null;
         var _loc12_:PhysObj_Joint = null;
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:Object = new Object();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         for each(_loc6_ in _loc1_.lines)
         {
            _loc10_ = _loc6_.Clone();
            _loc3_.push(_loc10_);
         }
         _loc2_.lines = _loc3_;
         _loc7_ = GetCurrentLevelInstances();
         for each(_loc8_ in _loc7_)
         {
            _loc11_ = _loc8_.Clone();
            _loc4_.push(_loc11_);
         }
         _loc2_.objects = _loc4_;
         for each(_loc9_ in _loc1_.joints)
         {
            _loc12_ = _loc9_.Clone();
            _loc5_.push(_loc12_);
         }
         _loc2_.joints = _loc5_;
         undoList.push(_loc2_);
      }
      
      public static function DoUndo() : *
      {
         var _loc6_:PhysLine = null;
         var _loc7_:PhysObj_Joint = null;
         var _loc8_:PhysLine = null;
         var _loc9_:Array = null;
         var _loc10_:LevelObj_Instance = null;
         var _loc11_:LevelObj_Instance = null;
         var _loc12_:PhysObj_Joint = null;
         var _loc1_:Level = GetCurrentLevel();
         if(undoList.length == 0)
         {
            return;
         }
         var _loc2_:Object = undoList.pop();
         var _loc3_:Array = _loc2_.joints;
         var _loc4_:Array = _loc2_.lines;
         var _loc5_:Array = _loc2_.objects;
         _loc1_.lines = new Array();
         for each(_loc6_ in _loc4_)
         {
            _loc8_ = _loc6_.Clone();
            _loc1_.lines.push(_loc8_);
         }
         if(_loc5_.length != 0)
         {
            _loc9_ = new Array();
            for each(_loc10_ in _loc5_)
            {
               _loc11_ = _loc10_.Clone();
               _loc9_.push(_loc11_);
            }
            Levels.list[currentLevel].instances = _loc9_;
         }
         _loc1_.joints = new Array();
         for each(_loc7_ in _loc3_)
         {
            _loc12_ = _loc7_.Clone();
            _loc1_.joints.push(_loc12_);
         }
         editModeObj_Lines.currentLineIndex = -1;
         editModeObj_Lines.currentPointIndex = -1;
      }
      
      public static function ExportLevelAsXml() : String
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:PhysObj_Joint = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:PhysLine = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:LevelObj_Instance = null;
         var _loc17_:PhysObj = null;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:* = 0;
         var _loc24_:String = null;
         var _loc1_:Level = GetCurrentLevel();
         var _loc2_:String = "";
         var _loc3_:String = "";
         _loc2_ = "<level id=\"" + _loc1_.id + "\"";
         _loc2_ += " name=\"" + _loc1_.name + "\"";
         _loc2_ += " category=\"" + _loc1_.category.toString() + "\"";
         _loc2_ += " desc=\"" + _loc1_.description + "\"";
         _loc2_ += " bg=\"" + _loc1_.bgFrame + "\"";
         _loc2_ += " >";
         _loc3_ += _loc2_ + "\n";
         Utils.trace(_loc2_);
         _loc2_ = Levels.GetGameSpecificLevelDataXML(currentLevel);
         _loc3_ += _loc2_ + "\n";
         Utils.trace(_loc2_);
         for each(_loc4_ in _loc1_.helpscreenFrames)
         {
            _loc2_ = "\t<helpscreen frame=\"" + _loc4_ + "\" />";
            _loc3_ += _loc2_ + "\n";
            Utils.trace(_loc2_);
         }
         _loc5_ = GetCurrentLevelInstances();
         for each(_loc6_ in editModeObj_Library.libraryFilters)
         {
            _loc15_ = false;
            for each(_loc16_ in _loc5_)
            {
               _loc17_ = Game.objectDefs.FindByName(_loc16_.typeName);
               if(_loc17_ != null && _loc17_.libraryClass == _loc6_)
               {
                  _loc15_ = true;
               }
            }
            if(_loc15_)
            {
               _loc2_ = "\t<objgroup name=\"" + _loc6_ + "\">";
               _loc3_ += _loc2_ + "\n";
               Utils.trace(_loc2_);
               for each(_loc16_ in _loc5_)
               {
                  _loc17_ = Game.objectDefs.FindByName(_loc16_.typeName);
                  if(_loc17_ != null && _loc17_.libraryClass == _loc6_)
                  {
                     _loc2_ = "\t\t<obj id=\"" + _loc16_.id + "\" type=\"" + _loc16_.typeName + "\" x=\"" + _loc16_.x + "\" y=\"" + _loc16_.y + "\" rot=\"" + _loc16_.rot + "\" scale=\"" + _loc16_.scale + "\" params=\"" + _loc16_.objParameters.ToString() + "\" />";
                     _loc3_ += _loc2_ + "\n";
                     Utils.trace(_loc2_);
                  }
               }
               _loc2_ = "\t</objgroup>";
               _loc3_ += _loc2_ + "\n";
               Utils.trace(_loc2_);
            }
         }
         _loc2_ = "\t<joints>";
         _loc3_ += _loc2_ + "\n";
         Utils.trace(_loc2_);
         for each(_loc7_ in _loc1_.joints)
         {
            _loc2_ = "";
            if(_loc7_.type == PhysObj_Joint.Type_Rev)
            {
               _loc2_ = "\t\t<joint type=\"rev\"" + " id=\"" + _loc7_.name + "\"" + " objid0=\"" + _loc7_.obj0Name + "\"" + " objid1=\"" + _loc7_.obj1Name + "\"" + " x=\"" + _loc7_.rev_pos.x + "\"" + " y=\"" + _loc7_.rev_pos.y + "\"" + " params=\"" + _loc7_.objParameters.ToString() + "\"" + " />";
            }
            if(_loc7_.type == PhysObj_Joint.Type_Distance)
            {
               _loc2_ = "\t\t<joint type=\"dist\"" + " id=\"" + _loc7_.name + "\"" + " objid0=\"" + _loc7_.obj0Name + "\"" + " objid1=\"" + _loc7_.obj1Name + "\"" + " x0=\"" + _loc7_.dist_pos0.x + "\"" + " y0=\"" + _loc7_.dist_pos0.y + "\"" + " x1=\"" + _loc7_.dist_pos1.x + "\"" + " y1=\"" + _loc7_.dist_pos1.y + "\"" + " params=\"" + _loc7_.objParameters.ToString() + "\"" + " />";
            }
            if(_loc7_.type == PhysObj_Joint.Type_Prismatic)
            {
               _loc2_ = "\t\t<joint type=\"prism\"" + " id=\"" + _loc7_.name + "\"" + " objid0=\"" + _loc7_.obj0Name + "\"" + " objid1=\"" + _loc7_.obj1Name + "\"" + " x0=\"" + _loc7_.prism_pos.x + "\"" + " y0=\"" + _loc7_.prism_pos.y + "\"" + " x1=\"" + _loc7_.prism_pos1.x + "\"" + " y1=\"" + _loc7_.prism_pos1.y + "\"" + " params=\"" + _loc7_.objParameters.ToString() + "\"" + " />";
            }
            _loc3_ += _loc2_ + "\n";
            Utils.trace(_loc2_);
         }
         _loc2_ = "\t</joints>";
         _loc3_ += _loc2_ + "\n";
         Utils.trace(_loc2_);
         for each(_loc11_ in _loc1_.lines)
         {
            _loc2_ = "<line type=\"" + _loc11_.type + "\" id=\"" + _loc11_.id + "\"";
            _loc2_ += " params=\"" + _loc11_.objParameters.ToString() + "\"" + " >";
            _loc3_ += _loc2_ + "\n";
            Utils.trace(_loc2_);
            _loc18_ = _loc11_.points;
            _loc19_ = int(_loc18_.length);
            _loc20_ = 10;
            _loc21_ = _loc19_ / _loc20_;
            _loc22_ = _loc19_ % _loc20_;
            _loc23_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _loc21_)
            {
               _loc24_ = "<points a=\"";
               _loc9_ = 0;
               while(_loc9_ < _loc20_)
               {
                  _loc10_ = _loc18_[_loc23_++];
                  _loc24_ += _loc10_.x + "," + _loc10_.y;
                  if(_loc9_ != _loc20_ - 1)
                  {
                     _loc24_ += ", ";
                  }
                  _loc9_++;
               }
               _loc2_ = _loc24_ += "\" />";
               _loc3_ += _loc2_ + "\n";
               Utils.trace(_loc2_);
               _loc8_++;
            }
            if(_loc22_ != 0)
            {
               _loc24_ = "<points a=\"";
               _loc9_ = 0;
               while(_loc9_ < _loc22_)
               {
                  _loc10_ = _loc18_[_loc23_++];
                  _loc24_ += _loc10_.x + "," + _loc10_.y;
                  if(_loc9_ != _loc22_ - 1)
                  {
                     _loc24_ += ", ";
                  }
                  _loc9_++;
               }
               _loc2_ = _loc24_ += "\" />";
               _loc3_ += _loc2_ + "\n";
               Utils.trace(_loc2_);
            }
            _loc2_ = "</line>";
            _loc3_ += _loc2_ + "\n";
            Utils.trace(_loc2_);
         }
         _loc2_ = "<map";
         _loc2_ += " minx=\"" + _loc1_.mapMinX + "\"";
         _loc2_ += " maxx=\"" + _loc1_.mapMaxX + "\"";
         _loc2_ += " miny=\"" + _loc1_.mapMinY + "\"";
         _loc2_ += " maxy=\"" + _loc1_.mapMaxY + "\"";
         _loc2_ += " cellw=\"" + _loc1_.mapCellW + "\"";
         _loc2_ += " cellh=\"" + _loc1_.mapCellH + "\"";
         _loc2_ += " >";
         _loc3_ += _loc2_ + "\n";
         Utils.trace(_loc2_);
         _loc12_ = int(_loc1_.map.length);
         _loc13_ = 0;
         _loc14_ = false;
         _loc20_ = 600;
         do
         {
            if(_loc12_ >= _loc20_)
            {
               _loc2_ = "<mapdata a=\"";
               _loc8_ = _loc13_;
               while(_loc8_ < _loc13_ + _loc20_)
               {
                  _loc2_ += _loc1_.map[_loc8_].toString();
                  _loc8_++;
               }
               _loc2_ += "\"/>";
               _loc3_ += _loc2_ + "\n";
               _loc13_ += _loc20_;
               _loc12_ -= _loc20_;
            }
            else
            {
               _loc2_ = "<mapdata a=\"";
               _loc8_ = _loc13_;
               while(_loc8_ < _loc13_ + _loc12_)
               {
                  _loc2_ += _loc1_.map[_loc8_].toString();
                  _loc8_++;
               }
               _loc2_ += "\"/>";
               _loc3_ += _loc2_ + "\n";
               _loc14_ = true;
            }
         }
         while(_loc14_ == false);
         _loc2_ = "</map>";
         _loc3_ += _loc2_ + "\n";
         Utils.trace(_loc2_);
         _loc2_ = "</level>";
         _loc3_ += _loc2_ + "\n";
         Utils.trace(_loc2_);
         return _loc3_;
      }
      
      public static function HitTestLineArea(param1:Number, param2:Number) : PhysLine
      {
         var _loc3_:Level = null;
         editModeObj_Lines.Lines_SelectLineByArea(param1,param2);
         if(editModeObj_Lines.currentLineIndex != -1)
         {
            _loc3_ = GetCurrentLevel();
            return _loc3_.lines[editModeObj_Lines.currentLineIndex];
         }
         return null;
      }
      
      public static function HitTestLinePoints(param1:Number, param2:Number) : PhysLine
      {
         var _loc3_:Level = null;
         editModeObj_Lines.Lines_SelectLineByPoint(param1,param2);
         if(editModeObj_Lines.currentLineIndex != -1)
         {
            _loc3_ = GetCurrentLevel();
            return _loc3_.lines[editModeObj_Lines.currentLineIndex];
         }
         return null;
      }
      
      public static function HitTestPhysObjGraphics(param1:Number, param2:Number, param3:Boolean = false) : LevelObj_Instance
      {
         var _loc5_:* = 0;
         var _loc6_:LevelObj_Instance = null;
         var _loc7_:PhysObj = null;
         var _loc8_:Boolean = false;
         var _loc9_:BitmapData = null;
         var _loc10_:Point = null;
         var _loc11_:uint = 0;
         var _loc4_:Array = GetCurrentLevelInstances();
         _loc5_ = int(_loc4_.length - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = Game.objectDefs.FindByName(_loc6_.typeName);
            _loc8_ = true;
            if(param3)
            {
               _loc8_ = false;
               if(_loc7_.hasPhysics)
               {
                  _loc8_ = true;
               }
            }
            if(_loc8_)
            {
               _loc9_ = screenBD;
               _loc9_.fillRect(Defs.screenRect,0);
               _loc10_ = GetMapPos(_loc6_.x,_loc6_.y);
               PhysObj.RenderAt(_loc7_,_loc10_.x,_loc10_.y,_loc6_.rot,_loc6_.scale * zoom,_loc9_);
               _loc11_ = _loc9_.getPixel(param1,param2);
               if(_loc11_ != 0)
               {
                  return _loc6_;
               }
            }
            _loc5_--;
         }
         return null;
      }
      
      internal static function GetCurrentLevelInstances() : Array
      {
         return Levels.list[currentLevel].instances;
      }
      
      internal static function SetCurrentLevelInstances(param1:Array) : void
      {
         Levels.list[currentLevel].instances = param1;
      }
      
      internal static function GetCurrentLevel() : Level
      {
         return Levels.GetLevel(currentLevel);
      }
      
      internal static function RemoveFromLevelInstances(param1:LevelObj_Instance) : *
      {
         var _loc4_:LevelObj_Instance = null;
         var _loc2_:Array = GetCurrentLevelInstances();
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_ != param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         _loc2_ = _loc3_;
         Levels.list[currentLevel].instances = _loc2_;
      }
      
      internal static function Editor_RenderLineToCursor() : *
      {
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:BitmapData = null;
         if(editModeObj_Lines.addlineActive == false)
         {
            return;
         }
         if(editModeObj_Lines.subMode != "addpoint")
         {
            return;
         }
         var _loc1_:Level = GetCurrentLevel();
         if(editModeObj_Lines.currentLineIndex == -1)
         {
            return;
         }
         var _loc2_:PhysLine = _loc1_.lines[editModeObj_Lines.currentLineIndex];
         if(_loc2_.primitiveType == PhysLine.PRIMITIVE_LINE)
         {
            GetMousePositions();
            _loc3_ = _loc2_.points.length - 1;
            _loc4_ = GetMapPos(_loc2_.points[_loc3_].x,_loc2_.points[_loc3_].y);
            _loc5_ = GetMapPos(mxs,mys);
            _loc6_ = screenBD;
            RenderLine(_loc5_.x,_loc5_.y,_loc4_.x,_loc4_.y,4278255615);
         }
      }
      
      internal static function GetMapPosRect(param1:Rectangle) : Rectangle
      {
         var _loc3_:Point = null;
         var _loc2_:Rectangle = param1.clone();
         _loc3_ = GetMapPos(param1.x,param1.y);
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         _loc3_ = GetMapPos(param1.width,param1.height);
         _loc2_.width = _loc3_.x;
         _loc2_.height = _loc3_.y;
         return _loc2_;
      }
      
      internal static function GetMapPosPoints(param1:Array) : Array
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc4_ = GetMapPos(_loc3_.x,_loc3_.y);
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      public static function GetMapPos(param1:int, param2:int) : Point
      {
         return new Point((param1 - PhysEditor.scrollX) * zoom,(param2 - PhysEditor.scrollY) * zoom);
      }
      
      public static function GetPos(param1:int, param2:int) : Point
      {
         return new Point(param1 * zoom,param2 * zoom);
      }
      
      internal static function GetMousePositions() : *
      {
         mx = MouseControl.x;
         my = MouseControl.y;
         if(PhysEditor.gridMode_active)
         {
            mx = Math.floor(mx);
            my = Math.floor(my);
            mx = int(mx / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
            my = int(my / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
         }
         sx = PhysEditor.scrollX;
         sy = PhysEditor.scrollY;
         if(PhysEditor.gridMode_active)
         {
            sx = Math.floor(sx);
            sy = Math.floor(sy);
            sx = int(sx / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
            sy = int(sy / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
         }
         mxs = mx * (1 / PhysEditor.zoom) + sx;
         mys = my * (1 / PhysEditor.zoom) + sy;
      }
      
      internal static function Editor_RenderLines(param1:Boolean = false) : *
      {
         var _loc2_:Point = null;
         var _loc8_:PhysLine = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Point = null;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:uint = 0;
         var _loc16_:int = 0;
         var _loc17_:Point = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         if(editModeObj_Lines.addlineActive == false)
         {
            param1 = false;
         }
         if(editModeObj_Lines.subMode != "addpoint")
         {
            param1 = false;
         }
         _loc2_ = new Point();
         var _loc3_:Point = new Point();
         var _loc4_:Rectangle = new Rectangle();
         var _loc5_:Level = GetCurrentLevel();
         var _loc6_:BitmapData = screenBD;
         var _loc7_:int = 0;
         for each(_loc8_ in _loc5_.lines)
         {
            _loc9_ = 0;
            if(_loc8_.objParameters.GetParam("editor_layer") != "")
            {
               _loc9_ = _loc8_.objParameters.GetValueInt("editor_layer") - 1;
            }
            if(IsLayerVisible(_loc9_) == true)
            {
               _loc10_ = _loc8_.points;
               if(_loc7_ == editModeObj_Lines.currentLineIndex && param1 && _loc8_.primitiveType == PhysLine.PRIMITIVE_LINE)
               {
                  GetMousePositions();
                  _loc10_ = new Array();
                  for each(_loc2_ in _loc8_.points)
                  {
                     _loc10_.push(_loc2_.clone());
                  }
                  _loc10_.push(new Point(mxs,mys));
               }
               _loc11_ = new Array();
               for each(_loc12_ in _loc10_)
               {
                  _loc17_ = GetMapPos(_loc12_.x,_loc12_.y);
                  _loc11_.push(_loc17_);
               }
               _loc10_ = _loc11_;
               _loc13_ = GetLineTypeMode(_loc8_.type);
               _loc14_ = false;
               if((_loc13_ & LM_LINK) != 0)
               {
                  _loc14_ = true;
               }
               _loc15_ = GetLineTypeColor(_loc8_.type);
               _loc16_ = 1;
               if(_loc7_ == editModeObj_Lines.currentLineIndex)
               {
                  _loc16_ = 2;
               }
               if(_loc10_.length >= 2)
               {
                  _loc18_ = 0;
                  while(_loc18_ < _loc10_.length - 1)
                  {
                     _loc2_ = _loc10_[_loc18_];
                     _loc3_ = _loc10_[_loc18_ + 1];
                     RenderLine(_loc2_.x,_loc2_.y,_loc3_.x,_loc3_.y,_loc15_,_loc16_,1,_loc14_);
                     _loc18_++;
                  }
                  if((_loc13_ & LM_LINK) != 0)
                  {
                     _loc2_ = _loc10_[_loc10_.length - 1];
                     _loc3_ = _loc10_[0];
                     RenderLine(_loc2_.x,_loc2_.y,_loc3_.x,_loc3_.y,_loc15_,_loc16_,1,_loc14_);
                  }
               }
               if((_loc13_ & LM_FILL) != 0)
               {
                  FillPoly(_loc10_,_loc15_,0.1);
               }
               if(_loc8_.primitiveType == PhysLine.PRIMITIVE_LINE)
               {
                  _loc18_ = 0;
                  while(_loc18_ < _loc10_.length)
                  {
                     _loc15_ = 4294901760;
                     if(_loc7_ == editModeObj_Lines.currentLineIndex && editModeObj_Lines.currentPointIndex == _loc18_)
                     {
                        _loc15_ = 4294967040;
                     }
                     _loc19_ = 2;
                     _loc20_ = 4;
                     if(_loc7_ == hoverLineIndex && hoverPointIndex == _loc18_)
                     {
                        _loc19_ = 3;
                        _loc20_ = 6;
                     }
                     _loc4_.x = _loc10_[_loc18_].x - _loc19_;
                     _loc4_.y = _loc10_[_loc18_].y - _loc19_;
                     _loc4_.width = _loc20_;
                     _loc4_.height = _loc20_;
                     RenderRectangle(_loc4_,_loc15_);
                     _loc18_++;
                  }
               }
               if(_loc8_.primitiveType == PhysLine.PRIMITIVE_RECTANGLE)
               {
                  _loc18_ = 0;
                  while(_loc18_ <= 2)
                  {
                     _loc15_ = 4294901760;
                     if(_loc7_ == editModeObj_Lines.currentLineIndex && editModeObj_Lines.currentPointIndex == _loc18_)
                     {
                        _loc15_ = 4294967040;
                     }
                     _loc19_ = 2;
                     _loc20_ = 4;
                     if(_loc7_ == hoverLineIndex && hoverPointIndex == _loc18_)
                     {
                        _loc19_ = 3;
                        _loc20_ = 6;
                     }
                     _loc4_.x = _loc10_[_loc18_].x - _loc19_;
                     _loc4_.y = _loc10_[_loc18_].y - _loc19_;
                     _loc4_.width = _loc20_;
                     _loc4_.height = _loc20_;
                     RenderRectangle(_loc4_,_loc15_);
                     _loc18_ += 2;
                  }
               }
            }
            _loc7_++;
         }
      }
      
      internal static function HighlightLinePoly(param1:PhysLine) : *
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = GetMapPosPoints(param1.points);
         FillPoly(_loc2_,16777215,0.5);
      }
   }
}

