package
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Joints.*;
   import LicPackage.Lic;
   import LicPackage.LicDef;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.SoundChannel;
   
   public class GameObj extends GameObj_Base
   {
      
      internal var textMessage:String;
      
      internal var textMessage1:String;
      
      internal var scaleVel:Number;
      
      internal var scaleAcc:Number;
      
      internal var scaleMax:Number;
      
      public var physObjOffsetX:Number;
      
      public var physObjOffsetY:Number;
      
      public var physObjInitVarString:String;
      
      internal var charCode:int;
      
      internal var showTimer:Boolean;
      
      internal var exploderType:int;
      
      internal var breakSFX:String;
      
      internal var oldMask:uint;
      
      internal var breakable_piece_def_list:Array;
      
      internal var force_strength:Number;
      
      internal var player_head_rot_offset:Number;
      
      internal var player_head_rot_to_offset:Number;
      
      internal var player_head_rot_timer:int;
      
      internal var displayPlayerSelector:int;
      
      internal var absoluteHeadOffset:Point = new Point(0,-42);
      
      internal var absolutePivotOffset:Point = new Point(0,-36);
      
      internal var barrelOffset:Point = new Point(30,0);
      
      internal var aimVec:Vec = new Vec();
      
      internal var isActivePlayer:Boolean;
      
      internal var ammo:int;
      
      internal var ammoMax:int;
      
      internal var weaponName:String;
      
      internal var weaponTimer:int;
      
      internal var deathLimbArray:Array;
      
      internal var attachment_AttachFlag:int;
      
      internal var attachment_AttachPoint:Point;
      
      internal var attachment_AttachJoint:b2Joint;
      
      internal var attachment_AttachObject:GameObj;
      
      internal var trailName:String;
      
      internal var zombie_headIndex:int;
      
      internal var zombie_bodyIndex:int;
      
      internal var zombie_legIndex:int;
      
      internal var zombie_electricDisplayFlag:Boolean;
      
      internal var zombie_electricTimer:int;
      
      internal var zombie_fireTimer:int;
      
      internal var cannonGO:GameObj;
      
      internal var zombieMakeNonWalker:Boolean;
      
      internal var isZombieWalker:Boolean;
      
      internal var zombieDobj:DisplayObj = null;
      
      internal var zombieTurnAroundTimer:int;
      
      internal var isSuperZombie:Boolean;
      
      internal var killsSuperZombie:Boolean;
      
      internal var disk_velocity:Number;
      
      internal var disk_type:String;
      
      internal var spawner_initialdelay:int;
      
      internal var spawner_frequency:int;
      
      internal var spawner_total:int;
      
      internal var spawner_spawncount:int;
      
      internal var spawner_spawnobject:String;
      
      internal var cannonCorked:Boolean;
      
      public function GameObj()
      {
         super();
      }
      
      internal function ShowHealthBar() : *
      {
         healthBarTimer = Defs.fps * 1;
      }
      
      internal function RenderHealthBar(param1:int, param2:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Rectangle = null;
         if(healthBarTimer > 0)
         {
            _loc3_ = xpos + param1 - Game.camera.x;
            _loc4_ = ypos + param2 - Game.camera.y;
            _loc5_ = new Rectangle(_loc3_ - 10,_loc4_,20,3);
            bd.fillRect(_loc5_,4278190080);
            _loc5_.width = Utils.ScaleTo(0,20,0,maxHealth,health);
            bd.fillRect(_loc5_,4294901760);
         }
      }
      
      public function InitTextMessage(param1:String, param2:Number, param3:Number) : void
      {
         this.textMessage = param1;
         updateFunction = this.UpdateTextMessage;
         renderFunction = this.RenderTextMessage;
         timer = 50;
         yvel = 0;
         zpos = -1000;
         yvel = 0;
         scale = 1;
         zvel = 0.1;
         alpha = 1;
      }
      
      internal function RenderTextMessage() : *
      {
         var _loc1_:Number = xpos;
         var _loc2_:Number = ypos;
         var _loc3_:Number = GraphicObjects.GetStringWidth(bd,GraphicObjects.gfx_font1,_loc1_,_loc2_,this.textMessage);
         GraphicObjects.RenderStringAt(bd,GraphicObjects.gfx_font1,_loc1_ - _loc3_ / 2,_loc2_,this.textMessage);
      }
      
      internal function UpdateTextMessage() : *
      {
         yvel -= 0.02;
         ypos += yvel;
         --timer;
         if(timer <= 0)
         {
            timer = 0;
            RemoveObject();
         }
      }
      
      public function RenderScoreOverlay() : void
      {
         RenderDispObjNormally();
      }
      
      public function UpdateScoreOverlay() : void
      {
         yvel -= 0.002;
         ypos += yvel;
         scale += this.scaleVel;
         if(scale > 1)
         {
            this.scaleVel -= this.scaleAcc;
         }
         if(scale < 1)
         {
            this.scaleVel += this.scaleAcc;
         }
         this.scaleVel = Utils.LimitNumber(-this.scaleMax,this.scaleMax,this.scaleVel);
         this.scaleMax *= 0.95;
         if(this.scaleMax <= 0.01)
         {
            RemoveObject();
         }
      }
      
      public function InitScoreOverlay(param1:int) : void
      {
         ypos -= 50;
         updateFunction = this.UpdateScoreOverlay;
         renderFunction = this.RenderScoreOverlay;
         timer = Defs.fps * 5.8;
         frame = param1;
         dobj = GraphicObjects.GetDisplayObjByName("ScoreText");
         scale = 0;
         this.scaleVel = 0.1;
         this.scaleAcc = 0.01;
         this.scaleMax = 0.1;
      }
      
      public function InitMessage(param1:int) : void
      {
         updateFunction = this.UpdateMessage;
         timer = Defs.fps * 0.8;
         frame = param1;
         dobj = GraphicObjects.GetDisplayObjByName("StartRaceText");
      }
      
      internal function UpdateMessage() : *
      {
         xpos = 320 + Game.camera.x;
         ypos = 100 + Game.camera.y;
         --timer;
         if(timer <= 0)
         {
            RemoveObject();
         }
      }
      
      public function InitPhysicsObject(param1:int, param2:int, param3:Number = 0, param4:Number = 0, param5:String = "", param6:Boolean = false) : *
      {
      }
      
      public function UpdatePhysicsObject() : *
      {
      }
      
      public function SetMarkerPos(param1:Number, param2:Number) : *
      {
         if(visible == false)
         {
            xpos = param1;
            ypos = param2;
         }
         toPosX = param1;
         toPosY = param2;
         visible = true;
      }
      
      public function GameObj_UpdateHelpText() : void
      {
         if(state == 0)
         {
            visible = false;
            --timer;
            if(timer <= 0)
            {
               state = 1;
               visible = true;
            }
         }
         else if(state == 1)
         {
            SoundPlayer.Play("sfx_text_appear");
            PlayAnimation();
            visible = true;
            state = 2;
         }
         else if(state == 2)
         {
            PlayAnimation();
         }
      }
      
      public function GameObj_RenderHelpText() : void
      {
         if(GameVars.takingADump)
         {
            return;
         }
         var _loc1_:Number = Math.round(xpos);
         var _loc2_:Number = Math.round(ypos);
         _loc1_ -= Math.round(Game.camera.x);
         _loc2_ -= Math.round(Game.camera.y);
         dobj.origMC.helpClip.help.text = this.textMessage;
         dobj.RenderAtRotScaled_Vector(frame,bd,_loc1_,_loc2_,1,0,null,false,xflip);
      }
      
      public function OnSwitch_HelpText() : void
      {
         if(state == 0)
         {
            state = 1;
         }
      }
      
      public function GameObj_InitHelpText() : void
      {
         name = "text";
         Utils.GetParams(initParams);
         switchName = Utils.GetParamString("switch_name","");
         this.textMessage = Utils.GetParamString("helptext_text","helptxt");
         timer = Utils.GetParamNumber("helptext_initialdelay",0) * Defs.fps;
         updateFunction = this.GameObj_UpdateHelpText;
         renderFunction = this.GameObj_RenderHelpText;
         dobj = GraphicObjects.GetDisplayObjByName("helpText");
         zpos = -10000;
         frame = 0;
         state = 0;
         if(switchName != "")
         {
            timer = 99999999999;
            state = 0;
            switchFunction = this.OnSwitch_HelpText;
         }
         visible = false;
      }
      
      public function GameObj_InitHelpTextImmediate(param1:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:GameObj = null;
         name = "text";
         this.textMessage = param1;
         updateFunction = this.GameObj_UpdateHelpText;
         renderFunction = this.GameObj_RenderHelpText;
         startx = xpos;
         starty = ypos;
         zpos = -10000;
         Game.textFrameOffset = 0;
         timer = Utils.RandBetweenInt(0,50);
         timer1 = Utils.RandBetweenInt(0,50);
         timer = 0;
         var _loc2_:int = GraphicObjects.GetStringWidth(bd,GraphicObjects.gfx_font2,0,0,this.textMessage,null,0);
         _loc2_ /= 2;
         var _loc3_:Array = GraphicObjects.GetStringOffsetTable(GraphicObjects.gfx_font2,this.textMessage,-2);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = GameObjects.AddObj(xpos - _loc2_ + _loc4_.x,ypos + _loc4_.y,zpos);
            _loc5_.GameObj_InitHelpCharacter(_loc4_.a);
         }
         RemoveObject();
      }
      
      public function GameObj_RenderHelpCharacter() : void
      {
         var _loc1_:Number = 0;
         ct.alphaMultiplier = alpha;
         if(alpha != 1 || scale != 1)
         {
            GraphicObjects.GetDisplayObjByIndex(GraphicObjects.gfx_font2 + 1).RenderAtRotScaled(this.charCode,bd,xpos + 1,ypos + 1,scale,_loc1_,ct);
            GraphicObjects.GetDisplayObjByIndex(GraphicObjects.gfx_font2).RenderAtRotScaled(this.charCode,bd,xpos,ypos,scale,_loc1_,ct);
         }
         else
         {
            GraphicObjects.RenderCharCodeAt(bd,GraphicObjects.gfx_font2,xpos,ypos,this.charCode);
         }
      }
      
      public function GameObj_UpdateHelpCharacter() : void
      {
         if(state == 0)
         {
            alpha = 0;
            --timer;
            if(timer <= 0)
            {
               state = 1;
               timerMax = 50;
            }
         }
         if(state == 1)
         {
            xpos = toPosX;
            ypos = toPosY;
            alpha += 0.5;
            scale -= 0.01;
            if(scale < 1)
            {
               scale = 1;
            }
            if(alpha >= 1)
            {
               alpha = 1;
            }
         }
      }
      
      public function GameObj_InitHelpCharacter(param1:int) : void
      {
         ct = new ColorTransform();
         timer = Game.textFrameOffset;
         ++Game.textFrameOffset;
         toPosX = xpos;
         toPosY = ypos;
         xpos = 0 + Game.textFrameOffset * 5;
         ypos = -40;
         this.charCode = param1;
         updateFunction = this.GameObj_UpdateHelpCharacter;
         renderFunction = this.GameObj_RenderHelpCharacter;
         state = 0;
         radius = 300;
         timer1 = Game.textFrameOffset * 0.4;
         alpha = 0;
         scale = 1.1;
         var _loc2_:GameObj = GameObjects.GetGameObjListByName("player")[0];
         xpos = _loc2_.xpos;
         ypos = _loc2_.ypos;
      }
      
      internal function GameObj_UpdateRemover() : void
      {
         if(PlayAnimation())
         {
            RemoveObject();
         }
      }
      
      internal function GameObj_InitRemover() : void
      {
         updateFunction = this.GameObj_UpdateRemover;
      }
      
      internal function GameObj_InitSwitch() : void
      {
         updateFunction = this.GameObj_UpdateSwitch;
         frameVel = 1;
         state = 0;
         frame = 0;
      }
      
      internal function GameObj_Switch_StopTimer() : void
      {
         state = 0;
         frame = 0;
      }
      
      internal function GameObj_Switch_StartTimer(param1:int) : void
      {
         var _loc2_:Number = 71 - 1;
         frameVel = _loc2_ / param1;
         frame = 1;
         state = 10;
         minFrame = 1;
         maxFrame = 71 - 1;
      }
      
      internal function GameObj_UpdateSwitch() : void
      {
         if(state != 0)
         {
            if(state == 1)
            {
               frameVel = 1;
               if(PlayAnimation())
               {
                  state = 0;
               }
            }
            else if(state == 2)
            {
               frameVel = -1;
               if(PlayAnimation())
               {
                  state = 0;
               }
            }
            else if(state == 3)
            {
               frame = 0;
               state = 0;
            }
            else if(state == 10)
            {
               if(PlayAnimationEx())
               {
                  state = 0;
               }
            }
         }
      }
      
      internal function GameObj_InitStandardObj() : void
      {
         renderFunction = this.GameObj_RenderStandardObj;
         frameVel = 0.5;
         this.showTimer = false;
      }
      
      internal function GameObj_RenderStandardObj() : void
      {
         var _loc1_:Rectangle = null;
         RenderDispObjNormally();
         if(this.showTimer)
         {
            _loc1_ = new Rectangle(xpos - 10,ypos,20,3);
            bd.fillRect(_loc1_,4278190080);
            _loc1_.width = Utils.ScaleTo(0,20,0,timerMax,timer);
            bd.fillRect(_loc1_,4294967295);
         }
      }
      
      internal function Exploder_GenerateObjectsCallback(param1:Object) : *
      {
         var _loc2_:GameObj = PhysicsBase.AddPhysObjAt(param1.name,param1.xpos,param1.ypos,0,1,"","","");
         _loc2_.ApplyImpulseRotSpeed(param1.r,param1.s);
         _loc2_.timer = param1.time;
      }
      
      internal function UpdatePhysObj_Exploder() : *
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Number = NaN;
         if(updateFunction1 != null)
         {
            updateFunction1();
         }
         if(state == 1)
         {
            SetBodyCollisionMask(-1,0);
            state = 2;
         }
         if(state == 2)
         {
            _loc1_ = 8;
            _loc2_ = "exploder_fragment";
            _loc3_ = 16;
            _loc4_ = 0;
            _loc5_ = true;
            if(this.exploderType == 0)
            {
               timer = 0;
            }
            else if(this.exploderType == 1)
            {
               _loc2_ = "fireball_fragment";
               _loc3_ = 8;
               _loc5_ = false;
               if(int(timer % 2) == 0)
               {
                  _loc5_ = true;
               }
               --timer;
               _loc1_ = 1;
               _loc4_ = Math.PI * 2 / 16 * timer;
            }
            if(_loc5_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc1_)
               {
                  _loc7_ = new Object();
                  _loc7_.xpos = xpos;
                  _loc7_.ypos = ypos;
                  _loc8_ = Math.PI * 2 / _loc1_ * _loc6_;
                  _loc8_ = _loc8_ + _loc4_;
                  _loc7_.r = _loc8_;
                  _loc7_.s = 80;
                  _loc7_.name = _loc2_;
                  _loc7_.time = _loc3_;
                  GameObjects.AddToAddList(this.Exploder_GenerateObjectsCallback,_loc7_);
                  _loc6_++;
               }
            }
            if(timer <= 0)
            {
               timer = 0;
               state = 2;
               RemoveObject();
            }
            scale = Utils.ScaleTo(0.1,1,0,timerMax,timer);
         }
         CycleAnimation();
      }
      
      internal function HitPhysObj_Exploder(param1:GameObj) : *
      {
         if(state != 0)
         {
            return;
         }
         if(this.exploderType == 0)
         {
            SoundPlayer.Play("sfx_hit_icecrystal");
         }
         if(this.exploderType == 1)
         {
            SoundPlayer.Play("sfx_fireball");
         }
         state = 1;
         timer = timerMax = Defs.fps * 2;
      }
      
      internal function InitPhysObj_Exploder() : *
      {
         InitPhysObj_Path();
         updateFunction1 = updateFunction;
         Utils.GetParams(initFunctionVarString);
         this.exploderType = Utils.GetParamInt("type");
         name = "exploder";
         updateFunction = this.UpdatePhysObj_Exploder;
         frameVel = 1;
         onHitFunction = this.HitPhysObj_Exploder;
         state = 0;
      }
      
      internal function InitExplosiveBarrel() : *
      {
         updateFunction = this.UpdateExplosiveBarrel;
         onHitFunction = this.OnHitExplosiveBarrel;
         onHitExplosionFunction = this.OnHitExplosion_ExplosiveBarrel;
         frame = 0;
         frameVel = 1;
      }
      
      internal function UpdateExplosiveBarrel() : *
      {
         var _loc1_:GameObj = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vec = null;
         if(state != 0)
         {
            if(state == 1)
            {
               for each(_loc1_ in GameObjects.objs)
               {
                  if(_loc1_.active && _loc1_.listIndex != listIndex)
                  {
                     _loc2_ = 100;
                     _loc3_ = Utils.DistBetweenPoints(xpos,ypos,_loc1_.xpos,_loc1_.ypos);
                     if(_loc3_ < _loc2_)
                     {
                        if(_loc1_.onHitExplosionFunction != null)
                        {
                           _loc1_.onHitExplosionFunction(this,100);
                        }
                        else
                        {
                           Utils.trace("pushed by explosive");
                           _loc4_ = new Vec();
                           _loc4_.SetFromDxDy(_loc1_.xpos - xpos,_loc1_.ypos - ypos);
                           _loc4_.speed = GameVars.explosiveBarrelForce;
                           _loc1_.ApplyImpulse(_loc4_.X(),_loc4_.Y());
                        }
                     }
                  }
               }
               RemoveObject(RemovePhysObj);
               _loc1_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
               _loc1_.InitBarrelExplosion();
               SoundPlayer.PlayRandomBetween("sfx_explosion_01","sfx_explosion_04");
            }
            else if(state == 2)
            {
               --timer;
               if(timer <= 0)
               {
                  state = 1;
               }
            }
         }
      }
      
      internal function OnHitExplosion_ExplosiveBarrel(param1:GameObj, param2:Number) : *
      {
         onHitExplosionFunction = null;
         if(state == 0)
         {
            state = 2;
            timer = 3;
         }
      }
      
      internal function OnHitExplosiveBarrel(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.physobj == null)
         {
            return;
         }
         if(param1.name != "missile")
         {
            return false;
         }
         if(state == 0)
         {
            frame = 0;
            state = 1;
            onHitFunction = null;
         }
      }
      
      internal function InitPhysObj_Breakable_Rope() : *
      {
         this.InitPhysObj_Breakable();
         this.breakSFX = "sfx_rope_snap";
      }
      
      internal function InitPhysObj_Breakable() : *
      {
         this.breakSFX = "";
         updateFunction = this.UpdatePhysObj_Breakable;
         onHitFunction = this.OnHit_Breakable;
         frame = 0;
      }
      
      internal function UpdatePhysObj_Breakable() : *
      {
         if(state != 0)
         {
            if(state == 1)
            {
               RemovePhysObj();
               state = 100;
            }
         }
         if(state == 100)
         {
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      internal function OnHit_Breakable(param1:GameObj) : *
      {
         if(param1.collisionType.search("killzombie") != -1)
         {
            frame = 0;
            frameVel = 1;
            state = 1;
            onHitFunction = null;
            if(this.breakSFX != "")
            {
               SoundPlayer.Play(this.breakSFX);
            }
         }
      }
      
      public function UpdateCannonSmoke() : *
      {
         if(state == 0)
         {
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      public function InitCannonSmoke() : *
      {
         updateFunction = this.UpdateCannonSmoke;
         dobj = GraphicObjects.GetDisplayObjByName("fx_smokepuff");
         frame = 0;
         frameVel = 1;
      }
      
      public function UpdateBarrelExplosion() : *
      {
         if(state == 0)
         {
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      public function InitBarrelExplosion() : *
      {
         updateFunction = this.UpdateBarrelExplosion;
         dobj = GraphicObjects.GetDisplayObjByName("fx_explosion");
         frame = 0;
         frameVel = 1;
         zpos = -1000;
         SoundPlayer.Play("sfx_barrelexplode");
      }
      
      public function UpdateMissileExplosion() : *
      {
         if(state == 0)
         {
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      public function InitMissileExplosion() : *
      {
         updateFunction = this.UpdateMissileExplosion;
         dobj = GraphicObjects.GetDisplayObjByName("fx_explosion");
         frame = 0;
         frameVel = 1;
         zpos = -1000;
         SoundPlayer.PlayRandomBetween("sfx_missile_explosion_01","sfx_missile_explosion_05");
      }
      
      public function InitMushromCloudExplosion() : *
      {
         updateFunction = this.UpdateMissileExplosion;
         dobj = GraphicObjects.GetDisplayObjByName("mushroomCloud");
         frame = 0;
         frameVel = 1;
         zpos = -1002;
         SoundPlayer.PlayRandomBetween("sfx_missile_explosion_01","sfx_missile_explosion_05");
      }
      
      public function InitShockwaveExplosion() : *
      {
         updateFunction = this.UpdateMissileExplosion;
         dobj = GraphicObjects.GetDisplayObjByName("shockWave");
         frame = 0;
         frameVel = 1;
         zpos = -1001;
         SoundPlayer.PlayRandomBetween("sfx_missile_explosion_01","sfx_missile_explosion_05");
      }
      
      internal function InitPhysObj_Path_Virtual() : *
      {
         InitPhysObj_Path();
         visible = false;
      }
      
      internal function InitPhysObj_Path_Normal() : *
      {
         InitPhysObj_Path();
      }
      
      internal function InitPhysObj_Path_Deadly() : *
      {
         InitPhysObj_Path();
         name = "death";
      }
      
      internal function ClickPhysObj_Remover() : *
      {
         if(state != 0)
         {
            return;
         }
         SoundPlayer.PlayRandomBetween("sfx_choc1","sfx_choc3");
         this.RemoveRemover();
      }
      
      internal function RemoveRemover() : *
      {
         RemoveObject(RemovePhysObj);
      }
      
      internal function UpdatePhysObj_Remover() : *
      {
         if(state != 0)
         {
            if(state == 1)
            {
            }
         }
      }
      
      internal function InitPhysObj_Remover() : *
      {
         colFlag_isRemovable = true;
         onClickedFunction = this.ClickPhysObj_Remover;
         updateFunction = this.UpdatePhysObj_Remover;
         state = 0;
         renderShadowFlag = true;
      }
      
      internal function InitGameObjLine_Null() : *
      {
         lineRender_Color0 = 0;
         lineRender_Color1 = 16711680;
         lineRender_Color = 10526880;
         frame = 0;
      }
      
      internal function InitGameObjLine_Remover() : *
      {
         Utils.trace("InitGameObjLine_Remover");
         colFlag_isRemovable = true;
         onClickedFunction = this.ClickPhysObj_Remover;
         updateFunction = this.UpdatePhysObj_Remover;
         state = 0;
         lineRender_Color = 10498096;
         frame = 1;
      }
      
      internal function InitGameObjLine_Remover_Respawn() : *
      {
         Utils.trace("InitGameObjLine_Remover_Respawn");
         colFlag_isRemovable = true;
         onClickedFunction = this.ClickPhysObj_Remover_Respawn;
         updateFunction = this.UpdatePhysObj_Remover_Respawn;
         state = 0;
         lineRender_Color = 10510432;
         frame = 2;
      }
      
      internal function InitGameObjLine_KnifeEdge() : *
      {
         health = maxHealth = 0.3;
         name = "knifeedge";
         collisionType = "killzombie_all";
         collisionExtra = "cut";
         scoreType = "saw";
         frame = 1;
         this.SetPolysMaterial("smooth");
      }
      
      internal function InitPhysObj_Death() : *
      {
         health = maxHealth = 100;
         name = "death";
         collisionType = "killzombie_all";
      }
      
      internal function InitGameObjLine_Death() : *
      {
         collisionType = "killzombie_all";
         name = "death";
         health = maxHealth = 100;
         name = "death";
         Utils.trace("InitGameObjLine_Death");
         state = 0;
         lineRender_Color = 16711680;
         lineRender_Color0 = 8388608;
         lineRender_Color1 = 16711680;
         frame = 4;
      }
      
      internal function InitGameObjLine_Sticky() : *
      {
         name = "sticky";
         Utils.trace("InitGameObjLine_Sticky");
         state = 0;
         lineRender_Color = 16711680;
         lineRender_Color0 = 32768;
         lineRender_Color1 = 65280;
         frame = 3;
      }
      
      internal function InitGameObjLine_Grassy() : *
      {
         this.InitGameObjLine_Wood();
      }
      
      internal function InitGameObjLine_Wood() : *
      {
         name = "grass";
         Utils.trace("InitGameObjLine_Wood");
         state = 0;
         frame = 1;
         this.SetPolysMaterial("average");
         Utils.GetParams(initParams);
         frame = linkedPhysLine.objParameters.GetValueInt("line_background_frame",1);
         --frame;
         frame = Utils.LimitNumber(0,dobj.GetNumFrames() - 1,frame);
         lineRender_Color = 2835220;
      }
      
      internal function InitGameObjLine_Smooth() : *
      {
         Utils.trace("InitGameObjLine_Smooth");
         state = 0;
         frame = 2;
         this.SetPolysMaterial("smooth");
      }
      
      internal function InitGameObjLine_Bouncy() : *
      {
         Utils.trace("InitGameObjLine_Bouncy");
         state = 0;
         frame = 2;
         this.SetPolysMaterial("bouncy");
      }
      
      internal function InitGameObjLine_Icy() : *
      {
         Utils.trace("InitGameObjLine_Icy");
         state = 0;
         frame = 3;
         this.SetPolysMaterial("smooth");
      }
      
      internal function InitGameObjLine_NonCollision() : *
      {
         Utils.trace("InitGameObjLine_NonCollision");
         SetBodyCollisionMask(0,0);
         zpos = 20000;
      }
      
      internal function InitGameObjLine_ScrollArea() : *
      {
         Utils.trace("InitGameObjLine_ScrollArea");
         SetBodyCollisionMask(0,0);
         visible = false;
         linkedPhysLine.CalcBoundingRectangle();
         Game.boundingRectangle = linkedPhysLine.boundingRectangle.clone();
      }
      
      internal function InitGameObjLine_ForShow() : *
      {
         var _loc1_:b2Body = bodies[0];
         PhysicsBase.world.DestroyBody(_loc1_);
         bodies = new Vector.<b2Body>();
         state = 0;
         name = "line_for_show";
         zpos = 0;
      }
      
      internal function SetPolysMaterial(param1:String) : *
      {
         var _loc4_:b2Shape = null;
         var _loc2_:PhysObj_Material = Game.GetPhysMaterialByName(param1);
         var _loc3_:b2Body = bodies[0];
         _loc4_ = _loc3_.GetShapeList();
         while(_loc4_)
         {
            _loc4_.m_friction = _loc2_.friction;
            _loc4_.m_restitution = _loc2_.restitution;
            _loc4_.m_density = _loc2_.density;
            _loc4_ = _loc4_.GetNext();
         }
      }
      
      internal function SetUpLineAsSwitch() : *
      {
         var _loc2_:b2Shape = null;
         var _loc1_:b2Body = bodies[0];
         _loc2_ = _loc1_.GetShapeList();
         while(_loc2_)
         {
            _loc2_.m_isSensor = true;
            Utils.trace("converting to sensor");
            _loc2_ = _loc2_.GetNext();
         }
         id = linkedPhysLine.id;
         visible = false;
      }
      
      internal function InitGameObjLine_Switch() : *
      {
         name = "invisible_switch";
         Utils.trace("InitGameObjLine_Switch");
         this.SetUpLineAsSwitch();
         onHitFunction = SwitchOnceHit;
         updateFunction = UpdateSwitchOnce;
         state = 0;
      }
      
      internal function InitGameObjLine_Background() : *
      {
         zpos = 5000;
         name = "";
         Utils.trace("InitGameObjLine_Background");
         state = 0;
         dobj = GraphicObjects.GetDisplayObjByName("Fills");
         lineRender_Mode = "background";
         SetBodyCollisionMask(0,0);
         frame = 0;
         frame = linkedPhysLine.objParameters.GetValueInt("line_background_frame") - 1;
         if(frame < 0)
         {
            frame = 0;
         }
      }
      
      internal function InitGameObjLine_StickyRespawn() : *
      {
         name = "sticky";
         respawnArea = true;
         Utils.trace("InitGameObjLine_StickyRespawn");
         state = 0;
         lineRender_Color = 16711680;
         lineRender_Color0 = 16544;
         lineRender_Color1 = 41024;
         frame = 3;
      }
      
      internal function ClickPhysObj_Remover_Respawn() : *
      {
         if(state != 0)
         {
            return;
         }
         SetInvisibleTimer(Defs.fps * 2);
         this.oldMask = GetBodyCollisionMask(0);
         SetBodyCollisionMask(0,0);
         state = 1;
      }
      
      internal function UpdatePhysObj_Remover_Respawn() : *
      {
         if(state != 0)
         {
            if(state == 1)
            {
               if(UpdateInvisibleTimer())
               {
                  SetBodyCollisionMask(0,this.oldMask);
                  state = 0;
               }
            }
         }
      }
      
      internal function InitPhysObj_Remover_Respawn() : *
      {
         colFlag_isRemovable = true;
         onClickedFunction = this.ClickPhysObj_Remover_Respawn;
         updateFunction = this.UpdatePhysObj_Remover_Respawn;
         state = 0;
         InitInvisibleTimer();
      }
      
      internal function ClipTest(param1:Number = 40) : Boolean
      {
         if(GameVars.takingADump)
         {
            return true;
         }
         if(xpos + param1 < Game.camera.x)
         {
            return false;
         }
         if(ypos + param1 < Game.camera.y)
         {
            return false;
         }
         if(xpos - param1 > Game.camera.x + Defs.displayarea_w)
         {
            return false;
         }
         if(ypos - param1 > Game.camera.y + Defs.displayarea_h)
         {
            return false;
         }
         return true;
      }
      
      internal function RenderPhysObj_Generic() : *
      {
         RenderDispObjNormally();
      }
      
      internal function RenderBackground() : *
      {
         RenderDispObjAt(0,0,dobj,frame,null,0,1,false);
      }
      
      internal function UpdateBackground() : *
      {
         --timer;
         if(timer <= 0)
         {
            timer = 0;
         }
      }
      
      internal function InitBackground() : *
      {
         renderFunction = this.RenderBackground;
         updateFunction = this.UpdateBackground;
         var _loc1_:Level = Levels.GetCurrent();
         dobj = GraphicObjects.GetDisplayObjByName("background01");
         frame = Levels.GetCurrent().bgFrame - 1;
         xpos = ypos = 0;
      }
      
      public function RenderPolyLayer() : *
      {
         var _loc1_:int = Math.round(Game.camera.x);
         var _loc2_:int = Math.round(Game.boundingRectangle.x);
         var _loc3_:int = Math.round(Game.camera.y);
         var _loc4_:int = Math.round(Game.boundingRectangle.y);
         var _loc5_:Number = _loc2_ - _loc1_;
         var _loc6_:Number = _loc4_ - _loc3_;
         bd.copyPixels(Game.scrollScreenBD,Game.scrollScreenBD.rect,new Point(_loc5_,_loc6_),null,null,true);
      }
      
      public function UpdatePolyLayer() : *
      {
      }
      
      public function InitPolyLayer() : *
      {
         updateFunction = this.UpdatePolyLayer;
         renderFunction = this.RenderPolyLayer;
         zpos = 0;
      }
      
      public function OnHitPinkBall(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name != "zombie" && param1.collisionType != "wood")
         {
            health -= 50;
            if(health <= 0)
            {
               frame = 0;
               frameVel = 1;
               state = 1;
               onHitFunction = null;
               --Game.pianoCount;
            }
         }
      }
      
      internal function InitPhysObj_Breakable_Piano() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(-24,-31,"piano_part1"));
         _loc1_.push(new BreakablePieceDef(8,-34,"piano_part2"));
         _loc1_.push(new BreakablePieceDef(30,-30,"piano_part3"));
         _loc1_.push(new BreakablePieceDef(28,-12,"piano_part4"));
         _loc1_.push(new BreakablePieceDef(24,9,"piano_part5"));
         _loc1_.push(new BreakablePieceDef(-25,8,"piano_part6"));
         _loc1_.push(new BreakablePieceDef(-26,-9,"piano_part7"));
         _loc1_.push(new BreakablePieceDef(-2,10,"piano_part8"));
         _loc1_.push(new BreakablePieceDef(13,7,"piano_part9"));
         _loc1_.push(new BreakablePieceDef(-8,-23,"piano_part10"));
         _loc1_.push(new BreakablePieceDef(12,-17,"piano_part11"));
         _loc1_.push(new BreakablePieceDef(-3,-6,"piano_part12"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         onHitFunction = this.OnHitPinkBall;
         health = maxHealth = 100;
         collisionType = "killzombie_all";
         name = "piano";
         scoreType = "piano";
         break_sfx_name = "sfx_piano_crash";
         ++Game.pianoCount;
      }
      
      public function UpdateSpark() : *
      {
         if(state == 0)
         {
            xpos += xvel;
            ypos += yvel;
            yvel += 0.5;
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      public function InitSpark() : *
      {
         dobj = GraphicObjects.GetDisplayObjByName("Sparks");
         updateFunction = this.UpdateSpark;
         xvel = Utils.RandBetweenFloat(-3,3);
         yvel = Utils.RandBetweenFloat(-1,-5);
         frameVel = Utils.RandBetweenFloat(2,4);
      }
      
      internal function InitPhysObj_Breakable_FortuneMachine() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(-12,-82,"fortune_part1"));
         _loc1_.push(new BreakablePieceDef(15,-78,"fortune_part2"));
         _loc1_.push(new BreakablePieceDef(-9,-66,"fortune_part3"));
         _loc1_.push(new BreakablePieceDef(-10,-44,"fortune_part4"));
         _loc1_.push(new BreakablePieceDef(15,-51,"fortune_part5"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         updateFunction = this.UpdatePhysObj_Breakable_FortuneMachine;
         collisionType = "";
         break_sfx_name = "sfx_crate";
      }
      
      internal function UpdatePhysObj_Breakable_FortuneMachine() : *
      {
         var _loc1_:BreakablePieceDef = null;
         var _loc2_:Number = NaN;
         var _loc3_:GameObj = null;
         var _loc4_:SoundChannel = null;
         if(state == 0)
         {
            frame = 0;
         }
         else if(state == 1)
         {
            frame = 1;
            SoundPlayer.PlayRandomBetween("sfx_wood_snap1","sfx_wood_snap4");
            for each(_loc1_ in this.breakable_piece_def_list)
            {
               _loc2_ = GetBodyAngle(0);
               _loc3_ = GameObjects.AddObj(xpos,ypos,zpos);
               _loc3_.InitBreakable_Piece(_loc1_,_loc2_);
            }
            state = 2;
            health = maxHealth = 1;
            collisionType = "killzombie_all";
            collisionExtra = "electric";
            SetBodySensor(true);
            timer = 0;
            if(Game.sparksActive == false)
            {
               SoundPlayer.Play("sfx_sparks_loop",1,9999999,"sparks");
               _loc4_ = SoundPlayer.GetSoundChannelByName("sparks");
               SoundPlayer.SetSoundChannelVolume(_loc4_,1);
            }
            Game.sparksActive = true;
         }
         else if(state == 2)
         {
            frame = 1;
            --timer;
            if(timer <= 0)
            {
               _loc3_ = GameObjects.AddObj(xpos + Utils.RandBetweenInt(-20,20),ypos + Utils.RandBetweenInt(-20,-40),-1000);
               _loc3_.InitSpark();
               timer = Utils.RandBetweenInt(3,10);
            }
         }
      }
      
      public function OnHitWireEnd(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateWireEnd() : *
      {
         var _loc1_:Point = null;
         var _loc2_:Matrix = null;
         var _loc3_:GameObj = null;
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               _loc1_ = new Point(3,40);
               _loc2_ = new Matrix();
               _loc2_.rotate(dir);
               _loc1_ = _loc2_.transformPoint(_loc1_);
               _loc3_ = GameObjects.AddObj(xpos + _loc1_.x,ypos + _loc1_.y,-1000);
               _loc3_.InitSpark();
               timer = Utils.RandBetweenInt(3,10);
            }
         }
      }
      
      public function InitWireEnd() : *
      {
         health = maxHealth = 1;
         collisionType = "killzombie_all";
         collisionExtra = "electric";
         updateFunction = this.UpdateWireEnd;
         onHitFunction = this.OnHitWireEnd;
         timer = 0;
         Game.sparksActive = true;
      }
      
      internal function InitPhysObj_Breakable_woodenCrate0() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(6,4,"woodenCrate0_part1"));
         _loc1_.push(new BreakablePieceDef(6,14,"woodenCrate0_part2"));
         _loc1_.push(new BreakablePieceDef(20,4,"woodenCrate0_part3"));
         _loc1_.push(new BreakablePieceDef(18,14,"woodenCrate0_part4"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         collisionType = "wood";
         break_sfx_name = "sfx_crate";
      }
      
      internal function InitPhysObj_Breakable_woodenCrate1() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(7,5,"woodenCrate1_part1"));
         _loc1_.push(new BreakablePieceDef(30,4,"woodenCrate1_part2"));
         _loc1_.push(new BreakablePieceDef(42,9,"woodenCrate1_part3"));
         _loc1_.push(new BreakablePieceDef(5,25,"woodenCrate1_part4"));
         _loc1_.push(new BreakablePieceDef(17,15,"woodenCrate1_part5"));
         _loc1_.push(new BreakablePieceDef(33,19,"woodenCrate1_part6"));
         _loc1_.push(new BreakablePieceDef(19,29,"woodenCrate1_part7"));
         _loc1_.push(new BreakablePieceDef(36,30,"woodenCrate1_part8"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         collisionType = "wood";
         break_sfx_name = "sfx_crate";
      }
      
      internal function InitPhysObj_Breakable_woodenPin() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(-4,-6,"woodenPin_part1"));
         _loc1_.push(new BreakablePieceDef(3,-4,"woodenPin_part2"));
         _loc1_.push(new BreakablePieceDef(4,3,"woodenPin_part3"));
         _loc1_.push(new BreakablePieceDef(-4,3,"woodenPin_part4"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         collisionType = "wood";
         break_sfx_name = "sfx_pin_break";
      }
      
      internal function InitPhysObj_Breakable_woodenPost0() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(4,33,"woodPost0_part1"));
         _loc1_.push(new BreakablePieceDef(4,18,"woodPost0_part2"));
         _loc1_.push(new BreakablePieceDef(4,5,"woodPost0_part3"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         collisionType = "wood";
         break_sfx_name = "sfx_crate";
      }
      
      internal function InitPhysObj_Breakable_woodenPost1() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(4,57,"woodPost1_part1"));
         _loc1_.push(new BreakablePieceDef(4,40,"woodPost1_part2"));
         _loc1_.push(new BreakablePieceDef(4,24,"woodPost1_part3"));
         _loc1_.push(new BreakablePieceDef(4,8,"woodPost1_part4"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         collisionType = "wood";
         break_sfx_name = "sfx_crate";
      }
      
      internal function InitPhysObj_Breakable_woodenPost2() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(4,12,"woodenPost2_part1"));
         _loc1_.push(new BreakablePieceDef(4,34,"woodenPost2_part2"));
         _loc1_.push(new BreakablePieceDef(4,55,"woodenPost2_part3"));
         _loc1_.push(new BreakablePieceDef(4,76,"woodenPost2_part4"));
         _loc1_.push(new BreakablePieceDef(4,97,"woodenPost2_part5"));
         _loc1_.push(new BreakablePieceDef(4,115,"woodenPost2_part6"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         collisionType = "wood";
         break_sfx_name = "sfx_crate";
      }
      
      internal function InitPhysObj_Breakable_glassPost0() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(4,33,"glassPost0_part1"));
         _loc1_.push(new BreakablePieceDef(4,18,"glassPost0_part2"));
         _loc1_.push(new BreakablePieceDef(4,5,"glassPost0_part3"));
         this.InitPhysObj_Breakable_Pieces_Glass(_loc1_);
      }
      
      internal function InitPhysObj_Breakable_glassPost1() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(4,57,"glassPost1_part1"));
         _loc1_.push(new BreakablePieceDef(4,40,"glassPost1_part2"));
         _loc1_.push(new BreakablePieceDef(4,24,"glassPost1_part3"));
         _loc1_.push(new BreakablePieceDef(4,8,"glassPost1_part4"));
         this.InitPhysObj_Breakable_Pieces_Glass(_loc1_);
      }
      
      internal function InitPhysObj_Breakable_glassPost2() : *
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new BreakablePieceDef(4,12,"glassPost2_part1"));
         _loc1_.push(new BreakablePieceDef(4,34,"glassPost2_part2"));
         _loc1_.push(new BreakablePieceDef(4,55,"glassPost2_part3"));
         _loc1_.push(new BreakablePieceDef(4,76,"glassPost2_part4"));
         _loc1_.push(new BreakablePieceDef(4,97,"glassPost2_part5"));
         _loc1_.push(new BreakablePieceDef(4,115,"glassPost2_part6"));
         this.InitPhysObj_Breakable_Pieces_Glass(_loc1_);
      }
      
      internal function OnHit_Breakable_Pieces_Glass(param1:GameObj) : *
      {
         if(param1.name.search("missile") != -1)
         {
            frame = 0;
            frameVel = 1;
            state = 1;
            onHitFunction = null;
         }
      }
      
      internal function InitPhysObj_Breakable_Pieces_Glass(param1:Array) : *
      {
         this.breakable_piece_def_list = param1;
         updateFunction = this.UpdatePhysObj_Breakable_Pieces;
         onHitFunction = this.OnHit_Breakable_Pieces_Glass;
         frame = 0;
         break_sfx_name = "sfx_glass";
      }
      
      internal function InitPhysObj_Breakable_Pieces(param1:Array) : *
      {
         this.breakable_piece_def_list = param1;
         updateFunction = this.UpdatePhysObj_Breakable_Pieces;
         onHitFunction = this.OnHit_Breakable_Pieces;
         frame = 0;
         health = maxHealth = 1;
      }
      
      internal function UpdatePhysObj_Breakable_Pieces() : *
      {
         var _loc1_:BreakablePieceDef = null;
         var _loc2_:Number = NaN;
         var _loc3_:GameObj = null;
         if(state != 0)
         {
            if(state == 1)
            {
               if(break_sfx_name != "")
               {
                  SoundPlayer.Play(break_sfx_name);
               }
               RemoveObject(RemovePhysObj());
               for each(_loc1_ in this.breakable_piece_def_list)
               {
                  _loc2_ = GetBodyAngle(0);
                  _loc3_ = GameObjects.AddObj(xpos,ypos,zpos);
                  _loc3_.InitBreakable_Piece(_loc1_,_loc2_);
               }
            }
         }
      }
      
      internal function OnHit_Breakable_Pieces(param1:GameObj) : *
      {
         if(param1.collisionType.search("killzombie") != -1 || param1.name == "zombie" || param1.name.search("missile") != -1)
         {
            if(param1.name != "piano")
            {
               frame = 0;
               frameVel = 1;
               state = 1;
               onHitFunction = null;
            }
         }
      }
      
      public function RenderBreakable_Piece() : *
      {
         RenderNormallyAlpha();
      }
      
      public function UpdateBreakable_Piece() : *
      {
         dir += rotVel;
         xpos += xvel;
         ypos += yvel;
         yvel += 0.3;
         --timer;
         if(timer <= 0)
         {
            RemoveObject();
         }
         alpha = Utils.ScaleTo(0,1,0,timerMax,timer);
      }
      
      public function InitBreakable_Piece(param1:BreakablePieceDef, param2:Number) : *
      {
         updateFunction = this.UpdateBreakable_Piece;
         renderFunction = this.RenderBreakable_Piece;
         dobj = GraphicObjects.GetDisplayObjByName(param1.objname);
         frame = 0;
         var _loc3_:Matrix = new Matrix();
         _loc3_.rotate(param2);
         var _loc4_:Point = new Point(param1.x,param1.y);
         _loc4_ = _loc3_.transformPoint(_loc4_);
         xpos += _loc4_.x;
         ypos += _loc4_.y;
         dir = param2;
         var _loc5_:Vec = new Vec();
         _loc5_.rot = Utils.RandCircle();
         _loc5_.speed = Utils.RandBetweenFloat(1,2);
         xvel = _loc5_.X();
         yvel = _loc5_.Y();
         rotVel = Utils.RandBetweenFloat(0.1,0.2);
         if(Utils.RandBetweenInt(0,1000) < 500)
         {
            rotVel = -rotVel;
         }
         timer = timerMax = Utils.RandBetweenInt(30,40);
      }
      
      internal function OnHit_Wind(param1:GameObj) : *
      {
         if(param1.name.match("ball") == null)
         {
            return;
         }
         var _loc2_:Number = GetBodyAngle(0);
         var _loc3_:Number = 1;
         var _loc4_:Number = 0;
         _loc3_ = Math.cos(_loc2_) * this.force_strength;
         _loc4_ = Math.sin(_loc2_) * this.force_strength;
         param1.ApplyForce(_loc3_,_loc4_);
      }
      
      internal function UpdateWind() : *
      {
         var _loc2_:Point = null;
         var _loc3_:Matrix = null;
         var _loc4_:Point = null;
         var _loc5_:GameObj = null;
         var _loc1_:Number = GetBodyAngle(0);
         _loc1_ -= Math.PI / 2;
         --timer;
         if(timer <= 0)
         {
            _loc2_ = new Point(Utils.RandBetweenInt(-20,20),Utils.RandBetweenInt(-20,20));
            _loc3_ = new Matrix();
            _loc3_.rotate(_loc1_);
            _loc2_ = _loc3_.transformPoint(_loc2_);
            _loc4_ = new Point(GetBodyWorldPosWorldCoords(0).x,GetBodyWorldPosWorldCoords(0).y);
            _loc4_.x += _loc2_.x;
            _loc4_.y += _loc2_.y;
            timer = Utils.RandBetweenInt(5,10);
            _loc5_ = GameObjects.AddObj(_loc4_.x,_loc4_.y,zpos);
            _loc5_.InitWindPart(dir);
         }
      }
      
      internal function InitWind() : *
      {
         name = "wind";
         timer = Utils.RandBetweenInt(10,30);
         this.force_strength = GameVars.windStrength;
         state = 0;
         onHitFunction = this.OnHit_Wind;
         onHitPersistFunction = this.OnHit_Wind;
         updateFunction = this.UpdateWind;
         visible = false;
      }
      
      internal function RenderWindPart() : *
      {
         var _loc1_:Number = int(xpos) - int(Game.camera.x);
         var _loc2_:Number = int(ypos) - int(Game.camera.y);
         var _loc3_:uint = 4294967295;
         bd.setPixel32(_loc1_,_loc2_,_loc3_);
         bd.setPixel32(_loc1_ + 1,_loc2_,_loc3_);
         bd.setPixel32(_loc1_ - 1,_loc2_,_loc3_);
         bd.setPixel32(_loc1_,_loc2_ + 1,_loc3_);
         bd.setPixel32(_loc1_,_loc2_ - 1,_loc3_);
      }
      
      internal function UpdateWindPart() : *
      {
         var _loc1_:Number = Utils.ScaleTo(0,1,timerMax,0,timer);
         movementVec.speed = 0.5 + Ease.Power_InOut(_loc1_,2);
         xpos += movementVec.X();
         ypos += movementVec.Y();
         --timer;
         if(timer <= 0)
         {
            RemoveObject();
         }
      }
      
      internal function InitWindPart(param1:Number) : *
      {
         state = 0;
         updateFunction = this.UpdateWindPart;
         renderFunction = this.RenderWindPart;
         frame = 0;
         frameVel = 4;
         dir = param1;
         timer = timerMax = 30;
         movementVec = new Vec();
         movementVec.Set(param1,Utils.RandBetweenFloat(1,2));
      }
      
      public function OnHitPlayer(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "zombie")
         {
            onHitFunction = null;
            GameVars.playerKilled = true;
            state = 100;
         }
         if(param1.collisionType == "killzombie_all" && param1.name != "missile")
         {
            onHitFunction = null;
            GameVars.playerKilled = true;
            state = 100;
         }
      }
      
      public function RenderPlayer() : *
      {
         var _loc6_:DisplayObj = null;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:DisplayObj = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Weapon = null;
         var _loc15_:Matrix = null;
         var _loc16_:Point = null;
         var _loc1_:Number = this.aimVec.rot;
         var _loc2_:Point = this.GetPlayerPivotOffset();
         var _loc3_:Point = this.GetPlayerHeadOffset();
         if(this.displayPlayerSelector == 1)
         {
            _loc6_ = GraphicObjects.GetDisplayObjByName("PlayerSelectButton");
            RenderDispObjAt(xpos,ypos - 30,_loc6_,this.displayPlayerSelector - 1);
         }
         var _loc4_:Number = Math.PI / 2;
         if(_loc1_ >= -_loc4_ && _loc1_ <= _loc4_)
         {
            xflip = false;
            RenderDispObjAt(xpos + _loc3_.x,ypos + _loc3_.y,dobj2,0,null,_loc1_ * 0.5 + this.player_head_rot_offset);
            RenderDispObjNormally();
            RenderDispObjAt(xpos + _loc2_.x,ypos + _loc2_.y,dobj1,frame1,null,_loc1_);
         }
         else
         {
            _loc7_ = _loc1_;
            _loc7_ = _loc7_ * 0.5;
            _loc7_ = _loc7_ - Math.PI;
            if(_loc1_ > 0)
            {
               _loc7_ += _loc4_;
            }
            else
            {
               _loc7_ -= _loc4_;
            }
            _loc1_ += Math.PI;
            xflip = true;
            RenderDispObjAt(xpos + _loc3_.x,ypos + _loc3_.y,dobj2,0,null,_loc7_ + this.player_head_rot_offset);
            RenderDispObjNormally();
            RenderDispObjAt(xpos + _loc2_.x,ypos + _loc2_.y,dobj1,frame1,null,_loc1_);
         }
         var _loc5_:Boolean = true;
         if(GameVars.totalPlayers == 1 && this.ammoMax == 0)
         {
            _loc5_ = false;
         }
         if(_loc5_)
         {
            _loc8_ = "99";
            if(this.ammoMax != 0)
            {
               _loc8_ = this.ammo.toString();
            }
            _loc9_ = GraphicObjects.GetDisplayObjByName("shotMarker");
            _loc9_.origMC.ammo.text = _loc8_;
            _loc10_ = Math.round(xpos);
            _loc11_ = Math.round(ypos - 80);
            _loc10_ -= Math.round(Game.camera.x);
            _loc11_ -= Math.round(Game.camera.y);
            _loc12_ = 1;
            if(this.isActivePlayer)
            {
               _loc12_ = 0;
            }
            _loc9_.RenderAtRotScaled_Vector(_loc12_,bd,_loc10_,_loc11_,1,0);
         }
         if(this.isActivePlayer)
         {
            Game.ClearRenderBallPathParams();
            if(state == 0)
            {
               _loc13_ = false;
               _loc14_ = GameVars.GetWeapon(this.weaponName);
               if(_loc14_.isStraight)
               {
                  _loc13_ = true;
               }
               _loc15_ = new Matrix();
               _loc15_.rotate(this.aimVec.rot);
               _loc16_ = new Point(this.barrelOffset.x,this.barrelOffset.y);
               _loc16_ = _loc15_.transformPoint(_loc16_);
               Game.SetRenderBallPathParams(bd,xpos - Game.camera.x + _loc2_.x + _loc16_.x,ypos - Game.camera.y + _loc2_.y + _loc16_.y,Game.ballpath_dx,Game.ballpath_dy,_loc13_);
            }
         }
      }
      
      public function UpdatePlayer() : *
      {
         var _loc4_:Weapon = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Matrix = null;
         var _loc11_:Point = null;
         var _loc12_:Array = null;
         var _loc13_:GameObj = null;
         var _loc14_:GameObj = null;
         this.displayPlayerSelector = 0;
         var _loc1_:Point = this.GetPlayerPivotOffset();
         var _loc2_:Number = MouseControl.x + Game.camera.x;
         var _loc3_:Number = MouseControl.y + Game.camera.y;
         if(state == 0)
         {
            --this.player_head_rot_timer;
            if(this.player_head_rot_timer <= 0)
            {
               this.player_head_rot_timer = Utils.RandBetweenInt(20,40);
               this.player_head_rot_to_offset = Utils.RandBetweenFloat(-0.2,0.2);
            }
            this.player_head_rot_offset += (this.player_head_rot_to_offset - this.player_head_rot_offset) * 0.2;
            _loc4_ = GameVars.GetWeapon(this.weaponName);
            _loc5_ = xpos + _loc1_.x;
            _loc6_ = ypos + _loc1_.y;
            this.aimVec = new Vec();
            _loc7_ = _loc2_ - _loc5_;
            _loc8_ = _loc3_ - _loc6_;
            this.aimVec.SetFromDxDy(_loc7_,_loc8_);
            _loc9_ = Utils.ScaleToPreLimit(GameVars.minMissileVelocity,GameVars.maxMissileVelocity,GameVars.minFireDist,GameVars.maxFireDist,this.aimVec.speed);
            if(_loc4_.isStraight)
            {
               _loc9_ = GameVars.maxMissileVelocity;
            }
            this.aimVec.speed = _loc9_;
            if(this.isActivePlayer)
            {
               Game.ballpath_dx = this.aimVec.X();
               Game.ballpath_dy = this.aimVec.Y();
            }
            _loc10_ = new Matrix();
            _loc10_.rotate(this.aimVec.rot);
            _loc11_ = new Point(this.barrelOffset.x,this.barrelOffset.y);
            _loc11_ = _loc10_.transformPoint(_loc11_);
            if(this.isActivePlayer == false)
            {
               this.displayPlayerSelector = 2;
               if(Utils.DistBetweenPoints(xpos,ypos - 30,_loc2_,_loc3_) < 30)
               {
                  this.displayPlayerSelector = 1;
               }
            }
            else
            {
               this.displayPlayerSelector = 0;
               if(MouseControl.buttonPressed)
               {
                  MouseControl.buttonPressed = false;
                  _loc12_ = GameObjects.GetGameObjListByName("player");
                  for each(_loc13_ in _loc12_)
                  {
                     if(_loc13_.isActivePlayer == false)
                     {
                        if(_loc13_.listIndex != listIndex)
                        {
                           if(Utils.DistBetweenPoints(_loc13_.xpos,_loc13_.ypos - 30,_loc2_,_loc3_) < 30)
                           {
                              Game.SetActivePlayer(_loc13_);
                              return;
                           }
                        }
                     }
                  }
                  if(this.weaponTimer == 0)
                  {
                     if(this.ammoMax == 0 || this.ammo > 0)
                     {
                        if(this.ammoMax != 0)
                        {
                           --this.ammo;
                        }
                        _loc14_ = PhysicsBase.AddPhysObjAt(_loc4_.objName,xpos + _loc1_.x + _loc11_.x,ypos + _loc1_.y + _loc11_.y,0,1);
                        this.aimVec.speed *= _loc14_.GetBodyMass(0);
                        _loc14_.ApplyImpulse(this.aimVec.X(),this.aimVec.Y());
                        this.weaponTimer = _loc4_.fireRate;
                        frame1 = 0;
                        frameVel1 = 1;
                        state = 1;
                        this.player_head_rot_offset = 0.4;
                        this.player_head_rot_to_offset = 0;
                        this.player_head_rot_timer = Utils.RandBetweenInt(20,40);
                        ++GameVars.numShotsFired;
                        Game.DecreaseShotBonus();
                     }
                  }
               }
            }
         }
         else if(state == 1)
         {
            if(PlayAnimation1())
            {
               state = 0;
               frame1 = 0;
            }
            this.player_head_rot_offset += (this.player_head_rot_to_offset - this.player_head_rot_offset) * 0.1;
         }
         else if(state == 100)
         {
            this.ZombieCreateBlood();
            this.PlayerGenerateLimbs();
            visible = false;
            state = 101;
         }
         --this.weaponTimer;
         if(this.weaponTimer <= 0)
         {
            this.weaponTimer = 0;
         }
      }
      
      internal function GetPlayerPivotOffset() : Point
      {
         var _loc1_:Matrix = new Matrix();
         _loc1_.rotate(dir);
         return _loc1_.transformPoint(this.absolutePivotOffset);
      }
      
      internal function GetPlayerHeadOffset() : Point
      {
         var _loc1_:Matrix = new Matrix();
         _loc1_.rotate(dir);
         return _loc1_.transformPoint(this.absoluteHeadOffset);
      }
      
      public function InitPlayer() : *
      {
         ++GameVars.totalPlayers;
         this.zombie_headIndex = 1;
         this.zombie_bodyIndex = 1;
         this.zombie_legIndex = 1;
         this.player_head_rot_offset = 0;
         this.player_head_rot_to_offset = 0;
         this.player_head_rot_timer = 0;
         name = "player";
         updateFunction = this.UpdatePlayer;
         onHitFunction = this.OnHitPlayer;
         renderFunction = this.RenderPlayer;
         frame1 = 0;
         this.displayPlayerSelector = 0;
         Utils.GetParams(initParams);
         this.ammo = this.ammoMax = Utils.GetParamInt("player_ammo",0);
         dobj1 = GraphicObjects.GetDisplayObjByName("bazTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("bazHead");
         Game.SetActivePlayer(this);
         this.weaponTimer = 0;
      }
      
      public function InitPlayer_BarryZooka() : *
      {
         this.InitPlayer();
         dobj1 = GraphicObjects.GetDisplayObjByName("bazTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("bazHead");
         this.weaponName = "Bazooka";
         this.deathLimbArray = GameVars.playerLimbObjects_baz;
      }
      
      public function InitPlayer_CustardPie() : *
      {
         this.InitPlayer();
         dobj1 = GraphicObjects.GetDisplayObjByName("custardpieTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("custardpieHead");
         this.weaponName = "Limpet";
         this.deathLimbArray = GameVars.playerLimbObjects_custard;
      }
      
      public function InitPlayer_HumanCannonball() : *
      {
         this.InitPlayer();
         dobj1 = GraphicObjects.GetDisplayObjByName("humanCannonballTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("humanCannonballHead");
         this.weaponName = "Cannonball";
         this.deathLimbArray = GameVars.playerLimbObjects_cannonball;
      }
      
      public function InitPlayer_MrNuke() : *
      {
         this.InitPlayer();
         dobj1 = GraphicObjects.GetDisplayObjByName("mrNukeTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("mrNukeHead");
         this.weaponName = "Explosive";
         this.deathLimbArray = GameVars.playerLimbObjects_nuke;
      }
      
      public function InitPlayer_FlameEater() : *
      {
         this.InitPlayer();
         dobj1 = GraphicObjects.GetDisplayObjByName("flameEaterTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("flameEaterHead");
         this.weaponName = "Fireball";
         this.deathLimbArray = GameVars.playerLimbObjects_flameEater;
      }
      
      public function InitPlayer_ElephantStrike() : *
      {
         this.InitPlayer();
         dobj1 = GraphicObjects.GetDisplayObjByName("lionTamerTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("lionTamerHead");
         this.weaponName = "Elestrike";
         this.deathLimbArray = GameVars.playerLimbObjects_lionTamer;
      }
      
      public function InitPlayer_Major() : *
      {
         this.InitPlayer();
         dobj1 = GraphicObjects.GetDisplayObjByName("majorTop");
         dobj2 = GraphicObjects.GetDisplayObjByName("majorHead");
         this.weaponName = "RailGun";
         this.deathLimbArray = GameVars.playerLimbObjects_major;
      }
      
      internal function MissileGenerateTrail() : *
      {
         var _loc1_:Particle = null;
         if(this.trailName != "")
         {
            _loc1_ = Particles.Add(xpos,ypos);
            if(this.trailName == "fx_railpuff")
            {
               _loc1_.InitSmoke(this.trailName);
               _loc1_.angle = dir;
               _loc1_.xvel = 0;
               _loc1_.yvel = 0;
            }
            else
            {
               _loc1_.InitSmoke(this.trailName);
            }
         }
      }
      
      internal function MissileRotateToMovement() : *
      {
         var _loc1_:Number = xpos - oldxpos;
         var _loc2_:Number = ypos - oldypos;
         dir = Math.atan2(_loc2_,_loc1_);
      }
      
      public function OnHitMissileSticky(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.hitShape.IsSensor())
         {
            return;
         }
         if(state == 0)
         {
            if(this.attachment_AttachFlag == 0)
            {
               this.attachment_AttachFlag = 1;
               this.attachment_AttachPoint.x = hitContactPoint.position.x;
               this.attachment_AttachPoint.y = hitContactPoint.position.y;
               this.attachment_AttachObject = param1;
               state = 1;
               SoundPlayer.Play("sfx_pie_hit");
            }
         }
      }
      
      internal function InitAttachment() : *
      {
         this.attachment_AttachFlag = 0;
         this.attachment_AttachPoint = new Point(0,0);
      }
      
      internal function UnattachAttachement() : *
      {
         if(this.attachment_AttachJoint != null)
         {
            PhysicsBase.world.DestroyJoint(this.attachment_AttachJoint);
            this.attachment_AttachJoint = null;
            this.attachment_AttachFlag = 0;
         }
      }
      
      public function Limpet_Explode() : *
      {
         if(state < 50)
         {
            state = 50;
         }
      }
      
      public function UpdateMissileSticky() : *
      {
         var _loc2_:GameObj = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:b2Body = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:b2RevoluteJointDef = null;
         var _loc10_:Point = null;
         var _loc1_:b2Vec2 = GetBodyWorldPosWorldCoords(0);
         if(state == 0)
         {
            this.MissileGenerateTrail();
            this.MissileRotateToMovement();
            --timer;
            if(timer <= 0)
            {
               state = 100;
            }
         }
         else if(state == 1)
         {
            SetBodyAngularVelocity(0,0);
            SetBodyLinearVelocity(0,0,0);
         }
         else if(state == 50)
         {
            if(this.attachment_AttachJoint != null)
            {
               PhysicsBase.world.DestroyJoint(this.attachment_AttachJoint);
               this.attachment_AttachJoint = null;
            }
            Game.DoCustardExplosionFromThisObject(this,GameVars.custardPieHPmin,GameVars.custardPieHPmax,GameVars.custardPieForce,GameVars.custardPieRadius);
            RemoveObject(RemovePhysObj);
            _loc2_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
            _loc2_.InitMissileExplosion();
            SoundPlayer.Play("sfx_pie_explode");
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
         }
         if(this.attachment_AttachFlag == 1)
         {
            this.attachment_AttachFlag = 2;
            _loc3_ = this.attachment_AttachPoint.x * PhysicsBase.p2w;
            _loc4_ = this.attachment_AttachPoint.y * PhysicsBase.p2w;
            _loc5_ = Math.atan2(_loc1_.y - _loc4_,_loc1_.x - _loc3_);
            _loc5_ = _loc5_ + Math.PI * 0.5;
            SetBodyAngle(0,_loc5_);
            _loc6_ = bodies[0];
            _loc6_.SetAngularVelocity(0);
            _loc7_ = bodies[0];
            _loc8_ = this.attachment_AttachObject.bodies[0];
            if(this.attachment_AttachObject == null)
            {
               _loc8_ = PhysicsBase.groundBody;
            }
            _loc9_ = new b2RevoluteJointDef();
            _loc10_ = new Point(this.attachment_AttachPoint.x,this.attachment_AttachPoint.y);
            _loc9_.Initialize(_loc7_,_loc8_,new b2Vec2(_loc10_.x,_loc10_.y));
            _loc9_.enableLimit = true;
            _loc9_.lowerAngle = 0;
            _loc9_.upperAngle = 0;
            _loc9_.enableMotor = false;
            _loc9_.motorSpeed = 0;
            _loc9_.maxMotorTorque = 0;
            _loc9_.collideConnected = true;
            this.attachment_AttachJoint = PhysicsBase.world.CreateJoint(_loc9_);
            state = 1;
            SetBodyCollisionMask(0,0);
            return;
         }
      }
      
      public function InitMissileSticky() : *
      {
         this.trailName = "fx_custardpuff";
         health = 35;
         name = "limpet";
         timer = GameVars.missile_time;
         updateFunction = this.UpdateMissileSticky;
         onHitFunction = this.OnHitMissileSticky;
         SoundPlayer.Play("sfx_pie_fire");
         this.InitAttachment();
      }
      
      public function OnHitMissileCannonball(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.hitShape.IsSensor())
         {
            return;
         }
      }
      
      public function UpdateMissileCannonball() : *
      {
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               state = 100;
            }
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
         }
      }
      
      public function InitMissileCannonball() : *
      {
         this.trailName = "";
         health = 0;
         name = "missile";
         collisionType = "killzombie";
         timer = GameVars.missile_time;
         updateFunction = this.UpdateMissileCannonball;
         onHitFunction = this.OnHitMissileCannonball;
         SoundPlayer.Play("sfx_cannon_fire");
      }
      
      public function OnHitMissileExplosive(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(state != 0)
         {
            return;
         }
         if(param1.hitShape.IsSensor())
         {
            return;
         }
      }
      
      public function UpdateMissileExplosive() : *
      {
         var _loc1_:GameObj = null;
         if(state == 0)
         {
            this.MissileGenerateTrail();
            this.MissileRotateToMovement();
            --timer;
            if(timer <= 0)
            {
               state = 50;
            }
         }
         else if(state == 50)
         {
            Game.DoExplosionFromThisObject(this,GameVars.nukeHPmin,GameVars.nukeHPmax,GameVars.nukeForce,GameVars.nukeRadius);
            RemoveObject(RemovePhysObj);
            _loc1_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
            _loc1_.InitMushromCloudExplosion();
            _loc1_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
            _loc1_.InitShockwaveExplosion();
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
         }
      }
      
      public function InitMissileExplosive() : *
      {
         this.trailName = "fx_smokepuff";
         name = "missile";
         timer = GameVars.missile_time;
         updateFunction = this.UpdateMissileExplosive;
         onHitFunction = this.OnHitMissileExplosive;
         SoundPlayer.PlayRandomBetween("sfx_bazookafire","sfx_bazookafire_03");
      }
      
      public function OnHitMissileFlame(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.hitShape.IsSensor())
         {
            return;
         }
         if(state < 100)
         {
            state = 100;
         }
      }
      
      public function UpdateMissileFlame() : *
      {
         if(state == 0)
         {
            this.MissileGenerateTrail();
            this.MissileRotateToMovement();
            --timer;
            if(timer <= 0)
            {
               state = 100;
            }
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
         }
      }
      
      public function InitMissileFlame() : *
      {
         this.trailName = "fx_firepuff";
         health = 0;
         name = "missileflame";
         timer = GameVars.missile_time;
         updateFunction = this.UpdateMissileFlame;
         onHitFunction = this.OnHitMissileFlame;
         SoundPlayer.Play("sfx_fire_bullet");
      }
      
      public function OnHitMissileAirStrike(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
      }
      
      public function UpdateMissileAirStrike() : *
      {
         var _loc1_:GameObj = null;
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               state = 1;
               timer = Defs.fps * 2;
               SoundPlayer.Play("sfx_elephant");
            }
         }
         else if(state == 1)
         {
            --timer1;
            if(timer1 <= 0)
            {
               _loc1_ = PhysicsBase.AddPhysObjAt("missile_airstrike_object",xpos,ypos - 600,0,1);
               _loc1_.ApplyImpulse(0,GameVars.airstrike_initialYVel);
               _loc1_ = GameObjects.AddObj(xpos,ypos,zpos);
               _loc1_.InitAirstrikeMarker();
               timer1 = 6;
            }
            --timer;
            if(timer <= 0)
            {
               state = 100;
            }
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
         }
      }
      
      public function InitMissileAirStrike() : *
      {
         this.trailName = "fx_smokepuff";
         health = 0;
         name = "airstrike_target";
         timer = 10;
         updateFunction = this.UpdateMissileAirStrike;
         onHitFunction = this.OnHitMissileAirStrike;
      }
      
      public function OnHitMissileRailGun(param1:GameObj) : *
      {
         if(param1 == null)
         {
            SoundPlayer.Play("sfx_rocketbounce");
            return;
         }
         if(param1.hitShape.IsSensor())
         {
            return;
         }
         if(param1.name != "zombie")
         {
            return;
         }
         if(state < 100)
         {
            state = 100;
         }
      }
      
      public function UpdateMissileRailGun() : *
      {
         var _loc1_:GameObj = null;
         if(state == 0)
         {
            this.MissileRotateToMovement();
            this.MissileGenerateTrail();
            ApplyForce(0,-PhysicsBase.physGravity * PhysicsBase.w2p);
            ApplyForce(0,-PhysicsBase.physGravity * PhysicsBase.w2p);
            --timer;
            if(timer <= 0)
            {
               state = 100;
            }
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
            _loc1_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
            _loc1_.InitMissileExplosion();
         }
      }
      
      public function InitMissileRailGun() : *
      {
         this.trailName = "fx_railpuff";
         health = 100;
         name = "missile";
         collisionType = "killzombie_all";
         updateFunction = this.UpdateMissileRailGun;
         onHitFunction = this.OnHitMissileRailGun;
         timer = GameVars.missile_time;
         SoundPlayer.Play("sfx_rail_gun");
      }
      
      public function OnHitMissileNormal(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.hitShape.IsSensor())
         {
            return;
         }
         onHitFunction = null;
         state = 100;
         timer = 2;
      }
      
      public function UpdateMissileNormal() : *
      {
         var _loc1_:GameObj = null;
         if(state == 0)
         {
            this.MissileGenerateTrail();
            this.MissileRotateToMovement();
            --timer;
            if(timer <= 0)
            {
               state = 100;
            }
         }
         else if(state == 100)
         {
            --timer;
            if(timer <= 0)
            {
               RemoveObject(RemovePhysObj);
               _loc1_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
               _loc1_.InitMissileExplosion();
            }
         }
      }
      
      public function InitMissileNormal() : *
      {
         this.trailName = "fx_smokepuff";
         health = 35;
         name = "missile";
         collisionType = "killzombie";
         timer = GameVars.missile_time;
         singleHitResponse = true;
         updateFunction = this.UpdateMissileNormal;
         onHitFunction = this.OnHitMissileNormal;
         SoundPlayer.PlayRandomBetween("sfx_bazookafire","sfx_bazookafire_03");
      }
      
      public function OnHitMissileAirStrikeObject(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(state > 100)
         {
            return;
         }
         state = 100;
         onHitFunction = null;
      }
      
      public function UpdateMissileAirStrikeObject() : *
      {
         var _loc1_:GameObj = null;
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               state = 100;
            }
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
            _loc1_ = GameObjects.AddObj(xpos,ypos,-5000);
            _loc1_.InitMushromCloudExplosion();
         }
         else if(state == 101)
         {
            if(xvel > 0)
            {
               dir += Utils.DegToRad(10);
               if(dir >= Math.PI)
               {
                  dir = Math.PI;
               }
            }
            if(xvel < 0)
            {
               dir += Utils.DegToRad(-10);
               if(dir <= -Math.PI)
               {
                  dir = -Math.PI;
               }
            }
            yvel += 1;
            ypos += yvel;
            xpos += xvel;
            --timer;
            if(timer <= 0)
            {
               RemoveObject();
            }
         }
      }
      
      public function InitMissileAirStrikeObject() : *
      {
         this.trailName = "";
         collisionType = "killzombie_all";
         scoreType = "elephant";
         health = 100;
         updateFunction = this.UpdateMissileAirStrikeObject;
         onHitFunction = this.OnHitMissileAirStrikeObject;
         timer = 100;
      }
      
      internal function Zombie_AddHealth(param1:Number, param2:String) : *
      {
         var _loc3_:scoreData = null;
         if(health <= 0)
         {
            return;
         }
         health += param1;
         if(param1 != 0)
         {
            this.ShowHealthBar();
         }
         if(health <= 0)
         {
            state = 100;
            _loc3_ = GameVars.GetScoreData(param2);
            this.AddScore(_loc3_);
         }
      }
      
      public function OnHitPersistZombie(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(state == 13 || state == 23)
         {
            return;
         }
         if(param1.singleHitResponse == true)
         {
            return;
         }
         this.OnHitZombie_Inner(param1,true);
      }
      
      public function OnHitZombie(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(state == 13 || state == 23)
         {
            return;
         }
         this.OnHitZombie_Inner(param1,false);
      }
      
      internal function OnHitExplosion_Zombie(param1:GameObj, param2:Number) : *
      {
         this.Zombie_MakeNonWalker(true);
         this.Zombie_AddHealth(-param2,"explosion");
      }
      
      public function OnHitZombie_Inner(param1:GameObj, param2:Boolean) : *
      {
         var _loc3_:Number = NaN;
         if(param2)
         {
            if(param1.hit_sfx_name != "")
            {
               SoundPlayer.Play(param1.hit_sfx_name);
            }
         }
         if(param1.name == "cannon")
         {
            this.Zombie_EnterCannon(param1);
         }
         if(param1.name == "zombiestopwalk")
         {
            this.Zombie_MakeNonWalker();
         }
         if(param1.name == "zombieturnaround")
         {
            this.Zombie_TurnAround();
         }
         if(param1.name == "zombie")
         {
            if(param1.Zombie_IsOnFire())
            {
               this.Zombie_StartFire();
            }
         }
         if(param1.name == "missileflame")
         {
            this.Zombie_StartFire();
         }
         if(param1.collisionType == "killzombie")
         {
            this.Zombie_MakeNonWalker();
            if(this.isSuperZombie == false)
            {
               _loc3_ = param1.health;
               if(param1.collisionExtra == "cut")
               {
                  this.Zombie_GenerateBloodSplat(param1.hitContactPoint);
                  this.Zombie_AddHealth(-_loc3_,param1.scoreType);
               }
               else if(param1.collisionExtra == "cutspray")
               {
                  this.Zombie_GenerateBloodSplat_Spray(param1.hitContactPoint);
                  this.Zombie_AddHealth(-_loc3_,param1.scoreType);
               }
               else if(param1.collisionExtra == "flame")
               {
                  this.Zombie_StartFire();
               }
               else if(param1.collisionExtra == "electric")
               {
                  this.Zombie_StartElectric();
               }
               else if(param1.hitShapeName == "head")
               {
                  _loc3_ *= 3;
                  if(param1.scoreType != "normal" && param1.scoreType != "")
                  {
                     this.Zombie_AddHealth(-_loc3_,param1.scoreType);
                  }
                  else
                  {
                     this.Zombie_AddHealth(-_loc3_,"headshot");
                  }
               }
               else
               {
                  this.Zombie_AddHealth(-_loc3_,param1.scoreType);
               }
            }
         }
         if(param1.collisionType == "killzombie_all")
         {
            this.Zombie_MakeNonWalker();
            _loc3_ = param1.health;
            if(param1.collisionExtra == "cut")
            {
               this.Zombie_GenerateBloodSplat(param1.hitContactPoint);
               this.Zombie_AddHealth(-_loc3_,param1.scoreType);
            }
            else if(param1.collisionExtra == "cutspray")
            {
               this.Zombie_GenerateBloodSplat_Spray(param1.hitContactPoint);
               this.Zombie_AddHealth(-_loc3_,param1.scoreType);
            }
            else if(param1.collisionExtra == "flame")
            {
               this.Zombie_StartFire();
            }
            else if(param1.collisionExtra == "electric")
            {
               this.Zombie_StartElectric();
            }
            else if(param1.hitShapeName == "head")
            {
               _loc3_ *= 3;
               if(param1.scoreType != "normal" && param1.scoreType != "")
               {
                  this.Zombie_AddHealth(-_loc3_,param1.scoreType);
               }
               else
               {
                  this.Zombie_AddHealth(-_loc3_,"headshot");
               }
            }
            else
            {
               this.Zombie_AddHealth(-_loc3_,param1.scoreType);
            }
         }
      }
      
      internal function Zombie_GenerateBloodSplatParticles(param1:b2ContactPoint) : *
      {
         var _loc4_:Particle = null;
         var _loc2_:int = Utils.RandBetweenInt(3,6);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = Particles.Add(param1.position.x * PhysicsBase.p2w,param1.position.y * PhysicsBase.p2w);
            _loc4_.InitBloodSplat();
            _loc3_++;
         }
      }
      
      internal function Zombie_GenerateBloodSplat(param1:b2ContactPoint) : *
      {
         var _loc2_:GameObj = GameObjects.AddObj(param1.position.x * PhysicsBase.p2w,param1.position.y * PhysicsBase.p2w,-3000);
         _loc2_.InitBloodSplat();
      }
      
      internal function Zombie_GenerateBloodSplat_Spray(param1:b2ContactPoint) : *
      {
         var _loc2_:GameObj = GameObjects.AddObj(param1.position.x * PhysicsBase.p2w,param1.position.y * PhysicsBase.p2w,-3000);
         _loc2_.InitBloodSplat(Utils.RandCircle(),Utils.RandBetweenFloat(3,5));
      }
      
      internal function Zombie_IsElectric() : Boolean
      {
         return this.zombie_electricTimer != 0;
      }
      
      internal function Zombie_ClearElectric() : *
      {
         this.zombie_electricDisplayFlag = false;
         this.zombie_electricTimer = 0;
      }
      
      internal function Zombie_StartElectric() : *
      {
         if(this.zombie_electricTimer == 0)
         {
            this.zombie_electricTimer = 5;
         }
      }
      
      internal function Zombie_UpdateElectric() : *
      {
         this.zombie_electricDisplayFlag = false;
         --this.zombie_electricTimer;
         if(this.zombie_electricTimer <= 0)
         {
            this.zombie_electricDisplayFlag = false;
            this.zombie_electricTimer = 0;
            return;
         }
         if(Utils.RandBetweenInt(0,4) < 2)
         {
            this.zombie_electricDisplayFlag = true;
         }
         this.Zombie_AddHealth(-1,"electric");
      }
      
      internal function Zombie_IsOnFire() : Boolean
      {
         return this.zombie_fireTimer != 0;
      }
      
      internal function Zombie_ClearFire() : *
      {
         this.zombie_fireTimer = 0;
      }
      
      internal function Zombie_StartFire() : *
      {
         if(this.zombie_fireTimer == 0)
         {
            this.zombie_fireTimer = 1;
         }
      }
      
      internal function Zombie_UpdateFire() : *
      {
         var _loc1_:Point = null;
         var _loc2_:Matrix = null;
         var _loc3_:GameObj = null;
         if(this.zombie_fireTimer == 0)
         {
            Game.flameActive1 = false;
            return;
         }
         Game.flameActive1 = true;
         ++this.zombie_fireTimer;
         this.Zombie_AddHealth(-0.5,"fire");
         if(this.zombie_fireTimer >= 2)
         {
            _loc1_ = new Point(Utils.RandBetweenFloat(-8,8),Utils.RandBetweenFloat(-60,0));
            _loc2_ = new Matrix();
            _loc2_.rotate(dir);
            _loc1_ = _loc2_.transformPoint(_loc1_);
            this.zombie_fireTimer = 1;
            _loc3_ = GameObjects.AddObj(xpos + _loc1_.x,ypos + _loc1_.y,zpos - 100);
            _loc3_.InitZombieFlame();
         }
      }
      
      internal function ZombieCreateBlood() : *
      {
         var _loc1_:Particle = null;
         var _loc4_:int = 0;
         SoundPlayer.Play("sfx_explode_zombie");
         var _loc2_:Matrix = new Matrix();
         _loc2_.rotate(dir);
         var _loc3_:Point = new Point(0,0);
         if(Levels.currentIndex == 40)
         {
            _loc4_ = 0;
            while(_loc4_ < 10)
            {
               _loc3_.x = Utils.RandBetweenFloat(-10,-10);
               _loc3_.y = -Utils.RandBetweenFloat(0,70);
               _loc3_ = _loc2_.transformPoint(_loc3_);
               _loc1_ = Particles.Add(xpos + _loc3_.x,ypos + _loc3_.y);
               _loc1_.InitBloodSplat();
               _loc4_++;
            }
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < 15)
         {
            _loc3_.x = Utils.RandBetweenFloat(-10,-10);
            _loc3_.y = -Utils.RandBetweenFloat(0,70);
            _loc3_ = _loc2_.transformPoint(_loc3_);
            _loc1_ = Particles.Add(xpos + _loc3_.x,ypos + _loc3_.y);
            _loc1_.InitBloodSplat();
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 5)
         {
            _loc3_.x = Utils.RandBetweenFloat(-10,-10);
            _loc3_.y = -Utils.RandBetweenFloat(0,70);
            _loc3_ = _loc2_.transformPoint(_loc3_);
            _loc1_ = Particles.Add(xpos + _loc3_.x,ypos + _loc3_.y);
            _loc1_.InitGibs();
            _loc4_++;
         }
      }
      
      internal function ZombieGenerateLimbs() : *
      {
         var _loc1_:Array = GameVars.zombieLimbOffsets;
         var _loc2_:Array = GameVars.zombieLimbObjects;
         var _loc3_:Array = GameVars.zombieLimbSets;
         this.GenerateLimbsInner(_loc1_,_loc2_,_loc3_);
      }
      
      internal function HumanGenerateLimbs() : *
      {
         var _loc1_:Array = GameVars.humanLimbOffsets;
         var _loc2_:Array = GameVars.humanLimbObjects;
         var _loc3_:Array = GameVars.zombieLimbSets;
         this.GenerateLimbsInner(_loc1_,_loc2_,_loc3_);
      }
      
      internal function PlayerGenerateLimbs() : *
      {
         var _loc1_:Array = GameVars.playerLimbOffsets;
         var _loc2_:Array = this.deathLimbArray;
         var _loc3_:Array = GameVars.zombieLimbSets;
         this.GenerateLimbsInner(_loc1_,_loc2_,_loc3_);
      }
      
      internal function GenerateLimbsInner(param1:Array, param2:Array, param3:Array) : *
      {
         var _loc10_:Point = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:GameObj = null;
         var _loc4_:int = int(param1.length);
         var _loc5_:Number = xpos;
         var _loc6_:Number = ypos;
         var _loc7_:Matrix = new Matrix();
         _loc7_.rotate(dir);
         var _loc8_:Point = new Point(0,-40);
         _loc8_ = _loc7_.transformPoint(_loc8_);
         _loc8_.x += _loc5_;
         _loc8_.y += _loc6_;
         var _loc9_:int = 0;
         while(_loc9_ < _loc4_)
         {
            _loc10_ = param1[_loc9_].clone();
            _loc10_.y -= 38;
            _loc10_ = _loc7_.transformPoint(_loc10_);
            _loc11_ = _loc10_.x + _loc5_;
            _loc12_ = _loc10_.y + _loc6_;
            _loc13_ = GameObjects.AddObj(_loc11_,_loc12_,zpos - 1);
            _loc13_.InitLimb(param2[_loc9_],param3[_loc9_],dir,this,_loc8_);
            _loc9_++;
         }
      }
      
      public function RenderZombie() : *
      {
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:Number = scale;
         var _loc2_:int = frame;
         var _loc3_:Number = Math.round(xpos);
         var _loc4_:Number = Math.round(ypos);
         _loc3_ -= Math.round(Game.camera.x);
         _loc4_ -= Math.round(Game.camera.y);
         scale = 1;
         if(this.zombie_electricDisplayFlag)
         {
            _loc7_ = dobj.origMC;
            _loc7_.armTR.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.armBR.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.body.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.head.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.armTL.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.armBL.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.legTR.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.legBR.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.legTL.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc7_.legBL.gotoAndStop(GameVars.ZT_ELECTROCUTED);
            _loc8_ = dobj.GetFrameIndexLabel("electric");
            _loc9_ = dobj.GetFrameIndexLabel("electric_end");
            _loc2_ = Utils.RandBetweenInt(_loc8_,_loc9_);
            dobj.RenderAtRotScaled_Vector(_loc2_,bd,_loc3_,_loc4_,1,dir,null,false,xflip);
         }
         else if(this.Zombie_IsOnFire())
         {
            _loc7_ = dobj.origMC;
            _loc8_ = dobj.GetFrameIndexLabel("electric");
            _loc9_ = dobj.GetFrameIndexLabel("electric_end");
            _loc2_ = Utils.RandBetweenInt(_loc8_,_loc9_);
            dobj.RenderAtRotScaled_Vector(_loc2_,bd,_loc3_,_loc4_,1,dir,null,false,xflip);
         }
         else
         {
            if(dobj.frames[_loc2_].bitmapData == null)
            {
               this.Zombie_CreateFrameBitmap();
            }
            RenderDispObjNormally();
         }
         var _loc5_:Matrix = new Matrix();
         _loc5_.rotate(dir);
         var _loc6_:Point = new Point(0,-40);
         _loc6_ = _loc5_.transformPoint(_loc6_);
         this.RenderHealthBar(_loc6_.x,_loc6_.y - 40);
      }
      
      internal function DoMakeZombieNonWalker() : *
      {
         var _loc4_:GameObj = null;
         var _loc1_:b2Body = bodies[0];
         _loc1_.SetUpright(false);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = false;
         this.zombieMakeNonWalker = false;
         if(state == 21 || state == 11)
         {
            _loc4_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
            _loc4_.InitSeparateUnicycle();
         }
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(state == 20 || state == 10)
         {
            _loc2_ = true;
         }
         if(state == 21 || state == 11)
         {
            _loc3_ = true;
         }
         if(state <= 21)
         {
            state = 0;
            timer = 0;
         }
         this.SetZombieIdle();
         if(_loc3_)
         {
            this.RemoveWalkerWheels();
            this.ChangeShapes();
         }
         if(_loc2_)
         {
            this.RemoveWalkerWheels();
            this.ChangeShapes1();
         }
      }
      
      internal function RemoveWalkerWheels() : *
      {
         var _loc2_:b2Shape = null;
         var _loc3_:b2FilterData = null;
         var _loc5_:int = 0;
         var _loc1_:b2Body = bodies[0];
         var _loc4_:Array = new Array();
         _loc2_ = _loc1_.GetShapeList();
         while(_loc2_)
         {
            _loc5_ = _loc2_.GetType();
            if(_loc5_ == b2Shape.e_circleShape)
            {
               _loc4_.push(_loc2_);
            }
            _loc2_ = _loc2_.GetNext();
         }
         for each(_loc2_ in _loc4_)
         {
            _loc1_.DestroyShape(_loc2_);
         }
      }
      
      internal function ChangeShapes() : *
      {
         var _loc2_:b2Shape = null;
         var _loc3_:b2FilterData = null;
         var _loc1_:b2Body = bodies[0];
         var _loc4_:PhysObj_Material = Game.GetPhysMaterialByName("average");
         var _loc5_:PhysObj_Material = Game.GetPhysMaterialByName("nonexistant");
         _loc2_ = _loc1_.GetShapeList();
         while(_loc2_)
         {
            _loc3_ = _loc2_.GetFilterData();
            if(_loc3_.maskBits == 0)
            {
               _loc3_.maskBits = 15;
               _loc2_.m_friction = _loc4_.friction;
               _loc2_.m_restitution = _loc4_.restitution;
               _loc2_.m_density = _loc4_.density;
            }
            else
            {
               _loc3_.maskBits = 0;
               _loc2_.m_friction = _loc5_.friction;
               _loc2_.m_restitution = _loc5_.restitution;
               _loc2_.m_density = _loc5_.density;
            }
            _loc2_.SetFilterData(_loc3_);
            PhysicsBase.world.Refilter(_loc2_);
            _loc2_ = _loc2_.GetNext();
         }
      }
      
      internal function ChangeShapes1() : *
      {
         var _loc2_:b2Shape = null;
         var _loc3_:b2FilterData = null;
         var _loc1_:b2Body = bodies[0];
         var _loc4_:PhysObj_Material = Game.GetPhysMaterialByName("average");
         var _loc5_:PhysObj_Material = Game.GetPhysMaterialByName("nonexistant");
         _loc2_ = _loc1_.GetShapeList();
         while(_loc2_)
         {
            _loc3_ = _loc2_.GetFilterData();
            if(_loc3_.maskBits == 0)
            {
               _loc3_.maskBits = 15;
               _loc2_.m_friction = _loc4_.friction;
               _loc2_.m_restitution = _loc4_.restitution;
               _loc2_.m_density = _loc4_.density;
               _loc2_.SetFilterData(_loc3_);
            }
            PhysicsBase.world.Refilter(_loc2_);
            _loc2_ = _loc2_.GetNext();
         }
      }
      
      public function ZombieFallerClicked() : *
      {
         if(state == 90)
         {
            state = 100;
         }
      }
      
      public function UpdateZombie() : *
      {
         var _loc1_:GameObj = null;
         var _loc2_:Boolean = false;
         var _loc3_:b2Body = null;
         if(this.zombieTurnAroundTimer > 0)
         {
            --this.zombieTurnAroundTimer;
         }
         if(healthBarTimer > 0)
         {
            --healthBarTimer;
         }
         this.Zombie_UpdateFire();
         this.Zombie_UpdateElectric();
         if(this.zombieMakeNonWalker)
         {
            this.DoMakeZombieNonWalker();
         }
         if(state == 0)
         {
            _loc1_ = Game.GetActivePlayer();
            xflip = false;
            if(_loc1_.xpos > xpos)
            {
               xflip = true;
            }
            _loc2_ = CycleAnimationEx();
            if(_loc2_ && frame == minFrame)
            {
               this.SetZombieIdle();
            }
            ++timer;
         }
         else if(state == 10)
         {
            xflip = false;
            ApplyForce(-2,0);
            this.LimitXVelocity(0.25);
            CycleAnimationEx();
         }
         else if(state == 11)
         {
            xflip = false;
            ApplyForce(-3,0);
            this.LimitXVelocity(0.45);
            CycleAnimationEx();
         }
         else if(state == 12)
         {
            xflip = false;
            if(PlayAnimationEx())
            {
               state = 10;
               SetBodyCollisionMask(0,15);
               SetBodyFixed(0,false);
               _loc3_ = bodies[0];
               _loc3_.SetUpright(true);
               _loc3_.SetMassFromShapes();
               this.isZombieWalker = true;
               SetAnimRangeSingle("walk");
            }
         }
         else if(state == 13)
         {
            visible = true;
            xflip = false;
            if(PlayAnimationEx())
            {
               state = 11;
               SetBodyFixed(0,false);
               _loc3_ = bodies[0];
               _loc3_.SetUpright(true);
               _loc3_.SetMassFromShapes();
               this.isZombieWalker = true;
               SetAnimRangeSingle("uni");
            }
         }
         else if(state == 20)
         {
            xflip = true;
            ApplyForce(2,0);
            this.LimitXVelocity(0.25);
            CycleAnimationEx();
         }
         else if(state == 21)
         {
            xflip = true;
            ApplyForce(3,0);
            this.LimitXVelocity(0.45);
            CycleAnimationEx();
         }
         else if(state == 22)
         {
            xflip = true;
            if(PlayAnimationEx())
            {
               state = 20;
               SetBodyCollisionMask(0,15);
               SetBodyFixed(0,false);
               _loc3_ = bodies[0];
               _loc3_.SetUpright(true);
               _loc3_.SetMassFromShapes();
               this.isZombieWalker = true;
               SetAnimRangeSingle("walk");
            }
         }
         else if(state == 23)
         {
            visible = true;
            if(PlayAnimationEx())
            {
               state = 21;
               SetBodyFixed(0,false);
               _loc3_ = bodies[0];
               _loc3_.SetUpright(true);
               _loc3_.SetMassFromShapes();
               this.isZombieWalker = true;
               SetAnimRangeSingle("uni");
            }
         }
         else if(state == 30)
         {
            xpos = this.cannonGO.xpos;
            ypos = this.cannonGO.ypos;
            dir = this.cannonGO.dir;
            SetXForm(xpos * PhysicsBase.w2p,ypos * PhysicsBase.w2p,dir);
            SetBodyLinearVelocity(0,0,0);
            SetBodyAngularVelocity(0,0);
            --timer;
            if(timer <= 0)
            {
               if(this.cannonGO.cannonCorked)
               {
                  state = 100;
                  this.cannonGO.CannonExplode();
               }
               else
               {
                  this.cannonGO.CannonFire();
                  this.Zombie_LaunchFromCannon();
               }
            }
            this.Zombie_MakeNonWalker();
         }
         else if(state == 90)
         {
            if(ypos > 450)
            {
               GameVars.numBonusKillStreak = 0;
               RemoveObject(RemovePhysObj);
            }
         }
         else if(state == 100)
         {
            SoundPlayer.PlayRandomBetween("sfx_zombie_01","sfx_zombie_03");
            this.ZombieCreateBlood();
            this.ZombieGenerateLimbs();
            RemoveObject(RemovePhysObj);
            ++GameVars.numZombiesKilled;
         }
      }
      
      internal function UpdateFromPhysicsFunction_DoNothing(param1:b2Body) : *
      {
      }
      
      internal function Zombie_EnterCannon(param1:GameObj) : *
      {
         if(state >= 100)
         {
            return;
         }
         if(state == 30)
         {
            return;
         }
         if(state == 0)
         {
            if(timer <= 5)
            {
               return;
            }
         }
         if(param1.cannonCorked)
         {
            return;
         }
         this.cannonGO = param1;
         state = 30;
         timer = GameVars.cannonHoldTime;
         this.cannonGO.Cannon_SetZombieInCannon();
         updateFromPhysicsFunction = this.UpdateFromPhysicsFunction_DoNothing;
         SoundPlayer.Play("sfx_cannon_load");
      }
      
      internal function Zombie_LaunchFromCannon() : *
      {
         state = 0;
         this.cannonGO.Cannon_DoLaunch();
         visible = true;
         timer = 0;
         updateFromPhysicsFunction = null;
         var _loc1_:Vec = new Vec();
         _loc1_.SetAng(dir - Math.PI * 0.5);
         _loc1_.speed = GameVars.cannonLaunchForce * GetBodyMass(0);
         ApplyImpulse(_loc1_.X(),_loc1_.Y());
         SoundPlayer.Play("sfx_cannonball_fire");
      }
      
      public function InitZombie() : *
      {
         this.isSuperZombie = false;
         this.zombieTurnAroundTimer = 0;
         this.zombieMakeNonWalker = false;
         this.isZombieWalker = false;
         health = maxHealth = 100;
         ++GameVars.totalZombies;
         name = "zombie";
         updateFunction = this.UpdateZombie;
         onHitFunction = this.OnHitZombie;
         onHitPersistFunction = this.OnHitPersistZombie;
         renderFunction = this.RenderZombie;
         onHitExplosionFunction = this.OnHitExplosion_Zombie;
         this.SetZombieIdle();
         this.Zombie_ClearFire();
         this.Zombie_ClearElectric();
      }
      
      internal function SetZombieIdle() : *
      {
         var _loc1_:String = "idle" + Utils.RandBetweenInt(1,4);
         SetAnimRangeSingle(_loc1_,true,true);
         frameVel = Utils.RandBetweenFloat(0.8,1);
      }
      
      public function InitZombie_Generic() : *
      {
         this.InitZombie();
         this.zombie_bodyIndex = Utils.RandBetweenInt(GameVars.ZT_GENERIC0,GameVars.ZT_GENERIC4);
         this.zombie_headIndex = Utils.RandBetweenInt(GameVars.ZT_GENERIC0,GameVars.ZT_GENERIC4);
         this.zombie_legIndex = Utils.RandBetweenInt(GameVars.ZT_GENERIC0,GameVars.ZT_GENERIC4);
         this.Zombie_CreateDobj();
      }
      
      public function InitZombie_Clown() : *
      {
         this.InitZombie();
         this.zombie_bodyIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.zombie_headIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.zombie_legIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.Zombie_CreateDobj();
         this.isSuperZombie = true;
      }
      
      public function InitZombie_Clown_Stilts() : *
      {
         this.InitZombie();
         this.zombie_bodyIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.zombie_headIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.zombie_legIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.Zombie_CreateDobjStilts();
         this.isSuperZombie = true;
      }
      
      public function InitZombie_RingMaster() : *
      {
         this.InitZombie();
         this.zombie_bodyIndex = GameVars.ZT_RING_MASTER;
         this.zombie_headIndex = GameVars.ZT_RING_MASTER;
         this.zombie_legIndex = GameVars.ZT_RING_MASTER;
         this.Zombie_CreateDobj();
      }
      
      public function InitZombie_StrongMan() : *
      {
         this.InitZombie();
         this.zombie_bodyIndex = GameVars.ZT_STRONG_MAN;
         this.zombie_headIndex = GameVars.ZT_STRONG_MAN;
         this.zombie_legIndex = GameVars.ZT_STRONG_MAN;
         this.Zombie_CreateDobj();
      }
      
      public function InitZombie_BeardedLady() : *
      {
         this.InitZombie();
         this.zombie_bodyIndex = GameVars.ZT_BEARDED_LADY;
         this.zombie_headIndex = GameVars.ZT_BEARDED_LADY;
         this.zombie_legIndex = GameVars.ZT_BEARDED_LADY;
         this.Zombie_CreateDobj();
      }
      
      public function InitZombie_Electrocuted() : *
      {
         this.InitZombie();
         this.zombie_bodyIndex = GameVars.ZT_ELECTROCUTED;
         this.zombie_headIndex = GameVars.ZT_ELECTROCUTED;
         this.zombie_legIndex = GameVars.ZT_ELECTROCUTED;
         this.Zombie_CreateDobj();
      }
      
      internal function Zombie_CreateFrameBitmap() : *
      {
         dobj.CreateSingleBitmapdataFrame(frame,this.Zombie_CreateDobj_CB);
      }
      
      internal function Zombie_CreateDobj_CB(param1:MovieClip) : *
      {
         param1.armTR.gotoAndStop(this.zombie_bodyIndex);
         param1.armBR.gotoAndStop(this.zombie_bodyIndex);
         param1.body.gotoAndStop(this.zombie_bodyIndex);
         param1.head.gotoAndStop(this.zombie_headIndex);
         param1.armTL.gotoAndStop(this.zombie_bodyIndex);
         param1.armBL.gotoAndStop(this.zombie_bodyIndex);
         param1.legTR.gotoAndStop(this.zombie_legIndex);
         param1.legBR.gotoAndStop(this.zombie_legIndex);
         param1.legTL.gotoAndStop(this.zombie_legIndex);
         param1.legBL.gotoAndStop(this.zombie_legIndex);
      }
      
      internal function DisposeOfZombieDobj() : *
      {
         if(this.zombieDobj == null)
         {
            return;
         }
         this.zombieDobj.DisposeOf();
         this.zombieDobj = null;
      }
      
      internal function Zombie_CreateDobj() : *
      {
         this.zombieDobj = ZombieHolder.Add(new Zombie(),"Zombie",this.Zombie_CreateDobj_CB,this.zombie_headIndex,this.zombie_bodyIndex,this.zombie_legIndex);
         dobj = this.zombieDobj;
      }
      
      internal function Zombie_CreateDobjStilts() : *
      {
         this.zombieDobj = ZombieHolder.Add(new ZombieStilts(),"ZombieStilts",this.Zombie_CreateDobj_CB,this.zombie_headIndex,this.zombie_bodyIndex,this.zombie_legIndex);
         dobj = this.zombieDobj;
      }
      
      internal function LimitVelocity(param1:Number) : *
      {
         var _loc4_:b2Vec2 = null;
         var _loc2_:b2Body = bodies[0];
         var _loc3_:b2Vec2 = _loc2_.GetLinearVelocity();
         if(_loc3_.Length() > param1)
         {
            _loc4_ = _loc3_.Copy();
            _loc4_.Normalize();
            _loc4_.Multiply(param1);
            _loc2_.SetLinearVelocity(_loc4_);
         }
      }
      
      internal function LimitXVelocity(param1:Number) : *
      {
         var _loc2_:b2Body = bodies[0];
         var _loc3_:b2Vec2 = _loc2_.GetLinearVelocity();
         if(Math.abs(_loc3_.x) > param1)
         {
            if(_loc3_.x > 0)
            {
               _loc3_.x = param1;
            }
            else
            {
               _loc3_.x = -param1;
            }
            _loc2_.SetLinearVelocity(_loc3_);
         }
      }
      
      public function InitZombieWalkLeftStilts() : *
      {
         this.InitZombie_Clown_Stilts();
         var _loc1_:b2Body = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 10;
         SetAnimRangeSingle("walk");
         frameVel = 1;
      }
      
      public function InitZombieWalkRightStilts() : *
      {
         this.InitZombie_Clown_Stilts();
         xflip = true;
         var _loc1_:b2Body = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 20;
         SetAnimRangeSingle("walk");
         frameVel = 1;
      }
      
      public function InitZombieWalkLeft() : *
      {
         var _loc1_:b2Body = null;
         this.InitZombie_Generic();
         _loc1_ = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 10;
         SetAnimRangeSingle("walk");
         frameVel = 1;
      }
      
      public function InitZombieClimbOutWalkLeft() : *
      {
         this.InitZombieWalkLeft();
         this.isZombieWalker = true;
         state = 12;
         SetAnimRangeSingle("climb");
         frameVel = 1;
         SetBodyCollisionMask(0,0);
         SetBodyFixed(0,true);
      }
      
      public function InitZombieClimbOutWalkRight() : *
      {
         this.InitZombieWalkLeft();
         this.isZombieWalker = true;
         state = 22;
         SetAnimRangeSingle("climb");
         frameVel = 1;
         SetBodyCollisionMask(0,0);
         SetBodyFixed(0,true);
      }
      
      public function InitZombieClimbOutUnicycleLeft() : *
      {
         visible = false;
         this.InitZombieUnicycleLeft();
         this.isZombieWalker = true;
         state = 13;
         SetAnimRangeSingle("climb");
         frameVel = 1;
         SetBodyFixed(0,true);
      }
      
      public function InitZombieClimbOutUnicycleRight() : *
      {
         visible = false;
         this.InitZombieWalkLeft();
         this.isZombieWalker = true;
         state = 23;
         SetAnimRangeSingle("climb");
         frameVel = 1;
         SetBodyFixed(0,true);
      }
      
      public function InitZombieWalkRight() : *
      {
         var _loc1_:b2Body = null;
         this.InitZombie_Generic();
         xflip = true;
         _loc1_ = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 20;
         SetAnimRangeSingle("walk");
         frameVel = 1;
      }
      
      public function InitZombieUnicycleLeft() : *
      {
         var _loc1_:b2Body = null;
         this.InitZombie_Clown();
         _loc1_ = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 11;
         SetAnimRangeSingle("uni");
         frameVel = 1;
      }
      
      public function InitZombieUnicycleRight() : *
      {
         var _loc1_:b2Body = null;
         this.InitZombie_Clown();
         _loc1_ = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 21;
         SetAnimRangeSingle("uni");
         frameVel = 1;
      }
      
      internal function Zombie_TurnAround() : *
      {
         var _loc1_:int = 0;
         if(this.zombieTurnAroundTimer > 0)
         {
            return;
         }
         _loc1_ = 5;
         if(state == 10)
         {
            state = 20;
            this.zombieTurnAroundTimer = _loc1_;
         }
         else if(state == 20)
         {
            state = 10;
            this.zombieTurnAroundTimer = _loc1_;
         }
         else if(state == 11)
         {
            state = 21;
            this.zombieTurnAroundTimer = _loc1_;
         }
         else if(state == 21)
         {
            state = 11;
            this.zombieTurnAroundTimer = _loc1_;
         }
      }
      
      internal function Zombie_MakeNonWalker(param1:Boolean = false) : *
      {
         if(this.isZombieWalker)
         {
            if(param1)
            {
               this.DoMakeZombieNonWalker();
            }
            else
            {
               this.zombieMakeNonWalker = true;
            }
         }
      }
      
      public function RenderZombieFaller() : *
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:MovieClip = null;
         var _loc1_:Number = scale;
         var _loc2_:int = frame;
         _loc3_ = Math.round(xpos);
         _loc4_ = Math.round(ypos);
         _loc3_ -= Math.round(Game.camera.x);
         _loc4_ -= Math.round(Game.camera.y);
         scale = 1;
         _loc5_ = dobj.origMC;
         _loc5_.armTR.gotoAndStop(this.zombie_bodyIndex);
         _loc5_.armBR.gotoAndStop(this.zombie_bodyIndex);
         _loc5_.body.gotoAndStop(this.zombie_bodyIndex);
         _loc5_.head.gotoAndStop(this.zombie_headIndex);
         _loc5_.armTL.gotoAndStop(this.zombie_bodyIndex);
         _loc5_.armBL.gotoAndStop(this.zombie_bodyIndex);
         _loc5_.legTR.gotoAndStop(this.zombie_legIndex);
         _loc5_.legBR.gotoAndStop(this.zombie_legIndex);
         _loc5_.legTL.gotoAndStop(this.zombie_legIndex);
         _loc5_.legBL.gotoAndStop(this.zombie_legIndex);
         dobj.RenderAtRotScaled_Vector(frame,bd,_loc3_,_loc4_,1,dir,null,false,xflip);
      }
      
      public function InitZombieFaller() : *
      {
         this.isSuperZombie = false;
         this.zombieTurnAroundTimer = 0;
         this.zombieMakeNonWalker = false;
         this.isZombieWalker = false;
         health = maxHealth = 100;
         ++GameVars.totalZombies;
         name = "zombie_fall";
         updateFunction = this.UpdateZombie;
         renderFunction = this.RenderZombie;
         this.SetZombieIdle();
         state = 90;
         SetBodyCollisionMask(0,0);
         this.Zombie_ClearFire();
         this.Zombie_ClearElectric();
         this.zombie_bodyIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.zombie_headIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         this.zombie_legIndex = Utils.RandBetweenInt(GameVars.ZT_CLOWN0,GameVars.ZT_CLOWN3);
         ApplyImpulse(Utils.RandBetweenFloat(-0.1,0.1),Utils.RandBetweenFloat(-0.2,0));
         SetBodyAngularVelocity(0,Utils.RandBetweenFloat_Seeded(-10,10));
         this.Zombie_CreateDobj();
      }
      
      public function RenderLimb() : *
      {
         RenderNormallyAlpha();
      }
      
      public function UpdateLimb() : *
      {
         dir += rotVel;
         yvel += GameVars.gravity_GO;
         ypos += yvel;
         xpos += xvel;
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               RemoveObject();
            }
         }
         if(timer <= 10)
         {
            alpha = Utils.ScaleTo(0,1,0,10,timer);
         }
      }
      
      public function InitLimb(param1:String, param2:int, param3:Number, param4:GameObj, param5:Point) : *
      {
         var _loc6_:Vec = null;
         updateFunction = this.UpdateLimb;
         renderFunction = this.RenderLimb;
         dobj = GraphicObjects.GetDisplayObjByName(param1);
         frame = 0;
         dir = param3;
         param5.x += Utils.RandBetweenFloat(-4,4);
         param5.y += Utils.RandBetweenFloat(-4,4);
         _loc6_ = new Vec();
         _loc6_.SetAng(Utils.RandCircle());
         _loc6_.SetFromDxDy(xpos - param5.x,ypos - param5.y);
         _loc6_.speed = Utils.RandBetweenFloat(5,10);
         xvel = _loc6_.X();
         yvel = _loc6_.Y();
         timer = Utils.RandBetweenInt(40,50);
         rotVel = Utils.RandBetweenFloat(0,0.1);
         if(Utils.RandBetweenInt(0,100) < 50)
         {
            rotVel = -rotVel;
         }
         zpos = -3000;
         if(param2 == 2)
         {
            frame = param4.zombie_headIndex - 1;
         }
         if(param2 == 0)
         {
            frame = param4.zombie_bodyIndex - 1;
         }
         if(param2 == 1)
         {
            frame = param4.zombie_legIndex - 1;
         }
      }
      
      public function OnHitCuttingDisk(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateCuttingDisk() : *
      {
         if(state == 0)
         {
            SetBodyAngularVelocity(0,this.disk_velocity);
         }
      }
      
      public function InitCuttingDisk() : *
      {
         scoreType = "cuttingdisk";
         collisionType = "killzombie_all";
         collisionExtra = "cutspray";
         health = maxHealth = 5;
         Utils.GetParams(initParams);
         this.disk_velocity = Utils.GetParamNumber("disk_velocity",0);
         this.disk_type = Utils.GetParamString("disk_type","constant");
         this.disk_velocity;
         updateFunction = this.UpdateCuttingDisk;
         onHitFunction = this.OnHitCuttingDisk;
         Game.circularSawActive = true;
      }
      
      public function UpdateBloodSplat() : *
      {
         if(state == 0)
         {
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
         else if(state == 1)
         {
            xpos += xvel;
            ypos += yvel;
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      public function InitBloodSplat(param1:Number = 0, param2:Number = 0) : *
      {
         updateFunction = this.UpdateBloodSplat;
         dobj = GraphicObjects.GetDisplayObjByName("bloodPuff");
         dir = Utils.RandCircle();
         if(param2 != 0)
         {
            movementVec.Set(param1,param2);
            xvel = movementVec.X();
            yvel = movementVec.Y();
            state = 1;
         }
         else
         {
            state = 0;
         }
      }
      
      internal function SwitchLimpetHit(param1:GameObj) : *
      {
         if(state != 0)
         {
            return false;
         }
         Utils.trace("SwitchLimpetHit");
         state = 1;
         frame = 1;
         return true;
      }
      
      internal function UpdateSwitchLimpet() : *
      {
         if(state != 0)
         {
            if(state == 1)
            {
               Game.BlowUpLimpetMines();
               frame = 1;
               state = 2;
               timer = Defs.fps * 1;
            }
            else if(state == 2)
            {
               --timer;
               if(timer <= 0)
               {
                  state = 0;
                  frame = 0;
               }
            }
         }
      }
      
      internal function InitSwitch_Limpet() : *
      {
         switchType = "limpet";
         onHitFunction = this.SwitchLimpetHit;
         updateFunction = this.UpdateSwitchLimpet;
         state = 0;
      }
      
      public function OnHitFlame(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateFlame() : *
      {
         if(state == 0)
         {
            Game.flameActive = true;
            CycleAnimation();
         }
      }
      
      public function InitFlame() : *
      {
         scoreType = "fire";
         health = 0;
         collisionType = "killzombie_all";
         collisionExtra = "flame";
         updateFunction = this.UpdateFlame;
         onHitFunction = this.OnHitFlame;
         onHitPersistFunction = this.OnHitFlame;
         frame = Utils.RandBetweenInt(0,dobj.GetNumFrames() - 1);
         frameVel = Utils.RandBetweenFloat(0.8,1);
      }
      
      public function RenderZombieFlame() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = Math.round(xpos);
         _loc2_ = Math.round(ypos);
         _loc1_ -= Math.round(Game.camera.x);
         _loc2_ -= Math.round(Game.camera.y);
         dobj.RenderAtRotScaledAdditive(frame,bd,_loc1_,_loc2_,scale,dir);
      }
      
      public function UpdateZombieFlame() : *
      {
         if(state == 0)
         {
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      public function InitZombieFlame() : *
      {
         updateFunction = this.UpdateZombieFlame;
         renderFunction = this.RenderZombieFlame;
         dobj = GraphicObjects.GetDisplayObjByName("ZombieFlame");
         frame = 0;
         frameVel = 4;
         frame = Utils.RandBetweenInt(0,3);
         scale = Utils.RandBetweenFloat(1,1.5);
      }
      
      public function UpdateSpawner() : *
      {
         var _loc1_:Object = null;
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               state = 1;
            }
         }
         else if(state == 1)
         {
            _loc1_ = new Object();
            _loc1_.xpos = xpos;
            _loc1_.ypos = ypos;
            _loc1_.name = this.spawner_spawnobject;
            GameObjects.AddToAddList(this.Spawner_GenerateObjectsCallback,_loc1_);
            ++this.spawner_spawncount;
            timer = this.spawner_frequency;
            state = 0;
            if(this.spawner_total != 0)
            {
               if(this.spawner_spawncount >= this.spawner_total)
               {
                  state = 2;
                  frame = 1;
               }
            }
         }
         else if(state == 2)
         {
         }
      }
      
      internal function Spawner_GenerateObjectsCallback(param1:Object) : *
      {
         var _loc2_:GameObj = PhysicsBase.AddPhysObjAt(param1.name,param1.xpos,param1.ypos,0,1,"","","");
         --GameVars.totalZombies;
      }
      
      public function InitSpawner() : *
      {
         Utils.GetParams(initParams);
         switchName = Utils.GetParamString("switch_name","");
         this.spawner_initialdelay = Utils.GetParamNumber("spawner_initialdelay",0) * Defs.fps;
         this.spawner_frequency = Utils.GetParamNumber("spawner_frequency",3) * Defs.fps;
         this.spawner_total = Utils.GetParamInt("spawner_totalamount",10);
         this.spawner_spawnobject = Utils.GetParamString("spawner_spawnobject","");
         GameVars.totalZombies += this.spawner_total;
         state = 0;
         timer = this.spawner_initialdelay;
         this.spawner_spawncount = 0;
         updateFunction = this.UpdateSpawner;
         visible = false;
         if(Game.usedebug)
         {
            visible = true;
         }
      }
      
      public function UpdateSpawnerLastLevel() : *
      {
         var _loc1_:Object = null;
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               state = 1;
            }
         }
         else if(state == 1)
         {
            _loc1_ = new Object();
            _loc1_.xpos = xpos + Utils.RandBetweenInt(-30,30);
            _loc1_.ypos = ypos;
            _loc1_.name = this.spawner_spawnobject;
            GameObjects.AddToAddList(this.Spawner_GenerateObjectsCallback,_loc1_);
            ++this.spawner_spawncount;
            timer = Utils.RandBetweenInt(30,60);
            state = 0;
         }
         else if(state == 2)
         {
         }
      }
      
      public function InitSpawnerLastLevel() : *
      {
         Utils.GetParams(initParams);
         switchName = Utils.GetParamString("switch_name","");
         this.spawner_initialdelay = Utils.GetParamNumber("spawner_initialdelay",0) * Defs.fps;
         this.spawner_frequency = Utils.GetParamNumber("spawner_frequency",3) * Defs.fps;
         this.spawner_total = Utils.GetParamInt("spawner_totalamount",10);
         this.spawner_spawnobject = Utils.GetParamString("spawner_spawnobject","");
         state = 0;
         timer = Utils.RandBetweenInt(0,50);
         this.spawner_spawncount = 0;
         updateFunction = this.UpdateSpawnerLastLevel;
         visible = true;
      }
      
      public function UpdateZombieStopWalkMarker() : *
      {
      }
      
      public function InitZombieStopWalkMarker() : *
      {
         name = "zombiestopwalk";
         updateFunction = this.UpdateZombieStopWalkMarker;
         visible = false;
      }
      
      public function UpdateZombieTurnAroundMarker() : *
      {
      }
      
      public function InitZombieTurnAroundMarker() : *
      {
         name = "zombieturnaround";
         updateFunction = this.UpdateZombieTurnAroundMarker;
         visible = false;
      }
      
      internal function UpdateGameObjJoint_Trapeze() : *
      {
         var _loc1_:b2RevoluteJoint = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc1_ = jointController_joint as b2RevoluteJoint;
         _loc1_.EnableMotor(true);
         _loc2_ = _loc1_.GetJointAngle();
         _loc2_ = Utils.RadToDeg(_loc2_);
         _loc3_ = 30;
         if(state == 0)
         {
            xvel -= 0.1;
            if(xvel <= -1)
            {
               xvel = -1;
            }
            _loc1_.SetMotorSpeed(xvel);
            _loc1_.SetMaxMotorTorque(4);
            if(_loc2_ < -_loc3_)
            {
               state = 1;
            }
         }
         else if(state == 1)
         {
            xvel += 0.1;
            if(xvel >= 1)
            {
               xvel = 1;
            }
            _loc1_.SetMotorSpeed(xvel);
            _loc1_.SetMaxMotorTorque(4);
            if(_loc2_ > _loc3_)
            {
               state = 0;
            }
         }
      }
      
      internal function InitGameObjJoint_Trapeze1(param1:b2Joint) : *
      {
         this.InitGameObjJoint_Trapeze(param1);
         state = 1;
      }
      
      internal function InitGameObjJoint_Trapeze(param1:b2Joint) : *
      {
         var _loc2_:b2RevoluteJoint = null;
         jointController_joint = param1;
         updateFunction = this.UpdateGameObjJoint_Trapeze;
         visible = false;
         _loc2_ = jointController_joint as b2RevoluteJoint;
         _loc2_.SetLimits(-Utils.DegToRad(80),Utils.DegToRad(80));
         _loc2_.EnableLimit(true);
         state = 0;
         timer = timerMax = Defs.fps * 2;
         xvel = 0;
      }
      
      internal function UpdateGameObjJoint_LoweringDistance() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:b2DistanceJoint = null;
         _loc1_ = 0.5;
         _loc2_ = 0.005;
         _loc3_ = jointController_joint as b2DistanceJoint;
         _loc3_.m_length -= _loc2_;
         if(_loc3_.m_length <= _loc1_)
         {
            _loc3_.m_length = _loc1_;
         }
      }
      
      internal function InitGameObjJoint_LoweringDistance(param1:b2Joint) : *
      {
         jointController_joint = param1;
         updateFunction = this.UpdateGameObjJoint_LoweringDistance;
         visible = false;
      }
      
      internal function UpdateGameObjJoint_RaisingDistance() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:b2DistanceJoint = null;
         _loc1_ = 10;
         _loc2_ = 0.005;
         _loc3_ = jointController_joint as b2DistanceJoint;
         _loc3_.m_length += _loc2_;
         if(_loc3_.m_length > _loc1_)
         {
            _loc3_.m_length = _loc1_;
         }
      }
      
      internal function InitGameObjJoint_RaisingDistance(param1:b2Joint) : *
      {
         jointController_joint = param1;
         updateFunction = this.UpdateGameObjJoint_RaisingDistance;
         visible = false;
      }
      
      public function OnHitCannon(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function RenderCannon() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Rectangle = null;
         RenderDispObjNormally();
         if(state == 2)
         {
            _loc1_ = 0;
            _loc2_ = -10;
            _loc3_ = xpos + _loc1_ - Game.camera.x;
            _loc4_ = ypos + _loc2_ - Game.camera.y;
            _loc5_ = new Rectangle(_loc3_ - 10,_loc4_,20,3);
            bd.fillRect(_loc5_,4278190080);
            _loc5_.width = Utils.ScaleTo(0,20,0,timerMax,timer);
            bd.fillRect(_loc5_,4294967295);
         }
      }
      
      internal function CannonSetCorked() : *
      {
         this.cannonCorked = true;
         dobj = GraphicObjects.GetDisplayObjByName("cannon_top_corked");
         SoundPlayer.Play("sfx_corkedup");
      }
      
      public function UpdateCannon() : *
      {
         var _loc1_:GameObj = null;
         if(state == 0)
         {
            frame = 0;
         }
         else if(state == 1)
         {
            if(PlayAnimation())
            {
               state = 0;
            }
         }
         else if(state == 2)
         {
            frame = 0;
            --timer;
            if(timer <= 0)
            {
               timer = 0;
            }
         }
         else if(state == 100)
         {
            RemoveObject(RemovePhysObj);
            _loc1_ = GameObjects.AddObj(xpos,ypos,zpos - 10);
            _loc1_.InitBarrelExplosion();
         }
      }
      
      public function Cannon_SetZombieInCannon() : *
      {
         state = 2;
         timer = timerMax = GameVars.cannonHoldTime;
      }
      
      public function Cannon_DoLaunch() : *
      {
         state = 1;
      }
      
      public function InitCannon() : *
      {
         this.cannonCorked = false;
         name = "cannon";
         updateFunction = this.UpdateCannon;
         onHitFunction = this.OnHitCannon;
         renderFunction = this.RenderCannon;
      }
      
      internal function CannonExplode() : *
      {
         state = 100;
      }
      
      internal function CannonFire() : *
      {
         frame = 0;
         state = 1;
      }
      
      public function UpdateSeparateUnicycle() : *
      {
         if(state == 0)
         {
            dir += rotVel;
            ypos += yvel;
            yvel += 1;
            --timer;
            if(timer <= 0)
            {
               RemoveObject();
            }
         }
      }
      
      public function InitSeparateUnicycle() : *
      {
         updateFunction = this.UpdateSeparateUnicycle;
         dobj = GraphicObjects.GetDisplayObjByName("SeparateUnicycle");
         yvel = -10;
         xvel = Utils.RandBetweenFloat(-1,1);
         rotVel = Utils.RandBetweenFloat(-0.2,0.2);
         timer = Defs.fps * 3;
      }
      
      public function UpdateHuman() : *
      {
         var _loc1_:b2Body = null;
         var _loc2_:GameObj = null;
         if(this.zombieTurnAroundTimer > 0)
         {
            --this.zombieTurnAroundTimer;
         }
         if(healthBarTimer > 0)
         {
            --healthBarTimer;
         }
         this.Zombie_UpdateFire();
         this.Zombie_UpdateElectric();
         if(this.zombieMakeNonWalker)
         {
            _loc1_ = bodies[0];
            _loc1_.SetUpright(false);
            _loc1_.SetMassFromShapes();
            this.isZombieWalker = false;
            this.zombieMakeNonWalker = false;
            if(state <= 20)
            {
               state = 0;
               timer = 0;
            }
            SetAnimRangeSingle("idle",true,true);
         }
         if(state == 0)
         {
            _loc2_ = Game.GetActivePlayer();
            xflip = false;
            if(_loc2_.xpos > xpos)
            {
               xflip = true;
            }
            CycleAnimationEx();
            ++timer;
         }
         else if(state == 10)
         {
            xflip = false;
            ApplyForce(-2,0);
            this.LimitXVelocity(0.35);
            CycleAnimationEx();
         }
         else if(state == 20)
         {
            xflip = true;
            ApplyForce(2,0);
            this.LimitXVelocity(0.35);
            CycleAnimationEx();
         }
         else if(state == 30)
         {
            xpos = this.cannonGO.xpos;
            ypos = this.cannonGO.ypos;
            dir = this.cannonGO.dir;
            SetXForm(xpos * PhysicsBase.w2p,ypos * PhysicsBase.w2p,dir);
            SetBodyLinearVelocity(0,0,0);
            SetBodyAngularVelocity(0,0);
            --timer;
            if(timer <= 0)
            {
               if(this.cannonGO.cannonCorked)
               {
                  state = 100;
                  this.cannonGO.CannonExplode();
               }
               else
               {
                  this.cannonGO.CannonFire();
                  this.Zombie_LaunchFromCannon();
               }
            }
            this.Zombie_MakeNonWalker();
         }
         else if(state == 100)
         {
            SoundPlayer.Play("sfx_humanscream");
            this.ZombieCreateBlood();
            this.HumanGenerateLimbs();
            RemoveObject(RemovePhysObj);
            ++GameVars.numHumansKilled;
         }
      }
      
      public function InitHuman() : *
      {
         this.zombieTurnAroundTimer = 0;
         this.zombieMakeNonWalker = false;
         this.isZombieWalker = false;
         health = maxHealth = 100;
         ++GameVars.totalHumans;
         name = "human";
         updateFunction = this.UpdateHuman;
         onHitFunction = this.OnHitHuman;
         renderFunction = this.RenderZombie;
         SetAnimRangeSingle("idle",true,true);
         this.Zombie_ClearFire();
         this.Zombie_ClearElectric();
         this.zombie_bodyIndex = 1;
         this.zombie_headIndex = 1;
         this.zombie_legIndex = 1;
         this.Human_CreateDobj();
      }
      
      public function InitHuman_WalkLeft() : *
      {
         var _loc1_:b2Body = null;
         this.InitHuman();
         _loc1_ = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 10;
         SetAnimRangeSingle("walk");
      }
      
      public function InitHuman_WalkRight() : *
      {
         var _loc1_:b2Body = null;
         this.InitHuman();
         _loc1_ = bodies[0];
         _loc1_.SetUpright(true);
         _loc1_.SetMassFromShapes();
         this.isZombieWalker = true;
         state = 20;
         SetAnimRangeSingle("walk");
      }
      
      internal function Human_CreateDobj() : *
      {
         this.zombieDobj = ZombieHolder.Add(new Civilian(),"Civilian",this.Zombie_CreateDobj_CB,this.zombie_headIndex,this.zombie_bodyIndex,this.zombie_legIndex);
         dobj = this.zombieDobj;
      }
      
      public function OnHitHuman(param1:GameObj) : *
      {
         var _loc2_:Number = NaN;
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "cannon")
         {
            this.Zombie_EnterCannon(param1);
         }
         if(param1.name == "zombiestopwalk")
         {
            this.Zombie_MakeNonWalker();
         }
         if(param1.name == "zombieturnaround")
         {
            this.Zombie_TurnAround();
         }
         if(param1.name == "zombie")
         {
            state = 100;
         }
         if(param1.collisionType == "killzombie" || param1.collisionType == "killzombie_all")
         {
            this.Zombie_MakeNonWalker();
            _loc2_ = param1.health;
            this.Zombie_AddHealth(-_loc2_,"");
            if(param1.collisionExtra == "cut")
            {
               this.Zombie_GenerateBloodSplat(param1.hitContactPoint);
            }
            if(param1.collisionExtra == "cutspray")
            {
               this.Zombie_GenerateBloodSplat_Spray(param1.hitContactPoint);
            }
            if(param1.collisionExtra == "flame")
            {
               this.Zombie_StartFire();
            }
         }
      }
      
      public function OnHitHeavyBall(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateHeavyBall() : *
      {
         if(state == 0)
         {
         }
      }
      
      public function InitHeavyBall() : *
      {
         hit_sfx_name = "sfx_anvil";
         scoreType = "heavy";
         health = maxHealth = 100;
         collisionType = "killzombie_all";
         updateFunction = this.UpdateHeavyBall;
         onHitFunction = this.OnHitHeavyBall;
      }
      
      public function OnHitAnvil(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateAnvil() : *
      {
         if(state == 0)
         {
         }
      }
      
      public function InitAnvil() : *
      {
         hit_sfx_name = "sfx_anvil";
         scoreType = "heavy";
         health = maxHealth = 100;
         collisionType = "killzombie_all";
         updateFunction = this.UpdateAnvil;
         onHitFunction = this.OnHitAnvil;
      }
      
      public function OnHitChainsaw(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateChainsaw() : *
      {
         if(state == 0)
         {
            CycleAnimation();
         }
      }
      
      public function InitChainsaw() : *
      {
         scoreType = "chainsaw";
         health = maxHealth = 1;
         collisionType = "killzombie_all";
         collisionExtra = "cutspray";
         updateFunction = this.UpdateChainsaw;
         onHitFunction = this.OnHitChainsaw;
         Game.chainsawActive = true;
      }
      
      public function RenderScoreText() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = Math.round(xpos);
         _loc2_ = Math.round(ypos);
         _loc1_ -= Math.round(Game.camera.x);
         _loc2_ -= Math.round(Game.camera.y);
         dobj.origMC.text1.theText.text = this.textMessage;
         dobj.origMC.text2.theText.text = this.textMessage1;
         dobj.RenderAtRotScaled_Vector(frame,bd,_loc1_,_loc2_,1,0,null,false,xflip);
      }
      
      public function UpdateScoreText() : *
      {
         if(state == 0)
         {
            if(PlayAnimation())
            {
               RemoveObject();
            }
         }
      }
      
      public function InitScoreText(param1:String, param2:int) : *
      {
         this.textMessage = param1;
         this.textMessage1 = param2.toString() + " PTS";
         updateFunction = this.UpdateScoreText;
         renderFunction = this.RenderScoreText;
         dobj = GraphicObjects.GetDisplayObjByName("scoreText");
         frame = 0;
      }
      
      internal function AddScore(param1:scoreData) : *
      {
         var _loc2_:GameObj = null;
         if(param1 == null)
         {
            param1 = GameVars.GetScoreData("normal");
         }
         Game.AddScore(param1.score);
         _loc2_ = GameObjects.AddObj(xpos,ypos - 80,-6000);
         _loc2_.InitScoreText(param1.desc,param1.score);
      }
      
      public function OnHitSaw(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateSaw() : *
      {
         if(state == 0)
         {
         }
      }
      
      public function InitSaw() : *
      {
         this.killsSuperZombie = true;
         scoreType = "saw";
         health = maxHealth = 1;
         collisionType = "killzombie_all";
         collisionExtra = "cut";
         updateFunction = this.UpdateSaw;
         onHitFunction = this.OnHitSaw;
         Game.sawingActive = true;
      }
      
      public function OnHitTrampoline(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "zombie")
         {
            SoundPlayer.Play("sfx_trampoline");
         }
      }
      
      public function UpdateTrampoline() : *
      {
         if(state == 0)
         {
         }
      }
      
      public function InitTrampoline() : *
      {
         updateFunction = this.UpdateTrampoline;
         onHitFunction = this.OnHitTrampoline;
      }
      
      public function UpdateDecal() : *
      {
         if(state == 0)
         {
         }
      }
      
      public function InitDecal() : *
      {
         name = "decal";
         updateFunction = this.UpdateDecal;
      }
      
      public function HitGameObjLine_TriggerHitMissile(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.collisionType == "killzombie")
         {
            state = 1;
         }
      }
      
      public function UpdateGameObjLine_TriggerHitMissile() : *
      {
         if(state != 0)
         {
            if(state == 1)
            {
               Game.DoSwitch(this as GameObj_Base);
               RemoveObject(RemovePhysObj);
            }
         }
      }
      
      public function InitGameObjLine_TriggerHitMissile() : *
      {
         this.SetUpLineAsSwitch();
         onHitFunction = this.HitGameObjLine_TriggerHitMissile;
         updateFunction = this.UpdateGameObjLine_TriggerHitMissile;
      }
      
      public function OnHitTiedUp(param1:GameObj) : *
      {
         var _loc2_:scoreData = null;
         if(param1 == null)
         {
            return;
         }
         if(state == 0)
         {
            if(param1.name.search("missile") != -1)
            {
               state = 1;
               SetAnimRangeSingle("tiedup");
               ++GameVars.numHostagesRescued;
               _loc2_ = GameVars.GetScoreData("rescue");
               this.AddScore(_loc2_);
            }
         }
         if(param1.name == "zombie")
         {
            state = 100;
         }
      }
      
      public function UpdateTiedUp() : *
      {
         if(state == 0)
         {
            frame = 0;
         }
         else if(state == 1)
         {
            if(PlayAnimationEx())
            {
               SetAnimRangeSingle("wave");
               state = 2;
            }
         }
         else if(state == 2)
         {
            CycleAnimationEx();
         }
         else if(state == 100)
         {
            this.PlayerGenerateLimbs();
            this.ZombieCreateBlood();
            ++GameVars.numHumansKilled;
            RemoveObject(RemovePhysObj);
         }
      }
      
      public function InitTiedUp() : *
      {
         this.deathLimbArray = GameVars.playerLimbObjects_cannonball;
         ++GameVars.totalHumans;
         ++GameVars.totalHostages;
         updateFunction = this.UpdateTiedUp;
         onHitFunction = this.OnHitTiedUp;
         this.zombie_bodyIndex = 1;
         this.zombie_headIndex = 1;
         this.zombie_legIndex = 1;
      }
      
      public function InitTiedUp1() : *
      {
         this.InitTiedUp();
         this.deathLimbArray = GameVars.playerLimbObjects_lionTamer;
      }
      
      public function InitTiedUp2() : *
      {
         this.InitTiedUp();
         this.deathLimbArray = GameVars.playerLimbObjects_cannonball;
      }
      
      public function InitTiedUp3() : *
      {
         this.InitTiedUp();
         this.deathLimbArray = GameVars.playerLimbObjects_flameEater;
      }
      
      public function InitTiedUp4() : *
      {
         this.InitTiedUp();
         this.deathLimbArray = GameVars.playerLimbObjects_major;
      }
      
      public function InitTiedUp5() : *
      {
         this.InitTiedUp();
         this.deathLimbArray = GameVars.playerLimbObjects_nuke;
      }
      
      public function InitTiedUp6() : *
      {
         this.InitTiedUp();
         this.deathLimbArray = GameVars.playerLimbObjects_custard;
      }
      
      public function RenderDance() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = Math.round(xpos);
         _loc2_ = Math.round(ypos);
         _loc1_ -= Math.round(Game.camera.x);
         _loc2_ -= Math.round(Game.camera.y);
         dobj.RenderAtRotScaled_Vector(frame,bd,_loc1_,_loc2_,scale,0,null,false,xflip);
      }
      
      public function UpdateDance() : *
      {
         if(state == 0)
         {
            if(PlayAnimationEx())
            {
               this.SetDanceIdle();
            }
            --timer;
            if(timer <= 0)
            {
               timer = Utils.RandBetweenInt(30,60);
               xflip = xflip == false;
            }
         }
      }
      
      public function InitDance1() : *
      {
         var _loc1_:GameObj = null;
         this.InitDance();
         _loc1_ = GameObjects.AddObj(0,0,0);
         _loc1_.InitDanceController();
      }
      
      public function InitDance() : *
      {
         scale = 1.5;
         updateFunction = this.UpdateDance;
         renderFunction = this.RenderDance;
         this.SetDanceIdle();
         xflip = Utils.RandBool();
      }
      
      internal function SetDanceIdle() : *
      {
         var _loc1_:String = null;
         _loc1_ = "idle" + Utils.RandBetweenInt(1,3);
         SetAnimRangeSingle(_loc1_,true,true);
         frameVel = Utils.RandBetweenFloat(0.8,1);
      }
      
      public function UpdateDanceController() : *
      {
         var _loc1_:GameObj = null;
         for each(_loc1_ in GameObjects.objs)
         {
            if(_loc1_.active && _loc1_.name == "zombie_fall")
            {
               if(Utils.DistBetweenPoints(MouseControl.x,MouseControl.y,_loc1_.xpos,_loc1_.ypos) < 70)
               {
                  _loc1_.ZombieFallerClicked();
                  ++GameVars.numBonusKills;
                  ++GameVars.numBonusKillStreak;
                  if(GameVars.numBonusKillStreak > GameVars.numBonusBestKillStreak)
                  {
                     GameVars.numBonusBestKillStreak = GameVars.numBonusKillStreak;
                  }
                  Game.SubmitMinigameStats();
                  return;
               }
            }
         }
      }
      
      public function InitDanceController() : *
      {
         updateFunction = this.UpdateDanceController;
         visible = false;
      }
      
      public function OnHitClownCar(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "")
         {
         }
      }
      
      public function UpdateClownCar() : *
      {
         if(state == 0)
         {
         }
      }
      
      public function InitClownCar() : *
      {
         this.killsSuperZombie = true;
         scoreType = "car";
         health = maxHealth = 10;
         collisionType = "killzombie_all";
         collisionExtra = "cut";
         updateFunction = this.UpdateClownCar;
         onHitFunction = this.OnHitClownCar;
      }
      
      public function UpdateAirstrikeMarker() : *
      {
         if(state == 0)
         {
            --timer;
            if(timer <= 0)
            {
               RemoveObject();
            }
         }
      }
      
      public function InitAirstrikeMarker() : *
      {
         dobj = GraphicObjects.GetDisplayObjByName("Missile");
         frame = 2;
         updateFunction = this.UpdateAirstrikeMarker;
         timer = Defs.fps * 3;
      }
      
      public function OnHitCork(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name == "cannon")
         {
            param1.CannonSetCorked();
            state = 100;
            onHitFunction = null;
         }
      }
      
      public function UpdateCork() : *
      {
         if(state != 0)
         {
            if(state == 100)
            {
               RemoveObject(RemovePhysObj);
            }
         }
      }
      
      public function InitCork() : *
      {
         name = "cork";
         updateFunction = this.UpdateCork;
         onHitFunction = this.OnHitCork;
      }
      
      public function OnHitZombieTurnSign(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.name.search("missile") != -1)
         {
            frame = 0;
            frameVel = 1;
            state = 1;
            onHitFunction = null;
            param1.state = 100;
            param1.timer = 0;
         }
      }
      
      public function UpdateZombieTurnSign() : *
      {
         if(state != 0)
         {
            if(state == 100)
            {
               RemoveObject(RemovePhysObj);
            }
         }
      }
      
      public function InitZombieTurnSign() : *
      {
         name = "zombieturnaround";
         onHitFunction = this.OnHitZombieTurnSign;
      }
      
      public function InitZombieTurnSign_Left() : *
      {
         var _loc1_:Array = null;
         _loc1_ = new Array();
         _loc1_.push(new BreakablePieceDef(19,-36,"sign_turn_left_part0"));
         _loc1_.push(new BreakablePieceDef(1,-32,"sign_turn_left_part1"));
         _loc1_.push(new BreakablePieceDef(-18,-34,"sign_turn_left_part2"));
         _loc1_.push(new BreakablePieceDef(-12,-18,"sign_turn_left_part3"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         this.InitZombieTurnSign();
         collisionType = "";
      }
      
      public function InitZombieTurnSign_Right() : *
      {
         var _loc1_:Array = null;
         _loc1_ = new Array();
         _loc1_.push(new BreakablePieceDef(15,-35,"sign_turn_right_part0"));
         _loc1_.push(new BreakablePieceDef(-1,-35,"sign_turn_right_part1"));
         _loc1_.push(new BreakablePieceDef(-19,-38,"sign_turn_right_part2"));
         _loc1_.push(new BreakablePieceDef(0,-11,"sign_turn_right_part3"));
         this.InitPhysObj_Breakable_Pieces(_loc1_);
         this.InitZombieTurnSign();
         collisionType = "";
      }
      
      public function InitDeadlyWheel() : *
      {
         health = maxHealth = 5;
         collisionType = "killzombie_all";
         collisionExtra = "cutspray";
      }
      
      public function UpdateInitialPlayerMarker() : *
      {
         --timer;
         if(timer <= 0)
         {
            RemoveObject();
         }
      }
      
      public function InitInitialPlayerMarker() : *
      {
         name = "initial_player_marker";
         updateFunction = this.UpdateInitialPlayerMarker;
         visible = false;
         timer = 10;
      }
      
      public function OnHitStickyPad(param1:GameObj) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(state != 0)
         {
            return;
         }
         if(param1.name.search("zombie") != -1)
         {
            if(param1.state < 100)
            {
               this.attachment_AttachFlag = 1;
               this.attachment_AttachPoint.x = hitContactPoint.position.x;
               this.attachment_AttachPoint.y = hitContactPoint.position.y;
               this.attachment_AttachObject = param1;
               state = 1;
            }
         }
      }
      
      public function UpdateStickyPad() : *
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2RevoluteJointDef = null;
         var _loc9_:Point = null;
         _loc1_ = GetBodyWorldPosWorldCoords(0);
         if(state != 0)
         {
            if(state == 1)
            {
               _loc2_ = this.attachment_AttachPoint.x * PhysicsBase.p2w;
               _loc3_ = this.attachment_AttachPoint.y * PhysicsBase.p2w;
               _loc4_ = Math.atan2(_loc1_.y - _loc3_,_loc1_.x - _loc2_);
               _loc4_ = _loc4_ + Math.PI * 0.5;
               SetBodyAngle(0,_loc4_);
               _loc5_ = bodies[0];
               _loc5_.SetAngularVelocity(0);
               _loc6_ = bodies[0];
               _loc7_ = this.attachment_AttachObject.bodies[0];
               if(this.attachment_AttachObject == null)
               {
                  _loc7_ = PhysicsBase.groundBody;
               }
               _loc8_ = new b2RevoluteJointDef();
               _loc9_ = new Point(this.attachment_AttachPoint.x,this.attachment_AttachPoint.y);
               _loc8_.Initialize(_loc6_,_loc7_,new b2Vec2(_loc9_.x,_loc9_.y));
               _loc8_.enableLimit = true;
               _loc8_.lowerAngle = 0;
               _loc8_.upperAngle = 0;
               _loc8_.enableMotor = false;
               _loc8_.motorSpeed = 0;
               _loc8_.maxMotorTorque = 0;
               _loc8_.collideConnected = true;
               this.attachment_AttachJoint = PhysicsBase.world.CreateJoint(_loc8_);
               state = 2;
            }
         }
      }
      
      public function InitStickyPad() : *
      {
         updateFunction = this.UpdateStickyPad;
         onHitFunction = this.OnHitStickyPad;
         this.InitAttachment();
      }
      
      public function RenderPlayerBillboard() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = Math.round(xpos);
         _loc2_ = Math.round(ypos);
         _loc1_ -= Math.round(Game.camera.x);
         _loc2_ -= Math.round(Game.camera.y);
         dobj.origMC.playerName.text = this.textMessage;
         dobj.RenderAtRotScaled_Vector(frame,bd,_loc1_,_loc2_,1,0,null,false,xflip);
      }
      
      public function UpdatePlayerBillboard() : *
      {
      }
      
      public function InitPlayerBillboard() : *
      {
         this.textMessage = "RobotJAM";
         if(Utils.RandBool())
         {
            this.textMessage = "LongAnimals";
         }
         if(LicDef.IsAtKongregate())
         {
            this.textMessage = Lic.Kongregate_GetUserName();
            if(this.textMessage == "UserName")
            {
               this.textMessage = "LongAnimals";
            }
         }
         updateFunction = this.UpdatePlayerBillboard;
         renderFunction = this.RenderPlayerBillboard;
      }
   }
}

