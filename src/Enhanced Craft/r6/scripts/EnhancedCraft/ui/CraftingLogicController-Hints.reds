module EnhancedCraft.UI
import EnhancedCraft.Config.*

// -- Displays Previous and Next variant button hints on crafting screen
@addMethod(CraftingLogicController)
public func ShowButtonHints() -> Void {
  if !Config.RandomizerEnabled() {
    this.m_buttonHintsController.AddButtonHint(HotkeyActions.EnhancedCraftNextAction(), GetLocalizedTextByKey(n"Mod-Craft-UI-Next"));
    this.m_buttonHintsController.AddButtonHint(HotkeyActions.EnhancedCraftPrevAction(), GetLocalizedTextByKey(n"Mod-Craft-UI-Previous"));
  };
}

// -- Hides displayed button hints
@addMethod(CraftingLogicController)
public func HideButtonHints() -> Void {
  if !Config.RandomizerEnabled() {
    this.m_buttonHintsController.RemoveButtonHint(HotkeyActions.EnhancedCraftNextAction());
    this.m_buttonHintsController.RemoveButtonHint(HotkeyActions.EnhancedCraftPrevAction());
  };
}
