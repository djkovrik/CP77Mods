public class SilentModeHelper extends IScriptable {

  public static func GetSilentModeEnabledLabel() -> String = "* Silent Mode: Disable"

  public static func GetSilentModeDisabledLabel() -> String = "* Silent Mode: Enable"

  public static func GetSilentModeEnabledNotification() -> String = "Silent mode enabled"

  public static func GetSilentModeDisabledNotification() -> String = "Silent mode disabled"

  public static func GetSilentModeDefaultStateWhenLoaded() -> Bool = true

  public static func GetEnabledId() -> String = "SilentModeEnabled"

  public static func GetDisabledId() -> String = "SilentModeDisabled"

  private let m_modeTurnedOnContact: ref<ContactData>;

  private let m_modeTurnedOffContact: ref<ContactData>;

  public func Initialize() -> Void {
    this.m_modeTurnedOnContact = this.GenerateContactData(true);
    this.m_modeTurnedOffContact = this.GenerateContactData(false);
  }

  public func GetSilentModeContact(enabled: Bool) -> ref<ContactData>  {
    if enabled {
      return this.m_modeTurnedOnContact;
    } else {
      return this.m_modeTurnedOffContact;
    };
  }

  private func GenerateContactData(enabled: Bool) -> ref<ContactData> {
    let newContact: ref<ContactData>;

    newContact = new ContactData();
    newContact.questRelated = false;
    newContact.hasMessages = false;
    newContact.unreadMessegeCount = 0;
    newContact.avatarID = t"PhoneAvatars.Avatar_Unknown";
    newContact.playerCanReply = false;
    newContact.playerIsLastSender = false;
    newContact.lastMesssagePreview = "";
    newContact.threadsCount = 0;

    if enabled {
      newContact.id = "SilentModeEnabled";
      newContact.localizedName = this.GetSilentModeEnabledLabel();
      newContact.hash = 12345556;
    } else {
      newContact.id = this.GetDisabledId();
      newContact.localizedName = this.GetSilentModeDisabledLabel();
      newContact.hash = 12345557;
    };

    return newContact;
  }
}

// -- New stuff for GameObject

@addField(GameObject)
let m_silentModeHelper: ref<SilentModeHelper>;

@addField(GameObject)
let m_IsSilentModeEnabled: Bool;

@addMethod(GameObject)
public func IsInVehicle() -> Bool {
  return VehicleComponent.IsMountedToVehicle(this.GetGame(), this.GetEntityID());
}

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
public func IsSilentModeEnabled() -> Bool {
  return this.m_IsSilentModeEnabled;
}

@addMethod(GameObject)
public func GetSilentModeContact() -> ref<ContactData> {
  return this.m_silentModeHelper.GetSilentModeContact(this.IsSilentModeEnabled());
}

@addMethod(GameObject)
public func SetSilentModeEnabled(enabled: Bool) -> Void {
  this.m_IsSilentModeEnabled = enabled;
}

@addMethod(GameObject)
public func ApplySilentModeEffect() -> Void {
  StatusEffectHelper.ApplyStatusEffect(this, t"GameplayRestriction.VehicleScene");
  PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(this);
}

@addMethod(GameObject)
public func RemoveSilentModeEffect() -> Void {
  StatusEffectHelper.RemoveStatusEffect(this, t"GameplayRestriction.VehicleScene");
  PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(this);
}

@addMethod(GameObject)
public func RefreshSilentModeState(withNotification: Bool) -> Void {
  if this.IsSilentModeEnabled() {
    if !this.IsInVehicle() {
      this.ApplySilentModeEffect();
    };
    if withNotification {
      this.ShowCustomNotification(SilentModeHelper.GetSilentModeEnabledNotification());
    };
  } else {
    this.RemoveSilentModeEffect();
    if withNotification {
      this.ShowCustomNotification(SilentModeHelper.GetSilentModeDisabledNotification());
    };
  };
}

@addMethod(GameObject)
public func ToggleSilentMode() -> Void {
  let isEnabled: Bool;
  isEnabled = this.IsSilentModeEnabled();
  this.SetSilentModeEnabled(!isEnabled);
  this.RefreshSilentModeState(true);
}

// -- Overrides

@replaceMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let objectID: StatsObjectID;
  let blackboard: ref<IBlackboard>;
  let playerAttach: ref<PlayerAttachRequest>;
  let memoryListener: ref<MemoryListener>;
  objectID = Cast(this.GetEntityID());
  playerAttach = new PlayerAttachRequest();
  playerAttach.owner = this;
  GameInstance.GetScriptableSystemsContainer(GetGameInstance()).QueueRequest(playerAttach);
  super.OnGameAttached();
  if this.IsControlledByLocalPeer() || IsHost() {
    this.RegisterInputListener(this);
    this.m_Debug_DamageInputRec = new DEBUG_DamageInputReceiver();
    this.m_Debug_DamageInputRec.m_player = this;
    this.RegisterInputListener(this.m_Debug_DamageInputRec);
  } else {
    if IsClient() {
      this.RegisterRemoteMappin();
      this.RefreshCPOVisionAppearance();
      this.RegisterCPOMissionDataCallback();
    };
  };
  this.m_CPOMissionDataState = new CPOMissionDataState();
  memoryListener = new MemoryListener();
  memoryListener.m_player = this;
  GameInstance.GetStatPoolsSystem(GetGameInstance()).RequestRegisteringListener(Cast(this.GetEntityID()), gamedataStatPoolType.Memory, memoryListener);
  this.isTalkingOnPhone = false;
  this.m_combatStateListener = Cast(0);
  this.m_LocomotionStateListener = Cast(0);
  this.m_coverVisibilityPerkBlocked = false;
  this.m_behindCover = false;
  this.m_inCombat = false;
  this.m_hasBeenDetected = false;
  this.m_inCrouch = false;
  this.RegisterToFacts();
  this.RegisterUIBlackboardListener();
  this.InitializeTweakDBRecords();
  this.DefineModifierGroups();
  this.RegisterStatListeners(this);
  this.UpdateVisibilityModifier();
  this.EnableInteraction(n"Revive", false);
  this.m_incapacitated = false;
  this.UpdatePlayerSettings();
  this.CalculateEncumbrance();
  AnimationControllerComponent.ApplyFeature(this, n"CameraGameplay", new AnimFeature_CameraGameplay());
  AnimationControllerComponent.ApplyFeature(this, n"CameraBodyOffset", new AnimFeature_CameraBodyOffset());
  this.m_playerAttachedCallbackID = GameInstance.GetPlayerSystem(GetGameInstance()).RegisterPlayerPuppetAttachedCallback(this, n"PlayerAttachedCallback");
  this.m_playerDetachedCallbackID = GameInstance.GetPlayerSystem(GetGameInstance()).RegisterPlayerPuppetDetachedCallback(this, n"PlayerDetachedCallback");
  this.UpdateSecondaryVisibilityOffset(false);
  this.EnableCombatVisibilityDistances(false);
  this.SetSenseObjectType(gamedataSenseObjectType.Player);
  this.GracePeriodAfterSpawn();
  StatusEffectHelper.RemoveStatusEffect(this, t"GameplayRestriction.FastForward");
  StatusEffectHelper.RemoveStatusEffect(this, t"GameplayRestriction.FastForwardCrouchLock");
  this.m_silentModeHelper = new SilentModeHelper();
  this.m_silentModeHelper.Initialize();
}

@replaceMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  this.SetInvisible(false);
  GameInstance.GetGodModeSystem(this.GetGame()).RemoveGodMode(this.GetEntityID(), gameGodModeType.Invulnerable, n"GracePeriodAfterSpawn");
  // setup silent mode after player loaded
  this.SetSilentModeEnabled(SilentModeHelper.GetSilentModeDefaultStateWhenLoaded());
  this.RefreshSilentModeState(true);
}

@replaceMethod(PhoneDialerGameController)
private final func PopulateData() -> Void {
  let initEvent: ref<PhoneDialerDelayedInit>;
  let contactDataArray: array<ref<IScriptable>>;
  let player: ref<PlayerPuppet>;
  contactDataArray = this.m_journalManager.GetContactDataArray(false);
  player = (this.GetPlayerControlledObject() as PlayerPuppet);

  // Insert silent mode toggle contact
  if NotEquals(player, null) {
    ArrayInsert(contactDataArray, 0, player.GetSilentModeContact());
  };

  this.m_dataView.EnableSorting();
  this.m_dataSource.Reset(contactDataArray);
  this.m_dataView.DisableSorting();
  initEvent = new PhoneDialerDelayedInit();
  this.QueueEvent(initEvent);
}

@replaceMethod(PhoneDialerGameController)
private final func CallSelectedContact() -> Void {
  let callRequest: ref<questTriggerCallRequest>;
  let contactData: ref<ContactData>;
  let player: ref<PlayerPuppet>;
  let item: ref<PhoneContactItemVirtualController>;
  player = (this.GetPlayerControlledObject() as PlayerPuppet);
  item = (this.m_listController.GetSelectedItem() as PhoneContactItemVirtualController);
  contactData = item.GetContactData();

  if NotEquals(contactData, null) {
    if NotEquals(contactData.id, SilentModeHelper.GetEnabledId()) && NotEquals(contactData.id, SilentModeHelper.GetDisabledId()) {
      // normal call
      callRequest = new questTriggerCallRequest();
      callRequest.addressee = StringToName(contactData.id);
      callRequest.caller = n"Player";
      callRequest.callPhase = questPhoneCallPhase.IncomingCall;
      callRequest.callMode = questPhoneCallMode.Video;
      this.m_phoneSystem.QueueRequest(callRequest);
    } else {
      // silent mode toggle
      player.ToggleSilentMode();
      this.CloseContactList();
    };
  };
}

@replaceMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  Log("VehicleComponent::OnMountingEvent");
  let mountChild: ref<GameObject>;
  let PSvehicleDooropenRequest: ref<VehicleDoorOpen>;
  let vehicleNPCData: ref<AnimFeature_VehicleNPCData>;
  let vehicleRecord: ref<Vehicle_Record>;
  let vehicleDataPackage: wref<VehicleDataPackage_Record>;
  mountChild = (GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject);
  VehicleComponent.GetVehicleDataPackage(this.GetVehicle().GetGame(), this.GetVehicle(), vehicleDataPackage);
  if mountChild.IsPlayer() {
    mountChild.RemoveSilentModeEffect();
    this.m_mountedPlayer = (mountChild as PlayerPuppet);
    VehicleComponent.QueueEventToAllPassengers(this.m_mountedPlayer.GetGame(), this.GetVehicle().GetEntityID(), PlayerMuntedToMyVehicle.Create(this.m_mountedPlayer));
    PlayerPuppet.ReevaluateAllBreathingEffects((mountChild as PlayerPuppet));
    if !this.GetVehicle().IsCrowdVehicle() {
      this.GetVehicle().GetDeviceLink().TriggerSecuritySystemNotification(this.GetVehicle().GetWorldPosition(), mountChild, ESecurityNotificationType.ALARM);
    };
    this.ToggleScanningComponent(false);
    if this.GetVehicle().GetHudManager().IsRegistered(this.GetVehicle().GetEntityID()) {
      this.RegisterToHUDManager(false);
    };
    this.RegisterInputListener();
    FastTravelSystem.AddFastTravelLock(n"InVehicle", this.GetVehicle().GetGame());
    this.m_mounted = true;
    this.SetupListeners();
    this.DisableTargetingComponents();
    if EntityID.IsDefined(evt.request.mountData.mountEventOptions.entityID) {
      this.m_enterTime = vehicleDataPackage.Stealing() + vehicleDataPackage.SlideDuration();
    } else {
      this.m_enterTime = vehicleDataPackage.Entering() + vehicleDataPackage.SlideDuration();
    };
    this.DrivingStimuli(true);
    if Equals(evt.request.lowLevelMountingInfo.slotId.id, VehicleComponent.GetDriverSlotName()) {
      if NotEquals((this.GetVehicle() as TankObject), null) {
        this.TogglePlayerHitShapesForPanzer(this.m_mountedPlayer, false);
        this.ToggleTargetingSystemForPanzer(this.m_mountedPlayer, true);
      };
      this.SetSteeringLimitAnimFeature(1);
    };
    if evt.request.mountData.isInstant {
      this.DetermineShouldCrystalDomeBeOn(0.00);
    } else {
      this.DetermineShouldCrystalDomeBeOn(0.75);
    };
  };
  if !mountChild.IsPlayer() {
    if evt.request.mountData.isInstant {
      mountChild.QueueEvent(CreateDisableRagdollEvent());
    };
    vehicleNPCData = new AnimFeature_VehicleNPCData();
    VehicleComponent.GetVehicleNPCData(this.GetVehicle().GetGame(), mountChild, vehicleNPCData);
    AnimationControllerComponent.ApplyFeatureToReplicate(mountChild, n"VehicleNPCData", vehicleNPCData);
    AnimationControllerComponent.PushEventToReplicate(mountChild, n"VehicleNPCData");
    if mountChild.IsPuppet() && !this.GetVehicle().IsPlayerVehicle() && IsHostileTowardsPlayer(mountChild) || (mountChild as ScriptedPuppet).IsAggressive() {
      this.EnableTargetingComponents();
    };
  };
  if !evt.request.mountData.isInstant {
    PSvehicleDooropenRequest = new VehicleDoorOpen();
    PSvehicleDooropenRequest.slotID = this.GetVehicle().GetBoneNameFromSlot(evt.request.lowLevelMountingInfo.slotId.id);
    if EntityID.IsDefined(evt.request.mountData.mountEventOptions.entityID) {
      PSvehicleDooropenRequest.autoCloseTime = vehicleDataPackage.Stealing_open();
    } else {
      PSvehicleDooropenRequest.autoCloseTime = vehicleDataPackage.Normal_open();
    };
    if !this.GetPS().GetIsDestroyed() {
      PSvehicleDooropenRequest.shouldAutoClose = true;
    };
    GameInstance.GetPersistencySystem(this.GetVehicle().GetGame()).QueuePSEvent(this.GetPS().GetID(), this.GetPS().GetClassName(), PSvehicleDooropenRequest);
  };
}

@replaceMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  let mountChild: ref<GameObject>;
  let activePassengers: Int32;
  let turnedOn: Bool;
  let engineOn: Bool;
  mountChild = (GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject);
  VehicleComponent.SetAnimsetOverrideForPassenger(mountChild, evt.request.lowLevelMountingInfo.parentId, evt.request.lowLevelMountingInfo.slotId.id, 0.00);
  if NotEquals(mountChild, null) && mountChild.IsPlayer() {
    mountChild.RefreshSilentModeState(false);
    PlayerPuppet.ReevaluateAllBreathingEffects((mountChild as PlayerPuppet));
    this.ToggleScanningComponent(true);
    if this.GetVehicle().ShouldRegisterToHUD() {
      this.RegisterToHUDManager(true);
    };
    this.UnregisterInputListener();
    FastTravelSystem.RemoveFastTravelLock(n"InVehicle", this.GetVehicle().GetGame());
    this.m_mounted = false;
    this.UnregisterListeners();
    this.ToggleSiren(false, false);
    if this.m_broadcasting {
      this.DrivingStimuli(false);
    };
    if Equals(evt.request.lowLevelMountingInfo.slotId.id, n"seat_front_left") {
      turnedOn = this.GetVehicle().IsTurnedOn();
      engineOn = this.GetVehicle().IsEngineTurnedOn();
      if turnedOn {
        turnedOn = !turnedOn;
      };
      if engineOn {
        engineOn = !engineOn;
      };
      this.ToggleVehicleSystems(false, turnedOn, engineOn);
      this.GetVehicleControllerPS().SetState(vehicleEState.Default);
      this.SetSteeringLimitAnimFeature(0);
      this.m_ignoreAutoDoorClose = false;
    };
    this.DoPanzerCleanup();
    this.m_mountedPlayer = null;
    this.CleanUpRace();
  };
  if NotEquals(mountChild, null) && VehicleComponent.GetNumberOfActivePassengers(mountChild.GetGame(), this.GetVehicle().GetEntityID(), activePassengers) {
    if activePassengers < 0 {
      this.DisableTargetingComponents();
    };
  };
}

// -- Replace some VehicleScene checks

@replaceMethod(DefaultTransition)
protected final const func IsNoCombatActionsForced(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  //return PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"VehicleScene");
  return PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"NoCombat") || scriptInterface.executionOwner.IsInVehicle();
}

@replaceMethod(RadialMenuHelper)
public final static func IsWeaponsBlocked(target: wref<GameObject>) -> Bool {
  //return PlayerGameplayRestrictions.HasRestriction(target, n"VehicleScene") || PlayerGameplayRestrictions.HasRestriction(target, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(target, n"FirearmsNoUnequipNoSwitch");
  return target.IsInVehicle() || PlayerGameplayRestrictions.HasRestriction(target, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(target, n"FirearmsNoUnequipNoSwitch");
}


// @replaceMethod(PreventionSystem)
// public final const func CanPreventionReactToInput() -> Bool {
//   if Equals(this.m_player, null) {
//     return false;
//   };
//   if this.IsSystemDissabled() {
//     return false;
//   };
//   if EnumInt(this.m_playerHLS) > EnumInt(gamePSMHighLevel.SceneTier1) {
//     return false;
//   };
//   //if PlayerGameplayRestrictions.HasRestriction(this.m_player, n"VehicleCombat") || PlayerGameplayRestrictions.HasRestriction(this.m_player, n"VehicleScene") {
//   if PlayerGameplayRestrictions.HasRestriction(this.m_player, n"VehicleCombat") || this.m_player.IsInVehicle() {
//     return false;
//   };
//   return true;
// }

// @replaceMethod(QuickSlotsManager)
// protected final const func IsSelectingCombatItemPrevented() -> Bool {
//   //return PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"VehicleScene") || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"FirearmsNoUnequip") || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"FirearmsNoSwitch");
//   return this.m_Player.IsInVehicle() || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"FirearmsNoUnequip") || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(this.m_Player, n"FirearmsNoSwitch");
// }

// @replaceMethod(InventoryGPRestrictionHelper)
// private final static func CanInteractByEquipmentArea(itemData: InventoryItemData, playerPuppet: wref<PlayerPuppet>) -> Bool {
//   let equipmentSystem: wref<EquipmentSystem>;
//   let canInteract: Bool;
//   equipmentSystem = (GameInstance.GetScriptableSystemsContainer(playerPuppet.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem);

//   if Equals(InventoryItemData.GetEquipmentArea(itemData), gamedataEquipmentArea.Consumable) {
//     canInteract = !PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"FistFight");
//   } else {
//     if Equals(InventoryItemData.GetEquipmentArea(itemData), gamedataEquipmentArea.Weapon) {
//       //canInteract = !PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"VehicleScene") || PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"FirearmsNoUnequip") || PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"FirearmsNoSwitch") || InventoryGPRestrictionHelper.BlockedBySceneTier(playerPuppet) || !equipmentSystem.GetPlayerData(playerPuppet).IsEquippable(InventoryItemData.GetGameItemData(itemData));
//       canInteract = !playerPuppet.IsInVehicle() || PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"NoCombat") || PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"FirearmsNoUnequip") || PlayerGameplayRestrictions.HasRestriction(playerPuppet, n"FirearmsNoSwitch") || InventoryGPRestrictionHelper.BlockedBySceneTier(playerPuppet) || !equipmentSystem.GetPlayerData(playerPuppet).IsEquippable(InventoryItemData.GetGameItemData(itemData));
//     } else {
//       canInteract = true;
//     };
//   };

//   return canInteract;
// }

// @replaceMethod(DefaultTransition)
// protected final const func IsDisplayingInputHintBlocked(scriptInterface: ref<StateGameScriptInterface>, actionName: CName) -> Bool {
//   switch actionName {
//     case n"RangedAttack":
//       return StatusEffectHelper.HasStatusEffectWithTag(scriptInterface.executionOwner, n"NoCombat") || !this.HasAnyValidWeaponAvailable(scriptInterface);
//     case n"Jump":
//       return StatusEffectHelper.HasStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoJump");
//     case n"Exit":
//       //return PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"VehicleScene");
//       return scriptInterface.executionOwner.IsInVehicle();
//     case n"ToggleVehCamera":
//       return this.IsVehicleCameraChangeBlocked(scriptInterface);
//     case n"WeaponWheel":
//       return this.IsNoCombatActionsForced(scriptInterface) || this.IsVehicleExitCombatModeBlocked(scriptInterface);
//     case n"Dodge":
//       return this.IsInTier2Locomotion(scriptInterface) || PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"PhoneCall");
//     case n"SwitchItem":
//       return PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"NoCombat") || !EquipmentSystem.HasItemInArea(scriptInterface.executionOwner, gamedataEquipmentArea.Weapon);
//     case n"DropCarriedObject":
//       return PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"BodyCarryingNoDrop");
//     case n"QuickMelee":
//       return PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"NoQuickMelee");
//     default:
//       return false;
//   };
// }

// @replaceMethod(VehicleTransition)
// protected final const func IsPlayerAllowedToExitVehicle(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
//   if PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"VehicleScene") {
//     return false;
//   };
//   if PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"VehicleCombat") {
//     return false;
//   };
//   if PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"VehicleBlockExit") {
//     return false;
//   };
//   if this.IsInPhotoMode(scriptInterface) {
//     return false;
//   };
//   return true;
// }

