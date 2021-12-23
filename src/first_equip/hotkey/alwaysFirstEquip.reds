// --- CONFIG SECTION STARTS HERE

// -- Controls weapon firsEquip animation which 
//    usually appears when you equip any weapon for a first time
class FirstEquipConfig {
  // Replace true with false if you want to disable slot tracking behavior
  public static func TrackLastUsedSlot() -> Bool = true
  // If TrackLastUsedSlot disabled then hotkey will use this one for equip request
  // Use 1, 2 or 3
  public static func SlotNumber() -> Int32 = 1
  // Replace false with true if you want see firstEquip animation while in combat mode
  public static func PlayInCombatMode() -> Bool = false
  // Replace false with true if you want see firstEquip animation while in stealth mode
  public static func PlayInStealthMode() -> Bool = false
  // Replace false with true if you want see firstEquip animation when weapon magazine is empty
  public static func PlayWhenMagazineIsEmpty() -> Bool = false
}

// -- Controls weapon IdleBreak animation which 
//    If enabled then IdleBreak will be played on hotkey press with unsheathed weapon
public class IdleBreakConfig {
  // Replace true with false if you want to disable this feature and restore default weapon idle behavior
  public static func IsFeatureEnabled() -> Bool = true
}

// --- CONFIG SECTION ENDS HERE, DO NOT EDIT ANYTHING BELOW

// -- Checks if firstEquip animation must be played depending on config 
@addMethod(PlayerPuppet)
public func ShouldRunFirstEquip_eq(weapon: wref<WeaponObject>) -> Bool {
  if WeaponObject.IsMagazineEmpty(weapon) && !FirstEquipConfig.PlayWhenMagazineIsEmpty() {
    return false;
  };

  if !FirstEquipConfig.PlayInCombatMode() && this.m_inCombat { return false; }
  if !FirstEquipConfig.PlayInStealthMode() && this.m_inCrouch { return false; }

  return true;
}


// -- New fields

@addField(UI_SystemDef)
public let FirstEquipPressed_eq: BlackboardID_Bool;

@addField(UI_SystemDef)
public let IdleBreakRequested_eq: BlackboardID_Bool;

@addField(UI_SystemDef)
public let LastUsedSlot_eq: BlackboardID_Int;

@addField(HotkeyItemController)
public let playerPuppet_eq: ref<PlayerPuppet>;


// -- Hotkey stuff

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

      if IsDefined(this.m_player) && Equals(ListenerAction.GetName(action), n"FirstTimeEquip") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
        if this.m_player.HasRangedWeaponEquipped_eq() {  // If weapon equipped
          // Play IdleBreak if enabled, sheathe weapon otherwise
          if IdleBreakConfig.IsFeatureEnabled() {
            // Set flag that IdleBreak should be played
            GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IdleBreakRequested_eq, true, false);
          } else {
            // Unequip weapon request
            sheatheRequest = new EquipmentSystemWeaponManipulationRequest();
            equipmentSystem = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
            sheatheRequest.requestType = EquipmentManipulationAction.UnequipWeapon;
            sheatheRequest.owner = this.m_player;
            equipmentSystem.QueueRequest(sheatheRequest);
          };
        } else { // If no weapon equipped
          if FirstEquipConfig.TrackLastUsedSlot() {
            slotForHotkey = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.LastUsedSlot_eq);
          } else {
            slotForHotkey = FirstEquipConfig.SlotNumber() - 1;
          };
          drawItemRequest = new DrawItemRequest();
          drawItemRequest.itemID = EquipmentSystem.GetData(this.m_player).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, slotForHotkey);
          drawItemRequest.owner = this.m_player;
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEquipPressed_eq, true, false);
          GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"EquipmentSystem").QueueRequest(drawItemRequest);
        }
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


// -- Utils

// -- Checks if player has any ranged weapon equipped
@addMethod(PlayerPuppet)
public func HasRangedWeaponEquipped_eq() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if IsDefined(weapon) {
    if transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weapon.GetItemID()) {
      return true;
    };
  };
  return false;
}

// -- Replacements

// -- The mod logic based on this one, defines if firstEquip animation already played for particular weapon
@replaceMethod(FirstEquipSystem)
public final const func HasPlayedFirstEquip(weaponID: TweakDBID) -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let weapon: wref<WeaponObject> = transactionSystem.GetItemInSlot(player, t"AttachmentSlots.WeaponRight") as WeaponObject;
  let isHotkeyPressed: Bool = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.FirstEquipPressed_eq);
  let i: Int32 = 0;

  // Return true if firstEquip blocked
  if !player.ShouldRunFirstEquip_eq(weapon) {
    return true;
  }

  // Return false if hotkey pressed
  if (isHotkeyPressed) {
    GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.FirstEquipPressed_eq, false, false);
    return false;
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

// -- Track last used slot
@wrapMethod(DefaultTransition)
protected final const func SendEquipmentSystemWeaponManipulationRequest(const scriptInterface: ref<StateGameScriptInterface>, requestType: EquipmentManipulationAction, opt equipAnimType: gameEquipAnimationType) -> Void {
  let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(scriptInterface.executionOwner.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  let lastUsedSlot: Int32 = GameInstance.GetBlackboardSystem(scriptInterface.executionOwner.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.LastUsedSlot_eq);
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
  blackboard.SetInt(GetAllBlackboardDefs().UI_System.LastUsedSlot_eq, newLastUsedSlot, false);
  wrappedMethod(scriptInterface, requestType, equipAnimType);
}

// -- Cycle slots forward
public static func GetNextSlotIndex(current: Int32) -> Int32 {
  switch current {
    case 0: return 1;
    case 1: return 2;
    case 2: return 3;
    default: return 0;
  };
}

// -- Cycle slots backward
public static func GetPreviousSlotIndex(current: Int32) -> Int32 {
  switch current {
    case 3: return 2;
    case 2: return 1;
    case 1: return 0;
    default: return 3;
  };
}


// -- IdleBreak support

// -- Checks if hotkey pressed and IdleBreak must be triggered
@replaceMethod(ReadyEvents)
protected final func OnTick(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let animFeature: ref<AnimFeature_WeaponHandlingStats>;
  let ownerID: EntityID;
  let statsSystem: ref<StatsSystem>;
  let gameInstance: GameInstance = scriptInterface.GetGame();
  let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(gameInstance));
  let behindCover: Bool = NotEquals(GameInstance.GetSpatialQueriesSystem(gameInstance).GetPlayerObstacleSystem().GetCoverDirection(scriptInterface.executionOwner), IntEnum(0l));
  let hotkeyPressed: Bool = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.IdleBreakRequested_eq);
  if behindCover {
    this.m_timeStamp = currentTime;
    stateContext.SetPermanentFloatParameter(n"TurnOffPublicSafeTimeStamp", this.m_timeStamp, true);
  };

  if IdleBreakConfig.IsFeatureEnabled() {
    // reset flag and run IdleBreak
    if WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10 && stateContext.IsStateActive(n"Locomotion", n"stand") {
      if hotkeyPressed {
        GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IdleBreakRequested_eq, false, false);
        scriptInterface.PushAnimationEvent(n"IdleBreak");
      };
    };
  } else {
    // default logic
    if WeaponTransition.GetPlayerSpeed(scriptInterface) < 0.10 && stateContext.IsStateActive(n"Locomotion", n"stand") {
      if scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) != EnumInt(gamePSMCombat.InCombat) && !behindCover {
        if this.m_timeStamp + this.GetStaticFloatParameterDefault("timeBetweenIdleBreaks", 20.00) <= currentTime {
          scriptInterface.PushAnimationEvent(n"IdleBreak");
          this.m_timeStamp = currentTime;
        };
      };
    };
  }

  if this.IsHeavyWeaponEmpty(scriptInterface) && !stateContext.GetBoolParameter(n"requestHeavyWeaponUnequip", true) {
    stateContext.SetPermanentBoolParameter(n"requestHeavyWeaponUnequip", true, true);
  };
  statsSystem = GameInstance.GetStatsSystem(gameInstance);
  ownerID = scriptInterface.ownerEntityID;
  animFeature = new AnimFeature_WeaponHandlingStats();
  animFeature.weaponRecoil = statsSystem.GetStatValue(Cast(ownerID), gamedataStatType.RecoilAnimation);
  animFeature.weaponSpread = statsSystem.GetStatValue(Cast(ownerID), gamedataStatType.SpreadAnimation);
  scriptInterface.SetAnimationParameterFeature(n"WeaponHandlingData", animFeature, scriptInterface.executionOwner);
}

// -- Allows firstEquip in combat if PlayInCombatMode option enabled
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
  if TweakDBInterface.GetBool(t"player.weapon.enableWeaponBlur", false) {
    this.GetBlurParametersFromWeapon(scriptInterface);
  };
  if !isInCombat || FirstEquipConfig.PlayInCombatMode() {
    if Equals(this.GetProcessedEquipmentManipulationRequest(stateMachineInstanceData, stateContext).equipAnim, gameEquipAnimationType.FirstEquip) || this.GetStaticBoolParameterDefault("forceFirstEquip", false) || !firstEqSystem.HasPlayedFirstEquip(ItemID.GetTDBID(itemObject.GetItemID())) {
      weaponEquipAnimFeature.firstEquip = true;
      stateContext.SetConditionBoolParameter(n"firstEquip", true, true);
    };
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
