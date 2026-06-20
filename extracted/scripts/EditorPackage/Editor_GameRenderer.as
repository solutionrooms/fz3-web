package EditorPackage
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Editor_GameRenderer
   {
      
      public function Editor_GameRenderer()
      {
         super();
      }
      
      internal function RenderHelpText(param1:PhysObj, param2:LevelObj_Instance) : *
      {
         var _loc6_:DisplayObj = null;
         var _loc3_:BitmapData = PhysEditor.screenBD;
         var _loc4_:Point = PhysEditor.GetMapPos(param2.x,param2.y);
         PhysObj.RenderAt(param1,_loc4_.x,_loc4_.y,param2.rot,param2.scale * PhysEditor.zoom,_loc3_,PhysEditor.linesScreen.graphics,true);
         var _loc5_:String = param2.objParameters.GetValueString("helptext_text","helptxt");
         _loc6_ = GraphicObjects.GetDisplayObjByName("helpText");
         _loc6_.origMC.helpClip.help.text = _loc5_;
         _loc6_.RenderAtRotScaled_Vector(_loc6_.GetNumFrames() - 1,_loc3_,_loc4_.x,_loc4_.y,1,0,null,false,false);
      }
      
      internal function RenderNinja(param1:PhysObj, param2:LevelObj_Instance) : *
      {
         var _loc3_:BitmapData = PhysEditor.screenBD;
         var _loc4_:Point = PhysEditor.GetMapPos(param2.x,param2.y);
         PhysObj.RenderAt(param1,_loc4_.x,_loc4_.y,param2.rot,param2.scale * PhysEditor.zoom,_loc3_,PhysEditor.linesScreen.graphics,true);
         var _loc5_:int = 375;
         var _loc6_:int = 250;
         var _loc7_:Point = PhysEditor.GetMapPos(param2.x - _loc5_,param2.y - _loc6_);
         var _loc8_:Point = PhysEditor.GetMapPos(param2.x + _loc5_,param2.y + _loc6_);
         PhysEditor.RenderRectangle(new Rectangle(_loc7_.x,_loc7_.y,_loc8_.x - _loc7_.x,_loc8_.y - _loc7_.y),16711935,3,0.5);
      }
   }
}

