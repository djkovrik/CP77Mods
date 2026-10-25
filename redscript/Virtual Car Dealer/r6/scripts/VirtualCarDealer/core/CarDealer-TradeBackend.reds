module CarDealer.System

import CarDealer.Transactions.*

public class DealerGameTradeBackend extends VehicleTradeBackend {
  public let system: wref<PurchasableVehicleSystem>;
  public let player: wref<GameObject>;

  public func Owns(id: TweakDBID) -> Bool {
    return this.system.IsPurchased(id);
  }

  public func ChangeOwnership(id: TweakDBID, enable: Bool) -> Bool {
    if enable {
      return this.system.m_vehicleSystem.EnablePlayerVehicleID(id, true);
    };
    return RemoveVehicle(this.player.GetGame(), this.system.m_vehicleSystem, id);
  }

  public func GetBalance() -> Int32 {
    return this.system.m_transactionSystem.GetItemQuantity(this.player, MarketSystem.Money());
  }

  public func ChangeMoney(amount: Int32, purchase: Bool) -> Bool {
    if purchase {
      return this.system.m_transactionSystem.RemoveItemByTDBID(this.player, t"Items.money", amount);
    };
    return this.system.m_transactionSystem.GiveItem(this.player, MarketSystem.Money(), amount);
  }

  public func FinalizePurchase(id: TweakDBID) -> Void {
    this.system.FinalizePaidPurchase(id);
  }
}
