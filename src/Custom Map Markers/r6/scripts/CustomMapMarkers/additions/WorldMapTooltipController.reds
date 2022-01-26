import Codeware.Localization.*
import CustomMarkers.Config.*

// Set custom data for worldmap mappin popup
@wrapMethod(WorldMapTooltipController)
public func SetData(data: WorldMapTooltipData, menu: ref<WorldMapMenuGameController>) -> Void {
  wrappedMethod(data, menu);

  // CUSTOM
  let mappinData: ref<GameplayRoleMappinData>;
  let newTitleStr: String;
  let newDescStr: String;
  let newInputZoomToStr: String;
  if data.controller != null && data.mappin != null && menu.GetPlayer() != null {
    mappinData = data.mappin.GetScriptData() as GameplayRoleMappinData;
    if IsDefined(mappinData) && mappinData.m_isMappinCustom {
      // Set title and description
      newTitleStr = mappinData.m_customMappinTitle;
      newDescStr = mappinData.m_customMappinDescription;
      inkTextRef.SetText(this.m_titleText, newTitleStr);
      inkTextRef.SetText(this.m_descText, newDescStr);
      // Set Delete hint
      newInputZoomToStr = LocalizationSystem.GetInstance(menu.GetPlayer().GetGame()).GetText("CustomMarkers-ButtonLabelDelete");
      inkWidgetRef.SetVisible(this.m_inputZoomToContainer, true);
      inkTextRef.SetText(this.m_inputZoomToText, newInputZoomToStr);
    };
  };
}
