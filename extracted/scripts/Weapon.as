package
{
   public class Weapon
   {
      
      internal var fireRate:int;
      
      internal var objName:String;
      
      internal var name:String;
      
      internal var isStraight:Boolean;
      
      public function Weapon(param1:String, param2:String, param3:Number, param4:Boolean = false)
      {
         super();
         this.name = param1;
         this.objName = param2;
         this.fireRate = int(param3 * Defs.fps);
         this.isStraight = param4;
      }
   }
}

