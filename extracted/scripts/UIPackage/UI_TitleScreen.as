package UIPackage
{
   import LicPackage.Lic;
   import LicPackage.LicDef;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class UI_TitleScreen extends UIScreenInstance
   {
      
      internal var adHolder:MovieClip;
      
      public function UI_TitleScreen()
      {
         super();
      }
      
      override public function ExitScreen() : *
      {
         UI.RemoveAllButtons();
         UI.RemoveGeneric();
      }
      
      override public function InitScreen() : *
      {
         UI.StartAddButtons();
         titleMC = new titleScreen();
         titleMC.gotoAndStop(1);
         UI.AddAnimatedMCButton(titleMC.btn_playgame,this.buttonContinuePressed);
         UI.AddAnimatedMCButton(titleMC.buttonClearData,this.buttonClearDataPopupPressed);
         Lic.AnimatedMCMoreGamesButton(titleMC.btn_moregames,"title");
         Lic.MainLogoButton(titleMC.mainLogo);
         UI.AddGeneric(titleMC);
         Lic.AuthorButton(titleMC.turboBtn);
         titleMC.zombookaAdHolder.visible = false;
         if(LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
         {
            titleMC.zombookaAdHolder.visible = true;
         }
         UI.AddButton(titleMC.zombookaAdHolder.game1,this.buttonGame1Pressed);
         UI.AddButton(titleMC.zombookaAdHolder.game2,this.buttonGame2Pressed);
         UI.AddButton(titleMC.zombookaAdHolder.game3,this.buttonGame3Pressed);
      }
      
      public function buttonGame1Pressed(param1:MouseEvent) : *
      {
         Lic.DoLink("http://www.kongregate.com/games/robotJAM/flaming-zombooka");
      }
      
      public function buttonGame2Pressed(param1:MouseEvent) : *
      {
         Lic.DoLink("http://www.kongregate.com/games/turboNuke/flaming-zombooka-2");
      }
      
      public function buttonGame3Pressed(param1:MouseEvent) : *
      {
         Lic.DoLink("http://www.kongregate.com/games/turboNuke/flaming-zombooka-2-level-pack");
      }
      
      public function buttonClearDataPopupPressed(param1:MouseEvent) : *
      {
         UI.StartTransition("areyousure_cleardata");
      }
      
      public function buttonContinuePressed(param1:MouseEvent) : *
      {
         GameVars.gameMode = 0;
         UI.StartTransition("levelselect");
      }
   }
}

