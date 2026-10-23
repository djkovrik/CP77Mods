@wrapMethod(GameplayMappinController)
private func UpdateIcon() -> Void {
  let data: ref<GameplayRoleMappinData>;
  if IsDefined(this.m_mappin) {
    data = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
  };

  if IsDefined(data) && data.m_isMappinCustom {
    inkWidgetRef.SetVisible(this.m_scanningDiamond, false);
    this.SetCustomMarkerIcon(this.m_mappin, this.iconWidget);
    this.SetCustomMarkerTint(this.m_mappin, this.iconWidget);
  } else {
    wrappedMethod();
  };
}
