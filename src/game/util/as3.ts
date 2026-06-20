// Faithful ports of the AS3 primitive coercions used throughout the data path.
// These convert physics initial conditions (object x/y/rot, material params), so they must match
// AS3 exactly — see CLAUDE.md "THE PRIME DIRECTIVE".

/**
 * AS3 `Number(x)`. For our string | null | undefined inputs this is bit-identical to JS `Number()`:
 * both yield IEEE-754 doubles and share the same whitespace-trim, empty-string→0, hex (`0x..`),
 * `null`→0 and `undefined`→NaN rules.  (AS3: `Number(_loc15_.@x)` — Levels.as:174-176.)
 */
export function asNumber(x: string | null | undefined): number {
  return Number(x);
}

/**
 * AS3 `int(x)` = ToInt32(ToNumber(x)): NaN/±Infinity → 0, truncate toward zero, wrap mod 2^32.
 * JS `Number(x) | 0` performs exactly ToInt32, so this is bit-identical to AS3 `int()`.
 */
export function asInt(x: string | null | undefined): number {
  return Number(x) | 0;
}

/** AS3's data helpers treat ONLY the exact string "true" as boolean true (case-sensitive). */
export function isAs3True(x: unknown): boolean {
  return x === "true";
}
