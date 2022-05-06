module CarDealer.System
import CarDealer.Classes.PurchasableVehicle
import CarDealer.Utils.P

public class PurchasableVehicleSystem extends ScriptableSystem {

  private let m_storeVehicles: array<ref<PurchasableVehicle>>;

  private let m_vehicleSystem: ref<VehicleSystem>;

  public final static func GetInstance(gameInstance: GameInstance) -> ref<PurchasableVehicleSystem> {
    let system: ref<PurchasableVehicleSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"CarDealer.System.PurchasableVehicleSystem") as PurchasableVehicleSystem;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.m_vehicleSystem = GameInstance.GetVehicleSystem(player.GetGame());
      this.PopulateVehicleList();
      P(s"PurchasableVehicleSystem initialized, detected vehicles: \(ArraySize(this.m_storeVehicles))");
    };
  }

  private func PopulateVehicleList() -> Void {
    let vehicles: array<ref<PurchasableVehicle>>;
    let purchaseable: ref<PurchasableVehicle>;
    for record in TweakDBInterface.GetRecords(n"Vehicle") {
      let vehicleRecord: ref<Vehicle_Record> = record as Vehicle_Record;
      let id: TweakDBID = vehicleRecord.GetID();
      let price: Int32 = TweakDBInterface.GetInt(id + t".dealerPrice", 0);
      let dealerAtlasStr: String = TweakDBInterface.GetString(id + t".dealerAtlasPath", "");
      let dealerPartNameStr: String = TweakDBInterface.GetString(id + t".dealerPartName", "");
      if NotEquals(price, 0) && NotEquals(dealerAtlasStr, "") && NotEquals(dealerPartNameStr, "") {
        purchaseable = new PurchasableVehicle();
        purchaseable.record = vehicleRecord;
        purchaseable.price = price;
        purchaseable.dealerAtlasPath = ResRef.FromString(dealerAtlasStr);
        purchaseable.dealerPartName = StringToName(dealerPartNameStr);
        ArrayPush(vehicles, purchaseable);
        P(s" - vehicle detected: \(TDBID.ToStringDEBUG(id)) \(GetLocalizedTextByKey(vehicleRecord.DisplayName())): \(price) $");
      };
    };
    this.m_storeVehicles = vehicles;
  }

  public func GetList() -> array<ref<PurchasableVehicle>> {
    return this.m_storeVehicles;
  }

  public func IsPurchasable(id: TweakDBID) -> Bool {
    for vehicle in this.m_storeVehicles {
      if Equals(vehicle.record.GetID(), id) {
        return true;
      };
    };
    return false;
  }

  public func IsPurchased(id: TweakDBID) -> Bool {
    let unlockedVehicles: array<PlayerVehicle>;
    this.m_vehicleSystem.GetPlayerUnlockedVehicles(unlockedVehicles);
    for vehicle in unlockedVehicles {
      if Equals(vehicle.recordID, id) {
        return true;
      };
    };
    return false;
  }

  public func Purchase(id: TweakDBID) -> Void {
    this.m_vehicleSystem.EnablePlayerVehicle(TDBID.ToStringDEBUG(id), true, false);
  }

  public func BuyAll() -> Void {
    for vehicle in this.m_storeVehicles {
      this.Purchase(vehicle.record.GetID());
    };
  }

  public func IsInDangerZone(player: ref<PlayerPuppet>) -> Bool {
    let bb: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    let zone: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let inDanger: Bool = zone > 2;
    P(s"Detected zone: \(zone)");
    return inDanger;
  }
}
