module EnhancedCraft.UI
import EnhancedCraft.Config.ECraftConfig

// -- Displays Previous and Next variant button hints on crafting screen
@addMethod(CraftingLogicController)
public func ShowButtonHints() -> Void {
  let lastUsedKBM: Bool =  this.m_craftingGameController.GetPlayer().PlayerLastUsedKBM();
  if !this.ecraftConfig.randomizerEnabled {
    this.m_buttonHintsController.AddButtonHint(n"ECraft_Next", GetLocalizedTextByKey(n"Mod-Craft-UI-Next"));
    if lastUsedKBM {
      this.m_buttonHintsController.AddButtonHint(n"ECraft_Prev", GetLocalizedTextByKey(n"Mod-Craft-UI-Previous"));
    };
  };
}

// -- Hides displayed button hints
@addMethod(CraftingLogicController)
public func HideButtonHints() -> Void {
  if !this.ecraftConfig.randomizerEnabled {
    this.m_buttonHintsController.RemoveButtonHint(n"ECraft_Prev");
    this.m_buttonHintsController.RemoveButtonHint(n"ECraft_Next");
  };
}
