import { describe, it, expect } from "vitest";
import { asNumber, asInt, isAs3True } from "../../src/game/util/as3";
import {
  getAttrString,
  getAttrNumber,
  getAttrInt,
  getAttrBoolean,
} from "../../src/game/util/xml-helper";
import { pointArrayFromString, hexArrayFromString } from "../../src/game/util/packed";
import { ObjParameters, getParams } from "../../src/game/util/obj-parameters";

describe("as3 coercions", () => {
  it("asNumber matches AS3 Number()", () => {
    expect(asNumber("1.5")).toBe(1.5);
    expect(asNumber(" 49 ")).toBe(49); // Number() trims, like AS3
    expect(asNumber("")).toBe(0);
    expect(asNumber("-26")).toBe(-26);
    expect(Number.isNaN(asNumber("abc"))).toBe(true);
    expect(asNumber(undefined)).toBeNaN();
    expect(asNumber(null)).toBe(0);
  });
  it("asInt matches AS3 int() (ToInt32, truncate toward zero)", () => {
    expect(asInt("12.9")).toBe(12);
    expect(asInt("-3.7")).toBe(-3);
    expect(asInt("5")).toBe(5);
    expect(asInt("abc")).toBe(0);
    expect(asInt("")).toBe(0);
  });
  it("isAs3True only accepts exact 'true'", () => {
    expect(isAs3True("true")).toBe(true);
    expect(isAs3True("True")).toBe(false);
    expect(isAs3True("1")).toBe(false);
  });
});

describe("XmlHelper", () => {
  it("getAttrString: present→String, absent→default", () => {
    expect(getAttrString("hello")).toBe("hello");
    expect(getAttrString("")).toBe(""); // empty attr is present
    expect(getAttrString(undefined, "def")).toBe("def");
  });
  it("getAttrInt / getAttrNumber defaults", () => {
    expect(getAttrInt("7")).toBe(7);
    expect(getAttrInt(undefined, 3)).toBe(3);
    expect(getAttrNumber("300")).toBe(300);
    expect(getAttrNumber(undefined, 1)).toBe(1);
  });
  it("getAttrNumber resolves %constant indirection", () => {
    const constants = { grav: "300", scale: "0.5" };
    expect(getAttrNumber("%grav", 0, constants)).toBe(300);
    expect(getAttrNumber("%scale", 0, constants)).toBe(0.5);
    expect(getAttrNumber("123", 0, constants)).toBe(123);
  });
  it("getAttrBoolean: only exact 'true' (lowercasing is dead code)", () => {
    expect(getAttrBoolean("true")).toBe(true);
    expect(getAttrBoolean("True")).toBe(false);
    expect(getAttrBoolean("false")).toBe(false);
    expect(getAttrBoolean(undefined, true)).toBe(true);
  });
});

describe("packed decoders", () => {
  it("pointArrayFromString parses (x,y) pairs, with post-comma spaces", () => {
    expect(pointArrayFromString("-26,293, 49,299")).toEqual([
      { x: -26, y: 293 },
      { x: 49, y: 299 },
    ]);
  });
  it("pointArrayFromString rejects <2 or odd counts", () => {
    expect(pointArrayFromString("1")).toEqual([]);
    expect(pointArrayFromString("1,2,3")).toEqual([]);
  });
  it("hexArrayFromString: int() per character (non-digit → 0)", () => {
    expect(hexArrayFromString("012a3")).toEqual([0, 1, 2, 0, 3]);
    expect(hexArrayFromString("")).toEqual([]);
  });
});

describe("ObjParameters (and the faithful naive parser)", () => {
  it("createAllFromString on a real joint params string", () => {
    const s =
      "rev_enablelimit=false,rev_lowerangle=0,rev_upperangle=0,rev_enablemotor=true," +
      "rev_motorspeed=2,rev_maxmotortorque=2.5,joint_initfunction=InitGameObjJoint_Null";
    const p = new ObjParameters();
    p.createAllFromString(s);
    expect(p.getValueBoolean("rev_enablemotor")).toBe(true);
    expect(p.getValueBoolean("rev_enablelimit")).toBe(false);
    expect(p.getValueNumber("rev_motorspeed")).toBe(2);
    expect(p.getValueNumber("rev_maxmotortorque")).toBe(2.5);
    expect(p.getValueString("joint_initfunction")).toBe("InitGameObjJoint_Null");
    expect(p.getValueString("missing")).toBe(""); // absent → ""
  });
  it("a single param", () => {
    const p = new ObjParameters();
    p.createAllFromString("player_ammo=0");
    expect(p.getValueInt("player_ammo")).toBe(0);
  });
  it("FAITHFUL QUIRK: a value containing a comma is mangled (must reproduce)", () => {
    // 'helptext_text=Welcome, friends' → split(',') → ['helptext_text=Welcome',' friends']
    const parsed = getParams("helptext_text=Welcome, friends");
    expect(parsed.names).toEqual(["helptext_text", " friends"]);
    expect(parsed.values).toEqual(["Welcome", undefined]);
  });
  it("valuesFromString overrides only existing names", () => {
    const p = new ObjParameters();
    p.add("a", "1");
    p.add("b", "2");
    p.valuesFromString("b=20,c=30"); // 'c' is not in the list → ignored
    expect(p.getValueString("a")).toBe("1");
    expect(p.getValueString("b")).toBe("20");
    expect(p.getValueString("c")).toBe("");
  });
});
