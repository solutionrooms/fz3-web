package
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Joints.*;
   
   public class ContactListener extends b2ContactListener
   {
      
      public function ContactListener()
      {
         super();
      }
      
      override public function Remove(param1:b2ContactPoint) : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:Object = null;
         var _loc4_:Object = param1.shape1.GetUserData();
         var _loc5_:Object = param1.shape2.GetUserData();
         var _loc6_:String = "";
         if(_loc4_ != null)
         {
            _loc6_ = _loc4_.name;
         }
         var _loc7_:String = "";
         if(_loc5_ != null)
         {
            _loc7_ = _loc5_.name;
         }
         var _loc8_:b2Body = param1.shape1.GetBody();
         var _loc9_:PhysObj_BodyUserData = _loc8_.GetUserData();
         var _loc10_:b2Body = param1.shape2.GetBody();
         var _loc11_:PhysObj_BodyUserData = _loc10_.GetUserData();
         var _loc12_:GameObj = null;
         var _loc13_:GameObj = null;
         if(_loc9_.gameObjectIndex != -1)
         {
            _loc12_ = GameObjects.objs[_loc9_.gameObjectIndex];
         }
         if(_loc11_.gameObjectIndex != -1)
         {
            _loc13_ = GameObjects.objs[_loc11_.gameObjectIndex];
         }
         if(_loc12_ != null && _loc13_ != null)
         {
            if(_loc12_.onHitRemoveFunction != null)
            {
               _loc12_.hitShapeName = _loc6_;
               _loc13_.hitShapeName = _loc7_;
               _loc12_.hitContactPoint = param1;
               _loc13_.hitContactPoint = param1;
               _loc12_.onHitRemoveFunction(_loc13_);
            }
            if(_loc13_.onHitRemoveFunction != null)
            {
               _loc12_.hitShapeName = _loc6_;
               _loc13_.hitShapeName = _loc7_;
               _loc12_.hitContactPoint = param1;
               _loc13_.hitContactPoint = param1;
               _loc13_.onHitRemoveFunction(_loc12_);
            }
         }
      }
      
      override public function Persist(param1:b2ContactPoint) : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:Object = null;
         var _loc4_:Object = param1.shape1.GetUserData();
         var _loc5_:Object = param1.shape2.GetUserData();
         var _loc6_:String = "";
         if(_loc4_ != null)
         {
            _loc6_ = _loc4_.name;
         }
         var _loc7_:String = "";
         if(_loc5_ != null)
         {
            _loc7_ = _loc5_.name;
         }
         var _loc8_:b2Body = param1.shape1.GetBody();
         var _loc9_:PhysObj_BodyUserData = _loc8_.GetUserData();
         var _loc10_:b2Body = param1.shape2.GetBody();
         var _loc11_:PhysObj_BodyUserData = _loc10_.GetUserData();
         var _loc12_:GameObj = null;
         var _loc13_:GameObj = null;
         if(_loc9_.gameObjectIndex != -1)
         {
            _loc12_ = GameObjects.objs[_loc9_.gameObjectIndex];
         }
         if(_loc11_.gameObjectIndex != -1)
         {
            _loc13_ = GameObjects.objs[_loc11_.gameObjectIndex];
         }
         if(_loc12_ != null && _loc13_ != null)
         {
            if(_loc12_.onHitPersistFunction != null)
            {
               _loc12_.hitShape = param1.shape2;
               _loc13_.hitShape = param1.shape1;
               _loc12_.hitShapeUserData = _loc5_;
               _loc13_.hitShapeUserData = _loc4_;
               _loc12_.hitShapeName = _loc7_;
               _loc13_.hitShapeName = _loc6_;
               _loc12_.hitContactPoint = param1;
               _loc13_.hitContactPoint = param1;
               _loc12_.onHitPersistFunction(_loc13_);
            }
            if(_loc13_.onHitPersistFunction != null)
            {
               _loc12_.hitShape = param1.shape1;
               _loc13_.hitShape = param1.shape2;
               _loc12_.hitShapeUserData = _loc4_;
               _loc13_.hitShapeUserData = _loc5_;
               _loc12_.hitShapeName = _loc6_;
               _loc13_.hitShapeName = _loc7_;
               _loc12_.hitContactPoint = param1;
               _loc13_.hitContactPoint = param1;
               _loc13_.onHitPersistFunction(_loc12_);
            }
         }
      }
      
      override public function Add(param1:b2ContactPoint) : void
      {
         var _loc2_:GameObj = null;
         var _loc3_:Object = null;
         var _loc4_:Object = param1.shape1.GetUserData();
         var _loc5_:Object = param1.shape2.GetUserData();
         var _loc6_:String = "aaa";
         if(_loc4_ != null)
         {
            _loc6_ = _loc4_.name;
         }
         var _loc7_:String = "bbb";
         if(_loc5_ != null)
         {
            _loc7_ = _loc5_.name;
         }
         var _loc8_:b2Body = param1.shape1.GetBody();
         var _loc9_:PhysObj_BodyUserData = _loc8_.GetUserData();
         var _loc10_:b2Body = param1.shape2.GetBody();
         var _loc11_:PhysObj_BodyUserData = _loc10_.GetUserData();
         var _loc12_:GameObj = null;
         var _loc13_:GameObj = null;
         if(_loc9_.gameObjectIndex != -1)
         {
            _loc12_ = GameObjects.objs[_loc9_.gameObjectIndex];
         }
         if(_loc11_.gameObjectIndex != -1)
         {
            _loc13_ = GameObjects.objs[_loc11_.gameObjectIndex];
         }
         if(_loc12_ != null && _loc13_ == null)
         {
            _loc12_.hitShapeName = _loc7_;
            _loc12_.hitContactPoint = param1;
            if(_loc12_.onHitSceneryFunction != null)
            {
               _loc12_.onHitSceneryFunction(null);
            }
         }
         if(_loc13_ != null && _loc12_ == null)
         {
            _loc13_.hitShapeName = _loc6_;
            _loc13_.hitContactPoint = param1;
            if(_loc13_.onHitSceneryFunction != null)
            {
               _loc13_.onHitSceneryFunction(null);
            }
         }
         if(_loc12_ != null && _loc13_ != null)
         {
            if(_loc12_.onHitFunction != null)
            {
               _loc12_.hitShape = param1.shape2;
               _loc13_.hitShape = param1.shape1;
               _loc12_.hitShapeUserData = _loc5_;
               _loc13_.hitShapeUserData = _loc4_;
               _loc12_.hitShapeName = _loc7_;
               _loc13_.hitShapeName = _loc6_;
               _loc12_.hitContactPoint = param1;
               _loc13_.hitContactPoint = param1;
               _loc12_.onHitFunction(_loc13_);
            }
            if(_loc13_.onHitFunction != null)
            {
               _loc12_.hitShape = param1.shape1;
               _loc13_.hitShape = param1.shape2;
               _loc12_.hitShapeUserData = _loc4_;
               _loc13_.hitShapeUserData = _loc5_;
               _loc12_.hitShapeName = _loc6_;
               _loc13_.hitShapeName = _loc7_;
               _loc12_.hitContactPoint = param1;
               _loc13_.hitContactPoint = param1;
               _loc13_.onHitFunction(_loc12_);
            }
         }
      }
   }
}

