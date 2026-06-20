package Playtomic
{
   public final class Parse
   {
      
      private static var SECTION:String;
      
      private static var SAVE:String;
      
      private static var DELETE:String;
      
      private static var LOAD:String;
      
      private static var FIND:String;
      
      public function Parse()
      {
         super();
      }
      
      internal static function Initialise(param1:String) : void
      {
         SECTION = Encode.MD5("parse-" + param1);
         SAVE = Encode.MD5("parse-save-" + param1);
         DELETE = Encode.MD5("parse-delete-" + param1);
         LOAD = Encode.MD5("parse-load-" + param1);
         FIND = Encode.MD5("parse-find-" + param1);
      }
      
      public static function Save(param1:PFObject, param2:Function = null) : void
      {
         Request.Load(SECTION,SAVE,SaveComplete,param2,ObjectPostData(param1));
      }
      
      private static function SaveComplete(param1:Function, param2:Object, param3:XML = null, param4:Response = null) : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:PFObject = null;
         var _loc12_:XMLList = null;
         if(param1 == null)
         {
            return;
         }
         var _loc5_:XMLList = param3["object"];
         var _loc6_:XML = _loc5_[0];
         var _loc7_:PFObject = new PFObject();
         _loc7_.ObjectId = _loc6_["id"];
         _loc7_.ClassName = param2["classname"];
         _loc7_.Password = param2["password"];
         for(_loc8_ in param2)
         {
            if(_loc8_.indexOf("data") == 0)
            {
               _loc7_.Data[_loc8_.substring(4)] = param2[_loc8_];
            }
            if(_loc8_.indexOf("pointer") == 0 && _loc8_.indexOf("fieldname") > -1)
            {
               _loc9_ = _loc8_.substring(7);
               _loc9_ = _loc9_.substring(0,_loc9_.indexOf("fieldname"));
               _loc10_ = param2["pointer" + _loc9_ + "fieldname"];
               _loc11_ = new PFObject();
               _loc11_.ClassName = param2["pointer" + _loc9_ + "classname"];
               _loc11_.ObjectId = param2["pointer" + _loc9_ + "id"];
               _loc7_.Pointers.push(new PFPointer(_loc10_,_loc11_));
            }
         }
         if(param4.Success)
         {
            _loc12_ = param3["object"];
            _loc7_.CreatedAt = DateParse(_loc12_["created"]);
            _loc7_.UpdatedAt = DateParse(_loc12_["updated"]);
         }
         param1(_loc7_,param4);
      }
      
      public static function Delete(param1:PFObject, param2:Function = null) : void
      {
         Request.Load(SECTION,DELETE,DeleteComplete,param2,ObjectPostData(param1));
      }
      
      private static function DeleteComplete(param1:Function, param2:Object, param3:XML = null, param4:Response = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1(param4);
         param3 = param3;
         param2 = param2;
      }
      
      public static function Load(param1:String, param2:String, param3:Function = null) : void
      {
         var _loc4_:PFObject = new PFObject();
         _loc4_.ObjectId = param1;
         _loc4_.ClassName = param2;
         Request.Load(SECTION,LOAD,LoadComplete,param3,ObjectPostData(_loc4_));
      }
      
      private static function LoadComplete(param1:Function, param2:Object, param3:XML = null, param4:Response = null) : void
      {
         var _loc6_:XMLList = null;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:XMLList = null;
         var _loc10_:XML = null;
         var _loc11_:String = null;
         var _loc12_:PFObject = null;
         if(param1 == null)
         {
            return;
         }
         var _loc5_:PFObject = new PFObject();
         _loc5_.ObjectId = param2["objectid"];
         _loc5_.ClassName = param2["classname"];
         if(param4.Success)
         {
            _loc6_ = param3["object"];
            _loc5_.CreatedAt = DateParse(_loc6_["created"]);
            _loc5_.UpdatedAt = DateParse(_loc6_["updated"]);
            if(_loc6_.contains("fields"))
            {
               _loc7_ = _loc6_["fields"];
               for each(_loc8_ in _loc7_.children())
               {
                  _loc5_[_loc8_.name] = _loc8_.text();
               }
            }
            if(_loc6_.contains("pointers"))
            {
               _loc9_ = _loc6_["pointers"];
               for each(_loc10_ in _loc9_.children())
               {
                  _loc11_ = _loc10_["fieldname"];
                  _loc12_ = new PFObject();
                  _loc12_.ClassName = _loc10_["classname"];
                  _loc12_.ObjectId = _loc10_["id"];
                  _loc5_.Pointers.push(new PFPointer(_loc11_,_loc12_));
               }
            }
         }
         param1(_loc5_,param4);
      }
      
      public static function Find(param1:PFQuery, param2:Function = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = 0;
         var _loc3_:Object = new Object();
         _loc3_["classname"] = param1.ClassName;
         _loc3_["limit"] = param1.Limit;
         _loc3_["order"] = param1.Order != null && param1.Order != "" ? param1.Order : "created_at";
         for(_loc4_ in param1.WhereData)
         {
            _loc3_["data" + _loc4_] = param1.WhereData[_loc4_];
         }
         _loc5_ = int(param1.WherePointers.length - 1);
         while(_loc5_ > -1)
         {
            _loc3_["pointer" + _loc5_ + "fieldname"] = param1.WherePointers[_loc5_].FieldName;
            _loc3_["pointer" + _loc5_ + "classname"] = param1.WherePointers[_loc5_].PObject.ClassName;
            _loc3_["pointer" + _loc5_ + "id"] = param1.WherePointers[_loc5_].PObject.ObjectId;
            _loc5_--;
         }
         Request.Load(SECTION,FIND,FindComplete,param2,_loc3_);
      }
      
      private static function FindComplete(param1:Function, param2:Object, param3:XML = null, param4:Response = null) : void
      {
         var _loc6_:XMLList = null;
         var _loc7_:XML = null;
         var _loc8_:PFObject = null;
         var _loc9_:XMLList = null;
         var _loc10_:XML = null;
         var _loc11_:XMLList = null;
         var _loc12_:XML = null;
         var _loc13_:String = null;
         var _loc14_:PFObject = null;
         if(param1 == null)
         {
            return;
         }
         var _loc5_:Array = new Array();
         if(param4.Success)
         {
            _loc6_ = param3["objects"];
            for each(_loc7_ in _loc6_.children())
            {
               _loc8_ = new PFObject();
               _loc8_.ObjectId = _loc7_["id"];
               _loc8_.CreatedAt = DateParse(_loc7_["created"]);
               _loc8_.UpdatedAt = DateParse(_loc7_["updated"]);
               if(_loc7_.contains("fields"))
               {
                  _loc9_ = _loc7_["fields"];
                  for each(_loc10_ in _loc9_.children())
                  {
                     _loc8_[_loc10_.name] = _loc10_.text();
                  }
               }
               if(_loc7_.contains("pointers"))
               {
                  _loc11_ = _loc7_["pointers"];
                  for each(_loc12_ in _loc11_.children())
                  {
                     _loc13_ = _loc12_["fieldname"];
                     _loc14_ = new PFObject();
                     _loc14_.ClassName = _loc12_["classname"];
                     _loc14_.ObjectId = _loc12_["id"];
                     _loc8_.Pointers.push(new PFPointer(_loc13_,_loc14_));
                  }
               }
               _loc5_.push(_loc8_);
            }
         }
         param1(_loc5_,param4);
         param2 = param2;
      }
      
      private static function ObjectPostData(param1:PFObject) : Object
      {
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc2_:Object = new Object();
         _loc2_["classname"] = param1.ClassName;
         _loc2_["id"] = param1.ObjectId == null ? "" : param1.ObjectId;
         _loc2_["password"] = param1.Password == null ? "" : param1.Password;
         for(_loc3_ in param1.Data)
         {
            _loc2_["data" + _loc3_] = param1.Data[_loc3_];
         }
         _loc4_ = int(param1.Pointers.length - 1);
         while(_loc4_ > -1)
         {
            _loc2_["pointer" + _loc4_ + "fieldname"] = param1.Pointers[_loc4_].FieldName;
            _loc2_["pointer" + _loc4_ + "classname"] = param1.Pointers[_loc4_].PObject.ClassName;
            _loc2_["pointer" + _loc4_ + "id"] = param1.Pointers[_loc4_].PObject.ObjectId;
            _loc4_--;
         }
         return _loc2_;
      }
      
      private static function DateParse(param1:String) : Date
      {
         var _loc2_:Array = param1.split(" ");
         var _loc3_:Array = (_loc2_[0] as String).split("/");
         var _loc4_:Array = (_loc2_[1] as String).split(":");
         var _loc5_:int = int(_loc3_[1]);
         var _loc6_:int = int(_loc3_[0]);
         var _loc7_:int = int(_loc3_[2]);
         var _loc8_:int = int(_loc4_[0]);
         var _loc9_:int = int(_loc4_[1]);
         var _loc10_:int = int(_loc4_[2]);
         return new Date(Date.UTC(_loc7_,_loc6_,_loc5_,_loc8_,_loc9_,_loc10_));
      }
   }
}

