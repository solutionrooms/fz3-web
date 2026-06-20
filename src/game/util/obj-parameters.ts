// Ports of Utils.GetParams + accessors (Utils.as:493+) and EditorPackage/ObjParameters.as.
//
// A params string is "name=value,name=value,...". FAITHFUL QUIRK: the AS3 parser is NAIVE — it splits
// the WHOLE string on "," then each segment on "=", keeping only [0]=name and [1]=value. A value that
// itself contains "," (it is split into garbage segments) or "=" (everything after the 2nd "=" is
// dropped) is therefore mangled. The shipped level data was authored around this; reproduce it exactly
// and never "fix" it.

export interface ParsedParams {
  names: string[];
  values: (string | undefined)[];
}

/** Utils.GetParams. */
export function getParams(s: string | null | undefined): ParsedParams {
  const names: string[] = [];
  const values: (string | undefined)[] = [];
  if (s == null || s === "") return { names, values };
  for (const seg of s.split(",")) {
    const kv = seg.split("=");
    names.push(kv[0]);
    values.push(kv[1]); // undefined for a segment with no "="
  }
  return { names, values };
}

/** Utils.GetParamExists. */
export function paramExists(p: ParsedParams, name: string): boolean {
  return p.names.indexOf(name) !== -1;
}

/** Utils.GetParamString. (Real data never stores `undefined`; coerced to "" for type-safety.) */
export function getParamString(p: ParsedParams, name: string, def = ""): string {
  const i = p.names.indexOf(name);
  return i !== -1 ? (p.values[i] ?? "") : def;
}

export interface ObjParameter {
  name: string;
  value: string;
}

/** Port of EditorPackage/ObjParameters.as. */
export class ObjParameters {
  list: ObjParameter[] = [];

  clone(): ObjParameters {
    const o = new ObjParameters();
    o.list = this.list.map((p) => ({ name: p.name, value: p.value }));
    return o;
  }

  clearAll(): void {
    this.list = [];
  }

  add(name: string, value: string): void {
    this.list.push({ name, value });
  }

  /** ObjParameters.CreateAllFromString — replace the list with every parsed pair (obj instances). */
  createAllFromString(s: string | null | undefined): void {
    const p = getParams(s);
    this.clearAll();
    for (let i = 0; i < p.names.length; i++) {
      this.add(p.names[i], p.values[i] ?? "");
    }
  }

  /** ObjParameters.ValuesFromString — override existing entries whose name appears in `s` (lines/joints). */
  valuesFromString(s: string | null | undefined): void {
    const p = getParams(s);
    for (const item of this.list) {
      if (paramExists(p, item.name)) {
        item.value = getParamString(p, item.name, item.value);
      }
    }
  }

  private getParam(name: string): string {
    for (const it of this.list) if (it.name === name) return it.value;
    return "";
  }

  // Accessors mirror ObjParameters.as: a missing name yields "" (Number("")===0, ""!=="true"===false).
  // GetValueString/GetValueInt ignore their default in the AS3, so the ports do too.
  getValueBoolean(name: string): boolean {
    return this.getParam(name) === "true";
  }
  getValueString(name: string, _def = ""): string {
    return this.getParam(name);
  }
  getValueNumber(name: string): number {
    return Number(this.getParam(name));
  }
  getValueInt(name: string, _def = 0): number {
    return Number(this.getParam(name)) | 0;
  }
}
