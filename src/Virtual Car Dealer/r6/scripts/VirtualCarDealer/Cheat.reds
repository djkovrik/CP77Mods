import CarDealer.System.PurchasableVehicleSystem
// Use Game.CarDealerCheat() console command to open all supported vehicles
public static exec func CarDealerCheat(gi: GameInstance) -> Void {
  PurchasableVehicleSystem.GetInstance(gi).BuyAll();
}

@addMethod(WebPage)
private func RemoveMoneyFromPlayer(price: Int32) -> Bool {
  return GameInstance.GetTransactionSystem(this.playerPuppet.GetGame()).RemoveItemByTDBID(this.playerPuppet, t"Items.money", price);
}


public static exec func RemovePlayerMoney(gi: GameInstance, amount: Int32) -> Void {
  GameInstance.GetTransactionSystem(gi).RemoveItemByTDBID(GetPlayer(gi), t"Items.money", amount);
}
