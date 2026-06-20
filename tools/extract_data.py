#!/usr/bin/env python3
"""
FZ3 data extractor (build-time tool).

Faithfully TRANSCRIBES the SWF's binaryData XML into typed JSON modules the TS game loader consumes.
Design rule (Prime Directive applies to physics INPUTS too): we preserve raw attribute STRINGS verbatim
and do NOT convert numbers here. The TS loader applies the exact same conversions the AS3 used
(Number(), XmlHelper.GetAttr*, Utils.PointArrayFromString / HexArrayFromString, ObjParameters), so the
loaded values are bit-identical to the original game. This script must never lose or reinterpret data.

Sources (extracted/binaryData/):  Data = object/material library;  Levels(+1/2/3) = level data.
Runtime level order reproduces ExternalData.XmlAllLoadedInternal (onlyFinalLevels == false):
    final(41) + rob(Levels3) + julian(Levels1) + cathy(Levels2)
Outputs (data/):  constants.json, materials.json, objparams.json, physobjs.json, levels.json

Run:  python3 tools/extract_data.py
"""
import json, os
import xml.etree.ElementTree as ET
from collections import OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
BIN  = os.path.join(ROOT, "extracted", "binaryData")
OUT  = os.path.join(ROOT, "data")
os.makedirs(OUT, exist_ok=True)

DATA_XML = "746_ExternalData_class_Data.xml"
# (file, creator) in the exact order ExternalData builds levelsXml when onlyFinalLevels == false
LEVEL_SOURCES = [
    ("750_ExternalData_class_Levels.xml",  "final"),   # campaign, 41
    ("748_ExternalData_class_Levels3.xml", "rob"),     # appended 1st
    ("747_ExternalData_class_Levels1.xml", "julian"),  # appended 2nd
    ("749_ExternalData_class_Levels2.xml", "cathy"),   # appended 3rd (empty)
]

def parse(path):
    return ET.parse(os.path.join(BIN, path)).getroot()

def attrs(el):
    """Raw attribute dict, preserving source order & exact string values."""
    return OrderedDict((k, el.attrib[k]) for k in el.attrib)

def children_raw(el, tag):
    return [attrs(c) for c in el.findall(tag)]

def write(name, obj):
    p = os.path.join(OUT, name)
    with open(p, "w") as f:
        json.dump(obj, f, indent=2, ensure_ascii=False)
    print(f"  wrote {name:18s} ({os.path.getsize(p):>8d} bytes)")

# ---------- Data.xml: constants, materials, objparams, physobj library ----------
def extract_data():
    root = parse(DATA_XML)

    constants = OrderedDict()
    cs = root.find("constants")
    if cs is not None:
        for c in cs.findall("constant"):
            constants[c.attrib.get("name")] = c.attrib.get("value")  # raw string
    write("constants.json", constants)

    materials = OrderedDict()
    for m in root.findall("material"):
        a = attrs(m)
        materials[a["name"]] = OrderedDict(  # raw strings — physics-sensitive, loader does Number()
            density=a.get("density"), friction=a.get("friction"), restitution=a.get("restitution"))
    write("materials.json", materials)

    objparams = [attrs(op) for op in root.findall("objparam")]   # {name,type,default,values}
    write("objparams.json", objparams)

    physobjs = []
    for po in root.findall("physobj"):
        rec = attrs(po)  # name, inlibrary, libclass, hasphysics, initfunction, editorrender
        rec["graphics"]   = children_raw(po, "graphic")          # non-physics graphics on the physobj
        rec["parameters"] = children_raw(po, "parameter")        # {name, default}
        rec["zombooka"]   = children_raw(po, "zombooka")         # {greatkill, hitdamage, superhitdamage}
        bodies = []
        for b in po.findall("body"):
            brec = attrs(b)  # name, pos, fixed, sensor
            brec["graphic"] = children_raw(b, "graphic")
            brec["shapes"]  = children_raw(b, "shape")  # type,pos,name,col,radius,material,vertices (raw)
            bodies.append(brec)
        rec["bodies"] = bodies
        physobjs.append(rec)
    write("physobjs.json", physobjs)

# ---------- Levels: faithful transcription, runtime order ----------
def extract_level(el, source):
    lv = attrs(el)               # id, name, category, desc, bg, (creator added at runtime)
    lv["source"] = source
    z = el.find("zombooka")
    lv["zombooka"]    = attrs(z) if z is not None else None
    bb = el.find("basketballs")
    lv["basketballs"] = attrs(bb) if bb is not None else None

    groups = []
    for og in el.findall("objgroup"):
        groups.append(OrderedDict(name=og.attrib.get("name", ""),
                                  objs=children_raw(og, "obj")))   # id,type,x,y,rot,scale,params (raw)
    lv["objgroups"] = groups
    lv["objs"] = children_raw(el, "obj")        # top-level objs (Levels.as also reads level.obj[])

    lines = []
    for ln in el.findall("line"):
        lrec = attrs(ln)                         # type, id, params
        lrec["points"] = [p.attrib.get("a", "") for p in ln.findall("points")]  # raw packed strings
        lines.append(lrec)
    lv["lines"] = lines

    joints = []
    js = el.find("joints")
    if js is not None:
        joints = [attrs(j) for j in js.findall("joint")]  # type,id,objid0/1,x,y,x0,y0,x1,y1,params (raw)
    lv["joints"] = joints

    mp = el.find("map")
    if mp is not None:
        mrec = attrs(mp)                          # minx,maxx,miny,maxy,cellw,cellh
        mrec["mapdata"] = [md.attrib.get("a", "") for md in mp.findall("mapdata")]  # raw hex grid
        lv["map"] = mrec
    else:
        lv["map"] = None

    lv["helpscreens"] = [hs.attrib.get("frame", "0") for hs in el.findall("helpscreen")]
    return lv

def extract_levels():
    levels, counts = [], OrderedDict()
    for fname, creator in LEVEL_SOURCES:
        root = parse(fname)
        n = 0
        for el in root.findall("level"):
            rec = extract_level(el, creator)
            rec["creator"] = creator   # mirrors ExternalData setting level.@creator
            levels.append(rec)
            n += 1
        counts[creator] = n
    write("levels.json", levels)
    print(f"  level counts by source: {dict(counts)}  total={len(levels)}")

# ---------- anim: clip → {frames, labels} from the SWF DefineSprite/FrameLabel/SymbolClass tags ----------
def extract_anim():
    import struct
    swf = os.path.join(ROOT, "flaming-zombooka-3.uncompressed.swf")
    if not os.path.exists(swf):
        print("  (skip anim.json — uncompressed SWF not present; run the decompress step)")
        return
    data = open(swf, "rb").read()[8:]
    nbits = data[0] >> 3
    start = (5 + 4 * nbits + 7) // 8 + 4
    sprites = {}   # charID -> {frames, labels}
    symbols = {}   # charID -> className

    def walk(buf, p, end, sprite_cid=None):
        frame_idx = 0
        labels = []
        while p < end:
            th = struct.unpack("<H", buf[p:p + 2])[0]; code = th >> 6; length = th & 0x3f; p += 2
            if length == 0x3f:
                length = struct.unpack("<I", buf[p:p + 4])[0]; p += 4
            ps = p; payload = buf[p:p + length]
            if sprite_cid is not None:
                if code == 1:        # ShowFrame
                    frame_idx += 1
                elif code == 43:     # FrameLabel
                    i = 0
                    while payload[i] != 0: i += 1
                    labels.append({"name": payload[:i].decode("latin1"), "frame": frame_idx})
                elif code == 0:
                    return p + length, labels
            else:
                if code == 39:       # DefineSprite
                    cid, fcount = struct.unpack("<HH", payload[:4])
                    _, lbls = walk(buf, ps + 4, ps + length, sprite_cid=cid)
                    sprites[cid] = {"frames": fcount, "labels": lbls}
                elif code == 76:     # SymbolClass
                    cnt = struct.unpack("<H", payload[:2])[0]; i = 2
                    for _ in range(cnt):
                        tag = struct.unpack("<H", payload[i:i + 2])[0]; i += 2
                        j = i
                        while payload[j] != 0: j += 1
                        symbols[tag] = payload[i:j].decode("latin1"); i = j + 1
                elif code == 0:
                    return p + length, labels
            p += length
        return p, labels

    walk(data, start, len(data))
    clips = OrderedDict()
    for cid in sorted(sprites):
        name = symbols.get(cid)
        if name:
            clips[name] = sprites[cid]
    write("anim.json", clips)


if __name__ == "__main__":
    print("Extracting FZ3 data → data/*.json")
    extract_data()
    extract_levels()
    extract_anim()
    print("Done.")
