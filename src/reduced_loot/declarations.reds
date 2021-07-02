module ReducedLootDeclarations

@addField(gameItemData)
public let m_shouldKeep: Bool;

@addMethod(gameItemData)
public func SetShouldKeep_RL() -> Void {
  this.m_shouldKeep = true;
}

@addMethod(gameItemData)
public func GetShouldKeep_RL() -> Bool {
  return this.m_shouldKeep;
}

@addField(PlayerPuppet)
public let m_savedItemId: ItemID;

@addMethod(PlayerPuppet)
public func GetStoredId_RL() -> ItemID {
  return this.m_savedItemId;
}

@addMethod(PlayerPuppet)
public func StoreItemId_RL(id: ItemID) -> Void {
  this.m_savedItemId = id;
}