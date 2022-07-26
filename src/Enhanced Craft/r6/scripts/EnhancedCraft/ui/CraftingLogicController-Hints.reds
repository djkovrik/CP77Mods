module EnhancedCraft.UI
import EnhancedCraft.Config.ECraftConfig
import EnhancedCraft.Config.HotkeyActions

// -- Displays Previous and Next variant button hints on crafting screen
@addMethod(CraftingLogicController)
public func ShowButtonHints() -> Void {
  if !this.ecraftConfig.randomizerEnabled {
    this.m_buttonHintsController.AddButtonHint(HotkeyActions.EnhancedCraftNextAction(this.ecraftConfig), GetLocalizedTextByKey(n"Mod-Craft-UI-Next"));
    this.m_buttonHintsController.AddButtonHint(HotkeyActions.EnhancedCraftPrevAction(this.ecraftConfig), GetLocalizedTextByKey(n"Mod-Craft-UI-Previous"));
  };
}

// -- Hides displayed button hints
@addMethod(CraftingLogicController)
public func HideButtonHints() -> Void {
  if !this.ecraftConfig.randomizerEnabled {
    this.m_buttonHintsController.RemoveButtonHint(HotkeyActions.EnhancedCraftNextAction(this.ecraftConfig));
    this.m_buttonHintsController.RemoveButtonHint(HotkeyActions.EnhancedCraftPrevAction(this.ecraftConfig));
  };
}
