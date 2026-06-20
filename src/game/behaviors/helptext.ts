import type { GameObj } from "../game-objects";
import { getParams, getParamString, getParamNumber } from "../util/obj-parameters";
import { Defs } from "../defs";

// GameObj_InitHelpText (GameObj.as:317): a timed help-text banner. At runtime the object's editor
// graphic (Text_Marker) is replaced by the "helpText" clip and hidden until the initial delay elapses.
// The initial-delay → visible state machine is faithful; sound (sfx_text_appear) and the frame
// animation (PlayAnimation) are stubbed pending the sound + animation ports. Switch-driven help text
// (switch_name) waits on a switch — switches are a later port.
export function initHelpText(go: GameObj): void {
  go.name = "text";
  const p = getParams(go.initParams);
  go.switchName = getParamString(p, "switch_name", "");
  go.textMessage = getParamString(p, "helptext_text", "helptxt");
  go.timer = getParamNumber(p, "helptext_initialdelay", 0) * Defs.fps;
  go.updateFn = () => updateHelpText(go);
  go.dobjClip = "helpText"; // GraphicObjects.GetDisplayObjByName("helpText") — overrides the editor graphic
  go.zpos = -10000;
  go.frame = 0;
  go.state = 0;
  if (go.switchName !== "") {
    go.timer = 99999999999;
    go.state = 0;
    // switchFunction = OnSwitch_HelpText — switches: later port
  }
  go.visible = false;
}

function updateHelpText(go: GameObj): void {
  if (go.state === 0) {
    go.visible = false;
    go.timer--;
    if (go.timer <= 0) {
      go.state = 1;
      go.visible = true;
    }
  } else if (go.state === 1) {
    // SoundPlayer.Play("sfx_text_appear"); PlayAnimation();  — TODO (sound + frame animation)
    go.visible = true;
    go.state = 2;
  } else if (go.state === 2) {
    // PlayAnimation();  — TODO
  }
}
