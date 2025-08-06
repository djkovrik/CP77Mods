module RevisedBackpack

@addField(UIInventoryItemsManager)
public let revisedBackpackSystem: wref<RevisedBackpackSystem>;

@wrapMethod(UIInventoryItemsManager)
public final func AttachPlayer(player: wref<PlayerPuppet>) -> Void {
  wrappedMethod(player);
  this.revisedBackpackSystem = RevisedBackpackSystem.GetInstance(player.GetGame());
}

@addMethod(UIInventoryItemsManager)
public final func IsCustomJunk(itemId: ItemID) -> Bool {
  return this.revisedBackpackSystem.IsAddedToJunk(itemId);
}

@wrapMethod(UIInventoryItem)
public final func IsJunk() -> Bool {
  let wrapped: Bool = wrappedMethod();
  let isCustomJunk: Bool = this.m_manager.IsCustomJunk(this.ID);
  return wrapped || isCustomJunk;
}

@wrapMethod(FullscreenVendorGameController)
private final func PopulatePlayerInventory() -> Void {
  wrappedMethod();

  if RevisedBackpackSystem.GetInstance(this.m_player.GetGame()).HasCustomJunk() {
    this.m_buttonHintsController.AddButtonHint(n"sell_junk", GetLocalizedText("UI-UserActions-SellJunk"));
  };
}

@addMethod(InventoryDataManagerV2)
public final func GetItemsWithExistingPrice(out items: array<wref<gameItemData>>) -> Void {
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let data: ref<gameItemData>;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  let price: Int32;
  while i < limit {
    data = unfilteredItems[i];
    price = RPGManager.CalculateSellPrice(this.m_Player.GetGame(), this.m_Player, data.GetID());
    if price > 0 {
      ArrayPush(items, data);
    };
    i += 1;
  };
}

@addMethod(InventoryDataManagerV2)
public final func GetPlayerItemsCustomJunk(out items: array<wref<gameItemData>>) -> Void {
  let system: ref<RevisedBackpackSystem> = RevisedBackpackSystem.GetInstance(this.m_Player.GetGame());
  let unfilteredItems: array<wref<gameItemData>>;
  this.GetItemsWithExistingPrice(unfilteredItems);
  let data: ref<gameItemData>;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  while i < limit {
    data = unfilteredItems[i];
    if system.IsAddedToJunk(data.GetID()) {
      ArrayPush(items, data);
    };
    i += 1;
  };
}

@wrapMethod(FullscreenVendorGameController)
private final func GetSellableJunk() -> array<wref<gameItemData>> {
  let result: array<wref<gameItemData>> = wrappedMethod();
  let additionalJunk: array<wref<gameItemData>>;
  this.m_InventoryManager.GetPlayerItemsCustomJunk(additionalJunk);
  for additionalItem in additionalJunk {
    ArrayPush(result, additionalItem);
  };

  return result;
}
