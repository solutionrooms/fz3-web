package
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Joints.*;
   import EditorPackage.PhysEditor;
   import LicPackage.Lic;
   import UIPackage.UI;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundChannel;
   import flash.ui.*;
   import org.flashdevelop.utils.FlashConnect;
   
   public class Game
   {
      
      internal static var currentGameMusic:int;
      
      public static var currentMC:MovieClip;
      
      public static var main:Main;
      
      public static var currentScore:int;
      
      public static var levelScore:int;
      
      public static var scoreMultiplier:int;
      
      public static var numLevels:int;
      
      public static var numLives:int;
      
      public static var cash:int;
      
      public static var pause:Boolean;
      
      public static var pauseGameplayInput:Boolean;
      
      public static var goPlayer:GameObj;
      
      public static var levelTimer:int;
      
      public static var backgroundScreenBD:BitmapData;
      
      public static var shadowScreenBD:BitmapData;
      
      public static var scrollScreenBD:BitmapData;
      
      public static var foregroundScreenBD:BitmapData;
      
      public static var flattenedScreenBD:BitmapData;
      
      public static var particleScreenBD:BitmapData;
      
      public static var layerScreenBD:BitmapData;
      
      public static var copyScreenBD:BitmapData;
      
      public static var fillScreenMC:MovieClip;
      
      public static var fillScreenMC1:MovieClip;
      
      public static var camera:Camera;
      
      public static var boundingRectangle:Rectangle;
      
      public static var objectParameters:ObjectParameters;
      
      public static var achievements:Achievements;
      
      public static var levelState:int;
      
      public static var gameState:int;
      
      public static var levelStateTimer:int;
      
      public static var levelStateCount:int;
      
      public static var objectDefs:PhysObjs;
      
      public static var physMaterials:Array;
      
      public static var lastGeneratedGameObj:GameObj;
      
      public static var levelSuccessFlag:Boolean;
      
      public static var levelFailReason:int;
      
      public static var level_instances:Array;
      
      public static var textFrameOffset:int;
      
      public static var pitchedSound:MP3Pitch;
      
      public static var currentBackground:int;
      
      public static var goCursor:GameObj;
      
      public static var goMarker:GameObj;
      
      internal static var hudController:HudController;
      
      public static var killScore:int;
      
      public static var rating:int;
      
      public static var endLevelScore:int;
      
      public static var numGolds:int;
      
      internal static var goBackground:GameObj;
      
      internal static var goPolyLayer:GameObj;
      
      internal static var sparksActive:Boolean;
      
      internal static var mincerActive:Boolean;
      
      internal static var flameActive:Boolean;
      
      internal static var flameActive1:Boolean;
      
      internal static var chainsawActive:Boolean;
      
      internal static var sawingActive:Boolean;
      
      internal static var pianoCount:int;
      
      internal static var pianoLevel:Number;
      
      internal static var chainsawLevel:Number;
      
      internal static var chainsawToLevel:Number;
      
      internal static var circularSawActive:Boolean;
      
      internal static var flameLevel:Number;
      
      internal static var circularSawLevel:Number;
      
      internal static var circularSawToLevel:Number;
      
      internal static var scrollFirstTime:Boolean;
      
      internal static var zorder:Array;
      
      internal static var ballpath_dx:Number;
      
      internal static var ballpath_dy:Number;
      
      internal static var prevBallPath_dx:Number;
      
      internal static var prevBallPath_dy:Number;
      
      internal static var prevBallPath_x:Number;
      
      internal static var prevBallPath_y:Number;
      
      internal static var prevBallPath_doIt:Boolean;
      
      internal static var bp_bd:BitmapData;
      
      internal static var bp_x:Number;
      
      internal static var bp_y:Number;
      
      internal static var bp_dx:Number;
      
      internal static var bp_dy:Number;
      
      internal static var bp_straight:Boolean;
      
      internal static var debugPrint:Boolean = false;
      
      internal static var debugPrintError:Boolean = true;
      
      public static var soundon:Boolean = true;
      
      public static var usedebug:Boolean = false;
      
      public static var doLevelEndTests:Boolean = true;
      
      public static var onlyFinalLevels:Boolean = true;
      
      internal static const gameState_UI:* = 0;
      
      internal static const gameState_Play:* = 1;
      
      internal static const levelState_LevelStart:* = 0;
      
      internal static const levelState_Play:* = 1;
      
      internal static const levelState_Null:* = 2;
      
      internal static const levelState_Editor:* = 3;
      
      internal static const levelState_Complete:* = 4;
      
      internal static const levelState_EndScreen:* = 5;
      
      internal static const levelState_BonusSectionStart:* = 6;
      
      internal static const levelState_BonusSection:* = 7;
      
      internal static const levelState_PlayerDead:* = 8;
      
      internal static var debugPlayerInvulnerable:Boolean = false;
      
      public static var zsortoffset:Number = 0;
      
      public static var levelJustUnlocked:Boolean = false;
      
      public static var testTextureFrame:int = 0;
      
      internal static var createdForegroundBitmaps:Boolean = false;
      
      internal static var ballpath_grav:Number = 0.07919999999999916;
      
      internal static var ballpath_mult:Number = 0.8049999999999993;
      
      internal static var renderBallPathTimer:Number = 0;
      
      internal static var bp_paramsSet:Boolean = false;
      
      internal static var dragState:int = 0;
      
      internal static var dragPosX:Number = 0;
      
      internal static var dragPosY:Number = 0;
      
      public static var shadowOffsetX:Number = 5;
      
      public static var shadowOffsetY:Number = 5;
      
      public function Game()
      {
         super();
      }
      
      public static function InitOnce(param1:Main) : *
      {
         main = param1;
         currentScore = 0;
         scoreMultiplier = 1;
         numLevels = 8;
         Levels.currentIndex = 0;
         hudController = new HudController();
         hudController.InitOnce();
         gameState = gameState_UI;
         InitBitmaps();
         camera = new Camera();
         ZombieHolder.InitOnce();
         achievements = new Achievements();
         InitGame();
         objectParameters = new ObjectParameters();
         objectParameters.LoadObjectParams();
         LoadPhysMaterials();
         objectDefs = new PhysObjs();
         objectDefs.InitFromXml(ExternalData.xml);
         GameVars.InitOnce();
      }
      
      internal static function InitBitmaps() : *
      {
         scrollScreenBD = new BitmapData(2400,2000,true,0);
         copyScreenBD = new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0);
         fillScreenMC = new MovieClip();
         fillScreenMC.x = 0;
         fillScreenMC.y = 0;
         fillScreenMC1 = new MovieClip();
         fillScreenMC1.x = 0;
         fillScreenMC1.y = 0;
      }
      
      public static function StartTitleScreen() : *
      {
         gameState = gameState_UI;
         main.ClearStage();
         UI.StartTransition("preparingscreen");
      }
      
      public static function StopLevel() : *
      {
         gameState = gameState_UI;
      }
      
      public static function StartLevel() : *
      {
         Utils.trace("Func: StartLevel");
         gameState = gameState_Play;
         InitLevel();
      }
      
      public static function InitGame() : *
      {
         gameState = gameState_Play;
         Debug.debugMode = 0;
         numLives = 3;
         Levels.currentIndex = 0;
         pause = true;
         cash = 0;
         currentGameMusic = 0;
         Levels.LoadAll();
         Particles.Reset();
         MouseControl.Reset();
         Particles.Reset();
         GameObjects.ClearAll();
         ResetEverything();
         SaveData.Load();
         SubmitStats();
         MusicPlayer.StartStream("menus_music");
         StartTitleScreen();
      }
      
      internal static function FindObjInInstances(param1:Level, param2:String) : Boolean
      {
         var _loc3_:LevelObj_Instance = null;
         for each(_loc3_ in param1.instances)
         {
            if(_loc3_.typeName == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function DoesLevelContainHostage(param1:Level) : Boolean
      {
         if(FindObjInInstances(param1,"tiedup1"))
         {
            return true;
         }
         if(FindObjInInstances(param1,"tiedup2"))
         {
            return true;
         }
         if(FindObjInInstances(param1,"tiedup3"))
         {
            return true;
         }
         if(FindObjInInstances(param1,"tiedup4"))
         {
            return true;
         }
         if(FindObjInInstances(param1,"tiedup5"))
         {
            return true;
         }
         if(FindObjInInstances(param1,"tiedup6"))
         {
            return true;
         }
         return false;
      }
      
      internal static function ShowLevelPlayerUsage() : *
      {
         var _loc22_:int = 0;
         var _loc23_:Level = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:Array = new Array();
         var _loc10_:Array = new Array();
         var _loc11_:Array = new Array();
         var _loc12_:Array = new Array();
         var _loc13_:Array = new Array();
         var _loc14_:Array = new Array();
         var _loc15_:Array = new Array();
         var _loc16_:Array = new Array();
         var _loc17_:Array = new Array();
         var _loc18_:Array = new Array();
         var _loc19_:Array = new Array();
         var _loc20_:Array = new Array();
         var _loc21_:int = 0;
         _loc22_ = 1;
         for each(_loc23_ in Levels.list)
         {
            if(_loc23_.creator == "final")
            {
               if(FindObjInInstances(_loc23_,"zombooka_player_missile"))
               {
                  if(_loc1_.length == 0)
                  {
                     _loc8_.push(_loc22_,_loc23_.name);
                  }
                  _loc1_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_missile_movable"))
               {
                  if(_loc1_.length == 0)
                  {
                     _loc8_.push(_loc22_,_loc23_.name);
                  }
                  _loc1_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_custard"))
               {
                  if(_loc2_.length == 0)
                  {
                     _loc9_.push(_loc22_,_loc23_.name);
                  }
                  _loc2_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_cannonball"))
               {
                  if(_loc3_.length == 0)
                  {
                     _loc10_.push(_loc22_,_loc23_.name);
                  }
                  _loc3_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_cannonball_movable"))
               {
                  if(_loc3_.length == 0)
                  {
                     _loc10_.push(_loc22_,_loc23_.name);
                  }
                  _loc3_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_nuke"))
               {
                  if(_loc4_.length == 0)
                  {
                     _loc11_.push(_loc22_,_loc23_.name);
                  }
                  _loc4_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_flame"))
               {
                  if(_loc5_.length == 0)
                  {
                     _loc12_.push(_loc22_,_loc23_.name);
                  }
                  _loc5_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_airstrike"))
               {
                  if(_loc6_.length == 0)
                  {
                     _loc13_.push(_loc22_,_loc23_.name);
                  }
                  _loc6_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_railgun"))
               {
                  if(_loc7_.length == 0)
                  {
                     _loc14_.push(_loc22_,_loc23_.name);
                  }
                  _loc7_.push(_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"tiedup1"))
               {
                  _loc15_.push(_loc22_,_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"tiedup2"))
               {
                  _loc16_.push(_loc22_,_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"tiedup3"))
               {
                  _loc17_.push(_loc22_,_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"tiedup4"))
               {
                  _loc18_.push(_loc22_,_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"tiedup5"))
               {
                  _loc19_.push(_loc22_,_loc23_.name);
               }
               if(FindObjInInstances(_loc23_,"tiedup6"))
               {
                  _loc20_.push(_loc22_,_loc23_.name);
               }
               _loc21_++;
               _loc22_++;
            }
         }
         FlashConnect.trace("");
         FlashConnect.trace("");
         FlashConnect.trace("");
         FlashConnect.trace("!!! Player Layout: (total levels = " + _loc21_ + ")");
         FlashConnect.trace("* player_missile: " + _loc1_.length);
         FlashConnect.trace("* player_custard: " + _loc2_.length);
         FlashConnect.trace("* player_cannonball: " + _loc3_.length);
         FlashConnect.trace("* player_nuke: " + _loc4_.length);
         FlashConnect.trace("* player_flame: " + _loc5_.length);
         FlashConnect.trace("* player_airstrike: " + _loc6_.length);
         FlashConnect.trace("* player_railgun: " + _loc7_.length);
         FlashConnect.trace("* First used player_missile: " + _loc8_[0] + " / " + _loc8_[1]);
         FlashConnect.trace("* First used player_cannonball: " + _loc10_[0] + " / " + _loc10_[1]);
         FlashConnect.trace("* First used player_railgun: " + _loc14_[0] + " / " + _loc14_[1]);
         FlashConnect.trace("* First used player_flame: " + _loc12_[0] + " / " + _loc12_[1]);
         FlashConnect.trace("* First used player_nuke: " + _loc11_[0] + " / " + _loc11_[1]);
         FlashConnect.trace("* First used player_custard: " + _loc9_[0] + " / " + _loc9_[1]);
         FlashConnect.trace("* First used player_airstrike: " + _loc13_[0] + " / " + _loc13_[1]);
         FlashConnect.trace("* player_cannonball tiedup2: " + Boolean(_loc16_.length != 0) + ".. first used: " + _loc16_[0] + " / " + _loc16_[1]);
         FlashConnect.trace("* player_railgun tiedup4: " + Boolean(_loc18_.length != 0) + ".. first used: " + _loc18_[0] + " / " + _loc18_[1]);
         FlashConnect.trace("* player_flame tiedup3: " + Boolean(_loc17_.length != 0) + ".. first used: " + _loc17_[0] + " / " + _loc17_[1]);
         FlashConnect.trace("* player_nuke tiedup5: " + Boolean(_loc19_.length != 0) + ".. first used: " + _loc19_[0] + " / " + _loc19_[1]);
         FlashConnect.trace("* player_custard tiedup6: " + Boolean(_loc20_.length != 0) + ".. first used: " + _loc20_[0] + " / " + _loc20_[1]);
         FlashConnect.trace("* player_airstrike tiedup1: " + Boolean(_loc15_.length != 0) + ".. first used: " + _loc15_[0] + " / " + _loc15_[1]);
         FlashConnect.trace("");
         FlashConnect.trace("");
         FlashConnect.trace("");
         _loc22_ = 1;
         for each(_loc23_ in Levels.list)
         {
            if(_loc23_.creator == "final")
            {
               if(FindObjInInstances(_loc23_,"zombooka_player_cannonball") || FindObjInInstances(_loc23_,"zombooka_player_cannonball_movable"))
               {
                  if(_loc22_ < _loc16_[0])
                  {
                     FlashConnect.trace("ERROR: player_cannonball used on level " + _loc22_ + ":  " + _loc23_.name);
                  }
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_railgun"))
               {
                  if(_loc22_ < _loc18_[0])
                  {
                     FlashConnect.trace("ERROR: player_railgun used on level " + _loc22_ + ":  " + _loc23_.name);
                  }
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_flame"))
               {
                  if(_loc22_ < _loc17_[0])
                  {
                     FlashConnect.trace("ERROR: player_flame used on level " + _loc22_ + ":  " + _loc23_.name);
                  }
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_nuke"))
               {
                  if(_loc22_ < _loc19_[0])
                  {
                     FlashConnect.trace("ERROR: player_nuke used on level " + _loc22_ + ":  " + _loc23_.name);
                  }
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_custard"))
               {
                  if(_loc22_ < _loc20_[0])
                  {
                     FlashConnect.trace("ERROR: zombooka_player_custard used on level " + _loc22_ + ":  " + _loc23_.name);
                  }
               }
               if(FindObjInInstances(_loc23_,"zombooka_player_airstrike"))
               {
                  if(_loc22_ < _loc15_[0])
                  {
                     FlashConnect.trace("ERROR: player_airstrike used on level " + _loc22_ + ":  " + _loc23_.name);
                  }
               }
            }
            _loc22_++;
         }
      }
      
      internal static function ReloadData() : *
      {
         ExternalData.Load(ReloadData_Done);
      }
      
      internal static function ReloadData_Done() : *
      {
      }
      
      internal static function Reload(param1:Function) : *
      {
         ExternalData.Load(param1);
      }
      
      public static function InitLevel() : *
      {
         var _loc1_:GameObj = null;
         KeyReader.InitOnce(main.stage);
         Particles.Reset();
         GameObjects.ClearAll();
         camera.Reset();
         PhysicsBase.InitBox2D();
         levelTimer = 0;
         pause = false;
         StartLevelPlay();
      }
      
      internal static function GetPhysMaterialByName(param1:String) : PhysObj_Material
      {
         var _loc2_:PhysObj_Material = null;
         for each(_loc2_ in physMaterials)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         Utils.traceerror("ERROR, missing physics material: " + param1);
         return new PhysObj_Material();
      }
      
      internal static function LoadPhysMaterials() : *
      {
         var _loc1_:int = 0;
         var _loc3_:XML = null;
         var _loc4_:PhysObj_Material = null;
         physMaterials = new Array();
         var _loc2_:XML = ExternalData.xml;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.material.length())
         {
            _loc3_ = _loc2_.material[_loc1_];
            _loc4_ = new PhysObj_Material();
            _loc4_.FromXML(_loc3_);
            physMaterials.push(_loc4_);
            _loc1_++;
         }
      }
      
      internal static function AddGameObjectAt(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:String = "", param7:String = "", param8:String = "") : GameObj
      {
         var physobj:PhysObj = null;
         var graphic:PhysObj_Graphic = null;
         var objName:String = param1;
         var _x:Number = param2;
         var _y:Number = param3;
         var _rotDeg:Number = param4;
         var _scale:Number = param5;
         var instanceName:String = param6;
         var initParams:String = param7;
         var _id:String = param8;
         var go:GameObj = null;
         physobj = objectDefs.FindByName(objName);
         if(physobj.graphics.length != 0)
         {
            graphic = physobj.graphics[0];
            go = GameObjects.AddObj(_x,_y,graphic.zoffset + zsortoffset);
            go.dobj = GraphicObjects.GetDisplayObjByIndex(graphic.graphicID);
            go.frame = graphic.frame;
            go.dir = Utils.DegToRad(_rotDeg);
            go.scale = _scale;
            go.initParams = initParams;
            go.id = _id;
            if(graphic.goInitFuntion != "")
            {
               go.initFunctionVarString = graphic.goInitFuntionVarString;
               go[graphic.goInitFuntion]();
            }
         }
         try
         {
            go.initFunctionVarString = physobj.initFunctionParameters;
            go[physobj.initFunctionName]();
         }
         catch(err:Error)
         {
            Utils.trace("init function doesn\'t exist: " + physobj.initFunctionName);
         }
         return go;
      }
      
      internal static function GetLineListByType(param1:int) : Array
      {
         var _loc4_:PhysLine = null;
         var _loc2_:Array = new Array();
         var _loc3_:Level = Levels.GetCurrent();
         for each(_loc4_ in _loc3_.lines)
         {
            if(_loc4_.type == param1)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      internal static function GetNumLinesByType(param1:int) : int
      {
         var _loc4_:PhysLine = null;
         var _loc2_:int = 0;
         var _loc3_:Level = Levels.GetCurrent();
         for each(_loc4_ in _loc3_.lines)
         {
            if(_loc4_.type == param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      internal static function GetNearestPathLine(param1:Number, param2:Number) : int
      {
         var _loc7_:PhysLine = null;
         var _loc8_:Number = NaN;
         var _loc3_:Number = 999999;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Level = Levels.GetCurrent();
         for each(_loc7_ in _loc6_.lines)
         {
            if(_loc7_.type == 1)
            {
               _loc8_ = Utils.DistBetweenPoints(param1,param2,_loc7_.points[0].x,_loc7_.points[0].y);
               if(_loc8_ < _loc3_)
               {
                  _loc3_ = _loc8_;
                  _loc4_ = _loc5_;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      internal static function GetLineIndexByTypeIndex(param1:int, param2:int) : int
      {
         var _loc6_:PhysLine = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Level = Levels.GetCurrent();
         for each(_loc6_ in _loc5_.lines)
         {
            if(_loc6_.type == param1)
            {
               if(_loc3_ == param2)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
            _loc4_++;
         }
         return 0;
      }
      
      internal static function GetLineByIndex(param1:int) : PhysLine
      {
         var _loc2_:Level = Levels.GetCurrent();
         return _loc2_.lines[param1];
      }
      
      internal static function InitLines() : *
      {
         var _loc2_:b2Body = null;
         var _loc3_:b2PolygonDef = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc15_:PhysLine = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:PhysObj_Material = null;
         var _loc20_:Triangulate = null;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc23_:Array = null;
         var _loc24_:int = 0;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:PhysObj_BodyUserData = null;
         var _loc28_:GameObj = null;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:b2Shape = null;
         var _loc32_:Object = null;
         var _loc33_:int = 0;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc1_:b2BodyDef = new b2BodyDef();
         var _loc10_:PhysObj_BodyUserData = new PhysObj_BodyUserData();
         _loc10_.bodyName = "wall";
         var _loc11_:Number = 50;
         var _loc12_:Level = Levels.GetCurrent();
         var _loc13_:b2FilterData = new b2FilterData();
         _loc13_.categoryBits = 1;
         _loc13_.maskBits = 31;
         var _loc14_:b2FilterData = new b2FilterData();
         _loc14_.categoryBits = 2;
         _loc14_.maskBits = 2;
         for each(_loc15_ in _loc12_.lines)
         {
            if(_loc15_.type == 0)
            {
               _loc16_ = _loc15_.points;
               _loc17_ = _loc15_.type;
               _loc18_ = _loc15_.objParameters.GetValueString("line_physmaterial");
               _loc19_ = GetPhysMaterialByName(_loc18_);
               if(_loc16_.length >= 3)
               {
                  _loc20_ = new Triangulate();
                  _loc21_ = _loc20_.process(_loc16_);
                  if(_loc21_ == null)
                  {
                     Utils.trace("failed triangulating: " + _loc16_.length + " type: " + _loc17_);
                  }
                  if(_loc21_ != null)
                  {
                     _loc22_ = int(_loc21_.length / 3);
                     _loc23_ = new Array();
                     _loc1_ = new b2BodyDef();
                     _loc24_ = 0;
                     while(_loc24_ < _loc22_)
                     {
                        _loc5_ = _loc21_[_loc24_ * 3 + 0];
                        _loc6_ = _loc21_[_loc24_ * 3 + 1];
                        _loc7_ = _loc21_[_loc24_ * 3 + 2];
                        _loc23_.push(_loc5_);
                        _loc23_.push(_loc6_);
                        _loc23_.push(_loc7_);
                        _loc24_++;
                     }
                     _loc25_ = 0;
                     _loc26_ = 0;
                     _loc24_ = 0;
                     while(_loc24_ < _loc22_)
                     {
                        _loc5_ = _loc23_[_loc24_ * 3 + 0];
                        _loc6_ = _loc23_[_loc24_ * 3 + 1];
                        _loc7_ = _loc23_[_loc24_ * 3 + 2];
                        _loc29_ = (_loc5_.x + _loc6_.x + _loc7_.x) / 3;
                        _loc30_ = (_loc5_.y + _loc6_.y + _loc7_.y) / 3;
                        _loc25_ += _loc29_;
                        _loc26_ += _loc30_;
                        _loc24_++;
                     }
                     _loc25_ /= _loc22_;
                     _loc26_ /= _loc22_;
                     _loc15_.centrex = _loc25_;
                     _loc15_.centrey = _loc26_;
                     _loc1_.position.Set(_loc25_ * PhysicsBase.w2p,_loc26_ * PhysicsBase.w2p);
                     _loc2_ = PhysicsBase.world.CreateBody(_loc1_);
                     _loc24_ = 0;
                     while(_loc24_ < _loc22_)
                     {
                        _loc5_ = _loc23_[_loc24_ * 3 + 0].clone();
                        _loc6_ = _loc23_[_loc24_ * 3 + 1].clone();
                        _loc7_ = _loc23_[_loc24_ * 3 + 2].clone();
                        _loc5_.x -= _loc25_;
                        _loc5_.y -= _loc26_;
                        _loc6_.x -= _loc25_;
                        _loc6_.y -= _loc26_;
                        _loc7_.x -= _loc25_;
                        _loc7_.y -= _loc26_;
                        _loc3_ = new b2PolygonDef();
                        _loc3_.filter = _loc13_;
                        _loc3_.vertexCount = 3;
                        _loc3_.vertices[0].Set(_loc5_.x * PhysicsBase.w2p,_loc5_.y * PhysicsBase.w2p);
                        _loc3_.vertices[1].Set(_loc6_.x * PhysicsBase.w2p,_loc6_.y * PhysicsBase.w2p);
                        _loc3_.vertices[2].Set(_loc7_.x * PhysicsBase.w2p,_loc7_.y * PhysicsBase.w2p);
                        _loc3_.friction = _loc19_.friction;
                        _loc3_.restitution = _loc19_.restitution;
                        _loc3_.density = _loc19_.density;
                        _loc3_.userData = new Object();
                        _loc3_.userData.name = _loc19_.name;
                        _loc31_ = _loc2_.CreateShape(_loc3_);
                        _loc32_ = new Object();
                        _loc32_.origShape = null;
                        _loc32_.name = "";
                        _loc31_.SetUserData(_loc32_);
                        _loc24_++;
                     }
                     _loc27_ = _loc10_.Clone();
                     if(_loc15_.objParameters.GetValueBoolean("line_fixed") == false)
                     {
                        _loc2_.SetMassFromShapes();
                        _loc2_.WakeUp();
                     }
                     _loc28_ = GameObjects.AddObj(0,0,0);
                     _loc28_.InitPhysicsLineObject(_loc15_,_loc2_);
                     _loc27_.gameObjectIndex = _loc28_.listIndex;
                     _loc2_.SetUserData(_loc27_);
                  }
                  else
                  {
                     _loc9_ = 0;
                     while(_loc9_ < _loc16_.length)
                     {
                        _loc5_ = _loc16_[_loc9_].clone();
                        _loc33_ = _loc9_ + 1;
                        _loc33_ = _loc33_ % _loc16_.length;
                        _loc6_ = _loc16_[_loc33_].clone();
                        _loc7_ = _loc6_.clone();
                        _loc8_ = _loc5_.clone();
                        _loc34_ = Math.atan2(_loc6_.y - _loc5_.y,_loc6_.x - _loc5_.x);
                        _loc34_ = _loc34_ + Math.PI / 2;
                        _loc35_ = 7;
                        _loc36_ = Math.cos(_loc34_) * _loc35_;
                        _loc37_ = Math.sin(_loc34_) * _loc35_;
                        _loc7_.x += _loc36_;
                        _loc7_.y += _loc37_;
                        _loc8_.x += _loc36_;
                        _loc8_.y += _loc37_;
                        _loc1_ = new b2BodyDef();
                        _loc1_.position.Set(0,0);
                        _loc2_ = PhysicsBase.world.CreateBody(_loc1_);
                        if(_loc2_ != null)
                        {
                           _loc3_ = new b2PolygonDef();
                           _loc3_.filter = _loc13_;
                           _loc3_.vertexCount = 4;
                           _loc3_.vertices[0].Set(_loc5_.x * PhysicsBase.w2p,_loc5_.y * PhysicsBase.w2p);
                           _loc3_.vertices[1].Set(_loc6_.x * PhysicsBase.w2p,_loc6_.y * PhysicsBase.w2p);
                           _loc3_.vertices[2].Set(_loc7_.x * PhysicsBase.w2p,_loc7_.y * PhysicsBase.w2p);
                           _loc3_.vertices[3].Set(_loc8_.x * PhysicsBase.w2p,_loc8_.y * PhysicsBase.w2p);
                           _loc3_.friction = _loc19_.friction;
                           _loc3_.restitution = _loc19_.restitution;
                           _loc3_.density = _loc19_.density;
                           _loc3_.userData = new Object();
                           _loc3_.userData.name = _loc19_.name;
                           _loc31_ = _loc2_.CreateShape(_loc3_);
                           _loc32_ = new Object();
                           _loc32_.origShape = null;
                           _loc32_.name = "";
                           _loc31_.SetUserData(_loc32_);
                           _loc27_ = _loc10_.Clone();
                           if(_loc15_.objParameters.GetValueBoolean("line_fixed") == false)
                           {
                              _loc2_.SetMassFromShapes();
                              _loc2_.WakeUp();
                           }
                           _loc28_ = GameObjects.AddObj(0,0,0);
                           _loc28_.InitPhysicsLineObject(_loc15_,_loc2_);
                           _loc27_.gameObjectIndex = _loc28_.listIndex;
                           _loc2_.SetUserData(_loc27_);
                        }
                        _loc9_++;
                     }
                  }
               }
            }
         }
      }
      
      public static function NextLevel() : void
      {
         Levels.IncrementLevel();
         StartLevelPlay();
      }
      
      public static function RestartLevel() : void
      {
         StartLevelPlay();
      }
      
      public static function InitLevelGameplay() : *
      {
      }
      
      internal static function scoreOverlay_EnterFrame(param1:Event) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.stop();
            _loc2_.visible = false;
         }
      }
      
      internal static function UpdateLevel() : *
      {
      }
      
      public static function InitLevelState(param1:int) : *
      {
         levelState = param1;
         levelStateTimer = 0;
         if(levelState == levelState_LevelStart)
         {
            levelState = levelState_Play;
         }
         if(levelState == levelState_Complete)
         {
            SoundPlayer.Play("sfx_levelcomplete");
            levelStateTimer = 0;
         }
         if(levelState == levelState_EndScreen)
         {
            InitLevelState(levelState_Null);
            EndLevel();
            if(levelSuccessFlag == true)
            {
               DoEndLevelStuff();
               SaveData.Save();
               if(Levels.currentIndex == 39)
               {
                  Levels.currentIndex = 40;
                  StartLevelPlay();
               }
               else
               {
                  copyScreenBD.copyPixels(main.screenBD,copyScreenBD.rect,Defs.pointZero);
                  copyScreenBD.applyFilter(copyScreenBD,copyScreenBD.rect,Defs.pointZero,new BlurFilter(4,4,3));
                  UI.StartTransitionImmediate("levelcomplete");
               }
            }
            else
            {
               copyScreenBD.copyPixels(main.screenBD,copyScreenBD.rect,Defs.pointZero);
               copyScreenBD.applyFilter(copyScreenBD,copyScreenBD.rect,Defs.pointZero,new BlurFilter(4,4,3));
               UI.StartTransitionImmediate("levelfailed");
            }
         }
         if(levelState == levelState_PlayerDead)
         {
            levelTimer = Defs.fps * 1.5;
         }
         if(levelState == levelState_BonusSection)
         {
            levelTimer = Defs.fps * 10;
         }
         if(levelState == levelState_Play)
         {
            levelStateTimer = 0;
         }
         if(levelState == levelState_Editor)
         {
            PhysEditor.InitEditor(camera.x,camera.y);
            PhysEditor.currentLevel = Levels.currentIndex;
         }
      }
      
      internal static function LevelFailed() : *
      {
         InitLevelState(levelState_Null);
         UI.StartTransition("levelfailed");
      }
      
      public static function ResetEverything() : *
      {
         var _loc1_:Level = null;
         Utils.trace("Reset everything");
         for each(_loc1_ in Levels.list)
         {
            _loc1_.complete = false;
            _loc1_.available = false;
            _loc1_.bestScore = 0;
            _loc1_.percentage = 0;
            _loc1_.bestPercentage = 0;
            _loc1_.rating = 0;
            _loc1_.hasHitRef = false;
         }
         Levels.GetLevel(0).available = true;
         Levels.currentIndex = 0;
         CalculateScore();
      }
      
      internal static function DoEndLevelStuff() : *
      {
         if(levelTimer < 0)
         {
            levelTimer = 0;
         }
         Utils.trace("DoEndLevelStuff");
         var _loc1_:Level = Levels.GetCurrent();
         _loc1_.complete = true;
         _loc1_.lastTime = levelTimer;
         killScore = levelScore;
         levelScore += GameVars.currentShotBonus;
         endLevelScore = levelScore;
         rating = 0;
         if(levelScore >= _loc1_.gold_score)
         {
            rating = 1;
         }
         if(rating > _loc1_.rating)
         {
            _loc1_.rating = rating;
         }
         var _loc2_:int = Levels.currentIndex;
         Levels.IncrementLevel();
         levelJustUnlocked = false;
         _loc1_.levelScore = levelScore;
         var _loc3_:Level = Levels.GetLevel(Levels.currentIndex);
         if(_loc3_ != null)
         {
            if(_loc3_.available == false)
            {
               levelJustUnlocked = true;
            }
            Utils.trace("making available " + _loc3_.id);
            _loc3_.available = true;
         }
         Levels.currentIndex = _loc2_;
         Utils.trace("ENDSTUFF: " + levelScore + "  " + _loc1_.numRockets);
         if(levelScore > _loc1_.bestScore)
         {
            _loc1_.bestScore = levelScore;
         }
         CalculateScore();
         SubmitStats();
      }
      
      internal static function SubmitMinigameStats() : *
      {
         Lic.Kongregate_SubmitStat(GameVars.numBonusKills,"minigame_kills");
         Lic.Kongregate_SubmitStat(GameVars.numBonusBestKillStreak,"minigame_killstreak");
      }
      
      internal static function SubmitStats() : *
      {
         var _loc1_:Level = null;
         Lic.Kongregate_SubmitStat(currentScore,"highscore");
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 40)
         {
            _loc1_ = Levels.GetLevel(_loc4_);
            if(_loc1_.complete)
            {
               _loc2_++;
               if(_loc1_.rating >= 1)
               {
                  _loc3_++;
               }
            }
            _loc4_++;
         }
         Lic.Kongregate_SubmitStat(_loc2_,"numlevelscomplete");
         Lic.Kongregate_SubmitStat(_loc3_,"numlevelsperfect");
      }
      
      internal static function GetHighestScore() : int
      {
         var _loc2_:Level = null;
         var _loc1_:int = 0;
         for each(_loc2_ in Levels.list)
         {
            if(_loc2_.bestScore > _loc1_)
            {
               _loc1_ = _loc2_.bestScore;
            }
         }
         return _loc1_;
      }
      
      internal static function GetNumLevelsUnlocked() : int
      {
         var _loc2_:Level = null;
         var _loc1_:int = 0;
         for each(_loc2_ in Levels.list)
         {
            if(_loc2_.available)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public static function CalculateScore() : *
      {
         var _loc1_:Level = null;
         numGolds = 0;
         currentScore = 0;
         for each(_loc1_ in Levels.list)
         {
            currentScore += _loc1_.bestScore;
            if(_loc1_.rating != 0)
            {
               ++numGolds;
            }
         }
      }
      
      public static function InitLevelPlayFromEditorObjects() : *
      {
         var _loc1_:LevelObj_Instance = null;
         var _loc2_:PhysObj = null;
         zsortoffset = 0;
         level_instances = Levels.GetCurrentLevelInstances();
         for each(_loc1_ in level_instances)
         {
            _loc2_ = objectDefs.FindByName(_loc1_.typeName);
            if(_loc2_.bodies.length == 0)
            {
               Utils.trace("inst.typeName " + _loc1_.typeName);
               AddGameObjectAt(_loc1_.typeName,_loc1_.x,_loc1_.y,_loc1_.rot,_loc1_.scale,_loc1_.instanceName,_loc1_.objParameters.ToString(),_loc1_.id);
               zsortoffset += 0.01;
            }
            else if(_loc2_.graphics.length != 0)
            {
               AddGameObjectAt(_loc1_.typeName,_loc1_.x,_loc1_.y,_loc1_.rot,_loc1_.scale,_loc1_.instanceName,_loc1_.objParameters.ToString(),_loc1_.id);
               zsortoffset += 0.01;
            }
            else
            {
               PhysicsBase.AddPhysObjAt(_loc1_.typeName,_loc1_.x,_loc1_.y,_loc1_.rot,_loc1_.scale,_loc1_.instanceName,_loc1_.objParameters.ToString(),_loc1_.id);
               zsortoffset += 0.01;
            }
         }
      }
      
      public static function InitJoints() : *
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:b2Joint = null;
         var _loc6_:PhysObj_Joint = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:GameObj = null;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:GameObj = null;
         var _loc15_:GameObj = null;
         var _loc16_:GameObj = null;
         var _loc17_:GameObj = null;
         var _loc18_:b2RevoluteJointDef = null;
         var _loc19_:b2DistanceJointDef = null;
         var _loc20_:b2PrismaticJointDef = null;
         var _loc21_:b2Vec2 = null;
         var _loc22_:b2Vec2 = null;
         var _loc1_:Level = Levels.GetCurrent();
         var _loc2_:Array = Levels.GetCurrentLevelJoints();
         for each(_loc6_ in _loc2_)
         {
            _loc7_ = PhysicsBase.groundBody;
            _loc8_ = PhysicsBase.groundBody;
            if(_loc6_.obj0Name == "")
            {
               Utils.trace("jb0 using ground");
            }
            else
            {
               _loc14_ = GameObjects.GetGameObjById(_loc6_.obj0Name);
               _loc15_ = GameObjects.GetGameObjByLineName(_loc6_.obj0Name);
               if(_loc14_ != null)
               {
                  if(_loc14_.bodies == null)
                  {
                     Utils.traceerror("ERROR: jb0 joint.obj0Name " + _loc6_.obj0Name);
                  }
                  _loc7_ = _loc14_.bodies[0];
                  Utils.trace("jb0 joint.obj0Name " + _loc6_.obj0Name);
               }
               else if(_loc15_ != null)
               {
                  if(_loc15_.bodies == null)
                  {
                     Utils.traceerror("ERROR: jb0a joint.obj0Name " + _loc6_.obj0Name);
                  }
                  _loc7_ = _loc15_.bodies[0];
                  Utils.trace("jb0 joint.obj0Name is a line: " + _loc6_.obj0Name);
               }
               else
               {
                  Utils.trace("jb0 gameobject not found " + _loc6_.obj0Name);
               }
            }
            if(_loc6_.obj1Name == "")
            {
               Utils.trace("jb1 using ground");
            }
            else
            {
               _loc16_ = GameObjects.GetGameObjById(_loc6_.obj1Name);
               _loc17_ = GameObjects.GetGameObjByLineName(_loc6_.obj1Name);
               if(_loc16_ != null)
               {
                  _loc8_ = _loc16_.bodies[0];
                  Utils.trace("jb1 joint.obj1Name " + _loc6_.obj1Name);
               }
               else if(_loc17_ != null)
               {
                  _loc8_ = _loc17_.bodies[0];
                  Utils.trace("jb0 joint.obj1Name is a line: " + _loc6_.obj1Name);
               }
               else
               {
                  Utils.trace("jb1 gameobject not found " + _loc6_.obj1Name);
               }
            }
            if(_loc6_.type == PhysObj_Joint.Type_Rev)
            {
               Utils.trace("adding body here " + _loc7_ + " " + _loc8_);
               _loc18_ = new b2RevoluteJointDef();
               _loc3_ = new Point(_loc6_.rev_pos.x * PhysicsBase.w2p,_loc6_.rev_pos.y * PhysicsBase.w2p);
               _loc18_.Initialize(_loc7_,_loc8_,new b2Vec2(_loc3_.x,_loc3_.y));
               _loc18_.enableLimit = _loc6_.objParameters.GetValueBoolean("rev_enablelimit");
               _loc18_.lowerAngle = Utils.DegToRad(_loc6_.objParameters.GetValueNumber("rev_lowerangle"));
               _loc18_.upperAngle = Utils.DegToRad(_loc6_.objParameters.GetValueNumber("rev_upperangle"));
               _loc18_.enableMotor = _loc6_.objParameters.GetValueBoolean("rev_enablemotor");
               _loc18_.motorSpeed = _loc6_.objParameters.GetValueNumber("rev_motorspeed");
               _loc18_.maxMotorTorque = _loc6_.objParameters.GetValueNumber("rev_maxmotortorque");
               _loc18_.collideConnected = false;
               _loc5_ = PhysicsBase.world.CreateJoint(_loc18_);
            }
            if(_loc6_.type == PhysObj_Joint.Type_Distance)
            {
               _loc19_ = new b2DistanceJointDef();
               _loc3_ = new Point(_loc6_.dist_pos0.x * PhysicsBase.w2p,_loc6_.dist_pos0.y * PhysicsBase.w2p);
               _loc4_ = new Point(_loc6_.dist_pos1.x * PhysicsBase.w2p,_loc6_.dist_pos1.y * PhysicsBase.w2p);
               _loc19_.Initialize(_loc7_,_loc8_,new b2Vec2(_loc3_.x,_loc3_.y),new b2Vec2(_loc4_.x,_loc4_.y));
               _loc19_.collideConnected = false;
               _loc5_ = PhysicsBase.world.CreateJoint(_loc19_);
            }
            if(_loc6_.type == PhysObj_Joint.Type_Prismatic)
            {
               _loc20_ = new b2PrismaticJointDef();
               _loc21_ = new b2Vec2(_loc6_.prism_pos1.x - _loc6_.prism_pos.x,_loc6_.prism_pos1.y - _loc6_.prism_pos.y);
               _loc21_.Normalize();
               _loc22_ = new b2Vec2(_loc6_.prism_pos.x * PhysicsBase.w2p,_loc6_.prism_pos.y * PhysicsBase.w2p);
               _loc20_.Initialize(_loc7_,_loc8_,_loc22_,_loc21_);
               _loc20_.enableLimit = _loc6_.objParameters.GetValueBoolean("prismatic_enablelimit");
               _loc20_.lowerTranslation = _loc6_.objParameters.GetValueNumber("prismatic_lowertranslation") * PhysicsBase.w2p;
               _loc20_.upperTranslation = _loc6_.objParameters.GetValueNumber("prismatic_uppertranslation") * PhysicsBase.w2p;
               _loc20_.enableMotor = _loc6_.objParameters.GetValueBoolean("prismatic_enablemotor");
               _loc20_.motorSpeed = _loc6_.objParameters.GetValueNumber("prismatic_motorspeed");
               _loc20_.maxMotorForce = _loc6_.objParameters.GetValueNumber("prismatic_maxmotorforce");
               _loc20_.collideConnected = false;
               _loc5_ = PhysicsBase.world.CreateJoint(_loc20_);
            }
            _loc9_ = -1;
            _loc10_ = -1;
            if(_loc14_ != null)
            {
               _loc14_.AddJointReference(_loc5_);
               _loc9_ = _loc14_.listIndex;
            }
            if(_loc16_ != null)
            {
               _loc16_.AddJointReference(_loc5_);
               _loc10_ = _loc16_.listIndex;
            }
            _loc11_ = null;
            _loc12_ = -1;
            _loc13_ = _loc6_.objParameters.GetValueString("joint_initfunction");
            if(_loc13_ != null)
            {
               if(_loc13_ != "")
               {
                  _loc11_ = GameObjects.AddObj(0,0,0);
                  _loc11_[_loc13_](_loc5_);
                  _loc12_ = _loc11_.controlIndex;
               }
            }
            _loc5_.SetUserData(new PhysObj_JointUserData(_loc9_,_loc10_));
         }
      }
      
      internal static function RelinkAllJoints() : *
      {
         var _loc1_:GameObj = null;
         var _loc2_:b2Joint = null;
         var _loc3_:PhysObj_JointUserData = null;
         for each(_loc1_ in GameObjects.objs)
         {
            _loc1_.joints = new Array();
         }
         _loc2_ = PhysicsBase.world.GetJointList();
         while(_loc2_)
         {
            _loc3_ = _loc2_.GetUserData();
            if(_loc3_.gameObjectIndex0 != -1)
            {
               GameObjects.objs[_loc3_.gameObjectIndex0].AddJointReference(_loc2_);
            }
            if(_loc3_.gameObjectIndex1 != -1)
            {
               GameObjects.objs[_loc3_.gameObjectIndex1].AddJointReference(_loc2_);
            }
            _loc2_ = _loc2_.GetNext();
         }
      }
      
      internal static function TransferJoints(param1:GameObj, param2:GameObj) : *
      {
         var _loc3_:b2Joint = null;
         var _loc4_:PhysObj_JointUserData = null;
         Utils.trace("from " + param1.name + "  " + param1.listIndex + "   to " + param2.name + "  " + param2.listIndex);
         _loc3_ = PhysicsBase.world.GetJointList();
         while(_loc3_)
         {
            _loc4_ = _loc3_.GetUserData();
            Utils.trace("joint user data " + _loc4_.gameObjectIndex0 + "  " + _loc4_.gameObjectIndex1);
            if(_loc4_.gameObjectIndex0 == param1.listIndex)
            {
               _loc3_.m_body1 = param2.bodies[0];
               _loc4_.gameObjectIndex0 = param2.listIndex;
               _loc3_.SetUserData(_loc4_);
               Utils.trace("joint body 1 getting TO object");
            }
            if(_loc4_.gameObjectIndex1 == param1.listIndex)
            {
               _loc3_.m_body2 = param2.bodies[0];
               _loc4_.gameObjectIndex1 = param2.listIndex;
               _loc3_.SetUserData(_loc4_);
               Utils.trace("joint body 2 getting TO object");
            }
            _loc3_ = _loc3_.GetNext();
         }
         RelinkAllJoints();
      }
      
      internal static function GetMapData(param1:int, param2:int) : int
      {
         var _loc3_:Level = Levels.GetCurrent();
         param1 /= _loc3_.mapCellW;
         param2 /= _loc3_.mapCellH;
         if(param1 < _loc3_.mapMinX || param1 > _loc3_.mapMaxX || param2 < _loc3_.mapMinY || param2 > _loc3_.mapMaxY)
         {
            return 0;
         }
         var _loc4_:int = _loc3_.mapMaxX - _loc3_.mapMinX + 1;
         param1 -= _loc3_.mapMinX;
         param2 -= _loc3_.mapMinY;
         return _loc3_.map[param1 + param2 * _loc4_];
      }
      
      public static function StartLevelPlay() : void
      {
         var _loc1_:GameObj = null;
         var _loc4_:GameObj = null;
         Mouse.show();
         KeyReader.InitOnce(main.stage);
         QuietAllSounds();
         boundingRectangle = new Rectangle(0,0,Defs.displayarea_w,Defs.displayarea_h);
         textFrameOffset = 0;
         var _loc2_:Level = Levels.GetCurrent();
         Particles.Reset();
         Debug.StartImmediateTimer();
         PhysicsBase.InitBox2D();
         camera.ResetBounds();
         GameVars.InitForLevel();
         ResetSoundActiveFlags();
         InitOpponentTeam();
         GameVars.currentPlayerHead = Levels.currentIndex % 8;
         GameVars.currentRaceA = Levels.currentIndex % 2;
         GameVars.currentRaceB = (Levels.currentIndex + 1) % 2;
         RemoveZombieDobjs();
         GameObjects.ClearAll();
         InitLevelState(levelState_LevelStart);
         InitLevelPlayFromEditorObjects();
         InitLines();
         InitJoints();
         pause = false;
         pauseGameplayInput = false;
         Debug.StartImmediateTimer();
         levelTimer = 0;
         levelScore = 0;
         currentScore = 0;
         currentMC.addChild(hudController.hudMC);
         if(_loc2_.name == "Dancing")
         {
            MusicPlayer.StartStream("bonus_music");
         }
         else if(_loc2_.bgFrame == 5 || _loc2_.bgFrame == 9)
         {
            MusicPlayer.StartStream("game_novelty");
         }
         else
         {
            MusicPlayer.StartStream("game_music" + int(currentGameMusic + 1));
         }
         ++currentGameMusic;
         if(currentGameMusic >= 3)
         {
            currentGameMusic = 0;
         }
         Debug.StartImmediateTimer();
         scoreMultiplier = 1;
         InitLevelGameplay();
         currentBackground = Levels.currentIndex % 3;
         _loc1_ = GameObjects.AddObj(0,0,5000);
         _loc1_.InitJointRenderer();
         goPolyLayer = GameObjects.AddObj(0,0,0);
         goPolyLayer.InitPolyLayer();
         goBackground = GameObjects.AddObj(0,0,15000);
         goBackground.InitBackground();
         InitControl();
         Debug.StartImmediateTimer();
         StartLevelSounds();
         hudController.SetupMuteButtons();
         Debug.StartImmediateTimer();
         hudController.Update();
         InitDrag();
         InitBallPathForLevel();
         InitScroll();
         UpdateGameplay();
         createdForegroundBitmaps = false;
         CreateForegroundBitmaps();
         var _loc3_:GameObj = GameObjects.GetGameObjByName("initial_player_marker");
         if(_loc3_ != null)
         {
            _loc4_ = GameObjects.GetNearestGameObjByName("player",_loc3_.xpos,_loc3_.ypos);
            if(_loc4_ != null)
            {
               SetActivePlayer(_loc4_);
            }
         }
         ClearRenderBallPathParams();
         hudController.InitForLevel();
      }
      
      internal static function InitOpponentTeam() : *
      {
         var _loc1_:Array = new Array(new Array(1,2,3,4,5,6,7),new Array(0,2,3,4,5,6,7),new Array(0,1,3,5,6),new Array(0,1,5,6),new Array(0,1,4,5),new Array(0,1,2,3,6,7),new Array(0,1,2,3,4,5,7),new Array(0,1,2,3,5,6));
         var _loc2_:Array = _loc1_[GameVars.team_index];
         GameVars.opponent_team_index = _loc2_[Levels.currentIndex % _loc2_.length];
      }
      
      internal static function RemoveZombieDobjs() : *
      {
      }
      
      internal static function InitBackgroundSounds() : *
      {
      }
      
      internal static function EndLevel() : *
      {
         QuietAllSounds();
      }
      
      internal static function QuietAllSounds() : *
      {
         var _loc1_:SoundChannel = null;
         SoundPlayer.Reset();
      }
      
      internal static function ResetSoundActiveFlags() : *
      {
         flameActive = false;
         flameActive1 = false;
         sawingActive = false;
         chainsawActive = false;
         chainsawLevel = 0.2;
         chainsawToLevel = 0.2;
         pianoLevel = 0.4;
         pianoCount = 0;
         sparksActive = false;
         mincerActive = false;
         flameLevel = 1;
         circularSawActive = false;
         circularSawLevel = 0.2;
         circularSawToLevel = 0.2;
      }
      
      internal static function UpdateLevelSounds() : *
      {
         var _loc1_:SoundChannel = null;
         if(chainsawToLevel > 0.2)
         {
            chainsawToLevel -= 0.01;
         }
         if(chainsawLevel > chainsawToLevel)
         {
            chainsawLevel -= 0.01;
            if(chainsawLevel < chainsawToLevel)
            {
               chainsawLevel = chainsawToLevel;
            }
         }
         if(chainsawLevel < chainsawToLevel)
         {
            chainsawLevel += 0.1;
            if(chainsawLevel > chainsawToLevel)
            {
               chainsawLevel = chainsawToLevel;
            }
         }
         if(circularSawToLevel > 0.2)
         {
            circularSawToLevel -= 0.01;
         }
         if(circularSawLevel > circularSawToLevel)
         {
            circularSawLevel -= 0.01;
            if(circularSawLevel < circularSawToLevel)
            {
               circularSawLevel = circularSawToLevel;
            }
         }
         if(circularSawLevel < circularSawToLevel)
         {
            circularSawLevel += 0.1;
            if(circularSawLevel > circularSawToLevel)
            {
               circularSawLevel = circularSawToLevel;
            }
         }
         if(pianoCount > 0)
         {
            _loc1_ = SoundPlayer.GetSoundChannelByName("pianosong");
            SoundPlayer.SetSoundChannelVolume(_loc1_,pianoLevel);
         }
         else
         {
            _loc1_ = SoundPlayer.GetSoundChannelByName("pianosong");
            if(_loc1_ != null)
            {
               SoundPlayer.SetSoundChannelVolume(_loc1_,0);
            }
         }
         if(chainsawActive)
         {
            _loc1_ = SoundPlayer.GetSoundChannelByName("chainsaw");
            SoundPlayer.SetSoundChannelVolume(_loc1_,chainsawLevel);
         }
         if(circularSawActive)
         {
            _loc1_ = SoundPlayer.GetSoundChannelByName("circularsaw");
            SoundPlayer.SetSoundChannelVolume(_loc1_,circularSawLevel);
         }
         if(flameActive || flameActive1)
         {
            _loc1_ = SoundPlayer.GetSoundChannelByName("flame");
            SoundPlayer.SetSoundChannelVolume(_loc1_,flameLevel);
         }
      }
      
      internal static function StopAllLoops() : *
      {
      }
      
      internal static function StartLevelSounds() : *
      {
         var _loc1_:SoundChannel = null;
         SoundPlayer.Play("sfx_flame_loop",1,9999999,"flame");
         _loc1_ = SoundPlayer.GetSoundChannelByName("flame");
         SoundPlayer.SetSoundChannelVolume(_loc1_,0);
         if(pianoCount > 0)
         {
            SoundPlayer.Play("sfx_pianosong",1,9999999,"pianosong");
            _loc1_ = SoundPlayer.GetSoundChannelByName("pianosong");
            SoundPlayer.SetSoundChannelVolume(_loc1_,pianoLevel);
         }
         if(sawingActive)
         {
            SoundPlayer.Play("sfx_sawing_loop",1,9999999,"sawing");
            _loc1_ = SoundPlayer.GetSoundChannelByName("sawing");
            SoundPlayer.SetSoundChannelVolume(_loc1_,chainsawLevel);
         }
         if(chainsawActive)
         {
            SoundPlayer.Play("sfx_chainsaw",1,9999999,"chainsaw");
            _loc1_ = SoundPlayer.GetSoundChannelByName("chainsaw");
            SoundPlayer.SetSoundChannelVolume(_loc1_,chainsawLevel);
         }
         if(circularSawActive)
         {
            SoundPlayer.Play("sfx_circular_saw_loop",1,9999999,"circularsaw");
            _loc1_ = SoundPlayer.GetSoundChannelByName("circularsaw");
            SoundPlayer.SetSoundChannelVolume(_loc1_,circularSawLevel);
         }
         if(sparksActive)
         {
            SoundPlayer.Play("sfx_sparks_loop",1,9999999,"sparks");
            _loc1_ = SoundPlayer.GetSoundChannelByName("sparks");
            SoundPlayer.SetSoundChannelVolume(_loc1_,1);
         }
         if(mincerActive)
         {
            SoundPlayer.Play("sfx_mincer_loop",1,9999999,"mincer");
            _loc1_ = SoundPlayer.GetSoundChannelByName("mincer");
            SoundPlayer.SetSoundChannelVolume(_loc1_,1);
         }
      }
      
      public static function UpdateGameplay() : void
      {
         var _loc3_:int = 0;
         Debug.StartTimers();
         if(gameState == gameState_UI)
         {
            return;
         }
         if(pause)
         {
            return;
         }
         if(PauseMenu.IsPaused())
         {
            return;
         }
         if(levelState == levelState_EndScreen)
         {
            return;
         }
         if(levelState == levelState_Null)
         {
            return;
         }
         if(levelState == levelState_Editor)
         {
            PhysEditor.UpdateEditor();
            return;
         }
         if(usedebug)
         {
            if(KeyReader.Pressed(KeyReader.KEY_S))
            {
               Screenshot.Level_Dump();
            }
            if(KeyReader.Pressed(KeyReader.KEY_SPACE))
            {
               InitLevelState(levelState_Editor);
            }
         }
         var _loc1_:int = 1;
         if(GameVars.fastForwardFlag)
         {
            _loc1_ = 10;
         }
         if(usedebug)
         {
            if(KeyReader.Pressed(KeyReader.KEY_1))
            {
            }
            if(KeyReader.Pressed(KeyReader.KEY_2))
            {
               ReloadData();
            }
            if(KeyReader.Pressed(KeyReader.KEY_3))
            {
               Debug.debugMode ^= 1;
            }
            if(KeyReader.Pressed(KeyReader.KEY_4))
            {
               Debug.debugMode ^= 2;
            }
            if(KeyReader.Pressed(KeyReader.KEY_6))
            {
            }
            if(KeyReader.Pressed(KeyReader.KEY_7))
            {
               Reload(InitLevel);
            }
            if(KeyReader.Pressed(KeyReader.KEY_8))
            {
               Levels.DecrementLevel();
               StartLevelPlay();
            }
            if(KeyReader.Pressed(KeyReader.KEY_9))
            {
               NextLevel();
            }
         }
         if(levelState == levelState_Complete)
         {
            ++levelStateTimer;
            _loc3_ = Defs.fps * 2;
            if(levelStateTimer > _loc3_)
            {
               InitLevelState(levelState_EndScreen);
            }
         }
         if(levelState == levelState_Play)
         {
            if(levelStateTimer == 1)
            {
            }
            ++levelStateTimer;
         }
         if(levelState == levelState_LevelStart)
         {
         }
         if(levelState == levelState_Play || levelState == levelState_BonusSection)
         {
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            Debug.StartTimer("box2d");
            if(UI.isInTransition == false)
            {
               PhysicsBase.world.Step(PhysicsBase.physStep,PhysicsBase.physNumIterations);
               PhysicsBase.world.Step(PhysicsBase.physStep,PhysicsBase.physNumIterations);
            }
            Debug.EndTimer("box2d");
            GameObjects.UpdateGOsFromPhysics();
            if(levelState == levelState_Play || levelState == levelState_LevelStart || levelState == levelState_Complete || levelState == levelState_BonusSection || levelState == levelState_BonusSectionStart)
            {
               GameObjects.ClearAddList();
               if(UI.isInTransition == false)
               {
                  GameObjects.Update();
               }
               Collision.Update();
               Debug.StartTimer("particles");
               Debug.EndTimer("particles");
               GameObjects.KillObjects();
               GameObjects.DoAddList();
            }
            UpdateLevelSounds();
            Particles.Update();
            hudController.Update();
            if(levelState == levelState_Play)
            {
               ++levelTimer;
            }
            if(levelState == levelState_PlayerDead)
            {
            }
            if(levelState == levelState_Play)
            {
               if(doLevelEndTests)
               {
                  if(GameVars.totalZombies != 0)
                  {
                     if(GameVars.numZombiesKilled == GameVars.totalZombies)
                     {
                        if(GameVars.totalHostages == 0)
                        {
                           levelSuccessFlag = true;
                           InitLevelState(levelState_Complete);
                        }
                        else if(GameVars.numHostagesRescued >= GameVars.totalHostages)
                        {
                           levelSuccessFlag = true;
                           InitLevelState(levelState_Complete);
                        }
                     }
                  }
                  if(GameVars.totalHumans != 0)
                  {
                     if(GameVars.numHumansKilled > 0)
                     {
                        levelSuccessFlag = false;
                        InitLevelState(levelState_Complete);
                     }
                  }
                  if(GameVars.playerKilled)
                  {
                     levelSuccessFlag = false;
                     InitLevelState(levelState_Complete);
                  }
               }
            }
            UpdateScroll();
            _loc2_++;
         }
      }
      
      internal static function InitCreateForegroundBitmaps() : *
      {
      }
      
      internal static function CreateForegroundBitmaps() : *
      {
         var _loc3_:GameObj = null;
         if(createdForegroundBitmaps)
         {
            return;
         }
         createdForegroundBitmaps = true;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         camera.x = 0;
         camera.y = 0;
         for each(_loc3_ in GameObjects.objs)
         {
            if(_loc3_.active && _loc3_.isPolyObject && _loc3_.visible)
            {
               if(_loc3_.linkedPhysLine != null)
               {
                  _loc3_.linkedPhysLine.CalcBoundingRectangle();
               }
               _loc1_.push(_loc3_);
            }
            if(_loc3_.active && _loc3_.name == "decal")
            {
               _loc2_.push(_loc3_);
            }
         }
         scrollScreenBD.fillRect(scrollScreenBD.rect,0);
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.renderFunction != null)
            {
               _loc3_.xpos -= boundingRectangle.left;
               _loc3_.ypos -= boundingRectangle.top;
               _loc3_.bd = scrollScreenBD;
               _loc3_.renderFunction();
               _loc3_.xpos += boundingRectangle.left;
               _loc3_.ypos += boundingRectangle.top;
               _loc3_.visible = false;
            }
         }
         for each(_loc3_ in _loc2_)
         {
            _loc3_.xpos -= boundingRectangle.left;
            _loc3_.ypos -= boundingRectangle.top;
            _loc3_.Render(scrollScreenBD);
            _loc3_.xpos += boundingRectangle.left;
            _loc3_.ypos += boundingRectangle.top;
            _loc3_.RemoveObject();
         }
      }
      
      internal static function InitScroll() : *
      {
         scrollFirstTime = true;
      }
      
      internal static function UpdateScroll() : *
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc1_:GameObj = GetActivePlayer();
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:b2Vec2 = _loc1_.GetBodyWorldPosWorldCoords(0);
         var _loc3_:Number = 0.1;
         var _loc4_:Number = Defs.displayarea_w / 2;
         var _loc5_:Number = Defs.displayarea_h / 2;
         if(scrollFirstTime)
         {
            scrollFirstTime = false;
            _loc3_ = 1;
         }
         _loc6_ = MouseControl.x;
         _loc7_ = MouseControl.y;
         _loc8_ = (_loc6_ - _loc4_) * 0.5 + _loc2_.x - _loc4_;
         _loc9_ = (_loc7_ - _loc5_) * 0.5 + _loc2_.y - _loc5_;
         camera.x += (_loc8_ - camera.x) * _loc3_;
         camera.y += (_loc9_ - camera.y) * _loc3_;
         if(camera.x < boundingRectangle.x)
         {
            camera.x = boundingRectangle.x;
         }
         if(camera.y < boundingRectangle.y)
         {
            camera.y = boundingRectangle.y;
         }
         if(camera.x + Defs.displayarea_w > boundingRectangle.right)
         {
            camera.x = boundingRectangle.right - Defs.displayarea_w;
         }
         if(camera.y + Defs.displayarea_h > boundingRectangle.bottom)
         {
            camera.y = boundingRectangle.bottom - Defs.displayarea_h;
         }
      }
      
      public static function GetRankString(param1:Number) : String
      {
         param1 *= 0.01;
         if(param1 <= 0.2)
         {
            return "E";
         }
         if(param1 <= 0.4)
         {
            return "D";
         }
         if(param1 <= 0.6)
         {
            return "C";
         }
         if(param1 <= 0.8)
         {
            return "B";
         }
         if(param1 <= 0.9)
         {
            return "A";
         }
         if(param1 <= 0.95)
         {
            return "AA";
         }
         if(param1 >= 1)
         {
            return "AAA";
         }
         return "POO";
      }
      
      public static function GetRankIndex(param1:Number) : int
      {
         param1 *= 0.01;
         if(param1 <= 0.2)
         {
            return 0;
         }
         if(param1 <= 0.4)
         {
            return 1;
         }
         if(param1 <= 0.6)
         {
            return 2;
         }
         if(param1 <= 0.8)
         {
            return 3;
         }
         if(param1 <= 0.9)
         {
            return 4;
         }
         if(param1 <= 0.95)
         {
            return 5;
         }
         if(param1 >= 1)
         {
            return 6;
         }
         return 0;
      }
      
      public static function AddScore(param1:int) : void
      {
         levelScore += param1;
      }
      
      internal static function RenderBox2DBackground(param1:BitmapData) : void
      {
         var _loc5_:int = 0;
         var _loc6_:b2Body = null;
         var _loc7_:b2Shape = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         var _loc10_:* = undefined;
         var _loc11_:b2PolygonShape = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:Matrix = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         var _loc20_:b2CircleShape = null;
         var _loc21_:Number = NaN;
         var _loc2_:Number = Game.camera.x;
         var _loc3_:Number = Game.camera.y;
         var _loc4_:Number = PhysicsBase.p2w;
         _loc6_ = PhysicsBase.world.GetBodyList();
         while(_loc6_)
         {
            _loc8_ = _loc6_.GetPosition();
            _loc9_ = _loc6_.GetAngle();
            _loc7_ = _loc6_.GetShapeList();
            while(_loc7_)
            {
               _loc10_ = _loc7_.GetType();
               if(_loc10_ == b2Shape.e_polygonShape)
               {
                  _loc11_ = b2PolygonShape(_loc7_);
                  _loc12_ = _loc11_.GetVertices();
                  _loc13_ = _loc11_.GetVertexCount();
                  _loc5_ = 0;
                  while(_loc5_ < _loc13_)
                  {
                     _loc14_ = _loc5_ + 1;
                     if(_loc14_ >= _loc13_)
                     {
                        _loc14_ = 0;
                     }
                     _loc15_ = _loc12_[_loc5_].Copy();
                     _loc16_ = _loc12_[_loc14_].Copy();
                     _loc17_ = new Matrix();
                     _loc17_.rotate(_loc9_);
                     _loc18_ = new Point(_loc15_.x,_loc15_.y);
                     _loc19_ = new Point(_loc16_.x,_loc16_.y);
                     _loc18_ = _loc17_.transformPoint(_loc18_);
                     _loc19_ = _loc17_.transformPoint(_loc19_);
                     _loc15_.x = _loc18_.x;
                     _loc15_.y = _loc18_.y;
                     _loc16_.x = _loc19_.x;
                     _loc16_.y = _loc19_.y;
                     _loc15_.Add(_loc8_);
                     _loc16_.Add(_loc8_);
                     Utils.RenderDotLine(param1,_loc15_.x * _loc4_ - _loc2_,_loc15_.y * _loc4_ - _loc3_,_loc16_.x * _loc4_ - _loc2_,_loc16_.y * _loc4_ - _loc3_,500,4294901760);
                     _loc5_++;
                  }
               }
               if(_loc10_ == b2Shape.e_circleShape)
               {
                  _loc20_ = b2CircleShape(_loc7_);
                  _loc21_ = _loc20_.GetRadius() * _loc4_;
                  Utils.RenderCircle(param1,_loc8_.x * _loc4_ - _loc2_,_loc8_.y * _loc4_ - _loc3_,_loc21_,4294967295);
               }
               _loc7_ = _loc7_.GetNext();
            }
            _loc6_ = _loc6_.GetNext();
         }
      }
      
      public static function Render() : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(gameState == gameState_UI)
         {
            return;
         }
         if(pause)
         {
            return;
         }
         if(PauseMenu.IsPaused())
         {
            return;
         }
         if(levelState == levelState_EndScreen)
         {
            return;
         }
         if(levelState == levelState_Null)
         {
            return;
         }
         if(levelState == levelState_Editor)
         {
            return;
         }
         var _loc1_:BitmapData = main.screenBD;
         var _loc7_:Level = Levels.GetCurrent();
         Debug.StartTimer("render");
         GameObjects.Render(_loc1_);
         Particles.Render(_loc1_);
         RenderBallPathFromParams();
         Debug.RenderBox2D(_loc1_);
         Debug.RenderLines(_loc1_);
         Debug.EndTimer("render");
         Debug.StopTimers();
         RenderPanel();
         Debug.RenderTimers(main.screenBD);
      }
      
      internal static function RenderCircle(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:uint) : void
      {
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc6_:int = 50;
         var _loc7_:Number = Math.PI * 2 / _loc6_;
         var _loc9_:Number = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc10_ = _loc8_ + 1;
            _loc11_ = _loc9_ + _loc7_;
            _loc12_ = param2 + Math.cos(_loc9_) * param4;
            _loc13_ = param3 + Math.sin(_loc9_) * param4;
            _loc14_ = param2 + Math.cos(_loc11_) * param4;
            _loc15_ = param3 + Math.sin(_loc11_) * param4;
            _loc9_ += _loc7_;
            param1.beginFill(param5,1);
            param1.lineStyle(null,null,0);
            param1.moveTo(param2,param3);
            param1.lineTo(_loc12_,_loc13_);
            param1.lineTo(_loc14_,_loc15_);
            param1.lineTo(param2,param3);
            param1.endFill();
            _loc8_++;
         }
      }
      
      internal static function RenderCursor(param1:BitmapData) : *
      {
      }
      
      public static function RenderNearGOs(param1:BitmapData) : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:int = int(zorder.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = zorder[_loc4_];
            if(_loc2_.zpos < -1000)
            {
               _loc2_.Render(param1);
            }
            _loc4_++;
         }
      }
      
      public static function RenderFarGOs(param1:BitmapData) : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         Debug.StartTimer("sort");
         _loc3_ = 0;
         zorder = new Array();
         for each(_loc2_ in GameObjects.objs)
         {
            if(_loc2_.active && _loc2_.visible)
            {
               zorder.push(_loc2_);
               _loc3_++;
            }
         }
         zorder.sortOn("zpos",Array.NUMERIC | Array.DESCENDING);
         Debug.EndTimer("sort");
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = zorder[_loc4_];
            if(_loc2_.zpos >= -1000)
            {
               _loc2_.Render(param1);
            }
            _loc4_++;
         }
      }
      
      internal static function RenderFloorGrass(param1:BitmapData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc8_:PhysLine = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc5_:Level = Levels.GetCurrent();
         var _loc6_:DisplayObj = GraphicObjects.GetDisplayObjByName("spikes");
         var _loc7_:int = _loc6_.GetNumFrames();
         for each(_loc8_ in _loc5_.lines)
         {
            if(_loc8_.type == 3)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc8_.points.length)
               {
                  _loc9_ = _loc2_ + 1;
                  _loc9_ = _loc9_ % _loc8_.points.length;
                  _loc3_ = _loc8_.points[_loc2_].clone();
                  _loc4_ = _loc8_.points[_loc9_].clone();
                  _loc10_ = _loc4_.x - _loc3_.x;
                  _loc11_ = _loc4_.y - _loc3_.y;
                  _loc12_ = Utils.DistBetweenPoints(_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y);
                  _loc10_ /= _loc12_;
                  _loc11_ /= _loc12_;
                  _loc13_ = 0;
                  while(_loc13_ < _loc12_)
                  {
                     _loc14_ = _loc3_.x + _loc10_ * _loc13_;
                     _loc15_ = _loc3_.y + _loc11_ * _loc13_;
                     _loc16_ = Math.atan2(_loc11_,_loc10_);
                     _loc6_.RenderAtRotScaled(Utils.RandBetweenInt(0,_loc7_ - 1),param1,_loc14_,_loc15_,1,_loc16_,null,true);
                     _loc13_ += 7;
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      internal static function RenderLines() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:PhysLine = null;
         var _loc12_:uint = 0;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc17_:BitmapData = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         var _loc1_:Matrix = new Matrix();
         var _loc2_:Graphics = fillScreenMC.graphics;
         _loc2_.clear();
         var _loc3_:Level = Levels.GetCurrent();
         var _loc4_:Array = new Array(0,0,1,2);
         for each(_loc11_ in _loc3_.lines)
         {
         }
         _loc12_ = 43520;
         _loc13_ = new Array(16777215,16777215,16777215,16777215);
         _loc14_ = _loc3_.numRockets - 1;
         if(_loc14_ < 0)
         {
            _loc14_ = 0;
         }
         var _loc15_:DisplayObj = GraphicObjects.GetDisplayObjByName("fill");
         var _loc16_:int = _loc15_.GetNumFrames();
         _loc17_ = _loc15_.GetBitmapData(_loc14_);
         for each(_loc11_ in _loc3_.lines)
         {
            _loc17_ = _loc15_.GetBitmapData(_loc4_[_loc11_.type]);
            if(_loc11_.type == 3)
            {
               _loc2_.lineStyle(3,8421504,1);
               _loc2_.beginBitmapFill(_loc17_);
               _loc19_ = _loc11_.points[0].clone();
               _loc2_.moveTo(_loc19_.x,_loc19_.y);
               _loc8_ = 1;
               while(_loc8_ < _loc11_.points.length)
               {
                  _loc18_ = _loc11_.points[_loc8_].clone();
                  _loc2_.lineTo(_loc18_.x,_loc18_.y);
                  _loc8_++;
               }
               _loc2_.lineTo(_loc19_.x,_loc19_.y);
            }
         }
      }
      
      internal static function RenderFloorForeground() : void
      {
         var _loc8_:BitmapData = null;
         var _loc9_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc14_:PhysLine = null;
         var _loc1_:uint = 43520;
         var _loc2_:Array = new Array(8421504,8421504,8421504,8421504,8421504,8421504);
         var _loc3_:Graphics = fillScreenMC.graphics;
         _loc3_.clear();
         var _loc4_:Level = Levels.GetCurrent();
         var _loc5_:int = _loc4_.numRockets - 1;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         var _loc6_:DisplayObj = GraphicObjects.GetDisplayObjByName("fill");
         var _loc7_:int = _loc6_.GetNumFrames();
         _loc8_ = _loc6_.GetBitmapData(_loc5_);
         var _loc12_:Matrix = new Matrix();
         var _loc13_:Array = new Array(0,0,1,2,3,4);
         for each(_loc14_ in _loc4_.lines)
         {
            _loc8_ = _loc6_.GetBitmapData(_loc13_[_loc14_.type]);
            if(_loc14_.type == 4)
            {
               _loc3_.lineStyle(3,_loc2_[_loc14_.type],1);
               _loc3_.beginBitmapFill(_loc8_);
               _loc11_ = _loc14_.points[0].clone();
               _loc3_.moveTo(_loc11_.x,_loc11_.y);
               _loc9_ = 1;
               while(_loc9_ < _loc14_.points.length)
               {
                  _loc10_ = _loc14_.points[_loc9_].clone();
                  _loc3_.lineTo(_loc10_.x,_loc10_.y);
                  _loc9_++;
               }
               _loc3_.lineTo(_loc11_.x,_loc11_.y);
            }
         }
      }
      
      public static function InitMessage(param1:String, param2:Number = 320, param3:Number = 100) : *
      {
         var _loc4_:GameObj = null;
         _loc4_ = GameObjects.AddObj(0,0,-500);
         _loc4_.InitTextMessage(param1,param2,param3);
      }
      
      internal static function RenderPanel() : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc1_:Level = Levels.GetCurrent();
         if(_loc1_ == null)
         {
            Utils.trace("null level " + Levels.currentIndex);
            return;
         }
         var _loc7_:BitmapData = main.screenBD;
         _loc2_ = 10;
         _loc3_ = 10;
         if(usedebug == false)
         {
         }
      }
      
      internal static function InitBallPathForLevel() : *
      {
         prevBallPath_doIt = false;
      }
      
      internal static function RenderPreviousBallPath(param1:BitmapData) : *
      {
         var _loc15_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:* = undefined;
         if(prevBallPath_doIt == false)
         {
            return;
         }
         var _loc2_:* = prevBallPath_x - camera.x;
         var _loc3_:* = prevBallPath_y - camera.y;
         var _loc4_:* = prevBallPath_dx;
         var _loc5_:* = prevBallPath_dy;
         var _loc6_:Graphics = fillScreenMC.graphics;
         _loc6_.clear();
         _loc6_.lineStyle(1,16777215,0.1);
         renderBallPathTimer = renderBallPathTimer - 1;
         var _loc7_:Number = _loc2_;
         var _loc8_:Number = _loc3_;
         var _loc9_:Number = ballpath_grav;
         var _loc10_:Number = _loc4_ * ballpath_mult;
         var _loc11_:Number = _loc5_ * ballpath_mult;
         var _loc12_:Number = _loc7_;
         var _loc13_:Number = _loc8_;
         var _loc14_:Number = 3 * 3;
         _loc6_.moveTo(_loc7_,_loc8_);
         var _loc16_:int = 0;
         _loc15_ = 0;
         while(_loc15_ < 1700)
         {
            if(--_loc16_ <= 0)
            {
               if(Utils.Dist2BetweenPoints(_loc7_,_loc8_,_loc12_,_loc13_) > _loc14_)
               {
                  _loc17_ = 0.2;
                  _loc18_ = Utils.ScaleToPreLimit(0,0.2,0,GameVars.ballLineLength,_loc15_);
                  _loc17_ -= _loc18_;
                  if(_loc17_ <= 0)
                  {
                     _loc17_ = 0;
                  }
                  _loc6_.lineStyle(1,16777215,_loc17_);
                  _loc6_.lineTo(_loc7_,_loc8_);
                  _loc12_ = _loc7_;
                  _loc13_ = _loc8_;
               }
               _loc16_ = 10;
            }
            _loc7_ += _loc10_;
            _loc8_ += _loc11_;
            _loc11_ += _loc9_;
            if(_loc7_ < -10)
            {
               _loc15_ = 99999;
            }
            if(_loc7_ > Defs.displayarea_w + 10)
            {
               _loc15_ = 99999;
            }
            if(_loc8_ > Defs.displayarea_h)
            {
               _loc15_ = 99999;
            }
            _loc15_++;
         }
         param1.draw(fillScreenMC,null,null,null,null,false);
      }
      
      internal static function ClearRenderBallPathParams() : *
      {
         bp_paramsSet = false;
      }
      
      internal static function SetRenderBallPathParams(param1:BitmapData, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = false) : *
      {
         bp_paramsSet = true;
         bp_bd = param1;
         bp_x = param2;
         bp_y = param3;
         bp_dx = param4;
         bp_dy = param5;
         bp_straight = param6;
      }
      
      internal static function RenderBallPathFromParams() : *
      {
         if(bp_paramsSet == false)
         {
            return;
         }
         RenderBallPath(bp_bd,bp_x,bp_y,bp_dx,bp_dy,bp_straight);
      }
      
      internal static function RenderBallPath(param1:BitmapData, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = false) : *
      {
         var _loc18_:int = 0;
         var _loc20_:Number = NaN;
         var _loc21_:* = undefined;
         var _loc7_:Graphics = fillScreenMC.graphics;
         _loc7_.clear();
         _loc7_.lineStyle(1,16777215,0.5);
         renderBallPathTimer = renderBallPathTimer - 1;
         var _loc8_:Number = renderBallPathTimer;
         if(usedebug)
         {
            if(KeyReader.Down(KeyReader.KEY_NUM_1))
            {
               ballpath_grav -= 0.0001;
            }
            if(KeyReader.Down(KeyReader.KEY_NUM_2))
            {
               ballpath_grav += 0.0001;
            }
            if(KeyReader.Down(KeyReader.KEY_NUM_4))
            {
               ballpath_mult -= 0.001;
            }
            if(KeyReader.Down(KeyReader.KEY_NUM_5))
            {
               ballpath_mult += 0.001;
            }
         }
         var _loc9_:Number = param2;
         var _loc10_:Number = param3;
         var _loc11_:Number = ballpath_grav;
         var _loc12_:Number = param4 * ballpath_mult;
         var _loc13_:Number = param5 * ballpath_mult;
         var _loc14_:Number = _loc9_;
         var _loc15_:Number = _loc10_;
         var _loc16_:Number = 3 * 3;
         _loc7_.moveTo(_loc9_,_loc10_);
         var _loc17_:int = 1000;
         var _loc19_:int = 0;
         _loc18_ = 0;
         while(_loc18_ < _loc17_)
         {
            if(--_loc19_ <= 0)
            {
               if(Utils.Dist2BetweenPoints(_loc9_,_loc10_,_loc14_,_loc15_) > _loc16_)
               {
                  _loc20_ = 0.5;
                  _loc21_ = Utils.ScaleToPreLimit(0,0.5,0,GameVars.ballLineLength,_loc18_);
                  _loc20_ -= _loc21_;
                  if(_loc20_ <= 0)
                  {
                     _loc20_ = 0;
                  }
                  _loc8_ += 1;
                  _loc7_.lineStyle(1,16711680,_loc20_);
                  _loc7_.lineTo(_loc9_,_loc10_);
                  _loc14_ = _loc9_;
                  _loc15_ = _loc10_;
               }
               _loc19_ = 5;
            }
            _loc9_ += _loc12_;
            _loc10_ += _loc13_;
            if(param6 == false)
            {
               _loc13_ += _loc11_;
            }
            if(_loc9_ < -10)
            {
               _loc18_ = 99999;
            }
            if(_loc9_ > Defs.displayarea_w + 10)
            {
               _loc18_ = 99999;
            }
            if(_loc10_ > Defs.displayarea_h)
            {
               _loc18_ = 99999;
            }
            _loc18_++;
         }
         param1.draw(fillScreenMC,null,null,null,null,false);
      }
      
      internal static function InitControl() : *
      {
      }
      
      internal static function InitShot() : *
      {
      }
      
      public static function GetLineIndexByName(param1:String) : int
      {
         var _loc4_:PhysLine = null;
         var _loc2_:Level = Levels.GetCurrent();
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_.lines)
         {
            if(_loc4_.id == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      internal static function InitDrag() : *
      {
         dragState = 0;
      }
      
      public static function HitTestPhysObjGraphics(param1:Number, param2:Number) : GameObj
      {
         var _loc3_:GameObj = null;
         var _loc4_:BitmapData = null;
         var _loc5_:uint = 0;
         for each(_loc3_ in GameObjects.objs)
         {
            if(_loc3_.active && _loc3_.colFlag_isRemovable)
            {
               _loc4_ = Game.main.screenBD;
               _loc4_.fillRect(Defs.screenRect,0);
               _loc3_.Render(_loc4_);
               _loc5_ = _loc4_.getPixel32(param1,param2);
               if(_loc5_ != 0)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public static function DoGameObjSwitch(param1:GameObj_Base) : *
      {
         var _loc2_:GameObj = null;
         for each(_loc2_ in GameObjects.objs)
         {
            if(_loc2_.active && _loc2_.switchFunction != null)
            {
               if(_loc2_.switchName == param1.id)
               {
                  _loc2_.switchFunction();
               }
            }
         }
      }
      
      public static function DoSwitchPOI(param1:LevelObj_Instance) : *
      {
      }
      
      public static function DoSwitch(param1:GameObj_Base) : *
      {
         var _loc2_:GameObj = null;
         SoundPlayer.Play("sfx_switch");
         for each(_loc2_ in GameObjects.objs)
         {
            if(_loc2_.active)
            {
               if(_loc2_.switchFunction != null)
               {
                  if(_loc2_.switchName == param1.id)
                  {
                     _loc2_.switchFunction();
                  }
               }
            }
         }
      }
      
      public static function AddToMarkerList(param1:GameObj) : *
      {
         GameVars.markerList.push(param1);
         GameVars.markerList.sortOn("xpos",Array.NUMERIC);
      }
      
      public static function SetActivePlayer(param1:GameObj) : *
      {
         var _loc3_:GameObj = null;
         var _loc2_:Array = GameObjects.GetGameObjListByName("player");
         for each(_loc3_ in _loc2_)
         {
            _loc3_.isActivePlayer = false;
         }
         param1.isActivePlayer = true;
      }
      
      public static function GetActivePlayer() : GameObj
      {
         var _loc2_:GameObj = null;
         var _loc1_:Array = GameObjects.GetGameObjListByName("player");
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.isActivePlayer)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function BlowUpLimpetMines() : *
      {
         var _loc2_:GameObj = null;
         var _loc1_:Array = GameObjects.GetGameObjListByName("limpet");
         for each(_loc2_ in _loc1_)
         {
            _loc2_.Limpet_Explode();
         }
      }
      
      public static function DoExplosionFromThisObject(param1:GameObj, param2:Number, param3:Number, param4:Number, param5:Number = 100) : *
      {
         var _loc6_:GameObj = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Vec = null;
         for each(_loc6_ in GameObjects.objs)
         {
            if(_loc6_.active && _loc6_.listIndex != param1.listIndex)
            {
               _loc7_ = param5;
               _loc8_ = Utils.DistBetweenPoints(param1.xpos,param1.ypos,_loc6_.xpos,_loc6_.ypos);
               if(_loc8_ < _loc7_)
               {
                  if(_loc6_.onHitExplosionFunction != null)
                  {
                     _loc6_.onHitExplosionFunction(param1,param3);
                  }
                  _loc9_ = new Vec();
                  _loc9_.SetFromDxDy(_loc6_.xpos - param1.xpos,_loc6_.ypos - param1.ypos);
                  _loc9_.speed = param4;
                  _loc6_.ApplyImpulse(_loc9_.X(),_loc9_.Y());
               }
            }
         }
      }
      
      public static function DoCustardExplosionFromThisObject(param1:GameObj, param2:Number, param3:Number, param4:Number, param5:Number = 100) : *
      {
         var _loc6_:GameObj = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Vec = null;
         for each(_loc6_ in GameObjects.objs)
         {
            if(_loc6_.active && _loc6_.listIndex != param1.listIndex)
            {
               if(_loc6_.name != "missile" && _loc6_.name != "limpet")
               {
                  _loc7_ = param5;
                  _loc8_ = Utils.DistBetweenPoints(param1.xpos,param1.ypos,_loc6_.xpos,_loc6_.ypos);
                  if(_loc8_ < _loc7_)
                  {
                     if(_loc6_.onHitExplosionFunction != null)
                     {
                        _loc6_.onHitExplosionFunction(param1,param3);
                     }
                     _loc9_ = new Vec();
                     _loc9_.SetFromDxDy(_loc6_.xpos - param1.xpos,_loc6_.ypos - param1.ypos);
                     _loc9_.speed = param4;
                     _loc6_.ApplyImpulse(_loc9_.X(),_loc9_.Y());
                  }
               }
            }
         }
      }
      
      public static function DecreaseShotBonus() : *
      {
         if(GameVars.numShotsFired <= 1)
         {
            return;
         }
         GameVars.currentShotBonus -= GameVars.shotBonusSubAmt;
         if(GameVars.currentShotBonus <= 0)
         {
            GameVars.currentShotBonus = 0;
         }
      }
   }
}

