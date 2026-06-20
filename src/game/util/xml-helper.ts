// Port of XmlHelper.as — attribute accessors with defaults.
//
// In our JSON transcription a MISSING attribute reads as `undefined`; an EMPTY attribute is "".
// AS3 guards with `param1 != undefined`; since AS3 `null == undefined`, that means "neither null nor
// undefined", which JS `!= null` reproduces exactly.

/** XmlHelper.GetAttrString. */
export function getAttrString(v: string | null | undefined, def = ""): string {
  return v != null ? String(v) : def;
}

/**
 * XmlHelper.GetAttrNumber. Supports a `%constantName` indirection: a value beginning with "%" is
 * looked up in ExternalData.constants (pass the constants map). Otherwise plain `Number()`.
 */
export function getAttrNumber(
  v: string | null | undefined,
  def = 0,
  constants?: Record<string, string>,
): number {
  if (v == null) return def;
  const s = String(v);
  if (s.charAt(0) === "%") {
    const name = s.replace("%", "");
    return Number(constants ? constants[name] : undefined);
  }
  return Number(v);
}

/** XmlHelper.GetAttrInt (AS3 `int()`). */
export function getAttrInt(v: string | null | undefined, def = 0): number {
  return v != null ? Number(v) | 0 : def;
}

/**
 * XmlHelper.GetAttrBoolean. FAITHFUL QUIRK: only the exact string "true" → true. The source computes
 * `String(param1).toLowerCase()` but then tests the ORIGINAL `param1 == "true"`, so the lowercasing is
 * dead code and "True"/"TRUE" → false. Reproduce exactly; do not "fix".
 */
export function getAttrBoolean(v: string | null | undefined, def = false): boolean {
  if (v != null) return v === "true";
  return def;
}
