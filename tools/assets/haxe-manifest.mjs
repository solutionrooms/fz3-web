// Minimal Haxe-serialization (un)serializer for an OpenFL AssetLibrary `library.json`
// `assets` blob. The blob is a Haxe `Serializer` array of anonymous objects
// {id, size, type, path}. We only need the subset of tokens it actually uses:
//   a  array start         h  array end
//   o  object start        g  object end
//   y<len>:<urlenc>  string (len = url-ENCODED length; value is encodeURIComponent'd)
//   i<int>           int
//   R<idx>           back-reference into the string cache (0-based, insertion order)
//   n                null
// Strings (both object keys and string values) are cached on first write and may be
// referenced later by `R<idx>`. We resolve refs on read; on write we emit literals
// only (never refs) — the Haxe Unserializer rebuilds its own cache and is happy with
// that, so a fully literal stream is valid and far simpler to emit correctly.

export function unserializeAssets(blob) {
  let i = 0;
  const cache = []; // string cache (Haxe caches every serialized string)

  function readString() {
    // at a 'y<len>:<bytes>' — len is the encoded byte length
    if (blob[i] !== "y") throw new Error(`expected string token at ${i}, got '${blob[i]}'`);
    i++;
    let n = 0;
    while (blob[i] >= "0" && blob[i] <= "9") { n = n * 10 + (blob.charCodeAt(i) - 48); i++; }
    if (blob[i] !== ":") throw new Error(`expected ':' in string token at ${i}`);
    i++;
    const enc = blob.substr(i, n);
    i += n;
    const val = decodeURIComponent(enc);
    cache.push(val);
    return val;
  }
  function readRef() {
    i++; // 'R'
    let n = 0;
    while (blob[i] >= "0" && blob[i] <= "9") { n = n * 10 + (blob.charCodeAt(i) - 48); i++; }
    return cache[n];
  }
  function readValue() {
    const c = blob[i];
    if (c === "y") return readString();
    if (c === "R") return readRef();
    if (c === "n") { i++; return null; }
    if (c === "i") {
      i++;
      let neg = false;
      if (blob[i] === "-") { neg = true; i++; }
      let n = 0;
      while (blob[i] >= "0" && blob[i] <= "9") { n = n * 10 + (blob.charCodeAt(i) - 48); i++; }
      return neg ? -n : n;
    }
    throw new Error(`unsupported value token '${c}' at ${i}`);
  }

  if (blob[i] !== "a") throw new Error("assets blob is not a Haxe array");
  i++;
  const out = [];
  while (blob[i] !== "h") {
    if (blob[i] === "n") { i++; out.push(null); continue; } // null array slot
    if (blob[i] !== "o") throw new Error(`expected object at ${i}, got '${blob[i]}'`);
    i++;
    const obj = {};
    while (blob[i] !== "g") {
      const key = blob[i] === "R" ? readRef() : readString();
      obj[key] = readValue();
    }
    i++; // 'g'
    out.push(obj);
  }
  i++; // 'h'
  return out;
}

export function serializeAssets(arr) {
  let s = "a";
  const str = (v) => {
    const enc = encodeURIComponent(v);
    return "y" + enc.length + ":" + enc;
  };
  for (const obj of arr) {
    if (obj === null) { s += "n"; continue; }
    s += "o";
    for (const key of Object.keys(obj)) {
      s += str(key);
      const v = obj[key];
      if (v === null || v === undefined) s += "n";
      else if (typeof v === "number") s += "i" + v;
      else s += str(v);
    }
    s += "g";
  }
  s += "h";
  return s;
}
