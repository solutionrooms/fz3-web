package
{
   import flash.geom.Point;
   
   public class GameVars
   {
      
      public static var gameMode:int;
      
      public static var gameTimer:int;
      
      public static var gameTimerMax:int;
      
      public static var totalBaskets:int;
      
      public static var numBasketsGot:int;
      
      public static var totalRefs:int;
      
      public static var numRefsGot:int;
      
      public static var numMarkers:int;
      
      public static var currentMarker:int;
      
      public static var markerList:Array;
      
      public static var time_RankA:int;
      
      public static var time_RankB:int;
      
      public static var fastForwardFlag:Boolean;
      
      public static var fastforwardoffset:int;
      
      public static var currentPlayerHead:int;
      
      public static var currentRaceA:int;
      
      public static var currentRaceB:int;
      
      public static var totalZombies:int;
      
      public static var numZombiesKilled:int;
      
      public static var totalHumans:int;
      
      public static var numHumansKilled:int;
      
      public static var playerKilled:Boolean;
      
      public static var numHostagesRescued:int;
      
      public static var totalHostages:int;
      
      public static var totalPlayers:int;
      
      public static var currentShotBonus:int;
      
      public static var shotBonusMax:int;
      
      public static var shotBonusSubAmt:int;
      
      public static var numShotsFired:int;
      
      public static var numBonusKills:int;
      
      public static var numBonusKillStreak:int;
      
      public static var numBonusBestKillStreak:int;
      
      public static var hitRef:Boolean;
      
      public static var takingADump:Boolean;
      
      public static var lastPlayerToThrow:GameObj;
      
      public static var team_index:int;
      
      public static var opponent_team_index:int;
      
      internal static var weapons:Vector.<Weapon>;
      
      internal static var scores:Vector.<scoreData>;
      
      public static const minShootRadius:Number = 10;
      
      public static const levelScoreMin:int = 0;
      
      public static const levelScoreMax:int = 5000;
      
      public static const maxShootRadius:Number = 250;
      
      public static const minShootForce:Number = 2;
      
      public static const maxShootForce:Number = 9;
      
      public static const basketSuckMultiplier:Number = 0.5;
      
      public static const cannonHoldTime:int = Defs.fps * 5;
      
      public static const cannonLaunchForce:Number = 10;
      
      public static const explosiveBarrelForce:Number = 1;
      
      public static const custardPieForce:Number = 0.5;
      
      public static const custardPieHPmin:int = 10;
      
      public static const custardPieHPmax:int = 10;
      
      public static const custardPieRadius:int = 100;
      
      public static const nukeForce:Number = 0.3;
      
      public static const nukeHPmin:int = 100;
      
      public static const nukeHPmax:int = 100;
      
      public static const nukeRadius:int = 100;
      
      public static const magnetForce:Number = 0.5;
      
      public static const ballTimerMax:int = Defs.fps * 8;
      
      public static const ballTimerWarningMax:int = Defs.fps * 2;
      
      public static const gravity:Number = 300;
      
      public static const ballLineLength:int = 60;
      
      public static const windStrength:Number = 0.3;
      
      public static const refereeTimeBonus:int = 5 * Defs.fps;
      
      public static const lowestScreenClickY:int = Defs.displayarea_h - 30;
      
      public static const minMissileVelocity:Number = 1;
      
      public static const maxMissileVelocity:Number = 10;
      
      public static const minFireDist:Number = 40;
      
      public static const maxFireDist:Number = 220;
      
      public static const airstrike_initialYVel:Number = 1;
      
      public static const gravity_GO:Number = 0.2;
      
      public static const missile_time:int = Defs.fps * 2;
      
      public static const ZT_CLOWN0:int = 1;
      
      public static const ZT_CLOWN1:int = 2;
      
      public static const ZT_CLOWN2:int = 3;
      
      public static const ZT_CLOWN3:int = 4;
      
      public static const ZT_RING_MASTER:int = 5;
      
      public static const ZT_STRONG_MAN:int = 6;
      
      public static const ZT_GENERIC0:int = 7;
      
      public static const ZT_GENERIC1:int = 8;
      
      public static const ZT_GENERIC2:int = 9;
      
      public static const ZT_GENERIC3:int = 10;
      
      public static const ZT_GENERIC4:int = 11;
      
      public static const ZT_BEARDED_LADY:int = 12;
      
      public static const ZT_ELECTROCUTED:int = 13;
      
      public static var zombieLimbSets:Array = new Array(0,1,1,0,0,2);
      
      public static var zombieLimbObjects:Array = new Array("Zombie_body","Zombie_topLeg","Zombie_bottomLeg","Zombie_armTop","Zombie_armBottom","Zombie_head");
      
      public static var zombieLimbOffsets:Array = new Array(new Point(0,-4),new Point(0,13),new Point(0,26),new Point(-5,-6),new Point(-10,-6),new Point(-3,-14));
      
      public static var humanLimbObjects:Array = new Array("civilian_body_dead","civilian_topLeg_dead","civilian_bottomLeg_dead","civilian_armTop_dead","civilian_armBottom_dead","civilian_head_dead");
      
      public static var humanLimbOffsets:Array = new Array(new Point(0,-4),new Point(0,13),new Point(0,26),new Point(-5,-6),new Point(-10,-6),new Point(-3,-14));
      
      public static var playerLimbObjects:Array = new Array("baz_body_dead","baz_topLeg_dead","baz_bottomLeg_dead","baz_armTop_dead","baz_armBottom_dead","baz_head_dead");
      
      public static var playerLimbObjects_baz:Array = new Array("baz_body_dead","baz_topLeg_dead","baz_bottomLeg_dead","baz_armTop_dead","baz_armBottom_dead","baz_head_dead");
      
      public static var playerLimbObjects_custard:Array = new Array("custardpie_body_dead","custardpie_topLeg_dead","custardpie_bottomLeg_dead","custardpie_armTop_dead","custardpie_armBottom_dead","custardpie_head_dead");
      
      public static var playerLimbObjects_flameEater:Array = new Array("flameEater_body_dead","flameEater_topLeg_dead","flameEater_bottomLeg_dead","flameEater_armTop_dead","flameEater_armBottom_dead","flameEater_head_dead");
      
      public static var playerLimbObjects_cannonball:Array = new Array("humanCannonball_body_dead","humanCannonball_topLeg_dead","humanCannonball_bottomLeg_dead","humanCannonball_armTop_dead","humanCannonball_armBottom_dead","humanCannonball_head_dead");
      
      public static var playerLimbObjects_lionTamer:Array = new Array("lionTamer_body_dead","lionTamer_topLeg_dead","lionTamer_bottomLeg_dead","lionTamer_armTop_dead","lionTamer_armBottom_dead","lionTamer_head_dead");
      
      public static var playerLimbObjects_major:Array = new Array("major_body_dead","major_topLeg_dead","major_bottomLeg_dead","major_armTop_dead","major_armBottom_dead","major_head_dead");
      
      public static var playerLimbObjects_nuke:Array = new Array("mrNuke_body_dead","mrNuke_topLeg_dead","mrNuke_bottomLeg_dead","mrNuke_armTop_dead","mrNuke_armBottom_dead","mrNuke_head_dead");
      
      public static var playerLimbOffsets:Array = new Array(new Point(0,-4),new Point(0,13),new Point(0,26),new Point(-5,-6),new Point(-10,-6),new Point(-3,-14));
      
      public function GameVars()
      {
         super();
      }
      
      public static function GetWeapon(param1:String) : *
      {
         var _loc2_:Weapon = null;
         for each(_loc2_ in weapons)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function GetScoreData(param1:String) : scoreData
      {
         var _loc3_:scoreData = null;
         var _loc2_:Vector.<scoreData> = new Vector.<scoreData>();
         for each(_loc3_ in scores)
         {
            if(_loc3_.name == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length == 0)
         {
            return null;
         }
         var _loc4_:int = Utils.RandBetweenInt(0,_loc2_.length - 1);
         return _loc2_[_loc4_];
      }
      
      public static function InitOnce() : *
      {
         gameMode = 0;
         team_index = 0;
         opponent_team_index = 0;
         takingADump = false;
         weapons = new Vector.<Weapon>();
         weapons.push(new Weapon("Bazooka","missile_normal",1));
         weapons.push(new Weapon("Limpet","missile_sticky",1));
         weapons.push(new Weapon("Cannonball","missile_cannonball",1));
         weapons.push(new Weapon("Explosive","missile_explosive",1));
         weapons.push(new Weapon("Fireball","missile_flame",1));
         weapons.push(new Weapon("Elestrike","missile_airstrike",1));
         weapons.push(new Weapon("RailGun","missile_railgun",1,true));
         scores = new Vector.<scoreData>();
         scores.push(new scoreData("normal",500,"Good Hit"));
         scores.push(new scoreData("normal",500,"Killer!"));
         scores.push(new scoreData("headshot",1000,"Head Shot!"));
         scores.push(new scoreData("headshot",1000,"Well Ahead!"));
         scores.push(new scoreData("saw",2000,"Sliced!"));
         scores.push(new scoreData("saw",2000,"Cut!"));
         scores.push(new scoreData("chainsaw",2000,"Sliced!"));
         scores.push(new scoreData("chainsaw",2000,"Cut!"));
         scores.push(new scoreData("cuttingdisk",2000,"Sliced!"));
         scores.push(new scoreData("cuttingdisk",2000,"Cut!"));
         scores.push(new scoreData("heavy",2000,"Squished!"));
         scores.push(new scoreData("heavy",2000,"Flattened!"));
         scores.push(new scoreData("piano",2000,"Ivoried!"));
         scores.push(new scoreData("piano",2000,"Concertoed!"));
         scores.push(new scoreData("fire",2000,"Fried"));
         scores.push(new scoreData("fire",2000,"Burned"));
         scores.push(new scoreData("electric",2000,"Zapped"));
         scores.push(new scoreData("electric",2000,"Electrified"));
         scores.push(new scoreData("car",2000,"Run Over"));
         scores.push(new scoreData("car",2000,"Carjacked!"));
         scores.push(new scoreData("explosion",2000,"Explosive!"));
         scores.push(new scoreData("explosion",2000,"Kaboom!"));
         scores.push(new scoreData("rescue",1000,"Rescued!"));
         scores.push(new scoreData("elephant",2000,"Splatted"));
         scores.push(new scoreData("elephant",2000,"Phanted!"));
         scores.push(new scoreData("elephant",2000,"Ele-Splat"));
      }
      
      public static function InitForLevel() : *
      {
         gameTimerMax = gameTimer = Defs.fps * 30;
         numMarkers = 0;
         currentMarker = 0;
         markerList = new Array();
         totalBaskets = 0;
         numBasketsGot = 0;
         totalRefs = 0;
         numRefsGot = 0;
         lastPlayerToThrow = null;
         fastForwardFlag = false;
         fastforwardoffset = -1;
         var _loc1_:Level = Levels.GetCurrent();
         takingADump = false;
         numZombiesKilled = 0;
         totalZombies = 0;
         numHumansKilled = 0;
         totalHumans = 0;
         playerKilled = false;
         numHostagesRescued = 0;
         totalHostages = 0;
         totalPlayers = 0;
         hitRef = false;
         shotBonusMax = currentShotBonus = 5000;
         shotBonusSubAmt = 100;
         numShotsFired = 0;
         numBonusKills = 0;
         numBonusKillStreak = 0;
         numBonusBestKillStreak = 0;
      }
   }
}

