import ReducedLootExclusions.RL_Exclusions
import ReducedLootTypes.RL_LootSource
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
    GetPlayer(this.GetGame()).StoreItemId_RL(ItemID.GetTDBID(item));
  };
  return dispenseRequest;
}

@replaceMethod(WeaponVendingMachine)
protected func CreateDispenseRequest(shouldPay: Bool, item: ItemID) -> ref<DispenseRequest> {
  let dispenseRequest: ref<DispenseRequest> = new DispenseRequest();
  dispenseRequest.owner = this;
  dispenseRequest.position = this.RandomizePosition();
  dispenseRequest.shouldPay = shouldPay;
  if ItemID.IsValid(item) {
    dispenseRequest.itemID = ItemID.CreateQuery(ItemID.GetTDBID(item));
    // Always save spawned items
    GetPlayer(this.GetGame()).StoreItemId_RL(ItemID.GetTDBID(item));
  };
  return dispenseRequest;
}

@wrapMethod(gameItemDropObject)
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
  let tweakDbId: TweakDBID;

  playerPuppet = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  if IsDefined(playerPuppet) {
    tweakDbId = ItemID.GetTDBID(data.GetID());
    journalManager = GameInstance.GetJournalManager(playerPuppet.GetGame());
    trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
    preventDestroying = Equals(ItemID.GetTDBID(this.GetItemObject().GetItemID()), playerPuppet.GetStoredId_RL());
    shouldKeepForId = RL_Exclusions.KeepForItemId(tweakDbId) || RL_Exclusions.KeepForQ(tweakDbId) || RL_Exclusions.KeepForSQ(tweakDbId) || RL_Exclusions.KeepForMQ(tweakDbId);
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

      if preventDestroying {
        playerPuppet.ClearStoredId_RL();
      };
       
      if RL_Checker.CanLootThis(data, RL_LootSource.World) || preventDestroying || shouldKeepForId || shouldKeepForQuest || wasKept || Equals(data.GetItemType(), gamedataItemType.Gen_Keycard) {
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

  wrappedMethod(entID);
}

// -- EXPERIMENTAL HASH TRACKING
public class TrackerConfig {
  public static func CleanupThreshold() -> Int32 = 15000
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
  if !this.WasKept_RL(hash) {
    ArrayPush(this.m_keptItemHashes_RL, hash);
    RLog("?! kept hash " + hash + " saved, array size " + IntToString(ArraySize(this.m_keptItemHashes_RL)));
  };
}

@addMethod(PlayerPuppet)
public func SaveAsRemoved_RL(hash: String) -> Void {
  if !this.WasRemoved_RL(hash) {
    ArrayPush(this.m_removedItemHashes_RL, hash);
    RLog("?! removed hash" + hash + " saved, array size " + IntToString(ArraySize(this.m_removedItemHashes_RL)));
  };
}

@addMethod(PlayerPuppet)
public func WasKept_RL(hash: String) -> Bool {
  if this.m_scheduleKeptCleanup || ArraySize(this.m_keptItemHashes_RL) > TrackerConfig.CleanupThreshold() {
    ArrayClear(this.m_keptItemHashes_RL);
    this.m_scheduleKeptCleanup = false;
    RLog("?! Kept hashes array cleared");
  };
  return ArrayContains(this.m_keptItemHashes_RL, hash);
}

@addMethod(PlayerPuppet)
public func WasRemoved_RL(hash: String) -> Bool {
  if this.m_scheduleRemovedCleanup || ArraySize(this.m_removedItemHashes_RL) > TrackerConfig.CleanupThreshold()  {
    ArrayClear(this.m_removedItemHashes_RL);
    this.m_scheduleRemovedCleanup  = false;
    RLog("?! Removed hashes array cleared");
  };
  return ArrayContains(this.m_removedItemHashes_RL, hash);
}

@addMethod(PlayerPuppet)
public func ScheduleHaschesCleanup_RL() -> Void {
  this.m_scheduleKeptCleanup = true;
  this.m_scheduleRemovedCleanup = true;
  RLog("?! Hashes cleanup scheduled");
}

// Trigger cleanup on bed activation
@addField(dialogWidgetGameController)
private let m_lastSelectedHubTitle: String;

@replaceMethod(dialogWidgetGameController)
protected cb func OnDialogsSelectIndex(index: Int32) -> Bool {
  let playerPuppet: ref<PlayerPuppet>;
  // Save titles on interaction
  if ArraySize(this.m_data.choiceHubs) > 0 {
    this.m_lastSelectedHubTitle = this.m_data.choiceHubs[0].title;
  }

  this.m_selectedIndex = index;
  super.OnDialogsSelectIndex(index);

  // Check if hub title equals "Bed"
  // TODO: need to find a better place for schedule calling cuz this one is dirty
  if Equals(this.m_lastSelectedHubTitle, "LocKey#46418") && Equals(index, -1) {
    this.m_lastSelectedHubTitle = "";
    playerPuppet = this.GetPlayerControlledObject() as PlayerPuppet;
    if IsDefined(playerPuppet) {
      playerPuppet.ScheduleHaschesCleanup_RL();
    };
  };
}

