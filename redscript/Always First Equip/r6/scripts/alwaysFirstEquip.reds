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

private func AlwaysFirstEquipAction() -> CName = n"AlwaysFirstEquip"
private func SafeWeaponAction() -> CName = n"SafeWeapon"

public class FirstEquipOperation {
  public let hotkeyRequested: Bool;
  public let hotkeyCanceled: Bool;
  public let hotkeyDispatched: Bool;
  public let hotkeyRequestsCreated: Bool;
  public let rightHotkeyConsumed: Bool;
  public let leftHotkeyConsumed: Bool;
  public let requestedItem: ItemID;
  public let player: wref<PlayerPuppet>;
  public let skip: Bool;
}

public class FirstEquipConfig {

  public static func Create() -> ref<FirstEquipConfig> {
    let self = new FirstEquipConfig();
    return self;
  }

  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "UI-Settings-KeyBindings")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Main-Hotkey")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let afeMainHotkey: EInputKey = EInputKey.IK_F2;
  
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "UI-Settings-KeyBindings")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Additional-Hotkey")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let afeAdditionalHotkey: EInputKey = EInputKey.IK_F3;

  // Defines firstEquip animation probability in percents, you can use values from 0 to 100 here
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Percentage")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Percentage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  public let percentageProbability: Int32 = 50;

  // Use cooldown instead of probability
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Cooldowns")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Cooldowns-Desc")
  public let useCooldownBasedCheck: Bool = false;

  // Cooldown time
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Cooldowns-Time")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Cooldowns-Time-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "120")
  public let cooldownTime: Int32 = 20;

  // Cooldown time units: 1 = seconds, 2 = minutes
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Triggering")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Cooldowns-Time-Unit")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Cooldowns-Time-Unit-Desc")
  @runtimeProperty("ModSettings.displayValues.Seconds", "Mod-First-Equip-Seconds")
  @runtimeProperty("ModSettings.displayValues.Minutes", "Mod-First-Equip-Minutes")
  public let cooldownTimeUnit: FirstEquipTimeUnit = FirstEquipTimeUnit.Seconds;

  // Replace false with true if you want see firstEquip animation while in combat mode
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Combat")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Combat-Desc")
  public let playInCombatMode: Bool = false;

  // Replace false with true if you want see firstEquip animation while in stealth mode
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Stealth-Desc")
  public let playInStealthMode: Bool = false;

  // Replace false with true if you want see firstEquip animation when weapon magazine is empty
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Magazine")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Magazine-Desc")
  public let playWhenMagazineIsEmpty: Bool = false;

  // Replace false with true if you want see firstEquip animation while sprinting
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-Sprinting")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-Sprinting-Desc")
  public let playWhileSprinting: Bool = false;

  // Replace false with true if you want to prevent probability based animations for arms cyberware
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Restrictions")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Restrictions-ArmsCW")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Restrictions-ArmsCW-Desc")
  public let excludeArmsCyberware: Bool = true;

  // -- Hotkey config

  // Replace true with false if you want to disable slot tracking behavior
  // If enabled then mod tracks slots usage and hotkey press equips weapon from the last used slot,
  // if disabled then hotkey press always equips weapon from slot defined by DefaultSlotNumber
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Hotkey")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Hotkey-Track")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Hotkey-Track-Desc")
  public let trackLastUsedSlot: Bool = true;

  // Default slot number
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-Hotkey")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-Hotkey-Default")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-Hotkey-Default-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "4")
  public let defaultSlotNumber: Int32 = 1;

  // -- Common config
  // Replace true with false if you want to unbind IdleBreak animation trigger from a custom hotkey
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-IdleBreak")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-IdleBreak-Bind")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-IdleBreak-Bind-Desc")
  public let bindToHotkeyIdleBreak: Bool = true;

  // Set IdleBreak animation probability in percents, you can use values from 0 to 100 here
  @runtimeProperty("ModSettings.mod", "First Equip")
  @runtimeProperty("ModSettings.category", "Mod-First-Equip-IdleBreak")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-First-Equip-IdleBreak-Probability")
  @runtimeProperty("ModSettings.description", "Mod-First-Equip-IdleBreak-Probability-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  public let animationProbabilityIdleBreak: Int32 = 10;
  
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
  public let animationCheckPeriodIdleBreak: Float = 5.0;
}


public class FirstEquipGlobalInputListener {
    private let m_player: wref<PlayerPuppet>;

    public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
      this.m_player = player;
    }

    // Catch FirstTimeEquip hotkey press
    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
      let drawItemRequest: ref<DrawItemRequest>;
      let itemID: ItemID;
      let playerData: ref<EquipmentSystemPlayerData>;
      let slotForHotkey: Int32;
      let uiSystemBB: ref<IBlackboard>;

      if !IsDefined(this.m_player) {
        return false;
      };

      uiSystemBB = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System);
      if !IsDefined(uiSystemBB) {
        return false;
      };

      let actionName: CName = ListenerAction.GetName(action);
      let actionPressed: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);

      if Equals(actionName, SafeWeaponAction()) && actionPressed {
        if this.m_player.IsSafeStateForcedEQ() {
          this.m_player.SetSafeStateForced(false);
        } else {
          if this.m_player.HasAnyWeaponEquippedEQ() {
            this.m_player.SetSafeStateForced(true);
          };
        };
      };

      if this.m_player.IsSafeStateForcedEQ() && actionPressed
        && (Equals(actionName, n"CameraAim") || Equals(actionName, n"RangedAttack")) {
        this.m_player.SetSafeStateForced(false);
      };

      if Equals(actionName, AlwaysFirstEquipAction()) {
        let pressed: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);
        let released: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED);
        let hold: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE);

        if this.m_player.HasAnyWeaponEquippedEQ() {
          if pressed {
            uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyPressed, true, false);
            uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased, false, false);
            uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyHold, false, false);
          };
          if hold {
            uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyHold, true, false);
          };
          if released {
            uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased, true, false);
          };
        } else {
          if !pressed {
            return false;
          };
          this.m_player.CancelFirstEquipRequestEQ();
          if !IsDefined(this.m_player.firstEquipConfig) {
            return false;
          };
          // If no weapon equipped then run firstEquip
          if this.m_player.firstEquipConfig.trackLastUsedSlot {
            slotForHotkey = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.FirstEqLastUsedSlot);
          } else {
            slotForHotkey = this.m_player.firstEquipConfig.defaultSlotNumber - 1;
          };
          if slotForHotkey < 0 || slotForHotkey > 3 {
            return false;
          };
          playerData = EquipmentSystem.GetData(this.m_player);
          if !IsDefined(playerData) {
            return false;
          };
          itemID = playerData.GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, slotForHotkey == 3 ? EnumInt(WeaponSlot.MeleeSlot) : slotForHotkey);
          if !ItemID.IsValid(itemID) {
            return false;
          };
          drawItemRequest = new DrawItemRequest();
          drawItemRequest.itemID = itemID;
          drawItemRequest.owner = this.m_player;
          let equipmentSystem: ref<ScriptableSystem> = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"EquipmentSystem");
          if IsDefined(equipmentSystem) {
            let operation: ref<FirstEquipOperation> = new FirstEquipOperation();
            operation.hotkeyRequested = true;
            operation.requestedItem = itemID;
            operation.player = this.m_player;
            this.m_player.firstEquipRequest = operation;
            drawItemRequest.firstEquipOperation = operation;
            equipmentSystem.QueueRequest(drawItemRequest);
          };
        };
      };
    }
}


// --- NEW FIELDS

@addField(PlayerPuppet) public let firstEquipConfig: ref<FirstEquipConfig>;
@addField(PlayerPuppet) public let skipFirstEquip: Bool;
@addField(PlayerPuppet) public let safeStateForced: Bool;
@addField(PlayerPuppet) public let safeStateReleaseRequested: Bool;
@addField(PlayerPuppet) public let leftSafeStateReleaseRequested: Bool;
@addField(PlayerPuppet) public let firstEquipCooldowns: ref<inkIntHashMap>;
@addField(PlayerPuppet) public let firstEquipInputListener: ref<FirstEquipGlobalInputListener>;

@addField(ReadyEvents) public let firstEqHotkeyState: FirstEquipHotkeyState;
@addField(ReadyEvents) public let savedIdleTimestamp: Float;
@addField(ReadyEvents) public let safeAnimFeature: ref<AnimFeature_SafeAction>;
@addField(ReadyEvents) public let isHoldActive: Bool;
@addField(ReadyEvents) public let readyStateRequested: Bool;

@addField(UI_SystemDef) public let FirstEqHotkeyPressed: BlackboardID_Bool;
@addField(UI_SystemDef) public let FirstEqHotkeyReleased: BlackboardID_Bool;
@addField(UI_SystemDef) public let FirstEqHotkeyHold: BlackboardID_Bool;
@addField(UI_SystemDef) public let FirstEqLastUsedSlot: BlackboardID_Int;

@addField(EquipmentSystemPlayerData) private let firstEquipOperation: ref<FirstEquipOperation>;
@addField(EquipmentManipulationRequest) public let firstEquipOperation: ref<FirstEquipOperation>;
@addField(EquipmentManipulationRequest) public let firstEquipItem: ItemID;
@addField(EquipmentManipulationRequest) public let firstEquipHotkeyConsumed: Bool;
@addField(DrawItemRequest) public let firstEquipOperation: ref<FirstEquipOperation>;
@addField(PlayerPuppet) public let firstEquipRequest: ref<FirstEquipOperation>;


// --- HOTKEY AND CONFIG

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    if IsDefined(this.firstEquipInputListener) {
      this.UnregisterInputListener(this.firstEquipInputListener);
    };
    this.firstEquipInputListener = new FirstEquipGlobalInputListener();
    this.firstEquipInputListener.SetPlayer(this);
    this.RegisterInputListener(this.firstEquipInputListener);
    this.firstEquipCooldowns = new inkIntHashMap();
    this.firstEquipConfig = FirstEquipConfig.Create();
    this.safeStateForced = false;
    this.safeStateReleaseRequested = false;
    this.leftSafeStateReleaseRequested = false;
    this.ResetFirstEquipInputStateEQ();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    if IsDefined(this.firstEquipInputListener) {
      this.UnregisterInputListener(this.firstEquipInputListener);
    };
    this.ResetFirstEquipInputStateEQ();
    this.firstEquipInputListener = null;
    this.firstEquipCooldowns = null;
    this.firstEquipConfig = null;
    this.safeStateForced = false;
    this.safeStateReleaseRequested = false;
    this.leftSafeStateReleaseRequested = false;
    wrappedMethod();
}

@addMethod(PlayerPuppet)
public func ResetFirstEquipInputStateEQ() -> Void {
  this.CancelFirstEquipRequestEQ();
  let uiSystemBB: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  if !IsDefined(uiSystemBB) {
    return;
  };
  uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyPressed, false, false);
  uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased, false, false);
  uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyHold, false, false);
}

@addMethod(PlayerPuppet)
public func CancelFirstEquipRequestEQ() -> Void {
  if IsDefined(this.firstEquipRequest) {
    this.firstEquipRequest.hotkeyCanceled = true;
    this.firstEquipRequest = null;
  };
}

@addMethod(PlayerPuppet)
public func IsFirstEquipRequestActiveEQ(operation: ref<FirstEquipOperation>) -> Bool {
  return IsDefined(operation) && operation.hotkeyRequested && !operation.hotkeyCanceled
    && operation.player == this && this.firstEquipRequest == operation;
}


// --- WEAPON SAFE STANCE

@addMethod(PlayerPuppet)
public func SetSafeStateForced(forced: Bool) -> Void {
  if forced {
    this.safeStateReleaseRequested = false;
    this.leftSafeStateReleaseRequested = false;
  } else {
    if this.safeStateForced {
      this.safeStateReleaseRequested = true;
      this.leftSafeStateReleaseRequested = IsDefined(GameObject.GetLeftActiveWeapon(this));
    };
  };
  this.safeStateForced = forced;
}

@addMethod(PlayerPuppet)
public func IsSafeStateForcedEQ() -> Bool {
  return this.safeStateForced;
}

@addMethod(PlayerPuppet)
public func IsSafeStateReleaseRequestedEQ(opt isLeftWeapon: Bool) -> Bool {
  return isLeftWeapon ? this.leftSafeStateReleaseRequested : this.safeStateReleaseRequested;
}

@addMethod(PlayerPuppet)
public func ClearSafeStateReleaseRequestEQ(opt isLeftWeapon: Bool) -> Void {
  if isLeftWeapon {
    this.leftSafeStateReleaseRequested = false;
  } else {
    this.safeStateReleaseRequested = false;
  };
}

@wrapMethod(DefaultTransition)
public final const func IsSafeStateForced(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if wrappedMethod(stateContext, scriptInterface) {
    return true;
  };

  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if !IsDefined(player) || !player.IsSafeStateForcedEQ() {
    return false;
  };

  return !scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.SceneAimForced)
    && !scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.SceneSafeForced);
}

@wrapMethod(PublicSafeDecisions)
protected final const func ToPublicSafeToReady(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if wrappedMethod(stateContext, scriptInterface) {
    return true;
  };

  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  return IsDefined(player) && player.IsSafeStateReleaseRequestedEQ(this.IsLeftWeaponLogic());
}

@wrapMethod(PublicSafeToReadyEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(player) {
    player.ClearSafeStateReleaseRequestEQ(this.IsLeftWeaponLogic());
  };
}


// --- UTILITY FUNCTIONS

@addMethod(PlayerPuppet)
public func IsTryingWithArmsCW(weapon: wref<WeaponObject>) -> Bool {
  if !IsDefined(weapon) {
    return false;
  };
  let equipmentSystem: ref<EquipmentSystem> = EquipmentSystem.GetInstance(this);
  if !IsDefined(equipmentSystem) {
    return false;
  };
  let armsCW: gamedataItemType = RPGManager.GetItemType(equipmentSystem.GetActiveItem(this, gamedataEquipmentArea.ArmsCW));
  let itemId: ItemID = weapon.GetItemID();
  let targetItemType: gamedataItemType = RPGManager.GetItemType(itemId);
  let isTargetGorillaArms: Bool = Equals(armsCW, gamedataItemType.Cyb_Launcher) && Equals(targetItemType, gamedataItemType.Wea_Fists);
  let isTargetOtherArmsCW: Bool = Equals(targetItemType, gamedataItemType.Cyb_NanoWires) || Equals(targetItemType, gamedataItemType.Cyb_StrongArms) || Equals(targetItemType, gamedataItemType.Cyb_MantisBlades);
  return isTargetGorillaArms || isTargetOtherArmsCW;
}

@addMethod(PlayerPuppet)
public func ShouldRunFirstEquipEQ(weapon: wref<WeaponObject>, requestedByHotkey: Bool) -> Bool {
  if !IsDefined(weapon) || !IsDefined(this.firstEquipConfig) {
    return false;
  };

  if !weapon.m_isMeleeWeapon && WeaponObject.IsMagazineEmpty(weapon) && !this.firstEquipConfig.playWhenMagazineIsEmpty {
    return false;
  };

  if !this.firstEquipConfig.playInCombatMode && this.m_inCombat { return false; }
  if !this.firstEquipConfig.playInStealthMode && this.m_inCrouch { return false; }
  if VehicleComponent.IsMountedToVehicle(this.GetGame(), this)  { return false; }

  let isSprinting: Bool = Equals(PlayerPuppet.GetCurrentLocomotionState(this), gamePSMLocomotionStates.Sprint);
  if !this.firstEquipConfig.playWhileSprinting && isSprinting { return false; }

  if requestedByHotkey {
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
    if !IsDefined(this.firstEquipCooldowns) {
      this.firstEquipCooldowns = new inkIntHashMap();
    };

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

    if probability <= 0 { return false; }
    if probability >= 100 { return true; }

    return random < probability;
  };
}

@addMethod(PlayerPuppet)
public func ShouldRunIdleBreakEQ() -> Bool {
  if !IsDefined(this.firstEquipConfig) {
    return false;
  };

  if this.m_inCombat { return false; }
  if VehicleComponent.IsMountedToVehicle(this.GetGame(), this)  { return false; }

  let probability: Int32 = this.firstEquipConfig.animationProbabilityIdleBreak;
  let random: Int32 = RandRange(0, 100);

  if probability <= 0 { return false; }
  if probability >= 100 { return true; }

  return random < probability;
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
public func GetNextSlotIndex(current: Int32) -> Int32 {
  switch current {
    case 0: return 1;
    case 1: return 2;
    case 2: return 3;
    default: return 0;
  };
}

// Cycle slots backwards
public func GetPreviousSlotIndex(current: Int32) -> Int32 {
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

public func EQ(str: String) -> Void {
}

@addField(UpperBodyEventsTransition)
public let switchInputActive: Bool;

@wrapMethod(UpperBodyEventsTransition)
protected final func UpdateSwitchItem(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  this.switchInputActive = true;
  let result: Bool = wrappedMethod(timeDelta, stateContext, scriptInterface);
  this.switchInputActive = false;
  return result;
}

@wrapMethod(DefaultTransition)
protected final const func CheckEquipmentStateMachineState(const stateContext: ref<StateContext>, SMSide: EEquipmentSide, compareToState: EEquipmentState) -> Bool {
  let result: Bool = wrappedMethod(stateContext, SMSide, compareToState);
  let upperBody: ref<UpperBodyEventsTransition> = this as UpperBodyEventsTransition;
  if result || !IsDefined(upperBody) {
    return result;
  };
  if !upperBody.switchInputActive || NotEquals(SMSide, EEquipmentSide.Right) || NotEquals(compareToState, EEquipmentState.Equipped) {
    return false;
  };
  let identifier: StateMachineIdentifier;
  identifier.definitionName = n"Equipment";
  identifier.referenceName = n"RightHand";
  return stateContext.IsStateActiveWithIdentifier(identifier, n"firstEquip");
}

// --- SET SKIP ANIMATION FLAGS

@replaceMethod(EquipCycleDecisions)
protected final const func ToFirstEquip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let firstEquipResult: StateResultBool = stateContext.GetConditionBoolParameter(n"firstEquip");
  let preventFirstEquip: Bool = scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.ScenePreventFirstEquip)
    || scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedPreventFirstEquip);
  return firstEquipResult.valid && firstEquipResult.value && !preventFirstEquip && this.ToEquipped(stateContext, scriptInterface);
}

@wrapMethod(DefaultTransition)
protected final const func IsRightHandInEquippedState(const stateContext: ref<StateContext>) -> Bool {
  let result: Bool = wrappedMethod(stateContext);
  let weaponReadiness: ref<WeaponReadyListenerTransition> = this as WeaponReadyListenerTransition;
  if result || !IsDefined(weaponReadiness) {
    return result;
  };
  let identifier: StateMachineIdentifier;
  identifier.definitionName = n"Equipment";
  identifier.referenceName = n"RightHand";
  if stateContext.IsStateActiveWithIdentifier(identifier, n"firstEquip") {
    return true;
  };
  identifier.referenceName = n"LeftHand";
  return stateContext.IsStateActiveWithIdentifier(identifier, n"firstEquip");
}

@replaceMethod(FirstEquipEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let broadcaster: ref<StimBroadcasterComponent>;
  let weapon: ref<WeaponObject>;
  if this.IsRightHandLogic(this.stateMachineInstanceData) || this.IsLeftHandLogic(this.stateMachineInstanceData) {
    weapon = this.GetSlotAttachedItemObject(scriptInterface, this.stateMachineInstanceData) as WeaponObject;
    if IsDefined(weapon) && !WeaponObject.IsFists(weapon.GetItemID()) {
      broadcaster = scriptInterface.executionOwner.GetStimBroadcasterComponent();
      if IsDefined(broadcaster) {
        broadcaster.TriggerSingleBroadcast(scriptInterface.executionOwner, gamedataStimType.WeaponDisplayed);
      };
      stateContext.SetPermanentBoolParameter(n"weaponDisplayedStimuli", true, true);
    };
  };
}

@replaceMethod(FirstEquipEvents)
protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let mappedInstanceData: InstanceDataMappedToReferenceName = this.GetMappedInstanceData(this.stateMachineInstanceData.referenceName);
  let itemObject: wref<WeaponObject> = scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, TDBID.Create(mappedInstanceData.attachmentSlot)) as WeaponObject;
  if IsDefined(itemObject) {
    this.CreateAndSendFirstEquipEndRequest(scriptInterface, ItemID.GetTDBID(itemObject.GetItemID()));
  };
  scriptInterface.PushAnimationEvent(n"FirstEquipEnd");
  stateContext.SetConditionBoolParameter(n"firstEquip", false, true);
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

// Cool exit
@wrapMethod(CoolExitingEvents)
protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
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
  let hasWeaponEquipped: Bool;
  if IsDefined(playerPuppet) && !carrying {
    hasWeaponEquipped = playerPuppet.HasAnyWeaponEquippedEQ();
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
  if IsDefined(playerPuppet) && IsDefined(evt.hotspot) {
    className = evt.hotspot.GetClassName();
    if Equals(className, n"AccessPoint") || Equals(className, n"Computer") || Equals(className, n"Stillage") || Equals(className, n"WeakFence") {
      hasWeaponEquipped = playerPuppet.HasAnyWeaponEquippedEQ();
      playerPuppet.SetSkipFirstEquipEQ(hasWeaponEquipped);
    };
  };
  wrappedMethod(evt);
}

// Takedown
@wrapMethod(gamestateMachineComponent)
protected cb func OnStartTakedownEvent(startTakedownEvent: ref<StartTakedownEvent>) -> Bool {
  wrappedMethod(startTakedownEvent);
  let playerPuppet: ref<PlayerPuppet> = this.GetEntity() as PlayerPuppet;
  if IsDefined(playerPuppet) {
    playerPuppet.SetSkipFirstEquipEQ(true);
  };
}


// --- WEAPON EQUIP LOGIC

@wrapMethod(EquipmentSystemPlayerData)
public final func OnRestored() -> Void {
  let player: ref<PlayerPuppet> = this.m_owner as PlayerPuppet;
  if IsDefined(player) {
    player.CancelFirstEquipRequestEQ();
  };
  this.firstEquipOperation = null;
  wrappedMethod();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnDrawItemRequest(request: ref<DrawItemRequest>) -> Void {
  let previousOperation: ref<FirstEquipOperation> = this.firstEquipOperation;
  let operation: ref<FirstEquipOperation> = request.firstEquipOperation;
  let player: ref<PlayerPuppet> = this.m_owner as PlayerPuppet;
  if IsDefined(operation) {
    if IsDefined(player) && player.IsFirstEquipRequestActiveEQ(operation) && !operation.hotkeyDispatched
      && request.itemID == operation.requestedItem {
      operation.hotkeyDispatched = true;
    } else {
      operation.hotkeyCanceled = true;
    };
  } else {
    operation = new FirstEquipOperation();
  };
  this.firstEquipOperation = operation;
  wrappedMethod(request);
  if IsDefined(player) && player.firstEquipRequest == operation
    && (operation.hotkeyCanceled || !operation.hotkeyRequestsCreated) {
    player.CancelFirstEquipRequestEQ();
  };
  this.firstEquipOperation = previousOperation;
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipmentSystemWeaponManipulationRequest(request: ref<EquipmentSystemWeaponManipulationRequest>) -> Void {
  let previousOperation: ref<FirstEquipOperation> = this.firstEquipOperation;
  if !IsDefined(previousOperation) {
    this.firstEquipOperation = new FirstEquipOperation();
  };
  wrappedMethod(request);
  this.firstEquipOperation = previousOperation;
}

@wrapMethod(EquipmentSystemPlayerData)
private final func HandleEquipWeapon(itemID: ItemID, out slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool, out isLeftWeapon: Bool) -> Bool {
  let previousOperation: ref<FirstEquipOperation> = this.firstEquipOperation;
  if !IsDefined(previousOperation) {
    this.firstEquipOperation = new FirstEquipOperation();
  };
  let result: Bool = wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon, isLeftWeapon);
  this.firstEquipOperation = previousOperation;
  return result;
}

@wrapMethod(EquipmentSystemPlayerData)
public final func RefreshCurrentItems(swappedSlotIndex: Int32) -> Void {
  let previousOperation: ref<FirstEquipOperation> = this.firstEquipOperation;
  if !IsDefined(previousOperation) {
    this.firstEquipOperation = new FirstEquipOperation();
  };
  wrappedMethod(swappedSlotIndex);
  this.firstEquipOperation = previousOperation;
}

@replaceMethod(EquipmentSystemPlayerData)
private final func RequestEquipmentStateMachine(reqType: EquipmentManipulationRequestType, reqSlot: EquipmentManipulationRequestSlot, equipAnim: gameEquipAnimationType, referenceName: CName, requestName: CName, tempEquipOverWeapon: Bool, dualWieldLoadoutEdit: Bool) -> Void {
  let instanceData: StateMachineInstanceData;
  let operation: ref<FirstEquipOperation> = this.firstEquipOperation;
  let expectedItem: ItemID;
  let player: ref<PlayerPuppet> = this.m_owner as PlayerPuppet;
  let weaRequest: ref<EquipmentManipulationRequest> = new EquipmentManipulationRequest();
  let psmRequest: ref<PSMPostponedParameterScriptable> = new PSMPostponedParameterScriptable();
  let psmAdd: ref<PSMAddOnDemandStateMachine> = new PSMAddOnDemandStateMachine();
  let equipmentInitData: ref<EquipmentInitData> = new EquipmentInitData();
  if (this.m_owner as PlayerPuppet).GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody) != 5 {
    weaRequest.requestType = reqType;
    weaRequest.requestSlot = reqSlot;
    weaRequest.equipAnim = equipAnim;
    weaRequest.tempEquipOverWeapon = tempEquipOverWeapon;
    weaRequest.dualWieldLoadoutEdit = dualWieldLoadoutEdit;
    if !IsDefined(operation) {
      operation = new FirstEquipOperation();
    };
    if !operation.hotkeyRequested && IsDefined(player) && IsDefined(player.firstEquipRequest)
      && player.firstEquipRequest.hotkeyDispatched {
      player.CancelFirstEquipRequestEQ();
    };
    if Equals(reqType, EquipmentManipulationRequestType.DualEquip) || operation.hotkeyRequested {
      weaRequest.firstEquipOperation = operation;
    };
    if IsDefined(player) && player.IsFirstEquipRequestActiveEQ(operation)
      && this.GetSlotActiveItem(EquipmentManipulationRequestSlot.Right) == operation.requestedItem
      && (Equals(reqType, EquipmentManipulationRequestType.Equip) || Equals(reqType, EquipmentManipulationRequestType.DualEquip)) {
      expectedItem = this.GetSlotActiveItem(Equals(referenceName, n"RightHand") ? EquipmentManipulationRequestSlot.Right : EquipmentManipulationRequestSlot.Left);
      if ItemID.IsValid(expectedItem) && this.IsItemOfCategory(expectedItem, gamedataItemCategory.Weapon) {
        weaRequest.firstEquipItem = expectedItem;
        operation.hotkeyRequestsCreated = true;
      };
    };
    psmRequest.value = weaRequest;
    psmRequest.id = requestName;
    psmRequest.aspect = gamestateMachineParameterAspect.Permanent;
    this.m_owner.QueueEvent(psmRequest);
  };
  psmAdd.stateMachineName = n"Equipment";
  instanceData.referenceName = referenceName;
  psmAdd.instanceData = instanceData;
  equipmentInitData.eqManipulationVarName = requestName;
  psmAdd.instanceData.initData = equipmentInitData;
  psmAdd.owner = this.m_owner;
  this.m_owner.QueueEvent(psmAdd);
}

// Controls if firstEquip should be played, allows firstEquip in combat if PlayInCombatMode option enabled
@replaceMethod(EquipmentBaseTransition)
protected final const func HandleWeaponEquip(scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>, stateMachineInstanceData: StateMachineInstanceData, item: ItemID, isLeftWeapon: Bool) -> Void {
  let animFeatureMeleeData: ref<AnimFeature_MeleeData>;
  let autoRefillEvent: ref<SetAmmoCountEvent>;
  let autoRefillRatio: Float;
  let canPlayInCombat: Bool;
  let equipAnimationRequestsFirstEquip: Bool;
  let forceFirstEquip: Bool;
  let hasPlayedFirstEquip: Bool;
  let hotkeyRequestsFirstEquip: Bool;
  let leftHandAnimFeature: ref<AnimFeature_LeftHandAnimation>;
  let magazineCapacity: Uint32;
  let otherItem: wref<WeaponObject>;
  let preventFirstEquip: Bool;
  let repeatFirstEquip: Bool;
  let skipFirstEquip: Bool;
  let statsEvent: ref<UpdateWeaponStatsEvent>;
  let weaponEquipEvent: ref<WeaponEquipEvent>;
  let animFeature: ref<AnimFeature_EquipUnequipItem> = new AnimFeature_EquipUnequipItem();
  let animFeatureName: CName = n"equipUnequipItem";
  let weaponEquipAnimFeature: ref<AnimFeature_EquipType> = new AnimFeature_EquipType();
  let transactionSystem: ref<TransactionSystem> = scriptInterface.GetTransactionSystem();
  let statSystem: ref<StatsSystem> = scriptInterface.GetStatsSystem();
  let mappedInstanceData: InstanceDataMappedToReferenceName = this.GetMappedInstanceData(stateMachineInstanceData.referenceName);
  let firstEqSystem: ref<FirstEquipSystem> = FirstEquipSystem.GetInstance(scriptInterface.owner);
  let firstEquip: Bool = false;
  let processedRequest: ref<EquipmentManipulationRequest> = this.GetProcessedEquipmentManipulationRequest(stateMachineInstanceData, stateContext);
  let operation: ref<FirstEquipOperation> = processedRequest.firstEquipOperation;
  let hotkeyPending: Bool = !processedRequest.firstEquipHotkeyConsumed;
  let itemObject: wref<WeaponObject> = transactionSystem.GetItemInSlot(scriptInterface.executionOwner, TDBID.Create(mappedInstanceData.attachmentSlot)) as WeaponObject;
  processedRequest.firstEquipHotkeyConsumed = true;
  if IsDefined(operation) && ItemID.IsValid(processedRequest.firstEquipItem) {
    if isLeftWeapon {
      hotkeyPending = hotkeyPending && !operation.leftHotkeyConsumed;
      operation.leftHotkeyConsumed = true;
    } else {
      hotkeyPending = hotkeyPending && !operation.rightHotkeyConsumed;
      operation.rightHotkeyConsumed = true;
    };
  };
  if !IsDefined(itemObject) {
    return;
  };
  let weaponItemID: ItemID = itemObject.GetItemID();
  let weaponTdbId: TweakDBID = ItemID.GetTDBID(weaponItemID);
  let isInCombat: Bool = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == EnumInt(gamePSMCombat.InCombat);
  let playerPuppet: ref<PlayerPuppet> = scriptInterface.owner as PlayerPuppet;
  stateContext.SetConditionBoolParameter(n"firstEquip", false, true);
  if TweakDBInterface.GetBool(t"player.weapon.enableWeaponBlur", false) {
    this.GetBlurParametersFromWeapon(scriptInterface);
  };

  preventFirstEquip = scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.ScenePreventFirstEquip) || scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedPreventFirstEquip);
  equipAnimationRequestsFirstEquip = Equals(processedRequest.equipAnim, gameEquipAnimationType.FirstEquip);
  forceFirstEquip = this.GetStaticBoolParameterDefault("forceFirstEquip", false);
  hasPlayedFirstEquip = IsDefined(firstEqSystem) && firstEqSystem.HasPlayedFirstEquip(weaponTdbId);
  canPlayInCombat = !isInCombat || IsDefined(playerPuppet) && IsDefined(playerPuppet.firstEquipConfig) && playerPuppet.firstEquipConfig.playInCombatMode;
  hotkeyRequestsFirstEquip = hotkeyPending && IsDefined(playerPuppet)
    && playerPuppet.IsFirstEquipRequestActiveEQ(operation)
    && ItemID.IsValid(processedRequest.firstEquipItem) && processedRequest.firstEquipItem == weaponItemID;

  if IsDefined(playerPuppet) && IsDefined(firstEqSystem) && canPlayInCombat && !preventFirstEquip
    && (this.IsRightHandLogic(stateMachineInstanceData) || Equals(processedRequest.requestType, EquipmentManipulationRequestType.DualEquip)) {
    skipFirstEquip = IsDefined(operation) && operation.skip;
    if !skipFirstEquip && playerPuppet.ShouldSkipFirstEquipEQ() {
      playerPuppet.SetSkipFirstEquipEQ(false);
      if IsDefined(operation) {
        operation.skip = true;
      };
      skipFirstEquip = true;
    };
    if !skipFirstEquip {
      repeatFirstEquip = hasPlayedFirstEquip && IsDefined(playerPuppet.firstEquipConfig) && playerPuppet.ShouldRunFirstEquipEQ(itemObject, hotkeyRequestsFirstEquip);
      if equipAnimationRequestsFirstEquip || forceFirstEquip || !hasPlayedFirstEquip || repeatFirstEquip {
        weaponEquipAnimFeature.firstEquip = true;
        stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
        firstEquip = true;
      };
    };
  };
  scriptInterface.localBlackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsWeaponFirstEquip, firstEquip);
  if this.IsLeftHandLogic(stateMachineInstanceData) {
    animFeatureName = n"leftEquipUnequipItem";
    otherItem = GameObject.GetRightActiveWeapon(scriptInterface.executionOwner);
  } else {
    if this.IsRightHandLogic(stateMachineInstanceData) {
      animFeatureName = n"rightEquipUnequipItem";
      otherItem = GameObject.GetLeftActiveWeapon(scriptInterface.executionOwner);
    };
  };
  animFeature.stateTransitionDuration = statSystem.GetStatValue(Cast<StatsObjectID>(itemObject.GetEntityID()), gamedataStatType.EquipDuration);
  animFeature.itemState = 1;
  animFeature.itemType = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(item)).ItemType().AnimFeatureIndex();
  if !isLeftWeapon {
    this.BlockAimingForTime(stateContext, scriptInterface, animFeature.stateTransitionDuration + 0.10);
  };
  weaponEquipAnimFeature.equipDuration = this.GetEquipDuration(scriptInterface, stateContext, stateMachineInstanceData);
  weaponEquipAnimFeature.unequipDuration = this.GetUnequipDuration(scriptInterface, stateContext, stateMachineInstanceData);
  weaponEquipAnimFeature.dualWield = Equals(processedRequest.requestType, EquipmentManipulationRequestType.DualEquip) || IsDefined(transactionSystem.GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponRight")) && IsDefined(transactionSystem.GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponLeft"));
  scriptInterface.SetAnimationParameterFeature(mappedInstanceData.itemHandlingFeatureName, animFeature, scriptInterface.executionOwner);
  scriptInterface.SetAnimationParameterFeature(animFeatureName, animFeature, itemObject);
  if IsDefined(otherItem) {
    scriptInterface.SetAnimationParameterFeature(animFeatureName, animFeature, otherItem);
  };
  weaponEquipEvent = new WeaponEquipEvent();
  weaponEquipEvent.animFeature = weaponEquipAnimFeature;
  weaponEquipEvent.item = itemObject;
  weaponEquipEvent.isLeftWeapon = this.IsLeftHandLogic(stateMachineInstanceData);
  scriptInterface.executionOwner.QueueEvent(weaponEquipEvent);
  if weaponEquipAnimFeature.dualWield {
    leftHandAnimFeature = new AnimFeature_LeftHandAnimation();
    leftHandAnimFeature.lockLeftHandAnimation = true;
    scriptInterface.SetAnimationParameterFeature(n"LeftHandAnimation", leftHandAnimFeature, scriptInterface.executionOwner);
  };
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
    if this.IsRightHandLogic(stateMachineInstanceData) {
      stateContext.SetPermanentBoolParameter(n"WeaponInSafe", false, true);
    };
    stateContext.SetPermanentFloatParameter(this.GetTurnOffPublicSafeTimeStamp(stateMachineInstanceData), EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.owner.GetGame())), true);
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

@wrapMethod(EquipmentBaseTransition)
protected final const func HandleWeaponUnequip(scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>, stateMachineInstanceData: StateMachineInstanceData, item: ItemID, isLeftWeapon: Bool) -> Void {
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(player) {
    player.SetSafeStateForced(false);
  };
  wrappedMethod(scriptInterface, stateContext, stateMachineInstanceData, item, isLeftWeapon);
}


// --- TRACK USED SLOTS

@wrapMethod(DefaultTransition)
protected final const func SendEquipmentSystemWeaponManipulationRequest(const scriptInterface: ref<StateGameScriptInterface>, requestType: EquipmentManipulationAction, opt equipAnimType: gameEquipAnimationType) -> Void {
  let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(scriptInterface.executionOwner.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  if !IsDefined(blackboard) {
    wrappedMethod(scriptInterface, requestType, equipAnimType);
    return;
  };
  let lastUsedSlot: Int32 = blackboard.GetInt(GetAllBlackboardDefs().UI_System.FirstEqLastUsedSlot);
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
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(player) && !player.IsSafeStateForcedEQ() {
    player.ClearSafeStateReleaseRequestEQ(this.IsLeftWeaponLogic());
  };
  if !this.IsRightWeaponLogic() {
    return;
  };

  this.savedIdleTimestamp = EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.GetGame()));
  this.safeAnimFeature = new AnimFeature_SafeAction();
  this.isHoldActive = false;
  this.readyStateRequested = false;
}

@addMethod(ReadyEvents)
protected final func ResetReadyAnimationStateEQ(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !this.IsRightWeaponLogic() {
    return;
  };
  let weapon: ref<WeaponObject>;
  stateContext.SetPermanentBoolParameter(n"TriggerHeld", false, true);
  if IsDefined(this.safeAnimFeature) {
    this.safeAnimFeature.triggerHeld = false;
    scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeature);
    weapon = this.GetWeaponObject(scriptInterface);
    if IsDefined(weapon) {
      scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeature, weapon);
    };
  };
  this.isHoldActive = false;
  this.readyStateRequested = false;
}

@wrapMethod(ReadyEvents)
private final func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.ResetReadyAnimationStateEQ(stateContext, scriptInterface);
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(ReadyEvents)
protected func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  this.ResetReadyAnimationStateEQ(stateContext, scriptInterface);
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(ReadyEvents)
protected final func OnTick(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !this.IsRightWeaponLogic() {
    wrappedMethod(timeDelta, stateContext, scriptInterface);
    return;
  };
  let gameInstance: GameInstance = scriptInterface.GetGame();
  let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(gameInstance));
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;

  if IsDefined(player) && IsDefined(player.firstEquipConfig) {
    this.m_timeStamp = currentTime;
  };

  wrappedMethod(timeDelta, stateContext, scriptInterface);
  this.UpdateReadyHotkeysAndIdleEQ(timeDelta, currentTime, stateContext, scriptInterface, player);
}

@addMethod(ReadyEvents)
protected final func UpdateReadyHotkeysAndIdleEQ(timeDelta: Float, currentTime: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, player: ref<PlayerPuppet>) -> Void {
  let behindCover: Bool;
  let buttonReleased: Bool;
  let combatState: Int32;
  let hold: Bool;
  let idleCheckPeriod: Float;
  let idleEligible: Bool;
  let pressed: Bool;
  let released: Bool;
  let uiSystemBB: ref<IBlackboard>;
  let weapon: ref<WeaponObject>;
  let weaponRecord: ref<WeaponItem_Record>;

  if !DefaultTransition.HasRightWeaponEquipped(scriptInterface) {
    this.savedIdleTimestamp = currentTime;
    return;
  };

  uiSystemBB = GameInstance.GetBlackboardSystem(scriptInterface.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  if !IsDefined(uiSystemBB) {
    this.savedIdleTimestamp = currentTime;
    return;
  };

  pressed = uiSystemBB.GetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyPressed);
  released = uiSystemBB.GetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased);
  hold = uiSystemBB.GetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyHold);

  if this.readyStateRequested {
    this.readyStateRequested = false;
    scriptInterface.SetAnimationParameterFloat(n"safe", 0.00);
  };

  if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.IDLE) && pressed {
    this.firstEqHotkeyState = FirstEquipHotkeyState.PREPARING;
    uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyPressed, false, false);
  } else {
    if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.PREPARING) {
      if hold {
        this.firstEqHotkeyState = FirstEquipHotkeyState.HOLD_STARTED;
        uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyHold, false, false);
      } else {
        if released {
          this.firstEqHotkeyState = FirstEquipHotkeyState.TAPPED;
          uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased, false, false);
        };
      };
    };
  };

  buttonReleased = released || scriptInterface.GetActionValue(AlwaysFirstEquipAction()) < 0.50;
  if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.HOLD_STARTED) && buttonReleased {
    this.firstEqHotkeyState = FirstEquipHotkeyState.HOLD_ENDED;
    uiSystemBB.SetBool(GetAllBlackboardDefs().UI_System.FirstEqHotkeyReleased, false, false);
  };

  if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.PREPARING) {
    this.readyStateRequested = true;
  };

  if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.TAPPED) {
    if IsDefined(player) && IsDefined(player.firstEquipConfig) && player.firstEquipConfig.bindToHotkeyIdleBreak {
      this.savedIdleTimestamp = currentTime;
      scriptInterface.PushAnimationEvent(n"IdleBreak");
    };
    this.firstEqHotkeyState = FirstEquipHotkeyState.IDLE;
  } else {
    if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.HOLD_STARTED) && !this.isHoldActive {
      scriptInterface.SetAnimationParameterFloat(n"safe", 1.00);
      scriptInterface.PushAnimationEvent(n"SafeAction");
      stateContext.SetPermanentBoolParameter(n"TriggerHeld", true, true);
      if IsDefined(this.safeAnimFeature) {
        this.safeAnimFeature.triggerHeld = true;
      };
      this.isHoldActive = true;
    };

    if Equals(this.firstEqHotkeyState, FirstEquipHotkeyState.HOLD_ENDED) {
      this.ResetReadyAnimationStateEQ(stateContext, scriptInterface);
      this.firstEqHotkeyState = FirstEquipHotkeyState.IDLE;
      this.readyStateRequested = true;
    };
  };

  weapon = this.GetWeaponObject(scriptInterface);
  if IsDefined(this.safeAnimFeature) && IsDefined(weapon) {
    weaponRecord = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(weapon.GetItemID()));
    if IsDefined(weaponRecord) {
      this.safeAnimFeature.safeActionDuration = TDB.GetFloat(weaponRecord.GetID() + t".safeActionDuration");
    };
    scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeature);
    scriptInterface.SetAnimationParameterFeature(n"SafeAction", this.safeAnimFeature, weapon);
  };

  if !IsDefined(player) || !IsDefined(player.firstEquipConfig) {
    this.savedIdleTimestamp = currentTime;
    return;
  };

  idleCheckPeriod = player.firstEquipConfig.animationCheckPeriodIdleBreak;
  if idleCheckPeriod <= 0.00 {
    this.savedIdleTimestamp = currentTime;
    return;
  };

  combatState = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat);
  behindCover = NotEquals(GameInstance.GetSpatialQueriesSystem(scriptInterface.GetGame()).GetPlayerObstacleSystem().GetCoverDirection(scriptInterface.executionOwner), gamePlayerCoverDirection.None);
  idleEligible = combatState != EnumInt(gamePSMCombat.InCombat)
    && !player.IsInCombat()
    && !behindCover
    && !VehicleComponent.IsMountedToVehicle(player.GetGame(), player)
    && WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10
    && stateContext.IsStateActive(n"Locomotion", n"stand")
    && !this.isHoldActive;

  if !idleEligible {
    this.savedIdleTimestamp = currentTime;
    return;
  };

  if currentTime - this.savedIdleTimestamp > idleCheckPeriod {
    this.savedIdleTimestamp = currentTime;
    if player.ShouldRunIdleBreakEQ() {
      scriptInterface.SetAnimationParameterFloat(n"safe", 0.00);
      scriptInterface.PushAnimationEvent(n"IdleBreak");
    };
  };
}

@wrapMethod(ZoomLevelAimEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(player) && this.isAmingWithWeapon && player.IsSafeStateForcedEQ() {
    scriptInterface.SetAnimationParameterFloat(n"safe", 0.0);
    player.SetSafeStateForced(false);
  };
}

@wrapMethod(ShootEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(player) && player.IsSafeStateForcedEQ() {
    scriptInterface.SetAnimationParameterFloat(n"safe", 0.0);
    player.SetSafeStateForced(false);
  };
}
