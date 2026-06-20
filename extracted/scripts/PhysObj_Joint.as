package
{
   import EditorPackage.ObjParameters;
   import flash.geom.Point;
   
   public class PhysObj_Joint
   {
      
      public static const Type_Rev:int = 0;
      
      public static const Type_Distance:int = 1;
      
      public static const Type_Prismatic:int = 2;
      
      public static const Type_Mouse:int = 3;
      
      public static const Type_Pulley:int = 4;
      
      public var objParameters:ObjParameters;
      
      public var type:int;
      
      public var name:String;
      
      public var obj0Name:String;
      
      public var obj1Name:String;
      
      public var rev_pos:Point;
      
      public var rev_enableLimit:Boolean;
      
      public var rev_lowerAngle:Number;
      
      public var rev_upperAngle:Number;
      
      public var rev_enableMotor:Boolean;
      
      public var rev_motorSpeed:Number;
      
      public var rev_maxMotorTorque:Number;
      
      public var dist_pos0:Point;
      
      public var dist_pos1:Point;
      
      public var prism_pos:Point;
      
      public var prism_pos1:Point;
      
      public var prism_lowerTranslation:Number;
      
      public var prism_upperTranslation:Number;
      
      public var prism_enableLimit:Boolean;
      
      public var prism_enableMotor:Boolean;
      
      public var prism_motorSpeed:Number;
      
      public var prism_maxMotorForce:Number;
      
      public var prism_axisangle:Number;
      
      public function PhysObj_Joint()
      {
         super();
         this.type = 0;
         this.name = "";
         this.obj0Name = "";
         this.obj1Name = "";
         this.rev_pos = new Point(0,0);
         this.rev_enableLimit = false;
         this.rev_lowerAngle = 0;
         this.rev_upperAngle = 0;
         this.rev_enableMotor = false;
         this.rev_motorSpeed = 0;
         this.rev_maxMotorTorque = 0;
         this.prism_pos = new Point(0,0);
         this.prism_pos1 = new Point(0,0);
         this.prism_lowerTranslation = 0;
         this.prism_upperTranslation = 0;
         this.prism_enableLimit = false;
         this.prism_enableMotor = false;
         this.prism_motorSpeed = 0;
         this.prism_maxMotorForce = 0;
         this.prism_axisangle = 0;
         this.dist_pos0 = new Point(0,0);
         this.dist_pos1 = new Point(0,0);
         this.objParameters = new ObjParameters();
      }
      
      public function SetType(param1:int) : *
      {
         this.type = param1;
         this.objParameters = new ObjParameters();
         if(this.type != Type_Distance)
         {
            if(this.type == Type_Rev)
            {
               this.objParameters.Add("rev_enablelimit","false");
               this.objParameters.Add("rev_lowerangle","0");
               this.objParameters.Add("rev_upperangle","0");
               this.objParameters.Add("rev_enablemotor","false");
               this.objParameters.Add("rev_motorspeed","0");
               this.objParameters.Add("rev_maxmotortorque","0");
            }
            else if(this.type == Type_Prismatic)
            {
               this.objParameters.Add("prismatic_enablelimit","false");
               this.objParameters.Add("prismatic_lowertranslation","0");
               this.objParameters.Add("prismatic_uppertranslation","0");
               this.objParameters.Add("prismatic_enablemotor","false");
               this.objParameters.Add("prismatic_motorspeed","0");
               this.objParameters.Add("prismatic_maxmotorforce","0");
            }
         }
         this.objParameters.Add("joint_initfunction","InitGameObjJoint_Null");
      }
      
      public function Clone() : PhysObj_Joint
      {
         var _loc1_:PhysObj_Joint = new PhysObj_Joint();
         _loc1_.objParameters = this.objParameters.Clone();
         _loc1_.type = this.type;
         _loc1_.name = this.name;
         _loc1_.obj0Name = this.obj0Name;
         _loc1_.obj1Name = this.obj1Name;
         _loc1_.rev_pos = this.rev_pos.clone();
         _loc1_.rev_enableLimit = this.rev_enableLimit;
         _loc1_.rev_lowerAngle = this.rev_lowerAngle;
         _loc1_.rev_upperAngle = this.rev_upperAngle;
         _loc1_.rev_enableMotor = this.rev_enableMotor;
         _loc1_.rev_motorSpeed = this.rev_motorSpeed;
         _loc1_.rev_maxMotorTorque = this.rev_maxMotorTorque;
         _loc1_.prism_pos = this.prism_pos.clone();
         _loc1_.prism_pos1 = this.prism_pos1.clone();
         _loc1_.prism_lowerTranslation = this.prism_lowerTranslation;
         _loc1_.prism_upperTranslation = this.prism_upperTranslation;
         _loc1_.prism_enableLimit = this.prism_enableLimit;
         _loc1_.prism_enableMotor = this.prism_enableMotor;
         _loc1_.prism_motorSpeed = this.prism_motorSpeed;
         _loc1_.prism_maxMotorForce = this.prism_maxMotorForce;
         _loc1_.prism_axisangle = this.prism_axisangle;
         _loc1_.dist_pos0 = this.dist_pos0.clone();
         _loc1_.dist_pos1 = this.dist_pos1.clone();
         return _loc1_;
      }
   }
}

