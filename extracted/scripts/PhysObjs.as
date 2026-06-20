package
{
   public class PhysObjs
   {
      
      public var list:Array;
      
      public function PhysObjs()
      {
         super();
         this.list = new Array();
      }
      
      public function InitFromXml(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         var _loc4_:PhysObj = null;
         this.list = new Array();
         _loc2_ = 0;
         while(_loc2_ < param1.physobj.length())
         {
            _loc3_ = param1.physobj[_loc2_];
            _loc4_ = new PhysObj();
            _loc4_.FromXml(_loc3_);
            this.list.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function FindIndexByName(param1:String) : int
      {
         var _loc3_:PhysObj = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this.list)
         {
            if(_loc3_.name == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function FindByName(param1:String) : PhysObj
      {
         var _loc2_:PhysObj = null;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function GetNum() : int
      {
         return this.list.length;
      }
      
      public function GetByIndex(param1:int) : PhysObj
      {
         return this.list[param1];
      }
   }
}

