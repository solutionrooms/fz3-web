import { ObjParameters } from "../util/obj-parameters";

interface Pt {
  x: number;
  y: number;
}
const pt = (x = 0, y = 0): Pt => ({ x, y });

/**
 * Port of PhysObj_Joint.as. The loader sets type (via setType, which SEEDS the default param list),
 * the two object names, and the anchor positions; the actual joint values live in objParameters and are
 * overridden from the level XML via valuesFromString. The typed rev_ / prism_ fields stay at defaults —
 * the Box2D joint is built later by reading objParameters.
 */
export class PhysObjJoint {
  static readonly Type_Rev = 0;
  static readonly Type_Distance = 1;
  static readonly Type_Prismatic = 2;
  static readonly Type_Mouse = 3;
  static readonly Type_Pulley = 4;

  objParameters = new ObjParameters();
  type = 0;
  name = "";
  obj0Name = "";
  obj1Name = "";

  rev_pos = pt();
  rev_enableLimit = false;
  rev_lowerAngle = 0;
  rev_upperAngle = 0;
  rev_enableMotor = false;
  rev_motorSpeed = 0;
  rev_maxMotorTorque = 0;

  dist_pos0 = pt();
  dist_pos1 = pt();

  prism_pos = pt();
  prism_pos1 = pt();
  prism_lowerTranslation = 0;
  prism_upperTranslation = 0;
  prism_enableLimit = false;
  prism_enableMotor = false;
  prism_motorSpeed = 0;
  prism_maxMotorForce = 0;
  prism_axisangle = 0;

  /** PhysObj_Joint.SetType — sets the type and (re)seeds the default param list for that type. */
  setType(type: number): void {
    this.type = type;
    this.objParameters = new ObjParameters();
    if (type !== PhysObjJoint.Type_Distance) {
      if (type === PhysObjJoint.Type_Rev) {
        this.objParameters.add("rev_enablelimit", "false");
        this.objParameters.add("rev_lowerangle", "0");
        this.objParameters.add("rev_upperangle", "0");
        this.objParameters.add("rev_enablemotor", "false");
        this.objParameters.add("rev_motorspeed", "0");
        this.objParameters.add("rev_maxmotortorque", "0");
      } else if (type === PhysObjJoint.Type_Prismatic) {
        this.objParameters.add("prismatic_enablelimit", "false");
        this.objParameters.add("prismatic_lowertranslation", "0");
        this.objParameters.add("prismatic_uppertranslation", "0");
        this.objParameters.add("prismatic_enablemotor", "false");
        this.objParameters.add("prismatic_motorspeed", "0");
        this.objParameters.add("prismatic_maxmotorforce", "0");
      }
    }
    this.objParameters.add("joint_initfunction", "InitGameObjJoint_Null");
  }
}
