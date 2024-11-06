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
