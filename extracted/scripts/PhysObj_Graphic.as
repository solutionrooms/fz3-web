package
{
   import flash.geom.Point;
   
   public class PhysObj_Graphic
   {
      
      public var graphicName:String;
      
      public var graphicID:int;
      
      public var frame:int;
      
      public var offset:Point;
      
      public var rot:Number;
      
      public var goInitFuntion:String;
      
      public var goInitFuntionVarString:String;
      
      public var zoffset:Number;
      
      public var hasShadow:Boolean;
      
      public function PhysObj_Graphic()
      {
         super();
         this.graphicName = "";
         this.graphicID = 0;
         this.frame = 0;
         this.offset = new Point(0,0);
         this.rot = 0;
         this.goInitFuntion = "";
         this.goInitFuntionVarString = "";
         this.zoffset = 0;
         this.hasShadow = true;
      }
      
      public function Calculate() : *
      {
         this.graphicID = GraphicObjects.GetIndexByName(this.graphicName);
         if(this.frame < 0)
         {
            this.frame = 0;
         }
      }
   }
}

