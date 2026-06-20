package EditorPackage
{
   public class ObjParameter
   {
      
      public var name:String;
      
      public var value:String;
      
      public function ObjParameter()
      {
         super();
      }
      
      public function Clone() : ObjParameter
      {
         var _loc1_:ObjParameter = new ObjParameter();
         _loc1_.name = this.name;
         _loc1_.value = this.value;
         return _loc1_;
      }
   }
}

