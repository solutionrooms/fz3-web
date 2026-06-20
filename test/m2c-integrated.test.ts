// m2c — integrated shaped-body-in-world bit-exact gate (the m2 capstone).
//
// Mirrors tools/oracle/harness-integrated.as: a single shaped dynamic body
// (centred box => trig-immune) in a real b2World, with an off-centre ApplyImpulse,
// stepped 200×. Exercises the FULL m2 stack composing end-to-end: CreateShape ->
// CreateProxy, SetMassFromShapes (ComputeMass aggregation -> mass/invMass/I/invI/
// localCenter), ApplyImpulse (uses invMass/invI/COM), and per-step Synchronize ->
// ComputeSweptAABB -> MoveProxy -> Commit inside Step. Asserts hex16 for the mass
// data and for (x,y,a,vx,vy,ω) every step. (No second shape => no contacts; that's m3.)
import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { b2World } from "../src/box2d/Dynamics/b2World";
import { b2AABB } from "../src/box2d/Collision/b2AABB";
import { b2Vec2 } from "../src/box2d/Common/Math/b2Vec2";
import { b2BodyDef } from "../src/box2d/Dynamics/b2BodyDef";
import { b2PolygonDef } from "../src/box2d/Collision/Shapes/b2PolygonDef";
import type { b2Body } from "../src/box2d/Dynamics/b2Body";
import { f64hex, norm, type Golden } from "./helpers/hex16";

const __dirname = dirname(fileURLToPath(import.meta.url));
const golden: Golden = JSON.parse(readFileSync(join(__dirname, "goldens", "m2c-integrated.json"), "utf8"));

function bodyFields(b: b2Body): string[] {
  return [
    f64hex(b.GetPosition().x),
    f64hex(b.GetPosition().y),
    f64hex(b.GetAngle()),
    f64hex(b.GetLinearVelocity().x),
    f64hex(b.GetLinearVelocity().y),
    f64hex(b.GetAngularVelocity()),
  ];
}

function assertRow(tag: string, step: number, got: string[]): void {
  const want = golden.golden[tag].find((x) => x.step === step);
  expect(want, `golden missing ${tag} ${step}`).toBeTruthy();
  for (let f = 0; f < got.length; f++) {
    expect(got[f], `${tag} ${step} field ${f}: ours=${got[f]} golden=${norm(want!.fields[f])}`).toBe(
      norm(want!.fields[f]),
    );
  }
}

describe("m2c — integrated shaped body (bit-exact)", () => {
  it("matches the Ruffle golden for mass data and every step", () => {
    const aabb = new b2AABB();
    aabb.lowerBound.Set(-2500, -2500);
    aabb.upperBound.Set(2500, 2500);
    const world = new b2World(aabb, new b2Vec2(0, 6), true);

    const bd = new b2BodyDef();
    bd.position.Set(10, -20);
    const body = world.CreateBody(bd)!;

    const sd = new b2PolygonDef();
    sd.density = 0.5;
    sd.friction = 0.3;
    sd.restitution = 0.1;
    sd.SetAsBox(0.8, 0.5);
    body.CreateShape(sd);
    body.SetMassFromShapes();

    assertRow("MASS", 0, [
      f64hex(body.GetMass()),
      f64hex(body.m_invMass),
      f64hex(body.GetInertia()),
      f64hex(body.m_invI),
      f64hex(body.GetLocalCenter().x),
      f64hex(body.GetLocalCenter().y),
    ]);

    const c = body.GetWorldCenter();
    body.ApplyImpulse(new b2Vec2(5, -3), new b2Vec2(c.x + 0.4, c.y + 0.2));

    assertRow("M2C", 0, bodyFields(body));
    for (let i = 1; i <= 200; i++) {
      world.Step(1 / 60, 5);
      assertRow("M2C", i, bodyFields(body));
    }
  });
});
