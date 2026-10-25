module CarDealer.System
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.Classes.AutofixerItemData
import CarDealer.Utils.CarDealerLog
import CarDealer.Transactions.*

@if(ModuleExists("VehiclePersistence.System"))
import VehiclePersistence.System.PersistentVehicleSystem

public class PurchasableVehicleSystem extends ScriptableSystem {

  public let m_storeVehicles: array<ref<PurchasableVehicleBundle>>;

  public let m_vehicleSystem: ref<VehicleSystem>;

  public let m_transactionSystem: ref<TransactionSystem>;

  public let m_sellPriceModifier: Float = 0.25;

  public let m_fallbackPrice: Int32 = 40000;

  private persistent let m_soldVehicles: array<TweakDBID>;
  private persistent let m_pendingTrades: array<ref<VehicleTradeOperation>>;
  private let m_tradeIndex: ref<inkHashMap>;
  private let m_tradeBusy: Bool;
  private let m_activeTradeID: TweakDBID;

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
      if !this.m_tradeBusy {
        this.m_tradeIndex = null;
        this.EnsureTradeIndex();
      };
      this.PopulateVehicleList();
      CarDealerLog(s"ArchiveXL detected: \(ArchiveXL.Version())");
      CarDealerLog(s"PurchasableVehicleSystem initialized, detected vehicles: \(ArraySize(this.m_storeVehicles))");
      this.DeactivateSoldVehicles();
    };
  }

  public func DeactivateSoldVehicles() -> Void {
    for id in this.m_soldVehicles {
      // Reentrant hooks must not revoke a provisional repurchase.
      if !this.IsTradeBlocked(id) {
        RemoveVehicle(this.GetGameInstance(), this.m_vehicleSystem, id);
      };
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
    if this.m_tradeBusy || !IsDefined(this.m_vehicleSystem) || !TDBID.IsValid(id) {
      CarDealerLog(s"Failed to purchase vehicle with invalid ID: \(TDBID.ToStringDEBUG(id))");
      return false;
    };
    if this.HasPendingTrade(id) {
      FTLog(s"Skipped unresolved vehicle grant: \(TDBID.ToStringDEBUG(id))");
      return false;
    };
    this.m_tradeBusy = true;
    this.m_activeTradeID = id;
    if !this.m_vehicleSystem.EnablePlayerVehicleID(id, true) {
      this.m_tradeBusy = false;
      CarDealerLog(s"Failed to purchase vehicle: \(TDBID.ToStringDEBUG(id))");
      return false;
    };
    SyncPersistentVehicles(this.GetGameInstance());
    this.SetSoldFlag(id, false);
    this.m_tradeBusy = false;
    return true;
  }

  public func BuyAll() -> Void {
    if this.m_tradeBusy {
      return;
    };
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
    if this.m_tradeBusy || !IsDefined(this.m_vehicleSystem) {
      return;
    };
    this.EnsureTradeIndex();
    this.m_tradeBusy = true;
    let vehicleSystem: ref<VehicleSystem> = GameInstance.GetVehicleSystem(this.GetGameInstance());
    let soldVehicles: array<TweakDBID> = this.m_soldVehicles;
    let failedVehicles: array<TweakDBID>;
    let restoredCount: Int32 = 0;
    ArrayClear(this.m_soldVehicles);
    for soldVehicle in soldVehicles {
      if this.HasPendingTrade(soldVehicle) {
        ArrayPush(this.m_soldVehicles, soldVehicle);
      };
    };
    for soldVehicle in soldVehicles {
      if this.HasPendingTrade(soldVehicle) {
        ArrayPush(failedVehicles, soldVehicle);
        FTLog(s"Skipped unresolved vehicle: \(TDBID.ToStringDEBUG(soldVehicle))");
      } else {
        if TDBID.IsValid(soldVehicle) {
          this.m_activeTradeID = soldVehicle;
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
    };
    this.m_soldVehicles = failedVehicles;
    if restoredCount > 0 {
      SyncPersistentVehicles(this.GetGameInstance());
    };
    FTLog(s"Vehicles restored: \(restoredCount)");
    this.m_tradeBusy = false;
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
            item.tradeResult = this.GetTradeState(vehicleId);
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
    return Equals(this.SellOwnedVehicleDetailed(player, data), VehicleTradeResult.Completed);
  }

  public func SellOwnedVehicleDetailed(player: ref<GameObject>, data: ref<AutofixerItemData>) -> VehicleTradeResult {
    if this.m_tradeBusy || !IsDefined(player) || !IsDefined(data) || !IsDefined(this.m_vehicleSystem) || !IsDefined(this.m_transactionSystem) || !TDBID.IsValid(data.vehicleID) || data.price < 0 {
      return VehicleTradeResult.Rejected;
    };
    if this.IsTradeBlocked(data.vehicleID) {
      return this.GetTradeState(data.vehicleID);
    };
    this.m_tradeBusy = true;
    this.m_activeTradeID = data.vehicleID;
    if ArrayContains(this.m_soldVehicles, data.vehicleID) || !this.IsPurchased(data.vehicleID) {
      this.m_tradeBusy = false;
      return VehicleTradeResult.Rejected;
    };
    return this.ExecuteTrade(player, data.vehicleID, data.price, VehicleTradeKind.Sale);
  }

  public func BuyVehicle(player: ref<GameObject>, bundle: ref<PurchasableVehicleBundle>, variant: ref<PurchasableVehicleVariant>) -> VehicleTradeResult {
    if this.m_tradeBusy || !IsDefined(player) || !IsDefined(bundle) || !IsDefined(variant) || !IsDefined(variant.record) || !IsDefined(this.m_vehicleSystem) || !IsDefined(this.m_transactionSystem) || bundle.price <= 0 {
      return VehicleTradeResult.Rejected;
    };
    let id: TweakDBID = variant.record.GetID();
    if !TDBID.IsValid(id) || !ArrayContains(this.m_storeVehicles, bundle) || !ArrayContains(bundle.variants, variant) {
      return VehicleTradeResult.Rejected;
    };
    if this.IsTradeBlocked(id) {
      return this.GetTradeState(id);
    };
    this.m_tradeBusy = true;
    this.m_activeTradeID = id;
    let cred: Int32 = Cast<Int32>(GameInstance.GetStatsSystem(player.GetGame()).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.StreetCred));
    if this.IsPurchased(id) || this.m_transactionSystem.GetItemQuantity(player, MarketSystem.Money()) < bundle.price || cred < bundle.cred {
      this.m_tradeBusy = false;
      return VehicleTradeResult.Rejected;
    };
    return this.ExecuteTrade(player, id, bundle.price, VehicleTradeKind.Purchase);
  }

  private func CreateTradeBackend(player: ref<GameObject>) -> ref<DealerGameTradeBackend> {
    let backend: ref<DealerGameTradeBackend> = new DealerGameTradeBackend();
    backend.system = this;
    backend.player = player;
    return backend;
  }

  private func ExecuteTrade(player: ref<GameObject>, id: TweakDBID, amount: Int32, kind: VehicleTradeKind) -> VehicleTradeResult {
    let operation: ref<VehicleTradeOperation> = new VehicleTradeOperation();
    operation.vehicleID = id;
    operation.kind = kind;
    operation.amount = amount;
    operation.initialOwned = Equals(kind, VehicleTradeKind.Sale);
    operation.wasSold = ArrayContains(this.m_soldVehicles, id);
    // A restored in-flight intent is reviewed, never replayed.
    ArrayPush(this.m_pendingTrades, operation);
    this.m_tradeIndex.Insert(TDBID.ToNumber(id), operation);
    let result: VehicleTradeResult = VehicleTradeProcessor.Execute(operation, this.CreateTradeBackend(player));
    if Equals(result, VehicleTradeResult.Completed) {
      this.SetSoldFlag(id, Equals(kind, VehicleTradeKind.Sale));
      this.RemoveTrade(operation);
    } else {
      this.SetSoldFlag(id, operation.wasSold);
      if Equals(result, VehicleTradeResult.Rejected) || Equals(result, VehicleTradeResult.RolledBack) {
        this.RemoveTrade(operation);
      };
    };
    this.m_tradeBusy = false;
    return result;
  }

  public func FinalizePaidPurchase(id: TweakDBID) -> Void {
    if this.m_tradeBusy && Equals(this.m_activeTradeID, id) {
      this.SetSoldFlag(id, false);
      SyncPersistentVehicles(this.GetGameInstance());
    };
  }

  private func SetSoldFlag(id: TweakDBID, sold: Bool) -> Void {
    if sold {
      if !ArrayContains(this.m_soldVehicles, id) {
        ArrayPush(this.m_soldVehicles, id);
      };
    } else {
      ArrayRemove(this.m_soldVehicles, id);
    };
  }

  public func IsTradeBlocked(id: TweakDBID) -> Bool {
    return this.m_tradeBusy && Equals(this.m_activeTradeID, id) || this.HasPendingTrade(id);
  }

  private func HasPendingTrade(id: TweakDBID) -> Bool {
    this.EnsureTradeIndex();
    return this.m_tradeIndex.KeyExist(TDBID.ToNumber(id));
  }

  public func GetTradeState(id: TweakDBID) -> VehicleTradeResult {
    this.EnsureTradeIndex();
    let operation: ref<VehicleTradeOperation> = this.m_tradeIndex.Get(TDBID.ToNumber(id)) as VehicleTradeOperation;
    if !IsDefined(operation) {
      return VehicleTradeResult.Rejected;
    };
    if Equals(operation.phase, VehicleTradePhase.CompensationPending) {
      return VehicleTradeResult.CompensationPending;
    };
    return VehicleTradeResult.ReviewRequired;
  }

  private func EnsureTradeIndex() -> Void {
    if IsDefined(this.m_tradeIndex) {
      return;
    };
    this.m_tradeIndex = new inkHashMap();
    if Equals(ArraySize(this.m_pendingTrades), 0) {
      return;
    };
    this.RestorePendingSoldFlags();
    let ownership: ref<inkHashMap>;
    let vehicles: array<PlayerVehicle>;
    if IsDefined(this.m_vehicleSystem) && ArraySize(this.m_pendingTrades) > 0 {
      // Recovery inspection shares one ownership snapshot across all records.
      ownership = new inkHashMap();
      this.m_vehicleSystem.GetPlayerUnlockedVehicles(vehicles);
      for vehicle in vehicles {
        ownership.Set(TDBID.ToNumber(vehicle.recordID), this);
      };
      vehicles = GetPersistentVehicles(this.GetGameInstance());
      for vehicle in vehicles {
        ownership.Set(TDBID.ToNumber(vehicle.recordID), this);
      };
    };
    let remaining: array<ref<VehicleTradeOperation>>;
    for operation in this.m_pendingTrades {
      if IsDefined(operation) {
        let compensationResolved: Bool = Equals(operation.phase, VehicleTradePhase.CompensationPending) && IsDefined(ownership) && Equals(ownership.KeyExist(TDBID.ToNumber(operation.vehicleID)), operation.initialOwned);
        if !compensationResolved {
          if NotEquals(operation.phase, VehicleTradePhase.CompensationPending) && NotEquals(operation.phase, VehicleTradePhase.ReviewRequired) {
            operation.phase = VehicleTradePhase.ReviewRequired;
            operation.failure = VehicleTradeFailure.Interrupted;
          };
          ArrayPush(remaining, operation);
          this.m_tradeIndex.Insert(TDBID.ToNumber(operation.vehicleID), operation);
        };
      };
    };
    this.m_pendingTrades = remaining;
  }

  private func RestorePendingSoldFlags() -> Void {
    let flags: ref<inkHashMap> = new inkHashMap();
    let restored: array<TweakDBID>;
    let operation: ref<VehicleTradeOperation>;
    for pending in this.m_pendingTrades {
      if IsDefined(pending) {
        flags.Set(TDBID.ToNumber(pending.vehicleID), pending);
      };
    };
    for id in this.m_soldVehicles {
      operation = flags.Get(TDBID.ToNumber(id)) as VehicleTradeOperation;
      if !IsDefined(operation) || operation.wasSold {
        ArrayPush(restored, id);
      };
      if IsDefined(operation) {
        flags.Remove(TDBID.ToNumber(id));
      };
    };
    for pending in this.m_pendingTrades {
      if IsDefined(pending) && pending.wasSold && flags.KeyExist(TDBID.ToNumber(pending.vehicleID)) {
        ArrayPush(restored, pending.vehicleID);
        flags.Remove(TDBID.ToNumber(pending.vehicleID));
      };
    };
    this.m_soldVehicles = restored;
  }

  private func RemoveTrade(operation: ref<VehicleTradeOperation>) -> Void {
    this.m_tradeIndex.Remove(TDBID.ToNumber(operation.vehicleID));
    ArrayRemove(this.m_pendingTrades, operation);
  }

  public func ListPendingTrades() -> Void {
    this.EnsureTradeIndex();
    for operation in this.m_pendingTrades {
      FTLog(s"VCD unresolved ID=\(TDBID.ToStringDEBUG(operation.vehicleID)) kind=\(operation.kind) phase=\(operation.phase) amount=\(operation.amount) restoreOwned=\(operation.initialOwned) wasSold=\(operation.wasSold) moneyAttempted=\(operation.moneyAttempted) moneyReturned=\(operation.moneyReturned) before=\(operation.balanceBefore) after=\(operation.balanceAfter) failure=\(operation.failure)");
    };
    FTLog(s"VCD unresolved count: \(ArraySize(this.m_pendingTrades))");
  }

  public func RetryTradeCompensation(id: TweakDBID, allowDisable: Bool) -> VehicleTradeResult {
    if this.m_tradeBusy || !IsDefined(this.m_vehicleSystem) {
      return VehicleTradeResult.Rejected;
    };
    this.EnsureTradeIndex();
    let operation: ref<VehicleTradeOperation> = this.m_tradeIndex.Get(TDBID.ToNumber(id)) as VehicleTradeOperation;
    if !IsDefined(operation) || NotEquals(operation.phase, VehicleTradePhase.CompensationPending) {
      return VehicleTradeResult.Rejected;
    };
    if !operation.initialOwned && this.IsPurchased(id) {
      FTLog(s"VCD compensation will DISABLE ownership of \(TDBID.ToStringDEBUG(id)); explicit allowDisable=true is required.");
      if !allowDisable {
        return VehicleTradeResult.Rejected;
      };
    };
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
    if !IsDefined(player) {
      return VehicleTradeResult.Rejected;
    };
    this.m_tradeBusy = true;
    this.m_activeTradeID = id;
    let result: VehicleTradeResult = VehicleTradeProcessor.Compensate(operation, this.CreateTradeBackend(player));
    if Equals(result, VehicleTradeResult.RolledBack) {
      this.SetSoldFlag(id, operation.wasSold);
      this.RemoveTrade(operation);
    };
    this.m_tradeBusy = false;
    return result;
  }

  public func AcknowledgeTradeReview(id: TweakDBID, completed: Bool) -> Bool {
    if this.m_tradeBusy || !IsDefined(this.m_vehicleSystem) {
      return false;
    };
    this.EnsureTradeIndex();
    let operation: ref<VehicleTradeOperation> = this.m_tradeIndex.Get(TDBID.ToNumber(id)) as VehicleTradeOperation;
    if !IsDefined(operation) || NotEquals(operation.phase, VehicleTradePhase.ReviewRequired) {
      return false;
    };
    let targetOwned: Bool = completed ? Equals(operation.kind, VehicleTradeKind.Purchase) : operation.initialOwned;
    if NotEquals(this.IsPurchased(id), targetOwned) {
      return false;
    };
    this.SetSoldFlag(id, completed ? Equals(operation.kind, VehicleTradeKind.Sale) : operation.wasSold);
    this.RemoveTrade(operation);
    FTLog(s"VCD operator acknowledged monetary outcome for \(TDBID.ToStringDEBUG(id)); completed=\(completed). No money was changed.");
    return true;
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.m_tradeIndex = null;
    this.m_tradeBusy = false;
  }

  private func OnDetach() -> Void {
    this.m_tradeIndex = null;
    this.m_tradeBusy = false;
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
