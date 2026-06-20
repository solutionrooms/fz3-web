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
