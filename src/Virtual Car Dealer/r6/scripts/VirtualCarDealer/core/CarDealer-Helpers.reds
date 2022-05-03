import CarDealer.Classes.PurchasableVehicle
import CarDealer.System.PurchasableVehicleSystem

@addMethod(WebPage)
private func HasEnoughMoney(price: Int32) -> Bool {
  let playerBalance: Int32 = GameInstance.GetTransactionSystem(this.playerPuppet.GetGame()).GetItemQuantity(this.playerPuppet, MarketSystem.Money());
  return playerBalance >= price;
}

@addMethod(WebPage)
private func RemoveMoneyFromPlayer(price: Int32) -> Bool {
  return GameInstance.GetTransactionSystem(this.playerPuppet.GetGame()).RemoveItemByTDBID(this.playerPuppet, t"Items.money", price);
}

@addMethod(WebPage)
private func PushPurchasedNotification(id: TweakDBID) -> Void {
  let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.playerPuppet.GetGame()).Get(GetAllBlackboardDefs().VehiclePurchaseData);
  bb.SetVariant(GetAllBlackboardDefs().VehiclePurchaseData.PurchasedVehicleRecordID, ToVariant(id), true);
}

// this.PlaySound does not work here for some reason
@addMethod(WebPage)
protected cb func PlayCustomSound(evt: CName) -> Bool {
  GameObject.PlaySoundEvent(this.playerPuppet, evt);
}

@addMethod(WebPage)
private func BuyCurrentVehicle() {
  let vehicle: ref<PurchasableVehicle> = this.vehiclesStock[this.vehicleIndex];
  let id: TweakDBID = vehicle.record.GetID();
  let price: Int32 = vehicle.price;
  let isPurchased: Bool = this.purchaseSystem.IsPurchased(id);
  if !isPurchased {
    this.PlayCustomSound(n"ui_menu_onpress");
    this.purchaseSystem.Purchase(id);
    this.ShowCurrentPage();
    this.RemoveMoneyFromPlayer(price);
    this.PushPurchasedNotification(id);
  };
}
