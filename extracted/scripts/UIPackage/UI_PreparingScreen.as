package UIPackage
{
   import LicPackage.Lic;
   import flash.events.Event;
   import flash.system.System;
   
   public class UI_PreparingScreen extends UIScreenInstance
   {
      
      internal static var mem1:int;
      
      internal var preparingScreenDone:Boolean = false;
      
      internal var preparingGraphicsTimer:int;
      
      internal var preparingGraphicsIndex:int;
      
      internal var preparingGraphics:Array = new Array("cannonRung","PlayerSelectButton","fireRing","hook","banana2","banana1","distance_fills","rock3","rock2","rock1","sign_turn_left_part3","sign_turn_left_part2","sign_turn_left_part1","sign_turn_left_part0","sign_turn_right_part3","sign_turn_right_part1","sign_turn_right_part2","sign_turn_right_part0","hinge","clownwheel","shotMarker","cork_ingame","billboard_cannonball","billboard_fireeater","billboard_animaltamer","billboard_custardKing","billboard_clowns","billboard_nuke","circus_sign","sign_turn_left","sign_turn_right","decal5","decal3","decal7","decal2","decal4","decal6","decal8","decal9","decal10","decal1","bunting","buntingPole","fortune_part6","fortune_part5","fortune_part4","fortune_part3","fortune_part2","fortune_part1","wheelofdeathbackground","wheelofDeath","SeparateUnicycle","piano_part12","piano_part11","piano_part10","piano_part9","piano_part8","piano_part7","piano_part6","piano_part5","piano_part4","piano_part3","piano_part2"
      ,"piano_part1","Wheel_50","Wheel_35","elephant","woodenPost1","woodenPost1_fixed","woodenPost0","woodenPost0_fixed","woodPost0_part1","woodPost0_part2","woodPost0_part3","woodPost1_part1","woodPost1_part2","woodPost1_part3","woodPost1_part4","woodenPin","woodenCrate0","woodenCrate1","woodenPin_part1","woodenPin_part2","woodenPin_part3","woodenPin_part4","woodenCrate0_part1","woodenCrate0_part2","woodenCrate0_part3","woodenCrate0_part4","woodenCrate1_part1","woodenCrate1_part2","woodenCrate1_part3","woodenCrate1_part4","woodenCrate1_part5","woodenCrate1_part6","woodenCrate1_part7","woodenCrate1_part8","woodenPost2","woodenPost2_fixed","woodenPost2_part1","woodenPost2_part2","woodenPost2_part3","woodenPost2_part4","woodenPost2_part5","woodenPost2_part6","Spawner","chainsaw","cutting_disk","ExplosiveBarrel","switched_platform_2","Ball","Anvil","switched_platform_1","cutting_disk2","cutting_disk3","cannon_top","cannon_top_corked","cannon_top_big","cannon_base","magnet","landmine","fortuneMachine"
      ,"mincer","switched_platform_0","switched_platform_2way_0","parachuteBomb","rope","bloodsplat","background01","fill","Sparks","PlatformBouncyLarge","PlatformBouncy","car1","car2","switch_Timer","switch_Once","switch_twoWay","grass1","grass2","grass3","switch_StopGo","bowlingBall","wire_end","wire","Missile","missile_icon","explosion_3","explosion_custard","explosion_2","bloodPuff","mushroomCloud","shockWave","gibs","ZombieStopWalkMarker","piano","TrapezeWire120","Text_Marker","Switch_Limpet","obj_platform_holder_1x4","windblock","brain","fx_smokepuff","fx_explosion","grass","ZombieFlame","Flame1","ZombieTurnAroundMarker","fx_custardpuff","fx_railpuff","fx_firepuff","saw","saw_xflip","trampoline","helpText","metalPost0_part1","metalPost0_part2","metalPost0_part3","metalPost1_part1","metalPost1_part2","metalPost1_part3","metalPost1_part4","metalPost2_part1","metalPost2_part2","metalPost2_part3","metalPost2_part4","metalPost2_part5","metalPost2_part6","metalPost2","metalPost3","metalPost2_fixed"
      ,"glassPost2","glassPost2_fixed","metalPost1","metalPost1_fixed","glassPost1","glassPost1_fixed","metalPost0","metalPost0_fixed","glassPost0","glassPost0_fixed","glassPost0_part2","glassPost0_part3","glassPost1_part1","glassPost1_part2","glassPost1_part3","glassPost1_part4","glassPost2_part1","glassPost2_part2","glassPost2_part3","glassPost2_part4","glassPost2_part5","glassPost2_part6","glassPost0_part1","sky","tree_palm1","tree_palm2","tree_palm3","oaktree1","oaktree2","bush","bush2","bush3","tent","InitialPlayerMarker","terrainSpikes","water","fx_smoke3");
      
      public function UI_PreparingScreen()
      {
         super();
      }
      
      override public function ExitScreen() : *
      {
      }
      
      override public function InitScreen() : *
      {
         mem1 = System.totalMemory / 1024;
         titleMC = new PreparingScreen();
         titleMC.addEventListener(Event.ENTER_FRAME,this.UpdatePreparingScreen,false,0,true);
         Lic.PlayWithScoresButton(titleMC.buttonPlayWithHighcores);
         this.preparingGraphicsTimer = 0;
         this.preparingGraphicsIndex = 0;
         this.PreparingScreenSetBar();
      }
      
      internal function UpdatePreparingScreen(param1:Event) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(titleMC == null)
         {
            return;
         }
         --this.preparingGraphicsTimer;
         if(this.preparingGraphicsTimer > 0)
         {
            return;
         }
         this.PreparingScreenSetBar();
         var _loc2_:String = this.preparingGraphics[this.preparingGraphicsIndex];
         GraphicObjects.Add(_loc2_,0);
         this.PreparingScreenSetBar();
         ++this.preparingGraphicsIndex;
         if(this.preparingGraphicsIndex >= this.preparingGraphics.length)
         {
            this.preparingScreenDone = true;
            titleMC.removeEventListener(Event.ENTER_FRAME,this.UpdatePreparingScreen);
            _loc3_ = System.totalMemory / 1024;
            _loc4_ = _loc3_ - mem1;
            Utils.trace("memory used for gfx: " + _loc4_ + "k");
            UI.StartTransition("title");
         }
      }
      
      internal function PreparingScreenSetBar() : *
      {
         if(titleMC == null)
         {
            return;
         }
         var _loc1_:Number = Utils.ScaleTo(0,1,0,this.preparingGraphics.length - 1,this.preparingGraphicsIndex);
         titleMC.loaderBar.loadBar.scaleX = _loc1_;
      }
   }
}

