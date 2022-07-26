import LimitedHudConfig.LHUDAddonsConfig

@addField(interactionItemLogicController)
private let lhudAddonsConfig: ref<LHUDAddonsConfig>;

@wrapMethod(interactionItemLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudAddonsConfig = new LHUDAddonsConfig();
}

@wrapMethod(interactionItemLogicController)
private final func SetLabel(data: script_ref<InteractionChoiceData>) -> Void {
  wrappedMethod(data);
  let dataLocalizedName: String = Deref(data).localizedName;
  // LogChannel(n"DEBUG", s"LocKey = \(Deref(data).localizedName) = \(GetLocalizedText(dataLocalizedName))");

  // Get in / Get on
  if Equals(dataLocalizedName, "LocKey#23295") || Equals(dataLocalizedName, "LocKey#23296") {
    this.GetRootCompoundWidget().SetVisible(!this.lhudAddonsConfig.HidePromptGetIn);
  };

  // Pick Up Body
  if Equals(dataLocalizedName, "LocKey#238") {
    this.GetRootCompoundWidget().SetVisible(!this.lhudAddonsConfig.HidePromptPickUpBody);
  };

  // Talk
  if Equals(dataLocalizedName, "LocKey#312") {
    this.GetRootCompoundWidget().SetVisible(!this.lhudAddonsConfig.HidePromptTalk);
  };
}
