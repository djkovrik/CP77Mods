module CarDealer.System
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.Classes.AutofixerItemData
import CarDealer.Config.CarDealerConfig
import CarDealer.Utils.CarDealerLog

@if(ModuleExists("VehiclePersistence.System"))
import VehiclePersistence.System.PersistentVehicleSystem

public class PurchasableVehicleSystem extends ScriptableSystem {

  private let m_storeVehicles: array<ref<PurchasableVehicleBundle>>;

  private let m_vehicleSystem: ref<VehicleSystem>;

  private let m_transactionSystem: ref<TransactionSystem>;

  private let m_sellPriceModifier: Float = 0.25;

  private let m_fallbackPrice: Int32 = 40000;

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

  private func DeactivateSoldVehicles() -> Void {
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
    this.m_vehicleSystem.EnablePlayerVehicleID(id, true);
    SyncPersistentVehicles(this.GetGameInstance());
    let soldVehicles: array<TweakDBID> = this.m_soldVehicles;
    if ArrayContains(soldVehicles, id) {
      ArrayRemove(soldVehicles, id);
      this.m_soldVehicles = soldVehicles;
    };
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

  public func GetOwnedVehiclesData() -> array<ref<AutofixerItemData>> {
    let result: array<ref<AutofixerItemData>>;
    let playerVehicles: array<PlayerVehicle>;
    let persistentVehicles: array<PlayerVehicle>;
    let vehicleRecord: ref<Vehicle_Record>;
    let vehicleId: TweakDBID;
    let item: ref<AutofixerItemData>;
    let price: Int32;
    let sellPrice: Float;

    this.DeactivateSoldVehicles();
    this.m_vehicleSystem.GetPlayerUnlockedVehicles(playerVehicles);

    persistentVehicles = GetPersistentVehicles(this.GetGameInstance());
    for persistentVehicle in persistentVehicles {
      ArrayPush(playerVehicles, persistentVehicle);
    }

    for playerVehicle in playerVehicles {
      if TDBID.IsValid(playerVehicle.recordID) {
        vehicleRecord = TweakDBInterface.GetVehicleRecord(playerVehicle.recordID);
        vehicleId = vehicleRecord.GetID();
        price = TweakDBInterface.GetInt(vehicleId + t".autofixer", 0);
        if Equals(price, 0) { 
          price = this.FindPriceInBundles(vehicleId); 
        };
        sellPrice = Cast<Float>(price) * this.m_sellPriceModifier;
        item = new AutofixerItemData();
        item.title = GetLocalizedTextByKey(vehicleRecord.DisplayName());
        item.price = Cast<Int32>(sellPrice);
        item.atlasResource = vehicleRecord.Icon().AtlasResourcePath();
        item.textureName = vehicleRecord.Icon().AtlasPartName();
        item.vehicleID = playerVehicle.recordID;
        item.sold = false;
        CarDealerLog(s"Owned vehicle: \(TDBID.ToStringDEBUG(item.vehicleID)) \(item.title) with price \(price) and sell price \(item.price)");
        ArrayPush(result, item);
      };
    };

    return result;
  }

  public func SellOwnedVehicle(player: ref<GameObject>, data: ref<AutofixerItemData>) -> Void {
    if ArrayContains(this.m_soldVehicles, data.vehicleID) {
      return ;
    };
    if RemoveVehicle(this.GetGameInstance(), this.m_vehicleSystem, data.vehicleID) {
      this.m_transactionSystem.GiveItem(player, MarketSystem.Money(), data.price);
      ArrayPush(this.m_soldVehicles, data.vehicleID);
    } else {
      CarDealerLog(s"Failed to sell vehicle: \(data.title)");
    };
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