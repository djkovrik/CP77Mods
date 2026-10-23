import CarDealer.System.PurchasableVehicleSystem

// Use Game.CarDealerCheat() console command to open all supported vehicles
public func CarDealerCheat(gi: GameInstance) -> Void {
  PurchasableVehicleSystem.GetInstance(gi).BuyAll();
}

public func ClearSoldVehicles(gi: GameInstance) -> Void {
  PurchasableVehicleSystem.GetInstance(gi).ClearSoldVehicles();
}
