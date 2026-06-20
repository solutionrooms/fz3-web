package
{
   public class PhysObj_BodyUserData
   {
      
      public var type:String;
      
      public var bodyName:String;
      
      public var gameObjectIndex:int;
      
      public var id:int;
      
      public function PhysObj_BodyUserData()
      {
         super();
         this.type = "";
         this.bodyName = "";
         this.gameObjectIndex = -1;
         this.id = 0;
      }
      
      public function Clone() : PhysObj_BodyUserData
      {
         var _loc1_:PhysObj_BodyUserData = new PhysObj_BodyUserData();
         _loc1_.type = this.type;
         _loc1_.bodyName = this.bodyName;
         _loc1_.gameObjectIndex = this.gameObjectIndex;
         _loc1_.id = this.id;
         return _loc1_;
      }
   }
}

