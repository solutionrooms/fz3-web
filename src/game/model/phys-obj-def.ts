import { asNumber } from "../util/as3";
import { getAttrString, getAttrInt, getAttrNumber, getAttrBoolean } from "../util/xml-helper";
import { pointFromString, pointArrayFromString, type Pt } from "../util/packed";
import { degToRad, booleanFromString } from "../util/utils";
import type { PhysObjDef as PhysObjData, BodyDef, ShapeDef, GraphicDef } from "../../../contracts/game-data";

// Port of PhysObj_Graphic.as (+ PhysObj.GetGraphic, PhysObj.as:280). graphicID is resolved later from
// graphicName via GraphicObjects (render side) — deferred here; we keep the name and leave id = 0.
export class PhysObjGraphic {
  graphicName = "";
  graphicID = 0;
  frame = 0;
  offset: Pt = { x: 0, y: 0 };
  rot = 0;
  zoffset = 0;
  hasShadow = true;
  goInitFuntion = "";
  goInitFuntionVarString = "";

  static fromData(g: GraphicDef): PhysObjGraphic {
    const o = new PhysObjGraphic();
    o.goInitFuntion = getAttrString((g as { gameobjfunction?: string }).gameobjfunction, "");
    o.goInitFuntionVarString = getAttrString((g as { gameobjvars?: string }).gameobjvars, "");
    o.graphicName = getAttrString(g.clip, "");
    o.graphicID = 0;
    o.frame = getAttrInt(g.frame) - 1; // 0-based (GetGraphic: GetAttrInt(@frame) - 1)
    o.offset = pointFromString(getAttrString(g.pos, ""));
    o.zoffset = getAttrNumber(g.zoffset, 0);
    o.hasShadow = getAttrBoolean((g as { shadow?: string }).shadow, true);
    o.rot = asNumber(g.rot);
    return o;
  }
}

// Port of PhysObj_Shape.as.
export class PhysObjShape {
  static readonly Type_Poly = 0;
  static readonly Type_Circle = 1;

  type = 0;
  name = "";
  collisionCategory = 0;
  collisionMask = 0;
  materialName = "";
  density = 0;
  friction = 0;
  restitution = 0;
  poly_points: Pt[] = [];
  poly_rot = 0;
  circle_pos: Pt = { x: 0, y: 0 };
  circle_radius = 0;

  /** PhysObj_Shape.Caclulate [sic] — for polys, rotate poly_points by poly_rot (Matrix.rotate). */
  calculate(): void {
    if (this.type === PhysObjShape.Type_Poly) {
      const c = Math.cos(this.poly_rot);
      const s = Math.sin(this.poly_rot);
      // flash Matrix.rotate then transformPoint: (x*c - y*s, x*s + y*c)
      this.poly_points = this.poly_points.map((p) => ({ x: p.x * c - p.y * s, y: p.x * s + p.y * c }));
    }
  }

  static fromData(sh: ShapeDef): PhysObjShape {
    const o = new PhysObjShape();
    o.name = getAttrString(sh.name, "");
    const type = getAttrString(sh.type, "");
    const col = pointFromString(getAttrString(sh.col, "")); // "category,mask"
    o.collisionCategory = col.x | 0;
    o.collisionMask = col.y | 0;
    o.materialName = getAttrString(sh.material, "");
    o.density = getAttrNumber((sh as { density?: string }).density);
    o.friction = getAttrNumber((sh as { friction?: string }).friction);
    o.restitution = getAttrNumber((sh as { restitution?: string }).restitution);
    if (type === "circle") {
      o.type = PhysObjShape.Type_Circle;
      o.circle_pos = pointFromString(getAttrString(sh.pos, ""));
      o.circle_radius = getAttrNumber(sh.radius);
    } else if (type === "poly") {
      o.type = PhysObjShape.Type_Poly;
      o.poly_points = pointArrayFromString(getAttrString(sh.vertices, ""));
      o.poly_rot = degToRad(getAttrNumber((sh as { rot?: string }).rot));
    }
    o.calculate();
    return o;
  }
}

// Port of PhysObj_Body.as. Note: FromXml OVERRIDES the constructor damping defaults (0.1/1) to 0/0.
export class PhysObjBody {
  name = "";
  shapes: PhysObjShape[] = [];
  graphics: PhysObjGraphic[] = [];
  fixed = true;
  sensor = false;
  linearDamping = 0;
  angularDamping = 0;
  pos: Pt = { x: 0, y: 0 };

  static fromData(b: BodyDef): PhysObjBody {
    const o = new PhysObjBody();
    o.name = getAttrString(b.name, "");
    o.fixed = booleanFromString(b.fixed);
    o.sensor = booleanFromString(b.sensor);
    o.pos = pointFromString(getAttrString(b.pos, ""));
    o.linearDamping = 0;
    o.angularDamping = 0;
    for (const g of b.graphic) o.graphics.push(PhysObjGraphic.fromData(g));
    for (const sh of b.shapes) o.shapes.push(PhysObjShape.fromData(sh));
    return o;
  }
}

/**
 * Port of PhysObj.as (the library object definition). FZ3 data has no <joint>, <sfx>, or @initparams
 * under <physobj>, so internal joints / sfx / initparams are inert here (kept for fidelity).
 */
export class PhysObj {
  bodies: PhysObjBody[] = [];
  graphics: PhysObjGraphic[] = [];
  instanceParams: string[] = [];
  instanceParamsDefaults: string[] = [];
  name = "";
  displayInLibrary = false;
  editorRenderFunctionName: string | null = null;
  initFunctionName: string | null = null;
  initFunctionParameters = "";
  libraryClass = "";
  hasPhysics = true;

  // sfx / game-specific (zombooka) — render/gameplay metadata
  sfx_break = "";
  sfx_hit = "";
  zombooka_HitDamage = 0;
  zombooka_SuperHitDamage = 0;
  zombooka_greatkill = false;
  zombooka_hitZombieSound = "";
  zombooka_hitMissileSound = "";

  static fromData(d: PhysObjData): PhysObj {
    const o = new PhysObj();
    o.name = getAttrString(d.name, "");
    o.displayInLibrary = getAttrBoolean(d.inlibrary, false);
    o.initFunctionName = d.initfunction != null ? String(d.initfunction) : null;
    o.editorRenderFunctionName = d.editorrender != null ? String(d.editorrender) : null;
    o.initFunctionParameters = getAttrString((d as { initparams?: string }).initparams, "");
    o.libraryClass = getAttrString(d.libclass, "");
    o.hasPhysics = getAttrBoolean(d.hasphysics, true);

    // zombooka[0] (GetGameSpecific)
    const z = d.zombooka[0];
    if (z) {
      o.zombooka_HitDamage = getAttrNumber(z.hitdamage, 0);
      o.zombooka_SuperHitDamage = getAttrNumber(z.superhitdamage, 0);
      o.zombooka_greatkill = getAttrBoolean(z.greatkill, false);
    }

    for (const p of d.parameters) {
      o.instanceParams.push(getAttrString(p.name, ""));
      o.instanceParamsDefaults.push(getAttrString(p.default, ""));
    }
    for (const g of d.graphics) o.graphics.push(PhysObjGraphic.fromData(g));
    for (const b of d.bodies) o.bodies.push(PhysObjBody.fromData(b));
    return o;
  }

  bodyIndexFromName(name: string): number {
    for (let i = 0; i < this.bodies.length; i++) if (this.bodies[i].name === name) return i;
    return 0;
  }
}

/** Port of PhysObjs.as — the object-definition library (Game.objectDefs). */
export class PhysObjs {
  list: PhysObj[] = [];

  initFromData(defs: PhysObjData[]): void {
    this.list = [];
    for (const d of defs) this.list.push(PhysObj.fromData(d));
  }

  findByName(name: string): PhysObj | null {
    for (const o of this.list) if (o.name === name) return o;
    return null;
  }
  findIndexByName(name: string): number {
    for (let i = 0; i < this.list.length; i++) if (this.list[i].name === name) return i;
    return 0;
  }
  getNum(): number {
    return this.list.length;
  }
  getByIndex(i: number): PhysObj {
    return this.list[i];
  }
}
