package
{
   internal class Particle
   {
      
      internal var active:Boolean;
      
      internal var xpos:Number;
      
      internal var ypos:Number;
      
      internal var xpos1:Number;
      
      internal var ypos1:Number;
      
      internal var startx:Number;
      
      internal var starty:Number;
      
      internal var timer:Number;
      
      public var xvel:Number;
      
      public var yvel:Number;
      
      internal var yacc:Number;
      
      internal var graphicID:int;
      
      internal var frame:Number;
      
      internal var frameVel:Number;
      
      internal var speed:Number;
      
      internal var dir:Number;
      
      internal var radius:Number;
      
      internal var dirVel:Number;
      
      internal var alpha:Number;
      
      internal var alphaAdd:Number;
      
      internal var maxframe:int;
      
      internal var counter:int;
      
      internal var visible:Boolean;
      
      internal var updateFunction:Function;
      
      internal var mode:int;
      
      internal var color:uint;
      
      internal var psize:uint;
      
      internal var angle:Number;
      
      internal var anglevel:Number;
      
      internal var dobj:DisplayObj;
      
      internal var velmul:Number;
      
      public function Particle()
      {
         super();
      }
      
      internal function UpdateVelsTimer() : *
      {
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         --this.timer;
         if(this.timer <= 0)
         {
            this.active = false;
         }
      }
      
      internal function UpdateAnimAndStop() : *
      {
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         if(this.PlayAnimation())
         {
            this.active = false;
         }
      }
      
      public function InitBloodSplat() : void
      {
         var _loc1_:Number = Utils.RandCircle();
         var _loc2_:Number = Utils.RandBetweenFloat(4,7);
         this.xvel = Math.cos(_loc1_) * _loc2_;
         this.yvel = Math.sin(_loc1_) * _loc2_;
         var _loc3_:int = Utils.RandBetweenInt(0,3);
         if(_loc3_ == 0)
         {
            this.color = 4285530112;
         }
         if(_loc3_ == 1)
         {
            this.color = 4286578688;
         }
         if(_loc3_ == 2)
         {
            this.color = 4287627264;
         }
         if(_loc3_ == 3)
         {
            this.color = 4288675840;
         }
         this.updateFunction = this.UpdateBloodSplat;
         this.timer = Utils.RandBetweenInt(30,50);
         this.dobj = GraphicObjects.GetDisplayObjByName("bloodsplat");
         this.frame = Utils.RandBetweenInt(0,this.dobj.GetNumFrames() - 1);
         this.angle = Utils.RandCircle();
         this.anglevel = Utils.RandBetweenFloat(-0.1,0.1);
         if(Levels.currentIndex == 40)
         {
            this.angle = 0;
            this.anglevel = 0;
         }
      }
      
      internal function RenderBloodSplat(param1:int, param2:int) : *
      {
         var _loc3_:int = param1;
         var _loc4_:int = param2;
         var _loc5_:uint = Game.scrollScreenBD.getPixel(_loc3_,_loc4_);
         if(_loc5_ != 0)
         {
            Game.scrollScreenBD.setPixel32(_loc3_,_loc4_,this.color);
         }
      }
      
      internal function UpdateBloodSplat() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         this.yvel += GameVars.gravity_GO;
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         this.angle += this.anglevel;
         var _loc1_:int = this.xpos - Game.boundingRectangle.left;
         var _loc2_:int = this.ypos - Game.boundingRectangle.top;
         var _loc3_:uint = Game.scrollScreenBD.getPixel(int(_loc1_),int(_loc2_));
         if(_loc3_ != 0)
         {
            SoundPlayer.PlayRandomBetween("sfx_splat1","sfx_splat5");
            this.active = false;
            _loc4_ = -4;
            while(_loc4_ < 4)
            {
               _loc5_ = -4;
               while(_loc5_ < 4)
               {
                  _loc6_ = false;
                  if(_loc4_ < -2 || _loc4_ > 2)
                  {
                     _loc6_ = true;
                  }
                  if(_loc5_ < -2 || _loc5_ > 2)
                  {
                     _loc6_ = true;
                  }
                  if(_loc6_)
                  {
                     if(Utils.RandBool())
                     {
                        this.RenderBloodSplat(_loc1_ + _loc4_,_loc2_ + _loc5_);
                     }
                  }
                  else
                  {
                     this.RenderBloodSplat(_loc1_ + _loc4_,_loc2_ + _loc5_);
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
         }
         --this.timer;
         if(this.timer <= 0)
         {
            this.active = false;
            this.timer = 0;
         }
      }
      
      public function InitTextBloodSplat() : void
      {
         var _loc1_:Number = Utils.RandCircle();
         var _loc2_:Number = Utils.RandBetweenFloat(1,4);
         this.xvel = Math.cos(_loc1_) * _loc2_;
         this.yvel = Math.sin(_loc1_) * _loc2_;
         this.updateFunction = this.UpdateTextBloodSplat;
         this.timer = Utils.RandBetweenInt(30,50);
         this.dobj = GraphicObjects.GetDisplayObjByName("smokePuff");
         this.frame = Utils.RandBetweenInt(0,this.dobj.GetNumFrames() - 1);
      }
      
      internal function UpdateTextBloodSplat() : void
      {
         this.yvel += 0.1;
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         --this.timer;
         if(this.timer <= 0)
         {
            this.active = false;
            this.timer = 0;
         }
      }
      
      public function InitSmoke(param1:String) : void
      {
         var _loc2_:Number = Utils.RandBetweenFloat(0,1);
         var _loc3_:Number = Utils.RandCircle();
         this.xvel = Math.cos(_loc3_) * _loc2_;
         this.yvel = Math.sin(_loc3_) * _loc2_;
         this.dobj = GraphicObjects.GetDisplayObjByName(param1);
         this.updateFunction = this.UpdateSmoke;
         this.frameVel = Utils.RandBetweenFloat(0.6,1);
         this.frame = 0;
         this.maxframe = this.dobj.GetNumFrames() - 1;
         this.timer = 0;
         this.visible = false;
      }
      
      internal function UpdateSmoke() : void
      {
         this.xvel *= 0.9;
         this.yvel *= 0.9;
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         this.visible = false;
         ++this.timer;
         if(this.timer > 1)
         {
            this.visible = true;
            if(this.PlayAnimation())
            {
               this.active = false;
            }
         }
      }
      
      public function InitGibs() : void
      {
         var _loc1_:Number = Utils.RandBetweenFloat(3,6);
         var _loc2_:Number = Utils.RandCircle();
         this.xvel = Math.cos(_loc2_) * _loc1_;
         this.yvel = Math.sin(_loc2_) * _loc1_;
         this.dobj = GraphicObjects.GetDisplayObjByName("gibs");
         this.updateFunction = this.UpdateGibs;
         this.frame = Utils.RandBetweenInt(0,this.dobj.GetNumFrames() - 1);
         this.angle = Utils.RandCircle();
         if(Levels.currentIndex == 40)
         {
            this.angle = 0;
            this.anglevel = 0;
         }
      }
      
      public function InitGibsDown() : void
      {
         var _loc1_:Number = Utils.RandBetweenFloat(2,5);
         var _loc2_:Number = Utils.RandBetweenFloat(-1,1) + Math.PI * 0.5;
         this.xvel = Math.cos(_loc2_) * _loc1_;
         this.yvel = Math.sin(_loc2_) * _loc1_;
         this.dobj = GraphicObjects.GetDisplayObjByName("gibs");
         this.updateFunction = this.UpdateGibs;
         this.frame = Utils.RandBetweenInt(0,this.dobj.GetNumFrames() - 1);
         this.angle = Utils.RandCircle();
         this.timer = Utils.RandBetweenInt(30,50);
         if(Levels.currentIndex == 40)
         {
            this.angle = 0;
            this.anglevel = 0;
         }
      }
      
      public function InitGibsUp() : void
      {
         var _loc1_:Number = Utils.RandBetweenFloat(2,5);
         var _loc2_:Number = Utils.RandBetweenFloat(-1,1) - Math.PI * 0.5;
         this.xvel = Math.cos(_loc2_) * _loc1_;
         this.yvel = Math.sin(_loc2_) * _loc1_;
         this.dobj = GraphicObjects.GetDisplayObjByName("gibs");
         this.updateFunction = this.UpdateGibs;
         this.frame = Utils.RandBetweenInt(0,this.dobj.GetNumFrames() - 1);
         this.angle = Utils.RandCircle();
         this.timer = Utils.RandBetweenInt(30,50);
         if(Levels.currentIndex == 40)
         {
            this.angle = 0;
            this.anglevel = 0;
         }
      }
      
      internal function UpdateGibs() : void
      {
         this.yvel += GameVars.gravity_GO;
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         if(this.timer <= 10)
         {
            this.alpha = Utils.ScaleTo(0,1,0,10,this.timer);
         }
      }
      
      public function InitBubble() : void
      {
         this.psize = 2;
         this.dobj = GraphicObjects.GetDisplayObjByName("bubbles");
         this.yvel = -Utils.RandBetweenFloat(1,2);
         this.xvel = Utils.RandBetweenFloat(-0.5,0.5);
         this.color = 4294901814;
         this.updateFunction = this.UpdateBubble;
         this.frameVel = 1;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
      }
      
      internal function UpdateBubble() : void
      {
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         if(this.PlayAnimation())
         {
            this.active = false;
         }
      }
      
      public function InitBubble1(param1:Number) : void
      {
         this.psize = 2;
         this.dobj = GraphicObjects.GetDisplayObjByName("bubbles1");
         param1 += Utils.RandBetweenFloat(-0.3,0.3);
         var _loc2_:Number = Utils.RandBetweenFloat(1,3);
         this.xvel = Math.cos(param1) * _loc2_;
         this.yvel = Math.sin(param1) * _loc2_;
         this.updateFunction = this.UpdateBubble1;
         this.frameVel = 1;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
      }
      
      internal function UpdateBubble1() : void
      {
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         if(this.PlayAnimation())
         {
            this.active = false;
         }
      }
      
      public function InitExplosion_Small() : void
      {
         this.dobj = GraphicObjects.GetDisplayObjByName("explosion_2");
         this.updateFunction = this.UpdateExplosion;
         this.frameVel = 1;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
      }
      
      public function InitExplosion_Large() : void
      {
         this.dobj = GraphicObjects.GetDisplayObjByName("explosion_3");
         this.updateFunction = this.UpdateExplosion;
         this.frameVel = 1;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
      }
      
      public function InitExplosion_Mushroom() : void
      {
         this.dobj = GraphicObjects.GetDisplayObjByName("mushroomCloud");
         this.updateFunction = this.UpdateExplosion;
         this.frameVel = 1;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
      }
      
      public function InitExplosion_Shockwave() : void
      {
         this.dobj = GraphicObjects.GetDisplayObjByName("shockWave");
         this.updateFunction = this.UpdateExplosion;
         this.frameVel = 1;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
      }
      
      public function InitExplosion_BloodPuff() : void
      {
         this.dobj = GraphicObjects.GetDisplayObjByName("bloodPuff");
         this.updateFunction = this.UpdateExplosion;
         this.frameVel = 1;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
      }
      
      internal function UpdateExplosion() : void
      {
         if(this.PlayAnimation())
         {
            this.active = false;
         }
      }
      
      public function UpdateShard() : void
      {
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         this.yvel += 0.3;
         if(this.ypos > 500)
         {
            this.active = false;
         }
         this.angle += this.dirVel;
      }
      
      public function InitShard(param1:int, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1 == 0)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem1_shards");
         }
         else if(param1 == 1)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem2_shards");
         }
         else if(param1 == 2)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem3_shards");
         }
         else if(param1 == 3)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem4_shards");
         }
         else if(param1 == 4)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem5_shards");
         }
         else if(param1 == 5)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem6_shards");
         }
         else if(param1 == 6)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem9_shards");
         }
         else if(param1 == 7)
         {
            this.dobj = GraphicObjects.GetDisplayObjByName("gem8_shards");
         }
         this.updateFunction = this.UpdateShard;
         this.frameVel = 0;
         this.maxframe = this.dobj.GetNumFrames();
         this.frame = 0;
         this.frame = Utils.RandBetweenInt(0,this.dobj.GetNumFrames() - 1);
         _loc3_ = 6;
         var _loc4_:Number = Utils.RandCircle();
         _loc5_ = _loc3_;
         this.xpos += Math.cos(_loc4_) * _loc5_;
         this.ypos += Math.sin(_loc4_) * _loc5_;
         _loc3_ = 3;
         _loc5_ = _loc3_;
         this.xvel = Math.cos(_loc4_) * _loc5_;
         this.yvel = Math.sin(_loc4_) * _loc5_;
         this.velmul = Utils.RandBetweenFloat(0.8,0.95);
         this.angle = Utils.RandCircle();
         this.dirVel = Utils.RandBetweenFloat(-0.4,0.4);
      }
      
      public function UpdateSpark() : void
      {
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         this.xvel *= this.velmul;
         this.yvel *= this.velmul;
         if(this.ypos > 500)
         {
            this.active = false;
         }
         this.alpha -= 12;
         if(this.alpha <= 0)
         {
            this.alpha = 0;
            this.active = false;
         }
      }
      
      public function InitSpark(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         this.psize = 3;
         this.color = 16777215;
         this.updateFunction = this.UpdateSpark;
         _loc4_ = param2;
         _loc5_ = param3;
         this.xpos += Math.cos(_loc4_) * _loc5_;
         this.ypos += Math.sin(_loc4_) * _loc5_;
         _loc4_ = param2;
         _loc5_ = param3;
         this.xvel = Math.cos(_loc4_) * _loc5_;
         this.yvel = Math.sin(_loc4_) * _loc5_;
         this.velmul = 0.9;
         this.timer = 15;
         this.alpha = 255;
      }
      
      public function InitMultiplier() : void
      {
         this.psize = 3;
         this.startx = this.xpos;
         this.starty = this.ypos;
         var _loc1_:Number = Utils.RandCircle();
         this.dir = Utils.RandCircle();
         this.radius = Utils.RandBetweenInt(30,60);
         this.dirVel = Utils.RandBetweenFloat(0.05,0.1);
         this.color = 4294901814;
         if(Utils.RandBetweenInt(0,100) < 50)
         {
            this.color = 16744640;
         }
         this.updateFunction = this.UpdateMultiplier;
      }
      
      internal function UpdateMultiplier() : void
      {
         var _loc1_:Number = Math.cos(this.dir) * this.radius;
         var _loc2_:Number = Math.sin(this.dir) * this.radius;
         this.xpos = this.startx + _loc1_;
         this.ypos = this.starty + _loc2_;
         this.dir += this.dirVel;
         --this.radius;
         if(this.radius < 10)
         {
            this.timer = 0;
            this.active = false;
         }
      }
      
      public function InitPandaEaten() : void
      {
         this.psize = Utils.RandBetweenInt(1,3);
         var _loc1_:Number = Utils.RandCircle();
         this.dir = Utils.RandCircle();
         this.speed = Utils.RandBetweenFloat(1,2);
         this.dirVel = Utils.RandBetweenFloat(0.1,0.2);
         this.color = 4294963254;
         this.timer = Utils.RandBetweenInt(30,50);
         this.updateFunction = this.UpdatePandaEaten;
      }
      
      internal function UpdatePandaEaten() : void
      {
         var _loc1_:Number = Math.cos(this.dir) * this.speed;
         var _loc2_:Number = Math.sin(this.dir) * this.speed;
         this.xpos += _loc1_;
         this.ypos += _loc2_;
         this.speed += 0.3;
         this.dir += this.dirVel;
         --this.timer;
         if(this.timer <= 0)
         {
            this.timer = 0;
            this.active = false;
         }
      }
      
      public function InitPandaFireTrail(param1:int) : void
      {
         var _loc3_:Number = NaN;
         this.psize = Utils.RandBetweenInt(1,3);
         var _loc2_:Number = Utils.RandCircle();
         this.xpos += Utils.RandBetweenFloat(-6,6);
         this.ypos += Utils.RandBetweenFloat(-6,6);
         this.yacc = Utils.RandBetweenFloat(0.05,0.2);
         this.yvel = Utils.RandBetweenFloat(0,1);
         this.color = 4294942720;
         if(Utils.RandBetweenInt(0,100) < 50)
         {
            this.color = 4294967040;
         }
         this.timer = Utils.RandBetweenInt(25,35);
         this.updateFunction = this.UpdatePandaFireTrail;
      }
      
      internal function UpdatePandaFireTrail() : void
      {
         this.yvel += this.yacc;
         this.ypos += this.yvel;
         --this.timer;
         if(this.timer <= 0)
         {
            this.timer = 0;
            this.active = false;
         }
      }
      
      public function InitPandaLaunch(param1:Number) : void
      {
         this.psize = Utils.RandBetweenInt(2,3);
         var _loc2_:Number = param1 + Utils.RandBetweenFloat(-0.2,0.2);
         this.xpos += Utils.RandBetweenFloat(-6,6);
         this.ypos += Utils.RandBetweenFloat(-6,6);
         this.speed = Utils.RandBetweenFloat(3,10);
         this.xvel = Math.cos(_loc2_) * this.speed;
         this.yvel = Math.sin(_loc2_) * this.speed;
         this.color = 4294942720;
         if(Utils.RandBetweenInt(0,100) < 50)
         {
            this.color = 4294901814;
         }
         this.timer = Utils.RandBetweenInt(25,35);
         this.updateFunction = this.UpdatePandaLaunch;
      }
      
      internal function UpdatePandaLaunch() : void
      {
         this.yvel += 0.1;
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         this.xvel *= 0.97;
         this.yvel *= 0.97;
         --this.timer;
         if(this.timer <= 0)
         {
            this.timer = 0;
            this.active = false;
         }
      }
      
      public function InitAddScore(param1:int) : void
      {
         var _loc3_:Number = NaN;
         this.psize = 2;
         var _loc2_:Number = Utils.RandCircle();
         if(param1 == 0)
         {
            _loc3_ = Utils.RandBetweenFloat(2,5);
            this.color = 4294967295;
            this.timer = Utils.RandBetweenInt(10,20);
         }
         else if(param1 == 1)
         {
            _loc3_ = Utils.RandBetweenFloat(8,12);
            this.color = 4294901814;
            this.timer = Utils.RandBetweenInt(20,30);
         }
         this.xvel = Math.cos(_loc2_) * _loc3_;
         this.yvel = Math.sin(_loc2_) * _loc3_;
         this.updateFunction = this.UpdateAddScore;
      }
      
      internal function UpdateAddScore() : void
      {
         this.yvel += 0.1;
         this.xpos += this.xvel;
         this.ypos += this.yvel;
         this.xvel *= 0.95;
         this.yvel *= 0.95;
         --this.timer;
         if(this.timer <= 0)
         {
            this.timer = 0;
            this.active = false;
         }
      }
      
      internal function PlayAnimation() : Boolean
      {
         this.frame += this.frameVel;
         if(this.frame >= this.maxframe)
         {
            this.frame = this.maxframe;
            return true;
         }
         return false;
      }
      
      internal function CycleAnimation() : Boolean
      {
         this.frame += this.frameVel;
         if(this.frame >= this.maxframe)
         {
            this.frame = 0;
            return true;
         }
         return false;
      }
   }
}

