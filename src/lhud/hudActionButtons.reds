//////////////////////////////////////////////////////
// Show action buttons panel when weapon unsheathed //
//////////////////////////////////////////////////////

@addMethod(PlayerPuppet)
public func HasAnyWeaponEquippedButtons() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if IsDefined(weapon) {
    if transactionSystem.HasTag(this, WeaponObject.GetMeleeWeaponTag(), weapon.GetItemID()) 
      || transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weapon.GetItemID()) {
        return true;
    };
  };
  return false;
}

@addField(HotkeysWidgetController)
public let m_weaponBlackboard: wref<IBlackboard>;

@addField(HotkeysWidgetController)
public let m_weaponBlackboardCallback: Uint32;

@addField(HotkeysWidgetController)
public let m_playerPuppet: ref<PlayerPuppet>;

@addMethod(HotkeysWidgetController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  let playerPuppet: ref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;

  if IsDefined(playerPuppet) {
    this.GetRootWidget().SetVisible(playerPuppet.HasAnyWeaponEquippedButtons());
  };
}

@replaceMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
  this.m_player = this.GetOwnerEntity() as PlayerPuppet;
  this.m_root = this.GetRootWidget() as inkCompoundWidget;
  if !IsDefined(this.m_player) {
    return false;
  };
  this.m_phone = this.SpawnFromLocal(inkWidgetRef.Get(this.m_utilsList), n"DPAD_DOWN");
  this.m_car = this.SpawnFromLocal(inkWidgetRef.Get(this.m_utilsList), n"DPAD_RIGHT");
  this.m_consumables = this.SpawnFromLocal(inkWidgetRef.Get(this.m_hotkeysList), n"DPAD_UP");
  this.m_gadgets = this.SpawnFromLocal(inkWidgetRef.Get(this.m_hotkeysList), n"RB");
  this.m_fact1ListenerId = GameInstance.GetQuestsSystem(this.m_player.GetGame()).RegisterListener(n"dpad_hints_visibility_enabled", this, n"OnConsumableTutorial");
  this.m_fact2ListenerId = GameInstance.GetQuestsSystem(this.m_player.GetGame()).RegisterListener(n"q000_started", this, n"OnGameStarted");
  this.ResolveVisibility();
  this.m_gameInstance = this.GetPlayerControlledObject().GetGame();
  this.m_weaponBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);
  this.m_weaponBlackboardCallback = this.m_weaponBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
}

@replaceMethod(HotkeysWidgetController)
protected cb func OnUninitialize() -> Bool {
  GameInstance.GetQuestsSystem(this.m_gameInstance).UnregisterListener(n"dpad_hints_visibility_enabled", this.m_fact1ListenerId);
  GameInstance.GetQuestsSystem(this.m_gameInstance).UnregisterListener(n"q000_started", this.m_fact2ListenerId);
  this.m_weaponBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponBlackboardCallback);
}
