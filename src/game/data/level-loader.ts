import { asNumber } from "../util/as3";
import { getAttrString, getAttrInt, getAttrNumber } from "../util/xml-helper";
import { pointArrayFromString, hexArrayFromString } from "../util/packed";
import { Level } from "../model/level";
import { LevelObjInstance } from "../model/level-obj-instance";
import { PhysObjJoint } from "../model/phys-obj-joint";
import { PhysLine } from "../model/phys-line";
import type {
  Level as LevelData,
  ObjPlacement,
  JointDef,
  Constants,
} from "../../../contracts/game-data";

// Levels.CreateLevelObjInstanceAt (Levels.as:385)
function createLevelObjInstanceAt(
  typeName: string,
  x: number,
  y: number,
  rot: number,
  scale: number,
  instanceName: string,
  params: string,
): LevelObjInstance {
  const o = new LevelObjInstance();
  o.typeName = typeName;
  o.x = x;
  o.y = y;
  o.rot = rot;
  o.scale = scale;
  o.instanceName = instanceName;
  o.objParameters.createAllFromString(params);
  return o;
}

// Mirrors the obj-reading block in Levels.LoadLevel (Levels.as:171-180): @type is taken directly
// (E4X→String), @x/@y/@rot via Number(), @scale via GetAttrNumber(default 1), @params via GetAttrString.
function instanceFromPlacement(o: ObjPlacement, constants: Constants): LevelObjInstance {
  const inst = createLevelObjInstanceAt(
    o.type,
    asNumber(o.x),
    asNumber(o.y),
    asNumber(o.rot),
    getAttrNumber(o.scale, 1, constants),
    "",
    getAttrString(o.params, ""),
  );
  inst.id = getAttrString(o.id, "");
  return inst;
}

// Mirrors the joint block in Levels.LoadLevel (Levels.as:204-241). setType() seeds the default param
// list, then valuesFromString() overrides from the level XML's @params.
function jointFromDef(j: JointDef, constants: Constants): PhysObjJoint {
  const jt = new PhysObjJoint();
  jt.name = getAttrString(j.id, "");
  const type = getAttrString(j.type, "");
  if (type === "rev") {
    jt.setType(PhysObjJoint.Type_Rev);
    jt.obj0Name = getAttrString(j.objid0, "");
    jt.obj1Name = getAttrString(j.objid1, "");
    jt.rev_pos.x = getAttrNumber(j.x, 0, constants);
    jt.rev_pos.y = getAttrNumber(j.y, 0, constants);
  }
  if (type === "dist") {
    jt.setType(PhysObjJoint.Type_Distance);
    jt.obj0Name = getAttrString(j.objid0, "");
    jt.obj1Name = getAttrString(j.objid1, "");
    jt.dist_pos0.x = getAttrNumber(j.x0, 0, constants);
    jt.dist_pos0.y = getAttrNumber(j.y0, 0, constants);
    jt.dist_pos1.x = getAttrNumber(j.x1, 0, constants);
    jt.dist_pos1.y = getAttrNumber(j.y1, 0, constants);
  }
  if (type === "prism") {
    jt.setType(PhysObjJoint.Type_Prismatic);
    jt.obj0Name = getAttrString(j.objid0, "");
    jt.obj1Name = getAttrString(j.objid1, "");
    jt.prism_pos.x = getAttrNumber(j.x0, 0, constants);
    jt.prism_pos.y = getAttrNumber(j.y0, 0, constants);
    jt.prism_pos1.x = getAttrNumber(j.x1, 0, constants);
    jt.prism_pos1.y = getAttrNumber(j.y1, 0, constants);
  }
  jt.objParameters.valuesFromString(getAttrString(j.params, ""));
  return jt;
}

/**
 * Builds a runtime Level from one transcribed level record (data/levels.json) + the constants table
 * (data/constants.json). Combines Levels.PreLoadLevel (Levels.as:60) and Levels.LoadLevel (Levels.as:102).
 *
 * ORDER IS LOAD-BEARING: instances are appended objgroup-by-objgroup (in order) then the level's
 * top-level objs — this is the body-creation order the physics engine's island/contact solving depends
 * on. Do not reorder.
 */
export function buildLevel(d: LevelData, constants: Constants = {}): Level {
  const lv = new Level();

  // --- PreLoadLevel ---
  lv.fullyLoaded = false;
  lv.available = false;
  lv.complete = false;
  lv.id = getAttrString(d.id, "1");
  lv.name = getAttrString(d.name, "undefined");
  lv.category = getAttrInt(d.category, 0);
  lv.bgFrame = getAttrInt(d.bg, 1);
  lv.creator = getAttrString(d.creator, "");
  lv.gold_score = getAttrInt(d.zombooka?.gold_score, 10000); // LoadGameSpecificLevelData (Levels.as:90)
  for (const hs of d.helpscreens) lv.helpscreenFrames.push(getAttrInt(hs, 0));

  // --- LoadLevel ---
  lv.calculate();
  lv.fullyLoaded = true;

  // lines
  for (const lnD of d.lines) {
    const ln = new PhysLine();
    ln.id = getAttrString(lnD.id, "");
    ln.type = getAttrInt(lnD.type, 0);
    for (const a of lnD.points) for (const p of pointArrayFromString(a)) ln.points.push(p);
    ln.objParameters.valuesFromString(getAttrString(lnD.params, ""));
    lv.lines.push(ln);
  }

  // instances: objgroups (in order) THEN top-level objs — load-bearing order
  for (const g of d.objgroups) for (const o of g.objs) lv.instances.push(instanceFromPlacement(o, constants));
  for (const o of d.objs) lv.instances.push(instanceFromPlacement(o, constants));

  // joints
  for (const jD of d.joints) lv.joints.push(jointFromDef(jD, constants));

  // map (note: loader defaults cellw/cellh to 32 here, matching Levels.as:251-252)
  if (d.map) {
    lv.mapMinX = getAttrInt(d.map.minx, 0);
    lv.mapMaxX = getAttrInt(d.map.maxx, 0);
    lv.mapMinY = getAttrInt(d.map.miny, 0);
    lv.mapMaxY = getAttrInt(d.map.maxy, 0);
    lv.mapCellW = getAttrInt(d.map.cellw, 32);
    lv.mapCellH = getAttrInt(d.map.cellh, 32);
    for (const a of d.map.mapdata) for (const c of hexArrayFromString(a)) lv.map.push(c);
  }

  return lv;
}
