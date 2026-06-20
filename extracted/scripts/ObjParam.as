package
{
   public class ObjParam
   {
      
      public var name:String;
      
      public var type:String;
      
      public var defaultValue:String;
      
      public var valueList:Array;
      
      public function ObjParam()
      {
         super();
         this.name = "";
         this.type = "";
         this.defaultValue = "";
         this.valueList = new Array();
      }
      
      public function AddValuesString(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 == "")
         {
            return;
         }
         this.valueList = param1.split(",");
      }
   }
}

