import CarDealer.System.PurchasableVehicleSystem
// Use Game.CarDealerCheat() console command to open all supported vehicles
public static exec func CarDealerCheat(gi: GameInstance) -> Void {
  PurchasableVehicleSystem.GetInstance(gi).BuyAll();
}
