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
public let m_savedItemTdbId: TweakDBID;

@addMethod(PlayerPuppet)
public func GetStoredId_RL() -> TweakDBID {
  return this.m_savedItemTdbId;
}

@addMethod(PlayerPuppet)
public func StoreItemId_RL(id: TweakDBID) -> Void {
  this.m_savedItemTdbId = id;
}


@addMethod(PlayerPuppet)
public func ClearStoredId_RL() -> Void {
  this.m_savedItemTdbId = t"";
}
