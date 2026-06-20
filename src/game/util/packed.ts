// Ports of the packed-string decoders in Utils.as.

export interface Pt {
  x: number;
  y: number;
}

/**
 * Utils.PointArrayFromString (Utils.as:76). Splits on ",", rejects if there are fewer than 2 entries
 * or an odd count, then consumes the entries as (x, y) pairs via `Number()`. Whitespace after commas
 * (e.g. "-26,293, 49,299") is fine — `Number(" 49")` trims, matching AS3.
 */
export function pointArrayFromString(s: string): Pt[] {
  const out: Pt[] = [];
  const parts = s.split(",");
  if (parts.length < 2 || parts.length % 2 === 1) return out;
  const n = parts.length / 2;
  for (let i = 0; i < n; i++) {
    out.push({ x: Number(parts[i * 2 + 0]), y: Number(parts[i * 2 + 1]) });
  }
  return out;
}

/**
 * PhysObj.PointFromString (PhysObj.as:469). Splits on ",", requires EXACTLY 2 entries (else (0,0)).
 * Used for body/shape/joint positions and the `col`="category,mask" attribute.
 */
export function pointFromString(s: string): Pt {
  const parts = s.split(",");
  if (parts.length !== 2) return { x: 0, y: 0 };
  return { x: Number(parts[0]), y: Number(parts[1]) };
}

/**
 * Utils.HexArrayFromString (Utils.as:99). Despite the name, the AS3 applies `int()` to each single
 * CHARACTER: a digit 0-9 yields that digit; any other char yields 0 (`int("a")` === 0). So this is a
 * per-character decimal-digit decode of the spatial map grid.
 */
export function hexArrayFromString(s: string): number[] {
  const out: number[] = [];
  for (let i = 0; i < s.length; i++) out.push(Number(s.charAt(i)) | 0);
  return out;
}
