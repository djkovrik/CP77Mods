module CustomMarkers.System

import Codeware.Localization.*
import CustomMarkers.Common.*
import CustomMarkers.Config.*

public class CustomMappinData {
  public persistent let position: Vector4;
  public persistent let description: CName;
  public persistent let type: CName;
}

// Custom ScriptableSystem which holds all markers related stuff
public class CustomMarkerSystem extends ScriptableSystem {

  private let m_mappinSystem: ref<MappinSystem>;

  private let m_translator: ref<LocalizationSystem>;

  private persistent let m_mappins: array<ref<CustomMappinData>>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.m_mappinSystem = GameInstance.GetMappinSystem(this.GetGameInstance());
    this.m_translator = LocalizationSystem.GetInstance(this.GetGameInstance());
    CMM(s"Initialized! Your game language code: \(ToString(this.m_translator.GetInterfaceLanguage()))");
    CMM(s"Persisted data loaded, mappins count: \(ToString(ArraySize(this.m_mappins)))");
  }

  public func AddCustomMappin(title: String, description: String, texturePart: CName, persist: Bool) -> Void {
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    let position: Vector4 = player.GetWorldPosition();
    this.AddCustomMappin(title, description, texturePart, position, persist);
  }

  public func AddCustomMappin(title: String, description: String, texturePart: CName, position: Vector4, persist: Bool) -> Void {
    if ArraySize(this.m_mappins) >= CustomMarkersConfig.MaximumAvailableMarkers() && persist {
      this.ShowCustomWarning(this.m_translator.GetText("CustomMarkers-LimitMessage"));
      return ;
    };

    if this.IsMarkerExists(position) && persist {
      this.ShowCustomWarning(this.m_translator.GetText("CustomMarkers-AlreadyExists"));
      return ;
    };

    let mappinData: MappinData = this.CreateMappinData(title, description, texturePart, position);
    this.m_mappinSystem.RegisterMappin(mappinData, position);
    if persist {
      this.AddPersistedMappin(description, texturePart, position);
    };
    this.ShowCustomMessage(this.m_translator.GetText("CustomMarkers-AddedMessage"));
    CMM(s"Registered mappin at position \(ToString(position)) as \(NameToString(texturePart))");
  }

  public func DeleteCustomMappin(position: Vector4) -> Void {
    let mappins: array<MappinEntry>;
    this.m_mappinSystem.GetMappins(gamemappinsMappinTargetType.World, mappins);
    for mappin in mappins {
      if Equals(mappin.worldPosition, position) {
        this.m_mappinSystem.UnregisterMappin(mappin.id);
        this.DeletePersistedMappin(position);
        CMM(s"Unregistered mappin at position \(ToString(position))");
      };
    };
  }

  public func GetCustomMappins() -> array<ref<CustomMappinData>> {
    return this.m_mappins;
  }

  private func AddPersistedMappin(description: String, type: CName, position: Vector4) -> Void {
    let persistedMappins: array<ref<CustomMappinData>> = this.m_mappins;
    let newMappin: ref<CustomMappinData> = new CustomMappinData();
    newMappin.position = position;
    newMappin.description = StringToName(description);
    newMappin.type = type;
    ArrayPush(persistedMappins, newMappin);
    this.m_mappins = persistedMappins;
    CMM(s"Persisted mappin added: \(position), persisted mappins count: \(ArraySize(this.m_mappins))");
  }

  private func DeletePersistedMappin(position: Vector4) -> Void {
    let persistedMappins: array<ref<CustomMappinData>> = this.m_mappins;
    let index: Int32 = 0;
    for mappin in persistedMappins {
      if Equals(mappin.position, position) {
        ArrayErase(persistedMappins, index);
      }
      index = index + 1;
    };
    this.m_mappins = persistedMappins;
    CMM(s"Persisted mappin deleted: \(position), persisted mappins count: \(ArraySize(this.m_mappins))");
  }

  public func RestorePersistedMappins() -> Void {
    CMM(s"Trying to restore persisted mappins: \(ArraySize(this.m_mappins))");
    let persistedMappins: array<ref<CustomMappinData>> = this.m_mappins;
    let counter: Int32 = 0;
    for mappin in persistedMappins {
      this.AddCustomMappin(this.m_translator.GetText("CustomMarkers-MarkerTitle"), NameToString(mappin.description), mappin.type, mappin.position, false);
      counter = counter + 1;
    };

    CMM(s"Persisted mappins restored: \(counter)");
  }

  private func CreateMappinData(title: String, description: String, texturePart: CName, position: Vector4) -> MappinData {
    let roleMappinData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
    let mappinData: MappinData;

    roleMappinData.m_isQuest = true;
    roleMappinData.m_visibleThroughWalls = true;
    roleMappinData.m_range = 100.0;
    roleMappinData.m_gameplayRole = EGameplayRole.FastTravel;
    roleMappinData.m_textureID = t"MappinIcons.GenericDeviceMappin";
    roleMappinData.m_showOnMiniMap = true;
    roleMappinData.m_isMappinCustom = true;
    roleMappinData.m_customMappinTitle = title;
    roleMappinData.m_customMappinDescription = description;
    roleMappinData.m_customMappinTexturePart = texturePart;

    mappinData.mappinType = t"Mappins.QuestStaticMappinDefinition";
    mappinData.variant = gamedataMappinVariant.DefaultQuestVariant;
    mappinData.active = true;
    mappinData.debugCaption = s"Custom mappin \(description)";
    mappinData.scriptData = roleMappinData;
    mappinData.visibleThroughWalls = true;

    return mappinData;
  }

  private func ShowCustomMessage(text: String) -> Void {
    let onScreenMessage: SimpleScreenMessage;
    let blackboardDef = GetAllBlackboardDefs().UI_Notifications;
    let blackboard = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(blackboardDef);
    onScreenMessage.isShown = true;
    onScreenMessage.message = text;
    onScreenMessage.duration = 2.00;
    blackboard.SetVariant(blackboardDef.OnscreenMessage, ToVariant(onScreenMessage), true);
  }

  private func ShowCustomWarning(text: String) -> Void {
    let evt: ref<UIInGameNotificationEvent> = new UIInGameNotificationEvent();
    evt.m_isCustom = true;
    evt.m_text = text;
    GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(evt);
  }

  private func IsMarkerExists(position: Vector4) -> Bool {
    for mappin in this.m_mappins {
      if Equals(mappin.position, position) {
        return true;
      };
    };
    return false;
  }
}
