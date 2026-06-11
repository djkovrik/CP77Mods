module CustomMarkers.System

import CustomMarkers.Common.*
import CustomMarkers.Config.*

@if(ModuleExists("CustomMarkers.Export"))
import CustomMarkers.Export.*

public class CustomMappinData {
  public persistent let position: Vector4;
  public persistent let description: CName;
  public persistent let type: CName;
}

// Custom ScriptableSystem which holds all markers related stuff
public class CustomMarkerSystem extends ScriptableSystem {

  private let m_mappinSystem: ref<MappinSystem>;

  private let m_persistedMappinsRestored: Bool;

  private persistent let m_mappins: array<ref<CustomMappinData>>;

  private let m_externalMappins: array<ref<CustomMappinData>>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.m_mappinSystem = GameInstance.GetMappinSystem(this.GetGameInstance());
    CMM(s"Persisted data loaded, mappins count: \(ToString(ArraySize(this.m_mappins)))");
  }

  public func AddCustomMappin(title: String, description: String, texturePart: CName, persist: Bool) -> Void {
    let playerSystem: ref<PlayerSystem> = GameInstance.GetPlayerSystem(this.GetGameInstance());
    if !IsDefined(playerSystem) {
      CMM("Cannot add custom mappin: player system is not available");
      return ;
    };

    let player: ref<PlayerPuppet> = playerSystem.GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(player) {
      CMM("Cannot add custom mappin: player is not available");
      return ;
    };

    let position: Vector4 = player.GetWorldPosition();
    this.AddCustomMappin(title, description, texturePart, position, persist);
  }

  public func AddCustomMappin(title: String, description: String, texturePart: CName, position: Vector4, persist: Bool) -> Void {
    if !this.EnsureMappinSystem() {
      CMM("Cannot add custom mappin: mappin system is not available");
      return ;
    };

    if this.IsMarkerExists(position) && persist {
      this.ShowCustomWarning(GetLocalizedTextByKey(n"CustomMarkers-AlreadyExists"));
      return ;
    };

    let mappinData: MappinData = this.CreateMappinData(title, description, texturePart, position);
    this.m_mappinSystem.RegisterMappin(mappinData, position);
    if persist {
      this.AddPersistedMappin(description, texturePart, position);
    };
    this.ShowCustomMessage(GetLocalizedTextByKey(n"CustomMarkers-AddedMessage"));
    CMM(s"Registered mappin at position \(ToString(position)) as \(NameToString(texturePart))");
  }

  public func DeleteCustomMappin(position: Vector4) -> Void {
    if !this.EnsureMappinSystem() {
      CMM("Cannot delete custom mappin: mappin system is not available");
      return ;
    };

    let mappins: array<MappinEntry>;
    let mappinRef: ref<IMappin>;
    let mappinData: ref<GameplayRoleMappinData>;
    this.m_mappinSystem.GetMappinEntries(gamemappinsMappinTargetType.World, mappins);
    for mappin in mappins {
      mappinData = null;
      mappinRef = this.m_mappinSystem.GetMappin(mappin.id);
      if IsDefined(mappinRef) {
        mappinData = mappinRef.GetScriptData() as GameplayRoleMappinData;
      };
      if IsDefined(mappinData) && mappinData.m_isMappinCustom && Equals(mappin.worldPosition, position) {
        this.m_mappinSystem.UnregisterMappin(mappin.id);
        if !this.DeletePersistedMappin(position) {
          this.DeleteExternalMappin(position);
        };
        CMM(s"Unregistered mappin at position \(ToString(position))");
      };
    };
  }

  public func GetCustomMappins() -> array<ref<CustomMappinData>> {
    let result: array<ref<CustomMappinData>> = this.m_mappins;
    for mappin in this.m_externalMappins {
      if IsDefined(mappin) && !this.HasMappin(result, mappin) {
        ArrayPush(result, mappin);
      };
    };

    return result;
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
    this.RefreshStorageData();
  }

  private func DeletePersistedMappin(position: Vector4) -> Bool {
    let persistedMappins: array<ref<CustomMappinData>> = this.m_mappins;
    let index: Int32 = 0;
    for mappin in persistedMappins {
      if IsDefined(mappin) && Equals(mappin.position, position) {
        ArrayErase(persistedMappins, index);
        this.m_mappins = persistedMappins;
        CMM(s"Persisted mappin deleted: \(position), persisted mappins count: \(ArraySize(this.m_mappins))");
        this.RefreshStorageData();
        return true;
      };
      index = index + 1;
    };
    CMM(s"No persisted mappin found to delete at position \(position)");
    return false;
  }

  private func DeleteExternalMappin(position: Vector4) -> Bool {
    let externalMappins: array<ref<CustomMappinData>> = this.m_externalMappins;
    let index: Int32 = 0;
    for mappin in externalMappins {
      if IsDefined(mappin) && Equals(mappin.position, position) {
        ArrayErase(externalMappins, index);
        this.m_externalMappins = externalMappins;
        CMM(s"External mappin removed from runtime data: \(position), external mappins count: \(ArraySize(this.m_externalMappins))");
        return true;
      };
      index = index + 1;
    };
    return false;
  }

  public func RestorePersistedMappins() -> Void {
    if this.m_persistedMappinsRestored {
      return ;
    };

    this.m_persistedMappinsRestored = true;

    CMM(s"Trying to restore persisted mappins: \(ArraySize(this.m_mappins))");
    this.RefreshPersistedMappins();
    this.RefreshOtherModsMappins();
    let persistedMappins: array<ref<CustomMappinData>> = this.GetCustomMappins();
    let counter: Int32 = 0;
    for mappin in persistedMappins {
      this.AddCustomMappin(GetLocalizedTextByKey(n"CustomMarkers-MarkerTitle"), NameToString(mappin.description), mappin.type, mappin.position, false);
      counter = counter + 1;
    };

    CMM(s"Persisted mappins restored: \(counter)");
  }

  @if(ModuleExists("CustomMarkers.Export"))
  public final func RefreshPersistedMappins() -> Void {
    let exporter: ref<CustomMarkersExporter> = CustomMarkersExporter.Get();
    if !IsDefined(exporter) {
      CMM("Cannot refresh persisted mappins: exporter is not available");
      return ;
    };

    let updatedMappins: array<ref<CustomMappinData>> = exporter.RebuildMappinsWithStorageData(this.m_mappins);
    this.m_mappins = updatedMappins;
  }

  @if(ModuleExists("CustomMarkers.Export"))
  public final func RefreshOtherModsMappins() -> Void {
    let updatedMappins: array<ref<CustomMappinData>>;
    let exporter: ref<CustomMarkersExporter> = CustomMarkersExporter.Get();
    if !IsDefined(exporter) {
      CMM("Cannot refresh external mappins: exporter is not available");
      return ;
    };

    let otherModsMappins: array<ref<CustomMappinData>> = exporter.GetOtherModsMappinData();
    for mappin in otherModsMappins {
      if IsDefined(mappin) && !this.HasMappin(this.m_mappins, mappin) && !this.HasMappin(updatedMappins, mappin) {
        ArrayPush(updatedMappins, mappin);
      };
    };
    this.m_externalMappins = updatedMappins;
  }

  @if(ModuleExists("CustomMarkers.Export"))
  public final func RefreshStorageData() -> Void {
    let exporter: ref<CustomMarkersExporter> = CustomMarkersExporter.Get();
    if IsDefined(exporter) {
      exporter.PersistNewRevision(this.m_mappins);
    } else {
      CMM("Cannot refresh storage data: exporter is not available");
    };
  }

  @if(!ModuleExists("CustomMarkers.Export"))
  public final func RefreshPersistedMappins() -> Void {
    // do nothing
  }

  @if(!ModuleExists("CustomMarkers.Export"))
  public final func RefreshOtherModsMappins() -> Void {
    // do nothing
  }

  @if(!ModuleExists("CustomMarkers.Export"))
  public final func RefreshStorageData() -> Void {
    // do nothing
  }

  private func CreateMappinData(title: String, description: String, texturePart: CName, position: Vector4) -> MappinData {
    let roleMappinData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
    let mappinData: MappinData;

    roleMappinData.m_isQuest = true;
    roleMappinData.m_visibleThroughWalls = false;
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
    mappinData.visibleThroughWalls = false;

    return mappinData;
  }

  private func ShowCustomMessage(text: String) -> Void {
    let onScreenMessage: SimpleScreenMessage;
    let blackboardDef = GetAllBlackboardDefs().UI_Notifications;
    let blackboard = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(blackboardDef);
    if !IsDefined(blackboard) {
      return ;
    };

    onScreenMessage.isShown = true;
    onScreenMessage.message = text;
    onScreenMessage.duration = 2.00;
    blackboard.SetVariant(blackboardDef.OnscreenMessage, ToVariant(onScreenMessage), true);
  }

  private func ShowCustomWarning(text: String) -> Void {
    let evt: ref<UIInGameNotificationEvent> = new UIInGameNotificationEvent();
    evt.m_isCustom = true;
    evt.m_text = text;
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetGameInstance());
    if IsDefined(uiSystem) {
      uiSystem.QueueEvent(evt);
    };
  }

  private func IsMarkerExists(position: Vector4) -> Bool {
    return this.HasMappinAtPosition(this.m_mappins, position) || this.HasMappinAtPosition(this.m_externalMappins, position);
  }

  private func HasMappinAtPosition(source: array<ref<CustomMappinData>>, position: Vector4) -> Bool {
    for mappin in source {
      if IsDefined(mappin) && Equals(mappin.position, position) {
        return true;
      };
    };
    return false;
  }

  private func HasMappin(source: array<ref<CustomMappinData>>, mappin: ref<CustomMappinData>) -> Bool {
    if !IsDefined(mappin) {
      return false;
    };

    return this.HasMappinAtPosition(source, mappin.position);
  }

  private func EnsureMappinSystem() -> Bool {
    if !IsDefined(this.m_mappinSystem) {
      this.m_mappinSystem = GameInstance.GetMappinSystem(this.GetGameInstance());
    };

    return IsDefined(this.m_mappinSystem);
  }
}
