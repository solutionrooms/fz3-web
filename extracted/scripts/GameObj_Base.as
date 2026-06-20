package
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Joints.*;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.events.*;
   import flash.geom.*;
   
   public class GameObj_Base
   {
      
      public var listIndex:int;
      
      public var activeListIndex:int;
      
      public var inactiveListIndex:int;
      
      public var renderFunction:Function;
      
      public var updateFunction:Function;
      
      public var updateFromPhysicsFunction:Function;
      
      public var onClickedFunction:Function;
      
      public var updateFunction1:Function;
      
      public var switchFunction:Function;
      
      public var renderShadowFunction:Function;
      
      public var doSwitchFunction:Function;
      
      public var switchFlag:Boolean;
      
      public var id:String;
      
      public var xpos:Number;
      
      public var ypos:Number;
      
      public var xpos1:Number;
      
      public var ypos1:Number;
      
      public var oldxpos:Number;
      
      public var oldypos:Number;
      
      public var xpos2:Number;
      
      public var ypos2:Number;
      
      public var zpos:Number;
      
      public var zvel:Number;
      
      public var active:Boolean;
      
      public var killed:Boolean;
      
      public var visible:Boolean;
      
      public var renderShadowFlag:Boolean;
      
      public var starty:Number;
      
      public var startx:Number;
      
      public var startz:Number;
      
      public var type:int;
      
      public var subtype:int;
      
      public var state:int;
      
      public var nextState:int;
      
      public var controlIndex:int;
      
      public var xoffset:Number;
      
      public var yoffset:Number;
      
      public var xvel:Number;
      
      public var yvel:Number;
      
      public var xacc:Number;
      
      public var yacc:Number;
      
      public var timer:Number;
      
      public var timer1:Number;
      
      public var timerMax:Number;
      
      public var dobj:DisplayObj;
      
      public var dobj1:DisplayObj;
      
      public var dobj2:DisplayObj;
      
      public var frame:Number;
      
      public var frame1:Number;
      
      public var frame2:Number;
      
      public var frameVel:Number;
      
      public var frameVel1:Number;
      
      public var animBouncing:Boolean;
      
      public var isPolyObject:Boolean;
      
      public var radius:Number;
      
      public var colOffsetX:Number;
      
      public var colOffsetY:Number;
      
      public var movementVec:Vec;
      
      public var driveVec:Vec;
      
      internal var initParams:String;
      
      internal var initFunctionVarString:String;
      
      internal var linkedPhysLine:PhysLine;
      
      public var dir:Number;
      
      public var todir:Number;
      
      public var toPosX:Number;
      
      public var toPosY:Number;
      
      public var speed:Number;
      
      public var origspeed:Number;
      
      public var count:int;
      
      public var hitTimer:Number;
      
      internal var minFrame:int;
      
      internal var maxFrame:int;
      
      internal var rotVel:Number;
      
      internal var dist:Number;
      
      internal var flashTimer:int;
      
      internal var flashTimerMax:int;
      
      internal var flashFlag:Boolean;
      
      internal var xflip:Boolean;
      
      internal var healthBarTimer:int;
      
      internal var health:Number;
      
      internal var maxHealth:Number;
      
      internal var path:Poly;
      
      internal var maxSpeed:Number;
      
      internal var currentMaxSpeed:Number;
      
      internal var parentObj:GameObj;
      
      internal var respawnArea:Boolean;
      
      internal var inFrontZone:Poly;
      
      public var name:String;
      
      public var collisionType:String;
      
      public var collisionExtra:String;
      
      internal var scale:Number;
      
      internal var uniqueID:int;
      
      internal var isPhysObj:Boolean;
      
      internal var alpha:Number;
      
      internal var renderSmooth:Boolean;
      
      internal var currentPoly:Poly;
      
      internal var sortByY:Boolean;
      
      internal var isVehicle:Boolean;
      
      internal var soundTimer:int;
      
      internal var onHitSceneryFunction:Function;
      
      internal var onHitExplosionFunction:Function;
      
      internal var onHitFunction:Function;
      
      internal var onHitPersistFunction:Function;
      
      internal var onHitRemoveFunction:Function;
      
      internal var removeFunction:Function;
      
      internal var bodies:Vector.<b2Body>;
      
      internal var joints:Array;
      
      internal var physobj:PhysObj;
      
      internal var scoreType:String;
      
      internal var hit_sfx_name:String;
      
      internal var break_sfx_name:String;
      
      internal var singleHitResponse:Boolean;
      
      internal var jointList:Array;
      
      public var colFlag_jumpon:Boolean;
      
      public var colFlag_playercanbekilled:Boolean;
      
      public var colFlag_killPlayer:Boolean;
      
      public var colFlag_canBePickedUp:Boolean;
      
      public var colFlag_dontDamagePlayer:Boolean;
      
      public var colFlag_canBeShot:Boolean;
      
      public var colFlag_isBullet:Boolean;
      
      public var colFlag_isEnemy:Boolean;
      
      public var colFlag_isEnemyBullet:Boolean;
      
      public var colFlag_isPlatform:Boolean;
      
      public var colFlag_isPowerup:Boolean;
      
      public var colFlag_isSwitch:Boolean;
      
      public var colFlag_isBouncyPad:Boolean;
      
      public var colFlag_isCheckpoint:Boolean;
      
      public var colFlag_isShop:Boolean;
      
      public var colFlag_isBall:Boolean;
      
      public var colFlag_isHose:Boolean;
      
      public var colFlag_isPlayer:Boolean;
      
      public var colFlag_isPhysObj:Boolean;
      
      public var colFlag_isGoPhysObj:Boolean;
      
      public var colFlag_isRemovable:Boolean;
      
      internal var bd:BitmapData;
      
      internal var shadowCT:ColorTransform = new ColorTransform(1,1,1,1,-255,-255,-255,-128);
      
      internal var ct:ColorTransform = new ColorTransform();
      
      internal var generator_type:String;
      
      internal var generator_delay:int;
      
      internal var switch_timer:int;
      
      internal var switchType:String;
      
      internal var switchContactList:Array;
      
      internal var numAnims:int;
      
      internal var currentAnim:int;
      
      internal var lineLinearPos:Number;
      
      internal var lineSpeed:Number;
      
      internal var lineIndex:int;
      
      internal var lineLoop:Boolean;
      
      internal var lineResetAtEnd:Boolean;
      
      internal var lineSpline:Boolean;
      
      internal var lineRotateToPath:Boolean;
      
      internal var switchName:String;
      
      internal var switchName1:String;
      
      internal var anims:Array;
      
      internal var hitShape:b2Shape;
      
      internal var hitShapeUserData:Object;
      
      internal var hitShapeName:String;
      
      internal var hitContactPoint:b2ContactPoint;
      
      internal var pathSwitchTimer:int;
      
      internal var pathSwitchControlMode:int;
      
      internal var pathSwitchDoneOnce:Boolean;
      
      internal var pathControlMode:int;
      
      internal var lineRender_Mode:String;
      
      internal var lineRender_Color:uint;
      
      internal var lineRender_Color0:uint;
      
      internal var lineRender_Color1:uint;
      
      internal var lineRender_LineColor:uint;
      
      internal var lineRender_LineAlpha:Number;
      
      internal var lineRender_lineThickness:Number;
      
      internal var invisibleTimer:int;
      
      internal var invisibleTimerMax:int;
      
      internal var jointController_joint:b2Joint;
      
      public function GameObj_Base()
      {
         super();
         this.xpos = 0;
         this.ypos = 0;
         this.zpos = 1;
         this.starty = 0;
         this.startx = 0;
         this.active = false;
         this.killed = false;
         this.zpos = 0;
         this.frame = 0;
         this.frameVel = 1;
         this.controlIndex = 0;
         this.timer = 0;
         this.timer1 = 0;
         this.radius = 14;
         this.minFrame = 0;
         this.maxFrame = 0;
         this.movementVec = new Vec();
         this.dobj = null;
         this.dobj1 = null;
         this.dobj2 = null;
      }
      
      public function Init(param1:int) : void
      {
         var _loc2_:int = 0;
         this.id = "";
         _loc2_ = 0;
         var _loc3_:Number = 0;
         this.type = param1;
         this.state = _loc2_;
         this.xvel = _loc3_;
         this.yvel = _loc3_;
         this.frame = _loc3_;
         this.frameVel = _loc3_;
         this.animBouncing = false;
         this.timer = _loc3_;
         this.hitTimer = _loc3_;
         this.flashTimer = _loc2_;
         this.flashFlag = false;
         this.dir = 0;
         this.todir = 0;
         this.healthBarTimer = 0;
         this.health = 1;
         this.zvel = 0;
         this.name = "";
         this.collisionType = "";
         this.collisionExtra = "";
         this.scale = 1;
         this.xflip = false;
         this.doSwitchFunction = null;
         this.renderShadowFunction = null;
         this.updateFunction = null;
         this.updateFromPhysicsFunction = null;
         this.updateFunction1 = null;
         this.renderFunction = null;
         this.switchFunction = null;
         this.visible = true;
         this.renderShadowFlag = false;
         this.ClearColFlags();
         this.isPhysObj = false;
         this.alpha = 1;
         this.xpos1 = 0;
         this.ypos1 = 0;
         this.renderSmooth = true;
         this.frameVel = 1;
         this.isVehicle = false;
         this.sortByY = false;
         this.killed = false;
         this.initParams = "";
         this.dobj = null;
         this.dobj1 = null;
         this.dobj2 = null;
         this.jointList = new Array();
         this.physobj = null;
         this.onHitSceneryFunction = null;
         this.onHitFunction = null;
         this.onHitExplosionFunction = null;
         this.onHitRemoveFunction = null;
         this.onHitPersistFunction = null;
         this.removeFunction = null;
         this.linkedPhysLine = null;
         this.bodies = null;
         this.joints = new Array();
         this.isPolyObject = false;
         this.respawnArea = false;
         this.scoreType = "";
         this.hit_sfx_name = "";
         this.break_sfx_name = "";
         this.singleHitResponse = false;
      }
      
      internal function ClearColFlags() : *
      {
         this.colFlag_jumpon = false;
         this.colFlag_killPlayer = false;
         this.colFlag_playercanbekilled = false;
         this.colFlag_dontDamagePlayer = false;
         this.colFlag_canBePickedUp = false;
         this.colFlag_canBeShot = false;
         this.colFlag_isBullet = false;
         this.colFlag_isPlatform = false;
         this.colFlag_isPowerup = false;
         this.colFlag_isBouncyPad = false;
         this.colFlag_isCheckpoint = false;
         this.colFlag_isShop = false;
         this.colFlag_isEnemyBullet = false;
         this.colFlag_isEnemy = false;
         this.colFlag_isBall = false;
         this.colFlag_isHose = false;
         this.colFlag_isPlayer = false;
         this.colFlag_isPhysObj = false;
         this.colFlag_isGoPhysObj = false;
         this.colFlag_isSwitch = false;
         this.colFlag_isRemovable = false;
      }
      
      public function Render(param1:BitmapData) : void
      {
         this.bd = param1;
         if(this.visible == false)
         {
            return;
         }
         if(this.renderFunction != null)
         {
            this.renderFunction();
         }
         else
         {
            this.RenderDispObjNormally();
         }
      }
      
      public function RenderShadow(param1:BitmapData) : void
      {
         this.bd = param1;
         if(this.visible == false)
         {
            return;
         }
         if(this.renderShadowFlag == false)
         {
            return;
         }
         if(this.dobj == null)
         {
            return;
         }
         if(this.renderShadowFunction != null)
         {
            this.renderShadowFunction();
         }
         else
         {
            this.RenderDispObjShadow();
         }
      }
      
      internal function RenderDispObjShadow(param1:Boolean = true) : *
      {
         var _loc2_:Number = this.xpos;
         var _loc3_:Number = this.ypos;
         if(param1)
         {
            _loc2_ -= Game.camera.x;
            _loc3_ -= Game.camera.y;
         }
         _loc2_ += Game.shadowOffsetX;
         _loc3_ += Game.shadowOffsetY;
         this.dobj.RenderAtRotScaled(this.frame,this.bd,_loc2_,_loc3_,this.scale,this.dir,this.shadowCT,true);
      }
      
      internal function RenderDispObjNormally(param1:Boolean = true) : *
      {
         var _loc2_:Number = this.scale;
         var _loc3_:Number = Math.round(this.xpos);
         var _loc4_:Number = Math.round(this.ypos);
         if(param1)
         {
            _loc3_ -= Math.round(Game.camera.x);
            _loc4_ -= Math.round(Game.camera.y);
         }
         if(_loc2_ != 1 || this.dir != 0)
         {
            if(this.xflip)
            {
               this.dobj.RenderAtRotScaled_Xflip(this.frame,this.bd,_loc3_,_loc4_,_loc2_,this.dir,null,this.renderSmooth);
            }
            else
            {
               this.dobj.RenderAtRotScaled(this.frame,this.bd,_loc3_,_loc4_,_loc2_,this.dir,null,this.renderSmooth);
            }
         }
         else if(this.xflip)
         {
            this.dobj.RenderAtXFlip(this.frame,this.bd,_loc3_,_loc4_);
         }
         else
         {
            this.dobj.RenderAt(this.frame,this.bd,_loc3_,_loc4_);
         }
      }
      
      internal function RenderNormallyAlpha() : *
      {
         if(this.alpha == 1)
         {
            this.RenderDispObjNormally();
            return;
         }
         var _loc1_:Number = Math.round(this.xpos);
         var _loc2_:Number = Math.round(this.ypos);
         _loc1_ -= Math.round(Game.camera.x);
         _loc2_ -= Math.round(Game.camera.y);
         this.ct.alphaMultiplier = this.alpha;
         this.dobj.RenderAtRotScaled(this.frame,this.bd,_loc1_,_loc2_,this.scale,this.dir,this.ct,this.renderSmooth);
      }
      
      internal function RenderDispObjAt(param1:Number, param2:Number, param3:DisplayObj, param4:int, param5:ColorTransform = null, param6:Number = 0, param7:Number = 1, param8:Boolean = true) : *
      {
         var _loc9_:Number = param7;
         var _loc10_:Number = Math.round(param1);
         var _loc11_:Number = Math.round(param2);
         if(param8)
         {
            _loc10_ -= Math.round(Game.camera.x);
            _loc11_ -= Math.round(Game.camera.y);
         }
         if(param7 != 1 || param6 != 0)
         {
            if(this.xflip)
            {
               param3.RenderAtRotScaled_Xflip(param4,this.bd,_loc10_,_loc11_,param7,param6,null,this.renderSmooth);
            }
            else
            {
               param3.RenderAtRotScaled(param4,this.bd,_loc10_,_loc11_,param7,param6,null,this.renderSmooth);
            }
         }
         else if(this.xflip)
         {
            param3.RenderAtXFlip(param4,this.bd,_loc10_,_loc11_);
         }
         else
         {
            param3.RenderAt(param4,this.bd,_loc10_,_loc11_);
         }
      }
      
      internal function RenderCollision() : void
      {
         if(Debug.IsSet(1) == false)
         {
            return;
         }
         if(this.colFlag_isGoPhysObj == false)
         {
            return;
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         _loc1_ += this.xpos;
         _loc1_ -= Game.camera.x;
         _loc1_ += this.colOffsetX;
         _loc2_ += this.ypos;
         _loc2_ -= Game.camera.y;
         _loc2_ += this.colOffsetY;
         Utils.RenderCircle(this.bd,_loc1_,_loc2_,this.radius,4294967295);
      }
      
      internal function IsInWorld(param1:Number) : Boolean
      {
         if(this.xpos < 0 - param1)
         {
            return false;
         }
         if(this.ypos < 0 - param1)
         {
            return false;
         }
         if(this.xpos > Defs.displayarea_w + param1)
         {
            return false;
         }
         if(this.ypos > Defs.displayarea_h + param1)
         {
            return false;
         }
         return true;
      }
      
      public function GetDirBetween(param1:*, param2:*, param3:*, param4:*) : Number
      {
         return Math.atan2(param4 - param2,param3 - param1);
      }
      
      public function GetVelFromDir(param1:Number) : *
      {
         this.xvel = Math.cos(this.dir) * param1;
         this.yvel = Math.sin(this.dir) * param1;
      }
      
      public function CycleAnimationEx() : Boolean
      {
         var _loc2_:* = undefined;
         var _loc1_:Boolean = false;
         if(this.animBouncing == false)
         {
            this.frame += this.frameVel;
            _loc2_ = this.maxFrame - this.minFrame;
            if(this.frame > this.maxFrame)
            {
               this.frame -= _loc2_;
               _loc1_ = true;
            }
            if(this.frame < this.minFrame)
            {
               this.frame += _loc2_;
               _loc1_ = true;
            }
         }
         else
         {
            this.frame += this.frameVel;
            _loc2_ = this.maxFrame - this.minFrame;
            if(this.frame > this.maxFrame)
            {
               this.frameVel *= -1;
               this.frame = this.maxFrame;
               _loc1_ = true;
            }
            if(this.frame < this.minFrame)
            {
               this.frameVel *= -1;
               this.frame = this.minFrame;
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      public function PlayAnimationEx() : Boolean
      {
         var _loc1_:Boolean = false;
         this.frame += this.frameVel;
         if(this.frame > this.maxFrame)
         {
            this.frame = this.maxFrame;
            _loc1_ = true;
         }
         if(this.frame < this.minFrame)
         {
            this.frame = this.minFrame;
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function CycleAnimation() : void
      {
         var _loc1_:Number = this.frameVel;
         var _loc2_:int = this.dobj.GetNumFrames();
         this.frame += _loc1_;
         if(this.frame >= _loc2_)
         {
            this.frame -= _loc2_;
         }
         if(this.frame < 0)
         {
            this.frame += _loc2_;
         }
      }
      
      public function CycleAnimation1() : void
      {
         var _loc1_:Number = this.frameVel1;
         var _loc2_:int = this.dobj1.GetNumFrames();
         this.frame1 += _loc1_;
         if(this.frame1 >= _loc2_)
         {
            this.frame1 -= _loc2_;
         }
         if(this.frame1 < 0)
         {
            this.frame += _loc2_;
         }
      }
      
      public function PlayAnimation() : Boolean
      {
         var _loc1_:int = this.dobj.GetNumFrames() - 1;
         this.frame += this.frameVel;
         if(this.frame > _loc1_)
         {
            this.frame = _loc1_;
            return true;
         }
         if(this.frame < 0)
         {
            this.frame = 0;
            return true;
         }
         return false;
      }
      
      public function PlayAnimation1() : Boolean
      {
         var _loc1_:int = this.dobj1.GetNumFrames() - 1;
         this.frame1 += this.frameVel1;
         if(this.frame1 >= _loc1_)
         {
            this.frame1 = _loc1_;
            return true;
         }
         return false;
      }
      
      public function Update() : void
      {
         if(this.bodies != null)
         {
            if(this.bodies.length != 0)
            {
               this.bodies[0].WakeUp();
            }
         }
         if(this.updateFunction != null)
         {
            this.updateFunction();
         }
         if(this.sortByY)
         {
            this.zpos = 0 - this.ypos * 0.01;
         }
      }
      
      internal function GameObj_UpdateGenerator() : void
      {
         var _loc1_:Point = null;
         if(this.generator_type == "")
         {
            return;
         }
         --this.timer;
         if(this.timer < 0)
         {
            _loc1_ = new Point(this.xpos,this.ypos);
            this.timer = this.generator_delay;
         }
      }
      
      internal function GameObj_InitGenerator() : void
      {
         Utils.GetParams(this.initParams);
         this.generator_type = Utils.GetParamString("generator_type","");
         this.generator_delay = Utils.GetParamNumber("generator_delay",1) * Defs.fps;
         this.updateFunction = this.GameObj_UpdateGenerator;
         this.timer = this.generator_delay;
      }
      
      internal function InitGameObj_Switch() : *
      {
         this.colFlag_isSwitch = true;
         this.name = "switch";
         Utils.GetParams(this.initParams);
         this.switchType = Utils.GetParam("type");
         if(this.switchType == "")
         {
            this.switchType = "once";
         }
         if(this.switchType == "once")
         {
            this.doSwitchFunction = this.SwitchedGameObj_Switch;
            this.updateFunction = null;
            this.state = 0;
            this.frame = this.dobj.GetFrameIndexLabel("on");
         }
         if(this.switchType == "timed")
         {
            this.switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;
            this.doSwitchFunction = this.SwitchedGameObj_TimedSwitch;
            this.updateFunction = this.UpdateGameObj_TimedSwitch;
            this.frame = this.dobj.GetFrameIndexLabel("on");
         }
         if(this.switchType == "2way")
         {
            this.doSwitchFunction = this.SwitchedGameObj_TwoWaySwitch;
            this.updateFunction = this.UpdateGameObj_TwoWaySwitch;
            this.frame = this.dobj.GetFrameIndexLabel("on");
            this.state = 0;
         }
         this.switchContactList = new Array();
      }
      
      internal function Switch_IsInContactList(param1:GameObj) : Boolean
      {
         if(this.switchContactList.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      internal function Switch_AddToContactList(param1:GameObj) : *
      {
         this.switchContactList.push(param1);
      }
      
      internal function Switch_RemoveFromContactList(param1:GameObj) : *
      {
         var _loc2_:int = this.switchContactList.indexOf(param1);
         this.switchContactList.splice(_loc2_,1);
      }
      
      internal function Switch_IsDown() : Boolean
      {
         if(this.switchType == "once")
         {
            if(this.state == 0)
            {
               return false;
            }
            return true;
         }
         if(this.switchType == "timed")
         {
            if(this.state == 0)
            {
               return false;
            }
            return true;
         }
         if(this.switchType == "2way")
         {
            if(this.state == 0)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      internal function SwitchedGameObj_TwoWaySwitch() : Boolean
      {
         SoundPlayer.Play("sfx_switch");
         if(this.state == 0)
         {
            this.state = 1;
            this.frame = this.dobj.GetFrameIndexLabel("off");
            return true;
         }
         this.state = 0;
         this.frame = this.dobj.GetFrameIndexLabel("on");
         return true;
      }
      
      internal function UpdateGameObj_TwoWaySwitch() : *
      {
      }
      
      internal function SwitchedGameObj_Switch() : Boolean
      {
         if(this.state == 1)
         {
            return false;
         }
         if(this.state == 0)
         {
            this.state = 1;
            SoundPlayer.Play("sfx_switch");
            this.state = 1;
            this.frame = this.dobj.GetFrameIndexLabel("off");
            return true;
         }
         return false;
      }
      
      internal function UpdateGameObj_TimedSwitch() : *
      {
         if(this.state == 1)
         {
            --this.timer;
            if(this.timer <= 0)
            {
               SoundPlayer.Play("sfx_switch");
               Game.DoGameObjSwitch(this);
               this.state = 0;
            }
         }
      }
      
      internal function SwitchedGameObj_TimedSwitch() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.state == 0)
         {
            this.state = 1;
            this.timer = this.switch_timer;
            SoundPlayer.Play("sfx_switch");
            _loc1_ = true;
         }
         else
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      internal function Update_SimpleRotator() : *
      {
         this.dir += this.rotVel;
         this.dir = Utils.NormalizeRot(this.dir);
      }
      
      internal function Init_SimpleRotator() : *
      {
         Utils.trace("Init_SimpleRotator");
         Utils.GetParams(this.initParams);
         this.rotVel = Utils.DegToRad(Utils.GetParamNumber("rotation_speed",0));
         this.updateFunction = this.Update_SimpleRotator;
      }
      
      internal function Update_PlayAnimList() : *
      {
         var _loc1_:String = null;
         if(this.PlayAnimationEx())
         {
            Utils.GetParams(this.initFunctionVarString);
            ++this.currentAnim;
            if(this.currentAnim >= this.numAnims)
            {
               this.currentAnim = 0;
            }
            _loc1_ = Utils.paramNames[this.currentAnim];
            this.frameVel = Number(Utils.paramValues[this.currentAnim]);
            this.SetAnimRange(_loc1_ + "_start",_loc1_ + "_end",true);
         }
      }
      
      internal function Init_PlayAnimList() : *
      {
         var _loc1_:String = null;
         Utils.trace("Init_PlayAnimList");
         Utils.GetParams(this.initFunctionVarString);
         this.numAnims = Utils.paramNames.length;
         this.currentAnim = 0;
         this.updateFunction = this.Update_PlayAnimList;
         _loc1_ = Utils.paramNames[this.currentAnim];
         this.frameVel = Number(Utils.paramValues[this.currentAnim]);
         this.SetAnimRange(_loc1_ + "_start",_loc1_ + "_end",true);
      }
      
      internal function Set_SwitchedAnim(param1:int) : *
      {
         this.state = param1;
         if(this.state == 0)
         {
            this.SetAnimRange("idle_off_start","idle_off_end",true);
         }
         if(this.state == 1)
         {
            this.SetAnimRange("off_on_start","off_on_end",true);
         }
         if(this.state == 2)
         {
            this.SetAnimRange("idle_on_start","idle_on_end",true);
         }
         if(this.state == 3)
         {
            this.SetAnimRange("on_off_start","on_off_end",true);
         }
      }
      
      internal function Update_SwitchedAnim() : *
      {
         if(this.state == 0)
         {
            this.CycleAnimationEx();
         }
         else if(this.state == 1)
         {
            if(this.PlayAnimationEx())
            {
               this.Set_SwitchedAnim(2);
            }
         }
         else if(this.state == 2)
         {
            this.CycleAnimationEx();
         }
         else if(this.state == 3)
         {
            if(this.PlayAnimationEx())
            {
               this.Set_SwitchedAnim(0);
            }
         }
      }
      
      internal function SwitchFunction_SwitchedAnim() : *
      {
         if(this.state == 0)
         {
            if(this.dobj.DoesFrameIndexLabelExist("off_on_start"))
            {
               this.Set_SwitchedAnim(1);
            }
            else
            {
               this.Set_SwitchedAnim(2);
            }
         }
         else if(this.state == 2)
         {
            if(this.dobj.DoesFrameIndexLabelExist("on_off_start"))
            {
               this.Set_SwitchedAnim(3);
            }
            else
            {
               this.Set_SwitchedAnim(0);
            }
         }
      }
      
      internal function Init_SwitchedAnim() : *
      {
         Utils.trace("Init SwitchedAnim");
         Utils.GetParams(this.initParams);
         this.updateFunction = this.Update_SwitchedAnim;
         this.switchName = Utils.GetParamString("switch","");
         var _loc1_:int = Utils.GetParamInt("startpos",0);
         this.Set_SwitchedAnim(_loc1_);
         this.switchFunction = null;
         if(this.switchName != "")
         {
            this.switchFunction = this.SwitchFunction_SwitchedAnim;
         }
      }
      
      internal function InitGameObj_Path() : *
      {
         Utils.trace("Init path object");
         Utils.GetParams(this.initParams);
         var _loc1_:int = 0;
         while(_loc1_ < Utils.paramNames.length)
         {
            Utils.trace("InitGameObj_Path: Param " + _loc1_ + ":  " + Utils.paramNames[_loc1_] + "   =   " + Utils.paramValues[_loc1_]);
            _loc1_++;
         }
         var _loc2_:String = Utils.GetParam("path_line","");
         if(_loc2_ == "")
         {
            this.lineIndex = -1;
         }
         else
         {
            this.lineIndex = Game.GetLineIndexByName(_loc2_);
         }
         if(this.lineIndex == -1)
         {
            this.updateFunction = null;
         }
         this.lineSpeed = 1 / (Utils.GetParamNumber("path_speed") * Defs.fps);
         this.lineLoop = Utils.GetParamBool("path_loop");
         this.switchName = Utils.GetParam("path_switch","");
         this.lineResetAtEnd = Utils.GetParamBool("path_endreset");
         this.lineSpline = Utils.GetParamBool("path_spline");
         this.lineRotateToPath = Utils.GetParamBool("path_rotatetopath",false);
         this.lineLinearPos = 0;
         var _loc3_:Number = Utils.GetParamNumber("path_startpos",0);
         this.lineLinearPos = _loc3_;
         var _loc4_:Boolean = Utils.GetParamBool("path_2way");
         this.state = 1;
         this.switchFunction = null;
         this.updateFunction = null;
         if(this.lineIndex != -1)
         {
            if(this.switchName != "")
            {
               this.state = 0;
               this.switchFunction = this.SwitchFunction_Path;
            }
            else
            {
               this.state = 1;
            }
            this.updateFunction = this.UpdateObj_Path;
         }
         if(_loc4_)
         {
            this.updateFunction = this.UpdateObj_Path_2way;
            if(this.switchName != "")
            {
               this.switchFunction = this.SwitchFunction_Path_2way;
               this.updateFunction = this.UpdateObj_Path_2way_switched;
            }
         }
      }
      
      internal function SwitchFunction_Path_2way() : *
      {
         if(this.state == 0)
         {
            this.state = 1;
         }
         else if(this.state == 1)
         {
            Utils.trace("path 2way 2");
            this.state = 2;
         }
         else
         {
            Utils.trace("path 2way 1");
            this.state = 1;
         }
      }
      
      internal function UpdateObj_Path_2way() : *
      {
         var _loc1_:Point = null;
         if(this.lineRotateToPath)
         {
            this.dir = this.GetLineAngle();
         }
         if(this.state == 0)
         {
            this.state = 1;
         }
         if(this.state == 1)
         {
            _loc1_ = this.UpdateLine(this.lineSpeed);
            this.xpos = _loc1_.x;
            this.ypos = _loc1_.y;
            if(this.lineLinearPos >= 1)
            {
               this.state = 2;
            }
         }
         else if(this.state == 2)
         {
            _loc1_ = this.UpdateLine(-this.lineSpeed);
            this.xpos = _loc1_.x;
            this.ypos = _loc1_.y;
            if(this.lineLinearPos <= 0)
            {
               this.state = 1;
            }
         }
      }
      
      internal function UpdateObj_Path_2way_switched() : *
      {
         var _loc1_:Point = null;
         if(this.lineRotateToPath)
         {
            this.dir = this.GetLineAngle();
         }
         if(this.state == 0)
         {
            _loc1_ = this.UpdateLine(0);
            this.xpos = _loc1_.x;
            this.ypos = _loc1_.y;
         }
         else if(this.state == 1)
         {
            _loc1_ = this.UpdateLine(this.lineSpeed);
            this.xpos = _loc1_.x;
            this.ypos = _loc1_.y;
         }
         else if(this.state == 2)
         {
            _loc1_ = this.UpdateLine(-this.lineSpeed);
            this.xpos = _loc1_.x;
            this.ypos = _loc1_.y;
         }
      }
      
      internal function SwitchFunction_Path() : *
      {
         if(this.state == 0)
         {
            this.state = 1;
         }
      }
      
      internal function UpdateObj_Path() : *
      {
         var _loc1_:Point = null;
         if(this.lineRotateToPath)
         {
            this.dir = this.GetLineAngle();
         }
         if(this.state == 0)
         {
            _loc1_ = this.UpdateLine(0);
            this.xpos = _loc1_.x;
            this.ypos = _loc1_.y;
         }
         else
         {
            _loc1_ = this.UpdateLine(this.lineSpeed);
            this.xpos = _loc1_.x;
            this.ypos = _loc1_.y;
            if(this.lineLoop == false)
            {
               if(this.lineLinearPos >= 1)
               {
                  this.lineLinearPos = 1;
                  if(this.lineResetAtEnd)
                  {
                     this.lineLinearPos = 0;
                  }
                  this.state = 0;
               }
            }
         }
      }
      
      internal function GetLineAngle() : Number
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc1_:PhysLine = Levels.GetCurrent().lines[this.lineIndex];
         if(_loc1_ == null)
         {
            return 0;
         }
         if(this.lineLinearPos < 0.5)
         {
            _loc2_ = _loc1_.GetInterpolatedPoint(this.lineLinearPos,this.lineLoop,this.lineSpline);
            _loc3_ = _loc1_.GetInterpolatedPoint(this.lineLinearPos + 0.01,this.lineLoop,this.lineSpline);
         }
         else
         {
            _loc2_ = _loc1_.GetInterpolatedPoint(this.lineLinearPos - 0.01,this.lineLoop,this.lineSpline);
            _loc3_ = _loc1_.GetInterpolatedPoint(this.lineLinearPos,this.lineLoop,this.lineSpline);
         }
         return Math.atan2(_loc3_.y - _loc2_.y,_loc3_.x - _loc2_.x);
      }
      
      internal function UpdateLine(param1:Number) : Point
      {
         var _loc3_:Point = null;
         this.lineLinearPos += param1;
         if(this.lineLinearPos > 1)
         {
            if(this.lineLoop == true)
            {
               --this.lineLinearPos;
            }
            else
            {
               this.lineLinearPos = 1;
            }
         }
         if(this.lineLinearPos < 0)
         {
            if(this.lineLoop == true)
            {
               this.lineLinearPos += 1;
            }
            else
            {
               this.lineLinearPos = 0;
            }
         }
         var _loc2_:PhysLine = Levels.GetCurrent().lines[this.lineIndex];
         if(_loc2_ == null)
         {
            return new Point(0,0);
         }
         if(this.lineLoop == true && this.lineSpline == false)
         {
            _loc3_ = _loc2_.GetInterpolatedPoint1(this.lineLinearPos,this.lineLoop);
         }
         else
         {
            _loc3_ = _loc2_.GetInterpolatedPoint(this.lineLinearPos,this.lineLoop,this.lineSpline);
         }
         return _loc3_;
      }
      
      internal function GameObj_InitInvisible() : void
      {
         this.visible = false;
      }
      
      internal function GameObj_InitCycleAnim() : void
      {
         this.updateFunction = this.GameObj_UpdateCycleAnim;
         this.frameVel = 1;
      }
      
      internal function GameObj_UpdateCycleAnim() : void
      {
         this.CycleAnimation();
      }
      
      internal function GameObj_UpdateCycleAnimEx() : void
      {
         this.CycleAnimationEx();
      }
      
      internal function GameObj_UpdatePlayAnimEx() : void
      {
         this.CycleAnimationEx();
      }
      
      internal function InitSortByY() : void
      {
         this.sortByY = true;
      }
      
      internal function SetAnimRangeSingle(param1:*, param2:Boolean = true, param3:Boolean = false) : *
      {
         this.animBouncing = param3;
         this.SetAnimRange(param1,param1 + "_end",param2,param3);
      }
      
      internal function SetAnimRange(param1:String, param2:String, param3:Boolean = true, param4:Boolean = false) : *
      {
         this.animBouncing = param4;
         this.minFrame = this.dobj.GetFrameIndexLabel(param1);
         this.maxFrame = this.dobj.GetFrameIndexLabel(param2);
         if(this.frame < this.minFrame)
         {
            this.frame = this.minFrame;
         }
         if(this.frame > this.maxFrame)
         {
            this.frame = this.maxFrame;
         }
         if(param3)
         {
            this.frame = this.minFrame;
         }
      }
      
      internal function SetAnim(param1:String, param2:Boolean = true, param3:Boolean = false) : *
      {
         this.dobj = GraphicObjects.GetDisplayObjByName(param1);
         this.minFrame = 0;
         this.maxFrame = this.dobj.GetNumFrames() - 1;
         if(this.frame < this.minFrame)
         {
            this.frame = this.minFrame;
         }
         if(this.frame > this.maxFrame)
         {
            this.frame = this.maxFrame;
         }
         if(param2)
         {
            this.frame = this.minFrame;
         }
      }
      
      public function GetBodyWorldPosWorldCoords(param1:int) : b2Vec2
      {
         var _loc2_:b2Vec2 = this.GetBodyWorldPos(param1);
         _loc2_.Multiply(PhysicsBase.p2w);
         return _loc2_;
      }
      
      public function GetBodyWorldPos(param1:int) : b2Vec2
      {
         var _loc4_:b2Body = null;
         var _loc2_:b2Vec2 = new b2Vec2(0,0);
         var _loc3_:int = 0;
         for each(_loc4_ in this.bodies)
         {
            if(_loc3_ == param1)
            {
               _loc2_ = _loc4_.GetWorldCenter().Copy();
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function GetBodyAngleFromLinearVelocity(param1:int) : Number
      {
         var _loc2_:b2Vec2 = new b2Vec2(0,0);
         var _loc3_:b2Body = this.bodies[param1];
         var _loc4_:b2Vec2 = _loc3_.GetLinearVelocity();
         return Math.atan2(_loc4_.y,_loc4_.x);
      }
      
      public function GetBodyLinearVelocity(param1:int) : b2Vec2
      {
         var _loc2_:b2Vec2 = new b2Vec2(0,0);
         var _loc3_:b2Body = this.bodies[param1];
         return _loc3_.GetLinearVelocity();
      }
      
      public function AddJointReference(param1:b2Joint) : *
      {
         this.joints.push(param1);
      }
      
      public function RemoveJoints() : *
      {
         var _loc1_:b2Joint = null;
         if(this.joints == null)
         {
            return;
         }
         for each(_loc1_ in this.joints)
         {
            if(_loc1_ != null)
            {
               PhysicsBase.world.DestroyJoint(_loc1_);
            }
         }
         this.joints = new Array();
      }
      
      public function RemovePhysObj() : *
      {
         var _loc1_:b2Body = null;
         for each(_loc1_ in this.bodies)
         {
            PhysicsBase.world.DestroyBody(_loc1_);
         }
      }
      
      internal function RemoveObject(param1:Function = null) : *
      {
         if(param1 != null)
         {
            this.removeFunction = param1;
         }
         this.killed = true;
      }
      
      public function GetBodyMass(param1:int) : Number
      {
         var _loc2_:b2Body = this.bodies[param1];
         return _loc2_.GetMass();
      }
      
      public function GetBodyWorldCenter(param1:int) : b2Vec2
      {
         var _loc2_:b2Body = this.bodies[param1];
         return _loc2_.GetWorldCenter();
      }
      
      public function ApplyImpulse(param1:Number, param2:Number) : void
      {
         var _loc3_:b2Body = null;
         for each(_loc3_ in this.bodies)
         {
            _loc3_.ApplyImpulse(new b2Vec2(param1,param2),_loc3_.GetWorldCenter());
         }
      }
      
      public function ApplyForce(param1:Number, param2:Number) : void
      {
         var _loc3_:b2Body = null;
         for each(_loc3_ in this.bodies)
         {
            _loc3_.ApplyForce(new b2Vec2(param1,param2),_loc3_.GetWorldCenter());
         }
      }
      
      public function ApplyImpulseRotSpeed(param1:Number, param2:Number) : void
      {
         var _loc5_:b2Body = null;
         var _loc3_:Number = Math.cos(param1) * param2;
         var _loc4_:Number = Math.sin(param1) * param2;
         for each(_loc5_ in this.bodies)
         {
            _loc5_.ApplyImpulse(new b2Vec2(_loc3_,_loc4_),_loc5_.GetWorldCenter());
         }
      }
      
      public function SetBodyLinearVelocity(param1:int, param2:Number, param3:Number) : *
      {
         var _loc4_:b2Body = this.bodies[0];
         _loc4_.SetLinearVelocity(new b2Vec2(param2,param3));
      }
      
      public function SetBodyAngularVelocity(param1:int, param2:Number) : *
      {
         var _loc3_:b2Body = this.bodies[0];
         _loc3_.SetAngularVelocity(param2);
      }
      
      public function SetBodyAngle(param1:int, param2:Number) : *
      {
         var _loc3_:b2XForm = this.GetXForm(0);
         this.SetXForm(_loc3_.position.x,_loc3_.position.y,param2);
      }
      
      public function GetBodyAngle(param1:int) : Number
      {
         var _loc2_:b2Body = this.bodies[param1];
         return _loc2_.GetAngle();
      }
      
      public function SetXForm(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc5_:b2Body = null;
         var _loc4_:b2Vec2 = new b2Vec2(param1,param2);
         for each(_loc5_ in this.bodies)
         {
            _loc5_.SetXForm(_loc4_,param3);
         }
      }
      
      public function SetXFormRot(param1:Number) : void
      {
         var _loc2_:b2Body = this.bodies[0];
         var _loc3_:b2XForm = _loc2_.GetXForm();
         _loc2_.SetXForm(_loc3_.position,param1);
      }
      
      public function GetXForm(param1:int) : b2XForm
      {
         var _loc2_:b2Body = this.bodies[param1];
         return _loc2_.GetXForm();
      }
      
      public function SetBodyXForm(param1:int, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:b2Vec2 = new b2Vec2(param2,param3);
         var _loc6_:b2Body = this.bodies[param1];
         _loc6_.SetXForm(_loc5_,param4);
      }
      
      public function SetBodyFixed(param1:int, param2:Boolean) : void
      {
         var _loc3_:b2Body = null;
         if(param2 == false)
         {
            if(param1 != -1)
            {
               _loc3_ = this.bodies[param1];
               _loc3_.SetMassFromShapes();
            }
            else
            {
               for each(_loc3_ in this.bodies)
               {
                  _loc3_.SetMassFromShapes();
               }
            }
         }
         else if(param1 != -1)
         {
            _loc3_ = this.bodies[param1];
            _loc3_.PutToSleep();
            _loc3_.SetMass(new b2MassData());
         }
         else
         {
            for each(_loc3_ in this.bodies)
            {
               _loc3_.PutToSleep();
               _loc3_.SetMass(new b2MassData());
            }
         }
      }
      
      public function SetBodySensor(param1:Boolean) : *
      {
         var _loc2_:b2Body = null;
         var _loc3_:b2Shape = null;
         for each(_loc2_ in this.bodies)
         {
            _loc3_ = _loc2_.GetShapeList();
            while(_loc3_)
            {
               _loc3_.m_isSensor = param1;
               _loc3_ = _loc3_.GetNext();
            }
         }
      }
      
      public function SetBodyCollisionMask(param1:int, param2:int) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Shape = null;
         var _loc5_:b2FilterData = null;
         if(param1 == -1)
         {
            for each(_loc3_ in this.bodies)
            {
               _loc4_ = _loc3_.GetShapeList();
               while(_loc4_)
               {
                  _loc5_ = _loc4_.GetFilterData();
                  _loc5_.maskBits = param2;
                  _loc4_.SetFilterData(_loc5_);
                  PhysicsBase.world.Refilter(_loc4_);
                  _loc4_ = _loc4_.GetNext();
               }
            }
         }
         else
         {
            _loc3_ = this.bodies[param1];
            _loc4_ = _loc3_.GetShapeList();
            while(_loc4_)
            {
               _loc5_ = _loc4_.GetFilterData();
               _loc5_.maskBits = param2;
               _loc4_.SetFilterData(_loc5_);
               PhysicsBase.world.Refilter(_loc4_);
               _loc4_ = _loc4_.GetNext();
            }
         }
      }
      
      public function SetBodyCollisionMask_Special(param1:int, param2:int) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Shape = null;
         var _loc5_:b2FilterData = null;
         if(param1 == -1)
         {
            for each(_loc3_ in this.bodies)
            {
               _loc4_ = _loc3_.GetShapeList();
               while(_loc4_)
               {
                  _loc4_.GetUserData();
                  _loc5_ = _loc4_.GetFilterData();
                  _loc5_.maskBits = param2;
                  _loc4_.SetFilterData(_loc5_);
                  PhysicsBase.world.Refilter(_loc4_);
                  _loc4_ = _loc4_.GetNext();
               }
            }
         }
         else
         {
            _loc3_ = this.bodies[param1];
            _loc4_ = _loc3_.GetShapeList();
            while(_loc4_)
            {
               _loc5_ = _loc4_.GetFilterData();
               _loc5_.maskBits = param2;
               _loc4_.SetFilterData(_loc5_);
               PhysicsBase.world.Refilter(_loc4_);
               _loc4_ = _loc4_.GetNext();
            }
         }
      }
      
      public function GetBodyCollisionMask(param1:int) : uint
      {
         var _loc2_:b2Body = null;
         var _loc3_:b2Shape = null;
         var _loc4_:b2FilterData = null;
         _loc2_ = this.bodies[param1];
         _loc3_ = _loc2_.GetShapeList();
         if(!_loc3_)
         {
            return 0;
         }
         _loc4_ = _loc3_.GetFilterData();
         return _loc4_.maskBits;
      }
      
      internal function HitPhysObj_HitSwitch(param1:GameObj) : *
      {
         if(param1.name != "missile")
         {
            return;
         }
         if(this.doSwitchFunction != null)
         {
            Utils.trace("doing switch ");
            if(this.doSwitchFunction())
            {
               Utils.trace("switch hit");
               SoundPlayer.Play("sfx_switch");
               Game.DoSwitch(this as GameObj);
            }
         }
      }
      
      internal function InitPhysObj_HitSwitch() : *
      {
         this.InitPhysObj_Switch();
         this.onHitFunction = this.HitPhysObj_HitSwitch;
      }
      
      internal function InitPhysObj_Switch() : *
      {
         Utils.GetParams(this.initParams);
         var _loc1_:String = Utils.GetParam("type");
         if(_loc1_ == "")
         {
            _loc1_ = "once";
         }
         if(_loc1_ == "once")
         {
            this.doSwitchFunction = this.SwitchedPhysObj_Switch;
            this.updateFunction = this.UpdatePhysObj_SwitchOnce;
            this.state = 0;
         }
         if(_loc1_ == "timed")
         {
            this.switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;
            this.doSwitchFunction = this.SwitchedPhysObj_TimedSwitch;
            this.updateFunction = this.UpdatePhysObj_TimedSwitch;
         }
         if(_loc1_ == "2way")
         {
            this.doSwitchFunction = this.SwitchedPhysObj_TwoWaySwitch;
            this.updateFunction = this.UpdatePhysObj_TwoWaySwitch;
            this.state = 0;
         }
         this.frame = 0;
      }
      
      internal function SwitchedPhysObj_TwoWaySwitch() : Boolean
      {
         if(this.state == 0)
         {
            this.state = 1;
            this.timer = 10;
            return true;
         }
         return false;
      }
      
      internal function SwitchedPhysObj_TwoWaySwitch_Anim() : Boolean
      {
         SoundPlayer.Play("sfx_click");
         if(this.state == 0)
         {
            Utils.trace("2way 0");
            if(this.frame == this.minFrame)
            {
               this.state = 1;
               return true;
            }
         }
         else
         {
            Utils.trace("2way 0");
            if(this.frame == this.maxFrame)
            {
               this.state = 0;
               return true;
            }
         }
         return false;
      }
      
      internal function UpdatePhysObj_TwoWaySwitch() : *
      {
         if(this.state == 0)
         {
            this.frame = 0;
         }
         else
         {
            this.frame = 1;
            --this.timer;
            if(this.timer <= 0)
            {
               this.state = 0;
            }
         }
      }
      
      internal function SwitchedPhysObj_Switch() : Boolean
      {
         Utils.trace("SwitchedPhysObj_Switch");
         if(this.state == 1)
         {
            return false;
         }
         this.state = 1;
         Game.DoSwitch(this as GameObj);
         SoundPlayer.Play("sfx_click");
         this.frame = 1;
         return true;
      }
      
      internal function UpdatePhysObj_SwitchOnce() : *
      {
         if(this.state != 0)
         {
            if(this.state == 1)
            {
               this.frame = 1;
            }
         }
      }
      
      internal function UpdatePhysObj_TimedSwitch() : *
      {
         if(this.state == 1)
         {
            --this.timer;
            if(this.timer <= 0)
            {
               SoundPlayer.Play("sfx_click");
               Game.DoSwitch(this as GameObj);
               this.state = 0;
            }
         }
      }
      
      internal function SwitchedPhysObj_TimedSwitch() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.state == 0)
         {
            this.state = 1;
            this.timer = this.switch_timer;
            SoundPlayer.Play("sfx_click");
            _loc1_ = true;
         }
         else
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      internal function InitPhysObj_PathSwitch() : *
      {
         this.InitPhysObj_Path();
         this.onHitFunction = this.HitPhysObj_HitSwitch;
         this.pathSwitchTimer = 0;
         this.pathSwitchControlMode = 0;
         this.updateFunction1 = this.updateFunction;
         var _loc1_:String = Utils.GetParam("type");
         if(_loc1_ == "")
         {
            _loc1_ = "once";
         }
         if(_loc1_ == "once")
         {
            this.pathSwitchDoneOnce = false;
            this.doSwitchFunction = this.SwitchedPhysObj_PathSwitch_Once;
            this.updateFunction = this.UpdatePhysObj_PathSwitch_Once;
         }
         if(_loc1_ == "timed")
         {
            this.switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;
            this.updateFunction = this.UpdatePhysObj_PathSwitch_Once;
         }
         if(_loc1_ == "2way")
         {
            this.doSwitchFunction = this.SwitchedPhysObj_PathSwitch_TwoWay;
            this.updateFunction = this.UpdatePhysObj_PathSwitch_TwoWay;
         }
      }
      
      internal function SwitchedPhysObj_PathSwitch_TwoWay() : Boolean
      {
         if(this.pathSwitchControlMode != 0)
         {
            return false;
         }
         this.pathSwitchTimer = 20;
         this.pathSwitchControlMode = 1;
         SoundPlayer.Play("sfx_platform_click");
         return true;
      }
      
      internal function SwitchedPhysObj_PathSwitch_Once() : Boolean
      {
         if(this.pathSwitchDoneOnce)
         {
            return false;
         }
         if(this.pathSwitchControlMode == 0)
         {
            this.pathSwitchControlMode = 1;
         }
         else
         {
            this.pathSwitchControlMode = 0;
         }
         SoundPlayer.Play("sfx_platform_click");
         this.pathSwitchDoneOnce = true;
         return true;
      }
      
      internal function UpdatePhysObj_PathSwitch_TwoWay() : *
      {
         this.updateFunction1();
         if(this.pathSwitchControlMode == 0)
         {
            this.frame = 1;
         }
         else if(this.pathSwitchControlMode == 1)
         {
            this.frame = 0;
            --this.pathSwitchTimer;
            if(this.pathSwitchTimer <= 0)
            {
               this.pathSwitchControlMode = 0;
            }
         }
      }
      
      internal function UpdatePhysObj_PathSwitch_Once() : *
      {
         this.updateFunction1();
         if(this.pathSwitchControlMode != 0)
         {
            if(this.pathSwitchControlMode == 1)
            {
               --this.pathSwitchTimer;
               if(this.pathSwitchTimer <= 0)
               {
                  this.pathSwitchControlMode = 0;
               }
            }
         }
         this.frame = 1;
         if(this.pathSwitchDoneOnce)
         {
            this.frame = 2;
         }
      }
      
      internal function InitPhysObj_Path() : *
      {
         Utils.trace("Init path object");
         Utils.GetParams(this.initParams);
         var _loc1_:int = 0;
         while(_loc1_ < Utils.paramNames.length)
         {
            Utils.trace("Param " + _loc1_ + ":  " + Utils.paramNames[_loc1_] + "   =   " + Utils.paramValues[_loc1_]);
            _loc1_++;
         }
         var _loc2_:String = Utils.GetParam("path_line","");
         if(_loc2_ == "")
         {
            this.lineIndex = -1;
         }
         else
         {
            this.lineIndex = this.GetLineIndexByName(_loc2_);
         }
         if(this.lineIndex == -1)
         {
            this.updateFunction = null;
         }
         this.dir = this.GetBodyAngle(0);
         this.lineSpeed = 1 / (Utils.GetParamNumber("path_speed") * Defs.fps);
         this.lineLoop = Utils.GetParamBool("path_loop");
         this.switchName = Utils.GetParam("path_switch","");
         this.lineResetAtEnd = Utils.GetParamBool("path_endreset");
         this.lineSpline = Utils.GetParamBool("spath_pline");
         this.lineRotateToPath = Utils.GetParamBool("path_rotatetopath",false);
         var _loc3_:Boolean = Utils.GetParamBool("path_startmoving",true);
         this.lineLinearPos = 0;
         var _loc4_:Number = Utils.GetParamNumber("path_startpos",0);
         this.lineLinearPos = _loc4_;
         var _loc5_:Boolean = Utils.GetParamBool("path_2way");
         this.pathControlMode = 0;
         this.switchFunction = null;
         this.updateFunction = null;
         if(this.lineIndex != -1)
         {
            if(this.switchName != "")
            {
               this.pathControlMode = 0;
               this.switchFunction = this.SwitchFunction_PhysObj_Path;
            }
            else
            {
               this.pathControlMode = 1;
            }
            this.updateFunction = this.UpdatePhysObj_Path;
         }
         if(_loc5_)
         {
            this.updateFunction = this.UpdatePhysObj_Path_2way;
            if(this.switchName != "")
            {
               this.switchFunction = this.SwitchFunction_PhysObj_Path_2way;
               this.updateFunction = this.UpdatePhysObj_Path_2way_switched;
            }
         }
         if(_loc3_)
         {
            this.pathControlMode = 1;
         }
      }
      
      internal function SwitchFunction_PhysObj_Path_2way() : *
      {
         if(this.pathControlMode == 0)
         {
            this.pathControlMode = 1;
         }
         else if(this.pathControlMode == 1)
         {
            this.pathControlMode = 2;
         }
         else
         {
            this.pathControlMode = 1;
         }
      }
      
      internal function UpdatePhysObj_Path_2way() : *
      {
         var _loc1_:Point = null;
         if(this.lineRotateToPath)
         {
            this.dir = this.GetLineAngle();
         }
         if(this.pathControlMode == 0)
         {
            this.pathControlMode = 1;
         }
         if(this.pathControlMode == 1)
         {
            _loc1_ = this.UpdateLine(this.lineSpeed);
            this.SetBodyXForm(0,_loc1_.x * PhysicsBase.w2p,_loc1_.y * PhysicsBase.w2p,this.dir);
            if(this.lineLinearPos >= 1)
            {
               this.pathControlMode = 2;
            }
         }
         else if(this.pathControlMode == 2)
         {
            _loc1_ = this.UpdateLine(-this.lineSpeed);
            this.SetBodyXForm(0,_loc1_.x * PhysicsBase.w2p,_loc1_.y * PhysicsBase.w2p,this.dir);
            if(this.lineLinearPos <= 0)
            {
               this.pathControlMode = 1;
            }
         }
      }
      
      internal function UpdatePhysObj_Path_2way_switched() : *
      {
         var _loc1_:Point = null;
         if(this.lineRotateToPath)
         {
            this.dir = this.GetLineAngle();
         }
         if(this.pathControlMode == 0)
         {
            _loc1_ = this.UpdateLine(0);
            this.SetBodyXForm(0,_loc1_.x * PhysicsBase.w2p,_loc1_.y * PhysicsBase.w2p,this.dir);
         }
         else if(this.pathControlMode == 1)
         {
            _loc1_ = this.UpdateLine(this.lineSpeed);
            this.SetBodyXForm(0,_loc1_.x * PhysicsBase.w2p,_loc1_.y * PhysicsBase.w2p,this.dir);
         }
         else if(this.pathControlMode == 2)
         {
            _loc1_ = this.UpdateLine(-this.lineSpeed);
            this.SetBodyXForm(0,_loc1_.x * PhysicsBase.w2p,_loc1_.y * PhysicsBase.w2p,this.dir);
         }
      }
      
      internal function SwitchFunction_PhysObj_Path() : *
      {
         if(this.pathControlMode == 0)
         {
            this.pathControlMode = 1;
         }
         else
         {
            this.pathControlMode = 0;
         }
      }
      
      internal function UpdatePhysObj_Path() : *
      {
         var _loc1_:Point = null;
         if(this.lineRotateToPath)
         {
            this.dir = this.GetLineAngle();
         }
         if(this.pathControlMode == 0)
         {
            _loc1_ = this.UpdateLine(0);
            this.SetBodyXForm(0,_loc1_.x * PhysicsBase.w2p,_loc1_.y * PhysicsBase.w2p,this.dir);
         }
         else
         {
            _loc1_ = this.UpdateLine(this.lineSpeed);
            this.SetBodyXForm(0,_loc1_.x * PhysicsBase.w2p,_loc1_.y * PhysicsBase.w2p,this.dir);
            if(this.lineLoop == false)
            {
               if(this.lineLinearPos >= 1)
               {
                  this.lineLinearPos = 1;
                  if(this.lineResetAtEnd)
                  {
                     this.lineLinearPos = 0;
                  }
                  this.pathControlMode = 0;
               }
            }
         }
      }
      
      internal function GetLineIndexByName(param1:String) : int
      {
         var _loc4_:PhysLine = null;
         var _loc2_:Level = Levels.GetCurrent();
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_.lines)
         {
            if(_loc4_.id == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      internal function RenderPhysicsLineObjectInner() : *
      {
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc15_:Point = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:Matrix = null;
         var _loc20_:int = 0;
         var _loc21_:DisplayObj = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
         var _loc1_:Number = Math.round(this.xpos);
         var _loc2_:Number = Math.round(this.ypos);
         _loc1_ -= Math.round(Game.camera.x);
         _loc2_ -= Math.round(Game.camera.y);
         var _loc3_:Graphics = Game.fillScreenMC.graphics;
         _loc3_.clear();
         var _loc4_:Number = Math.round(Game.camera.x);
         var _loc5_:Number = Math.round(Game.camera.y);
         var _loc6_:int = this.zpos;
         var _loc7_:Matrix = new Matrix();
         _loc7_.translate(-_loc4_,-_loc5_);
         var _loc10_:Array = new Array();
         var _loc11_:Matrix = new Matrix();
         _loc11_.rotate(this.dir);
         var _loc12_:Number = Game.camera.scale;
         var _loc13_:Rectangle = new Rectangle(0,0,1,1);
         var _loc14_:int = 0;
         for each(_loc15_ in this.linkedPhysLine.points)
         {
            _loc8_ = _loc15_.clone();
            _loc8_.x -= this.linkedPhysLine.centrex;
            _loc8_.y -= this.linkedPhysLine.centrey;
            _loc8_ = _loc11_.transformPoint(_loc8_);
            _loc8_.x += this.xpos;
            _loc8_.y += this.ypos;
            _loc8_.x -= _loc4_;
            _loc8_.y -= _loc5_;
            _loc8_.x *= _loc12_;
            _loc8_.y *= _loc12_;
            _loc10_.push(_loc8_);
            if(_loc14_ == 0)
            {
               _loc13_ = new Rectangle(_loc8_.x,_loc8_.y,1,1);
            }
            else
            {
               if(_loc8_.x < _loc13_.left)
               {
                  _loc13_.left = _loc8_.x;
               }
               if(_loc8_.x > _loc13_.right)
               {
                  _loc13_.right = _loc8_.x;
               }
               if(_loc8_.y < _loc13_.top)
               {
                  _loc13_.top = _loc8_.y;
               }
               if(_loc8_.y > _loc13_.bottom)
               {
                  _loc13_.bottom = _loc8_.y;
               }
            }
            _loc14_++;
         }
         _loc3_.lineStyle(2,this.lineRender_Color,1);
         _loc3_.beginBitmapFill(this.dobj.GetBitmapData(this.frame),_loc7_,true);
         _loc16_ = new Array(this.lineRender_Color0,this.lineRender_Color1);
         _loc17_ = new Array(1,1);
         _loc18_ = new Array(0,255);
         _loc19_ = new Matrix();
         _loc19_.createGradientBox(_loc13_.width,_loc13_.height,0,_loc13_.x,_loc13_.y);
         _loc3_.lineStyle(null,null,0);
         if(this.name == "line_for_show")
         {
            _loc3_.lineStyle(2,16777215,1);
            _loc9_ = _loc10_[0].clone();
            _loc3_.moveTo(_loc9_.x,_loc9_.y);
            _loc20_ = 1;
            while(_loc20_ < _loc10_.length)
            {
               _loc8_ = _loc10_[_loc20_];
               _loc3_.lineTo(_loc8_.x,_loc8_.y);
               _loc20_++;
            }
            this.bd.draw(Game.fillScreenMC,null,null,null,null,false);
            return;
         }
         _loc9_ = _loc10_[0].clone();
         _loc3_.moveTo(_loc9_.x,_loc9_.y);
         _loc20_ = 1;
         while(_loc20_ < _loc10_.length)
         {
            _loc8_ = _loc10_[_loc20_].clone();
            _loc3_.lineTo(_loc8_.x,_loc8_.y);
            _loc20_++;
         }
         _loc3_.lineTo(_loc9_.x,_loc9_.y);
         _loc3_.endFill();
         this.bd.draw(Game.fillScreenMC,null,null,null,null,false);
         if(this.name == "death")
         {
            _loc21_ = GraphicObjects.GetDisplayObjByName("terrainSpikes");
            _loc22_ = _loc21_.GetNumFrames() - 1;
            Utils.RandSetSeed(123456789101112);
            _loc23_ = 0;
            while(_loc23_ < _loc10_.length)
            {
               _loc24_ = _loc23_ + 1;
               if(_loc24_ >= _loc10_.length)
               {
                  _loc24_ = 0;
               }
               _loc8_ = _loc10_[_loc23_].clone();
               _loc9_ = _loc10_[_loc24_].clone();
               _loc25_ = _loc9_.x - _loc8_.x;
               _loc26_ = _loc9_.y - _loc8_.y;
               _loc27_ = Math.abs(_loc25_);
               _loc28_ = Math.abs(_loc26_);
               _loc29_ = Math.atan2(_loc26_,_loc25_);
               _loc30_ = Utils.DistBetweenPoints(_loc8_.x,_loc8_.y,_loc9_.x,_loc9_.y);
               _loc31_ = 7;
               _loc32_ = _loc30_ / _loc31_;
               _loc25_ /= _loc32_;
               _loc26_ /= _loc32_;
               _loc20_ = 0;
               while(_loc20_ < _loc32_)
               {
                  _loc8_.x += _loc25_;
                  _loc8_.y += _loc26_;
                  _loc15_ = _loc8_.clone();
                  _loc15_.x += Utils.RandBetweenFloat_Seeded(-1,1);
                  _loc15_.y += Utils.RandBetweenFloat_Seeded(-1,1);
                  _loc33_ = Utils.RandBetweenInt_Seeded(0,_loc22_);
                  _loc21_.RenderAtRotScaled(_loc33_,this.bd,_loc15_.x,_loc15_.y,1,_loc29_,null,true);
                  _loc20_++;
               }
               _loc23_++;
            }
         }
         if(this.name == "grass")
         {
            _loc21_ = GraphicObjects.GetDisplayObjByName("grass");
            _loc22_ = _loc21_.GetNumFrames() - 1;
            Utils.RandSetSeed(123456789101112);
            _loc23_ = 0;
            while(_loc23_ < _loc10_.length)
            {
               _loc24_ = _loc23_ + 1;
               if(_loc24_ >= _loc10_.length)
               {
                  _loc24_ = 0;
               }
               _loc8_ = _loc10_[_loc23_].clone();
               _loc9_ = _loc10_[_loc24_].clone();
               _loc25_ = _loc9_.x - _loc8_.x;
               _loc26_ = _loc9_.y - _loc8_.y;
               _loc27_ = Math.abs(_loc25_);
               _loc28_ = Math.abs(_loc26_);
               if(_loc8_.x < _loc9_.x && _loc27_ > _loc28_)
               {
                  _loc30_ = Utils.DistBetweenPoints(_loc8_.x,_loc8_.y,_loc9_.x,_loc9_.y);
                  _loc31_ = 3;
                  _loc32_ = _loc30_ / _loc31_;
                  _loc25_ /= _loc32_;
                  _loc26_ /= _loc32_;
                  _loc20_ = 0;
                  while(_loc20_ < _loc32_)
                  {
                     _loc8_.x += _loc25_;
                     _loc8_.y += _loc26_;
                     _loc15_ = _loc8_.clone();
                     _loc15_.x += Utils.RandBetweenFloat_Seeded(-1,1);
                     _loc15_.y += Utils.RandBetweenFloat_Seeded(2,6);
                     _loc33_ = Utils.RandBetweenInt_Seeded(0,_loc22_);
                     _loc21_.RenderAt(_loc33_,this.bd,_loc15_.x,_loc15_.y);
                     _loc20_++;
                  }
               }
               else
               {
                  _loc25_ = _loc9_.x - _loc8_.x;
                  _loc26_ = _loc9_.y - _loc8_.y;
                  _loc30_ = Utils.DistBetweenPoints(_loc8_.x,_loc8_.y,_loc9_.x,_loc9_.y);
                  _loc31_ = 3;
                  _loc32_ = _loc30_ / _loc31_;
                  _loc25_ /= _loc32_;
                  _loc26_ /= _loc32_;
                  _loc20_ = 0;
                  while(_loc20_ < _loc32_)
                  {
                     _loc8_.x += _loc25_;
                     _loc8_.y += _loc26_;
                     _loc15_ = _loc8_.clone();
                     _loc15_.x += Utils.RandBetweenFloat_Seeded(-1,1);
                     _loc15_.y += Utils.RandBetweenFloat_Seeded(0,2);
                     _loc34_ = _loc15_.x;
                     _loc35_ = _loc15_.y;
                     _loc36_ = Utils.RandBetweenInt(1,2);
                     if(_loc36_ != 0)
                     {
                        if(_loc36_ == 1)
                        {
                           this.bd.setPixel32(_loc34_,_loc35_,0);
                           this.bd.setPixel32(_loc34_ + 1,_loc35_,0);
                           this.bd.setPixel32(_loc34_,_loc35_ + 1,0);
                           this.bd.setPixel32(_loc34_ + 1,_loc35_ + 1,0);
                        }
                        else if(_loc36_ == 2)
                        {
                           this.bd.setPixel32(_loc34_ - 1,_loc35_ - 1,0);
                           this.bd.setPixel32(_loc34_ - 1,_loc35_ + 1,0);
                           this.bd.setPixel32(_loc34_ + 1,_loc35_ - 1,0);
                           this.bd.setPixel32(_loc34_ + 1,_loc35_ + 1,0);
                           this.bd.setPixel32(_loc34_,_loc35_,0);
                        }
                     }
                     _loc20_++;
                  }
               }
               _loc23_++;
            }
         }
      }
      
      internal function RenderPhysicsLineObjectInner_Shadow() : *
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc1_:Number = this.xpos - Game.camera.x;
         var _loc2_:Number = this.ypos - Game.camera.y;
         var _loc3_:Graphics = Game.fillScreenMC.graphics;
         _loc3_.clear();
         var _loc6_:Array = new Array();
         var _loc7_:Matrix = new Matrix();
         _loc7_.rotate(this.dir);
         for each(_loc8_ in this.linkedPhysLine.points)
         {
            _loc4_ = _loc8_.clone();
            _loc4_.x -= this.linkedPhysLine.centrex;
            _loc4_.y -= this.linkedPhysLine.centrey;
            _loc4_ = _loc7_.transformPoint(_loc4_);
            _loc4_.x += this.xpos;
            _loc4_.y += this.ypos;
            _loc6_.push(_loc4_);
         }
         _loc3_.lineStyle(null,null,0);
         _loc3_.beginFill(0,1);
         _loc5_ = _loc6_[0].clone();
         _loc3_.moveTo(_loc5_.x,_loc5_.y);
         _loc9_ = 1;
         while(_loc9_ < _loc6_.length)
         {
            _loc4_ = _loc6_[_loc9_].clone();
            _loc3_.lineTo(_loc4_.x,_loc4_.y);
            _loc9_++;
         }
         _loc3_.lineTo(_loc5_.x,_loc5_.y);
         _loc3_.endFill();
      }
      
      internal function RenderPhysicsLineObjectShadow() : *
      {
         this.RenderPhysicsLineObjectInner();
         var _loc1_:Matrix = new Matrix();
         _loc1_.translate(Game.shadowOffsetX,Game.shadowOffsetY);
         this.bd.draw(Game.fillScreenMC,_loc1_,this.shadowCT,null,null,false);
      }
      
      internal function RenderPhysicsLineObject() : *
      {
         if(this.invisibleTimer == 0)
         {
            this.RenderPhysicsLineObjectInner();
         }
         this.RenderInvisibleBar(0,0);
      }
      
      internal function UpdatePhysicsLineObject() : *
      {
      }
      
      internal function InitPhysicsLineObject(param1:PhysLine, param2:b2Body) : *
      {
         this.isPolyObject = true;
         this.bodies = new Vector.<b2Body>();
         this.bodies.push(param2);
         this.linkedPhysLine = param1;
         Utils.trace("InitPhysicsLineObject: " + this.linkedPhysLine.id);
         this.visible = true;
         this.updateFunction = this.UpdatePhysicsLineObject;
         this.renderFunction = this.RenderPhysicsLineObject;
         this.lineRender_Mode = "";
         this.lineRender_Color = 8421504;
         this.lineRender_LineColor = 160;
         this.lineRender_LineAlpha = 1;
         this.lineRender_lineThickness = 0;
         this.renderShadowFunction = this.RenderPhysicsLineObjectShadow;
         this.renderShadowFlag = true;
         this.dobj = GraphicObjects.GetDisplayObjByName("fill");
         this.frame = 0;
         var _loc3_:String = this.linkedPhysLine.objParameters.GetValueString("line_function");
         if(_loc3_ != null && _loc3_ != "")
         {
            this[_loc3_]();
         }
      }
      
      internal function UpdateInvisibleTimer() : Boolean
      {
         if(this.invisibleTimer == 0)
         {
            return false;
         }
         --this.invisibleTimer;
         if(this.invisibleTimer <= 0)
         {
            this.invisibleTimer = 0;
            return true;
         }
         return false;
      }
      
      internal function InitInvisibleTimer() : *
      {
         this.invisibleTimer = this.invisibleTimerMax = 0;
      }
      
      internal function SetInvisibleTimer(param1:int) : *
      {
         this.invisibleTimer = this.invisibleTimerMax = param1;
      }
      
      internal function RenderInvisibleBar(param1:Number, param2:Number) : *
      {
         if(this.invisibleTimer == 0)
         {
            return;
         }
         var _loc3_:int = 30;
         var _loc4_:int = 5;
         var _loc5_:Rectangle = new Rectangle(this.xpos + param1 + -_loc3_ / 2,this.ypos + param2,_loc3_,_loc4_);
         this.bd.fillRect(_loc5_,4278190080);
         _loc5_.width = Utils.ScaleTo(0,_loc3_,0,this.invisibleTimerMax,this.invisibleTimer);
         this.bd.fillRect(_loc5_,4294901760);
      }
      
      internal function InitGameObjJoint_Null(param1:b2Joint) : *
      {
         this.jointController_joint = null;
         this.visible = false;
      }
      
      internal function SwitchOnceHit(param1:GameObj) : *
      {
         if(this.state != 0)
         {
            return false;
         }
         if(param1.name.search("missile") == -1)
         {
            return;
         }
         this.state = 1;
         this.frame = 1;
         return true;
      }
      
      internal function UpdateSwitchOnce() : *
      {
         if(this.state != 0)
         {
            if(this.state == 1)
            {
               Game.DoSwitch(this);
               this.frame = 1;
               this.state = 2;
            }
         }
      }
      
      internal function InitSwitch_Once() : *
      {
         Utils.GetParams(this.initParams);
         this.switchType = "once";
         this.onHitFunction = this.SwitchOnceHit;
         this.updateFunction = this.UpdateSwitchOnce;
         this.state = 0;
      }
      
      internal function Switch2WayHit(param1:GameObj) : *
      {
         if(this.state != 0)
         {
            return false;
         }
         if(param1.name.search("missile") == -1)
         {
            return;
         }
         if(this.timer > 0)
         {
            return;
         }
         this.timer = 3;
         if(this.switchFlag == false)
         {
            this.state = 1;
         }
         else
         {
            this.state = 2;
         }
         return true;
      }
      
      internal function UpdateSwitch2Way() : *
      {
         if(this.state != 0)
         {
            if(this.state == 1)
            {
               Game.DoSwitch(this);
               this.frame = 1;
               this.switchFlag = true;
               this.state = 0;
            }
            else if(this.state == 2)
            {
               Game.DoSwitch(this);
               this.frame = 0;
               this.switchFlag = false;
               this.state = 0;
            }
         }
         --this.timer;
         if(this.timer <= 0)
         {
            this.timer = 0;
         }
      }
      
      internal function InitSwitch_2Way() : *
      {
         Utils.GetParams(this.initParams);
         this.switchType = "once";
         this.onHitFunction = this.Switch2WayHit;
         this.updateFunction = this.UpdateSwitch2Way;
         this.state = 0;
         this.switchFlag = false;
         this.timer = 0;
      }
      
      internal function SwitchTimerHit(param1:GameObj) : *
      {
         if(this.state != 0)
         {
            return false;
         }
         Utils.trace("SwitchTimerHit");
         this.state = 1;
         this.timer = this.switch_timer;
         return true;
      }
      
      internal function UpdateSwitchTimer() : *
      {
         if(this.state != 0)
         {
            if(this.state == 1)
            {
               Game.DoSwitch(this);
               this.frame = 1;
               this.state = 2;
               this.timer1 = 8;
               this.switchFlag = true;
            }
            else if(this.state == 2)
            {
               this.minFrame = 1;
               this.maxFrame = this.dobj.GetNumFrames() - 1;
               this.frame = int(Utils.ScaleTo(this.minFrame,this.maxFrame,0,this.switch_timer,this.timer));
               --this.timer;
               if(this.timer <= 0)
               {
                  Game.DoSwitch(this);
                  this.frame = 0;
                  this.state = 0;
                  this.switchFlag = false;
               }
               --this.timer1;
               if(this.timer1 <= 0)
               {
                  SoundPlayer.Play("sfx_tick");
                  this.timer1 = 8;
               }
            }
         }
      }
      
      internal function InitSwitch_Timer() : *
      {
         Utils.GetParams(this.initParams);
         this.switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;
         this.switchType = "timer";
         this.onHitFunction = this.SwitchTimerHit;
         this.updateFunction = this.UpdateSwitchTimer;
         this.state = 0;
         this.switchFlag = false;
      }
      
      internal function Switchable_Disappear_Switched() : *
      {
         if(this.state != 0)
         {
            return;
         }
         if(this.switchFlag == false)
         {
            this.state = 1;
         }
         else
         {
            this.state = 2;
         }
      }
      
      internal function UpdateSwitchable_Disappear() : *
      {
         if(this.state == 0)
         {
            this.PlayAnimation();
         }
         else if(this.state == 1)
         {
            this.SetBodyCollisionMask(0,0);
            this.state = 0;
            this.switchFlag = true;
            this.frameVel = 1;
         }
         else if(this.state == 2)
         {
            this.SetBodyCollisionMask(0,15);
            this.state = 0;
            this.switchFlag = false;
            this.frameVel = -1;
         }
      }
      
      internal function InitSwitchable_Disappear() : *
      {
         this.frameVel = -1;
         Utils.GetParams(this.initParams);
         this.switchName = Utils.GetParamString("switch_name","");
         this.updateFunction = this.UpdateSwitchable_Disappear;
         this.switchFunction = this.Switchable_Disappear_Switched;
         this.switchFlag = false;
      }
      
      internal function RenderJointRenderer() : *
      {
         var _loc5_:int = 0;
         var _loc6_:b2Body = null;
         var _loc7_:b2Shape = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         var _loc10_:b2Joint = null;
         var _loc13_:int = 0;
         var _loc14_:b2DistanceJoint = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:Point = null;
         var _loc18_:Point = null;
         var _loc19_:Number = NaN;
         var _loc1_:Graphics = Game.fillScreenMC.graphics;
         _loc1_.clear();
         var _loc2_:Number = Game.camera.x;
         var _loc3_:Number = Game.camera.y;
         var _loc4_:Number = PhysicsBase.p2w;
         var _loc11_:Matrix = new Matrix();
         var _loc12_:DisplayObj = GraphicObjects.GetDisplayObjByName("distance_fills");
         _loc10_ = PhysicsBase.world.GetJointList();
         while(_loc10_)
         {
            _loc13_ = _loc10_.GetType();
            if(_loc13_ == b2Joint.e_distanceJoint)
            {
               _loc14_ = b2DistanceJoint(_loc10_);
               _loc15_ = _loc14_.GetAnchor1();
               _loc16_ = _loc14_.GetAnchor2();
               _loc17_ = new Point(_loc15_.x * _loc4_ - _loc2_,_loc15_.y * _loc4_ - _loc3_);
               _loc18_ = new Point(_loc16_.x * _loc4_ - _loc2_,_loc16_.y * _loc4_ - _loc3_);
               _loc11_.identity();
               _loc19_ = Math.atan2(_loc18_.y - _loc17_.y,_loc18_.x - _loc17_.x);
               _loc11_.rotate(_loc19_ - Math.PI / 2);
               _loc11_.translate(_loc17_.x,_loc17_.y);
               _loc1_.lineStyle(6,16777215,1);
               _loc1_.lineBitmapStyle(_loc12_.GetBitmapData(0),_loc11_);
               _loc1_.moveTo(_loc17_.x,_loc17_.y);
               _loc1_.lineTo(_loc18_.x,_loc18_.y);
            }
            else if(_loc13_ != b2Joint.e_revoluteJoint)
            {
               if(_loc13_ == b2Joint.e_prismaticJoint)
               {
               }
            }
            _loc10_ = _loc10_.GetNext();
         }
         this.bd.draw(Game.fillScreenMC,null,null,null,null,false);
      }
      
      internal function InitJointRenderer() : *
      {
         this.renderFunction = this.RenderJointRenderer;
      }
   }
}

