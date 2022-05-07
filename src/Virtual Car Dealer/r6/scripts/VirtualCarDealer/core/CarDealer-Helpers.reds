import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.System.PurchasableVehicleSystem

// Check if player has enough money to pay the price
@addMethod(WebPage)
private func HasEnoughMoneyDealer(price: Int32) -> Bool {
  let playerBalance: Int32 = GameInstance.GetTransactionSystem(this.playerPuppet.GetGame()).GetItemQuantity(this.playerPuppet, MarketSystem.Money());
  let result: Bool = playerBalance >= price;
  return playerBalance >= price;
}

// Remove money from player inventory
@addMethod(WebPage)
private func RemoveMoneyFromPlayerDealer(price: Int32) -> Bool {
  return GameInstance.GetTransactionSystem(this.playerPuppet.GetGame()).RemoveItemByTDBID(this.playerPuppet, t"Items.money", price);
}

// Show purchased notification
@addMethod(WebPage)
private func PushPurchasedNotificationDealer(id: TweakDBID) -> Void {
  let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.playerPuppet.GetGame()).Get(GetAllBlackboardDefs().VehiclePurchaseData);
  bb.SetVariant(GetAllBlackboardDefs().VehiclePurchaseData.PurchasedVehicleRecordID, ToVariant(id), true);
}

// this.PlaySound does not work here for some reason
@addMethod(WebPage)
protected cb func PlayCustomSoundDealer(evt: CName) -> Bool {
  GameObject.PlaySoundEvent(this.playerPuppet, evt);
}

// -- Play click sound, buy current selected vehicle, 
//    refresh UI and show notification
@addMethod(WebPage)
private func DealerBuyCurrentVehicle() {
  let currentBundle: ref<PurchasableVehicleBundle> = this.vehiclesStock[this.vehicleIndex];
  let currentVehicle: ref<PurchasableVehicleVariant> = currentBundle.variants[this.vehicleVariantIndex];
  let id: TweakDBID = currentVehicle.record.GetID();
  let price: Int32 = currentBundle.price;
  let isPurchased: Bool = this.purchaseSystem.IsPurchased(id);
  if !isPurchased && this.HasEnoughMoneyDealer(price) {
    this.PlayCustomSoundDealer(n"ui_menu_onpress");
    this.purchaseSystem.Purchase(id);
    this.RemoveMoneyFromPlayerDealer(price);
    this.PushPurchasedNotificationDealer(id);
    this.ShowDealerCurrentPage();
  };
}