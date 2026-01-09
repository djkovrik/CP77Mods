import CustomMarkers.Config.*
import CustomMarkers.Common.*

// Set worldmap icon
@wrapMethod(BaseWorldMapMappinController)
protected func UpdateIcon() -> Void {
  wrappedMethod();
  this.SetCustomMarkerIcon(this.m_mappin, this.iconWidget);
}

// Tint worldmap icon
@wrapMethod(BaseWorldMapMappinController)
private final func GetDesiredOpacityAndInteractivity(out opacity: Float, out interactive: Bool) -> Void {
  wrappedMethod(opacity, interactive);
  this.SetCustomMarkerTint(this.m_mappin, this.iconWidget);
}

// Set mappin icon and tint
@replaceMethod(MinimapDeviceMappinController)
protected func Update() -> Void {
  let gameplayRoleData: ref<GameplayRoleMappinData>;
  let iconID: TweakDBID;
  let isIconIDValid: Bool;
  let shouldShowEffectArea: Bool;
  let shouldShowMappin: Bool;
  let texturePart: CName;
  super.Update();
  gameplayRoleData = this.GetVisualData();
  if IsDefined(gameplayRoleData) && gameplayRoleData.m_showOnMiniMap {
    iconID = gameplayRoleData.m_textureID;
    isIconIDValid = TDBID.IsValid(iconID);
    if isIconIDValid {
      // Set custom icon for custom marker
      if gameplayRoleData.m_isMappinCustom {
        this.SetCustomMarkerIcon(this.m_mappin, this.iconWidget);
        this.SetCustomMarkerTint(this.m_mappin, this.iconWidget);
      } else {
        this.SetTexture(this.iconWidget, iconID);
      };
    } else {
      texturePart = this.GetTexturePartForDeviceEffect(gameplayRoleData.m_gameplayRole);
      inkImageRef.SetTexturePart(this.iconWidget, texturePart);
      isIconIDValid = NotEquals(texturePart, n"None");
    };
    shouldShowMappin = isIconIDValid;
  } else {
    shouldShowMappin = false;
  };
  shouldShowEffectArea = shouldShowMappin && (gameplayRoleData.m_isCurrentTarget || gameplayRoleData.m_isTagged);
  this.SetEffectAreaRadius(shouldShowEffectArea ? gameplayRoleData.m_range : 0.00);
  this.SetForceHide(!shouldShowMappin);
}

// Custom marker helper method
@addMethod(BaseMappinBaseController)
protected func SetCustomMarkerIcon(mappin: ref<IMappin>, image: inkImageRef) -> Void {
  let mappinData: ref<GameplayRoleMappinData>;
  if IsDefined(mappin) {
     mappinData = mappin.GetScriptData() as GameplayRoleMappinData;
     if IsDefined(mappinData) && mappinData.m_isMappinCustom {
      inkImageRef.SetAtlasResource(this.iconWidget, r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
      inkImageRef.SetTexturePart(this.iconWidget, mappinData.m_customMappinTexturePart);
     };
  };
}

// Custom tint helper method
@addMethod(BaseMappinBaseController)
protected func SetCustomMarkerTint(mappin: ref<IMappin>, image: inkImageRef) -> Void {
  let mappinData: ref<GameplayRoleMappinData>;
  let config: ref<CustomMarkersConfig>;
  let icon: ref<inkWidget>;
  let iconColor: CName;
  if IsDefined(mappin) {
     mappinData = mappin.GetScriptData() as GameplayRoleMappinData;
     config = new CustomMarkersConfig();
     iconColor = CustomMarkersConfig.GetColorStyleName(config.markerColorActive);
     if IsDefined(mappinData) && mappinData.m_isMappinCustom {
      icon = inkWidgetRef.Get(image);
      icon.BindProperty(n"tintColor", iconColor);
      icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
     };
  };
}
