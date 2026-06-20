package
{
   import flash.events.Event;
   import flash.net.*;
   import flash.system.System;
   
   public class ExternalData
   {
      
      public static var xml:XML;
      
      public static var levelsXml:XML;
      
      internal static var xmlLoader:URLLoader;
      
      internal static var cb:Function;
      
      public static var constants:Object;
      
      public static var gameconstants:Object;
      
      internal static var loadExternalLevels:Boolean = false;
      
      private static var class_Data:Class = ExternalData_class_Data;
      
      private static var class_Levels:Class = ExternalData_class_Levels;
      
      private static var class_Levels1:Class = ExternalData_class_Levels1;
      
      private static var class_Levels2:Class = ExternalData_class_Levels2;
      
      private static var class_Levels3:Class = ExternalData_class_Levels3;
      
      public function ExternalData()
      {
         super();
      }
      
      public static function OutputString(param1:String) : *
      {
         System.setClipboard(param1);
      }
      
      public static function Load(param1:Function) : *
      {
         cb = param1;
         if(loadExternalLevels)
         {
            XML.ignoreWhitespace = true;
            xml = new XML(new class_Data()) as XML;
            xmlLoader = new URLLoader();
            xmlLoader.addEventListener(Event.COMPLETE,levelXmlLoaded,false,0,true);
            xmlLoader.load(new URLRequest("FlamingZombooka3_Levels_Cathy_Data.xml"));
         }
         else
         {
            XmlAllLoadedInternal();
         }
      }
      
      internal static function XmlAllLoadedInternal() : *
      {
         var _loc1_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         XML.ignoreWhitespace = true;
         xml = new XML(new class_Data()) as XML;
         levelsXml = new XML(new class_Levels()) as XML;
         var _loc2_:XML = new XML(new class_Levels1()) as XML;
         var _loc3_:XML = new XML(new class_Levels2()) as XML;
         var _loc4_:XML = new XML(new class_Levels3()) as XML;
         _loc5_ = levelsXml.level.length();
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc6_ = levelsXml.level[_loc1_];
            _loc7_ = "creator";
            _loc6_[_loc7_] = "final";
            _loc1_++;
         }
         _loc5_ = _loc2_.level.length();
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc6_ = _loc2_.level[_loc1_];
            _loc7_ = "creator";
            _loc6_[_loc7_] = "julian";
            _loc1_++;
         }
         _loc5_ = _loc3_.level.length();
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc6_ = _loc3_.level[_loc1_];
            _loc7_ = "creator";
            _loc6_[_loc7_] = "cathy";
            _loc1_++;
         }
         _loc5_ = _loc4_.level.length();
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc6_ = _loc4_.level[_loc1_];
            _loc7_ = "creator";
            _loc6_[_loc7_] = "rob";
            _loc1_++;
         }
         if(Game.onlyFinalLevels == false)
         {
            _loc5_ = _loc4_.level.length();
            _loc1_ = 0;
            while(_loc1_ < _loc5_)
            {
               _loc6_ = _loc4_.level[_loc1_];
               levelsXml.appendChild(_loc6_);
               _loc1_++;
            }
            _loc5_ = _loc2_.level.length();
            _loc1_ = 0;
            while(_loc1_ < _loc5_)
            {
               _loc6_ = _loc2_.level[_loc1_];
               levelsXml.appendChild(_loc6_);
               _loc1_++;
            }
            _loc5_ = _loc3_.level.length();
            _loc1_ = 0;
            while(_loc1_ < _loc5_)
            {
               _loc6_ = _loc3_.level[_loc1_];
               levelsXml.appendChild(_loc6_);
               _loc1_++;
            }
         }
         if(Game.onlyFinalLevels)
         {
         }
         GetConstants();
         cb();
      }
      
      public static function GetConstants() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         constants = new Object();
         _loc1_ = xml.constants.constant.length();
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = xml.constants.constant[_loc2_];
            constants[_loc3_.@name] = _loc3_.@value;
            _loc2_++;
         }
         gameconstants = new Object();
         _loc1_ = xml.gameconstants.constant.length();
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = xml.gameconstants.constant[_loc2_];
            gameconstants[_loc3_.@name] = _loc3_.@value;
            _loc2_++;
         }
      }
      
      public static function dataXmlLoaded(param1:Event) : *
      {
         var _loc2_:int = 0;
         XML.ignoreWhitespace = true;
         levelsXml = new XML(param1.target.data);
         GetConstants();
         cb();
      }
      
      public static function levelXmlLoaded(param1:Event) : *
      {
         var _loc2_:int = 0;
         XML.ignoreWhitespace = true;
         levelsXml = new XML(param1.target.data) as XML;
         GetConstants();
         cb();
      }
   }
}

