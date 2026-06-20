/**
 * Letterbox the fixed Flash stage into the browser window.
 *
 * FZ3 renders at a fixed 700×500 (the OpenFL canvas keeps that internal resolution — crisp,
 * deterministic). To present it responsively we scale the stage element uniformly to fit the
 * window, preserving the 7:5 aspect ratio and centring it; the page background shows through
 * as the letterbox/pillarbox bars. This is pure presentation — it never touches the canvas's
 * internal resolution or the camera math.
 */
export interface LetterboxHandle {
  /** Recompute the fit now (e.g. after a manual layout change). */
  refit(): void;
  /** Detach the resize listener. */
  dispose(): void;
}

export function letterbox(element: HTMLElement, width: number, height: number): LetterboxHandle {
  const refit = (): void => {
    const scale = Math.min(window.innerWidth / width, window.innerHeight / height);
    element.style.transform = `translate(-50%, -50%) scale(${scale})`;
  };
  refit();
  window.addEventListener("resize", refit);
  return {
    refit,
    dispose: () => window.removeEventListener("resize", refit),
  };
}
