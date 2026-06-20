import { ObjParameters } from "../util/obj-parameters";
import type { Pt } from "../util/packed";

/**
 * Port of PhysLine.as — FOCUSED to the loader + physics surface. The original also carries
 * editor/render machinery (Catmull-Rom spline lengths, bounding rect, fill rendering) that is computed
 * lazily and not needed to load or to build the physics line; port those when the render/physics line
 * paths need them.
 */
export class PhysLine {
  static readonly PRIMITIVE_LINE = "line";
  static readonly PRIMITIVE_RECTANGLE = "rectangle";
  static readonly PRIMITIVE_CIRCLE = "circle";

  index = 0;
  id = "";
  type = 0;
  points: Pt[] = [];
  fill = 0;
  fillScaleX = 1;
  fillScaleY = 1;
  centrex = 0;
  centrey = 0;
  fixed = true;
  primitiveType = PhysLine.PRIMITIVE_LINE;
  objParameters = new ObjParameters();

  constructor() {
    // PhysLine() default param seed — these are physics-relevant defaults (material/fixed/function).
    this.objParameters.add("line_physmaterial", "average");
    this.objParameters.add("line_fixed", "true");
    this.objParameters.add("line_function", "InitGameObjLine_Wood");
    this.objParameters.add("line_background_frame", "1");
    this.objParameters.add("editor_layer", "1");
  }

  addPoint(x: number, y: number): void {
    this.points.push({ x, y });
  }

  getPoint(i: number): Pt {
    return this.points[i];
  }
}
