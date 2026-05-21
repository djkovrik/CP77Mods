module VehicleSummonTweaks.Dismiss

@if(ModuleExists("VehiclePersistence.System"))
import VehiclePersistence.System.*

public class VehicleSummonDismissConfig {

  @runtimeProperty("ModSettings.mod", "Vehicle Dismiss")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Mod-Dismiss-Hotkey")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let dismissVehicle: EInputKey = EInputKey.IK_R;

  @runtimeProperty("ModSettings.mod", "Vehicle Dismiss")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "UI-Settings-Controller")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let dismissVehicleController: EInputKey = EInputKey.IK_Pad_DigitUp;

  @runtimeProperty("ModSettings.mod", "Vehicle Dismiss")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Devices-Interactions-Helpers-Hold")
  @runtimeProperty("ModSettings.description", "")
  public let hold: Bool = true;

  @runtimeProperty("ModSettings.mod", "Vehicle Dismiss")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Mod-Dismiss-Despawn-Period")
  @runtimeProperty("ModSettings.description", "")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "120")
  public let despawnDelay: Float = 30.0;
}

@addField(PlayerPuppet)
private let m_dismissPromptVisible: Bool;

@addField(PlayerPuppet)
private let m_vehicleDismissInProgress: Bool;

@addField(VehicleObject)
private let m_vehicleSummonTweaksDismissPending: Bool;

@addMethod(PlayerPuppet)
public func SetDismissPromptVisible(visible: Bool) -> Void {
  this.m_dismissPromptVisible = visible;
}

@addMethod(PlayerPuppet)
public func VSTD_SetDismissInProgress(value: Bool) -> Void {
  this.m_vehicleDismissInProgress = value;
}

@addMethod(PlayerPuppet)
public func VSTD_IsDismissInProgress() -> Bool {
  return this.m_vehicleDismissInProgress;
}

@addMethod(PlayerPuppet)
public func VSTD_QueueActionRestrictionNotification() -> Void {
  let notificationEvent: ref<UIInGameNotificationEvent> = new UIInGameNotificationEvent();
  notificationEvent.m_notificationType = UIInGameNotificationType.ActionRestriction;
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(notificationEvent);
}

@addMethod(VehicleObject)
public func VSTD_SetDismissPending(value: Bool) -> Void {
  this.m_vehicleSummonTweaksDismissPending = value;
}

@addMethod(VehicleObject)
public func VSTD_IsDismissPending() -> Bool {
  return this.m_vehicleSummonTweaksDismissPending;
}

@wrapMethod(interactionWidgetGameController)
protected cb func OnUpdateInteraction(argValue: Variant) -> Bool {
  let cfg: ref<VehicleSummonDismissConfig> = new VehicleSummonDismissConfig();
  let player: ref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  let interactionData: InteractionChoiceHubData = FromVariant<InteractionChoiceHubData>(argValue);
  let interactionChoices: array<InteractionChoiceData> = interactionData.choices;
  let choicesCount: Int32 = ArraySize(interactionChoices);
  let emptyChoices: array<InteractionChoiceData>;
  let firstChoice: InteractionChoiceData;
  let newChoice: InteractionChoiceData;

  let inputKey: EInputKey;
  if player.PlayerLastUsedPad() {
    inputKey = cfg.dismissVehicleController;
  } else {
    inputKey = cfg.dismissVehicle;
  };

  if choicesCount > 0 && player.VSTD_IsLookingAtDismissPendingVehicle() {
    interactionData.choices = emptyChoices;
    wrappedMethod(ToVariant(interactionData));
    player.SetDismissPromptVisible(false);
  } else if choicesCount > 0 && player.IsLookingAtOwnedVehicle() && !player.VSTD_IsDismissInProgress() {
    firstChoice = interactionChoices[0];
    newChoice.inputAction = n"VehicleDismiss";
    newChoice.rawInputKey = inputKey;
    newChoice.isHoldAction = cfg.hold;
    newChoice.localizedName = GetLocalizedTextByKey(n"Mod-Dismiss-Action");
    newChoice.type = firstChoice.type;
    newChoice.data = firstChoice.data;
    newChoice.captionParts = firstChoice.captionParts;
    ArrayPush(interactionChoices, newChoice);
    interactionData.choices = interactionChoices;
    wrappedMethod(ToVariant(interactionData));
    player.SetDismissPromptVisible(true);
  } else {
    wrappedMethod(argValue);
    player.SetDismissPromptVisible(false);
  };
}

@addMethod(PlayerPuppet)
public func IsLookingAtOwnedVehicle() -> Bool {
  let currentTarget: ref<VehicleObject> = GameInstance.GetTargetingSystem(this.GetGame()).GetLookAtObject(this) as VehicleObject;
  let isLookingAtOwnedVehicle: Bool = false;
  let vehicleId: TweakDBID;
  if IsDefined(currentTarget) {
    vehicleId = currentTarget.GetRecord().GetID();
    isLookingAtOwnedVehicle = this.IsThisVehicleOwned(vehicleId);
  };

  return isLookingAtOwnedVehicle;
}

@addMethod(PlayerPuppet)
public func VSTD_IsLookingAtDismissPendingVehicle() -> Bool {
  let currentTarget: ref<VehicleObject> = GameInstance.GetTargetingSystem(this.GetGame()).GetLookAtObject(this) as VehicleObject;
  return IsDefined(currentTarget) && currentTarget.VSTD_IsDismissPending();
}

@if(!ModuleExists("VehiclePersistence.System"))
@addMethod(PlayerPuppet)
private func IsThisVehicleOwned(id: TweakDBID) -> Bool {
  let system: ref<VehicleSystem> = GameInstance.GetVehicleSystem(this.GetGame());
  let unlockedVehicles: array<PlayerVehicle>;
  system.GetPlayerUnlockedVehicles(unlockedVehicles);
  for vehicle in unlockedVehicles {
    if Equals(vehicle.recordID, id) {
      return true;
    };
  };
  return false;
}

@if(ModuleExists("VehiclePersistence.System"))
@addMethod(PlayerPuppet)
private func IsThisVehicleOwned(id: TweakDBID) -> Bool {
  let system: ref<VehicleSystem> = GameInstance.GetVehicleSystem(this.GetGame());
  let unlockedVehicles: array<PlayerVehicle>;
  system.GetPlayerUnlockedVehicles(unlockedVehicles);
  for vehicle in unlockedVehicles {
    if Equals(vehicle.recordID, id) {
      return true;
    };
  };

  let persisted: Bool = PersistentVehicleSystem.GetInstance(this.GetGame()).IsVehiclePersistent(id);
  if persisted {
    return true;
  };

  return false;
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  wrappedMethod(action, consumer);
  let cfg: ref<VehicleSummonDismissConfig> = new VehicleSummonDismissConfig();
  let pressed: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);
  let hold: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE);
  let shouldTriger: Bool = !cfg.hold && pressed || cfg.hold && hold;
  let isMounted: Bool = VehicleComponent.IsMountedToVehicle(this.GetGame(), this);
  let currentTarget: ref<VehicleObject>;
  let aiEvent: ref<AIEvent>;
  let joinTrafficCommand: ref<AIVehicleJoinTrafficCommand>;
  let callback: ref<VehicleSummonDismissCallback>;

  if Equals(ListenerAction.GetName(action), n"VehicleDismiss") && this.IsLookingAtOwnedVehicle() && this.m_dismissPromptVisible && !isMounted && shouldTriger && !this.VSTD_IsDismissInProgress() {
    cfg = new VehicleSummonDismissConfig();
    currentTarget = GameInstance.GetTargetingSystem(this.GetGame()).GetLookAtObject(this) as VehicleObject;
    if !IsDefined(currentTarget) || currentTarget.VSTD_IsDismissPending() {
      return false;
    };

    currentTarget.VSTD_SetDismissPending(true);
    this.VSTD_SetDismissInProgress(true);

    aiEvent = new AIEvent();
    aiEvent.name = n"DriverReady";
    currentTarget.QueueEvent(aiEvent);

    joinTrafficCommand = new AIVehicleJoinTrafficCommand();
    joinTrafficCommand.needDriver = false;
    joinTrafficCommand.useKinematic = true;
    currentTarget.GetAIComponent().SendCommand(joinTrafficCommand);
  
    callback = new VehicleSummonDismissCallback();
    callback.vehicleSystem = GameInstance.GetVehicleSystem(this.GetGame());
    callback.vehicleId = Cast<GarageVehicleID>(currentTarget.GetRecord().GetID());
    callback.player = this;
    callback.vehicle = currentTarget;
    GameInstance.GetDelaySystem(this.GetGame()).DelayCallback(callback, cfg.despawnDelay);
  };
}

@wrapMethod(VehicleSystem)
public final static func IsSummoningVehiclesRestricted(game: GameInstance) -> Bool {
  let player: ref<PlayerPuppet> = GetPlayer(game);
  if IsDefined(player) && player.VSTD_IsDismissInProgress() {
    return true;
  };

  return wrappedMethod(game);
}

@wrapMethod(PlayerPuppet)
private final func ProcessCallVehicleAction(type: gameinputActionType) -> Void {
  if this.VSTD_IsDismissInProgress() {
    this.VSTD_QueueActionRestrictionNotification();
    return;
  };

  wrappedMethod(type);
}

@wrapMethod(VehicleWheelDecisions)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let player: ref<PlayerPuppet>;
  if ListenerAction.IsButtonJustPressed(action) {
    player = GetPlayer(GetGameInstance());
    if IsDefined(player) && player.VSTD_IsDismissInProgress() {
      player.VSTD_QueueActionRestrictionNotification();
      return false;
    };
  };

  return wrappedMethod(action, consumer);
}

@wrapMethod(gamevehicleVehicleMountableComponent)
protected final func MountEntityToSlot(parentID: EntityID, childId: EntityID, slot: CName, mountType: MountType) -> Void {
  let player: ref<PlayerPuppet>;
  let vehicle: ref<VehicleObject> = this.GetEntity() as VehicleObject;
  if IsDefined(vehicle) {
    player = GameInstance.FindEntityByID(vehicle.GetGame(), childId) as PlayerPuppet;
  };
  if IsDefined(player) && IsDefined(vehicle) && vehicle.VSTD_IsDismissPending() {
    return;
  };

  wrappedMethod(parentID, childId, slot, mountType);
}

public class VehicleSummonDismissCallback extends DelayCallback {
  public let vehicleSystem: wref<VehicleSystem>;
  public let vehicleId: GarageVehicleID;
  public let player: wref<PlayerPuppet>;
  public let vehicle: wref<VehicleObject>;

  public func Call() -> Void {
    if IsDefined(this.vehicleSystem) {
      this.vehicleSystem.DespawnPlayerVehicle(this.vehicleId);
    };
    if IsDefined(this.vehicle) {
      this.vehicle.VSTD_SetDismissPending(false);
    };
    if IsDefined(this.player) {
      this.player.VSTD_SetDismissInProgress(false);
    };
  }
}
