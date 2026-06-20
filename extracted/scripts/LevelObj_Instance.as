package
{
   import EditorPackage.ObjParameters;
   
   public class LevelObj_Instance
   {
      
      public var id:String = "";
      
      public var instanceName:String;
      
      public var initFunctionParams:String;
      
      public var typeName:String;
      
      public var x:Number;
      
      public var y:Number;
      
      public var rot:Number;
      
      public var scale:Number;
      
      public var objParameters:ObjParameters;
      
      public var sortZ:Number;
      
      public var frame:Number;
      
      public function LevelObj_Instance()
      {
         super();
         this.scale = 1;
         this.instanceName = "";
         this.typeName = "";
         this.x = this.y = 0;
         this.objParameters = new ObjParameters();
      }
      
      public function Clone() : LevelObj_Instance
      {
         var _loc1_:LevelObj_Instance = new LevelObj_Instance();
         _loc1_.instanceName = this.instanceName;
         _loc1_.typeName = this.typeName;
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         _loc1_.rot = this.rot;
         _loc1_.scale = this.scale;
         _loc1_.id = this.id;
         _loc1_.objParameters = this.objParameters.Clone();
         return _loc1_;
      }
   }
}

