package
{
   import Box2D.Dynamics.b2Body;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.Endian;

   // Multi-level CREATION+STEP sweep: boot once (shared boot-bypass — see harness-intro1.as), then for each
   // level build it via the game's own creation code and step it 2×(1/60) ×NUM_FRAMES with NO game logic,
   // dumping every body as [L<li>B<idx>] <step> px py angle vx vy ω (raw f64). One inject + capture → goldens
   // for the whole batch, to flush out init-function physics-flag gaps (only a STEPPED golden catches them).
   public class Preloader extends MovieClip
   {
      private static const LEVELS:Array = [
         "Animal Man", "Animal Man Intro", "Flying Grayskins", "Working Custard", "Pitfalls",
         "Ring Of Fire", "Whack-A-Zom", "All Angles", "Sore!", "The Boys Are Here", "Dancing"
      ];
      private static const NUM_FRAMES:int = 50; // enough to separate gross init-flag gaps (≤~20) from trig (≥17)

      private var _ba:ByteArray;
      private var _main:Main;
      private var _seenClips:Object;

      public function Preloader()
      {
         super();
         this._ba = new ByteArray();
         this._ba.endian = Endian.BIG_ENDIAN;
         if(stage) this.boot(); else addEventListener(Event.ADDED_TO_STAGE,this.onStage);
      }

      private function onStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onStage);
         this.boot();
      }

      private function boot() : void
      {
         try
         {
            trace("[PHASE] 0 boot-start");
            GameObjects.InitOnce(Defs.maxGameObjects);
            Particles.InitOnce(Defs.maxParticles);
            GraphicObjects.InitOnce(this.afterGraphics);
         }
         catch(e:Error) { trace("[ERR] boot " + e.toString()); trace("[DONE]"); }
      }

      private function afterGraphics() : void
      {
         try { ExternalData.Load(this.afterData); }
         catch(e:Error) { trace("[ERR] aftergraphics " + e.toString()); trace("[DONE]"); }
      }

      private function afterData() : void
      {
         var li:int = 0;
         try
         {
            this._main = new Main(); // not added to stage → no Lic
            Game.main = this._main;
            Game.objectParameters = new ObjectParameters();
            Game.objectParameters.LoadObjectParams();
            Game.LoadPhysMaterials();
            this.preRegisterGraphics();
            Game.objectDefs = new PhysObjs();
            Game.objectDefs.InitFromXml(ExternalData.xml);
            GameVars.InitOnce();
            Levels.LoadAll();
            try { Game.camera = new Camera(); } catch(ce:Error) {}
            try { ZombieHolder.InitOnce(); } catch(ze:Error) {}

            trace("[PHASE] 1 boot-ok levels=" + LEVELS.length);
            li = 0;
            while(li < LEVELS.length)
            {
               this.runLevel(li, String(LEVELS[li]));
               li++;
            }
            trace("[PHASE] 99 sweep-done");
         }
         catch(e:Error) { trace("[ERR] afterdata@L" + li + " " + e.toString()); }
         trace("[DONE]");
      }

      private function runLevel(param1:int, param2:String) : void
      {
         var f:int = 0;
         try
         {
            Levels.currentIndex = Levels.GetLevelIndexByName(param2);
            trace("[PHASE] 2 L" + param1 + " building idx=" + Levels.currentIndex);
            PhysicsBase.InitBox2D();
            GameVars.InitForLevel();
            GameObjects.ClearAll();
            Game.InitLevelPlayFromEditorObjects();
            Game.InitLines();
            Game.InitJoints();
            this.dumpBodies(param1, 0);
            f = 1;
            while(f <= NUM_FRAMES)
            {
               PhysicsBase.world.Step(PhysicsBase.physStep,PhysicsBase.physNumIterations);
               PhysicsBase.world.Step(PhysicsBase.physStep,PhysicsBase.physNumIterations);
               this.dumpBodies(param1, f);
               f++;
            }
         }
         catch(e:Error) { trace("[ERR] L" + param1 + "@" + f + " " + e.toString()); }
      }

      private function dumpBodies(param1:int, param2:int) : void
      {
         var idx:int = 0;
         var b:b2Body = PhysicsBase.world.GetBodyList();
         while(b != null)
         {
            if(b.GetUserData() != -1)
            {
               trace("[L" + param1 + "B" + idx + "] " + param2
                  + " " + this.bits(b.GetPosition().x) + " " + this.bits(b.GetPosition().y)
                  + " " + this.bits(b.GetAngle())
                  + " " + this.bits(b.GetLinearVelocity().x) + " " + this.bits(b.GetLinearVelocity().y)
                  + " " + this.bits(b.GetAngularVelocity()));
               idx++;
            }
            b = b.GetNext();
         }
      }

      private function preRegisterGraphics() : void
      {
         this._seenClips = {};
         this.walkClips(ExternalData.xml);
         if(this._seenClips["fill"] == null)
         {
            this._seenClips["fill"] = true;
            GraphicObjects.AddDobjEmptyBitmap("fill",1,1,true);
         }
      }

      private function walkClips(param1:XML) : void
      {
         var nm:String = null;
         var k:XML = null;
         var att:XMLList = param1.attribute("clip");
         if(att.length() > 0)
         {
            nm = att.toString();
            if(nm != "" && this._seenClips[nm] == null)
            {
               this._seenClips[nm] = true;
               GraphicObjects.AddDobjEmptyBitmap(nm,1,1,true);
            }
         }
         for each(k in param1.children())
         {
            if(k.nodeKind() == "element") this.walkClips(k);
         }
      }

      private function bits(param1:Number) : String
      {
         this._ba.position = 0;
         this._ba.writeDouble(param1);
         this._ba.position = 0;
         return this.hex8(this._ba.readUnsignedInt()) + this.hex8(this._ba.readUnsignedInt());
      }

      private function hex8(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16);
         while(_loc2_.length < 8) _loc2_ = "0" + _loc2_;
         return _loc2_;
      }
   }
}
