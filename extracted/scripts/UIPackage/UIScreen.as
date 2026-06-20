package UIPackage
{
   public class UIScreen
   {
      
      internal var name:String;
      
      internal var overlay:Boolean;
      
      internal var theClass:Class;
      
      internal var params:Object;
      
      public function UIScreen(param1:String, param2:Boolean, param3:Class, param4:*)
      {
         super();
         this.name = param1;
         this.overlay = param2;
         this.theClass = param3;
         this.params = param4;
      }
   }
}

