module AlwaysFirstEquip

enum FirstEquipTimeUnit {
  Seconds = 0,
  Minutes = 1
}

enum FirstEquipHotkeyState {
  IDLE = 0,
  PREPARING = 1,
  TAPPED = 2,
  HOLD_STARTED = 3,
  HOLD_ENDED = 4,
}

enum SafeStanceHotkeyState {
  IDLE = 0,
  TAPPED = 1,
}

private static func AlwaysFirstEquipAction() -> CName = n"AlwaysFirstEquip"
private static func SafeWeaponAction() -> CName = n"SafeWeapon"

public class FirstEquipConfig {

  public static func Create() -> ref<FirstEquipConfig> {
    let self = new FirstEquipConfig();
    return self;
  }

  // Defines firstEquip animation probability in percents, you can use values from 0 to 100 here
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Percentage")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Percentage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let percentageProbability: Int32 = 50;

  // Use cooldown instead of probability
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Cooldowns")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Cooldowns-Desc")
  let useCooldownBasedCheck: Bool = false;

  // Cooldown time
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Cooldowns-Time")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Cooldowns-Time-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "120")
  let cooldownTime: Int32 = 20;

  // Cooldown time units: 1 = seconds, 2 = minutes
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Cooldowns-Time-Unit")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Cooldowns-Time-Unit-Desc")
  @runtimeProperty("ModSettings.displayValues.Seconds", "Mod-First-Equip-Seconds")
  @runtimeProperty("ModSettings.displayValues.Minutes", "Mod-First-Equip-Minutes")
  let cooldownTimeUnit: FirstEquipTimeUnit = FirstEquipTimeUnit.Seconds;

  // Replace false with true if you want see firstEquip animation while in combat mode
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Combat")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Combat-Desc")
  let playInCombatMode: Bool = false;

  // Replace false with true if you want see firstEquip animation while in stealth mode
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Stealth-Desc")
  let playInStealthMode: Bool = false;

  // Replace false with true if you want see firstEquip animation when weapon magazine is empty
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Magazine")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Magazine-Desc")
  let playWhenMagazineIsEmpty: Bool = false;

  // Replace false with true if you want see firstEquip animation while sprinting
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Sprinting")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Sprinting-Desc")
  let playWhileSprinting: Bool = false;

  // Replace false with true if you want to prevent probability based animations for arms cyberware
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-ArmsCW")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-ArmsCW-Desc")
  let excludeArmsCyberware: Bool = true;

  // -- Hotkey config

  // Replace true with false if you want to disable slot tracking behavior
  // If enabled then mod tracks slots usage and hotkey press equips weapon from the last used slot,
  // if disabled then hotkey press always equips weapon from slot defined by DefaultSlotNumber
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Hotkey")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Hotkey-Track")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Hotkey-Track-Desc")
  let trackLastUsedSlot: Bool = true;

  // Default slot number
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Hotkey")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Hotkey-Default")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Hotkey-Default-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "4")
  let defaultSlotNumber: Int32 = 1;

  // -- Common config
  // Replace true with false if you want to unbind IdleBreak animation trigger from a custom hotkey
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-IdleBreak")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-IdleBreak-Bind")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-IdleBreak-Bind-Desc")
  let bindToHotkeyIdleBreak: Bool = true;

  // Set IdleBreak animation probability in percents, you can use values from 0 to 100 here
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-IdleBreak")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-IdleBreak-Probability")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-IdleBreak-Probability-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let animationProbabilityIdleBreak: Int32 = 10;
  
  // Animation checks period in seconds, each check decides if animation should be played when V stands still based on 
  // probability value from AnimationProbability option (with default settings it runs each 5 seconds with 10% probability)
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-IdleBreak")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-IdleBreak-Check")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-IdleBreak-Check-Desc")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  let animationCheckPeriodIdleBreak: Float = 5.0;
}


public class FirstEquipGlobalInputListener {
    private let m_player: wref<PlayerPuppet>;

    public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
      this.m_player = player;
    }

    // Catch FirstTimeEquip hotkey press
    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
      let drawItemRequest: ref<DrawItemRequest>;
      let slotForHotkey: Int32;

      if !IsDefined(this.m_player) {
        return false;
      };

      if Equals(ListenerAction.GetName(action), SafeWeaponAction()) && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
        if this.m_player.HasAnyWeaponEquippedEQ() {
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.SafeStateRequested, true, false);
        };
      };

      if Equals(ListenerAction.GetName(action), AlwaysFirstEquipAction()) {
        let pressed: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);
        let released: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED);
        let hold: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE);

        if this.m_player.HasAnyWeaponEquippedEQ() {
          // If weapon equipped set flags
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyPressed, pressed, false);
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased, released, false);
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyHold, hold, false);
        } else {
          // If no weapon equipped then run firstEquip
          if this.m_player.firstEquipConfig.trackLastUsedSlot {
            slotForHotkey = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.FirstEqLastUsedSlot);
          } else {
            slotForHotkey = this.m_player.firstEquipConfig.defaultSlotNumber - 1;
          };
          drawItemRequest = new DrawItemRequest();
          drawItemRequest.itemID = EquipmentSystem.GetData(this.m_player).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, slotForHotkey);
          drawItemRequest.owner = this.m_player;
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEquipRequested, true, false);
          GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"EquipmentSystem").QueueRequest(drawItemRequest);
        };
      };
    }
}


// --- NEW FIELDS

@addField(PlayerPuppet) let firstEquipConfig: ref<FirstEquipConfig>;
@addField(PlayerPuppet) let skipFirstEquip: Bool;
@addField(PlayerPuppet) let safeStateForced: Bool;
@addField(PlayerPuppet) let firstEquipCooldowns: ref<inkIntHashMap>;
@addField(PlayerPuppet) let firstEquipInputListener: ref<FirstEquipGlobalInputListener>;

@addField(ReadyEvents) let firstEqHotkeyState: FirstEquipHotkeyState;
@addField(ReadyEvents) let safeStanceHotkeyState: SafeStanceHotkeyState;
@addField(ReadyEvents) let savedIdleTimestamp: Float;
@addField(ReadyEvents) let safeAnimFeature: ref<AnimFeature_SafeAction>;
@addField(ReadyEvents) let weaponObjectId: TweakDBID;
@addField(ReadyEvents) let isHoldActive: Bool;
@addField(ReadyEvents) let readyStateRequested: Bool;
@addField(ReadyEvents) let safeStateRequested: Bool;

@addField(UI_SystemDef) let FirstEquipRequested: BlackboardID_Bool;
@addField(UI_SystemDef) let FirstEqHotkeyPressed: BlackboardID_Bool;
@addField(UI_SystemDef) let FirstEqHotkeyReleased: BlackboardID_Bool;
@addField(UI_SystemDef) let FirstEqHotkeyHold: BlackboardID_Bool;
@addField(UI_SystemDef) let FirstEqLastUsedSlot: BlackboardID_Int;
@addField(UI_SystemDef) let SafeStateRequested: BlackboardID_Bool;


// --- HOTKEY AND CONFIG

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    this.firstEquipInputListener = new FirstEquipGlobalInputListener();
    this.firstEquipInputListener.SetPlayer(this);
    this.RegisterInputListener(this.firstEquipInputListener);
    this.firstEquipCooldowns = new inkIntHashMap();
    this.firstEquipConfig = FirstEquipConfig.Create();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.firstEquipInputListener);
    this.firstEquipInputListener = null;
    this.firstEquipConfig = null;
}


// --- WEAPON SAFE STANCE

@addMethod(PlayerPuppet)
public func SetSafeStateForced(forced: Bool) -> Void {
  this.safeStateForced = forced;
}

@addMethod(PlayerPuppet)
public func IsSafeStateForcedEQ() -> Bool {
  return this.safeStateForced;
}


// --- UTILITY FUNCTIONS

@addMethod(PlayerPuppet)
public func IsTryingWithArmsCW(weapon: wref<WeaponObject>) -> Bool {
  let armsCW: gamedataItemType = RPGManager.GetItemType(EquipmentSystem.GetInstance(this).GetActiveItem(this, gamedataEquipmentArea.ArmsCW));
  let itemId: ItemID = weapon.GetItemID();
  let targetItemType: gamedataItemType = RPGManager.GetItemType(itemId);
  let isTargetGorillaArms: Bool = Equals(armsCW, gamedataItemType.Cyb_Launcher) && Equals(targetItemType, gamedataItemType.Wea_Fists);
  let isTargetOtherArmsCW: Bool = Equals(targetItemType, gamedataItemType.Cyb_NanoWires) || Equals(targetItemType, gamedataItemType.Cyb_StrongArms) || Equals(targetItemType, gamedataItemType.Cyb_MantisBlades);
  return isTargetGorillaArms || isTargetOtherArmsCW;
}

@addMethod(PlayerPuppet)
public func ShouldRunFirstEquipEQ(weapon: wref<WeaponObject>) -> Bool {
  if !weapon.m_isMeleeWeapon && WeaponObject.IsMagazineEmpty(weapon) && !this.firstEquipConfig.playWhenMagazineIsEmpty {
    return false;
  };

  if !this.firstEquipConfig.playInCombatMode && this.m_inCombat { return false; }
  if !this.firstEquipConfig.playInStealthMode && this.m_inCrouch { return false; }
  if VehicleComponent.IsMountedToVehicle(this.GetGame(), this)  { return false; }

  let isSprinting: Bool = Equals(PlayerPuppet.GetCurrentLocomotionState(this), gamePSMLocomotionStates.Sprint);
  if !this.firstEquipConfig.playWhileSprinting && isSprinting { return false; }

  let uiSystemBB: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  let isHotkeyPressed: Bool = uiSystemBB.GetBool(GetAllBlackboardDefs().UI_System.FirstEquipRequested);
  if isHotkeyPressed { 
    uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEquipRequested, false, false);
    return true; 
  };

  if this.firstEquipConfig.excludeArmsCyberware && this.IsTryingWithArmsCW(weapon) {
    return false;
  };

  let itemId: TweakDBID;
  let currentTimeStamp: Int32;
  let probability: Int32;
  let random: Int32;
  let key: Uint64;
  let cooldown: Int32;
  let savedTime: Int32;

  if this.firstEquipConfig.useCooldownBasedCheck {
    // COOLDOWNS
    if Equals(this.firstEquipConfig.cooldownTimeUnit, FirstEquipTimeUnit.Seconds) {
      cooldown = this.firstEquipConfig.cooldownTime;
    } else {
      cooldown = this.firstEquipConfig.cooldownTime * 60;
    };

    itemId = ItemID.GetTDBID(weapon.GetItemID());
    key = TDBID.ToNumber(itemId);
    currentTimeStamp = Cast<Int32>(EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame())));

    if this.firstEquipCooldowns.KeyExist(key) {
      // Weapon does have saved cooldown
      savedTime = this.firstEquipCooldowns.Get(key);
      if currentTimeStamp - savedTime >= cooldown {
        // Time passed - refresh cooldown and allow firstEquip
        this.firstEquipCooldowns.Set(key, currentTimeStamp);
        return true;
      } else {
        // Time not passed - deny firstEquip
        return false;
      }
    } else {
      // Weapon does not have cooldown yet - save and allow firstEquip
      this.firstEquipCooldowns.Insert(key, currentTimeStamp);
      return true;
    };
  } else {
    // PROBABILITY
    probability = this.firstEquipConfig.percentageProbability;
    random = RandRange(0, 100);

    if probability < 0 { return false; }
    if probability > 100 { return true; }

    return random <= probability;
  };
}

@addMethod(PlayerPuppet)
public func ShouldRunIdleBreakEQ() -> Bool {
  if this.m_inCombat { return false; }
  if VehicleComponent.IsMountedToVehicle(this.GetGame(), this)  { return false; }

  let probability: Int32 = this.firstEquipConfig.animationProbabilityIdleBreak;
  let random: Int32 = RandRange(0, 100);

  if probability < 0 { return false; }
  if probability > 100 { return true; }

  return random <= probability;
}

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

@addMethod(PlayerPuppet)
public func HasAnyWeaponEquippedEQ() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  let weaponId: ItemID;
  if IsDefined(weapon) {
    weaponId = weapon.GetItemID();
    if transactionSystem.HasTag(this, WeaponObject.GetMeleeWeaponTag(), weaponId) 
      || transactionSystem.HasTag(this, WeaponObject.GetOneHandedRangedWeaponTag(), weaponId)
      || transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weaponId)
      || WeaponObject.IsFists(weaponId) 
      || WeaponObject.IsCyberwareWeapon(weaponId) {
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
  this.skipFirstEquip = skip;
}

@addMethod(PlayerPuppet)
public func ShouldSkipFirstEquipEQ() -> Bool {
  return this.skipFirstEquip;
}

public static func EQ(str: String) -> Void {
  // LogChannel(n"DEBUG", "> " + str);
}


// --- SET SKIP ANIMATION FLAGS

@wrapMethod(EquipCycleDecisions)
protected final const func ToFirstEquip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  return false;
}

// Climb
@wrapMethod(ClimbEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(playerPuppet) {
    playerPuppet.SetSkipFirstEquipEQ(true);
  };
}

// Ladder
@wrapMethod(LadderEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(playerPuppet) {
    playerPuppet.SetSkipFirstEquipEQ(true);
  };
}

// Body carrying
@wrapMethod(CarriedObjectEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let carrying: Bool = scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let hasWeaponEquipped: Bool = playerPuppet.HasAnyWeaponEquippedEQ();
  if IsDefined(playerPuppet) && !carrying {
    playerPuppet.SetSkipFirstEquipEQ(hasWeaponEquipped);
  };
  wrappedMethod(stateContext, scriptInterface);
}

// Interaction
@wrapMethod(InteractiveDevice)
protected cb func OnInteractionUsed(evt: ref<InteractionChoiceEvent>) -> Bool {
  let playerPuppet: ref<PlayerPuppet> = evt.activator as PlayerPuppet;
  let className: CName;
  let hasWeaponEquipped: Bool;
  if IsDefined(playerPuppet) {
    className = evt.hotspot.GetClassName();
    if Equals(className, n"AccessPoint") || Equals(className, n"Computer") || Equals(className, n"Stillage") || Equals(className, n"WeakFence") {
      hasWeaponEquipped = playerPuppet.HasAnyWeaponEquippedEQ();
      playerPuppet.SetSkipFirstEquipEQ(hasWeaponEquipped);
    };
  };
  wrappedMethod(evt);
}

// Takedown
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

  if !IsDefined(player) || !IsDefined(weapon) {
    return false;
  };

  return !player.ShouldRunFirstEquipEQ(weapon);
}


// --- WEAPON EQUIP LOGIC

// Controls if firstEquip should be played, allows firstEquip in combat if PlayInCombatMode option enabled
@replaceMethod(EquipmentBaseTransition)
protected final const func HandleWeaponEquip(scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>, stateMachineInstanceData: StateMachineInstanceData, item: ItemID) -> Void {
  let animFeatureMeleeData: ref<AnimFeature_MeleeData>;
  let autoRefillEvent: ref<SetAmmoCountEvent>;
  let autoRefillRatio: Float;
  let magazineCapacity: Uint32;
  let statsEvent: ref<UpdateWeaponStatsEvent>;
  let weaponEquipEvent: ref<WeaponEquipEvent>;
  let animFeature: ref<AnimFeature_EquipUnequipItem> = new AnimFeature_EquipUnequipItem();
  let weaponEquipAnimFeature: ref<AnimFeature_EquipType> = new AnimFeature_EquipType();
  let transactionSystem: ref<TransactionSystem> = scriptInterface.GetTransactionSystem();
  let statSystem: ref<StatsSystem> = scriptInterface.GetStatsSystem();
  let mappedInstanceData: InstanceDataMappedToReferenceName = this.GetMappedInstanceData(stateMachineInstanceData.referenceName);
  let itemObject: wref<WeaponObject> = transactionSystem.GetItemInSlot(scriptInterface.executionOwner, TDBID.Create(mappedInstanceData.attachmentSlot)) as WeaponObject;
  let isInCombat: Bool = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == EnumInt(gamePSMCombat.InCombat);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.owner as PlayerPuppet;
  if TweakDBInterface.GetBool(t"player.weapon.enableWeaponBlur", false) {
    this.GetBlurParametersFromWeapon(scriptInterface);
  };

  // Probability check and run
  if IsDefined(playerPuppet) && (!isInCombat || playerPuppet.firstEquipConfig.playInCombatMode) {
    if Equals(playerPuppet.ShouldSkipFirstEquipEQ(), true) {
      playerPuppet.SetSkipFirstEquipEQ(false);
    } else {
      if playerPuppet.ShouldRunFirstEquipEQ(itemObject) {
        weaponEquipAnimFeature.firstEquip = true;
        stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
      };
    };
  };

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
  if itemObject.WeaponHasTag(n"Throwable") && !scriptInterface.GetStatPoolsSystem().HasStatPoolValueReachedMax(Cast<StatsObjectID>(itemObject.GetEntityID()), gamedataStatPoolType.ThrowRecovery) {
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

  autoRefillRatio = statSystem.GetStatValue(Cast<StatsObjectID>(itemObject.GetEntityID()), gamedataStatType.MagazineAutoRefill);
  if autoRefillRatio > 0.00 {
    magazineCapacity = WeaponObject.GetMagazineCapacity(itemObject);
    autoRefillEvent = new SetAmmoCountEvent();
    autoRefillEvent.ammoTypeID = WeaponObject.GetAmmoType(itemObject);
    autoRefillEvent.count = Cast<Uint32>(Cast<Float>(magazineCapacity) * autoRefillRatio);
    itemObject.QueueEvent(autoRefillEvent);
  };
}


// --- TRACK USED SLOTS

@wrapMethod(DefaultTransition)
protected final const func SendEquipmentSystemWeaponManipulationRequest(const scriptInterface: ref<StateGameScriptInterface>, requestType: EquipmentManipulationAction, opt equipAnimType: gameEquipAnimationType) -> Void {
  let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(scriptInterface.executionOwner.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  let lastUsedSlot: Int32 = GameInstance.GetBlackboardSystem(scriptInterface.executionOwner.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.FirstEqLastUsedSlot);
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
  blackboard.SetInt(GetAllBlackboardDefs().UI_System.FirstEqLastUsedSlot, newLastUsedSlot, false);
  wrappedMethod(scriptInterface, requestType, equipAnimType);
}

@wrapMethod(ReadyEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  // Initialize new fields
  this.firstEqHotkeyState = FirstEquipHotkeyState.IDLE;
  this.safeStanceHotkeyState = SafeStanceHotkeyState.IDLE;
  this.savedIdleTimestamp = this.m_timeStamp;
  this.safeAnimFeature = new AnimFeature_SafeAction();
  this.weaponObjectId = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(DefaultTransition.GetActiveWeapon(scriptInterface).GetItemID())).GetID();
  this.isHoldActive = false;
  this.readyStateRequested = false;
  this.safeStateRequested = false;
  // Register custom hotkey listener
  scriptInterface.executionOwner.RegisterInputListener(this, AlwaysFirstEquipAction());
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
  let doSafeAction: Bool;

  // New logic
  if DefaultTransition.HasRightWeaponEquipped(scriptInterface) {

    // HOTKEY BASED
    pressed = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyPressed);
    released = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased);
    hold = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyHold);
    doSafeAction = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.SafeStateRequested);

    // Safe stance check
    if Equals(this.safeStanceHotkeyState, SafeStanceHotkeyState.TAPPED) {
      GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.SafeStateRequested, false, false);
      this.safeStanceHotkeyState = SafeStanceHotkeyState.IDLE;
      doSafeAction = false;
      let state: Float;
      if player.IsSafeStateForcedEQ() {
        state = 0.0;
      } else {
        state = 1.0;
      };
      player.SetSafeStateForced(!player.IsSafeStateForcedEQ());
      scriptInterface.SetAnimationParameterFloat(n"safe", state);
    };
    
    // Safe stance requested
    if Equals(this.safeStanceHotkeyState, SafeStanceHotkeyState.IDLE) && doSafeAction {
      this.safeStanceHotkeyState = SafeStanceHotkeyState.TAPPED;
    };

    // Force weapon ready state if requested
    if this.readyStateRequested {
      this.readyStateRequested = false;
      scriptInterface.SetAnimationParameterFloat(n"safe", 0.0);
    };

    // Action detected when in IDLE state -> PREPARING
    if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.IDLE) && pressed {
      this.firstEqHotkeyState = FirstEquipHotkeyState.PREPARING;
    } else {
      // Action detected when in PREPARING STATE -> TAPPED OR HOLD_STARTED
      if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.PREPARING) {
        if hold {
          this.firstEqHotkeyState = FirstEquipHotkeyState.HOLD_STARTED;
        } else {
          if released {
            this.firstEqHotkeyState = FirstEquipHotkeyState.TAPPED;
          };
        };
      };
    };

    // Action detected when in HOLD_STARTED state -> HOLD_ENDED
    let buttonReleased: Bool = released || scriptInterface.GetActionValue(AlwaysFirstEquipAction()) < 0.50;
    if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.HOLD_STARTED) && buttonReleased {
      this.firstEqHotkeyState = FirstEquipHotkeyState.HOLD_ENDED;
    };

    // RUN ANIMATIONS
    if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.PREPARING) {
      // Switch weapon state to ready when hotkey clicked
      this.readyStateRequested = true;
    };
    // Single tap
    if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.TAPPED) {
      if player.firstEquipConfig.bindToHotkeyIdleBreak {
        this.savedIdleTimestamp = currentTime;
        scriptInterface.PushAnimationEvent(n"IdleBreak");
      };
      this.firstEqHotkeyState = FirstEquipHotkeyState.IDLE;
    } else {
      // Hold started
      if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.HOLD_STARTED) && !this.isHoldActive {
        // Move weapon to safe position and run SafeAction
        scriptInterface.SetAnimationParameterFloat(n"safe", 1.0);
        scriptInterface.PushAnimationEvent(n"SafeAction");
        stateContext.SetPermanentBoolParameter(n"TriggerHeld", true, true);
        this.safeAnimFeature.triggerHeld = true;
        this.isHoldActive = true;
      };
      // Hold released
      if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.HOLD_ENDED) {
        stateContext.SetPermanentBoolParameter(n"TriggerHeld", false, true);
        this.safeAnimFeature.triggerHeld = false;
        this.firstEqHotkeyState = FirstEquipHotkeyState.IDLE;
        this.isHoldActive = false;
        // Switch weapon state to ready when SafeAction completed
        this.readyStateRequested = true;
        stateContext.SetConditionFloatParameter(n"ForceSafeTimeStampToAutoUnequip", stateContext.GetConditionFloat(n"ForceSafeTimeStampToAutoUnequip") + this.GetStaticFloatParameterDefault("addedTimeToAutoUnequipAfterSafeAction", 0.00), true);
      };
    };
    // AnimFeature setup
    stateContext.SetConditionFloatParameter(n"ForceSafeCurrentTimeToAutoUnequip", stateContext.GetConditionFloat(n"ForceSafeCurrentTimeToAutoUnequip") + timeDelta, true);
    this.safeAnimFeature.safeActionDuration = TDB.GetFloat(this.weaponObjectId + t".safeActionDuration");
    scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeature);
    scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeature, DefaultTransition.GetActiveWeapon(scriptInterface));
    
    // PROBABILITY BASED
    if WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10 && stateContext.IsStateActive(n"Locomotion", n"stand") && IsDefined(player) {
      playerStandsStill = WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10 && stateContext.IsStateActive(n"Locomotion", n"stand");
      timePassed = currentTime - this.savedIdleTimestamp > player.firstEquipConfig.animationCheckPeriodIdleBreak;
      if timePassed && playerStandsStill && !this.isHoldActive {
        // Reset flag and run IdleBreak
        this.savedIdleTimestamp = currentTime;
        if player.ShouldRunIdleBreakEQ() {
          scriptInterface.SetAnimationParameterFloat(n"safe", 0.0);
          scriptInterface.PushAnimationEvent(n"IdleBreak");
        };
      };
    };
  };

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

@wrapMethod(ZoomLevelAimEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if this.isAmingWithWeapon && player.IsSafeStateForcedEQ() {
    scriptInterface.SetAnimationParameterFloat(n"safe", 0.0);
    player.SetSafeStateForced(false);
  };
}

@wrapMethod(ShootEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if player.IsSafeStateForcedEQ() {
    scriptInterface.SetAnimationParameterFloat(n"safe", 0.0);
    player.SetSafeStateForced(false);
  };
}
