import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(interactionItemLogicController)
private final func SetLabel(data: script_ref<InteractionChoiceData>) -> Void {
  wrappedMethod(data);
  let dataLocalizedName: String = Deref(data).localizedName;
  // LogChannel(n"DEBUG", s"LocKey = \(Deref(data).localizedName) = \(GetLocalizedText(dataLocalizedName))");

  // Get in / Get on
  if Equals(dataLocalizedName, "LocKey#23295") || Equals(dataLocalizedName, "LocKey#23296") {
    this.GetRootCompoundWidget().SetVisible(!LHUDAddonsConfig.HidePromptGetIn());
  };

  // Pick Up Body
  if Equals(dataLocalizedName, "LocKey#238") {
    this.GetRootCompoundWidget().SetVisible(!LHUDAddonsConfig.HidePromptPickUpBody());
  };

  // Talk
  if Equals(dataLocalizedName, "LocKey#312") {
    this.GetRootCompoundWidget().SetVisible(!LHUDAddonsConfig.HidePromptTalk());
  };
}