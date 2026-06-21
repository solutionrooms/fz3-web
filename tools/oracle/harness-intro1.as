package
{
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2World;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.Endian;

   // ───────────────────────────────────────────────────────────────────────────────────────────
   // Intro-1 PATCHED-GAME golden harness  (the [ORIG] oracle for the first REAL level).
   //
   // Unlike the engine's standalone-scene harnesses (which build a fresh b2World by hand), this one
   // drives the SHIPPED GAME's OWN creation code to build Intro 1's world, then steps it exactly like
   // Game.UpdateGameplay (2×(1/60) per render frame, no game logic) and dumps every body each step.
   // That proves the GAME's level→body creation (positions, triangulation, materials, filter bits,
   // multi-fixture bodies, creation order) AND the engine are faithful — not just hand-built scenes.
   //
   // WHY engine-only (no GameObjects.Update) is faithful for Intro 1: the 4 zombies are
   // InitZombie_Generic → default state 0 (idle). UpdateZombie state 0 (GameObj.as:3152-3166) only
   // animates + sets face-player xflip; it NEVER mutates the body. Body-mutating states (10-23, walkers)
   // are entered only when a zombie is hit. So for an untouched Intro 1, the game logic leaves all bodies
   // alone ⇒ stepping the world with no game logic equals a real idle playthrough's physics.
   //
   // BOOT-BYPASS: the shipped boot (Preloader→Main→Lic.InitFromMain/Playtomic_Log/ShowIntro) is
   // headless-hostile (network + intro wait). We skip Lic entirely: construct a Main but NEVER add it to
   // the stage (so its ADDED_TO_STAGE→Lic path never fires — it's just the reference Game.InitOnce stores),
   // init only the subsystems creation needs, then call the FAITHFUL CORE of Game.StartLevelPlay
   // (Game.as:1448-1461) directly — InitBox2D + InitForLevel + ClearAll + InitLevelPlayFromEditorObjects +
   // InitLines + InitJoints — skipping the presentation half (HUD/music/background/main.stage/currentMC).
   //
   // Determinism: zombie init pulls Math.random (Utils.RandBetweenInt/Float) but ONLY for visuals
   // (idle-anim choice / frameVel / appearance indices) — none touch the body, so the PHYSICS dump is
   // deterministic without seeding. (A render-state golden WOULD need Math.random seeded; not here.)
   //
   // Output: per body per step  [I1B<idx>] <step> px py angle vx vy omega   (each = 16 hex = raw f64).
   // Body walk order = b2World.GetBodyList() = REVERSE creation order (prepend); the ground body
   // (userData == -1) is skipped so the dump is exactly Intro 1's level bodies. Ends with [DONE].
   // ───────────────────────────────────────────────────────────────────────────────────────────
   public class Preloader extends MovieClip
   {
      private static const NUM_FRAMES:int = 150; // ≥ settle + sleep window (b2_timeToSleep=0.5s=30 steps)

      private var _ba:ByteArray;
      private var _main:Main;

      public function Preloader()
      {
         super();
         this._ba = new ByteArray();
         this._ba.endian = Endian.BIG_ENDIAN;
         // We never add Main to the stage (avoids Lic), but we DO need to be on-stage ourselves before
         // some subsystem inits run; gate on ADDED_TO_STAGE for safety.
         if(stage)
         {
            this.boot();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onStage);
         }
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
            trace("[PHASE] 1 gameobjects+particles-ok");
            // GraphicObjects.InitOnce is SYNCHRONOUS (AddGraphics then cb()); cb = afterGraphics.
            GraphicObjects.InitOnce(this.afterGraphics);
         }
         catch(e:Error)
         {
            trace("[ERR] boot " + e.toString());
            trace("[DONE]");
         }
      }

      private function afterGraphics() : void
      {
         try
         {
            trace("[PHASE] 2 graphics-ok");
            // ExternalData.Load(cb): loadExternalLevels=false ⇒ synchronous embedded XML ⇒ cb=afterData.
            ExternalData.Load(this.afterData);
         }
         catch(e:Error)
         {
            trace("[ERR] aftergraphics " + e.toString());
            trace("[DONE]");
         }
      }

      private function afterData() : void
      {
         var idx:int = 0;
         var lvl:Level = null;
         try
         {
            trace("[PHASE] 3 data-ok");
            this._main = new Main(); // NOT added to stage ⇒ no Lic boot; just the Game.main reference
            // DATA-LOADING SUBSET of Game.InitOnce (Game.as:251-271), skipping the presentation half
            // (HudController.InitOnce → UI/Lic button wiring null-refs headless; achievements; InitGame →
            // StartTitleScreen → main.ClearStage/UI). We replicate ONLY what level→body creation reads.
            Game.main = this._main;
            Game.objectParameters = new ObjectParameters();
            Game.objectParameters.LoadObjectParams();
            Game.LoadPhysMaterials();
            // Pre-register DUMMY DisplayObjs for every @clip name BEFORE InitFromXml. PhysObj_Graphic
            // (PhysObj_Graphic.as:42) resolves graphicID = GraphicObjects.GetIndexByName(clip), which
            // lazily Add()s via getDefinitionByName — and that fails headless on the injected SWF (the
            // graphic symbols aren't AS-resolvable), leaving graphicID = -1, which makes AddPhysObjAt's
            // `go.dobj = GetDisplayObjByIndex(-1)` throw. Seeding harmless dummies makes GetIndexByName
            // return a valid position so the PHYSICS path runs 100% untouched (we never render the dummy).
            this.preRegisterGraphics();
            Game.objectDefs = new PhysObjs();
            Game.objectDefs.InitFromXml(ExternalData.xml);
            GameVars.InitOnce();
            Levels.LoadAll(); // the one creation-relevant call inside InitGame (Game.as:314)
            try { Game.camera = new Camera(); } catch(ce:Error) { trace("[PHASE] 41 camera-skip " + ce.toString()); }
            try { ZombieHolder.InitOnce(); } catch(ze:Error) { trace("[PHASE] 42 zombieholder-skip " + ze.toString()); }
            trace("[PHASE] 4 game-data-ok");

            idx = Levels.GetLevelIndexById("1"); // "Intro 1" = id 1 (first/final campaign set)
            Levels.currentIndex = idx;
            lvl = Levels.GetCurrent();
            trace("[PHASE] 5 level-selected idx=" + idx + " name=" + (lvl != null ? lvl.name : "<null>"));

            // ── The FAITHFUL CORE of Game.StartLevelPlay (Game.as:1448-1461) ──
            trace("[PHASE] 60 initbox2d");
            PhysicsBase.InitBox2D();
            trace("[PHASE] 61 initforlevel");
            GameVars.InitForLevel();
            trace("[PHASE] 62 clearall");
            GameObjects.ClearAll();
            trace("[PHASE] 63 editorobjects");
            Game.InitLevelPlayFromEditorObjects();
            trace("[PHASE] 64 lines");
            Game.InitLines();
            trace("[PHASE] 65 joints");
            Game.InitJoints();
            trace("[PHASE] 66 world-built bodies=" + this.countBodies());

            this.dumpBodies(0); // initial conditions (frame 0)
            this.run();
         }
         catch(e:Error)
         {
            trace("[ERR] afterdata " + e.toString());
            trace("[DONE]");
         }
      }

      // Seed a dummy DisplayObj for every distinct "clip" attribute in the object-defs XML so
      // GetIndexByName resolves to a valid position (instead of a failing headless
      // getDefinitionByName → -1). Uses method-call E4X (children()/attribute()) — ffdec's recompiler
      // rejects the `..@clip` descendant-attribute operator.
      private var _seenClips:Object;
      private var _clipCount:int;

      private function preRegisterGraphics() : void
      {
         this._seenClips = {};
         this._clipCount = 0;
         this.walkClips(ExternalData.xml);
         this.registerDummy("fill"); // hardcoded line-fill graphic (InitPhysicsLineObject), not a @clip
         trace("[PHASE] 9 preregistered-clips=" + this._clipCount);
      }

      // A well-formed 1-frame dummy (GetNumFrames()→1) so the shipped display setup that runs INSIDE
      // creation (e.g. InitGameObjLine_Wood → dobj.GetNumFrames()) doesn't null-ref. Never rendered.
      private function registerDummy(param1:String) : void
      {
         if(param1 != "" && this._seenClips[param1] == null)
         {
            this._seenClips[param1] = true;
            GraphicObjects.AddDobjEmptyBitmap(param1,1,1,true);
            this._clipCount++;
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
            this.registerDummy(nm);
         }
         for each(k in param1.children())
         {
            if(k.nodeKind() == "element")
            {
               this.walkClips(k);
            }
         }
      }

      private function run() : void
      {
         var f:int = 1;
         try
         {
            while(f <= NUM_FRAMES)
            {
               // Game.UpdateGameplay cadence: two 1/60 substeps per render frame, no game logic.
               PhysicsBase.world.Step(PhysicsBase.physStep,PhysicsBase.physNumIterations);
               PhysicsBase.world.Step(PhysicsBase.physStep,PhysicsBase.physNumIterations);
               this.dumpBodies(f);
               f++;
            }
            trace("[PHASE] 70 stepped " + NUM_FRAMES + " frames");
         }
         catch(e:Error)
         {
            trace("[ERR] run@" + f + " " + e.toString());
         }
         trace("[DONE]");
      }

      private function countBodies() : int
      {
         var n:int = 0;
         var b:b2Body = PhysicsBase.world.GetBodyList();
         while(b != null)
         {
            if(b.GetUserData() != -1)
            {
               n++;
            }
            b = b.GetNext();
         }
         return n;
      }

      private function dumpBodies(param1:int) : void
      {
         var idx:int = 0;
         var b:b2Body = PhysicsBase.world.GetBodyList();
         while(b != null)
         {
            if(b.GetUserData() != -1) // skip the internal ground body
            {
               this.emit("I1B" + idx,param1,b);
               idx++;
            }
            b = b.GetNext();
         }
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

      private function bits(param1:Number) : String
      {
         this._ba.position = 0;
         this._ba.writeDouble(param1);
         this._ba.position = 0;
         var _loc2_:uint = this._ba.readUnsignedInt();
         var _loc3_:uint = this._ba.readUnsignedInt();
         return this.hex8(_loc2_) + this.hex8(_loc3_);
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
   }
}
