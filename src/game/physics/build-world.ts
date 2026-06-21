// Executes a CreationPlan against the LIVE Box2D engine to populate a real b2World — the game↔engine
// integration. Faithful to PhysicsBase.InitBox2D + the AddPhysObjAt/InitLines/InitJoints call sequence the
// plan encodes. The engine is feature-complete (m6 joints), so jointed levels now build fully: joints are
// created after all bodies (Game.StartLevelPlay order: instances → lines → joints).

import {
  b2World, b2BodyDef, b2Vec2, b2AABB, b2FilterData, b2MassData, b2ContactListener, b2Body,
} from "../../box2d/index";
import { b2PolygonDef } from "../../box2d/Collision/Shapes/b2PolygonDef";
import { b2CircleDef } from "../../box2d/Collision/Shapes/b2CircleDef";
import { b2RevoluteJointDef } from "../../box2d/Dynamics/Joints/b2RevoluteJointDef";
import { b2DistanceJointDef } from "../../box2d/Dynamics/Joints/b2DistanceJointDef";
import { b2PrismaticJointDef } from "../../box2d/Dynamics/Joints/b2PrismaticJointDef";
import type { CreationPlan, BodyOp, ShapeOp, JointOp } from "./creation-plan";

const W2P = 1 / 50;
const PHYS_GRAVITY = 300 * W2P; // GameVars.gravity(300) * w2p — PhysicsBase.physGravity

export interface BuiltWorld {
  world: b2World;
  groundBody: b2Body;
  bodies: b2Body[];
  bodyById: Map<string, b2Body>;
  joints: number; // created joint count (Game.InitJoints)
  skippedJoints: number;
}

type Pt = { x: number; y: number };

// Game.InitJoints — one b2*JointDef per level joint, Initialize(b0,b1,anchor[,...]) then params, then
// CreateJoint. Body resolution matches the original: obj name → instance/line body, else groundBody.
function createJoint(world: b2World, op: JointOp, resolve: (name: string) => b2Body): void {
  const d = op.def;
  const b0 = resolve(op.body0);
  const b1 = resolve(op.body1);
  if (op.jointType === "revolute") {
    const jd = new b2RevoluteJointDef();
    const a = d.anchor as Pt;
    jd.Initialize(b0, b1, new b2Vec2(a.x, a.y));
    jd.enableLimit = d.enableLimit as boolean;
    jd.lowerAngle = d.lowerAngle as number;
    jd.upperAngle = d.upperAngle as number;
    jd.enableMotor = d.enableMotor as boolean;
    jd.motorSpeed = d.motorSpeed as number;
    jd.maxMotorTorque = d.maxMotorTorque as number;
    jd.collideConnected = false;
    world.CreateJoint(jd);
  } else if (op.jointType === "distance") {
    const jd = new b2DistanceJointDef();
    const a0 = d.anchor0 as Pt, a1 = d.anchor1 as Pt;
    jd.Initialize(b0, b1, new b2Vec2(a0.x, a0.y), new b2Vec2(a1.x, a1.y));
    jd.collideConnected = false;
    world.CreateJoint(jd);
  } else {
    const jd = new b2PrismaticJointDef();
    const a = d.anchor as Pt, ax = d.axis as Pt;
    jd.Initialize(b0, b1, new b2Vec2(a.x, a.y), new b2Vec2(ax.x, ax.y));
    jd.enableLimit = d.enableLimit as boolean;
    jd.lowerTranslation = d.lowerTranslation as number;
    jd.upperTranslation = d.upperTranslation as number;
    jd.enableMotor = d.enableMotor as boolean;
    jd.motorSpeed = d.motorSpeed as number;
    jd.maxMotorForce = d.maxMotorForce as number;
    jd.collideConnected = false;
    world.CreateJoint(jd);
  }
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

// Walker init-functions (InitZombieWalk{Left,Right}[Stilts] etc.) call SetUpright(true) + SetMassFromShapes
// right after creation — the body becomes fixedRotation (invI=0) so the zombie can't tip over. Invisible to
// a frame-0 creation check; only a stepped golden catches it (first terrain contact spins a free body).
// All init-functions whose body must be upright (SetUpright(true) + SetMassFromShapes): every walking/riding
// character — zombie walkers (+stilts), zombie unicyclists, and human walkers. (Verified: the grep also
// flagged InitMissileAirStrikeObject, but reading it shows it does NOT SetUpright — excluded.)
const UPRIGHT_INITS = new Set([
  "InitZombieWalkLeft", "InitZombieWalkRight", "InitZombieWalkLeftStilts", "InitZombieWalkRightStilts",
  "InitZombieUnicycleLeft", "InitZombieUnicycleRight", "InitHuman_WalkLeft", "InitHuman_WalkRight",
]);

/** Apply an init-function's STRUCTURAL physics effect at creation (fixture-value effects are folded into the
 *  plan's shapes already). Returns false if the body was destroyed (InitGameObjLine_ForShow). */
function applyStructuralInit(world: b2World, body: b2Body, initFunction: string | undefined): boolean {
  if (initFunction == null) return true;
  if (initFunction === "InitGameObjLine_ForShow") {
    world.DestroyBody(body); // decorative line: created then destroyed (no physics body remains)
    return false;
  }
  if (UPRIGHT_INITS.has(initFunction)) {
    body.SetUpright(true);
    body.SetMassFromShapes(); // recompute mass with fixedRotation → invI = 0
  }
  return true;
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
  let joints = 0;
  let skippedJoints = 0;
  // Game.InitJoints body resolution: name → instance/line body, else (incl. "ground"/not-found) groundBody.
  const resolve = (name: string): b2Body => (name === "ground" ? groundBody : (bodyById.get(name) ?? groundBody));

  // The plan is ordered instances → lines → joints, so all bodies exist before any joint is created.
  for (const op of plan.ops) {
    if (op.kind === "body") {
      const b = createBody(world, op);
      if (!applyStructuralInit(world, b, op.initFunction)) continue; // ForShow → destroyed, no handle kept
      bodies.push(b);
      if (op.id) bodyById.set(op.id, b);
    } else {
      createJoint(world, op, resolve);
      joints++;
    }
  }

  return { world, groundBody, bodies, bodyById, joints, skippedJoints };
}
