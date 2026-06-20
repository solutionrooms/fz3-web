package
{
   public class ObjectParameters
   {
      
      internal var objparamList:Array;
      
      public function ObjectParameters()
      {
         super();
      }
      
      public function GetObjParamString(param1:Array, param2:Array) : String
      {
         var _loc3_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:ObjParam = null;
         var _loc4_:int = int(param1.length);
         var _loc5_:String = "";
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = param1[_loc3_];
            _loc7_ = param2[_loc3_];
            Utils.trace("param " + _loc6_ + " " + _loc7_);
            _loc8_ = this.GetObjectParamByName(_loc6_);
            _loc5_ += _loc8_.name;
            _loc5_ = _loc5_ + "=";
            if(_loc7_ != "")
            {
               _loc5_ += _loc7_;
            }
            else
            {
               _loc5_ += _loc8_.defaultValue;
            }
            if(_loc3_ != _loc4_ - 1)
            {
               _loc5_ += ",";
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public function GetObjectParamByName(param1:String) : ObjParam
      {
         var _loc2_:ObjParam = null;
         for each(_loc2_ in this.objparamList)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function LoadObjectParams() : *
      {
         var _loc4_:XML = null;
         var _loc5_:ObjParam = null;
         this.objparamList = new Array();
         var _loc1_:XML = ExternalData.xml;
         var _loc2_:* = _loc1_.objparam.length();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_.objparam[_loc3_];
            _loc5_ = new ObjParam();
            _loc5_.name = XmlHelper.GetAttrString(_loc4_.@name,"");
            _loc5_.type = XmlHelper.GetAttrString(_loc4_.@type,"");
            _loc5_.defaultValue = XmlHelper.GetAttrString(_loc4_.@§default§,"");
            _loc5_.AddValuesString(XmlHelper.GetAttrString(_loc4_.@values,""));
            this.objparamList.push(_loc5_);
            _loc3_++;
         }
      }
   }
}

