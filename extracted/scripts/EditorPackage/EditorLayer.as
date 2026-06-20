package EditorPackage
{
   public class EditorLayer
   {
      
      internal var name:String;
      
      internal var index:int;
      
      internal var visible:Boolean;
      
      internal var locked:Boolean;
      
      public function EditorLayer(param1:int, param2:String)
      {
         super();
         this.name = param2;
         this.index = param1;
         this.visible = true;
         this.locked = false;
      }
      
      public function ToggleVisibility() : *
      {
         this.visible = this.visible == false;
      }
      
      public function ToggleLocked() : *
      {
         this.locked = this.locked == false;
      }
      
      public function IsVisible() : Boolean
      {
         return this.visible;
      }
      
      public function IsLocked() : Boolean
      {
         return this.locked;
      }
   }
}

