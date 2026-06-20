import { ObjParameters } from "../util/obj-parameters";

/** Port of LevelObj_Instance.as — one placed object in a level (typeName + transform + params). */
export class LevelObjInstance {
  id = "";
  instanceName = "";
  initFunctionParams = "";
  typeName = "";
  x = 0;
  y = 0;
  rot = 0; // AS3 Number; the loader always assigns it (Levels.as:176)
  scale = 1;
  objParameters = new ObjParameters();
  sortZ = 0; // set by game code later, not the loader
  frame = 0; // set by game code later, not the loader

  clone(): LevelObjInstance {
    const o = new LevelObjInstance();
    o.instanceName = this.instanceName;
    o.typeName = this.typeName;
    o.x = this.x;
    o.y = this.y;
    o.rot = this.rot;
    o.scale = this.scale;
    o.id = this.id;
    o.objParameters = this.objParameters.clone();
    return o;
  }
}
