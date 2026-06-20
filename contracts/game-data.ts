/**
 * FZ3 game-data contract — types for the JSON in data/ (produced by tools/extract_data.py).
 * Owner: game developer. Consumed by the TS level/library loader (and indirectly by engine + render).
 *
 * RAW-STRING DISCIPLINE (important — Prime Directive applies to physics inputs)
 *   Every value below is the VERBATIM attribute string from the SWF XML. The extractor does NOT convert
 *   numbers. The loader must apply the EXACT conversions the AS3 used, so loaded values are bit-identical
 *   to the original game. Decoders to port (cite the .as line range above each, as usual):
 *     - XmlHelper.GetAttrString / GetAttrInt / GetAttrNumber      (attribute defaults)
 *     - Number(@x|@y|@rot)                                        (Levels.as:174-176 — obj placement)
 *     - Utils.PointArrayFromString(line.points[].a)               (Levels.as:152 — line vertices)
 *     - Utils.HexArrayFromString(map.mapdata[].a)                 (Levels.as:258 — spatial grid)
 *     - ObjParameters.CreateAllFromString / ValuesFromString(params)  (Levels.as:179,239,394)
 *   Joint type strings map to PhysObj_Joint types (Levels.as:210-237): 'rev'|'dist'|'prism'.
 *   Material → Box2D fixture: density/friction/restitution (Number); shape.col → collision filter;
 *   body.sensor → isSensor; body.fixed → static body. (See PhysObj.as / PhysicsBase.AddPhysObjAt.)
 */

// ---------- data/constants.json ----------
export type Constants = Record<string, string>;

// ---------- data/anim.json (clip → timeline frame count + frame labels) ----------
export interface AnimLabel { name: string; frame: number } // frame is 0-based
export interface AnimClip { frames: number; labels: AnimLabel[] }
export type Anim = Record<string, AnimClip>; // keyed by SWF linkage/clip name

// ---------- data/materials.json ----------
export interface Material { density: string; friction: string; restitution: string }
export type Materials = Record<string, Material>;

// ---------- data/objparams.json ----------
export interface ObjParam { name: string; type: string; default: string; values?: string }

// ---------- data/physobjs.json (the object/body/shape library) ----------
export interface GraphicDef { clip: string; frame?: string; pos?: string; rot?: string; zoffset?: string }
export interface ShapeDef {
  type: string;            // shape kind (polygon/circle/etc.)
  pos?: string;
  name?: string;
  col?: string;            // collision filter category/group
  radius?: string;         // circle radius
  material?: string;       // → Materials key
  vertices?: string;       // packed polygon verts (port a decoder when wiring fixtures)
}
export interface BodyDef {
  name?: string;
  pos?: string;
  fixed?: string;          // 'true' → static body
  sensor?: string;         // 'true' → sensor fixtures
  graphic: GraphicDef[];
  shapes: ShapeDef[];
}
export interface PhysObjDef {
  name: string;
  inlibrary?: string;
  libclass?: string;
  hasphysics?: string;     // 'true' → has bodies/shapes
  initfunction?: string;   // AS3 init function name → registry key in the TS behavior port
  editorrender?: string;
  graphics: GraphicDef[];
  parameters: { name: string; default: string }[];
  zombooka: { greatkill?: string; hitdamage?: string; superhitdamage?: string }[];
  bodies: BodyDef[];
}

// ---------- data/levels.json (runtime order: final×41, rob, julian, cathy) ----------
export interface ObjPlacement {
  id: string;
  type: string;            // → PhysObjDef.name / behavior type
  x: string; y: string; rot: string;   // Number() at load — physics initial conditions
  scale: string;
  params: string;          // ObjParameters.CreateAllFromString
}
export interface LineDef {
  id: string;
  type: string;
  params?: string;
  points: string[];        // each: Utils.PointArrayFromString
}
export interface JointDef {
  type: string;            // 'rev' | 'dist' | 'prism'
  id: string;
  objid0?: string; objid1?: string;
  x?: string; y?: string;             // rev anchor
  x0?: string; y0?: string; x1?: string; y1?: string;   // dist/prism anchors
  params?: string;
}
export interface MapDef {
  minx: string; maxx: string; miny: string; maxy: string;
  cellw: string; cellh: string;
  mapdata: string[];       // each: Utils.HexArrayFromString
}
export interface Level {
  id: string;
  name: string;
  category: string;
  desc?: string;
  bg: string;              // background frame
  creator: string;        // 'final' | 'rob' | 'julian' | 'cathy'
  source: string;         // same as creator (origin file)
  zombooka: { gold_score: string } | null;
  basketballs: { time_gold: string; time_silver: string } | null;
  objgroups: { name: string; objs: ObjPlacement[] }[];
  objs: ObjPlacement[];    // top-level objs (Levels.as also reads level.obj[])
  lines: LineDef[];
  joints: JointDef[];
  map: MapDef | null;
  helpscreens: string[];
}
export type Levels = Level[];
