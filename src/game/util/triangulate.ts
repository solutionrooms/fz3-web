// Faithful port of Triangulate.as — ear-clipping triangulation (Sweeney/Eberly).
//
// PHYSICS-CRITICAL and a known faithfulness landmine (SB2): every concave/poly fixture is fan-split
// into triangles by this; a different winding, vertex order, or a degenerate triangle changes the
// collision shapes (and a degenerate tri NaN'd a whole level on SB2). Operation order is preserved
// verbatim; +−×÷ only (no trig) so AS3 Number == JS number gives bit-identical output.

import type { Pt } from "./packed";

const EPSILON = 1e-10;

/** Triangulate.area — signed polygon area (shoelace). */
export function area(contour: Pt[]): number {
  const n = contour.length | 0;
  let a = 0;
  let p = n - 1;
  for (let q = 0; q < n; q++) {
    a += contour[p].x * contour[q].y - contour[q].x * contour[p].y;
    p = q;
  }
  return a * 0.5;
}

// Triangulate.insideTriangle — barycentric sign test (exact op order from source).
function insideTriangle(
  ax: number, ay: number, bx: number, by: number, cx: number, cy: number, px: number, py: number,
): boolean {
  const ax2 = cx - bx, ay2 = cy - by;
  const bx2 = ax - cx, by2 = ay - cy;
  const cx2 = bx - ax, cy2 = by - ay;
  const apx = px - ax, apy = py - ay;
  const bpx = px - bx, bpy = py - by;
  const cpx = px - cx, cpy = py - cy;
  const aCROSSbp = ax2 * bpy - ay2 * bpx;
  const cCROSSap = cx2 * apy - cy2 * apx;
  const bCROSScp = bx2 * cpy - by2 * cpx;
  return aCROSSbp >= 0 && bCROSScp >= 0 && cCROSSap >= 0;
}

// Triangulate.snip — is the (u,v,w) ear clippable (convex + contains no other vertex)?
function snip(contour: Pt[], u: number, v: number, w: number, n: number, V: number[]): boolean {
  const ax = Number(contour[V[u]].x), ay = Number(contour[V[u]].y);
  const bx = Number(contour[V[v]].x), by = Number(contour[V[v]].y);
  const cx = Number(contour[V[w]].x), cy = Number(contour[V[w]].y);
  if (EPSILON > (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)) return false;
  for (let p = 0; p < n; p++) {
    if (p === u || p === v || p === w) continue;
    const px = Number(contour[V[p]].x), py = Number(contour[V[p]].y);
    if (insideTriangle(ax, ay, bx, by, cx, cy, px, py)) return false;
  }
  return true;
}

/**
 * Triangulate.process — returns a flat list of points, 3 per triangle, or null on failure
 * (fewer than 3 verts, or a non-triangulable / degenerate polygon — the count guard). Callers must
 * handle null (the original logs and skips), never feed NaN downstream.
 */
export function triangulate(contour: Pt[]): Pt[] | null {
  const n = contour.length | 0;
  if (n < 3) return null;

  const V: number[] = [];
  if (0 < area(contour)) {
    for (let s = 0; s < n; s++) V[s] = s;
  } else {
    for (let s = 0; s < n; s++) V[s] = n - 1 - s;
  }

  const result: Pt[] = [];
  let nv = n;
  let count = (2 * nv) | 0;
  let v = nv - 1;
  while (nv > 2) {
    if (0 >= count--) return null; // bad/degenerate polygon
    let u = v;
    if (nv <= u) u = 0;
    v = u + 1;
    if (nv <= v) v = 0;
    let w = v + 1;
    if (nv <= w) w = 0;
    if (snip(contour, u, v, w, nv, V)) {
      const a = V[u] | 0, b = V[v] | 0, c = V[w] | 0;
      result.push(contour[a], contour[b], contour[c]);
      // erase vertex v from the working list
      let s = v;
      for (let t = v + 1; t < nv; t++) {
        V[s] = V[t];
        s++;
      }
      nv--;
      count = (2 * nv) | 0;
    }
  }
  return result;
}
