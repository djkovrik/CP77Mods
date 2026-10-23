import CustomMarkers.Config.*

@wrapMethod(WorldMapTooltipController)
public func SetData(const data: script_ref<WorldMapTooltipData>, menu: ref<WorldMapMenuGameController>) -> Void {
  wrappedMethod(data, menu);

  let mappinData: ref<GameplayRoleMappinData>;
  let newTitleStr: String;
  let newDescStr: String;
  if Deref(data).controller != null && Deref(data).mappin != null && menu.GetPlayer() != null {
    mappinData = Deref(data).mappin.GetScriptData() as GameplayRoleMappinData;
    if IsDefined(mappinData) && mappinData.m_isMappinCustom {
      newTitleStr = mappinData.m_customMappinTitle;
      newDescStr = mappinData.m_customMappinDescription;
      inkTextRef.SetText(this.m_titleText, newTitleStr);
      inkTextRef.SetText(this.m_descText, newDescStr);
    };
  };
}
