package
{
   public class XmlHelper
   {
      
      public function XmlHelper()
      {
         super();
      }
      
      public static function GetAttrString(param1:Object, param2:String = "") : String
      {
         var _loc3_:String = param2;
         if(param1 != undefined)
         {
            _loc3_ = String(param1);
         }
         return _loc3_;
      }
      
      public static function GetAttrNumber(param1:Object, param2:Number = 0) : Number
      {
         var _loc4_:String = null;
         var _loc3_:Number = param2;
         if(param1 != undefined)
         {
            _loc4_ = String(param1);
            if(_loc4_.charAt(0) == "%")
            {
               _loc4_ = _loc4_.replace("%","");
               _loc3_ = Number(ExternalData.constants[_loc4_]);
            }
            else
            {
               _loc3_ = Number(param1);
            }
         }
         return _loc3_;
      }
      
      public static function GetAttrInt(param1:Object, param2:int = 0) : int
      {
         var _loc3_:int = param2;
         if(param1 != undefined)
         {
            _loc3_ = int(param1);
         }
         return _loc3_;
      }
      
      public static function GetAttrBoolean(param1:Object, param2:Boolean = false) : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:Boolean = param2;
         if(param1 != null && param1 != undefined)
         {
            _loc3_ = false;
            _loc4_ = String(param1);
            _loc4_ = _loc4_.toLowerCase();
            if(param1 == "true")
            {
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
   }
}

