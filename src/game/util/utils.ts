// Ports of small Utils.as helpers (+ the PhysObj boolean variant). Citations inline.

/**
 * Utils.DegToRad (Utils.as:398). PHYSICS-CRITICAL operation order — feeds joint angles, poly rotation,
 * and instance rotation. Written exactly as the source (`Math.PI * 2 / 360 * deg`, left-to-right);
 * do NOT simplify to `deg * Math.PI / 180` (could differ in the last bit).
 */
export function degToRad(deg: number): number {
  return (Math.PI * 2) / 360 * deg;
}

/**
 * PhysObj.BooleanFromString (PhysObj.as:505). DISTINCT from XmlHelper.GetAttrBoolean: case-INSENSITIVE
 * and also accepts "1". (Used for physobj body fixed/sensor and internal-joint flags.)
 */
export function booleanFromString(s: string | null | undefined): boolean {
  const u = (s ?? "").toUpperCase();
  return u === "1" || u === "TRUE";
}

/** Utils.GetLength (Utils.as) — NOTE: misnamed; returns length-SQUARED (x²+y²), not the magnitude. */
export function getLength(x: number, y: number): number {
  return x * x + y * y;
}

/** Utils.LimitNumber — clamp v to [min, max]. */
export function limitNumber(min: number, max: number, v: number): number {
  if (v < min) v = min;
  if (v > max) v = max;
  return v;
}

/** Utils.ScaleTo — linear map of v from [inMin, inMax] onto [outMin, outMax] (op order preserved). */
export function scaleTo(outMin: number, outMax: number, inMin: number, inMax: number, v: number): number {
  const d = inMax - inMin;
  const r = outMax - outMin;
  const t = (1 / d) * (v - inMin);
  return r * t + outMin;
}

/** Utils.RandBetweenInt — non-deterministic; used only for cosmetic camera shake. */
export function randBetweenInt(a: number, b: number): number {
  return (Math.random() * (b - a + 1) + a) | 0;
}

/** Utils.RandBetweenFloat — non-deterministic; cosmetic camera shake only. */
export function randBetweenFloat(a: number, b: number): number {
  return Math.random() * (b - a) + a;
}
