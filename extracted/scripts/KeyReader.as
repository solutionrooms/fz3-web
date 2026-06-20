package
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   
   public class KeyReader
   {
      
      public static var active:Boolean;
      
      public static var keysDown:Vector.<int>;
      
      public static var keysPressed:Vector.<Boolean>;
      
      public static const KEY_RIGHT:int = 39;
      
      public static const KEY_LEFT:int = 37;
      
      public static const KEY_UP:int = 38;
      
      public static const KEY_DOWN:int = 40;
      
      public static const KEY_SPACE:int = 32;
      
      public static const KEY_ENTER:int = 13;
      
      public static const KEY_MINUS:int = 189;
      
      public static const KEY_EQUALS:int = 187;
      
      public static const KEY_DOT:int = 190;
      
      public static const KEY_SQUIGGLE:int = 192;
      
      public static const KEY_A:int = 65;
      
      public static const KEY_B:int = 66;
      
      public static const KEY_C:int = 67;
      
      public static const KEY_D:int = 68;
      
      public static const KEY_E:int = 69;
      
      public static const KEY_F:int = 70;
      
      public static const KEY_G:int = 71;
      
      public static const KEY_H:int = 72;
      
      public static const KEY_I:int = 73;
      
      public static const KEY_J:int = 74;
      
      public static const KEY_K:int = 75;
      
      public static const KEY_L:int = 76;
      
      public static const KEY_M:int = 77;
      
      public static const KEY_N:int = 78;
      
      public static const KEY_O:int = 79;
      
      public static const KEY_P:int = 80;
      
      public static const KEY_Q:int = 81;
      
      public static const KEY_R:int = 82;
      
      public static const KEY_S:int = 83;
      
      public static const KEY_T:int = 84;
      
      public static const KEY_U:int = 85;
      
      public static const KEY_V:int = 86;
      
      public static const KEY_W:int = 87;
      
      public static const KEY_X:int = 88;
      
      public static const KEY_Y:int = 89;
      
      public static const KEY_Z:int = 90;
      
      public static const KEY_1:int = 49;
      
      public static const KEY_2:int = 50;
      
      public static const KEY_3:int = 51;
      
      public static const KEY_4:int = 52;
      
      public static const KEY_5:int = 53;
      
      public static const KEY_6:int = 54;
      
      public static const KEY_7:int = 55;
      
      public static const KEY_8:int = 56;
      
      public static const KEY_9:int = 57;
      
      public static const KEY_0:int = 48;
      
      public static const KEY_NUM_0:int = 96;
      
      public static const KEY_NUM_1:int = 97;
      
      public static const KEY_NUM_2:int = 98;
      
      public static const KEY_NUM_3:int = 99;
      
      public static const KEY_NUM_4:int = 100;
      
      public static const KEY_NUM_5:int = 101;
      
      public static const KEY_NUM_6:int = 102;
      
      public static const KEY_NUM_7:int = 103;
      
      public static const KEY_NUM_8:int = 104;
      
      public static const KEY_NUM_9:int = 105;
      
      public static const KEY_NUM_PLUS:int = 107;
      
      public static const KEY_NUM_MINUS:int = 109;
      
      public static const KEY_ESCAPE:int = 27;
      
      public static const KEY_TAB:int = 9;
      
      public static const KEY_INSERT:int = 45;
      
      public static const KEY_DELETE:int = 46;
      
      public static const KEY_HOME:int = 36;
      
      public static const KEY_END:int = 35;
      
      public static const KEY_PAGEUP:int = 33;
      
      public static const KEY_PAGEDOWN:int = 34;
      
      public static const KEY_F1:int = 112;
      
      public static const KEY_F2:int = 113;
      
      public static const KEY_F3:int = 114;
      
      public static const KEY_F4:int = 115;
      
      public static const KEY_F5:int = 116;
      
      public static const KEY_F6:int = 117;
      
      public static const KEY_F7:int = 118;
      
      public static const KEY_F8:int = 119;
      
      public static const KEY_F9:int = 120;
      
      public static const KEY_SHIFT:int = 16;
      
      public static const KEY_CONTROL:int = 17;
      
      public static const KEY_BACKSPACE:int = 8;
      
      public static const KEY_BACKSLASH:int = 220;
      
      public static const KEY_FORWARDSLASH:int = 191;
      
      public static const KEY_HASH:int = 222;
      
      public static const KEY_SEMICOLON:int = 186;
      
      public static const KEY_LEFTSQUAREBRACKET:int = 219;
      
      public static const KEY_RIGHTSQUAREBRACKET:int = 221;
      
      public static const KEY_TOPLEFT:int = 223;
      
      public static const KEY_COMMA:int = 188;
      
      public static const KEY_PERIOD:int = 190;
      
      public function KeyReader()
      {
         super();
      }
      
      public static function Reset() : *
      {
         var _loc1_:int = 0;
         keysDown = new Vector.<int>(256);
         keysPressed = new Vector.<Boolean>(256);
         _loc1_ = 0;
         while(_loc1_ < 256)
         {
            keysDown[_loc1_] = int(0);
            keysPressed[_loc1_] = Boolean(false);
            _loc1_++;
         }
         active = true;
      }
      
      public static function InitOnce(param1:Stage) : *
      {
         param1.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
         param1.addEventListener(KeyboardEvent.KEY_UP,keyUpListener);
         param1.focus = param1;
         Reset();
      }
      
      public static function UpdateOncePerFrame() : void
      {
         var _loc1_:int = 0;
         if(active == false)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < 256)
         {
            if(keysDown[_loc1_] == 1)
            {
               keysPressed[_loc1_] = true;
               ++keysDown[_loc1_];
            }
            else
            {
               keysPressed[_loc1_] = false;
            }
            _loc1_++;
         }
      }
      
      public static function Down(param1:int) : Boolean
      {
         return keysDown[param1] != 0;
      }
      
      public static function Pressed(param1:int) : Boolean
      {
         return keysPressed[param1];
      }
      
      public static function ClearKey(param1:int) : void
      {
         keysPressed[param1] = 0;
         keysDown[param1] = 0;
      }
      
      internal static function keyDownListener(param1:KeyboardEvent) : void
      {
         if(active == false)
         {
            return;
         }
         var _loc2_:int = int(param1.keyCode);
         ++keysDown[_loc2_];
      }
      
      internal static function keyUpListener(param1:KeyboardEvent) : void
      {
         if(active == false)
         {
            return;
         }
         var _loc2_:int = int(param1.keyCode);
         keysDown[_loc2_] = 0;
      }
   }
}

