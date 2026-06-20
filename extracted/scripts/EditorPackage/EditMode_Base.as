package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class EditMode_Base
   {
      
      internal var editSubMode:int;
      
      internal var mx:int;
      
      internal var my:int;
      
      internal var sx:Number;
      
      internal var sy:Number;
      
      internal var mxs:int;
      
      internal var mys:int;
      
      public function EditMode_Base()
      {
         super();
      }
      
      public function InitOnce() : void
      {
         this.editSubMode = 0;
      }
      
      public function EnterMode() : void
      {
         PhysEditor.CursorText_Hide();
         PhysEditor.CursorText_Set("");
         this.editSubMode = 0;
      }
      
      internal function GetMousePositions() : *
      {
         this.mx = MouseControl.x;
         this.my = MouseControl.y;
         if(PhysEditor.gridMode_active)
         {
            this.mx = Math.floor(this.mx);
            this.my = Math.floor(this.my);
            this.mx = int(this.mx / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
            this.my = int(this.my / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
         }
         this.sx = PhysEditor.scrollX;
         this.sy = PhysEditor.scrollY;
         if(PhysEditor.gridMode_active)
         {
            this.sx = Math.floor(this.sx);
            this.sy = Math.floor(this.sy);
            this.sx = int(this.sx / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
            this.sy = int(this.sy / PhysEditor.gridsnap) * int(PhysEditor.gridsnap);
         }
         this.mxs = this.mx * (1 / PhysEditor.zoom) + this.sx;
         this.mys = this.my * (1 / PhysEditor.zoom) + this.sy;
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         this.GetMousePositions();
      }
      
      public function OnMouseUp(param1:MouseEvent) : void
      {
         this.GetMousePositions();
      }
      
      public function OnMouseMove(param1:MouseEvent) : void
      {
         this.GetMousePositions();
      }
      
      public function OnMouseWheel(param1:int) : void
      {
      }
      
      public function Update() : void
      {
      }
      
      public function Render(param1:BitmapData) : void
      {
         this.GetMousePositions();
      }
      
      public function RenderHud(param1:int, param2:int) : int
      {
         return param2;
      }
      
      internal function GetCurrentLevel() : Level
      {
         return PhysEditor.GetCurrentLevel();
      }
      
      internal function GetCurrentLevelJoints() : Array
      {
         return PhysEditor.GetCurrentLevel().joints;
      }
      
      internal function GetCurrentLevelInstances() : Array
      {
         return PhysEditor.GetCurrentLevelInstances();
      }
      
      internal function SetCurrentLevelInstances(param1:Array) : void
      {
         PhysEditor.SetCurrentLevelInstances(param1);
      }
   }
}

