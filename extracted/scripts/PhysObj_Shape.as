package
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class PhysObj_Shape
   {
      
      public static const Type_Poly:int = 0;
      
      public static const Type_Circle:int = 1;
      
      public var type:int;
      
      public var name:String;
      
      public var collisionCategory:int;
      
      public var collisionMask:int;
      
      public var materialName:String;
      
      public var density:Number;
      
      public var friction:Number;
      
      public var restitution:Number;
      
      public var poly_points:Array;
      
      public var poly_rot:Number;
      
      public var circle_pos:Point;
      
      public var circle_radius:Number;
      
      public function PhysObj_Shape()
      {
         super();
         this.type = 0;
         this.name = "";
         this.poly_points = new Array();
         this.circle_pos = new Point();
         this.circle_radius = 0;
         this.poly_rot = 0;
         this.collisionCategory = 0;
         this.collisionMask = 0;
         this.materialName = "";
      }
      
      public function Caclulate() : *
      {
         var _loc1_:Matrix = null;
         var _loc2_:Array = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         if(this.type == Type_Poly)
         {
            _loc1_ = new Matrix();
            _loc1_.rotate(this.poly_rot);
            _loc2_ = new Array();
            for each(_loc3_ in this.poly_points)
            {
               _loc4_ = _loc1_.transformPoint(_loc3_);
               _loc2_.push(_loc4_);
            }
            this.poly_points = _loc2_;
         }
      }
   }
}

