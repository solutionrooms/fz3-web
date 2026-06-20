package
{
   import Box2D.Collision.b2AABB;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2World;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.Endian;

   // FZ3 golden-trace harness — injected as the document class `Preloader` via
   // `ffdec -replace` into a copy of flaming-zombooka-3.swf, so it links the
   // SHIPPED 2011 Box2DFlash 2.0.2 bytecode. Run under Ruffle headless; every
   // traced line is scraped to a golden JSON and bit-compared (hex16) against
   // the TypeScript port.
   //
   // Two engine-unit scenes, both shapeless bodies whose mass is set directly
   // on the b2BodyDef (so m0/m1 isolate the integrator — no collision/broadphase
   // touches a body with no fixtures):
   //   [M0] pure freefall under gravity.
   //   [M1] freefall + initial linear velocity + constant spin (centred body =>
   //        trig-immune position; exercises angle integration & b2Mat22.Set).
   public class Preloader extends MovieClip
   {
      private var _ba:ByteArray;

      public function Preloader()
      {
         super();
         this._ba = new ByteArray();
         this._ba.endian = Endian.BIG_ENDIAN;
         try
         {
            this.runM0();
            this.runM1();
         }
         catch(e:Error)
         {
            trace("[ERR] " + e.toString());
         }
         trace("[DONE]");
      }

      // 8 hex digits, zero-padded, of a uint32.
      private function hex8(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16);
         while(_loc2_.length < 8)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }

      // Raw IEEE-754 bits of a Number as 16 contiguous hex digits (hi word then
      // lo word, big-endian) == f64hex on the TS side. NEVER trace decimals.
      private function bits(param1:Number) : String
      {
         this._ba.position = 0;
         this._ba.writeDouble(param1);
         this._ba.position = 0;
         var _loc2_:uint = this._ba.readUnsignedInt();
         var _loc3_:uint = this._ba.readUnsignedInt();
         return this.hex8(_loc2_) + this.hex8(_loc3_);
      }

      private function makeWorld() : b2World
      {
         var _loc1_:b2AABB = new b2AABB();
         _loc1_.lowerBound.Set(-2500,-2500);
         _loc1_.upperBound.Set(2500,2500);
         var _loc2_:b2Vec2 = new b2Vec2(0,6);
         return new b2World(_loc1_,_loc2_,true);
      }

      private function makeDynamicBody(param1:b2World, param2:Number, param3:Number) : b2Body
      {
         var _loc4_:b2BodyDef = new b2BodyDef();
         _loc4_.position.Set(param2,param3);
         _loc4_.massData.mass = 1;
         _loc4_.massData.I = 1;
         return param1.CreateBody(_loc4_);
      }

      private function emit(param1:String, param2:int, param3:b2Body) : void
      {
         trace("[" + param1 + "] " + param2
            + " " + this.bits(param3.GetPosition().x)
            + " " + this.bits(param3.GetPosition().y)
            + " " + this.bits(param3.GetAngle())
            + " " + this.bits(param3.GetLinearVelocity().x)
            + " " + this.bits(param3.GetLinearVelocity().y)
            + " " + this.bits(param3.GetAngularVelocity()));
      }

      private function runM0() : void
      {
         var _loc4_:int = 0;
         var _loc1_:b2World = this.makeWorld();
         var _loc2_:b2Body = this.makeDynamicBody(_loc1_,10,-20);
         this.emit("M0",0,_loc2_);
         _loc4_ = 1;
         while(_loc4_ <= 200)
         {
            _loc1_.Step(1 / 60,5);
            this.emit("M0",_loc4_,_loc2_);
            _loc4_++;
         }
      }

      private function runM1() : void
      {
         var _loc4_:int = 0;
         var _loc1_:b2World = this.makeWorld();
         var _loc2_:b2Body = this.makeDynamicBody(_loc1_,10,-20);
         _loc2_.SetLinearVelocity(new b2Vec2(3,-8));
         _loc2_.SetAngularVelocity(2.5);
         this.emit("M1",0,_loc2_);
         _loc4_ = 1;
         while(_loc4_ <= 200)
         {
            _loc1_.Step(1 / 60,5);
            this.emit("M1",_loc4_,_loc2_);
            _loc4_++;
         }
      }
   }
}
