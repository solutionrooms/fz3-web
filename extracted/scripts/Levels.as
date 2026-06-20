package
{
   import flash.geom.Point;
   
   public class Levels
   {
      
      public static var currentIndex:int;
      
      public static var list:Vector.<Level>;
      
      public function Levels()
      {
         super();
      }
      
      public static function GetCurrent() : Level
      {
         if(currentIndex < 0)
         {
            return null;
         }
         if(currentIndex >= list.length)
         {
            return null;
         }
         LoadLevel(currentIndex,false);
         return list[currentIndex];
      }
      
      public static function CountPerfectLevels() : int
      {
         var _loc2_:Level = null;
         var _loc1_:int = 0;
         for each(_loc2_ in list)
         {
            if(_loc2_.complete && _loc2_.rating != 0)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public static function LoadAll() : *
      {
         list = new Vector.<Level>();
         var _loc1_:XML = ExternalData.levelsXml;
         var _loc2_:* = _loc1_.level.length();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            PreLoadLevel(_loc3_);
            LoadLevel(_loc3_);
            _loc3_++;
         }
         Utils.trace("num levels " + _loc2_);
      }
      
      public static function PreLoadLevel(param1:int) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Level = null;
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         _loc2_ = ExternalData.levelsXml;
         _loc2_ = _loc2_.level[param1];
         _loc3_ = new Level();
         _loc3_.fullyLoaded = false;
         _loc3_.available = false;
         _loc3_.complete = false;
         _loc3_.id = XmlHelper.GetAttrString(_loc2_.@id,"1");
         _loc3_.name = XmlHelper.GetAttrString(_loc2_.@name,"undefined");
         _loc3_.category = XmlHelper.GetAttrInt(_loc2_.@category,0);
         _loc3_.bgFrame = XmlHelper.GetAttrInt(_loc2_.@bg,1);
         _loc3_.creator = XmlHelper.GetAttrString(_loc2_.@creator,"");
         LoadGameSpecificLevelData(_loc3_,_loc2_);
         _loc4_ = 0;
         while(_loc4_ < _loc2_.helpscreen.length())
         {
            _loc5_ = _loc2_.helpscreen[_loc4_];
            _loc3_.helpscreenFrames.push(XmlHelper.GetAttrInt(_loc5_.@frame,0));
            _loc4_++;
         }
         list.push(_loc3_);
      }
      
      public static function LoadGameSpecificLevelData(param1:Level, param2:XML) : *
      {
         param1.gold_score = XmlHelper.GetAttrInt(param2.zombooka.@gold_score,10000);
      }
      
      public static function GetGameSpecificLevelDataXML(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:Level = GetLevel(param1);
         _loc2_ = "\t<zombooka";
         _loc2_ += " gold_score=\"" + _loc3_.gold_score + "\"";
         return _loc2_ + " />";
      }
      
      public static function LoadLevel(param1:int, param2:Boolean = true) : *
      {
         var _loc4_:Level = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:XML = null;
         var _loc8_:PhysLine = null;
         var _loc9_:String = null;
         var _loc10_:XML = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:Point = null;
         var _loc14_:XML = null;
         var _loc15_:XML = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:LevelObj_Instance = null;
         var _loc23_:XML = null;
         var _loc24_:PhysObj_Joint = null;
         var _loc25_:String = null;
         var _loc26_:XML = null;
         var _loc27_:XML = null;
         var _loc28_:String = null;
         var _loc29_:int = 0;
         var _loc3_:XML = ExternalData.levelsXml;
         _loc3_ = _loc3_.level[param1];
         _loc4_ = list[param1];
         if(_loc4_.fullyLoaded)
         {
            return;
         }
         _loc4_.Calculate();
         _loc4_.fullyLoaded = true;
         _loc4_.lines = new Array();
         _loc5_ = 0;
         while(_loc5_ < _loc3_.line.length())
         {
            _loc7_ = _loc3_.line[_loc5_];
            _loc8_ = new PhysLine();
            _loc8_.id = XmlHelper.GetAttrString(_loc7_.@id,"");
            _loc8_.type = XmlHelper.GetAttrInt(_loc7_.@type,0);
            _loc6_ = 0;
            while(_loc6_ < _loc7_.points.length())
            {
               _loc10_ = _loc7_.points[_loc6_];
               _loc11_ = XmlHelper.GetAttrString(_loc10_.@a,"");
               _loc12_ = Utils.PointArrayFromString(_loc11_);
               for each(_loc13_ in _loc12_)
               {
                  _loc8_.points.push(_loc13_);
               }
               _loc6_++;
            }
            _loc9_ = XmlHelper.GetAttrString(_loc7_.@params,"");
            _loc8_.objParameters.ValuesFromString(_loc9_);
            _loc4_.lines.push(_loc8_);
            _loc5_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.objgroup.length())
         {
            _loc14_ = _loc3_.objgroup[_loc6_];
            _loc5_ = 0;
            while(_loc5_ < _loc14_.obj.length())
            {
               _loc15_ = _loc14_.obj[_loc5_];
               _loc16_ = XmlHelper.GetAttrString(_loc15_.@id,"");
               _loc17_ = _loc15_.@type;
               _loc18_ = Number(_loc15_.@x);
               _loc19_ = Number(_loc15_.@y);
               _loc20_ = Number(_loc15_.@rot);
               _loc21_ = XmlHelper.GetAttrNumber(_loc15_.@scale,1);
               _loc9_ = XmlHelper.GetAttrString(_loc15_.@params,"");
               _loc22_ = CreateLevelObjInstanceAt(_loc17_,_loc18_,_loc19_,_loc20_,_loc21_,"",_loc9_);
               _loc22_.id = _loc16_;
               _loc4_.instances.push(_loc22_);
               _loc5_++;
            }
            _loc6_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc3_.obj.length())
         {
            _loc15_ = _loc3_.obj[_loc5_];
            _loc16_ = XmlHelper.GetAttrString(_loc15_.@id,"");
            _loc17_ = _loc15_.@type;
            _loc18_ = Number(_loc15_.@x);
            _loc19_ = Number(_loc15_.@y);
            _loc20_ = Number(_loc15_.@rot);
            _loc21_ = XmlHelper.GetAttrNumber(_loc15_.@scale,1);
            _loc9_ = XmlHelper.GetAttrString(_loc15_.@params,"");
            _loc22_ = CreateLevelObjInstanceAt(_loc17_,_loc18_,_loc19_,_loc20_,_loc21_,"",_loc9_);
            _loc22_.id = _loc16_;
            _loc4_.instances.push(_loc22_);
            _loc5_++;
         }
         _loc4_.joints = new Array();
         _loc5_ = 0;
         while(_loc5_ < _loc3_.joints.joint.length())
         {
            _loc23_ = _loc3_.joints.joint[_loc5_];
            _loc24_ = new PhysObj_Joint();
            _loc24_.name = XmlHelper.GetAttrString(_loc23_.@id,"");
            _loc25_ = XmlHelper.GetAttrString(_loc23_.@type,"");
            if(_loc25_ == "rev")
            {
               _loc24_.SetType(PhysObj_Joint.Type_Rev);
               _loc24_.obj0Name = XmlHelper.GetAttrString(_loc23_.@objid0,"");
               _loc24_.obj1Name = XmlHelper.GetAttrString(_loc23_.@objid1,"");
               _loc24_.rev_pos.x = XmlHelper.GetAttrNumber(_loc23_.@x,0);
               _loc24_.rev_pos.y = XmlHelper.GetAttrNumber(_loc23_.@y,0);
            }
            if(_loc25_ == "dist")
            {
               _loc24_.SetType(PhysObj_Joint.Type_Distance);
               _loc24_.obj0Name = XmlHelper.GetAttrString(_loc23_.@objid0,"");
               _loc24_.obj1Name = XmlHelper.GetAttrString(_loc23_.@objid1,"");
               _loc24_.dist_pos0.x = XmlHelper.GetAttrNumber(_loc23_.@x0,0);
               _loc24_.dist_pos0.y = XmlHelper.GetAttrNumber(_loc23_.@y0,0);
               _loc24_.dist_pos1.x = XmlHelper.GetAttrNumber(_loc23_.@x1,0);
               _loc24_.dist_pos1.y = XmlHelper.GetAttrNumber(_loc23_.@y1,0);
            }
            if(_loc25_ == "prism")
            {
               _loc24_.SetType(PhysObj_Joint.Type_Prismatic);
               _loc24_.obj0Name = XmlHelper.GetAttrString(_loc23_.@objid0,"");
               _loc24_.obj1Name = XmlHelper.GetAttrString(_loc23_.@objid1,"");
               _loc24_.prism_pos.x = XmlHelper.GetAttrNumber(_loc23_.@x0,0);
               _loc24_.prism_pos.y = XmlHelper.GetAttrNumber(_loc23_.@y0,0);
               _loc24_.prism_pos1.x = XmlHelper.GetAttrNumber(_loc23_.@x1,0);
               _loc24_.prism_pos1.y = XmlHelper.GetAttrNumber(_loc23_.@y1,0);
            }
            _loc9_ = XmlHelper.GetAttrString(_loc23_.@params,"");
            _loc24_.objParameters.ValuesFromString(_loc9_);
            _loc4_.joints.push(_loc24_);
            _loc5_++;
         }
         if(_loc3_.map.length() != 0)
         {
            _loc4_.map = new Array();
            _loc26_ = _loc3_.map[0];
            _loc4_.mapMinX = XmlHelper.GetAttrInt(_loc26_.@minx,0);
            _loc4_.mapMaxX = XmlHelper.GetAttrInt(_loc26_.@maxx,0);
            _loc4_.mapMinY = XmlHelper.GetAttrInt(_loc26_.@miny,0);
            _loc4_.mapMaxY = XmlHelper.GetAttrInt(_loc26_.@maxy,0);
            _loc4_.mapCellW = XmlHelper.GetAttrInt(_loc26_.@cellw,32);
            _loc4_.mapCellH = XmlHelper.GetAttrInt(_loc26_.@cellh,32);
            _loc6_ = 0;
            while(_loc6_ < _loc26_.mapdata.length())
            {
               _loc27_ = _loc26_.mapdata[_loc6_];
               _loc28_ = XmlHelper.GetAttrString(_loc27_.@a,"");
               _loc12_ = Utils.HexArrayFromString(_loc28_);
               for each(_loc29_ in _loc12_)
               {
                  _loc4_.map.push(_loc29_);
               }
               _loc6_++;
            }
         }
      }
      
      public static function GetCurrentLevelInstances() : Array
      {
         if(currentIndex < 0)
         {
            return null;
         }
         if(currentIndex >= list.length)
         {
            return null;
         }
         LoadLevel(currentIndex,false);
         return list[currentIndex].instances;
      }
      
      public static function GetCurrentLevelJoints() : Array
      {
         if(currentIndex < 0)
         {
            return null;
         }
         if(currentIndex >= list.length)
         {
            return null;
         }
         LoadLevel(currentIndex,false);
         return list[currentIndex].joints;
      }
      
      public static function GetLevel(param1:int) : Level
      {
         if(param1 < 0)
         {
            return null;
         }
         if(param1 >= list.length)
         {
            return null;
         }
         LoadLevel(param1,false);
         return list[param1];
      }
      
      public static function GetLevelById(param1:String) : Level
      {
         var _loc3_:Level = null;
         var _loc2_:int = 0;
         for each(_loc3_ in list)
         {
            if(_loc3_.id == param1)
            {
               LoadLevel(_loc2_,false);
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function GetLevelIndexById(param1:String) : int
      {
         var _loc3_:Level = null;
         var _loc2_:int = 0;
         for each(_loc3_ in list)
         {
            if(_loc3_.id == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public static function GetLevelIndexByName(param1:String) : int
      {
         var _loc3_:Level = null;
         var _loc2_:int = 0;
         for each(_loc3_ in list)
         {
            if(_loc3_.name == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public static function GetHighestAvailableLevelIndex() : int
      {
         var _loc3_:Level = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in list)
         {
            if(_loc3_.available)
            {
               _loc1_ = _loc2_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function GetLevelLight(param1:int) : Level
      {
         if(param1 < 0)
         {
            return null;
         }
         if(param1 >= list.length)
         {
            return null;
         }
         return list[param1];
      }
      
      public static function CreateLevelObjInstanceAt(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:String = "", param7:String = "") : LevelObj_Instance
      {
         var _loc8_:LevelObj_Instance = new LevelObj_Instance();
         _loc8_.typeName = param1;
         _loc8_.x = param2;
         _loc8_.y = param3;
         _loc8_.rot = param4;
         _loc8_.scale = param5;
         _loc8_.instanceName = param6;
         _loc8_.objParameters.CreateAllFromString(param7);
         return _loc8_;
      }
      
      public static function IncrementLevel() : *
      {
         ++currentIndex;
         if(currentIndex >= list.length)
         {
            currentIndex = 0;
         }
      }
      
      public static function DecrementLevel() : *
      {
         --currentIndex;
         if(currentIndex < 0)
         {
            currentIndex = list.length - 1;
         }
      }
      
      public static function ClearAll() : *
      {
         var _loc1_:Level = null;
         for each(_loc1_ in list)
         {
            _loc1_.bestScore = 0;
            _loc1_.available = false;
            _loc1_.complete = false;
            _loc1_.rating = 0;
            _loc1_.hasHitRef = false;
         }
      }
      
      public static function ToSharedObject() : Object
      {
         var _loc7_:Level = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         for each(_loc7_ in list)
         {
            _loc2_.push(_loc7_.bestScore);
            _loc3_.push(_loc7_.available);
            _loc4_.push(_loc7_.complete);
            _loc5_.push(_loc7_.hasHitRef);
            _loc6_.push(_loc7_.rating);
         }
         _loc1_.a = _loc2_;
         _loc1_.b = _loc3_;
         _loc1_.c = _loc4_;
         _loc1_.d = _loc5_;
         _loc1_.e = _loc6_;
         return _loc1_;
      }
      
      public static function FromSharedObject(param1:Object) : *
      {
         var _loc8_:Level = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = param1.a;
         var _loc3_:Array = param1.b;
         var _loc4_:Array = param1.c;
         var _loc5_:Array = param1.d;
         var _loc6_:Array = param1.e;
         var _loc7_:int = 0;
         for each(_loc8_ in list)
         {
            _loc8_.bestScore = _loc2_[_loc7_];
            _loc8_.available = _loc3_[_loc7_];
            _loc8_.complete = _loc4_[_loc7_];
            _loc8_.hasHitRef = _loc5_[_loc7_];
            _loc8_.rating = _loc6_[_loc7_];
            _loc7_++;
         }
      }
   }
}

