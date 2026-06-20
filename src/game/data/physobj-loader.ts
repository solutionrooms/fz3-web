import { PhysObjs } from "../model/phys-obj-def";
import { PhysObjMaterial } from "../model/phys-obj-material";
import type { PhysObjDef, Materials } from "../../../contracts/game-data";

/** Builds the object-definition library (Game.objectDefs) from data/physobjs.json. */
export function buildPhysObjs(defs: PhysObjDef[]): PhysObjs {
  const lib = new PhysObjs();
  lib.initFromData(defs);
  return lib;
}

/** Game material load (Game.as:623): each <material> → PhysObj_Material.FromXML. Order preserved. */
export function buildMaterials(materials: Materials): PhysObjMaterial[] {
  const out: PhysObjMaterial[] = [];
  for (const name of Object.keys(materials)) {
    const m = new PhysObjMaterial();
    m.fromData(name, materials[name]);
    out.push(m);
  }
  return out;
}

/** Game.GetPhysMaterialByName (Game.as:604) — linear search by name. */
export function getPhysMaterialByName(
  materials: PhysObjMaterial[],
  name: string,
): PhysObjMaterial | null {
  for (const m of materials) if (m.name === name) return m;
  return null;
}
