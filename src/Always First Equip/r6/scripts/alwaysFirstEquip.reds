class FirstEquipConfig {
  // -- Common config
  // Defines firstEquip animation probability in percents, you can use values from 0 to 100 here
  public static func PercentageProbability() -> Int32 = 50
  // Replace false with true if you want see firstEquip animation while in combat mode
  public static func PlayInCombatMode() -> Bool = false
  // Replace false with true if you want see firstEquip animation while in stealth mode
  public static func PlayInStealthMode() -> Bool = false
  // Replace false with true if you want see firstEquip animation when weapon magazine is empty
  public static func PlayWhenMagazineIsEmpty() -> Bool = false
  // Replace false with true if you want see firstEquip animation while sprinting
  public static func PlayWhileSprinting() -> Bool = false


  // -- Hotkey config
  // Replace true with false if you want to unbind firstEquip animation trigger from a custom hotkey
  public static func BindToHotkey() -> Bool = true
  // Replace true with false if you want to disable slot tracking behavior
  // If enabled then mod tracks slots usage and hotkey press equips weapon from the last used slot,
  // if disabled then hotkey press always equips weapon from slot defined by DefaultSlotNumber
  public static func TrackLastUsedSlot() -> Bool = true
  // Default slot number
  public static func DefaultSlotNumber() -> Int32 = 1
}

class IdleBreakConfig {
  // -- Common config
  // Set IdleBreak animation probability in percents, you can use values from 0 to 100 here
  public static func AnimationProbability() -> Int32 = 10
  // Animation checks period in seconds, each check decides if animation should be played when V stands still based on 
  // probability value from AnimationProbability option (with default settings it runs each 5 seconds with 10% probability)
  public static func AnimationCheckPeriod() -> Float = 5.0

  // -- Hotkey config
  // Replace true with false if you want to unbind IdleBreak animation trigger from a custom hotkey
  public static func BindToHotkey() -> Bool = true 
}

// --- CONFIG SECTION ENDS HERE, DO NOT EDIT ANYTHING BELOW


// --- NEW FIELDS

@addField(PlayerPuppet)
private let skipFirstEquipEQ: Bool;

@addField(UI_SystemDef)
public let FirstEquipRequestedEQ: BlackboardID_Bool;

@addField(UI_SystemDef)
public let HotkeyPressedEQ: BlackboardID_Bool;

@addField(UI_SystemDef)
public let HotkeyReleasedEQ: BlackboardID_Bool;

@addField(UI_SystemDef)
public let HotkeyHoldEQ: BlackboardID_Bool;

@addField(UI_SystemDef)
public let LastUsedSlotEQ: BlackboardID_Int;

@addField(HotkeyItemController)
public let playerPuppetEQ: ref<PlayerPuppet>;


// --- CUSTOM HOTKEY

public class FirstEquipGlobalInputListener {
    private let m_player: ref<PlayerPuppet>;

    public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
      this.m_player = player;
    }

    // Catch FirstTimeEquip hotkey press
    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
      let drawItemRequest: ref<DrawItemRequest>;
      let sheatheRequest: ref<EquipmentSystemWeaponManipulationRequest>;
      let equipmentSystem: ref<EquipmentSystem>;
      let slotForHotkey: Int32;

      if !IsDefined(this.m_player) {
        return false;
      };

      if IsDefined(this.m_player) && Equals(ListenerAction.GetName(action), n"FirstTimeEquip") {
        let pressed: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);
        let released: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED);
        let hold: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE);

        // EQ(s"pressed = \(pressed), released = \(released), hold = \(hold)");

        if this.m_player.HasRangedWeaponEquippedEQ() {
          // If weapon equipped set flags
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.HotkeyPressedEQ, pressed, false);
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.HotkeyReleasedEQ, released, false);
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.HotkeyHoldEQ, hold, false);
        } else {
          // If no weapon equipped then run firstEquip
          if FirstEquipConfig.TrackLastUsedSlot() {
            slotForHotkey = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.LastUsedSlotEQ);
          } else {
            slotForHotkey = FirstEquipConfig.DefaultSlotNumber() - 1;
          };
          drawItemRequest = new DrawItemRequest();
          drawItemRequest.itemID = EquipmentSystem.GetData(this.m_player).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, slotForHotkey);
          drawItemRequest.owner = this.m_player;
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEquipRequestedEQ, true, false);
          GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"EquipmentSystem").QueueRequest(drawItemRequest);
        };
      };
    }
}

@addField(PlayerPuppet)
private let m_firstEquipGlobalInputListener: ref<FirstEquipGlobalInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    this.m_firstEquipGlobalInputListener = new FirstEquipGlobalInputListener();
    this.m_firstEquipGlobalInputListener.SetPlayer(this);
    this.RegisterInputListener(this.m_firstEquipGlobalInputListener);
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.m_firstEquipGlobalInputListener);
    this.m_firstEquipGlobalInputListener = null;
}


// --- UTILITY FUNCTIONS

// Checks if firstEquip animation must be played depending on config 
@addMethod(PlayerPuppet)
public func ShouldRunFirstEquipEQ(weapon: wref<WeaponObject>) -> Bool {
  if WeaponObject.IsMagazineEmpty(weapon) && !FirstEquipConfig.PlayWhenMagazineIsEmpty() {
    return false;
  };

  if !FirstEquipConfig.PlayInCombatMode() && this.m_inCombat { return false; }
  if !FirstEquipConfig.PlayInStealthMode() && this.m_inCrouch { return false; }

  let isSprinting: Bool = Equals(PlayerPuppet.GetCurrentLocomotionState(this), gamePSMLocomotionStates.Sprint);
  if !FirstEquipConfig.PlayWhileSprinting() && isSprinting { return false; }

  let probability: Int32 = FirstEquipConfig.PercentageProbability();
  let random: Int32 = RandRange(0, 100);

  if probability < 0 { return false; }
  if probability > 100 { return true; }

  return random <= probability;
}

// Checks if IdleBreak animation must be played depending on config 
@addMethod(PlayerPuppet)
public func ShouldRunIdleBreakEQ() -> Bool {
  let probability: Int32 = IdleBreakConfig.AnimationProbability();
  let random: Int32 = RandRange(0, 100);

  if probability < 0 { return false; }
  if probability > 100 { return true; }

  return random <= probability;
}

// Checks if player has any ranged weapon equipped
@addMethod(PlayerPuppet)
public func HasRangedWeaponEquippedEQ() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if IsDefined(weapon) {
    if transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weapon.GetItemID()) {
      return true;
    };
  };
  return false;
}

// Cycle slots forward
public static func GetNextSlotIndex(current: Int32) -> Int32 {
  switch current {
    case 0: return 1;
    case 1: return 2;
    case 2: return 3;
    default: return 0;
  };
}

// Cycle slots backwards
public static func GetPreviousSlotIndex(current: Int32) -> Int32 {
  switch current {
    case 3: return 2;
    case 2: return 1;
    case 1: return 0;
    default: return 3;
  };
}

// Flag which controls if firstEquip animation must be skipped
@addMethod(PlayerPuppet)
public func SetSkipFirstEquipEQ(skip: Bool) -> Void {
  this.skipFirstEquipEQ = skip;
}

@addMethod(PlayerPuppet)
public func ShouldSkipFirstEquipEQ() -> Bool {
  return this.skipFirstEquipEQ;
}

public static func EQ(str: String) -> Void {
  LogChannel(n"DEBUG", "> " + str);
}


// --- SET SKIP ANIMATION FLAGS

// Set skip flag for locomotion events
@wrapMethod(LocomotionEventsTransition)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.owner as PlayerPuppet;
  let event: Int32 = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed);
  if event == EnumInt(gamePSMDetailedLocomotionStates.Climb) || event == EnumInt(gamePSMDetailedLocomotionStates.Ladder) {
    if IsDefined(playerPuppet) {
      playerPuppet.SetSkipFirstEquipEQ(true);
    };
  };
  wrappedMethod(stateContext, scriptInterface);
}

// Set skip flag for body carrying events
@wrapMethod(CarriedObjectEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let carrying: Bool = scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let hasWeaponEquipped: Bool = playerPuppet.HasRangedWeaponEquippedEQ();
  // Set flag if player and not carrying yet
  if IsDefined(playerPuppet) && !carrying {
    playerPuppet.SetSkipFirstEquipEQ(hasWeaponEquipped);
  };
  wrappedMethod(stateContext, scriptInterface);
}

// Set skip flag for interaction events
@wrapMethod(InteractiveDevice)
protected cb func OnInteractionUsed(evt: ref<InteractionChoiceEvent>) -> Bool {
  let playerPuppet: ref<PlayerPuppet>;
  let className: CName;
  let hasWeaponEquipped: Bool;
  // Set if player
  playerPuppet = evt.activator as PlayerPuppet;
  if IsDefined(playerPuppet) {
    className = evt.hotspot.GetClassName();
    if Equals(className, n"AccessPoint") || Equals(className, n"Computer") || Equals(className, n"Stillage") || Equals(className, n"WeakFence") {
      hasWeaponEquipped = playerPuppet.HasRangedWeaponEquippedEQ();
      playerPuppet.SetSkipFirstEquipEQ(hasWeaponEquipped);
    };
  };
  wrappedMethod(evt);
}

// Set skip flag for takedown events
@replaceMethod(gamestateMachineComponent)
protected cb func OnStartTakedownEvent(startTakedownEvent: ref<StartTakedownEvent>) -> Bool {
  let instanceData: StateMachineInstanceData;
  let initData: ref<LocomotionTakedownInitData> = new LocomotionTakedownInitData();
  let addEvent: ref<PSMAddOnDemandStateMachine> = new PSMAddOnDemandStateMachine();
  let record1HitDamage: ref<Record1DamageInHistoryEvent> = new Record1DamageInHistoryEvent();
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
    playerPuppet.SetSkipFirstEquipEQ(true);
  };
}


// --- INJECT HOTKEY PRESS RESULT INTO DEFAULT CHECK

@replaceMethod(FirstEquipSystem)
public final const func HasPlayedFirstEquip(weaponID: TweakDBID) -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let weapon: wref<WeaponObject> = transactionSystem.GetItemInSlot(player, t"AttachmentSlots.WeaponRight") as WeaponObject;
  let isHotkeyPressed: Bool = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.FirstEquipRequestedEQ);
  let i: Int32 = 0;

  // Return false if hotkey pressed
  if isHotkeyPressed && FirstEquipConfig.BindToHotkey() {
    GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEquipRequestedEQ, false, false);
    return false;
  };

  // Return true if firstEquip blocked
  if !player.ShouldRunFirstEquipEQ(weapon) {
    return true;
  };

  // Default logic
  while i < ArraySize(this.m_equipDataArray) {
    if this.m_equipDataArray[i].weaponID == weaponID {
      return this.m_equipDataArray[i].hasPlayedFirstEquip;
    };
    i += 1;
  };
  return false;
}


// --- WEAPON EQUIP LOGIC

// Controls if firstEquip should be played, allows firstEquip in combat if PlayInCombatMode option enabled
@replaceMethod(EquipmentBaseTransition)
protected final const func HandleWeaponEquip(scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>, stateMachineInstanceData: StateMachineInstanceData, item: ItemID) -> Void {
  let animFeatureMeleeData: ref<AnimFeature_MeleeData>;
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
  if TweakDBInterface.GetBool(t"player.weapon.enableWeaponBlur", false) {
    this.GetBlurParametersFromWeapon(scriptInterface);
  };

  // Hotkey check and run
  if !firstEqSystem.HasPlayedFirstEquip(ItemID.GetTDBID(itemObject.GetItemID())) {
    weaponEquipAnimFeature.firstEquip = true;
    stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
  } else {
    // Probability check and run
    let playerPuppet: ref<PlayerPuppet> = scriptInterface.owner as PlayerPuppet;
    if IsDefined(playerPuppet) && (!isInCombat || FirstEquipConfig.PlayInCombatMode()) {
      if Equals(playerPuppet.ShouldSkipFirstEquipEQ(), true) {
        playerPuppet.SetSkipFirstEquipEQ(false);
      } else {
        if playerPuppet.ShouldRunFirstEquipEQ(itemObject) {
          weaponEquipAnimFeature.firstEquip = true;
          stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
        };
      };
    };
  };

  // Default game logic:
  // if !isInCombat {
  //   if Equals(this.GetProcessedEquipmentManipulationRequest(stateMachineInstanceData, stateContext).equipAnim, gameEquipAnimationType.FirstEquip) || this.GetStaticBoolParameterDefault("forceFirstEquip", false) || !firstEqSystem.HasPlayedFirstEquip(ItemID.GetTDBID(itemObject.GetItemID())) {
  //     weaponEquipAnimFeature.firstEquip = true;
  //     stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
  //   };
  // };
  animFeature.stateTransitionDuration = statSystem.GetStatValue(Cast<StatsObjectID>(itemObject.GetEntityID()), gamedataStatType.EquipDuration);
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
  if itemObject.WeaponHasTag(n"Throwable") && !scriptInterface.GetStatPoolsSystem().HasStatPoolValueReachedMax(Cast<StatsObjectID>(itemObject.GetEntityID()), gamedataStatPoolType.WeaponOverheat) {
    animFeatureMeleeData = new AnimFeature_MeleeData();
    animFeatureMeleeData.isThrowReloading = true;
    scriptInterface.SetAnimationParameterFeature(n"MeleeData", animFeatureMeleeData);
  };
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

// --- TRACK USED SLOTS

// -- Tracks last used slot
@wrapMethod(DefaultTransition)
protected final const func SendEquipmentSystemWeaponManipulationRequest(const scriptInterface: ref<StateGameScriptInterface>, requestType: EquipmentManipulationAction, opt equipAnimType: gameEquipAnimationType) -> Void {
  let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(scriptInterface.executionOwner.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  let lastUsedSlot: Int32 = GameInstance.GetBlackboardSystem(scriptInterface.executionOwner.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.LastUsedSlotEQ);
  let newLastUsedSlot: Int32 = lastUsedSlot;
  switch requestType {
    case EquipmentManipulationAction.RequestWeaponSlot1:
      newLastUsedSlot = 0;
      break;
    case EquipmentManipulationAction.RequestWeaponSlot2:
      newLastUsedSlot = 1;
      break;
    case EquipmentManipulationAction.RequestWeaponSlot3:
      newLastUsedSlot = 2;
      break;
    case EquipmentManipulationAction.RequestWeaponSlot4:
      newLastUsedSlot = 3;
      break;
    case EquipmentManipulationAction.CycleNextWeaponWheelItem:
      newLastUsedSlot = GetNextSlotIndex(lastUsedSlot);
      break;
    case EquipmentManipulationAction.CyclePreviousWeaponWheelItem:
      newLastUsedSlot = GetPreviousSlotIndex(lastUsedSlot);
      break;
  };
  blackboard.SetInt(GetAllBlackboardDefs().UI_System.LastUsedSlotEQ, newLastUsedSlot, false);
  wrappedMethod(scriptInterface, requestType, equipAnimType);
}


// --- IDLEBREAK AND SAFEACTION

enum FirstEquipHotkeyState {
  IDLE = 0,
  PREPARING = 1,
  TAPPED = 2,
  HOLD_STARTED = 3,
  HOLD_ENDED = 4,
}

// Track custom hotkey states
@addField(ReadyEvents)
private let customHotkeyStateEQ: FirstEquipHotkeyState;

// Timestamp field to control the mod logic periods
@addField(ReadyEvents)
private let savedIdleTimestampEQ: Float;

// SafeAction anim object
@addField(ReadyEvents)
private let safeAnimFeatureEQ: ref<AnimFeature_SafeAction>;

// Weapon object
@addField(ReadyEvents)
private let weaponObjectIDEQ: TweakDBID;

// Held status
@addField(ReadyEvents)
private let isHeldActiveEQ: Bool;

// Flag to request weapon ready state
@addField(ReadyEvents)
private let readyStateRequestedEQ: Bool;

@wrapMethod(ReadyEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  // Initialize new fields
  this.customHotkeyStateEQ = FirstEquipHotkeyState.IDLE;
  this.savedIdleTimestampEQ = this.m_timeStamp;
  this.safeAnimFeatureEQ = new AnimFeature_SafeAction();
  this.weaponObjectIDEQ = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(DefaultTransition.GetActiveWeapon(scriptInterface).GetItemID())).GetID();
  this.isHeldActiveEQ = false;
  this.readyStateRequestedEQ = false;
  // Register custom hotkey listener
  scriptInterface.executionOwner.RegisterInputListener(this, n"FirstTimeEquip");
}

@addMethod(ReadyEvents)
protected func OnDetach(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
  scriptInterface.executionOwner.UnregisterInputListener(this);
}

// Hack OnTick to play IdleBreak and SafeAction 
@replaceMethod(ReadyEvents)
protected final func OnTick(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let animFeature: ref<AnimFeature_WeaponHandlingStats>;
  let ownerID: EntityID;
  let statsSystem: ref<StatsSystem>;
  let gameInstance: GameInstance = scriptInterface.GetGame();
  let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(gameInstance));
  let behindCover: Bool = NotEquals(GameInstance.GetSpatialQueriesSystem(gameInstance).GetPlayerObstacleSystem().GetCoverDirection(scriptInterface.executionOwner), IntEnum(0l));
  if behindCover {
    this.m_timeStamp = currentTime;
    stateContext.SetPermanentFloatParameter(n"TurnOffPublicSafeTimeStamp", this.m_timeStamp, true);
  };

  // New values for probability based checks
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let playerStandsStill: Bool;
  let timePassed: Bool;
  // New values for hotkey based checks
  let pressed: Bool;
  let released: Bool;
  let hold: Bool;

  // New logic
  if DefaultTransition.HasRightWeaponEquipped(scriptInterface) {

    // HOTKEY BASED
    pressed = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.HotkeyPressedEQ);
    released = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.HotkeyReleasedEQ);
    hold = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.HotkeyHoldEQ);

    // EQ(s"OnTick: pressed = \(pressed), released = \(released), hold = \(hold), state = \(ToString(this.customHotkeyStateEQ))");

    // Force weapon ready state if requested
    if this.readyStateRequestedEQ {
      this.readyStateRequestedEQ = false;
      scriptInterface.SetAnimationParameterFloat(n"safe", 0.0);
    };

    // Action detected when in IDLE state -> PREPARING
    if Equals(this.customHotkeyStateEQ, FirstEquipHotkeyState.IDLE) && pressed {
      this.customHotkeyStateEQ = FirstEquipHotkeyState.PREPARING;
    } else {
      // Action detected when in PREPARING STATE -> TAPPED OR HOLD_STARTED
      if Equals(this.customHotkeyStateEQ, FirstEquipHotkeyState.PREPARING) {
        if hold {
          this.customHotkeyStateEQ = FirstEquipHotkeyState.HOLD_STARTED;
        } else {
          if released {
            this.customHotkeyStateEQ = FirstEquipHotkeyState.TAPPED;
          };
        };
      };
    };

    // Action detected when in HOLD_STARTED state -> HOLD_ENDED
    let buttonReleased: Bool = released || scriptInterface.GetActionValue(n"FirstTimeEquip") < 0.50;
    if Equals(this.customHotkeyStateEQ, FirstEquipHotkeyState.HOLD_STARTED) && buttonReleased {
      this.customHotkeyStateEQ = FirstEquipHotkeyState.HOLD_ENDED;
    };

    // RUN ANIMATIONS
    if Equals(this.customHotkeyStateEQ, FirstEquipHotkeyState.PREPARING) {
      // Switch weapon state to ready when hotkey clicked
      this.readyStateRequestedEQ = true;
    };
    // Single tap
    if Equals(this.customHotkeyStateEQ, FirstEquipHotkeyState.TAPPED) {
      if IdleBreakConfig.BindToHotkey() {
        this.savedIdleTimestampEQ = currentTime;
        scriptInterface.PushAnimationEvent(n"IdleBreak");
      };
      this.customHotkeyStateEQ = FirstEquipHotkeyState.IDLE;
    } else {
      // Hold started
      if Equals(this.customHotkeyStateEQ, FirstEquipHotkeyState.HOLD_STARTED) && !this.isHeldActiveEQ {
        // Move weapon to safe position and run SafeAction
        scriptInterface.SetAnimationParameterFloat(n"safe", 1.0);
        scriptInterface.PushAnimationEvent(n"SafeAction");
        stateContext.SetPermanentBoolParameter(n"TriggerHeld", true, true);
        this.safeAnimFeatureEQ.triggerHeld = true;
        this.isHeldActiveEQ = true;
      };
      // Hold released
      if Equals(this.customHotkeyStateEQ, FirstEquipHotkeyState.HOLD_ENDED) {
        stateContext.SetPermanentBoolParameter(n"TriggerHeld", false, true);
        this.safeAnimFeatureEQ.triggerHeld = false;
        this.customHotkeyStateEQ = FirstEquipHotkeyState.IDLE;
        this.isHeldActiveEQ = false;
        // Switch weapon state to ready when SafeAction completed
        this.readyStateRequestedEQ = true;
        stateContext.SetConditionFloatParameter(n"ForceSafeTimeStampToAutoUnequip", stateContext.GetConditionFloat(n"ForceSafeTimeStampToAutoUnequip") + this.GetStaticFloatParameterDefault("addedTimeToAutoUnequipAfterSafeAction", 0.00), true);
      };
    };
    // AnimFeature setup
    stateContext.SetConditionFloatParameter(n"ForceSafeCurrentTimeToAutoUnequip", stateContext.GetConditionFloat(n"ForceSafeCurrentTimeToAutoUnequip") + timeDelta, true);
    this.safeAnimFeatureEQ.safeActionDuration = TDB.GetFloat(this.weaponObjectIDEQ + t".safeActionDuration");
    scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeatureEQ);
    scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeatureEQ, DefaultTransition.GetActiveWeapon(scriptInterface));
    
    // PROBABILITY BASED
    if WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10 && stateContext.IsStateActive(n"Locomotion", n"stand") && IsDefined(player) {
      playerStandsStill = WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10 && stateContext.IsStateActive(n"Locomotion", n"stand");
      timePassed = currentTime - this.savedIdleTimestampEQ > IdleBreakConfig.AnimationCheckPeriod();
      if timePassed && playerStandsStill && !this.isHeldActiveEQ {
        // Reset flag and run IdleBreak
        this.savedIdleTimestampEQ = currentTime;
        if player.ShouldRunIdleBreakEQ() {
          scriptInterface.PushAnimationEvent(n"IdleBreak");
        };
      };
    };
  };

  // Default logic:
  // if WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10 && stateContext.IsStateActive(n"Locomotion", n"stand") {
  //   if scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) != EnumInt(gamePSMCombat.InCombat) && !behindCover {
  //     if this.m_timeStamp + this.GetStaticFloatParameterDefault("timeBetweenIdleBreaks", 20.00) <= currentTime {
  //       scriptInterface.PushAnimationEvent(n"IdleBreak");
  //       this.m_timeStamp = currentTime;
  //     };
  //   };
  // };
  if this.IsHeavyWeaponEmpty(scriptInterface) && !stateContext.GetBoolParameter(n"requestHeavyWeaponUnequip", true) {
    stateContext.SetPermanentBoolParameter(n"requestHeavyWeaponUnequip", true, true);
  };
  statsSystem = GameInstance.GetStatsSystem(gameInstance);
  ownerID = scriptInterface.ownerEntityID;
  animFeature = new AnimFeature_WeaponHandlingStats();
  animFeature.weaponRecoil = statsSystem.GetStatValue(Cast<StatsObjectID>(ownerID), gamedataStatType.RecoilAnimation);
  animFeature.weaponSpread = statsSystem.GetStatValue(Cast<StatsObjectID>(ownerID), gamedataStatType.SpreadAnimation);
  scriptInterface.SetAnimationParameterFeature(n"WeaponHandlingData", animFeature, scriptInterface.executionOwner);
}
