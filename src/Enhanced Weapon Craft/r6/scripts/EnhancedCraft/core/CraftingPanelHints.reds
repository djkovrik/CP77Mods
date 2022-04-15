module EnhancedCraft.UI
import EnhancedCraft.Config.*

@addMethod(CraftingLogicController)
public func ShowButtonHints() -> Void {
  if !Config.RandomizerEnabled() {
    this.m_buttonHintsController.AddButtonHint(n"option_switch_next", GetLocalizedTextByKey(n"Mod-Craft-UI-Next"));
    this.m_buttonHintsController.AddButtonHint(n"option_switch_prev", GetLocalizedTextByKey(n"Mod-Craft-UI-Previous"));
  };
}

@addMethod(CraftingLogicController)
public func HideButtonHints() -> Void {
  if !Config.RandomizerEnabled() {
    this.m_buttonHintsController.RemoveButtonHint(n"option_switch_next");
    this.m_buttonHintsController.RemoveButtonHint(n"option_switch_prev");
  };
}
