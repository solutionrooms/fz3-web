package
{
   public class Achievements
   {
      
      public var list:Array;
      
      public var unlockedList:Array;
      
      public function Achievements()
      {
         super();
         this.list = new Array();
         this.unlockedList = new Array();
         this.LoadXml();
      }
      
      internal function LoadXml() : *
      {
         var _loc4_:XML = null;
         var _loc5_:Achievement = null;
         var _loc1_:XML = ExternalData.xml;
         var _loc2_:* = _loc1_.achievement.length();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_.achievement[_loc3_];
            _loc5_ = new Achievement();
            _loc5_.specificLevelName = XmlHelper.GetAttrString(_loc4_.@specificlevel,"1-01");
            _loc5_.name = XmlHelper.GetAttrString(_loc4_.@name,"undefined");
            _loc5_.description = XmlHelper.GetAttrString(_loc4_.@desc,"undefined");
            _loc5_.testFunction = XmlHelper.GetAttrString(_loc4_.test.@func,"");
            _loc5_.testFunctionParams = XmlHelper.GetAttrString(_loc4_.test.@params,"");
            _loc5_.completeFunction = XmlHelper.GetAttrString(_loc4_.pass.@func,"");
            _loc5_.completeFunctionParams = XmlHelper.GetAttrString(_loc4_.pass.@params,"");
            _loc5_.specificLevel = 0;
            this.list.push(_loc5_);
            _loc3_++;
         }
      }
      
      public function GetFullString(param1:String, param2:Boolean = true, param3:Boolean = true) : String
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc8_:String = null;
         var _loc9_:Level = null;
         var _loc10_:* = undefined;
         return param1;
      }
      
      public function CountAchievementsComplete() : int
      {
         var _loc2_:Achievement = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.complete)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function GetAchievementIndex(param1:Achievement) : int
      {
         var _loc3_:Achievement = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this.list)
         {
            if(_loc3_ == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function AllComplete() : Boolean
      {
         var _loc1_:Achievement = null;
         for each(_loc1_ in this.list)
         {
            if(_loc1_.complete == false)
            {
               return false;
            }
         }
         return true;
      }
      
      public function TestNone() : *
      {
         this.unlockedList = new Array();
      }
      
      public function TestAll() : *
      {
         var _loc1_:Achievement = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         this.unlockedList = new Array();
         for each(_loc1_ in this.list)
         {
            _loc2_ = true;
            if(_loc1_.specificLevel != -1)
            {
               if(_loc1_.specificLevel != Levels.currentIndex)
               {
                  _loc2_ = false;
               }
            }
            if(_loc2_)
            {
               Utils.GetParams(_loc1_.testFunctionParams);
               _loc3_ = Boolean(this[_loc1_.testFunction]());
               if(_loc3_)
               {
                  Utils.GetParams(_loc1_.completeFunctionParams);
                  this[_loc1_.completeFunction]();
                  _loc1_.complete = true;
                  this.unlockedList.push(_loc1_);
               }
            }
         }
      }
      
      public function GetLevelAchievements(param1:int) : Array
      {
         var _loc3_:Achievement = null;
         param1++;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.list)
         {
            if(_loc3_.specificLevel == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

