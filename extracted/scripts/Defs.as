package
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Defs
   {
      
      public static const maxParticles:int = 300;
      
      public static const maxGameObjects:int = 400;
      
      public static const displayarea_w:int = 700;
      
      public static const displayarea_h:int = 500;
      
      public static const gamearea_h:int = 500;
      
      public static const fps:Number = 30;
      
      public static var screenRect:Rectangle = new Rectangle(0,0,displayarea_w,displayarea_h);
      
      public static var pointZero:Point = new Point(0,0);
      
      public function Defs()
      {
         super();
      }
   }
}

