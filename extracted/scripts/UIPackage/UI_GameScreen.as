package UIPackage
{
   import flash.display.MovieClip;
   
   public class UI_GameScreen extends UIScreenInstance
   {
      
      public function UI_GameScreen()
      {
         super();
      }
      
      override public function ExitScreen() : *
      {
         titleMC.removeChild(Game.main.screenB);
      }
      
      override public function InitScreen() : *
      {
         Game.main.screenB.bitmapData.fillRect(Defs.screenRect,0);
         titleMC = new MovieClip();
         titleMC.addChild(Game.main.screenB);
         Game.currentMC = titleMC;
         Game.main.screenB.x = 0;
         Game.main.screenB.y = 0;
         Game.StartLevel();
         Game.UpdateGameplay();
         Game.Render();
      }
   }
}

