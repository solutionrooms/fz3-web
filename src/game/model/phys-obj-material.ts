import { getAttrString, getAttrNumber } from "../util/xml-helper";
import type { Material } from "../../../contracts/game-data";

/** Port of PhysObj_Material.as. density/friction/restitution default to 1 (GetAttrNumber default). */
export class PhysObjMaterial {
  name = "";
  density = 1;
  friction = 1;
  restitution = 1;

  clone(): PhysObjMaterial {
    const m = new PhysObjMaterial();
    m.name = this.name;
    m.density = this.density;
    m.friction = this.friction;
    m.restitution = this.restitution;
    return m;
  }

  /** PhysObj_Material.FromXML — name from @name, the three values via GetAttrNumber(default 1). */
  fromData(name: string, m: Material): void {
    this.name = getAttrString(name, "");
    this.density = getAttrNumber(m.density, 1);
    this.friction = getAttrNumber(m.friction, 1);
    this.restitution = getAttrNumber(m.restitution, 1);
  }
}
