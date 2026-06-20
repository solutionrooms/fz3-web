package
{
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class ZombieHolder
   {
      
      internal static var dictionary:Dictionary;
      
      public function ZombieHolder()
      {
         super();
      }
      
      public static function InitOnce() : *
      {
         dictionary = new Dictionary();
      }
      
      public static function Add(param1:MovieClip, param2:String, param3:Function, param4:int, param5:int, param6:int) : DisplayObj
      {
         var _loc7_:DisplayObj = null;
         var _loc8_:String = param2 + param4 + "_" + param5 + "_" + param6;
         if(dictionary[_loc8_] == null)
         {
            _loc7_ = new DisplayObj(null,1,0);
            _loc7_.origMC = param1;
            _loc7_.CreateBlankBitmapsFromMovieClip(_loc7_.origMC,0,param3);
            _loc7_.name = _loc7_.origMC.name;
            dictionary[_loc8_] = _loc7_;
         }
         else
         {
            _loc7_ = dictionary[_loc8_];
         }
         return _loc7_;
      }
   }
}

