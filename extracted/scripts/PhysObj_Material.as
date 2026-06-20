package
{
   public class PhysObj_Material
   {
      
      internal var name:String;
      
      internal var density:Number;
      
      internal var friction:Number;
      
      internal var restitution:Number;
      
      public function PhysObj_Material()
      {
         super();
         this.name = "";
         this.density = 1;
         this.friction = 1;
         this.restitution = 1;
      }
      
      public function Clone() : PhysObj_Material
      {
         var _loc1_:PhysObj_Material = new PhysObj_Material();
         _loc1_.name = this.name;
         _loc1_.density = this.density;
         _loc1_.friction = this.friction;
         _loc1_.restitution = this.restitution;
         return _loc1_;
      }
      
      public function FromXML(param1:XML) : *
      {
         this.name = XmlHelper.GetAttrString(param1.@name,"");
         this.density = XmlHelper.GetAttrNumber(param1.@density,1);
         this.friction = XmlHelper.GetAttrNumber(param1.@friction,1);
         this.restitution = XmlHelper.GetAttrNumber(param1.@restitution,1);
         Utils.trace(" Phys Material " + this.name + "  d:" + this.density + "  f:" + this.friction + "  r:" + this.restitution);
      }
   }
}

