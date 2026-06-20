# Flaming Zombooka 3 — SWF analysis

## File
- **Original:** `flaming-zombooka-3-12590fdd9.swf` (moved from `~/Downloads`)
- **In repo:** `flaming-zombooka-3.swf` (5.6 MB, zlib-compressed `CWS`)
- **Decompressed:** `flaming-zombooka-3.uncompressed.swf` (6.7 MB, `FWS`)
- **Raw AS3 bytecode:** `abc_bytecode.bin` (644 KB)
- **Full export:** `extracted/` (26 MB — see below)

## SWF header
| Property | Value |
|---|---|
| Signature | `CWS` (zlib-compressed) |
| Flash version | 11 (Flash Player 11) |
| Stage | 700 × 500 px |
| Frame rate | 30 fps |
| ActionScript | **AS3** (2 × `DoABC` tags) |
| Built with | Adobe Flex 4 SDK (Metadata tag), compiled **21 Nov 2011** |
| Developer | **Long Animals Games** (longanimals.com / longanimalsgames.com) |
| Document class | `Preloader` |

## Physics engine
**Box2DFlash 2.0.2** — the ActionScript 3 port of Erin Catto's Box2D.

Evidence:
- Packages `Box2D.Dynamics`, `Box2D.Collision`, `Box2D.Common.Math`, classes `b2World`, `b2Body`, `b2Vec2`, `b2PolygonShape`, etc. (74 Box2D `.as` files extracted).
- Version pinned to the **2.0.x** line: contains `b2XForm` + `b2OBB` + `ClipVertex` and a required world `b2AABB`; lacks `b2Transform`. `b2Settings` has `b2_maxProxies=1024`, `b2_toiSlop`, `b2_maxTOIContactsPerIsland` — all unique to 2.0.2's brute-force broadphase (removed in 2.1a).

### World setup (`extracted/scripts/PhysicsBase.as`)
```
world AABB        : (-2500,-2500) → (2500,2500)
gravity           : 300 px/s² (GameVars.gravity) → 6.0 in world units
pixels-per-meter  : p2w = 50  (50 px = 1 Box2D metre)
fixed timestep    : 1/60 s
solver iterations : 5
allowSleep        : true
```
Joints used: revolute, prismatic, pulley, distance, mouse. Custom `ContactListener`.

### Physics materials (`extracted/binaryData/746_..._Data.xml`)
Named density/friction/restitution presets, e.g.
`average` (d0.3 f1 r0.1), `bouncy` (d0.5 f0.5 r0.95), `smooth` (f0 r0),
`dense`, `sticky`, `wood`, `solidmetal`, `bowling_ball`, `missile`, `nuke`, …

## Content
- **41 campaign levels** + 3 bonus modes (XML in `extracted/binaryData/*.xml`:
  Levels = campaign, Levels1 "Dancing", Levels3 "Hooks Law" basketball, etc.).
  Level objects are data-driven: `zombie1`, `flame1`, `explosiveBarrel`,
  `zombooka_player_missile`, posts/pins, `rev`/`dist` joints, decals, scenery.
- **711** decompiled AS3 scripts, **1119** shapes, **44** images, **63** sounds (3.6 MB),
  19 fonts, 93 text fields.

## Third-party libraries / SDKs detected
- **Box2DFlash 2.0.2** (physics)
- as3corelib (`com.adobe.*`)
- MochiMedia (`mochi.as3` — ads/leaderboards)
- Kongregate API, Newgrounds API (`ngAPI`)
- Adobe Flash UI components (`fl.controls.*`), Flex `mx.core`
- Heavy sponsor/site-lock list embedded (ArmorGames, AddictingGames, NotDoppler,
  Kongregate, MouseBreaker, SpielAffe, Agame, …) — typical of a sponsored portal game.

## How it was extracted
1. Decompress `CWS` zlib body → raw `FWS` SWF (Python `zlib`).
2. Parse tags / ABC constant pool for engine fingerprinting (Python).
3. Full asset + ActionScript export with **JPEXS FFDec 26.2.1** (`tools/ffdec/`).
