// Always First Equip by hotkey

class FirstEquipConfig {
  public static func SlotNumber() -> Int32 = 1 // Use 1, 2 or 3
}

@addField(UI_SystemDef)
public let IsFirstEquipPressed_eq: BlackboardID_Bool;

@addField(HotkeyItemController)
public let m_playerPuppet_eq: ref<PlayerPuppet>;

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

@replaceMethod(HotkeyItemController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.InitializeHotkeyItem();
  this.m_playerPuppet_eq = playerPuppet as PlayerPuppet;

  if IsDefined(this.m_playerPuppet_eq) {
    this.m_playerPuppet_eq.RegisterInputListener(this, n"FirstTimeEquip");
  };
}

@addMethod(HotkeyItemController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerPuppet_eq.UnregisterInputListener(this);
}

@addMethod(HotkeyItemController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let drawItemRequest: ref<DrawItemRequest>;
  let sheatheRequest: ref<EquipmentSystemWeaponManipulationRequest>;
  let equipmentSystem: ref<EquipmentSystem>;

  if IsDefined(this.m_playerPuppet_eq) && Equals(ListenerAction.GetName(action), n"FirstTimeEquip") {
    if this.m_playerPuppet_eq.HasRangedWeaponEquipped_eq() {
      sheatheRequest = new EquipmentSystemWeaponManipulationRequest();
      equipmentSystem = GameInstance.GetScriptableSystemsContainer(this.m_playerPuppet_eq.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
      sheatheRequest.requestType = EquipmentManipulationAction.UnequipWeapon;
      sheatheRequest.owner = this.m_playerPuppet_eq;
      equipmentSystem.QueueRequest(sheatheRequest);
    } else {
      drawItemRequest = new DrawItemRequest();
      drawItemRequest.itemID = EquipmentSystem.GetData(this.m_playerPuppet_eq).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, FirstEquipConfig.SlotNumber() - 1);
      drawItemRequest.owner = this.m_playerPuppet_eq;
      drawItemRequest.equipAnimationType = gameEquipAnimationType.FirstEquip;
      GameInstance.GetBlackboardSystem(this.m_playerPuppet_eq.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsFirstEquipPressed_eq, true, false);
      GameInstance.GetScriptableSystemsContainer(this.m_playerPuppet_eq.GetGame()).Get(n"EquipmentSystem").QueueRequest(drawItemRequest);
    }
  };
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
