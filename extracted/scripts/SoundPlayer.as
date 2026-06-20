package
{
   import flash.events.SampleDataEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class SoundPlayer
   {
      
      public static var soundTransform:SoundTransform;
      
      public static var sound:Sound;
      
      internal static var timer:Timer;
      
      internal static var channel:SoundChannel;
      
      internal static var playingFlag:Boolean;
      
      internal static var Instances:Array;
      
      public static var doSFX:Boolean;
      
      public static var playingNames:Array;
      
      public static var playingChannels:Array;
      
      public static var startTimes:Array;
      
      public static var volumes:Array;
      
      public static var lengths:Array;
      
      public static var sounds:Array;
      
      public static var times:Array;
      
      public static var names:Array;
      
      public static var groups:Array;
      
      public static var groupNames:Array;
      
      public static var soundChannels:Array;
      
      public static var soundTransforms:Array;
      
      public static const minPlayTime:* = 3;
      
      internal static var active:* = false;
      
      public function SoundPlayer()
      {
         super();
      }
      
      public static function InitOnce() : void
      {
         var _loc1_:Array = null;
         doSFX = Game.soundon;
         groups = new Array();
         groupNames = new Array();
         startTimes = new Array();
         lengths = new Array();
         sounds = new Array();
         names = new Array();
         times = new Array();
         volumes = new Array();
         soundChannels = new Array();
         soundTransforms = new Array();
         if(doSFX)
         {
            AddSound("sfx_anvil");
            AddSound("sfx_barrelexplode");
            AddSound("sfx_bazookafire");
            AddSound("sfx_bazookafire_01");
            AddSound("sfx_bazookafire_02");
            AddSound("sfx_bazookafire_03");
            AddSound("sfx_cannon_fire");
            AddSound("sfx_cannon_load");
            AddSound("sfx_cannonball_fire");
            AddSound("sfx_chainsaw");
            AddSound("sfx_circular_saw_loop");
            AddSound("sfx_corkedup");
            AddSound("sfx_crate");
            AddSound("sfx_elephant");
            AddSound("sfx_explode_zombie");
            AddSound("sfx_fire_bullet");
            AddSound("sfx_flame_bullet");
            AddSound("sfx_flame_loop");
            AddSound("sfx_glass");
            AddSound("sfx_humanscream");
            AddSound("sfx_missile_explosion_01");
            AddSound("sfx_missile_explosion_02");
            AddSound("sfx_missile_explosion_03");
            AddSound("sfx_missile_explosion_04");
            AddSound("sfx_missile_explosion_05");
            AddSound("sfx_piano_crash");
            AddSound("sfx_pie_explode");
            AddSound("sfx_pie_fire");
            AddSound("sfx_pie_hit");
            AddSound("sfx_pin_break");
            AddSound("sfx_platform_click");
            AddSound("sfx_rail_gun");
            AddSound("sfx_rocketbounce");
            AddSound("sfx_rope_break");
            AddSound("sfx_spark_01");
            AddSound("sfx_spark_02");
            AddSound("sfx_spark_03");
            AddSound("sfx_sparks_loop");
            AddSound("sfx_splat1");
            AddSound("sfx_splat2");
            AddSound("sfx_splat3");
            AddSound("sfx_splat4");
            AddSound("sfx_splat5");
            AddSound("sfx_trampoline");
            AddSound("sfx_zombie_01");
            AddSound("sfx_zombie_02");
            AddSound("sfx_zombie_03");
            AddSound("sfx_zombiegroan");
            AddSound("sfx_sawing_loop");
            AddSound("sfx_pianosong");
         }
         soundTransform = new SoundTransform(1,0);
         active = true;
         playingFlag = false;
         Reset();
      }
      
      internal static function AddGroup(param1:String) : Array
      {
         groupNames.push(param1);
         var _loc2_:Array = new Array();
         groups.push(_loc2_);
         return _loc2_;
      }
      
      public static function Reset() : void
      {
         SoundMixer.stopAll();
         playingChannels = new Array();
         playingNames = new Array();
         MusicPlayer.currentStreamName = "";
      }
      
      public static function UpdateOncePerFrame() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(times.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(times[_loc1_] > 0)
            {
               --times[_loc1_];
            }
            _loc1_++;
         }
      }
      
      public static function ToggleMute() : *
      {
         doSFX = doSFX == false;
      }
      
      public static function ToggleMuteAll() : *
      {
         doSFX = doSFX == false;
         if(doSFX)
         {
            SoundMixer.soundTransform = new SoundTransform(1);
         }
         else
         {
            SoundMixer.soundTransform = new SoundTransform(0);
         }
      }
      
      internal static function AddSound(param1:String) : *
      {
         var classRef:Class = null;
         var s:Sound = null;
         var _soundName:String = param1;
         try
         {
            classRef = getDefinitionByName(_soundName) as Class;
         }
         catch(e:Object)
         {
            classRef = null;
         }
         if(classRef == null)
         {
            sounds.push(null);
         }
         else
         {
            s = new classRef() as Sound;
            sounds.push(s);
         }
         names.push(_soundName);
         startTimes.push(0);
         lengths.push(s.length);
         volumes.push(1);
         times.push(0);
      }
      
      public static function GetLengthById(param1:int) : int
      {
         return lengths[param1];
      }
      
      public static function GetId(param1:String) : int
      {
         return names.indexOf(param1);
      }
      
      public static function PlayRandomBetween(param1:String, param2:String, param3:Number = 1, param4:int = 0, param5:String = "") : int
      {
         if(doSFX == false)
         {
            return 0;
         }
         var _loc6_:int = names.indexOf(param1);
         var _loc7_:int = names.indexOf(param2);
         var _loc8_:int = Utils.RandBetweenInt(_loc6_,_loc7_);
         PlayById(param1 + "-" + param2,_loc8_,param3,param4,param5);
         return _loc8_;
      }
      
      public static function GetSoundByName(param1:String) : Sound
      {
         var _loc2_:int = names.indexOf(param1);
         return sounds[_loc2_];
      }
      
      public static function PlayGroupDebug(param1:String, param2:Number = 1, param3:int = 0, param4:String = "", param5:Function = null) : Sound
      {
         Utils.trace("Play Sound Group " + param1 + "  vol:" + param2);
         return PlayGroup(param1,param2,param3,param4,param5);
      }
      
      public static function PlayGroup(param1:String, param2:Number = 1, param3:int = 0, param4:String = "", param5:Function = null) : Sound
      {
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc6_:Sound = null;
         if(param1.search("group") == -1)
         {
            _loc6_ = Play(param1,param2,param3,param4,param5);
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < groupNames.length)
            {
               if(groupNames[_loc7_] == param1)
               {
                  _loc8_ = groups[_loc7_];
                  _loc9_ = _loc8_[Utils.RandBetweenInt(0,_loc8_.length - 1)];
                  _loc6_ = Play(_loc9_,param2,param3,param4,param5);
               }
               _loc7_++;
            }
         }
         return _loc6_;
      }
      
      public static function PlayOnce(param1:String, param2:Number = 1, param3:int = 0, param4:String = "", param5:Function = null) : Sound
      {
         if(doSFX == false)
         {
            return null;
         }
         var _loc6_:int = names.indexOf(param1);
         return PlayById(param1,_loc6_,param2,param3,param4,param5);
      }
      
      public static function Play(param1:String, param2:Number = 1, param3:int = 0, param4:String = "", param5:Function = null) : Sound
      {
         if(doSFX == false)
         {
            return null;
         }
         var _loc6_:int = names.indexOf(param1);
         return PlayById(param1,_loc6_,param2,param3,param4,param5);
      }
      
      public static function PlayById(param1:String, param2:int, param3:Number = 1, param4:int = 0, param5:String = "", param6:Function = null) : Sound
      {
         var _loc7_:SoundTransform = null;
         var _loc8_:Sound = null;
         var _loc9_:Sound = null;
         var _loc10_:SoundChannel = null;
         if(doSFX == false)
         {
            return null;
         }
         if(times[param2] > 0)
         {
            return null;
         }
         if(sounds[param2] != null)
         {
            _loc8_ = sounds[param2];
            if(param6 != null)
            {
               _loc9_ = new Sound();
               _loc9_.addEventListener(SampleDataEvent.SAMPLE_DATA,param6);
               _loc9_.play(0,param4);
               _loc8_ = _loc9_;
            }
            else
            {
               _loc7_ = new SoundTransform();
               _loc7_.volume = param3;
               _loc10_ = _loc8_.play(0,param4,_loc7_);
               times[param2] = 5;
            }
            if(param5 != "")
            {
               playingNames.push(param5);
               playingChannels.push(_loc10_);
            }
         }
         else
         {
            Utils.trace("SoundPlayer: Cant find sound " + param1 + " " + param2);
         }
         return _loc8_;
      }
      
      public static function SetSoundChannelVolume(param1:SoundChannel, param2:Number) : *
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:SoundTransform = param1.soundTransform;
         _loc3_.volume = param2;
         param1.soundTransform = _loc3_;
      }
      
      public static function GetSoundChannelByName(param1:String) : SoundChannel
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc2_ = 0;
         while(_loc2_ < playingChannels.length)
         {
            _loc3_ = playingNames[_loc2_];
            if(_loc3_ == param1)
            {
               return playingChannels[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

