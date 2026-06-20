package LicPackage
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class OtherGames
   {
      
      internal static var otherGamesList:Array;
      
      public function OtherGames()
      {
         super();
      }
      
      public static function GetOtherGamesMC(param1:int = 4, param2:int = 0) : MovieClip
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc3_:MovieClip = new otherGamesMC();
         if(param2 == 1)
         {
            _loc3_ = new otherGamesMC_TitleScreen();
         }
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            otherGamesList = new Array();
            otherGamesList.push({
               "button":"game1",
               "name":"DriftRunners2",
               "select":true
            });
            otherGamesList.push({
               "button":"game2",
               "name":"CoasterRacer",
               "select":true
            });
            otherGamesList.push({
               "button":"game3",
               "name":"DriftRunners1",
               "select":true
            });
            otherGamesList.push({
               "button":"game4",
               "name":"NeonRace",
               "select":true
            });
            otherGamesList.push({
               "button":"game5",
               "name":"GunExpress",
               "select":true
            });
            otherGamesList.push({
               "button":"game6",
               "name":"HeatRush",
               "select":true
            });
            otherGamesList.push({
               "button":"game7",
               "name":"CycloManiacs",
               "select":true
            });
            otherGamesList.push({
               "button":"game8",
               "name":"SoccerBalls",
               "select":true
            });
            otherGamesList.push({
               "button":"game9",
               "name":"Zombooka2",
               "select":true
            });
            otherGamesList.push({
               "button":"game10",
               "name":"Zombooka",
               "select":true
            });
            otherGamesList.push({
               "button":"game11",
               "name":"SkiManiacs",
               "select":true
            });
            otherGamesList.push({
               "button":"game12",
               "name":"Toxers",
               "select":true
            });
            otherGamesList.push({
               "button":"game13",
               "name":"HarryQuantum",
               "select":true
            });
            otherGamesList.push({
               "button":"game14",
               "name":"CycloManiacs2",
               "select":true
            });
            otherGamesList.push({
               "button":"game15",
               "name":"CoasterRacer2",
               "select":true
            });
            otherGamesList.push({
               "button":"game16",
               "name":"FormulaRacer",
               "select":true
            });
            otherGamesList.push({
               "button":"game17",
               "name":"Zomgies2",
               "select":true
            });
            otherGamesList.push({
               "button":"game18",
               "name":"CorporationInc",
               "select":false
            });
            otherGamesList.push({
               "button":"game19",
               "name":"SovietGiraffe",
               "select":false
            });
            otherGamesList.push({
               "button":"game20",
               "name":"EleQuest",
               "select":false
            });
            otherGamesList.push({
               "button":"game21",
               "name":"SushiCat2",
               "select":false
            });
            otherGamesList.push({
               "button":"game22",
               "name":"GrandPrixGo",
               "select":true
            });
            otherGamesList.push({
               "button":"game23",
               "name":"SpacePunkRacer",
               "select":true
            });
            otherGamesList.push({
               "button":"game24",
               "name":"BasketBalls",
               "select":true
            });
            otherGamesList.push({
               "button":"game25",
               "name":"NinjaAcademy",
               "select":true
            });
            _loc4_ = new Array();
            _loc5_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < otherGamesList.length)
            {
               if(otherGamesList[_loc6_].select == true)
               {
                  _loc5_.push(_loc6_);
               }
               _loc6_++;
            }
            _loc5_ = ShuffleIntList(_loc5_,500);
            for each(_loc7_ in otherGamesList)
            {
               _loc3_[_loc7_.button].visible = false;
               _loc4_.push(new Point(_loc3_[_loc7_.button].x,_loc3_[_loc7_.button].y));
            }
            _loc6_ = 0;
            while(_loc6_ < param1)
            {
               _loc7_ = otherGamesList[_loc6_];
               _loc8_ = otherGamesList[_loc5_[_loc6_]];
               _loc3_[_loc8_.button].visible = true;
               _loc3_[_loc8_.button].x = _loc4_[_loc6_].x;
               _loc3_[_loc8_.button].y = _loc4_[_loc6_].y;
               _loc3_[_loc8_.button].addEventListener(MouseEvent.CLICK,OtherGamesPanel_ClickGame,false,0,true);
               _loc6_++;
            }
            return _loc3_;
         }
         return null;
      }
      
      internal static function ShuffleIntList(param1:Array, param2:int = 100) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc5_ = Utils.RandBetweenInt(0,_loc3_ - 1);
            _loc6_ = Utils.RandBetweenInt(0,_loc3_ - 1);
            _loc7_ = int(param1[_loc5_]);
            param1[_loc5_] = param1[_loc6_];
            param1[_loc6_] = _loc7_;
            _loc4_++;
         }
         return param1;
      }
      
      internal static function OtherGamesPanel_ClickGame(param1:MouseEvent) : *
      {
         var _loc6_:Object = null;
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:String = _loc2_.substr(4);
         var _loc4_:int = int(_loc3_);
         var _loc5_:Object = null;
         for each(_loc6_ in otherGamesList)
         {
            if(_loc6_.button == _loc2_)
            {
               _loc5_ = _loc6_;
            }
         }
         if(_loc5_ != null)
         {
            Utils.trace(_loc5_.button + "  " + _loc5_.name);
            if(_loc5_.name == "CycloManiacs")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/cyclomaniacs" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "Zombooka")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/robotJAM/flaming-zombooka" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "SoccerBalls")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/turboNuke/soccer-balls" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "Zombooka2")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/turboNuke/flaming-zombooka-2" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "CoasterRacer")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/coaster-racer" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "SkiManiacs")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/ski-maniacs" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "Toxers")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/Rob_Almighty/toxers" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "HarryQuantum")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/harry-quantum-tv-go-home" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "DriftRunners1")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/drift-runners" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "DriftRunners2")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/drift-runners-2" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "NeonRace")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/neon-race" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "GunExpress")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/gun-express" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "HeatRush")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/heat-rush" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "CycloManiacs2")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/TurboNuke/cyclomaniacs-2" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "CoasterRacer2")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/coaster-racer-2" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "FormulaRacer")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/TurboNuke/formula-racer" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "Zomgies2")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/zomgies-2" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "CorporationInc")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/ArmorGames/corporation-inc" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "SovietGiraffe")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/ArmorGames/soviet-rocket-giraffe-go-go-go" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "EleQuest")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/ArmorGames/elephant-quest" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "SushiCat2")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/ArmorGames/sushi-cat-2" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "GrandPrixGo")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/TurboNuke/grand-prix-go" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "SpacePunkRacer")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/space-punk-racer" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "BasketBalls")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/TurboNuke/basketballs" + LicDef.referralString,"othergames");
            }
            if(_loc5_.name == "NinjaAcademy")
            {
               Lic.Playtomic_Link("http://www.kongregate.com/games/LongAnimals/sticky-ninja-academy" + LicDef.referralString,"othergames");
            }
         }
      }
   }
}

