package EditorPackage
{
   import fl.controls.ComboBox;
   import fl.controls.List;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import fl.events.ListEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import org.flashdevelop.utils.FlashConnect;
   
   public class EditParams
   {
      
      internal static var objParameters:ObjParameters;
      
      internal static var instanceParamsStartY:int;
      
      internal static var instanceParamsStartX:int;
      
      internal static var comboBox:ComboBox;
      
      internal static var tf:TextField;
      
      internal static var AddTextEntry_Callback:Function;
      
      internal static var currentParamIndex:int = 0;
      
      internal static var listBox:List = null;
      
      internal static var listBoxContainer:MovieClip = null;
      
      internal static var entryMC:MovieClip = null;
      
      internal static var pickedPieceForLink:LevelObj_Instance = null;
      
      public function EditParams()
      {
         super();
      }
      
      internal static function ClearParameterListBox() : *
      {
         if(listBoxContainer != null)
         {
            listBoxContainer.parent.removeChild(listBoxContainer);
            listBoxContainer = null;
         }
      }
      
      internal static function PreventPropogationHandler(param1:MouseEvent) : *
      {
         param1.stopImmediatePropagation();
      }
      
      internal static function AddParameterListBox(param1:ObjParameters) : *
      {
         var _loc2_:ObjParameter = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         objParameters = param1;
         currentParamIndex = 0;
         ClearParameterListBox();
         listBoxContainer = new MovieClip();
         listBoxContainer.addEventListener(MouseEvent.CLICK,PreventPropogationHandler);
         listBoxContainer.addEventListener(MouseEvent.MOUSE_DOWN,PreventPropogationHandler);
         listBoxContainer.addEventListener(MouseEvent.MOUSE_UP,PreventPropogationHandler);
         PhysEditor.editorMC.addChild(listBoxContainer);
         listBox = new List();
         listBoxContainer.addChild(listBox);
         listBox.alpha = 1;
         for each(_loc2_ in objParameters.list)
         {
            _loc3_ = new Object();
            _loc4_ = _loc2_.name + " : " + _loc2_.value;
            _loc3_.label = _loc4_;
            _loc3_.data = _loc4_;
            listBox.addItem(_loc3_);
         }
         listBox.height = objParameters.list.length * listBox.rowHeight;
         listBox.width = 200;
         listBoxContainer.y = Defs.displayarea_h - 16 - listBox.height;
         listBoxContainer.x = 16;
         ParameterListBox_SetSelectedIndex();
         listBox.addEventListener(ListEvent.ITEM_CLICK,AddParameterListBox_changeHandler);
      }
      
      internal static function UpdateListBoxItem(param1:int) : *
      {
         var _loc2_:ObjParameter = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         listBox.removeAll();
         for each(_loc2_ in objParameters.list)
         {
            _loc3_ = new Object();
            _loc4_ = _loc2_.name + " : " + _loc2_.value;
            _loc3_.label = _loc4_;
            _loc3_.data = _loc4_;
            listBox.addItem(_loc3_);
         }
      }
      
      internal static function AddParameterListBox_changeHandler(param1:ListEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:List = List(param1.target);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:CellRenderer = _loc2_.itemToCellRenderer(param1.item) as CellRenderer;
         var _loc4_:ListData = _loc3_.listData;
         currentParamIndex = _loc4_.row;
         CurrentAdjustObject_EnterParameter();
      }
      
      internal static function PickLineReturnFunction(param1:PhysLine) : *
      {
         var _loc2_:String = "";
         if(param1 != null)
         {
            _loc2_ = PhysEditor.GetOrCreateUniqueLineID(param1);
            UpdateListBoxItem(currentParamIndex);
         }
         FlashConnect.trace("here " + _loc2_);
         CurrentAdjustObject_UpdateCurrentParameter(_loc2_);
         UpdateListBoxItem(currentParamIndex);
         PhysEditor.SetEditMode(PhysEditor.oldEditMode,false);
         PhysEditor.CursorText_Set("");
      }
      
      internal static function PickObjectReturnFunction(param1:LevelObj_Instance) : *
      {
         var _loc2_:String = "";
         if(param1 != null)
         {
            _loc2_ = PhysEditor.GetOrCreateUniqueObjectID(param1);
            UpdateListBoxItem(currentParamIndex);
         }
         FlashConnect.trace("here1 " + _loc2_);
         CurrentAdjustObject_UpdateCurrentParameter(_loc2_);
         UpdateListBoxItem(currentParamIndex);
         PhysEditor.SetEditMode(PhysEditor.oldEditMode,false);
         PhysEditor.CursorText_Set("");
      }
      
      internal static function CurrentAdjustObject_EnterParameter() : *
      {
         var _loc1_:ObjParameter = objParameters.GetByIndex(currentParamIndex);
         var _loc2_:String = _loc1_.name;
         var _loc3_:ObjParam = Game.objectParameters.GetObjectParamByName(_loc2_);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_.type == "list")
         {
            AddComboBoxEntry(GetParamXpos(currentParamIndex),GetParamYpos(currentParamIndex),_loc3_.name,CurrentAdjustObject_GetSelectedParameterValue(),_loc3_.valueList,CurrentAdjustObject_EnterParameter_Done);
         }
         else if(_loc3_.type == "linelink" && KeyReader.Down(KeyReader.KEY_SHIFT))
         {
            PhysEditor.oldEditMode = PhysEditor.editMode;
            PhysEditor.editModeObj_PickLineForLink.returnFunction = PickLineReturnFunction;
            PhysEditor.SetEditMode(PhysEditor.editMode_PickLineForLink,false);
            PhysEditor.CursorText_Set("Pick Line");
         }
         else if(_loc3_.type == "objlink" && KeyReader.Down(KeyReader.KEY_SHIFT))
         {
            PhysEditor.oldEditMode = PhysEditor.editMode;
            PhysEditor.editModeObj_PickPieceForLink.returnFunction = PickObjectReturnFunction;
            PhysEditor.SetEditMode(PhysEditor.editMode_PickPieceForLink,false);
            PhysEditor.CursorText_Set("Pick Object");
         }
         else
         {
            AddTextEntry(GetParamXpos(PhysEditor.editModeObj_Adjust.currentAdjustObjectParam),GetParamYpos(PhysEditor.editModeObj_Adjust.currentAdjustObjectParam),_loc3_.name,CurrentAdjustObject_GetSelectedParameterValue(),CurrentAdjustObject_EnterParameter_Done);
         }
      }
      
      internal static function CurrentAdjustObject_EnterParameter_Done(param1:String) : *
      {
         CurrentAdjustObject_UpdateCurrentParameter(param1);
         UpdateListBoxItem(currentParamIndex);
      }
      
      internal static function ParameterListBox_SetSelectedIndex() : *
      {
         if(listBoxContainer != null)
         {
            listBox.selectedIndex = currentParamIndex;
         }
      }
      
      internal static function CurrentAdjustObject_UpdateCurrentParameter(param1:String) : void
      {
         var _loc2_:ObjParameter = objParameters.GetByIndex(currentParamIndex);
         _loc2_.value = param1;
      }
      
      internal static function CurrentAdjustObject_GetSelectedParameterName() : String
      {
         var _loc1_:ObjParameter = objParameters.GetByIndex(currentParamIndex);
         return _loc1_.name;
      }
      
      internal static function CurrentAdjustObject_GetSelectedParameterValue() : String
      {
         var _loc1_:ObjParameter = objParameters.GetByIndex(currentParamIndex);
         return _loc1_.value;
      }
      
      internal static function CurrentAdjustObject_SelectNextParameter() : *
      {
         ++currentParamIndex;
         if(currentParamIndex >= objParameters.list.length)
         {
            currentParamIndex = 0;
         }
         ParameterListBox_SetSelectedIndex();
      }
      
      internal static function GetParamXpos(param1:int) : int
      {
         return 230;
      }
      
      internal static function GetParamYpos(param1:int) : int
      {
         return Defs.displayarea_h - 100;
      }
      
      internal static function RemoveEntryMC() : *
      {
         if(entryMC != null)
         {
            entryMC.parent.removeChild(entryMC);
            entryMC = null;
         }
      }
      
      internal static function AddEntryMC() : *
      {
         RemoveEntryMC();
         entryMC = new MovieClip();
         entryMC.x = 0;
         entryMC.y = 0;
         entryMC.graphics.clear();
         entryMC.graphics.beginFill(16777215,0.5);
         entryMC.graphics.drawRect(entryMC.x,entryMC.y,Defs.displayarea_w,Defs.displayarea_h);
         entryMC.graphics.endFill();
         PhysEditor.editorMC.addChild(entryMC);
         entryMC.addEventListener(MouseEvent.CLICK,PreventPropogationHandler);
         entryMC.addEventListener(MouseEvent.MOUSE_DOWN,PreventPropogationHandler);
         entryMC.addEventListener(MouseEvent.MOUSE_UP,PreventPropogationHandler);
      }
      
      internal static function AddComboBoxEntry(param1:int, param2:int, param3:String, param4:String, param5:Array, param6:Function) : *
      {
         var _loc7_:String = null;
         var _loc8_:Object = null;
         AddEntryMC();
         AddTextEntry_Callback = param6;
         comboBox = new ComboBox();
         comboBox.x = param1;
         comboBox.y = param2;
         comboBox.alpha = 1;
         comboBox.width = 300;
         entryMC.addChild(comboBox);
         for each(_loc7_ in param5)
         {
            _loc8_ = new Object();
            _loc8_.label = _loc7_;
            _loc8_.data = _loc7_;
            if(_loc7_ == param4)
            {
               comboBox.selectedItem = _loc8_;
            }
            comboBox.addItem(_loc8_);
         }
         comboBox.prompt = param4;
         PhysEditor.isEntering = true;
         comboBox.addEventListener(Event.CHANGE,AddComboBoxEntry_changeHandler);
         Game.main.stage.focus = comboBox;
      }
      
      internal static function AddComboBoxEntry_changeHandler(param1:Event) : void
      {
         var _loc2_:String = ComboBox(param1.target).selectedItem.data;
         Game.main.stage.focus = null;
         comboBox.close();
         RemoveEntryMC();
         PhysEditor.isEntering = false;
         if(AddTextEntry_Callback != null)
         {
            AddTextEntry_Callback(_loc2_);
         }
      }
      
      internal static function AddTextEntry(param1:int, param2:int, param3:String, param4:String, param5:Function) : *
      {
         var _loc6_:TextFormat = null;
         AddEntryMC();
         AddTextEntry_Callback = param5;
         _loc6_ = new TextFormat();
         _loc6_.size = 20;
         _loc6_.color = 0;
         tf = new TextField();
         tf.name = "tf";
         tf.type = TextFieldType.INPUT;
         entryMC.addChild(tf);
         tf.x = param1;
         tf.y = param2;
         tf.text = param4;
         tf.opaqueBackground = true;
         tf.background = true;
         tf.backgroundColor = 16777215;
         tf.multiline = false;
         tf.setTextFormat(_loc6_);
         tf.setSelection(0,tf.text.length);
         Game.main.stage.focus = tf;
         tf.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,false,0,true);
         PhysEditor.isEntering = true;
      }
      
      internal static function keyDownHandler(param1:KeyboardEvent) : *
      {
         if(PhysEditor.isEntering == false)
         {
            return;
         }
         var _loc2_:TextField = param1.currentTarget as TextField;
         if(param1.charCode == KeyReader.KEY_ENTER)
         {
            if(AddTextEntry_Callback != null)
            {
               AddTextEntry_Callback(_loc2_.text);
            }
            PhysEditor.isEntering = false;
            Game.main.stage.focus = null;
            _loc2_.parent.removeChild(_loc2_);
            _loc2_ = null;
            RemoveEntryMC();
         }
         if(param1.charCode == KeyReader.KEY_ESCAPE)
         {
            Utils.trace("cancelled");
            PhysEditor.isEntering = false;
            Game.main.stage.focus = null;
            _loc2_.parent.removeChild(_loc2_);
            _loc2_ = null;
            RemoveEntryMC();
         }
      }
   }
}

