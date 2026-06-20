package
{
   import Box2D.Collision.Shapes.b2CircleDef;
   import Box2D.Collision.Shapes.b2FilterData;
   import Box2D.Collision.Shapes.b2MassData;
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2AABB;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2MouseJoint;
   import Box2D.Dynamics.Joints.b2MouseJointDef;
   import Box2D.Dynamics.Joints.b2PrismaticJointDef;
   import Box2D.Dynamics.Joints.b2PulleyJointDef;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2World;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class PhysicsBase
   {
      
      public static var world:b2World;
      
      internal static var groundBody:b2Body;
      
      internal static var physNumIterations:int = 5;
      
      internal static var physStep:Number = 1 / 60;
      
      internal static var p2w:Number = 50;
      
      internal static var w2p:Number = 1 / p2w;
      
      public static var physGravity:Number = GameVars.gravity * w2p;
      
      internal static var mouseJoint:b2MouseJoint = null;
      
      public function PhysicsBase()
      {
         super();
      }
      
      public static function InitBox2D() : void
      {
         mouseJoint = null;
         var _loc1_:b2AABB = new b2AABB();
         _loc1_.lowerBound.Set(-2500,-2500);
         _loc1_.upperBound.Set(2500,2500);
         var _loc2_:b2Vec2 = new b2Vec2(0,physGravity);
         var _loc3_:Boolean = true;
         world = new b2World(_loc1_,_loc2_,_loc3_);
         groundBody = world.GetGroundBody();
         groundBody.SetUserData(-1);
         var _loc4_:ContactListener = new ContactListener();
         world.SetContactListener(_loc4_);
      }
      
      internal static function AddPhysObjAt(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:String = "", param7:String = "", param8:String = "") : GameObj
      {
         var rot:Number;
         var instance:LevelObj_Instance;
         var m:Matrix;
         var physobj:PhysObj = null;
         var jointxoff:Number = NaN;
         var jointyoff:Number = NaN;
         var bd:b2BodyDef = null;
         var b:b2Body = null;
         var pd:b2PolygonDef = null;
         var cd:b2CircleDef = null;
         var i:int = 0;
         var jnt:b2Joint = null;
         var body:PhysObj_Body = null;
         var joint:PhysObj_Joint = null;
         var bodyxoff:Number = NaN;
         var bodyyoff:Number = NaN;
         var p:Point = null;
         var bud:PhysObj_BodyUserData = null;
         var shape:PhysObj_Shape = null;
         var graphic:PhysObj_Graphic = null;
         var fd:b2FilterData = null;
         var physMaterial:PhysObj_Material = null;
         var triangulatePoly:Boolean = false;
         var b2sh:b2Shape = null;
         var o:Object = null;
         var pt:Point = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var points:Array = null;
         var triangulate:Triangulate = null;
         var triangulatedVerts:Array = null;
         var numTris:int = 0;
         var t:int = 0;
         var p0:Point = null;
         var p1:Point = null;
         var p2:Point = null;
         var sc:Number = NaN;
         var a:int = 0;
         var j0index:int = 0;
         var j1index:int = 0;
         var jb0:b2Body = null;
         var jb1:b2Body = null;
         var rjd:b2RevoluteJointDef = null;
         var pjd:b2PrismaticJointDef = null;
         var aa:Number = NaN;
         var axis:b2Vec2 = null;
         var ppd:b2PulleyJointDef = null;
         var djd:b2DistanceJointDef = null;
         var jointxoff1:Number = NaN;
         var jointyoff1:Number = NaN;
         var mjd:b2MouseJointDef = null;
         var objName:String = param1;
         var _x:Number = param2;
         var _y:Number = param3;
         var _rotDeg:Number = param4;
         var scale:Number = param5;
         var instanceName:String = param6;
         var initParams:String = param7;
         var _id:String = param8;
         var go:GameObj = GameObjects.AddObj(x,y,0);
         physobj = Game.objectDefs.FindByName(objName);
         if(physobj == null)
         {
            Utils.trace("error in AddPhysObjAt() - can\'t find object " + objName);
            return null;
         }
         rot = Utils.DegToRad(_rotDeg);
         _x *= PhysicsBase.w2p;
         _y *= PhysicsBase.w2p;
         instance = new LevelObj_Instance();
         instance.typeName = objName;
         instance.x = _x;
         instance.y = _y;
         go.bodies = new Vector.<b2Body>();
         go.joints = new Array();
         go.initParams = initParams;
         go.id = _id;
         go.physobj = Game.objectDefs.FindByName(objName);
         go.initFunctionVarString = physobj.initFunctionParameters;
         go.dir = _rotDeg;
         go.scale = scale;
         go.colFlag_isPhysObj = true;
         go.isPhysObj = true;
         go.physObjOffsetX = 0;
         go.physObjOffsetY = 0;
         m = new Matrix();
         m.rotate(rot);
         m.scale(scale,scale);
         if(physobj.bodies.length > 1)
         {
            Utils.trace("EEEEEEEEERRRRRRRROOOOOOOOOORRRRR physobj.bodies.length= " + physobj.bodies.length);
         }
         for each(body in physobj.bodies)
         {
            bd = new b2BodyDef();
            bodyxoff = body.pos.x * PhysicsBase.w2p;
            bodyyoff = body.pos.y * PhysicsBase.w2p;
            p = new Point(bodyxoff,bodyyoff);
            p = m.transformPoint(p);
            bodyxoff = p.x;
            bodyyoff = p.y;
            bd.position.Set(_x + bodyxoff,_y + bodyyoff);
            bd.angularDamping = body.angularDamping;
            bd.linearDamping = body.linearDamping;
            bd.angle = rot;
            b = PhysicsBase.world.CreateBody(bd);
            bud = new PhysObj_BodyUserData();
            bud.type = objName;
            bud.bodyName = body.name;
            bud.gameObjectIndex = go.listIndex;
            b.SetUserData(bud);
            if(body.graphics.length != 0)
            {
               graphic = body.graphics[0];
               go.zpos = graphic.zoffset;
               go.dobj = GraphicObjects.GetDisplayObjByIndex(graphic.graphicID);
               go.frame = graphic.frame;
            }
            for each(shape in body.shapes)
            {
               fd = new b2FilterData();
               fd.categoryBits = shape.collisionCategory;
               fd.maskBits = shape.collisionMask;
               physMaterial = Game.GetPhysMaterialByName(shape.materialName);
               if(shape.type == PhysObj_Shape.Type_Poly)
               {
                  triangulatePoly = true;
                  if(triangulatePoly == false)
                  {
                     pd = new b2PolygonDef();
                     pd.vertexCount = shape.poly_points.length;
                     pd.filter = fd;
                     pd.isSensor = body.sensor;
                     i = 0;
                     while(i < shape.poly_points.length)
                     {
                        pt = shape.poly_points[i].clone();
                        x = pt.x * scale * PhysicsBase.w2p;
                        y = pt.y * scale * PhysicsBase.w2p;
                        pd.vertices[i].Set(x,y);
                        i++;
                     }
                     pd.friction = physMaterial.friction;
                     pd.restitution = physMaterial.restitution;
                     pd.density = physMaterial.density;
                     b2sh = b.CreateShape(pd);
                     o = new Object();
                     o.origShape = shape;
                     o.name = shape.name;
                     b2sh.SetUserData(o);
                  }
                  else
                  {
                     points = shape.poly_points;
                     if(points.length >= 3)
                     {
                        triangulate = new Triangulate();
                        triangulatedVerts = triangulate.process(points);
                        if(triangulatedVerts == null)
                        {
                           Utils.trace("object failed triangulating: " + points.length);
                        }
                        else
                        {
                           Utils.trace("object triangulating: " + points.length + "  ->  " + triangulatedVerts.length);
                        }
                        numTris = int(triangulatedVerts.length / 3);
                        t = 0;
                        while(t < numTris)
                        {
                           p0 = triangulatedVerts[t * 3 + 0];
                           p1 = triangulatedVerts[t * 3 + 1];
                           p2 = triangulatedVerts[t * 3 + 2];
                           pd = new b2PolygonDef();
                           pd.vertexCount = 3;
                           pd.filter = fd;
                           pd.isSensor = body.sensor;
                           sc = PhysicsBase.w2p * scale;
                           pd.vertices[0].Set(p0.x * sc,p0.y * sc);
                           pd.vertices[1].Set(p1.x * sc,p1.y * sc);
                           pd.vertices[2].Set(p2.x * sc,p2.y * sc);
                           pd.friction = physMaterial.friction;
                           pd.restitution = physMaterial.restitution;
                           pd.density = physMaterial.density;
                           b2sh = b.CreateShape(pd);
                           o = new Object();
                           o.origShape = shape;
                           o.name = shape.name;
                           b2sh.SetUserData(o);
                           t++;
                        }
                     }
                  }
               }
               else if(shape.type == PhysObj_Shape.Type_Circle)
               {
                  cd = new b2CircleDef();
                  cd.radius = shape.circle_radius * PhysicsBase.w2p * scale;
                  cd.filter = fd;
                  cd.isSensor = body.sensor;
                  if(shape.circle_pos.y != 0)
                  {
                     a = 99;
                  }
                  cd.localPosition.x = shape.circle_pos.x * scale * w2p;
                  cd.localPosition.y = shape.circle_pos.y * scale * w2p;
                  cd.friction = physMaterial.friction;
                  cd.restitution = physMaterial.restitution;
                  cd.density = physMaterial.density;
                  b2sh = b.CreateShape(cd);
                  o = new Object();
                  o.origShape = shape;
                  o.name = shape.name;
                  b2sh.SetUserData(o);
               }
            }
            if(body.fixed)
            {
               b.PutToSleep();
               b.SetMass(new b2MassData());
            }
            else
            {
               b.SetMassFromShapes();
               b.SetBullet(false);
            }
            b.SetAngularVelocity(0);
            b.SetLinearVelocity(new b2Vec2(0,0));
            go.bodies.push(b);
         }
         for each(joint in physobj.joints)
         {
            j0index = physobj.BodyIndexFromName(joint.obj0Name);
            j1index = physobj.BodyIndexFromName(joint.obj1Name);
            jb0 = go.bodies[j0index];
            jb1 = go.bodies[j1index];
            if(joint.type == PhysObj_Joint.Type_Rev)
            {
               rjd = new b2RevoluteJointDef();
               jointxoff = joint.rev_pos.x * PhysicsBase.w2p;
               jointyoff = joint.rev_pos.y * PhysicsBase.w2p;
               p = new Point(jointxoff,jointyoff);
               p = m.transformPoint(p);
               jointxoff = p.x;
               jointyoff = p.y;
               rjd.Initialize(jb0,jb1,new b2Vec2(_x + jointxoff,_y + jointyoff));
               rjd.enableLimit = joint.rev_enableLimit;
               rjd.lowerAngle = joint.rev_lowerAngle;
               rjd.upperAngle = joint.rev_upperAngle;
               rjd.enableMotor = joint.rev_enableMotor;
               rjd.motorSpeed = joint.rev_motorSpeed;
               rjd.maxMotorTorque = joint.rev_maxMotorTorque;
               rjd.collideConnected = false;
               jnt = PhysicsBase.world.CreateJoint(rjd);
            }
            if(joint.type == PhysObj_Joint.Type_Prismatic)
            {
               pjd = new b2PrismaticJointDef();
               jointxoff = joint.prism_pos.x * PhysicsBase.w2p;
               jointyoff = joint.prism_pos.y * PhysicsBase.w2p;
               p = new Point(jointxoff,jointyoff);
               p = m.transformPoint(p);
               jointxoff = p.x;
               jointyoff = p.y;
               joint.prism_axisangle = 0;
               aa = Utils.DegToRad(joint.prism_axisangle);
               axis = new b2Vec2(Math.cos(aa),Math.sin(aa));
               pjd.Initialize(jb0,jb1,new b2Vec2(_x + jointxoff,_y + jointyoff),axis);
               pjd.enableLimit = joint.prism_enableLimit;
               pjd.lowerTranslation = joint.prism_lowerTranslation * PhysicsBase.w2p;
               pjd.upperTranslation = joint.prism_upperTranslation * PhysicsBase.w2p;
               pjd.enableMotor = joint.prism_enableMotor;
               pjd.motorSpeed = joint.prism_motorSpeed;
               pjd.maxMotorForce = joint.prism_maxMotorForce;
               pjd.collideConnected = false;
               jnt = PhysicsBase.world.CreateJoint(pjd);
            }
            if(joint.type == PhysObj_Joint.Type_Pulley)
            {
               ppd = new b2PulleyJointDef();
            }
            if(joint.type == PhysObj_Joint.Type_Distance)
            {
               djd = new b2DistanceJointDef();
               jointxoff = joint.dist_pos0.x * PhysicsBase.w2p;
               jointyoff = joint.dist_pos0.y * PhysicsBase.w2p;
               jointxoff1 = joint.dist_pos1.x * PhysicsBase.w2p;
               jointyoff1 = joint.dist_pos1.y * PhysicsBase.w2p;
               p = new Point(jointxoff,jointyoff);
               p = m.transformPoint(p);
               jointxoff = p.x;
               jointyoff = p.y;
               p = new Point(jointxoff1,jointyoff1);
               p = m.transformPoint(p);
               jointxoff1 = p.x;
               jointyoff1 = p.y;
               djd.Initialize(jb0,jb1,new b2Vec2(_x + jointxoff,_y + jointyoff),new b2Vec2(_x + jointxoff1,_y + jointyoff1));
               djd.dampingRatio = 0.1;
               djd.collideConnected = false;
               jnt = PhysicsBase.world.CreateJoint(djd);
            }
            if(joint.type == PhysObj_Joint.Type_Mouse)
            {
               mjd = new b2MouseJointDef();
               mjd.target.Set(jb0.GetPosition().x,jb0.GetPosition().y);
               mjd.body1 = PhysicsBase.world.GetGroundBody();
               mjd.body2 = jb0;
               mjd.maxForce = 30000 * jb0.GetMass();
               mjd.dampingRatio = 0.7;
               mjd.frequencyHz = 10;
               mjd.timeStep = 1 / 60;
               jnt = PhysicsBase.world.CreateJoint(mjd);
               PhysicsBase.mouseJoint = jnt as b2MouseJoint;
            }
            go.joints.push(jnt);
         }
         try
         {
            GameObjects.UpdateSingleGOsFromPhysics(go);
            go[physobj.initFunctionName]();
         }
         catch(err:Error)
         {
            Utils.trace("init function doesn\'t exist: " + physobj.initFunctionName);
         }
         return go;
      }
   }
}

