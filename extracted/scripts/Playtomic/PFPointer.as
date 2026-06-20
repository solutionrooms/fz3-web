package Playtomic
{
   public final class PFPointer
   {
      
      public var FieldName:String;
      
      public var PObject:PFObject;
      
      public function PFPointer(param1:String, param2:PFObject)
      {
         super();
         this.FieldName = param1;
         this.PObject = param2;
      }
   }
}

