module CombatAwareness

@addField(BaseScriptableAction)
private let caPaying: Bool;

@addField(BaseScriptableAction)
private let caQuotedPayment: Int32;

@wrapMethod(BaseScriptableAction)
public func PayCost(opt checkForOverclockedState: Bool) -> Bool {
  if !IsDefined(this as PuppetAction) || !IsDefined(this.GetExecutor() as PlayerPuppet) {
    return wrappedMethod(checkForOverclockedState);
  };

  this.caPaying = true;
  this.caQuotedPayment = -1;
  let paid = wrappedMethod(checkForOverclockedState);
  this.caPaying = false;
  
  if paid && this.caQuotedPayment >= 0 && this.paymentQuantity == this.caQuotedPayment {
    AwarenessSystem.Get(this.GetExecutor().GetGame()).Spend(6);
  };

  return paid;
}

@wrapMethod(BaseScriptableAction)
public func GetCost() -> Int32 {
  let price: Int32 = wrappedMethod();
  if price <= 0 || !IsDefined(this as PuppetAction) || !IsDefined(this.GetExecutor() as PlayerPuppet) { 
    return price; 
  };

  let target = this.GetRequesterID();
  if !EntityID.IsDefined(target) { 
    target = PersistentID.ExtractEntityID(this.GetPersistentID()); 
  };

  let system = AwarenessSystem.Get(this.GetExecutor().GetGame());

  if !EntityID.IsDefined(target) 
    || target != system.studied
    || !system.Ready(6)
    || NotEquals(this.GetObjectActionRecord().ObjectActionType().Type(), gamedataObjectActionType.PuppetQuickHack) { 
      return price; 
  };

  let ram = this.m_costComponents[0] as StatPoolCost_Record;

  if !IsDefined(ram) || NotEquals(ram.StatPool().StatPoolType(), gamedataStatPoolType.Memory) { 
    return price; 
  };

  let minimum = ram.GetCostModsCount() > 0 ? 2 : 0;

  if ArraySize(this.m_costComponents) > 1 {
    let costMods: array<wref<StatModifier_Record>>;
    BaseScriptableAction.GetCostMods(this.m_costComponents, costMods);
    minimum = ArraySize(costMods) > 0 ? 2 : 0;
  };

  let discounted = Max(minimum, price - Min(4, CeilF(Cast<Float>(price) * 0.25)));
  if discounted >= price { 
    return price; 
  };

  if QuickHackableHelper.IsOverclockedStateActive(this.GetExecutor())
    && GameInstance.GetStatPoolsSystem(this.GetExecutor().GetGame()).GetStatPoolValue(Cast<StatsObjectID>(this.GetExecutor().GetEntityID()), gamedataStatPoolType.Memory, false) < Cast<Float>(discounted) { 
      return price;
  };

  if this.caPaying { 
    this.caQuotedPayment = discounted; 
  };
  
  return discounted;
}
