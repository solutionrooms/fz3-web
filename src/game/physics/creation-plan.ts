// Creation-order plan: the exact ordered sequence of Box2D world-population calls a level produces,
// with faithful def fields. Mirrors Game.StartLevelPlay's order:
//   InitBox2D (groundBody, engine-internal) → InitLevelPlayFromEditorObjects (instances) → InitLines → InitJoints.
// This is what the engine session goldens against an instrumented-original capture (it must match the
// CreateBody/CreateShape/SetMass/CreateJoint sequence + def args bit-for-bit). It is PURE computation
// (no running world): faithful arithmetic is the point, so MULTIPLICATION ORDER is preserved verbatim —
// these values become b2 def fields and feed the simulation.
//
// Faithful simplifications (verified against FZ3 data, not assumptions):
//  - All physobjs are single-body with body.pos = (0,0) → the AddPhysObjAt body-offset Matrix is identity,
//    so bd.position = (instance.x*w2p, instance.y*w2p). (If a future asset has a non-zero body.pos, the
//    flash.geom.Matrix(rotate→scale→transformPoint) path must be ported.)
//  - FZ3 physobjs have no internal joints; only level joints (InitJoints) connect objects.

import { degToRad } from "../util/utils";
import { triangulate } from "../util/triangulate";
import { getPhysMaterialByName } from "../data/physobj-loader";
import { PhysObjShape, type PhysObjs } from "../model/phys-obj-def";
import { PhysObjJoint } from "../model/phys-obj-joint";
import type { PhysObjMaterial } from "../model/phys-obj-material";
import type { Level } from "../model/level";
import type { LevelObjInstance } from "../model/level-obj-instance";
import type { Pt } from "../util/packed";

const W2P = 1 / 50; // PhysicsBase: p2w = 50, w2p = 1/p2w

export interface BodyDefFields {
  position: { x: number; y: number };
  angle: number;
  linearDamping: number;
  angularDamping: number;
  isBullet: boolean;
  fixedRotation: boolean;
}
export interface ShapeOp {
  shape: "circle" | "polygon";
  density: number;
  friction: number;
  restitution: number;
  categoryBits: number;
  maskBits: number;
  isSensor: boolean;
  // circle
  radius?: number;
  localPosition?: { x: number; y: number };
  // polygon (always a 3-vertex triangle here)
  vertices?: { x: number; y: number }[];
}
export interface BodyOp {
  kind: "body";
  source: "instance" | "line";
  type: string; // physobj typeName, or "wall" for lines
  id: string;
  bodyDef: BodyDefFields;
  shapes: ShapeOp[];
  massMode: "fromShapes" | "static"; // static = PutToSleep + SetMass(empty) / line left static
}
export interface JointOp {
  kind: "joint";
  jointType: "revolute" | "distance" | "prismatic";
  body0: string; // GameObj id / "ground"
  body1: string;
  def: Record<string, number | boolean | { x: number; y: number }>;
}
export type CreationOp = BodyOp | JointOp;

export interface CreationPlan {
  meta: {
    level: string;
    w2p: number;
    note: string;
  };
  ops: CreationOp[];
}

function material(materials: PhysObjMaterial[], name: string): PhysObjMaterial {
  const m = getPhysMaterialByName(materials, name);
  if (m == null) throw new Error(`creation-plan: material not found: ${name}`);
  return m;
}

// PhysicsBase.AddPhysObjAt body+fixture path (single body, pos 0,0). Caller has already applied the
// routing (only instances with bodies>0 AND graphics==0 reach here).
function planInstance(inst: LevelObjInstance, lib: PhysObjs, materials: PhysObjMaterial[]): BodyOp[] {
  const def = lib.findByName(inst.typeName);
  if (def == null) return []; // AS3 logs "can't find object" and returns null
  const rot = degToRad(inst.rot);
  const x = inst.x * W2P;
  const y = inst.y * W2P;
  const scale = inst.scale;
  const out: BodyOp[] = [];
  for (const body of def.bodies) {
    const shapes: ShapeOp[] = [];
    for (const shape of body.shapes) {
      const cat = shape.collisionCategory;
      const mask = shape.collisionMask;
      const mat = material(materials, shape.materialName);
      if (shape.type === PhysObjShape.Type_Poly) {
        const tris = triangulate(shape.poly_points); // ALWAYS triangulated (dead `triangulatePoly==false` branch)
        if (tris == null) continue; // AS3 traces failure and skips
        const numTris = (tris.length / 3) | 0;
        const sc = W2P * scale; // AS3: sc = w2p * scale; then v = p * sc
        for (let t = 0; t < numTris; t++) {
          const p0 = tris[t * 3 + 0], p1 = tris[t * 3 + 1], p2 = tris[t * 3 + 2];
          shapes.push({
            shape: "polygon",
            vertices: [
              { x: p0.x * sc, y: p0.y * sc },
              { x: p1.x * sc, y: p1.y * sc },
              { x: p2.x * sc, y: p2.y * sc },
            ],
            density: mat.density, friction: mat.friction, restitution: mat.restitution,
            categoryBits: cat, maskBits: mask, isSensor: body.sensor,
          });
        }
      } else if (shape.type === PhysObjShape.Type_Circle) {
        shapes.push({
          shape: "circle",
          radius: shape.circle_radius * W2P * scale, // AS3: r * w2p * scale  (this order)
          localPosition: { x: shape.circle_pos.x * scale * W2P, y: shape.circle_pos.y * scale * W2P }, // pos * scale * w2p (this order)
          density: mat.density, friction: mat.friction, restitution: mat.restitution,
          categoryBits: cat, maskBits: mask, isSensor: body.sensor,
        });
      }
    }
    out.push({
      kind: "body", source: "instance", type: inst.typeName, id: inst.id,
      bodyDef: {
        position: { x, y }, angle: rot,
        linearDamping: body.linearDamping, angularDamping: body.angularDamping,
        isBullet: false, fixedRotation: false,
      },
      shapes,
      massMode: body.fixed ? "static" : "fromShapes", // fixed: PutToSleep+SetMass(empty); else SetMassFromShapes+SetBullet(false)
    });
  }
  return out;
}

// Game.InitLines — one static body per type-0 line, positioned at the averaged triangle-centroid;
// triangle fixtures in local coords; filter cat=1/mask=31; material from line_physmaterial.
function planLines(level: Level, materials: PhysObjMaterial[]): BodyOp[] {
  const out: BodyOp[] = [];
  for (const line of level.lines) {
    if (line.type !== 0) continue; // (type!=0 lines use a different filter — not yet needed)
    const pts = line.points;
    const mat = material(materials, line.objParameters.getValueString("line_physmaterial"));
    if (pts.length < 3) continue;
    const tris = triangulate(pts);
    if (tris == null) continue;
    const numTris = (tris.length / 3) | 0;

    // centroid = mean of per-triangle centroids
    let cx = 0, cy = 0;
    for (let t = 0; t < numTris; t++) {
      const p0 = tris[t * 3 + 0], p1 = tris[t * 3 + 1], p2 = tris[t * 3 + 2];
      cx += (p0.x + p1.x + p2.x) / 3;
      cy += (p0.y + p1.y + p2.y) / 3;
    }
    cx /= numTris;
    cy /= numTris;

    const shapes: ShapeOp[] = [];
    for (let t = 0; t < numTris; t++) {
      const p0 = tris[t * 3 + 0], p1 = tris[t * 3 + 1], p2 = tris[t * 3 + 2];
      const v = (p: Pt) => ({ x: (p.x - cx) * W2P, y: (p.y - cy) * W2P }); // subtract centroid THEN ×w2p
      shapes.push({
        shape: "polygon",
        vertices: [v(p0), v(p1), v(p2)],
        density: mat.density, friction: mat.friction, restitution: mat.restitution,
        categoryBits: 1, maskBits: 31, isSensor: false,
      });
    }
    out.push({
      kind: "body", source: "line", type: "wall", id: line.id,
      bodyDef: {
        position: { x: cx * W2P, y: cy * W2P }, angle: 0,
        linearDamping: 0, angularDamping: 0, isBullet: false, fixedRotation: false,
      },
      shapes,
      massMode: line.objParameters.getValueBoolean("line_fixed") ? "static" : "fromShapes",
    });
  }
  return out;
}

// Game.InitJoints — level joints (anchors ×w2p; params from objParameters; collideConnected=false).
function planJoints(level: Level): JointOp[] {
  const out: JointOp[] = [];
  for (const j of level.joints) {
    const body0 = j.obj0Name === "" ? "ground" : j.obj0Name;
    const body1 = j.obj1Name === "" ? "ground" : j.obj1Name;
    const p = j.objParameters;
    if (j.type === PhysObjJoint.Type_Rev) {
      out.push({
        kind: "joint", jointType: "revolute", body0, body1,
        def: {
          anchor: { x: j.rev_pos.x * W2P, y: j.rev_pos.y * W2P },
          enableLimit: p.getValueBoolean("rev_enablelimit"),
          lowerAngle: degToRad(p.getValueNumber("rev_lowerangle")),
          upperAngle: degToRad(p.getValueNumber("rev_upperangle")),
          enableMotor: p.getValueBoolean("rev_enablemotor"),
          motorSpeed: p.getValueNumber("rev_motorspeed"),
          maxMotorTorque: p.getValueNumber("rev_maxmotortorque"),
          collideConnected: false,
        },
      });
    } else if (j.type === PhysObjJoint.Type_Distance) {
      out.push({
        kind: "joint", jointType: "distance", body0, body1,
        def: {
          anchor0: { x: j.dist_pos0.x * W2P, y: j.dist_pos0.y * W2P },
          anchor1: { x: j.dist_pos1.x * W2P, y: j.dist_pos1.y * W2P },
          collideConnected: false,
        },
      });
    } else if (j.type === PhysObjJoint.Type_Prismatic) {
      // axis = normalize(prism_pos1 - prism_pos); anchor = prism_pos × w2p
      let axx = j.prism_pos1.x - j.prism_pos.x;
      let axy = j.prism_pos1.y - j.prism_pos.y;
      const len = Math.sqrt(axx * axx + axy * axy); // b2Vec2.Normalize
      if (len >= Number.MIN_VALUE) { axx /= len; axy /= len; }
      out.push({
        kind: "joint", jointType: "prismatic", body0, body1,
        def: {
          anchor: { x: j.prism_pos.x * W2P, y: j.prism_pos.y * W2P },
          axis: { x: axx, y: axy },
          enableLimit: p.getValueBoolean("prismatic_enablelimit"),
          lowerTranslation: p.getValueNumber("prismatic_lowertranslation") * W2P,
          upperTranslation: p.getValueNumber("prismatic_uppertranslation") * W2P,
          enableMotor: p.getValueBoolean("prismatic_enablemotor"),
          motorSpeed: p.getValueNumber("prismatic_motorspeed"),
          maxMotorForce: p.getValueNumber("prismatic_maxmotorforce"),
          collideConnected: false,
        },
      });
    }
  }
  return out;
}

/** Build the full ordered creation plan for a level (after the engine's InitBox2D groundBody). */
export function buildCreationPlan(level: Level, lib: PhysObjs, materials: PhysObjMaterial[]): CreationPlan {
  const ops: CreationOp[] = [];
  // 1) instances, in level.instances order, with the AS3 routing
  for (const inst of level.instances) {
    const def = lib.findByName(inst.typeName);
    if (def == null) continue;
    if (def.bodies.length === 0) continue; // AddGameObjectAt (no physics)
    if (def.graphics.length !== 0) continue; // AddGameObjectAt (has top-level graphics → no physics body)
    ops.push(...planInstance(inst, lib, materials));
  }
  // 2) lines
  ops.push(...planLines(level, materials));
  // 3) joints
  ops.push(...planJoints(level));
  return {
    meta: {
      level: level.name,
      w2p: W2P,
      note: "Order: instances → lines → joints, after InitBox2D groundBody (engine-internal, userData -1).",
    },
    ops,
  };
}
