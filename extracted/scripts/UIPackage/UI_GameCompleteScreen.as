package UIPackage
{
   import LicPackage.Lic;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public class UI_GameCompleteScreen extends UIScreenInstance
   {
      
      public function UI_GameCompleteScreen()
      {
         super();
      }
      
      override public function ExitScreen() : *
      {
         UI.RemoveAllButtons();
      }
      
      override public function InitScreen() : *
      {
         UI.StartAddButtons();
         Mouse.show();
         MusicPlayer.StartStream("menus_music");
         titleMC = new GameWinScreen();
         UI.AddMCButton(titleMC.buttonContinue,this.buttonNextPressed);
         Lic.MCMoreGamesButton(titleMC.buttonMoreGames,"gamecomplete");
         Lic.MCMoreGamesButton(titleMC.buttonMoreGames1,"gamecomplete");
      }
      
      internal function buttonNextPressed(param1:MouseEvent) : *
      {
         UI.StartTransition("levelcomplete");
      }
   }
}

