package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class EditMode_PickPieceForLink extends EditMode_Base
   {
      
      public var pickedObject:LevelObj_Instance;
      
      public var returnFunction:Function;
      
      public function EditMode_PickPieceForLink()
      {
         super();
      }
      
      override public function EnterMode() : void
      {
         PhysEditor.CursorText_Show();
         this.pickedObject = null;
      }
      
      override public function InitOnce() : void
      {
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         super.OnMouseDown(param1);
         this.pickedObject = null;
         var _loc2_:LevelObj_Instance = PhysEditor.HitTestPhysObjGraphics(mx,my,true);
         this.pickedObject = _loc2_;
         this.returnFunction(this.pickedObject);
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseWheel(param1:int) : void
      {
      }
      
      override public function Update() : void
      {
      }
      
      override public function Render(param1:BitmapData) : void
      {
         param1.fillRect(Defs.screenRect,4281549909);
         PhysEditor.RenderBackground(param1);
         PhysEditor.Editor_RenderObjects();
         PhysEditor.Editor_RenderPickedObjectsHilight();
         PhysEditor.Editor_RenderMiniMap();
         PhysEditor.Editor_RenderLines();
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         return param2;
      }
   }
}

