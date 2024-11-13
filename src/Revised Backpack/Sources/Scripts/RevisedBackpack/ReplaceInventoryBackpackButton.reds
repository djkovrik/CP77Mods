module RevisedBackpack

@wrapMethod(gameuiInventoryGameController)
protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
  wrappedMethod(userData);

  let settings: ref<RevisedBackpackSettings> = new RevisedBackpackSettings();
  if settings.replaceInventoryButton {
    HubMenuUtils.SetMenuHyperlinkData(this.m_btnBackpack, HubMenuItems.Backpack, HubMenuItems.Inventory, n"revised_backpack", n"ico_backpack", n"UI-PanelNames-BACKPACK");
  };
}
