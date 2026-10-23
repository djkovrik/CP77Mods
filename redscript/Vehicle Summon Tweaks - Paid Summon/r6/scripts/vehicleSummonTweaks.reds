// -- Add summoning cost

private class VehicleSummonConfig {
  public static func SummonCost() -> Int32 = 100
}

@wrapMethod(QuickSlotsManager)
public final func SummonActiveVehicle(force: Bool) -> Void {
  let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_Player.GetGame());
  let playerMoney: Int32 = ts.GetItemQuantity(this.m_Player, MarketSystem.Money());
  let price: Int32 = VehicleSummonConfig.SummonCost();
  let canSummon: Bool = force || !GameInstance.GetVehicleSystem(this.m_Player.GetGame()).IsActivePlayerVehicleOnCooldown(this.GetActiveVehicleType());

  if playerMoney < price {
    QuickSlotsManager.ShowNoMoneyMessage(this.m_Player.GetGame());
  } else {
    wrappedMethod(force);
    if canSummon {
      ts.RemoveItemByTDBID(this.m_Player, t"Items.money", price);
    };
  }
}

@wrapMethod(QuickSlotsManager)
public final func SummonVehicle(force: Bool, type: gamedataVehicleType, vehicle: TweakDBID, spawnOnlyOnValidRoad: Bool) -> Void {
  let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_Player.GetGame());
  let playerMoney: Int32 = ts.GetItemQuantity(this.m_Player, MarketSystem.Money());
  let price: Int32 = VehicleSummonConfig.SummonCost();
  let canSummon: Bool = force || !GameInstance.GetVehicleSystem(this.m_Player.GetGame()).IsPlayerVehicleOnCooldown(type, vehicle);

  if playerMoney < price {
    QuickSlotsManager.ShowNoMoneyMessage(this.m_Player.GetGame());
  } else {
    wrappedMethod(force, type, vehicle, spawnOnlyOnValidRoad);
    if canSummon {
      ts.RemoveItemByTDBID(this.m_Player, t"Items.money", price);
    };
  };
}

@addMethod(QuickSlotsManager)
public final static func ShowNoMoneyMessage(gameInstance: GameInstance) -> Void {
  let onscreenMsg: SimpleScreenMessage;
  onscreenMsg.isShown = true;
  onscreenMsg.duration = 5.0;
  onscreenMsg.message = GetLocalizedText("LocKey#54029");
  GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(onscreenMsg), true);
}
