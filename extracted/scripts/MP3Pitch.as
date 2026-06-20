package
{
   import flash.events.Event;
   import flash.events.SampleDataEvent;
   import flash.media.Sound;
   import flash.utils.ByteArray;
   
   public class MP3Pitch
   {
      
      private const BLOCK_SIZE:int = 2048;
      
      private var _mp3:Sound;
      
      private var _sound:Sound;
      
      private var _target:ByteArray;
      
      private var _position:Number;
      
      private var _rate:Number;
      
      public function MP3Pitch(param1:String)
      {
         super();
         this._target = new ByteArray();
         this._position = 0;
         this._rate = 1;
         this._sound = new Sound();
         this._sound.addEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleData);
         this._sound.play();
      }
      
      public function get rate() : Number
      {
         return this._rate;
      }
      
      public function set rate(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         this._rate = param1;
      }
      
      private function complete(param1:Event) : void
      {
         this._sound.play();
      }
      
      private function sampleData(param1:SampleDataEvent) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         this._target.position = 0;
         var _loc2_:ByteArray = param1.data;
         var _loc3_:Number = this.BLOCK_SIZE * this._rate;
         var _loc4_:int = this._position;
         var _loc5_:Number;
         var _loc6_:Number = _loc5_ = this._position - _loc4_;
         var _loc7_:int = -1;
         var _loc8_:int = Math.ceil(_loc3_) + 2;
         _loc4_ = 0;
         var _loc9_:int = this._mp3.extract(this._target,_loc8_,_loc4_);
         var _loc10_:int = _loc9_ == _loc8_ ? this.BLOCK_SIZE : int(_loc9_ / this._rate);
         _loc10_ = _loc10_ - 32;
         var _loc15_:Number = 0.3;
         if(SoundPlayer.doSFX == false)
         {
            _loc15_ = 0;
         }
         var _loc16_:int = 0;
         while(_loc16_ < _loc10_)
         {
            if(int(_loc6_) != _loc7_)
            {
               _loc7_ = _loc6_;
               this._target.position = _loc7_ << 3;
               _loc11_ = this._target.readFloat();
               _loc12_ = this._target.readFloat();
               _loc13_ = this._target.readFloat();
               _loc14_ = this._target.readFloat();
            }
            _loc2_.writeFloat((_loc11_ + _loc5_ * (_loc13_ - _loc11_)) * _loc15_);
            _loc2_.writeFloat((_loc12_ + _loc5_ * (_loc14_ - _loc12_)) * _loc15_);
            _loc6_ += this._rate;
            _loc5_ += this._rate;
            while(_loc5_ >= 1)
            {
               _loc5_--;
            }
            _loc16_++;
         }
         if(_loc16_ < this.BLOCK_SIZE)
         {
            while(_loc16_ < this.BLOCK_SIZE)
            {
               _loc2_.writeFloat(0);
               _loc2_.writeFloat(0);
               _loc16_++;
            }
         }
         this._position += _loc3_;
      }
   }
}

