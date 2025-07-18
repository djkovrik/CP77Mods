module LimitedHudRicochet

import LimitedHudConfig.LHUDAddonsColoringConfig
import LimitedHudCommon.LHUDRicochetColors

@if(!ModuleExists("KeepDrawingTheLine"))
@replaceMethod(gameEffectExecutor_Ricochet)
public final func OnSnap(ctx: EffectScriptContext, entity: ref<Entity>) -> Void {
  let data: OutlineData;
  let evt: ref<OutlineRequestEvent> = new OutlineRequestEvent();
  let outlineType: EOutlineType = this.GetOutlineColor();
  data.outlineType = outlineType;
  data.outlineOpacity = 1.0;
  let id: CName = n"gameEffectExecutor_Ricochet";
  evt.outlineRequest = OutlineRequest.CreateRequest(id, data);
  evt.outlineDuration = 0.0;
  entity.QueueEvent(evt);
}

@addMethod(gameEffectExecutor_Ricochet)
private final func GetOutlineColor() -> EOutlineType {
  let config: ref<LHUDAddonsColoringConfig> = new LHUDAddonsColoringConfig();
  let configInt: Int32 = EnumInt(config.RicochetColor);

  switch configInt {
    case 1: return EOutlineType.GREEN;
    case 2: return EOutlineType.RED;
    case 3: return EOutlineType.YELLOW;
  };

  return EOutlineType.NONE;
}
