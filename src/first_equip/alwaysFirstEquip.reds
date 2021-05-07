public class FirstEquipConfig {
  // Setup the animation probability in percents, you can use values from 0 to 100 here
  // 0 means that animation never plays, 100 means that animations plays every time you equip a weapon
  public static func PercentageProbability() -> Int32 = 100
  // Replace false with true if you want see firstEquip animation while in stealth mode
  public static func PlayInStealthMode() -> Bool = true
}

@addField(PlayerPuppet)
let m_skipFirstEquip: Bool;

@addMethod(PlayerPuppet)
public func ShouldRunFirstEquip() -> Bool {
  let probability: Int32 = FirstEquipConfig.PercentageProbability();
  let random: Int32 = RandRange(0, 100);

  if probability < 0 { return false; };
  if probability > 100 { return true; }
  if !FirstEquipConfig.PlayInStealthMode() && this.m_inCrouch { return false; }

  return random <= probability;
}

@addMethod(PlayerPuppet)
public func SetSkipFirstEquip(skip: Bool) -> Void {
  this.m_skipFirstEquip = skip;
}

@addMethod(PlayerPuppet)
public func ShouldSkipFirstEquip() -> Bool {
  return this.m_skipFirstEquip;
}


// -- Handle skip flag for different locomotion events
@replaceMethod(LocomotionGroundEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let event: Int32;
  let playerPuppet: ref<PlayerPuppet>;
  let animFeature: ref<AnimFeature_PlayerLocomotionStateMachine>;
  let hasWeaponEquipped: Bool = UpperBodyTransition.HasRangedWeaponEquipped(scriptInterface);
  super.OnEnter(stateContext, scriptInterface);
  // Set skip flag after Climb or Ladder
  event = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed);
  if event == EnumInt(gamePSMDetailedLocomotionStates.Climb) || event == EnumInt(gamePSMDetailedLocomotionStates.Ladder) {
    playerPuppet = scriptInterface.owner as PlayerPuppet;
    if IsDefined(playerPuppet) {
      playerPuppet.SetSkipFirstEquip(hasWeaponEquipped);
    };
  };

  stateContext.RemovePermanentBoolParameter(n"enteredFallFromAirDodge");
  stateContext.SetPermanentIntParameter(n"currentNumberOfJumps", 0, true);
  stateContext.SetPermanentIntParameter(n"currentNumberOfAirDodges", 0, true);
  this.SetAudioParameter(n"RTPC_Vertical_Velocity", 0.00, scriptInterface);
  DefaultTransition.UpdateAimAssist(stateContext, scriptInterface);
  animFeature = new AnimFeature_PlayerLocomotionStateMachine();
  animFeature.inAirState = false;
  scriptInterface.SetAnimationParameterFeature(n"LocomotionStateMachine", animFeature);
  this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Fall, EnumInt(gamePSMFallStates.Default));
  GameInstance.GetAudioSystem(scriptInterface.owner.GetGame()).NotifyGameTone(n"EnterOnGround");
  this.StopEffect(scriptInterface, n"falling");
  stateContext.SetConditionBoolParameter(n"JumpPressed", false, true);
}


// -- Handle skip flag for body carrying events
@replaceMethod(CarriedObjectEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let hasWeaponEquipped: Bool = UpperBodyTransition.HasRangedWeaponEquipped(scriptInterface);
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


// -- Handle skip flag for device interaction events
@replaceMethod(InteractiveDevice)
protected cb func OnInteractionUsed(evt: ref<InteractionChoiceEvent>) -> Bool {
  let playerPuppet: ref<PlayerPuppet>;
  let className: CName;
  // Set if player
  playerPuppet = evt.activator as PlayerPuppet;
  if IsDefined(playerPuppet) {
    className = evt.hotspot.GetClassName();
    if Equals(className, n"AccessPoint") || Equals(className, n"Computer") || Equals(className, n"Stillage") || Equals(className, n"WeakFence") {
      playerPuppet.SetSkipFirstEquip(true);
    };
  };
  // Log("Interaction used: " + NameToString(evt.hotspot.GetClassName()));
  this.ExecuteAction(evt.choice, evt.activator, evt.layerData.tag);
}


// -- Control if firstEquip should be played
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
        if playerPuppet.ShouldRunFirstEquip() {
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
