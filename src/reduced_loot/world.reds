import ReducedLootExclusions.RL_Exclusions
import ReducedLootTypes.RL_LootSource
import ReducedLootDeclarations.*
import ReducedLootUtils.*

@replaceMethod(VendingMachine)
protected func CreateDispenseRequest(shouldPay: Bool, item: ItemID) -> ref<DispenseRequest> {
  let dispenseRequest: ref<DispenseRequest> = new DispenseRequest();
  dispenseRequest.owner = this;
  dispenseRequest.position = this.RandomizePosition();
  dispenseRequest.shouldPay = shouldPay;
  if ItemID.IsValid(item) {
    dispenseRequest.itemID = item;
    // Always save spawned items
    GetPlayer(this.GetGame()).StoreItemId_RL(item);
  };
  return dispenseRequest;
}

@replaceMethod(gameItemDropObject)
protected final func OnItemEntitySpawned(entID: EntityID) -> Void {
  let playerPuppet: ref<PlayerPuppet>;
  let data: ref<gameItemData> = this.GetItemObject().GetItemData();
  let journalManager: wref<JournalManager>;
  let trackedObjective: wref<JournalQuestObjective>;
  let preventDestroying: Bool = false;
  let shouldKeepForId: Bool = false;
  let shouldKeepForQuest: Bool = false;
  let isHeldWeapon: Bool = false;
  let wasKept: Bool = false;
  let wasRemoved: Bool = false;
  let hash: String = this.GetSimpleHash_RL();

  playerPuppet = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  if IsDefined(playerPuppet) {
    journalManager = GameInstance.GetJournalManager(playerPuppet.GetGame());
    trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
    preventDestroying = Equals(this.GetItemObject().GetItemID(), playerPuppet.GetStoredId_RL());
    shouldKeepForId = RL_Exclusions.KeepForItemId(ItemID.GetTDBID(data.GetID()));
    shouldKeepForQuest = RL_Exclusions.KeepForQuestTarget(trackedObjective.GetId());
    isHeldWeapon = RL_Utils.IsWeapon(data) && data.GetShouldKeep_RL();
    wasKept = playerPuppet.WasKept_RL(hash);
    wasRemoved = playerPuppet.WasRemoved_RL(hash);

    if isHeldWeapon {
      RLog("> Held weapon check:");
      RLog("? Item TDBID: " + TDBID.ToStringDEBUG(ItemID.GetTDBID(data.GetID())));
      RLog("? keep for id: " + BoolToString(shouldKeepForId) + ", no destroy: " + BoolToString(preventDestroying) + ", keep for quest: " + BoolToString(shouldKeepForQuest) + ", was held: " + BoolToString(isHeldWeapon));
      if RL_Checker.CanLootThis(data, RL_LootSource.Held) {
        RLog("+ kept for world " + ToStr(data));
      } else {
        RLog("- removed from world " + ToStr(data));
        EntityGameInterface.Destroy(this.GetEntity());
        return ;
      };
    } else {
      RLog("> World check:");
      RLog("? Item TDBID: " + TDBID.ToStringDEBUG(ItemID.GetTDBID(data.GetID())));
      RLog("? Current quest objective: " + trackedObjective.GetId());
      RLog("? keep for id: " + BoolToString(shouldKeepForId) + ", no destroy: " + BoolToString(preventDestroying) + ", keep for quest: " + BoolToString(shouldKeepForQuest) + ", was held: " + BoolToString(isHeldWeapon));
      
      if wasRemoved {
        RLog(">>> was previously removed from world " + ToStr(data));
        EntityGameInterface.Destroy(this.GetEntity());
        return ;
      };

      if wasKept {
        RLog(">>> was previously kept for world " + ToStr(data));
      };
       
      if RL_Checker.CanLootThis(data, RL_LootSource.World) || preventDestroying || shouldKeepForId || shouldKeepForQuest || wasKept {
        RLog("+ kept for world " + ToStr(data));
        playerPuppet.SaveAsKept_RL(hash);
      } else {
        RLog("- removed from world " + ToStr(data));
        playerPuppet.SaveAsRemoved_RL(hash);
        EntityGameInterface.Destroy(this.GetEntity());
        return ;
      };
    };
  };

  this.SetQualityRangeInteractionLayerState(true);
  this.EvaluateLootQualityEvent(entID);
  this.RequestHUDRefresh();
}

// -- EXPERIMENTAL HASH TRACKING
public class TrackerConfig {
  // Array size which triggers saved hashes clean
  // 10k too much? too low? TODO: check
  public static func CleanupThreshold() -> Int32 = 10000
}

@addMethod(gameItemDropObject)
public func GetSimpleHash_RL() -> String {
  return Vector4.ToString(this.GetWorldPosition());
}

@addField(PlayerPuppet)
private let m_keptItemHashes_RL: array<String>;

@addField(PlayerPuppet)
private let m_removedItemHashes_RL: array<String>;

@addField(PlayerPuppet)
private let m_scheduleKeptCleanup: Bool;

@addField(PlayerPuppet)
private let m_scheduleRemovedCleanup: Bool;

@addMethod(PlayerPuppet)
public func SaveAsKept_RL(hash: String) -> Void {
  if ArraySize(this.m_keptItemHashes_RL) > TrackerConfig.CleanupThreshold() {
    ArrayClear(this.m_keptItemHashes_RL);
  };
  if !this.WasKept_RL(hash) {
    ArrayPush(this.m_keptItemHashes_RL, hash);
  };
}

@addMethod(PlayerPuppet)
public func SaveAsRemoved_RL(hash: String) -> Void {
  if ArraySize(this.m_removedItemHashes_RL) > TrackerConfig.CleanupThreshold()  {
    ArrayClear(this.m_removedItemHashes_RL);
  };
  if !this.WasRemoved_RL(hash) {
    ArrayPush(this.m_removedItemHashes_RL, hash);
  };
}

@addMethod(PlayerPuppet)
public func WasKept_RL(hash: String) -> Bool {
  return ArrayContains(this.m_keptItemHashes_RL, hash);
}

@addMethod(PlayerPuppet)
public func WasRemoved_RL(hash: String) -> Bool {
  return ArrayContains(this.m_removedItemHashes_RL, hash);
}
