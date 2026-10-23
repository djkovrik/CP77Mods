import LimitedHudConfig.LHUDAddonsConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent

@addField(interactionItemLogicController)
private let lhudAddonsConfig: ref<LHUDAddonsConfig>;

@wrapMethod(interactionItemLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudAddonsConfig = new LHUDAddonsConfig();
}

@addMethod(interactionItemLogicController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudAddonsConfig = new LHUDAddonsConfig();
}

@wrapMethod(interactionItemLogicController)
private final func SetLabel(data: script_ref<InteractionChoiceData>, isItemBroken: Bool) -> Void {
  wrappedMethod(data, isItemBroken);
  let dataLocalizedName: String = Deref(data).localizedName;

  // Get in / Get on
  if Equals(dataLocalizedName, "LocKey#23295") || Equals(dataLocalizedName, "LocKey#23296") {
    if this.lhudAddonsConfig.HidePromptGetIn {
      this.GetRootCompoundWidget().SetOpacity(0.0);
    } else {
      this.GetRootCompoundWidget().SetOpacity(1.0);
    };
  };

  // Pick Up Body
  if Equals(dataLocalizedName, "LocKey#238") {
    if this.lhudAddonsConfig.HidePromptPickUpBody {
      this.GetRootCompoundWidget().SetOpacity(0.0);
    } else {
      this.GetRootCompoundWidget().SetOpacity(1.0);
    };
  };

  // Talk
  if Equals(dataLocalizedName, "LocKey#312") {
    if this.lhudAddonsConfig.HidePromptTalk {
      this.GetRootCompoundWidget().SetOpacity(0.0);
    } else {
      this.GetRootCompoundWidget().SetOpacity(1.0);
    };
  };
}
