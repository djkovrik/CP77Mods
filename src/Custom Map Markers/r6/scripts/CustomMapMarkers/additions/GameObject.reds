import Codeware.Localization.*
import CustomMarkers.Core.*

@addMethod(GameObject)
public func ShowCustomNotification(text: String) -> Void {
  let onScreenMessage: SimpleScreenMessage;
  let blackboardDef = GetAllBlackboardDefs().UI_Notifications;
  let blackboard = GameInstance.GetBlackboardSystem(this.GetGame()).Get(blackboardDef);
  onScreenMessage.isShown = true;
  onScreenMessage.message = text;
  onScreenMessage.duration = 2.00;
  blackboard.SetVariant(blackboardDef.OnscreenMessage, ToVariant(onScreenMessage), true);
}

@addMethod(GameObject)
public func AddCustomMappin(title: String, description: String, texturePart: CName) -> Void {
  let position: Vector4 = this.GetWorldPosition();
  let roleMappinData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
  let mappinAddedMessage: String = LocalizationSystem.GetInstance(this.GetGame()).GetText("CustomMarkers-MappinAddedMessage");
  roleMappinData.m_mappinVisualState = EMappinVisualState.Available;
  roleMappinData.m_isTagged = false;
  roleMappinData.m_isQuest = false;
  roleMappinData.m_visibleThroughWalls = false;
  roleMappinData.m_range = 100.0;
  roleMappinData.m_isCurrentTarget = false;
  roleMappinData.m_gameplayRole = EGameplayRole.GenericRole;
  roleMappinData.m_braindanceLayer = braindanceVisionMode.Default;
  roleMappinData.m_quality = gamedataQuality.Invalid;
  roleMappinData.m_isIconic = false;
  roleMappinData.m_hasOffscreenArrow = true;
  roleMappinData.m_isScanningCluesBlocked = false;
  roleMappinData.m_textureID = t"MappinIcons.GenericDeviceMappin";
  roleMappinData.m_showOnMiniMap = true;
  roleMappinData.m_isMappinCustom = true;
  roleMappinData.m_customMappinTitle = title;
  roleMappinData.m_customMappinDescription = description;
  roleMappinData.m_customMappinTexturePart = texturePart;

  let mappinData: MappinData;
  mappinData.mappinType = t"Mappins.QuestStaticMappinDefinition";
  mappinData.variant = gamedataMappinVariant.DefaultQuestVariant;
  mappinData.active = true;
  mappinData.debugCaption = s"Custom mappin \(description)";
  mappinData.scriptData = roleMappinData;
  mappinData.visibleThroughWalls = false;

  GameInstance.GetMappinSystem(this.GetGame()).RegisterMappin(mappinData, position);
  L(s"Registered mappin at position \(ToString(position)) as \(NameToString(texturePart))");
  this.ShowCustomNotification(mappinAddedMessage);
}

@addMethod(GameObject)
public func DeleteCustomMappin(position: Vector4) -> Void {
  let ms: ref<MappinSystem> = GameInstance.GetMappinSystem(this.GetGame());
  let mappins: array<MappinEntry>;
  ms.GetMappins(gamemappinsMappinTargetType.World, mappins);
  for mappin in mappins {
    if Equals(mappin.worldPosition, position) {
      ms.UnregisterMappin(mappin.id);
      L(s"Unregistered mappin at position \(ToString(position))");
    };
  };
}
