package EditorPackage
{
   public class ObjParameters
   {
      
      internal var list:Vector.<ObjParameter>;
      
      public function ObjParameters()
      {
         super();
         this.list = new Vector.<ObjParameter>();
      }
      
      public function Clone() : ObjParameters
      {
         var _loc2_:ObjParameter = null;
         var _loc1_:ObjParameters = new ObjParameters();
         _loc1_.list = new Vector.<ObjParameter>();
         for each(_loc2_ in this.list)
         {
            _loc1_.list.push(_loc2_.Clone());
         }
         return _loc1_;
      }
      
      public function GetByIndex(param1:int) : ObjParameter
      {
         return this.list[param1];
      }
      
      public function ClearAll() : *
      {
         this.list = new Vector.<ObjParameter>();
      }
      
      public function Add(param1:String, param2:String) : *
      {
         var _loc3_:ObjParameter = new ObjParameter();
         _loc3_.name = param1;
         _loc3_.value = param2;
         this.list.push(_loc3_);
      }
      
      public function ToString() : String
      {
         var _loc3_:ObjParameter = null;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.list.length)
         {
            _loc3_ = this.list[_loc2_];
            _loc1_ += _loc3_.name;
            _loc1_ += "=";
            _loc1_ += _loc3_.value;
            if(_loc2_ != this.list.length - 1)
            {
               _loc1_ += ",";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function ValuesFromString(param1:String) : *
      {
         var _loc3_:ObjParameter = null;
         Utils.GetParams(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this.list.length)
         {
            _loc3_ = this.list[_loc2_];
            if(Utils.GetParamExists(_loc3_.name))
            {
               _loc3_.value = Utils.GetParamString(_loc3_.name,_loc3_.value);
            }
            _loc2_++;
         }
      }
      
      public function CreateAllFromString(param1:String) : *
      {
         Utils.GetParams(param1);
         this.ClearAll();
         var _loc2_:int = 0;
         while(_loc2_ < Utils.paramNames.length)
         {
            this.Add(Utils.paramNames[_loc2_],Utils.paramValues[_loc2_]);
            _loc2_++;
         }
      }
      
      public function GetValueBoolean(param1:String) : Boolean
      {
         var _loc2_:String = this.GetParam(param1);
         if(_loc2_ == "true")
         {
            return true;
         }
         return false;
      }
      
      public function GetValueString(param1:String, param2:String = "") : String
      {
         return this.GetParam(param1);
      }
      
      public function GetValueNumber(param1:String) : Number
      {
         var _loc2_:String = this.GetParam(param1);
         return Number(_loc2_);
      }
      
      public function GetValueInt(param1:String, param2:int = 0) : int
      {
         var _loc3_:String = this.GetParam(param1);
         return int(_loc3_);
      }
      
      internal function GetParam(param1:String) : String
      {
         var _loc3_:ObjParameter = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.list.length)
         {
            _loc3_ = this.list[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc3_.value;
            }
            _loc2_++;
         }
         return "";
      }
   }
}

