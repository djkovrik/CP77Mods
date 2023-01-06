import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.System.PurchasableVehicleSystem
import CarDealer.Utils.CarDealerLog

// Check if player has enough money to pay the price
@addMethod(WebPage)
private func HasEnoughMoneyDealer(price: Int32) -> Bool {
  let playerBalance: Int32 = GameInstance.GetTransactionSystem(this.playerPuppet.GetGame()).GetItemQuantity(this.playerPuppet, MarketSystem.Money());
  CarDealerLog(s"has enough money: player \(playerBalance), required: \(price)");
  return playerBalance >= price;
}

// Check if player has enough money to pay the price
@addMethod(WebPage)
private func HasEnoughStreetCredDealer(cred: Int32) -> Bool {
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.playerPuppet.GetGame());
  let streetCredStat: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(this.playerPuppet.GetEntityID()), gamedataStatType.StreetCred);
  let streetCred: Int32 = Cast<Int32>(streetCredStat);
  CarDealerLog(s"has enough street cred: player \(streetCred), required: \(cred)");
  return streetCred >= cred;
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
  let cred: Int32 = currentBundle.cred;
  let price: Int32 = currentBundle.price;
  let isPurchased: Bool = this.purchaseSystem.IsPurchased(id);
  if !isPurchased && this.HasEnoughMoneyDealer(price) && this.HasEnoughStreetCredDealer(cred) {
    this.PlayCustomSoundDealer(n"ui_menu_onpress");
    this.purchaseSystem.Purchase(id);
    this.RemoveMoneyFromPlayerDealer(price);
    this.PushPurchasedNotificationDealer(id);
    this.ShowDealerCurrentPage();
  };
}

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  PurchasableVehicleSystem.GetInstance(this.GetGame()).Initialize(this);
}
