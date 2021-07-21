// --- CONFIG SECTION STARTS HERE:

public class FirstEquipConfig {
  // Set the animation probability in percents, you can use values from 0 to 100 here
  // 0 means that animation never plays, 100 means that animation always plays
  public static func PercentageProbability() -> Int32 = 75
  // Replace false with true if you want see firstEquip animation while in stealth mode
  public static func PlayInStealthMode() -> Bool = false
  // Replace false with true if you want see firstEquip animation when weapon magazine is empty
  public static func PlayWhenMagazineIsEmpty() -> Bool = false
}

// --- CONFIG SECTION ENDS HERE, DO NOT EDIT ANYTHING BELOW


// -- New stuff:
@addField(PlayerPuppet)
let m_skipFirstEquip: Bool;

@addMethod(PlayerPuppet)
public func ShouldRunFirstEquip(weapon: wref<WeaponObject>) -> Bool {

  if WeaponObject.IsMagazineEmpty(weapon) && !FirstEquipConfig.PlayWhenMagazineIsEmpty() {
    return false;
  };

  let probability: Int32 = FirstEquipConfig.PercentageProbability();
  let random: Int32 = RandRange(0, 100);

  if probability < 0 { return false; };
  if probability > 100 { return true; }
  if !FirstEquipConfig.PlayInStealthMode() && this.m_inCrouch { return false; }

  return random <= probability;
}

@addMethod(PlayerPuppet)
public func HasRangedWeaponEquipped() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if IsDefined(weapon) {
    if transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weapon.GetItemID()) {
      return true;
    };
  };
  return false;
}

@addMethod(PlayerPuppet)
public func SetSkipFirstEquip(skip: Bool) -> Void {
  this.m_skipFirstEquip = skip;
}

@addMethod(PlayerPuppet)
public func ShouldSkipFirstEquip() -> Bool {
  return this.m_skipFirstEquip;
}


// -- Handle skip flag for locomotion events:
@replaceMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let playerPuppet: ref<PlayerPuppet>;
  let event: Int32;
  let flag = UpperBodyTransition.HasRangedWeaponEquipped(scriptInterface);
  playerPuppet = scriptInterface.owner as PlayerPuppet;
  event = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed);
  if event == EnumInt(gamePSMDetailedLocomotionStates.Climb) || event == EnumInt(gamePSMDetailedLocomotionStates.Ladder) {
    if IsDefined(playerPuppet) {
      playerPuppet.SetSkipFirstEquip(true);
    };
  };

  let blockAimingFor: Float = this.GetStaticFloatParameter("softBlockAimingOnEnterFor", -1.00);
  if blockAimingFor > 0.00 {
    this.SoftBlockAimingForTime(stateContext, scriptInterface, blockAimingFor);
  };
  this.SetLocomotionParameters(stateContext, scriptInterface);
  this.SetCollisionFilter(scriptInterface);
  this.SetLocomotionCameraParameters(stateContext);
}

// -- Handle skip flag for body carrying events:
@replaceMethod(CarriedObjectEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let hasWeaponEquipped: Bool;
  let carrying: Bool = scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying);
  let playerPuppet: ref<PlayerPuppet>;
  let mountingInfo: MountingInfo = GameInstance.GetMountingFacility(scriptInterface.owner.GetGame()).GetMountingInfoSingleWithObjects(scriptInterface.owner);
  let isNPCMounted: Bool = EntityID.IsDefined(mountingInfo.childId);
  let attitude: EAIAttitude;
  let slotId: MountingSlotId;
  let mountEvent: ref<MountingRequest>;
  let puppet: ref<gamePuppet>;
  let workspotSystem: ref<WorkspotGameSystem>;
  // Set flag if player and not carrying yet
  playerPuppet = scriptInterface.executionOwner as PlayerPuppet;
  hasWeaponEquipped = playerPuppet.HasRangedWeaponEquipped();
  if IsDefined(playerPuppet) && !carrying {
    playerPuppet.SetSkipFirstEquip(hasWeaponEquipped);
  };
  if !isNPCMounted && !this.IsBodyDisposalOngoing(stateContext, scriptInterface) {
    mountEvent = new MountingRequest();
    slotId.id = n"leftShoulder";
    mountingInfo.childId = scriptInterface.owner.GetEntityID();
    mountingInfo.parentId = scriptInterface.executionOwner.GetEntityID();
    mountingInfo.slotId = slotId;
    mountEvent.lowLevelMountingInfo = mountingInfo;
    GameInstance.GetMountingFacility(scriptInterface.executionOwner.GetGame()).Mount(mountEvent);
    scriptInterface.owner as NPCPuppet.MountingStartDisableComponents();
  };
  workspotSystem = GameInstance.GetWorkspotSystem(scriptInterface.executionOwner.GetGame());
  this.m_animFeature = new AnimFeature_Mounting();
  this.m_animFeature.mountingState = 2;
  this.UpdateCarryStylePickUpAndDropParams(stateContext, scriptInterface, false);
  this.m_isFriendlyCarry = false;
  this.m_forcedCarryStyle = gamePSMBodyCarryingStyle.Any;
  puppet = scriptInterface.owner as gamePuppet;
  if IsDefined(puppet) {
    if IsDefined(workspotSystem) && !this.IsBodyDisposalOngoing(stateContext, scriptInterface) {
      workspotSystem.StopNpcInWorkspot(puppet);
    };
    attitude = GameObject.GetAttitudeBetween(scriptInterface.owner, scriptInterface.executionOwner);
    this.m_forcedCarryStyle = IntEnum(puppet.GetBlackboard().GetInt(GetAllBlackboardDefs().Puppet.ForcedCarryStyle));
    if Equals(this.m_forcedCarryStyle, gamePSMBodyCarryingStyle.Friendly) || Equals(attitude, EAIAttitude.AIA_Friendly) && Equals(this.m_forcedCarryStyle, gamePSMBodyCarryingStyle.Any) {
      this.m_isFriendlyCarry = true;
    };
    this.UpdateCarryStylePickUpAndDropParams(stateContext, scriptInterface, this.m_isFriendlyCarry);
  };
  scriptInterface.SetAnimationParameterFeature(n"Mounting", this.m_animFeature, scriptInterface.executionOwner);
  scriptInterface.SetAnimationParameterFeature(n"Mounting", this.m_animFeature);
  scriptInterface.owner as NPCPuppet.MountingStartDisableComponents();
}


// -- Handle skip flag for interaction events:
@replaceMethod(InteractiveDevice)
protected cb func OnInteractionUsed(evt: ref<InteractionChoiceEvent>) -> Bool {
  let playerPuppet: ref<PlayerPuppet>;
  let className: CName;
  let hasWeaponEquipped: Bool;
  // Set if player
  playerPuppet = evt.activator as PlayerPuppet;
  if IsDefined(playerPuppet) {
    className = evt.hotspot.GetClassName();
    if Equals(className, n"AccessPoint") || Equals(className, n"Computer") || Equals(className, n"Stillage") || Equals(className, n"WeakFence") {
      hasWeaponEquipped = playerPuppet.HasRangedWeaponEquipped();
      playerPuppet.SetSkipFirstEquip(hasWeaponEquipped);
    };
  };
  // Log("Interaction used: " + NameToString(evt.hotspot.GetClassName()));
  this.ExecuteAction(evt.choice, evt.activator, evt.layerData.tag);
}

// -- Handle skip flag for takedown events:
@replaceMethod(gamestateMachineComponent)
protected cb func OnStartTakedownEvent(startTakedownEvent: ref<StartTakedownEvent>) -> Bool {
  let initData: ref<LocomotionTakedownInitData> = new LocomotionTakedownInitData();
  let addEvent: ref<PSMAddOnDemandStateMachine> = new PSMAddOnDemandStateMachine();
  let record1HitDamage: ref<Record1DamageInHistoryEvent> = new Record1DamageInHistoryEvent();
  let instanceData: StateMachineInstanceData;
  let playerPuppet: ref<PlayerPuppet>;
  initData.target = startTakedownEvent.target;
  initData.slideTime = startTakedownEvent.slideTime;
  initData.actionName = startTakedownEvent.actionName;
  instanceData.initData = initData;
  addEvent.stateMachineName = n"LocomotionTakedown";
  addEvent.instanceData = instanceData;
  let owner: wref<Entity> = this.GetEntity();
  owner.QueueEvent(addEvent);
  if IsDefined(startTakedownEvent.target) {
    record1HitDamage.source = owner as GameObject;
    startTakedownEvent.target.QueueEvent(record1HitDamage);
  };

  playerPuppet = owner as PlayerPuppet;
  if IsDefined(playerPuppet) {
    playerPuppet.SetSkipFirstEquip(true);
  };
}

// -- Control if firstEquip should be played:
@replaceMethod(EquipmentBaseTransition)
protected final const func HandleWeaponEquip(scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>, stateMachineInstanceData: StateMachineInstanceData, item: ItemID) -> Void {
  let animFeature: ref<AnimFeature_EquipUnequipItem> = new AnimFeature_EquipUnequipItem();
  let weaponEquipAnimFeature: ref<AnimFeature_EquipType> = new AnimFeature_EquipType();
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(scriptInterface.executionOwner.GetGame());
  let statSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(scriptInterface.executionOwner.GetGame());
  let mappedInstanceData: InstanceDataMappedToReferenceName = this.GetMappedInstanceData(stateMachineInstanceData.referenceName);
  let firstEqSystem: ref<FirstEquipSystem> = FirstEquipSystem.GetInstance(scriptInterface.owner);
  let itemObject: wref<WeaponObject> = transactionSystem.GetItemInSlot(scriptInterface.executionOwner, TDBID.Create(mappedInstanceData.attachmentSlot)) as WeaponObject;
  let isInCombat: Bool = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == EnumInt(gamePSMCombat.InCombat);
  let weaponEquipEvent: ref<WeaponEquipEvent>;
  let statsEvent: ref<UpdateWeaponStatsEvent>;
  let playerPuppet: ref<PlayerPuppet>;
  if TweakDBInterface.GetBool(t"player.weapon.enableWeaponBlur", false) {
    this.GetBlurParametersFromWeapon(scriptInterface);
  };
  
  // If GetSkipFirstEquip then reset skip flag else if ShouldRunFirstEquip then play firstEquip
  playerPuppet = scriptInterface.owner as PlayerPuppet;
  if !isInCombat {
    if IsDefined(playerPuppet) {
      if Equals(playerPuppet.ShouldSkipFirstEquip(), true) {
        playerPuppet.SetSkipFirstEquip(false);
      } else {
        if playerPuppet.ShouldRunFirstEquip(itemObject) {
          weaponEquipAnimFeature.firstEquip = true;
          stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
        };
      };
    };
    //// Default game logic
    // if Equals(this.GetProcessedEquipmentManipulationRequest(stateMachineInstanceData, stateContext).equipAnim, gameEquipAnimationType.FirstEquip) || this.GetStaticBoolParameter("forceFirstEquip", false) || !firstEqSystem.HasPlayedFirstEquip(ItemID.GetTDBID(itemObject.GetItemID())) {
    //   weaponEquipAnimFeature.firstEquip = true;
    //   stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
    // };
  };
  animFeature.stateTransitionDuration = statSystem.GetStatValue(Cast(itemObject.GetEntityID()), gamedataStatType.EquipDuration);
  animFeature.itemState = 1;
  animFeature.itemType = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(item)).ItemType().AnimFeatureIndex();
  this.BlockAimingForTime(stateContext, scriptInterface, animFeature.stateTransitionDuration + 0.10);
  weaponEquipAnimFeature.equipDuration = this.GetEquipDuration(scriptInterface, stateContext, stateMachineInstanceData);
  weaponEquipAnimFeature.unequipDuration = this.GetUnequipDuration(scriptInterface, stateContext, stateMachineInstanceData);
  scriptInterface.SetAnimationParameterFeature(mappedInstanceData.itemHandlingFeatureName, animFeature, scriptInterface.executionOwner);
  scriptInterface.SetAnimationParameterFeature(n"equipUnequipItem", animFeature, itemObject);
  weaponEquipEvent = new WeaponEquipEvent();
  weaponEquipEvent.animFeature = weaponEquipAnimFeature;
  weaponEquipEvent.item = itemObject;
  GameInstance.GetDelaySystem(scriptInterface.executionOwner.GetGame()).DelayEvent(scriptInterface.executionOwner, weaponEquipEvent, 0.03);
  scriptInterface.executionOwner.QueueEventForEntityID(itemObject.GetEntityID(), new PlayerWeaponSetupEvent());
  statsEvent = new UpdateWeaponStatsEvent();
  scriptInterface.executionOwner.QueueEventForEntityID(itemObject.GetEntityID(), statsEvent);
  if weaponEquipAnimFeature.firstEquip {
    scriptInterface.SetAnimationParameterFloat(n"safe", 0.00);
    stateContext.SetPermanentBoolParameter(n"WeaponInSafe", false, true);
    stateContext.SetPermanentFloatParameter(n"TurnOffPublicSafeTimeStamp", EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.owner.GetGame())), true);
  } else {
    if DefaultTransition.GetParameterBool(n"InPublicZone", stateContext, true) {
    } else {
      if DefaultTransition.GetParameterBool(n"WeaponInSafe", stateContext, true) {
        scriptInterface.SetAnimationParameterFloat(n"safe", 1.00);
      };
    };
  };
}
