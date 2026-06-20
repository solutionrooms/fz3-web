package
{
   public class SeededRandom
   {
      
      public static var seed:uint = 1;
      
      public function SeededRandom()
      {
         super();
      }
      
      internal static function SetSeed(param1:uint) : *
      {
         seed = param1;
      }
      
      public static function GetInt() : uint
      {
         return gen();
      }
      
      public static function GetNumber() : Number
      {
         return gen() / 2147483647;
      }
      
      private static function gen() : uint
      {
         return seed = seed * 16807 % 2147483647;
      }
   }
}

