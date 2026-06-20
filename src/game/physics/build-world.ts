// Executes a CreationPlan against the LIVE Box2D engine to populate a real b2World — the game↔engine
// integration. Faithful to PhysicsBase.InitBox2D + the AddPhysObjAt/InitLines call sequence the plan
// encodes. Joints (CreateJoint) are m6 in the engine, so jointed levels build their bodies only (joints
// recorded as skipped) — Intro 1 has none and builds fully on the current engine.

import {
  b2World, b2BodyDef, b2Vec2, b2AABB, b2FilterData, b2MassData, b2ContactListener, b2Body,
} from "../../box2d/index";
import { b2PolygonDef } from "../../box2d/Collision/Shapes/b2PolygonDef";
import { b2CircleDef } from "../../box2d/Collision/Shapes/b2CircleDef";
import type { CreationPlan, BodyOp, ShapeOp } from "./creation-plan";

const W2P = 1 / 50;
const PHYS_GRAVITY = 300 * W2P; // GameVars.gravity(300) * w2p — PhysicsBase.physGravity

export interface BuiltWorld {
  world: b2World;
  groundBody: b2Body;
  bodies: b2Body[];
  bodyById: Map<string, b2Body>;
  skippedJoints: number;
}

function filter(s: ShapeOp): b2FilterData {
  const fd = new b2FilterData();
  fd.categoryBits = s.categoryBits;
  fd.maskBits = s.maskBits;
  return fd;
}

function createBody(world: b2World, op: BodyOp): b2Body {
  const bd = new b2BodyDef();
  bd.position.Set(op.bodyDef.position.x, op.bodyDef.position.y);
  bd.angle = op.bodyDef.angle;
  bd.linearDamping = op.bodyDef.linearDamping;
  bd.angularDamping = op.bodyDef.angularDamping;
  const b = world.CreateBody(bd)!;

  for (const s of op.shapes) {
    if (s.shape === "polygon") {
      const pd = new b2PolygonDef();
      pd.vertexCount = s.vertices!.length;
      for (let i = 0; i < s.vertices!.length; i++) pd.vertices[i].Set(s.vertices![i].x, s.vertices![i].y);
      pd.filter = filter(s);
      pd.isSensor = s.isSensor;
      pd.friction = s.friction;
      pd.restitution = s.restitution;
      pd.density = s.density;
      b.CreateShape(pd);
    } else {
      const cd = new b2CircleDef();
      cd.radius = s.radius!;
      cd.localPosition.x = s.localPosition!.x;
      cd.localPosition.y = s.localPosition!.y;
      cd.filter = filter(s);
      cd.isSensor = s.isSensor;
      cd.friction = s.friction;
      cd.restitution = s.restitution;
      cd.density = s.density;
      b.CreateShape(cd);
    }
  }

  if (op.massMode === "static") {
    b.PutToSleep();
    b.SetMass(new b2MassData());
  } else {
    b.SetMassFromShapes();
    b.SetBullet(false);
  }
  // AddPhysObjAt zeroes the instance body's velocity (lines don't); harmless on a fresh body.
  if (op.source === "instance") {
    b.SetAngularVelocity(0);
    b.SetLinearVelocity(new b2Vec2(0, 0));
  }
  return b;
}

/** PhysicsBase.InitBox2D + execute the plan. Returns the live world + body handles. */
export function buildWorld(plan: CreationPlan): BuiltWorld {
  // InitBox2D
  const aabb = new b2AABB();
  aabb.lowerBound.Set(-2500, -2500);
  aabb.upperBound.Set(2500, 2500);
  const world = new b2World(aabb, new b2Vec2(0, PHYS_GRAVITY), true);
  const groundBody = world.GetGroundBody();
  groundBody.SetUserData(-1);
  world.SetContactListener(new b2ContactListener()); // base no-op; the game's ContactListener (logic) is a separate port

  const bodies: b2Body[] = [];
  const bodyById = new Map<string, b2Body>();
  let skippedJoints = 0;

  for (const op of plan.ops) {
    if (op.kind === "body") {
      const b = createBody(world, op);
      bodies.push(b);
      if (op.id) bodyById.set(op.id, b);
    } else {
      skippedJoints++; // CreateJoint is m6 in the engine; recorded, not attempted
    }
  }

  return { world, groundBody, bodies, bodyById, skippedJoints };
}
