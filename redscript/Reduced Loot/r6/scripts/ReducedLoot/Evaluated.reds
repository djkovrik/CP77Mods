import ReducedLoot.Money.*


// -- WORLD

@addField(gameItemDropObject)
private let moneyCfg: ref<ReducedLootMoneyConfig>;

@wrapMethod(gameItemDropObject)
protected cb func OnGameAttached() -> Bool {
  this.moneyCfg = new ReducedLootMoneyConfig();
  return wrappedMethod();
}

@wrapMethod(gameItemDropObject)
protected final func OnItemEntitySpawned(entID: EntityID) -> Void {
  let data: ref<gameItemData> = this.GetItemObject().GetItemData();

  // Money
  if ReducedLootMoneyDrop.ShouldDelete(data, this.moneyCfg) {
    EntityGameInterface.Destroy(this.GetEntity());
    return ;
  };

  wrappedMethod(entID);
}


// --- CONTAINERS

@addField(gameLootContainerBase)
private let moneyCfg: ref<ReducedLootMoneyConfig>;

@wrapMethod(gameLootContainerBase)
protected cb func OnGameAttached() -> Bool {
  this.moneyCfg = new ReducedLootMoneyConfig();
  return wrappedMethod();
}

@wrapMethod(gameLootContainerBase)
private final func EvaluateLootQuality() -> Bool {
  let wrapped: Bool = wrappedMethod();
  let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let lootItems: array<wref<gameItemData>>;
  if ts.GetItemList(this, lootItems) && !this.m_hasQuestItems {
    for lootItem in lootItems {
      // Money
      ReducedLootMoneyDrop.TweakEvaluated(this, ts, lootItem, this.moneyCfg);
    };
  };

  return wrapped;
}


// --- BODIES

@addField(ScriptedPuppet)
private let moneyCfg: ref<ReducedLootMoneyConfig>;

@wrapMethod(ScriptedPuppet)
protected cb func OnGameAttached() -> Bool {
  this.moneyCfg = new ReducedLootMoneyConfig();
  return wrappedMethod();
}

@wrapMethod(ScriptedPuppet)
private final func EvaluateLootQuality() -> Bool {
  let wrapped: Bool = wrappedMethod();
  let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let lootItems: array<wref<gameItemData>>;
  if ts.GetItemList(this, lootItems) && !this.m_hasQuestItems {
    for lootItem in lootItems {
      // Money
      ReducedLootMoneyDrop.TweakEvaluated(this, ts, lootItem, this.moneyCfg);
    };
  };

  return wrapped;
}
