package
{
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2World;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.Endian;

   // m2c golden harness — the FULL integrated path for a single SHAPED body in a real
   // world: CreateBody -> CreateShape (proxy) -> SetMassFromShapes (ComputeMass
   // aggregation -> mass/invMass/I/invI/localCenter) -> ApplyImpulse off-centre ->
   // Step x200 (Collide no-op, Solve integrate, per-step Synchronize -> ComputeSweptAABB
   // -> MoveProxy -> Commit, SolveTOI reset). The box is centred at its COM so position
   // is trig-immune (CLAUDE.md rule 5) => bit-exact. No second shape => no contacts.
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
            this.run();
         }
         catch(e:Error)
         {
            trace("[ERR] " + e.toString());
         }
         trace("[DONE]");
      }

      private function hex8(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16);
         while(_loc2_.length < 8)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }

      private function bits(param1:Number) : String
      {
         this._ba.position = 0;
         this._ba.writeDouble(param1);
         this._ba.position = 0;
         var _loc2_:uint = this._ba.readUnsignedInt();
         var _loc3_:uint = this._ba.readUnsignedInt();
         return this.hex8(_loc2_) + this.hex8(_loc3_);
      }

      private function emitBody(param1:String, param2:int, param3:b2Body) : void
      {
         trace("[" + param1 + "] " + param2
            + " " + this.bits(param3.GetPosition().x)
            + " " + this.bits(param3.GetPosition().y)
            + " " + this.bits(param3.GetAngle())
            + " " + this.bits(param3.GetLinearVelocity().x)
            + " " + this.bits(param3.GetLinearVelocity().y)
            + " " + this.bits(param3.GetAngularVelocity()));
      }

      private function run() : void
      {
         var _loc7_:int = 0;
         var _loc1_:b2AABB = new b2AABB();
         _loc1_.lowerBound.Set(-2500,-2500);
         _loc1_.upperBound.Set(2500,2500);
         var _loc2_:b2World = new b2World(_loc1_,new b2Vec2(0,6),true);

         var _loc3_:b2BodyDef = new b2BodyDef();
         _loc3_.position.Set(10,-20);
         var _loc4_:b2Body = _loc2_.CreateBody(_loc3_);

         var _loc5_:b2PolygonDef = new b2PolygonDef();
         _loc5_.density = 0.5;
         _loc5_.friction = 0.3;
         _loc5_.restitution = 0.1;
         _loc5_.SetAsBox(0.8,0.5);
         _loc4_.CreateShape(_loc5_);
         _loc4_.SetMassFromShapes();

         trace("[MASS] 0 " + this.bits(_loc4_.GetMass())
            + " " + this.bits(_loc4_.m_invMass)
            + " " + this.bits(_loc4_.GetInertia())
            + " " + this.bits(_loc4_.m_invI)
            + " " + this.bits(_loc4_.GetLocalCenter().x)
            + " " + this.bits(_loc4_.GetLocalCenter().y));

         var _loc6_:b2Vec2 = _loc4_.GetWorldCenter();
         _loc4_.ApplyImpulse(new b2Vec2(5,-3),new b2Vec2(_loc6_.x + 0.4,_loc6_.y + 0.2));

         this.emitBody("M2C",0,_loc4_);
         _loc7_ = 1;
         while(_loc7_ <= 200)
         {
            _loc2_.Step(1 / 60,5);
            this.emitBody("M2C",_loc7_,_loc4_);
            _loc7_++;
         }
      }
   }
}
