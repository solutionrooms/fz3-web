// m0 (freefall) + m1 (rotation) bit-exact gates.
//
// Reproduces the AS3 oracle harness scenes (tools/oracle/harness-freefall.as) in the
// ported TS engine and asserts hex16(ours) === golden every body, every field, every
// step against goldens captured from the SHIPPED 2011 Box2DFlash 2.0.2 under Ruffle.
//
// These are PURE bit-exact gates (no tolerance) — the body is centred and shapeless,
// so it is trig-immune (CLAUDE.md rule 5): the rotation matrix never rotates an offset
// back into the solve. Any single flipped bit means the integrator diverged.
import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { b2World } from "../src/box2d/Dynamics/b2World";
import { b2AABB } from "../src/box2d/Collision/b2AABB";
import { b2Vec2 } from "../src/box2d/Common/Math/b2Vec2";
import { b2BodyDef } from "../src/box2d/Dynamics/b2BodyDef";
import type { b2Body } from "../src/box2d/Dynamics/b2Body";
import { f64hex, norm, type Golden } from "./helpers/hex16";

const __dirname = dirname(fileURLToPath(import.meta.url));
const golden: Golden = JSON.parse(readFileSync(join(__dirname, "goldens", "m0-m1-freefall.json"), "utf8"));

// matches harness makeWorld(): AABB ±2500, gravity (0,6), allowSleep true.
function makeWorld(): b2World {
  const aabb = new b2AABB();
  aabb.lowerBound.Set(-2500, -2500);
  aabb.upperBound.Set(2500, 2500);
  const gravity = new b2Vec2(0, 6);
  return new b2World(aabb, gravity, true);
}

// matches harness makeDynamicBody(): mass set directly on the def (shapeless body).
function makeDynamicBody(world: b2World, x: number, y: number): b2Body {
  const bd = new b2BodyDef();
  bd.position.Set(x, y);
  bd.massData.mass = 1;
  bd.massData.I = 1;
  return world.CreateBody(bd)!;
}

function fieldsOf(b: b2Body): string[] {
  return [
    f64hex(b.GetPosition().x),
    f64hex(b.GetPosition().y),
    f64hex(b.GetAngle()),
    f64hex(b.GetLinearVelocity().x),
    f64hex(b.GetLinearVelocity().y),
    f64hex(b.GetAngularVelocity()),
  ];
}

const FIELD_NAMES = ["px", "py", "a", "vx", "vy", "w"];

function assertStep(tag: string, step: number, got: string[]): void {
  const want = golden.golden[tag][step];
  expect(want, `golden missing ${tag} step ${step}`).toBeTruthy();
  expect(want.step).toBe(step);
  for (let f = 0; f < FIELD_NAMES.length; f++) {
    expect(
      got[f],
      `${tag} step ${step} field ${FIELD_NAMES[f]}: ours=${got[f]} golden=${norm(want.fields[f])}`,
    ).toBe(norm(want.fields[f]));
  }
}

describe("m0 — freefall (bit-exact)", () => {
  it("matches the Ruffle golden every field every step", () => {
    const world = makeWorld();
    const body = makeDynamicBody(world, 10, -20);
    assertStep("M0", 0, fieldsOf(body));
    for (let i = 1; i <= 200; i++) {
      world.Step(1 / 60, 5);
      assertStep("M0", i, fieldsOf(body));
    }
  });
});

describe("m1 — freefall + linear velocity + spin (bit-exact)", () => {
  it("matches the Ruffle golden every field every step", () => {
    const world = makeWorld();
    const body = makeDynamicBody(world, 10, -20);
    body.SetLinearVelocity(new b2Vec2(3, -8));
    body.SetAngularVelocity(2.5);
    assertStep("M1", 0, fieldsOf(body));
    for (let i = 1; i <= 200; i++) {
      world.Step(1 / 60, 5);
      assertStep("M1", i, fieldsOf(body));
    }
  });
});
