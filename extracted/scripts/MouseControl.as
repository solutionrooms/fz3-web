package
{
   import flash.display.Stage;
   import flash.events.MouseEvent;
   
   public class MouseControl
   {
      
      public static var ox:Number = 0;
      
      public static var oy:Number = 0;
      
      public static var x:Number = 0;
      
      public static var y:Number = 0;
      
      public static var mouseVelX:Number = 0;
      
      public static var mouseVelY:Number = 0;
      
      public static var buttonPressed:Boolean = false;
      
      public static var buttonReleased:Boolean = false;
      
      public static var wheelFunction:Function = null;
      
      public static var dx:Number = 0;
      
      public static var dy:Number = 0;
      
      public static var delta:int = 0;
      
      public function MouseControl()
      {
         super();
      }
      
      public static function InitOnce(param1:Stage) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_MOVE,MouseHandler);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,MouseClickHandler);
         param1.addEventListener(MouseEvent.MOUSE_UP,MouseUpHandler);
         param1.addEventListener(MouseEvent.MOUSE_WHEEL,MouseWheelHandler);
         wheelFunction = null;
      }
      
      public static function SetWheelHandler(param1:Function) : void
      {
         wheelFunction = param1;
      }
      
      public static function Reset() : void
      {
         buttonPressed = false;
         buttonReleased = false;
      }
      
      public static function MouseHandler(param1:MouseEvent) : void
      {
         x = param1.stageX;
         y = param1.stageY;
         mouseVelX = x - ox;
         mouseVelY = y - oy;
         dx = x - ox;
         dy = y - oy;
         ox = x;
         oy = y;
      }
      
      public static function ResetDxDy() : void
      {
         dx = 0;
         dy = 0;
      }
      
      public static function MouseWheelHandler(param1:MouseEvent) : void
      {
         delta = param1.delta;
         if(wheelFunction != null)
         {
            wheelFunction(delta);
         }
      }
      
      public static function MouseClickHandler(param1:MouseEvent) : void
      {
         buttonPressed = true;
         buttonReleased = false;
      }
      
      public static function MouseUpHandler(param1:MouseEvent) : void
      {
         buttonPressed = false;
         buttonReleased = true;
      }
   }
}

