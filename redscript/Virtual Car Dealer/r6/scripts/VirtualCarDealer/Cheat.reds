import CarDealer.System.PurchasableVehicleSystem
import CarDealer.Transactions.VehicleTradeResult

// Use Game.CarDealerCheat() console command to open all supported vehicles
public func CarDealerCheat(gi: GameInstance) -> Void {
  PurchasableVehicleSystem.GetInstance(gi).BuyAll();
}

public func ClearSoldVehicles(gi: GameInstance) -> Void {
  PurchasableVehicleSystem.GetInstance(gi).ClearSoldVehicles();
}

public func CarDealerListPendingTrades(gi: GameInstance) -> Void {
  PurchasableVehicleSystem.GetInstance(gi).ListPendingTrades();
}

public func CarDealerRetryCompensation(gi: GameInstance, id: TweakDBID, allowDisable: Bool) -> Void {
  let result = PurchasableVehicleSystem.GetInstance(gi).RetryTradeCompensation(id, allowDisable);
  FTLog(s"VCD compensation result: \(result)");
}

public func CarDealerAcknowledgeReview(gi: GameInstance, id: TweakDBID, completed: Bool) -> Void {
  let result = PurchasableVehicleSystem.GetInstance(gi).AcknowledgeTradeReview(id, completed);
  FTLog(s"VCD review acknowledgement: \(result)");
}
