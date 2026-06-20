package
{
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.getDefinitionByName;
   
   public class MusicPlayer
   {
      
      public static var doMusic:Boolean;
      
      internal static var musicSoundTransform:SoundTransform;
      
      internal static var musicSound:Sound;
      
      internal static var musicSoundTransform1:SoundTransform;
      
      internal static var musicSound1:Sound;
      
      internal static var streamChannels:Array;
      
      internal static var streamChannelFlags:Array;
      
      internal static var streamChannelVolumes:Array;
      
      internal static var streamChannelIndices:Array;
      
      internal static var musicChannel:SoundChannel = null;
      
      internal static var musicChannel1:SoundChannel = null;
      
      internal static var lastMusicID:* = -1;
      
      internal static var currentMusicID:int = -1;
      
      internal static var volumeMod:Number = 0.5;
      
      public static var volumeMods:Array = new Array(0.5,0.5,0.5,0.5,0.3,0.3,0.3,0.3);
      
      internal static var streamSound:Sound = null;
      
      public static var currentStreamID:int = -1;
      
      public static var currentStreamName:String = "";
      
      public function MusicPlayer()
      {
         super();
      }
      
      public static function InitOnce() : void
      {
         doMusic = Game.soundon;
         lastMusicID = -1;
         currentMusicID = -1;
         streamChannels = new Array();
         streamChannelFlags = new Array();
         streamChannelVolumes = new Array();
         streamChannelIndices = new Array();
         Utils.trace("InitOnce music");
      }
      
      public static function ToggleMute() : *
      {
         doMusic = doMusic == false;
      }
      
      public static function SetStreamVolume(param1:int, param2:Number) : *
      {
         volumeMods[param1] = param2;
      }
      
      public static function UpdateOncePerFrame() : *
      {
         var _loc3_:SoundTransform = null;
         var _loc4_:int = 0;
         var _loc5_:SoundChannel = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc1_:Number = 0.02;
         var _loc2_:Boolean = false;
         _loc4_ = 0;
         while(_loc4_ < streamChannels.length)
         {
            _loc8_ = _loc4_;
            _loc5_ = streamChannels[_loc4_];
            _loc6_ = int(streamChannelFlags[_loc4_]);
            _loc7_ = Number(streamChannelVolumes[_loc4_]);
            if(_loc6_ == 0)
            {
               _loc3_ = _loc5_.soundTransform;
               _loc7_ += _loc1_;
               if(_loc7_ >= 1)
               {
                  _loc7_ = 1;
                  _loc6_ = 1;
               }
               _loc3_.volume = _loc7_ * volumeMods[_loc8_];
               _loc5_.soundTransform = _loc3_;
            }
            else if(_loc6_ == 1)
            {
               _loc3_ = _loc5_.soundTransform;
               _loc3_.volume = _loc7_ * volumeMods[_loc8_];
               _loc5_.soundTransform = _loc3_;
            }
            else if(_loc6_ == 2)
            {
               _loc3_ = _loc5_.soundTransform;
               _loc7_ -= _loc1_;
               if(_loc7_ <= 0)
               {
                  _loc5_.stop();
                  _loc6_ = 3;
                  _loc2_ = true;
               }
               _loc3_.volume = _loc7_ * volumeMods[_loc8_];
               _loc5_.soundTransform = _loc3_;
            }
            else if(_loc6_ == 3)
            {
            }
            streamChannelFlags[_loc4_] = _loc6_;
            streamChannels[_loc4_] = _loc5_;
            streamChannelVolumes[_loc4_] = _loc7_;
            if(!doMusic)
            {
               _loc3_ = _loc5_.soundTransform;
               _loc3_.volume = 0;
               _loc5_.soundTransform = _loc3_;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            _loc9_ = new Array();
            _loc10_ = new Array();
            _loc11_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < streamChannels.length)
            {
               _loc5_ = streamChannels[_loc4_];
               _loc6_ = int(streamChannelFlags[_loc4_]);
               _loc7_ = Number(streamChannelVolumes[_loc4_]);
               if(_loc6_ != 3)
               {
                  _loc9_.push(_loc6_);
                  _loc10_.push(_loc5_);
                  _loc11_.push(_loc7_);
               }
               _loc4_++;
            }
            streamChannelFlags = _loc9_;
            streamChannels = _loc10_;
            streamChannelVolumes = _loc11_;
         }
         if(!doMusic)
         {
            if(musicChannel != null)
            {
               _loc3_ = musicChannel.soundTransform;
               _loc3_.volume = 0;
               musicChannel.soundTransform = _loc3_;
            }
         }
         else if(musicChannel != null)
         {
            _loc3_ = musicChannel.soundTransform;
            _loc3_.volume = 1;
            musicChannel.soundTransform = _loc3_;
         }
      }
      
      public static function StartStream(param1:String) : *
      {
         var _loc3_:Class = null;
         if(doMusic == false)
         {
            return;
         }
         if(currentStreamName == param1)
         {
            return;
         }
         StopMusic();
         Utils.trace("STARTING TRACK " + param1);
         var _loc2_:String = param1;
         currentStreamName = param1;
         _loc3_ = getDefinitionByName(_loc2_) as Class;
         var _loc4_:Sound = new _loc3_() as Sound;
         var _loc5_:SoundTransform = new SoundTransform(0);
         streamChannels.push(_loc4_.play(0,999999,_loc5_));
         streamChannelFlags.push(int(0));
         streamChannelVolumes.push(Number(0));
      }
      
      public static function StopMusic() : *
      {
         var _loc1_:int = 0;
         var _loc2_:SoundChannel = null;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < streamChannels.length)
         {
            _loc3_ = int(streamChannelFlags[_loc1_]);
            if(_loc3_ == 0 || _loc3_ == 1)
            {
               _loc3_ = 2;
            }
            streamChannelFlags[_loc1_] = _loc3_;
            _loc1_++;
         }
         if(musicChannel != null)
         {
            musicChannel.stop();
         }
      }
      
      public static function StartMusic(param1:String) : *
      {
         var classRef:Class = null;
         var m:Sound = null;
         var musicName:String = param1;
         if(doMusic == false)
         {
            return;
         }
         if(musicChannel != null)
         {
            musicChannel.stop();
         }
         try
         {
            classRef = getDefinitionByName(musicName) as Class;
         }
         catch(e:Object)
         {
            classRef = null;
         }
         if(classRef != null)
         {
            m = new classRef() as Sound;
            musicSoundTransform = new SoundTransform(1,0);
            musicSound = m;
            musicChannel = musicSound.play(0,999999,musicSoundTransform);
         }
         lastMusicID = 0;
      }
   }
}

