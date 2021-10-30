class FirstEquipConfig {
  // Replace true with false if you want to disable slot tracking behavior
  public static func TrackLastUsedSlot() -> Bool = true
  // If TrackLastUsedSlot disabled then hotkey will use this one for equip request
  // Use 1, 2 or 3
  public static func SlotNumber() -> Int32 = 1
}

@addField(UI_SystemDef)
public let IsFirstEquipPressed_eq: BlackboardID_Bool;

@addField(UI_SystemDef)
public let LastUsedSlot_eq: BlackboardID_Int;

@addField(HotkeyItemController)
public let m_playerPuppet_eq: ref<PlayerPuppet>;

public class FirstEquipGlobalInputListener {
    private let m_player: ref<PlayerPuppet>;

    public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
      this.m_player = player;
    }

    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
      let drawItemRequest: ref<DrawItemRequest>;
      let sheatheRequest: ref<EquipmentSystemWeaponManipulationRequest>;
      let equipmentSystem: ref<EquipmentSystem>;
      let slotForHotkey: Int32;

      if IsDefined(this.m_player) && Equals(ListenerAction.GetName(action), n"FirstTimeEquip") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
        if this.m_player.HasRangedWeaponEquipped_eq() {
          sheatheRequest = new EquipmentSystemWeaponManipulationRequest();
          equipmentSystem = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
          sheatheRequest.requestType = EquipmentManipulationAction.UnequipWeapon;
          sheatheRequest.owner = this.m_player;
          equipmentSystem.QueueRequest(sheatheRequest);
        } else {
          if FirstEquipConfig.TrackLastUsedSlot() {
            slotForHotkey = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).GetInt(GetAllBlackboardDefs().UI_System.LastUsedSlot_eq);
          } else {
            slotForHotkey = FirstEquipConfig.SlotNumber() - 1;
          };
          drawItemRequest = new DrawItemRequest();
          drawItemRequest.itemID = EquipmentSystem.GetData(this.m_player).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, slotForHotkey);
          drawItemRequest.owner = this.m_player;
          GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsFirstEquipPressed_eq, true, false);
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

@replaceMethod(FirstEquipSystem)
public final const func HasPlayedFirstEquip(weaponID: TweakDBID) -> Bool {
  let isHotkeyPressed: Bool;
  let i: Int32 = 0;

  isHotkeyPressed = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.IsFirstEquipPressed_eq);

  if (isHotkeyPressed) {
    GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsFirstEquipPressed_eq, false, false);
    return false;
  };

  while i < ArraySize(this.m_equipDataArray) {
    if this.m_equipDataArray[i].weaponID == weaponID {
      return this.m_equipDataArray[i].hasPlayedFirstEquip;
    };
    i += 1;
  };
  return false;
}

// Track last used slot
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

public static func GetNextSlotIndex(current: Int32) -> Int32 {
  switch current {
    case 0: return 1;
    case 1: return 2;
    case 2: return 3;
    default: return 0;
  };
}

public static func GetPreviousSlotIndex(current: Int32) -> Int32 {
  switch current {
    case 3: return 2;
    case 2: return 1;
    case 1: return 0;
    default: return 3;
  };
}