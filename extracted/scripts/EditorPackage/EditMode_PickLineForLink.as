package EditorPackage
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class EditMode_PickLineForLink extends EditMode_Base
   {
      
      public var pickedLine:PhysLine;
      
      public var returnFunction:Function;
      
      internal var hoveredLine:PhysLine;
      
      public function EditMode_PickLineForLink()
      {
         super();
      }
      
      override public function EnterMode() : void
      {
         PhysEditor.CursorText_Show();
         this.hoveredLine = null;
      }
      
      override public function InitOnce() : void
      {
      }
      
      override public function OnMouseDown(param1:MouseEvent) : void
      {
         this.pickedLine = null;
         super.OnMouseDown(param1);
         PhysEditor.editModeObj_Lines.currentLineIndex = -1;
         var _loc2_:PhysLine = PhysEditor.HitTestLineArea(mx,my);
         this.pickedLine = _loc2_;
         this.returnFunction(this.pickedLine);
      }
      
      override public function OnMouseUp(param1:MouseEvent) : void
      {
      }
      
      override public function OnMouseMove(param1:MouseEvent) : void
      {
         super.OnMouseMove(param1);
         this.hoveredLine = null;
         this.hoveredLine = PhysEditor.HitTestLineArea(mx,my);
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
         PhysEditor.HighlightLinePoly(this.hoveredLine);
      }
      
      override public function RenderHud(param1:int, param2:int) : int
      {
         return param2;
      }
   }
}

