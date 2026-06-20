package UIPackage
{
   import flash.events.MouseEvent;
   
   public class UI_AreYouSure_ClearData extends UIScreenInstance
   {
      
      public function UI_AreYouSure_ClearData()
      {
         super();
      }
      
      public static function buttonOKPressed(param1:MouseEvent) : *
      {
         Game.ResetEverything();
         SaveData.Save();
         UI.StartTransition("title");
      }
      
      public static function buttonCancelPressed(param1:MouseEvent) : *
      {
         UI.StartTransition("title");
      }
      
      override public function ExitScreen() : *
      {
      }
      
      override public function InitScreen() : *
      {
         UI.StartAddButtons();
         titleMC = new AreYouSure();
         UI.AddAnimatedMCButton(titleMC.buttonOK,buttonOKPressed);
         UI.AddAnimatedMCButton(titleMC.buttonCancel,buttonCancelPressed);
      }
   }
}

