package EditorPackage
{
   public class PhysEd_GuideLine
   {
      
      public var x0:Number;
      
      public var x1:Number;
      
      public var y0:Number;
      
      public var y1:Number;
      
      public var type:int;
      
      public var level:Boolean;
      
      public function PhysEd_GuideLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean)
      {
         super();
         this.type = param4;
         this.level = param5;
         if(this.type == 0)
         {
            this.x0 = param1;
            this.x1 = param2;
            this.y0 = param3;
            this.y1 = param3;
         }
         else
         {
            this.y0 = param1;
            this.y1 = param2;
            this.x0 = param3;
            this.x1 = param3;
         }
      }
   }
}

