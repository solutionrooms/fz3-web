package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.events.*;
   import flash.geom.Point;
   
   public class GameObjects
   {
      
      public static var objs:Vector.<GameObj>;
      
      public static var activeIndices:Vector.<int>;
      
      public static var inactiveIndices:Vector.<int>;
      
      public static var zorder:Array;
      
      public static var numActive:int;
      
      public static var numInactive:int;
      
      public static var numobjs:int;
      
      public static var lastGenIndex:int;
      
      internal static var addList:Array;
      
      internal var v:Vector.<GameObj> = new Vector.<GameObj>(1000);
      
      public function GameObjects()
      {
         super();
      }
      
      public static function InitOnce(param1:int) : *
      {
         var _loc2_:* = undefined;
         numobjs = param1;
         objs = new Vector.<GameObj>(numobjs);
         activeIndices = new Vector.<int>(numobjs);
         inactiveIndices = new Vector.<int>(numobjs);
         zorder = new Array(numobjs);
         _loc2_ = 0;
         while(_loc2_ < numobjs)
         {
            objs[_loc2_] = new GameObj();
            objs[_loc2_].listIndex = _loc2_;
            activeIndices[_loc2_] = -1;
            inactiveIndices[_loc2_] = _loc2_;
            objs[_loc2_].activeListIndex = -1;
            objs[_loc2_].inactiveListIndex = _loc2_;
            _loc2_++;
         }
         numActive = 0;
         numInactive = numobjs;
      }
      
      public static function ClearAll() : *
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < numobjs)
         {
            objs[_loc1_].active = false;
            objs[_loc1_].listIndex = _loc1_;
            activeIndices[_loc1_] = -1;
            inactiveIndices[_loc1_] = _loc1_;
            _loc1_++;
         }
         numActive = 0;
         numInactive = numobjs;
      }
      
      public static function GetGOByIndex(param1:int) : GameObj
      {
         return objs[param1];
      }
      
      public static function AddObj(param1:Number, param2:Number, param3:Number) : GameObj
      {
         var _loc4_:int = 0;
         var _loc5_:GameObj = null;
         _loc4_ = 0;
         while(_loc4_ < numobjs)
         {
            if(objs[_loc4_].active == false)
            {
               _loc5_ = objs[_loc4_];
               _loc5_.active = true;
               _loc5_.zpos = param3;
               _loc5_.xpos = param1;
               _loc5_.ypos = param2;
               _loc5_.startx = param1;
               _loc5_.starty = param2;
               _loc5_.startz = param3;
               _loc5_.Init(0);
               lastGenIndex = _loc4_;
               return objs[_loc4_];
            }
            _loc4_++;
         }
         lastGenIndex = -1;
         return null;
      }
      
      public static function ForEachActive(param1:Function) : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:Array = new Array();
         for each(_loc2_ in objs)
         {
            if(_loc2_.active)
            {
               param1(_loc2_);
            }
         }
      }
      
      public static function zcompare(param1:Point, param2:Point) : Number
      {
         if(param1.y > param2.y)
         {
            return -1;
         }
         if(param1.y < param2.y)
         {
            return 1;
         }
         return 0;
      }
      
      public static function RenderZposBelow(param1:BitmapData, param2:*) : *
      {
         var _loc3_:GameObj = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         Debug.StartTimer("sort");
         _loc4_ = 0;
         zorder = new Array();
         for each(_loc3_ in objs)
         {
            if(_loc3_.active && _loc3_.visible)
            {
               zorder.push(_loc3_);
               _loc4_++;
            }
         }
         zorder.sortOn("zpos",Array.NUMERIC | Array.DESCENDING);
         Debug.EndTimer("sort");
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = zorder[_loc5_];
            if(_loc3_.zpos < param2)
            {
               _loc3_.Render(param1);
            }
            _loc5_++;
         }
      }
      
      public static function RenderZposAboveEqual(param1:BitmapData, param2:*) : *
      {
         var _loc3_:GameObj = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         Debug.StartTimer("sort");
         _loc4_ = 0;
         zorder = new Array();
         for each(_loc3_ in objs)
         {
            if(_loc3_.active && _loc3_.visible)
            {
               zorder.push(_loc3_);
               _loc4_++;
            }
         }
         zorder.sortOn("zpos",Array.NUMERIC | Array.DESCENDING);
         Debug.EndTimer("sort");
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = zorder[_loc5_];
            if(_loc3_.zpos >= param2)
            {
               _loc3_.Render(param1);
            }
            _loc5_++;
         }
      }
      
      public static function Render(param1:BitmapData) : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         Debug.StartTimer("sort");
         _loc3_ = 0;
         zorder = new Array();
         for each(_loc2_ in objs)
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
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = zorder[_loc4_];
            _loc2_.Render(param1);
            _loc4_++;
         }
      }
      
      public static function CountByName(param1:String) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < objs.length)
         {
            if(objs[_loc3_].active == true && objs[_loc3_].name == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function CountActive() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < objs.length)
         {
            if(objs[_loc2_].active == true)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function Update() : void
      {
         var _loc1_:GameObj = null;
         Debug.StartTimer("update GOs");
         for each(_loc1_ in objs)
         {
            if(_loc1_.active == true)
            {
               _loc1_.Update();
            }
         }
         Debug.EndTimer("update GOs");
      }
      
      public static function KillObjects() : void
      {
         var _loc2_:GameObj = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in objs)
         {
            if(_loc2_.active == true && _loc2_.killed)
            {
               _loc2_.active = false;
               _loc1_.push(_loc2_);
            }
         }
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.removeFunction != null)
            {
               _loc2_.removeFunction();
            }
         }
      }
      
      public static function DoAddList() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in addList)
         {
            _loc1_.fn(_loc1_.o);
         }
      }
      
      public static function ClearAddList() : void
      {
         addList = new Array();
      }
      
      public static function AddToAddList(param1:Function, param2:Object) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.fn = param1;
         _loc3_.o = param2;
         addList.push(_loc3_);
      }
      
      internal static function GetGameObjListByNameList(param1:String) : Array
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:GameObj = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = param1.split(",");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = GetGameObjListByName(_loc4_);
            for each(_loc6_ in _loc5_)
            {
               _loc2_.push(_loc6_);
            }
            _loc5_ = null;
         }
         return _loc2_;
      }
      
      internal static function GetGameObjListByName(param1:String) : Array
      {
         var _loc3_:GameObj = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in GameObjects.objs)
         {
            if(_loc3_.active == true && _loc3_.name == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      internal static function GetGameObjByName(param1:String) : GameObj
      {
         var _loc2_:GameObj = null;
         for each(_loc2_ in GameObjects.objs)
         {
            if(_loc2_.active == true && _loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      internal static function GetGameObjById(param1:String) : GameObj
      {
         var _loc2_:GameObj = null;
         for each(_loc2_ in GameObjects.objs)
         {
            if(_loc2_.active == true && _loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      internal static function GetGameObjByLineName(param1:String) : GameObj
      {
         var _loc2_:GameObj = null;
         for each(_loc2_ in GameObjects.objs)
         {
            if(_loc2_.linkedPhysLine != null)
            {
               if(_loc2_.linkedPhysLine.id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      internal static function GetGameObjListByFlag(param1:String) : Array
      {
         var _loc3_:GameObj = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in GameObjects.objs)
         {
            if(_loc3_.active == true && _loc3_[param1] == true)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      internal static function GetNearestGameObjByName(param1:String, param2:Number, param3:Number) : GameObj
      {
         var _loc4_:GameObj = null;
         var _loc6_:GameObj = null;
         var _loc7_:Number = NaN;
         var _loc5_:int = 999999;
         for each(_loc6_ in GameObjects.objs)
         {
            if(_loc6_.active && _loc6_.name == param1)
            {
               _loc7_ = Utils.DistBetweenPoints(param2,param3,_loc6_.xpos,_loc6_.ypos);
               if(_loc7_ < _loc5_)
               {
                  _loc5_ = _loc7_;
                  _loc4_ = _loc6_;
               }
            }
         }
         return _loc4_;
      }
      
      internal static function UpdateSingleGOsFromPhysics(param1:GameObj) : void
      {
         var _loc2_:b2Vec2 = param1.GetBodyWorldPosWorldCoords(0);
         param1.xpos = _loc2_.x;
         param1.ypos = _loc2_.y;
      }
      
      internal static function UpdateGOsFromPhysics() : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:b2Body = null;
         var _loc4_:PhysObj_BodyUserData = null;
         var _loc5_:int = 0;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc1_:Number = PhysicsBase.p2w;
         _loc3_ = PhysicsBase.world.GetBodyList();
         while(_loc3_)
         {
            _loc4_ = _loc3_.GetUserData() as PhysObj_BodyUserData;
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.gameObjectIndex;
               if(_loc5_ != -1)
               {
                  _loc2_ = GameObjects.objs[_loc5_];
                  if(_loc2_.updateFromPhysicsFunction != null)
                  {
                     _loc2_.updateFromPhysicsFunction(_loc3_);
                  }
                  else
                  {
                     _loc6_ = _loc3_.GetPosition();
                     _loc7_ = _loc3_.GetAngle();
                     _loc2_.oldxpos = _loc2_.xpos;
                     _loc2_.oldypos = _loc2_.ypos;
                     _loc2_.xpos = _loc6_.x * _loc1_;
                     _loc2_.ypos = _loc6_.y * _loc1_;
                     _loc2_.dir = _loc7_;
                  }
               }
            }
            _loc3_ = _loc3_.GetNext();
         }
      }
      
      public function GameObjGroup() : *
      {
      }
   }
}

