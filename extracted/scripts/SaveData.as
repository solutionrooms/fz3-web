package
{
   import flash.net.SharedObject;
   
   public class SaveData
   {
      
      internal static var id:String = "flamingzombooka3_998";
      
      public function SaveData()
      {
         super();
      }
      
      public static function Exists() : Boolean
      {
         var _loc1_:SharedObject = SharedObject.getLocal(id);
         if(_loc1_ == null)
         {
            return false;
         }
         if(_loc1_.size == 0)
         {
            _loc1_.close();
            return false;
         }
         _loc1_.close();
         return true;
      }
      
      public static function Load() : void
      {
         var _loc1_:SharedObject = null;
         _loc1_ = SharedObject.getLocal(id);
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.size == 0)
         {
            _loc1_.close();
            return;
         }
         Levels.FromSharedObject(_loc1_.data.levels);
         SoundPlayer.doSFX = _loc1_.data.dosfx;
         MusicPlayer.doMusic = _loc1_.data.domusic;
         _loc1_.close();
      }
      
      public static function DontLoad() : void
      {
      }
      
      public static function Clear() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal(id);
         _loc1_.clear();
         _loc1_.close();
         _loc1_.flush();
      }
      
      public static function DontSave() : void
      {
      }
      
      public static function Save() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SharedObject = SharedObject.getLocal(id);
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.size == 0)
         {
         }
         _loc2_.clear();
         _loc2_.data.levels = Levels.ToSharedObject();
         _loc2_.data.dosfx = SoundPlayer.doSFX;
         _loc2_.data.domusic = MusicPlayer.doMusic;
         _loc2_.close();
      }
   }
}

