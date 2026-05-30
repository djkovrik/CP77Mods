module CarDealer.System
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.Classes.AutofixerItemData
import CarDealer.Utils.CarDealerLog

@if(ModuleExists("VehiclePersistence.System"))
import VehiclePersistence.System.PersistentVehicleSystem

public class PurchasableVehicleSystem extends ScriptableSystem {

  public let m_storeVehicles: array<ref<PurchasableVehicleBundle>>;

  public let m_vehicleSystem: ref<VehicleSystem>;

  public let m_transactionSystem: ref<TransactionSystem>;

  public let m_sellPriceModifier: Float = 0.25;

  public let m_fallbackPrice: Int32 = 40000;

  private persistent let m_soldVehicles: array<TweakDBID>;

  public final static func GetInstance(gameInstance: GameInstance) -> ref<PurchasableVehicleSystem> {
    let system: ref<PurchasableVehicleSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"CarDealer.System.PurchasableVehicleSystem") as PurchasableVehicleSystem;
    return system;
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
    // Check if the game actually loaded
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      CarDealerLog("Main menu detected, skip Car Dealer init");
      return ;
    };

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.m_vehicleSystem = GameInstance.GetVehicleSystem(player.GetGame());
      this.m_transactionSystem = GameInstance.GetTransactionSystem(player.GetGame());
      this.PopulateVehicleList();
      CarDealerLog(s"ArchiveXL detected: \(ArchiveXL.Version())");
      CarDealerLog(s"PurchasableVehicleSystem initialized, detected vehicles: \(ArraySize(this.m_storeVehicles))");
      this.DeactivateSoldVehicles();
    };
  }

  public func DeactivateSoldVehicles() -> Void {
    for id in this.m_soldVehicles {
      RemoveVehicle(this.GetGameInstance(), this.m_vehicleSystem, id);
    };
  }

  private func PopulateVehicleList() -> Void {
    let result: array<ref<PurchasableVehicleBundle>>;
    let newBundle: ref<PurchasableVehicleBundle>;
    let newVariant: ref<PurchasableVehicleVariant>;
    // Check all vehicle records
    for record in TweakDBInterface.GetRecords(n"Vehicle") {
      let currentRecord: ref<Vehicle_Record> = record as Vehicle_Record;
      if IsDefined(currentRecord) {
        let currentId: TweakDBID = currentRecord.GetID();
        if TDBID.IsValid(currentId) {
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
              if TDBID.IsValid(currentVehicleVariantId) {
                let currentVariantRecord: ref<Vehicle_Record> = TweakDBInterface.GetVehicleRecord(currentVehicleVariantId) as Vehicle_Record;
                if IsDefined(currentVariantRecord) {
                  newVariant = new PurchasableVehicleVariant();
                  newVariant.record = currentVariantRecord;
                  // Variants is not empty so should take paths from each variant record
                  newVariant.dealerAtlasPath = ResRef.FromString(TweakDBInterface.GetString(currentVehicleVariantId + t".dealerAtlasPath", ""));
                  newVariant.dealerPartName = StringToName(TweakDBInterface.GetString(currentVehicleVariantId + t".dealerPartName", ""));
                  ArrayPush(detectedVariants, newVariant);
                  CarDealerLog(s" --- variant: \(newVariant.dealerPartName)");
                } else {
                  CarDealerLog(s" --- skipped missing variant record: \(TDBID.ToStringDEBUG(currentVehicleVariantId))");
                };
              } else {
                CarDealerLog(s" --- skipped invalid variant: \(TDBID.ToStringDEBUG(currentVehicleVariantId))");
              };
            };
            if ArraySize(detectedVariants) > 0 {
              newBundle.variants = detectedVariants;
              ArrayPush(result, newBundle);
            } else {
              CarDealerLog(s" - skipped vehicle with no valid variants: \(TDBID.ToStringDEBUG(currentId))");
            };
          };
        } else {
          CarDealerLog(" - skipped vehicle with invalid TDBID");
        };
      };
    };

    this.m_storeVehicles = result;
  }

  public func GetList() -> array<ref<PurchasableVehicleBundle>> {
    return this.m_storeVehicles;
  }

  public func IsPurchasable(id: TweakDBID) -> Bool {
    for vehicle in this.m_storeVehicles {
      if IsDefined(vehicle) {
        for variant in vehicle.variants {
          if IsDefined(variant) && IsDefined(variant.record) && Equals(variant.record.GetID(), id) {
            return true;
          };
        };
      };
    };
    return false;
  }

  public func IsPurchased(id: TweakDBID) -> Bool {
    return this.IsSeparatePurchased(id);
  }

  public func Purchase(id: TweakDBID) -> Bool {
    if !TDBID.IsValid(id) {
      CarDealerLog(s"Failed to purchase vehicle with invalid ID: \(TDBID.ToStringDEBUG(id))");
      return false;
    };
    if !this.m_vehicleSystem.EnablePlayerVehicleID(id, true) {
      CarDealerLog(s"Failed to purchase vehicle: \(TDBID.ToStringDEBUG(id))");
      return false;
    };
    SyncPersistentVehicles(this.GetGameInstance());
    let soldVehicles: array<TweakDBID> = this.m_soldVehicles;
    if ArrayContains(soldVehicles, id) {
      ArrayRemove(soldVehicles, id);
      this.m_soldVehicles = soldVehicles;
    };
    return true;
  }

  public func BuyAll() -> Void {
    for vehicle in this.m_storeVehicles {
      if IsDefined(vehicle) {
        for variant in vehicle.variants {
          if IsDefined(variant) && IsDefined(variant.record) {
            this.Purchase(variant.record.GetID());
          };
        };
      };
    };
  }

  public func ClearSoldVehicles() -> Void {
    let vehicleSystem: ref<VehicleSystem> = GameInstance.GetVehicleSystem(this.GetGameInstance());
    let soldVehicles: array<TweakDBID> = this.m_soldVehicles;
    let failedVehicles: array<TweakDBID>;
    let restoredCount: Int32 = 0;
    ArrayClear(this.m_soldVehicles);
    for soldVehicle in soldVehicles {
      if TDBID.IsValid(soldVehicle) {
        if vehicleSystem.EnablePlayerVehicleID(soldVehicle, true) {
          restoredCount += 1;
          FTLog(s"Restored sold vehicle: \(TDBID.ToStringDEBUG(soldVehicle))");
        } else {
          ArrayPush(failedVehicles, soldVehicle);
          FTLog(s"Failed to restore sold vehicle: \(TDBID.ToStringDEBUG(soldVehicle))");
        };
      } else {
        FTLog(s"Skipped invalid sold vehicle ID: \(TDBID.ToStringDEBUG(soldVehicle))");
      };
    };
    this.m_soldVehicles = failedVehicles;
    if restoredCount > 0 {
      SyncPersistentVehicles(this.GetGameInstance());
    };
    FTLog(s"Vehicles restored: \(restoredCount)");
  }

  public func IsInDangerZone(player: ref<PlayerPuppet>) -> Bool {
    let bb: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    let zone: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let inDanger: Bool = zone > 2;
    CarDealerLog(s"Detected zone: \(zone)");
    return inDanger;
  }

  public func GetOwnedVehiclesData() -> array<ref<AutofixerItemData>> {
    let result: array<ref<AutofixerItemData>>;
    let playerVehicles: array<PlayerVehicle>;
    let persistentVehicles: array<PlayerVehicle>;
    let vehicleRecord: ref<Vehicle_Record>;
    let vehicleId: TweakDBID;
    let item: ref<AutofixerItemData>;
    let vehicleIcon: wref<UIIcon_Record>;
    let price: Int32;
    let sellPrice: Float;
    let isVanillaVehicle: Bool;

    this.DeactivateSoldVehicles();
    this.m_vehicleSystem.GetPlayerUnlockedVehicles(playerVehicles);

    persistentVehicles = GetPersistentVehicles(this.GetGameInstance());
    for persistentVehicle in persistentVehicles {
      ArrayPush(playerVehicles, persistentVehicle);
    }

    for playerVehicle in playerVehicles {
      if TDBID.IsValid(playerVehicle.recordID) {
        vehicleRecord = TweakDBInterface.GetVehicleRecord(playerVehicle.recordID);
        if IsDefined(vehicleRecord) {
          vehicleIcon = vehicleRecord.Icon();
          if IsDefined(vehicleIcon) {
            vehicleId = vehicleRecord.GetID();
            price = TweakDBInterface.GetInt(vehicleId + t".autofixer", 0);
            if Equals(price, 0) { 
              isVanillaVehicle = false;
              price = this.FindPriceInBundles(vehicleId); 
            } else {
              isVanillaVehicle = true;
            };
            sellPrice = Cast<Float>(price) * this.m_sellPriceModifier;
            item = new AutofixerItemData();
            item.title = GetLocalizedTextByKey(vehicleRecord.DisplayName());
            item.price = Cast<Int32>(sellPrice);
            item.atlasResource = vehicleIcon.AtlasResourcePath();
            item.textureName = vehicleIcon.AtlasPartName();
            item.vehicleID = playerVehicle.recordID;
            item.sold = false;
            item.vanilla = isVanillaVehicle;
            CarDealerLog(s"Owned vehicle: \(TDBID.ToStringDEBUG(item.vehicleID)) \(item.title) with price \(price) and sell price \(item.price), vanilla: \(item.vanilla)");
            ArrayPush(result, item);
          } else {
            CarDealerLog(s"Skipped owned vehicle with missing icon: \(TDBID.ToStringDEBUG(playerVehicle.recordID))");
          };
        } else {
          CarDealerLog(s"Skipped owned vehicle with missing record: \(TDBID.ToStringDEBUG(playerVehicle.recordID))");
        };
      } else {
        CarDealerLog(s"Skipped owned vehicle with invalid ID: \(TDBID.ToStringDEBUG(playerVehicle.recordID))");
      };
    };

    return result;
  }

  public func SellOwnedVehicle(player: ref<GameObject>, data: ref<AutofixerItemData>) -> Bool {
    if !IsDefined(player) || !IsDefined(data) || !TDBID.IsValid(data.vehicleID) {
      CarDealerLog("Failed to sell vehicle: invalid sell request");
      return false;
    };
    if ArrayContains(this.m_soldVehicles, data.vehicleID) {
      return false;
    };
    if RemoveVehicle(this.GetGameInstance(), this.m_vehicleSystem, data.vehicleID) {
      this.m_transactionSystem.GiveItem(player, MarketSystem.Money(), data.price);
      ArrayPush(this.m_soldVehicles, data.vehicleID);
      return true;
    } else {
      CarDealerLog(s"Failed to sell vehicle: \(data.title)");
    };
    return false;
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
    return CheckIfVehicleIsPersistent(this.GetGameInstance(), id);
  }

  private func FindPriceInBundles(id: TweakDBID) -> Int32 {
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
      if IsDefined(currentBundle) {
        while j < ArraySize(currentBundle.variants)  && !bundleFound {
          currentVariant = currentBundle.variants[j];
          if IsDefined(currentVariant) && IsDefined(currentVariant.record) && Equals(currentVariant.record.GetID(), id) {
            targetBundle = currentBundle;
            bundleFound = true;
          };
          j += 1;
        };
      };
      i += 1;
    };

    if bundleFound {
      return targetBundle.price;
    };

    return this.m_fallbackPrice;
  }
}

// conditional methods for compatibility with Improved Vehicle Persistence

@if(!ModuleExists("VehiclePersistence.System"))
func RemoveVehicle(gameInstance: GameInstance, vehicleSystem: ref<VehicleSystem>, id: TweakDBID) -> Bool {
  return vehicleSystem.EnablePlayerVehicleID(id, false); 
}
@if(ModuleExists("VehiclePersistence.System"))
func RemoveVehicle(gameInstance: GameInstance, vehicleSystem: ref<VehicleSystem>, id: TweakDBID) -> Bool {
  let result = vehicleSystem.EnablePlayerVehicleID(id, false, true);
  result = PersistentVehicleSystem.GetInstance(gameInstance).RemovePersistentVehicle(id) || result;
  return result;
}

@if(!ModuleExists("VehiclePersistence.System"))
func SyncPersistentVehicles(gameInstance: GameInstance) -> Void {}
@if(ModuleExists("VehiclePersistence.System"))
func SyncPersistentVehicles(gameInstance: GameInstance) -> Void {
  PersistentVehicleSystem.GetInstance(gameInstance).SyncAllPersistentVehicles();
}

@if(!ModuleExists("VehiclePersistence.System"))
func GetPersistentVehicles(gameInstance: GameInstance) -> array<PlayerVehicle> { return []; }
@if(ModuleExists("VehiclePersistence.System"))
func GetPersistentVehicles(gameInstance: GameInstance) -> array<PlayerVehicle> {
  return PersistentVehicleSystem.GetInstance(gameInstance).GetPersistentVehicles();
}

@if(!ModuleExists("VehiclePersistence.System"))
func CheckIfVehicleIsPersistent(gameInstance: GameInstance, id: TweakDBID) -> Bool { return false; }
@if(ModuleExists("VehiclePersistence.System"))
func CheckIfVehicleIsPersistent(gameInstance: GameInstance, id: TweakDBID) -> Bool {
  return PersistentVehicleSystem.GetInstance(gameInstance).IsVehiclePersistent(id);
}
