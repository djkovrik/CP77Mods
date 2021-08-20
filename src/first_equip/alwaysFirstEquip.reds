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
@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.owner as PlayerPuppet;
  let event: Int32 = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed);
  if event == EnumInt(gamePSMDetailedLocomotionStates.Climb) || event == EnumInt(gamePSMDetailedLocomotionStates.Ladder) {
    if IsDefined(playerPuppet) {
      playerPuppet.SetSkipFirstEquip(true);
    };
  };

  wrappedMethod(stateContext, scriptInterface);
}

// -- Handle skip flag for body carrying events:
@wrapMethod(CarriedObjectEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let carrying: Bool = scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let hasWeaponEquipped: Bool = playerPuppet.HasRangedWeaponEquipped();
  // Set flag if player and not carrying yet
  if IsDefined(playerPuppet) && !carrying {
    playerPuppet.SetSkipFirstEquip(hasWeaponEquipped);
  };
  wrappedMethod(stateContext, scriptInterface);
}

// -- Handle skip flag for interaction events:
@wrapMethod(InteractiveDevice)
protected cb func OnInteractionUsed(evt: ref<InteractionChoiceEvent>) -> Bool {
  let playerPuppet: ref<PlayerPuppet> = evt.activator as PlayerPuppet;
  let className: CName;
  let hasWeaponEquipped: Bool;
  // Set if player
  if IsDefined(playerPuppet) {
    className = evt.hotspot.GetClassName();
    if Equals(className, n"AccessPoint") || Equals(className, n"Computer") || Equals(className, n"Stillage") || Equals(className, n"WeakFence") {
      hasWeaponEquipped = playerPuppet.HasRangedWeaponEquipped();
      playerPuppet.SetSkipFirstEquip(hasWeaponEquipped);
    };
  };
  wrappedMethod(evt);
}

// -- Handle skip flag for takedown events:
@wrapMethod(gamestateMachineComponent)
protected cb func OnStartTakedownEvent(startTakedownEvent: ref<StartTakedownEvent>) -> Bool {
  let playerPuppet: ref<PlayerPuppet> = this.GetEntity() as PlayerPuppet;
  if IsDefined(playerPuppet) {
    playerPuppet.SetSkipFirstEquip(true);
  };
  wrappedMethod(startTakedownEvent);
}

// -- Control if firstEquip should be played:
@replaceMethod(EquipmentBaseTransition)
protected final const func HandleWeaponEquip(scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>, stateMachineInstanceData: StateMachineInstanceData, item: ItemID) -> Void {
  let statsEvent: ref<UpdateWeaponStatsEvent>;
  let weaponEquipEvent: ref<WeaponEquipEvent>;
  let animFeature: ref<AnimFeature_EquipUnequipItem> = new AnimFeature_EquipUnequipItem();
  let weaponEquipAnimFeature: ref<AnimFeature_EquipType> = new AnimFeature_EquipType();
  let transactionSystem: ref<TransactionSystem> = scriptInterface.GetTransactionSystem();
  let statSystem: ref<StatsSystem> = scriptInterface.GetStatsSystem();
  let mappedInstanceData: InstanceDataMappedToReferenceName = this.GetMappedInstanceData(stateMachineInstanceData.referenceName);
  let firstEqSystem: ref<FirstEquipSystem> = FirstEquipSystem.GetInstance(scriptInterface.owner);
  let itemObject: wref<WeaponObject> = transactionSystem.GetItemInSlot(scriptInterface.executionOwner, TDBID.Create(mappedInstanceData.attachmentSlot)) as WeaponObject;
  let isInCombat: Bool = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == EnumInt(gamePSMCombat.InCombat);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.owner as PlayerPuppet;
  if TweakDBInterface.GetBool(t"player.weapon.enableWeaponBlur", false) {
    this.GetBlurParametersFromWeapon(scriptInterface);
  };
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
    // Default game logic
    // if weaponEquipAnimFeature.firstEquip = Equals(this.GetProcessedEquipmentManipulationRequest(stateMachineInstanceData, stateContext).equipAnim, gameEquipAnimationType.FirstEquip) || this.GetStaticBoolParameterDefault("forceFirstEquip", false) || !firstEqSystem.HasPlayedFirstEquip(ItemID.GetTDBID(itemObject.GetItemID())) {
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
    if stateContext.GetBoolParameter(n"InPublicZone", true) {
    } else {
      if stateContext.GetBoolParameter(n"WeaponInSafe", true) {
        scriptInterface.SetAnimationParameterFloat(n"safe", 1.00);
      };
    };
  };
}
