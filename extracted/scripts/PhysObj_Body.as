package
{
   import flash.geom.Point;
   
   public class PhysObj_Body
   {
      
      public var name:String;
      
      public var shapes:Array;
      
      public var graphics:Array;
      
      public var fixed:Boolean;
      
      public var sensor:Boolean;
      
      public var linearDamping:Number;
      
      public var angularDamping:Number;
      
      public var pos:Point;
      
      public function PhysObj_Body()
      {
         super();
         this.shapes = new Array();
         this.graphics = new Array();
         this.name = "";
         this.pos = new Point();
         this.fixed = true;
         this.sensor = false;
         this.linearDamping = 0.1;
         this.angularDamping = 1;
      }
   }
}

