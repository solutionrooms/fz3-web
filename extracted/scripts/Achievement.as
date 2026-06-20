package
{
   public class Achievement
   {
      
      internal var name:String;
      
      internal var description:String;
      
      internal var complete:Boolean;
      
      internal var testFunction:String;
      
      internal var testFunctionParams:String;
      
      internal var completeFunction:String;
      
      internal var completeFunctionParams:String;
      
      internal var specificLevel:int;
      
      internal var specificLevelName:String;
      
      public function Achievement()
      {
         super();
         this.name = "undefined";
         this.description = "undefined";
         this.complete = false;
         this.testFunction = null;
         this.completeFunction = null;
         this.completeFunctionParams = null;
         this.testFunctionParams = null;
         this.specificLevel = -1;
         this.specificLevelName = "";
      }
   }
}

