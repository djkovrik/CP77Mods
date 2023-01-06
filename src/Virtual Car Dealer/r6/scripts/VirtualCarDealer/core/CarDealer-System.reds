module CarDealer.System
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.Config.CarDealerConfig
import CarDealer.Utils.CarDealerLog

public class PurchasableVehicleSystem extends ScriptableSystem {

  private let m_storeVehicles: array<ref<PurchasableVehicleBundle>>;

  private let m_vehicleSystem: ref<VehicleSystem>;

  public final static func GetInstance(gameInstance: GameInstance) -> ref<PurchasableVehicleSystem> {
    let system: ref<PurchasableVehicleSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"CarDealer.System.PurchasableVehicleSystem") as PurchasableVehicleSystem;
    return system;
  }

  public final func Initialize(player: ref<PlayerPuppet>) -> Void {
    if IsDefined(player) {
      this.m_vehicleSystem = GameInstance.GetVehicleSystem(player.GetGame());
      this.PopulateVehicleList();
      CarDealerLog(s"PurchasableVehicleSystem initialized, detected vehicles: \(ArraySize(this.m_storeVehicles))");
    };
  }

  private func PopulateVehicleList() -> Void {
    let result: array<ref<PurchasableVehicleBundle>>;
    let newBundle: ref<PurchasableVehicleBundle>;
    let newVariant: ref<PurchasableVehicleVariant>;
    // Check all vehicle records
    for record in TweakDBInterface.GetRecords(n"Vehicle") {
      let currentRecord: ref<Vehicle_Record> = record as Vehicle_Record;
      let currentId: TweakDBID = currentRecord.GetID();
      let currentCred: Int32 = TweakDBInterface.GetInt(currentId + t".dealerCred", 0);
      let currentPrice: Int32 = TweakDBInterface.GetInt(currentId + t".dealerPrice", 0);
      // Dealer record detected
      if NotEquals(currentPrice, 0) {
        CarDealerLog(s" - vehicle detected: \(TDBID.ToStringDEBUG(currentId)) \(GetLocalizedTextByKey(currentRecord.DisplayName())): \(currentPrice) $");
        // Let's make a new bundle
        newBundle = new PurchasableVehicleBundle();
        newBundle.cred = currentCred;
        newBundle.price = currentPrice;
        // And then check if dealer variants available
        let dealerVariants: array<String> = TweakDBInterface.GetStringArray(currentId + t".dealerVariants");
        let vehicleVariantIds: array<TweakDBID> = this.GetTDBIDs(dealerVariants);
        if Equals(ArraySize(vehicleVariantIds), 0) {
          // No variants detected - add core record
          ArrayPush(vehicleVariantIds, currentId);
        };
        // Populate variants archive
        let detectedVariants: array<ref<PurchasableVehicleVariant>>;
        // Iterate through detected variants
        for currentVehicleVariantId in vehicleVariantIds {
          let currentVariantRecord: ref<Vehicle_Record> = TweakDBInterface.GetVehicleRecord(currentVehicleVariantId) as Vehicle_Record;
          newVariant = new PurchasableVehicleVariant();
          newVariant.record = currentVariantRecord;
          // Variants is not empty so should take paths from each variant record
          newVariant.dealerAtlasPath = ResRef.FromString(TweakDBInterface.GetString(currentVehicleVariantId + t".dealerAtlasPath", ""));
          newVariant.dealerPartName = StringToName(TweakDBInterface.GetString(currentVehicleVariantId + t".dealerPartName", ""));
          ArrayPush(detectedVariants, newVariant);
          CarDealerLog(s" --- variant: \(newVariant.dealerPartName)");
        };
        newBundle.variants = detectedVariants;
        ArrayPush(result, newBundle);
      };
    };

    this.m_storeVehicles = result;
  }

  public func GetList() -> array<ref<PurchasableVehicleBundle>> {
    return this.m_storeVehicles;
  }

  public func IsPurchasable(id: TweakDBID) -> Bool {
    for vehicle in this.m_storeVehicles {
      for variant in vehicle.variants {
      if Equals(variant.record.GetID(), id) {
        return true;
      };
      }
    };
    return false;
  }

  public func IsPurchased(id: TweakDBID) -> Bool {
    if CarDealerConfig.HandleColorVariantsAsSingleLot() {
      return this.IsBundlePurchased(id);
    } else {
      return this.IsSeparatePurchased(id);
    };
  }

  public func Purchase(id: TweakDBID) -> Void {
    if IsDefined(this.m_vehicleSystem) {
      Log("Vehicle system available");
    };
    this.m_vehicleSystem.EnablePlayerVehicle(TDBID.ToStringDEBUG(id), true, false);
  }

  public func BuyAll() -> Void {
    for vehicle in this.m_storeVehicles {
      for variant in vehicle.variants {
        this.Purchase(variant.record.GetID());
      };
    };
  }

  public func IsInDangerZone(player: ref<PlayerPuppet>) -> Bool {
    let bb: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    let zone: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let inDanger: Bool = zone > 2;
    CarDealerLog(s"Detected zone: \(zone)");
    return inDanger;
  }

  private func GetTDBIDs(items: array<String>) -> array<TweakDBID> {
    let result: array<TweakDBID>;
    for item in items {
      ArrayPush(result, TDBID.Create(item));
    };
    return result;
  }

  private func IsSeparatePurchased(id: TweakDBID) -> Bool {
    let unlockedVehicles: array<PlayerVehicle>;
    this.m_vehicleSystem.GetPlayerUnlockedVehicles(unlockedVehicles);
    for vehicle in unlockedVehicles {
      if Equals(vehicle.recordID, id) {
        return true;
      };
    };
    return false;
  }

  private func IsBundlePurchased(id: TweakDBID) -> Bool {
    let currentBundle: ref<PurchasableVehicleBundle>;
    let currentVariant: ref<PurchasableVehicleVariant>;
    let targetBundle: ref<PurchasableVehicleBundle>;
    // Find target bundle
    let i: Int32 = 0;
    let j: Int32;
    let bundleFound: Bool = false;
    while i < ArraySize(this.m_storeVehicles) && !bundleFound {
      currentBundle = this.m_storeVehicles[i];
      j = 0;
      while j < ArraySize(currentBundle.variants)  && !bundleFound {
        currentVariant = currentBundle.variants[j];
        if Equals(currentVariant.record.GetID(), id) {
          targetBundle = currentBundle;
          bundleFound = true;
        };
        j += 1;
      };
      i += 1;
    };

    // Check if anything inside the bundle is purchased
    if bundleFound {
      for variant in targetBundle.variants {
        if this.IsSeparatePurchased(variant.record.GetID()) {
          return true;
        };
      };
    };

    return false;
  }
}
