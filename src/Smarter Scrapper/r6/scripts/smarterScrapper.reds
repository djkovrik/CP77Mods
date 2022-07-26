class SmarterScrapperClothesConfig {
  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53753")
  @runtimeProperty("ModSettings.displayName", "LocKey#1815")
  public let legendary: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53753")
  @runtimeProperty("ModSettings.displayName", "LocKey#1813")
  public let epic: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53753")
  @runtimeProperty("ModSettings.displayName", "LocKey#1816")
  public let rare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53753")
  @runtimeProperty("ModSettings.displayName", "LocKey#1817")
  public let uncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53753")
  @runtimeProperty("ModSettings.displayName", "LocKey#1814")
  public let common: Bool = true;
}

class SmarterScrapperWeaponsConfig {
  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53751")
  @runtimeProperty("ModSettings.displayName", "LocKey#778")
  public let knife: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53751")
  @runtimeProperty("ModSettings.displayName", "LocKey#1815")
  public let legendary: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53751")
  @runtimeProperty("ModSettings.displayName", "LocKey#1813")
  public let epic: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53751")
  @runtimeProperty("ModSettings.displayName", "LocKey#1816")
  public let rare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53751")
  @runtimeProperty("ModSettings.displayName", "LocKey#1817")
  public let uncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#53751")
  @runtimeProperty("ModSettings.displayName", "LocKey#1814")
  public let common: Bool = true;
}

class SmarterScrapperModsConfig {
  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#49863")
  @runtimeProperty("ModSettings.displayName", "LocKey#1816")
  public let rare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#49863")
  @runtimeProperty("ModSettings.displayName", "LocKey#1817")
  public let uncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#49863")
  @runtimeProperty("ModSettings.displayName", "LocKey#1814")
  public let common: Bool = false;
}

class SmarterScrapperGrenadeConfig {
  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#76995")
  @runtimeProperty("ModSettings.displayName", "LocKey#1816")
  public let rare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#76995")
  @runtimeProperty("ModSettings.displayName", "LocKey#1817")
  public let uncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#76995")
  @runtimeProperty("ModSettings.displayName", "LocKey#1814")
  public let common: Bool = false;
}

class SmarterScrapperBounceBackConfig {
  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#23418")
  @runtimeProperty("ModSettings.displayName", "LocKey#35420")
  public let rare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#23418")
  @runtimeProperty("ModSettings.displayName", "LocKey#34157")
  public let uncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#23418")
  @runtimeProperty("ModSettings.displayName", "LocKey#35418")
  public let common: Bool = false;
}

class SmarterScrapperMaxDocConfig {
  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#23418")
  @runtimeProperty("ModSettings.displayName", "LocKey#35387")
  public let epic: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#23418")
  @runtimeProperty("ModSettings.displayName", "LocKey#2679")
  public let rare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Smarter Scrapper")
  @runtimeProperty("ModSettings.category", "LocKey#23418")
  @runtimeProperty("ModSettings.displayName", "LocKey#35384")
  public let uncommon: Bool = false;
}

@addMethod(PlayerPuppet)
public func IsExclusionSS(id: TweakDBID) -> Bool {
  return 
    // Stadium Love
    Equals(id, t"Items.Preset_MQ008_Nova") ||
    // Sasquatch Hammer
    Equals(id, t"Items.Preset_Hammer_Sasquatch") ||
    // Prologue
    Equals(id, t"Items.Preset_Nova_Q000_Nomad") ||
  false;
}

@addMethod(PlayerPuppet)
public func HasExcludedQuestActive() -> Bool {
  let journalManager: wref<JournalManager> = GameInstance.GetJournalManager(this.GetGame());
  let trackedObjective: wref<JournalQuestObjective> = journalManager.GetTrackedEntry() as JournalQuestObjective;
  return 
    // Starting tutorial
    Equals(trackedObjective.GetId(), "01a_pick_weapon") ||
    Equals(trackedObjective.GetId(), "01c_pick_up_reanimator") ||
    Equals(trackedObjective.GetId(), "03_pick_up_katana") ||
  false;
}

@addMethod(PlayerPuppet)
private func IsClothesSS(type: gamedataItemType) -> Bool {
  return
    Equals(type, gamedataItemType.Clo_Face) ||
    Equals(type, gamedataItemType.Clo_Feet) ||
    Equals(type, gamedataItemType.Clo_Head) ||
    Equals(type, gamedataItemType.Clo_InnerChest) ||
    Equals(type, gamedataItemType.Clo_Legs) ||
    Equals(type, gamedataItemType.Clo_OuterChest) ||
  false;
}

@addMethod(PlayerPuppet)
private func IsWeaponSS(type: gamedataItemType) -> Bool {
  return
    Equals(type, gamedataItemType.Wea_AssaultRifle) ||
    Equals(type, gamedataItemType.Wea_Hammer) ||
    Equals(type, gamedataItemType.Wea_Handgun) ||
    Equals(type, gamedataItemType.Wea_HeavyMachineGun) ||
    Equals(type, gamedataItemType.Wea_Katana) ||
    Equals(type, gamedataItemType.Wea_LightMachineGun) ||
    Equals(type, gamedataItemType.Wea_LongBlade) ||
    Equals(type, gamedataItemType.Wea_OneHandedClub) ||
    Equals(type, gamedataItemType.Wea_PrecisionRifle) ||
    Equals(type, gamedataItemType.Wea_Revolver) ||
    Equals(type, gamedataItemType.Wea_Rifle) ||
    Equals(type, gamedataItemType.Wea_ShortBlade) ||
    Equals(type, gamedataItemType.Wea_Shotgun) ||
    Equals(type, gamedataItemType.Wea_ShotgunDual) ||
    Equals(type, gamedataItemType.Wea_SniperRifle) ||
    Equals(type, gamedataItemType.Wea_SubmachineGun) ||
    Equals(type, gamedataItemType.Wea_TwoHandedClub) ||
  false;
}

@addMethod(PlayerPuppet)
private func IsModSS(type: gamedataItemType) -> Bool {
  return
    Equals(type, gamedataItemType.Prt_Mod) ||
    Equals(type, gamedataItemType.Prt_Muzzle) ||
    Equals(type, gamedataItemType.Prt_Scope) ||
    Equals(type, gamedataItemType.Prt_FabricEnhancer) ||
    Equals(type, gamedataItemType.Prt_HeadFabricEnhancer) ||
    Equals(type, gamedataItemType.Prt_FaceFabricEnhancer) ||
    Equals(type, gamedataItemType.Prt_OuterTorsoFabricEnhancer) ||
    Equals(type, gamedataItemType.Prt_TorsoFabricEnhancer) ||
    Equals(type, gamedataItemType.Prt_PantsFabricEnhancer) ||
    Equals(type, gamedataItemType.Prt_BootsFabricEnhancer) ||
    // Equals(type, gamedataItemType.Prt_Program ) ||
    // Equals(type, gamedataItemType.Prt_Capacitor) ||
    // Equals(type, gamedataItemType.Prt_HandgunMuzzle) ||
    // Equals(type, gamedataItemType.Prt_Magazine) ||
    // Equals(type, gamedataItemType.Prt_RifleMuzzle) ||
    // Equals(type, gamedataItemType.Prt_ScopeRail) ||
    // Equals(type, gamedataItemType.Prt_Stock) ||
    // Equals(type, gamedataItemType.Prt_TargetingSystem) ||
  false;
}

@addField(PlayerPuppet) public let scrapperClothes: ref<SmarterScrapperClothesConfig>;
@addField(PlayerPuppet) public let scrapperWeapons: ref<SmarterScrapperWeaponsConfig>;
@addField(PlayerPuppet) public let scrapperMods: ref<SmarterScrapperModsConfig>;
@addField(PlayerPuppet) public let scrapperGrenade: ref<SmarterScrapperGrenadeConfig>;
@addField(PlayerPuppet) public let scrapperBounceBack: ref<SmarterScrapperBounceBackConfig>;
@addField(PlayerPuppet) public let scrapperMaxDoc: ref<SmarterScrapperMaxDocConfig>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();

  this.scrapperClothes = new SmarterScrapperClothesConfig();
  this.scrapperWeapons = new SmarterScrapperWeaponsConfig();
  this.scrapperMods = new SmarterScrapperModsConfig();
  this.scrapperGrenade = new SmarterScrapperGrenadeConfig();
  this.scrapperBounceBack = new SmarterScrapperBounceBackConfig();
  this.scrapperMaxDoc = new SmarterScrapperMaxDocConfig();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  wrappedMethod();

  this.scrapperClothes = null;
  this.scrapperWeapons = null;
  this.scrapperMods = null;
  this.scrapperGrenade = null;
  this.scrapperBounceBack = null;
  this.scrapperMaxDoc = null;
}

@addMethod(PlayerPuppet)
private func ShouldBeScrappedSS(data: wref<gameItemData>, quality: gamedataQuality) -> Bool {
  let type: gamedataItemType = data.GetItemType();

  if this.IsClothesSS(type) {
    switch quality {
      case gamedataQuality.Legendary: return this.scrapperClothes.legendary;
      case gamedataQuality.Epic: return this.scrapperClothes.epic;
      case gamedataQuality.Rare: return this.scrapperClothes.rare;
      case gamedataQuality.Uncommon: return this.scrapperClothes.uncommon;
      case gamedataQuality.Common: return this.scrapperClothes.common;
    };
  };

  if this.IsWeaponSS(type) {
    switch quality {
      case gamedataQuality.Legendary: return this.scrapperWeapons.legendary;
      case gamedataQuality.Epic: return this.scrapperWeapons.epic;
      case gamedataQuality.Rare: return this.scrapperWeapons.rare;
      case gamedataQuality.Uncommon: return this.scrapperWeapons.uncommon;
      case gamedataQuality.Common: return this.scrapperWeapons.common;
    };
  };
  
  if Equals(type, gamedataItemType.Wea_Knife) && this.scrapperWeapons.knife {
    switch quality {
      case gamedataQuality.Legendary: return this.scrapperWeapons.legendary;
      case gamedataQuality.Epic: return this.scrapperWeapons.epic;
      case gamedataQuality.Rare: return this.scrapperWeapons.rare;
      case gamedataQuality.Uncommon: return this.scrapperWeapons.uncommon;
      case gamedataQuality.Common: return this.scrapperWeapons.common;
    };
  };

  if this.IsModSS(type) {
    switch quality {
      case gamedataQuality.Rare: return this.scrapperMods.rare;
      case gamedataQuality.Uncommon: return this.scrapperMods.uncommon;
      case gamedataQuality.Common: return this.scrapperMods.common;
    };
  };

  return false;
}

@addMethod(PlayerPuppet)
private func ShouldBeScrappedConsumableSS(data: wref<gameItemData>, quality: gamedataQuality) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  
  if Equals(type, gamedataItemType.Gad_Grenade) {
    switch quality {
      case gamedataQuality.Rare: return this.scrapperGrenade.rare;
      case gamedataQuality.Uncommon: return this.scrapperGrenade.uncommon;
      case gamedataQuality.Common: return this.scrapperGrenade.common;
    };
  };
  
  if Equals(type, gamedataItemType.Con_Injector) {
    switch quality {
      case gamedataQuality.Rare: return this.scrapperBounceBack.rare;
      case gamedataQuality.Uncommon: return this.scrapperBounceBack.uncommon;
      case gamedataQuality.Common: return this.scrapperBounceBack.common;
    };
  };
  
  if Equals(type, gamedataItemType.Con_Inhaler) {
    switch quality {
      case gamedataQuality.Epic: return this.scrapperMaxDoc.epic;
      case gamedataQuality.Rare: return this.scrapperMaxDoc.rare;
      case gamedataQuality.Uncommon: return this.scrapperMaxDoc.uncommon;
    };
  };

  return false;
}

// Keep last bought item id
@addField(PlayerPuppet)
public let boughtItem: ItemID;

// Save last bought item id
@wrapMethod(Vendor)
private final func PerformItemTransfer(buyer: wref<GameObject>, seller: wref<GameObject>, itemTransaction: SItemTransaction) -> Bool {
  let player: ref<PlayerPuppet> = buyer as PlayerPuppet;
  if IsDefined(player) {
    player.boughtItem = itemTransaction.itemStack.itemID;
  };
  return wrappedMethod(buyer, seller, itemTransaction);
}

@addMethod(PlayerPuppet)
public func HasWeaponInInventorySS() -> Bool {
  let itemList: array<wref<gameItemData>>;
  let item: wref<gameItemData>;
  GameInstance.GetTransactionSystem(this.GetGame()).GetItemList(this, itemList);
  let i: Int32 = 0;
  let counter: Int32 = 0;
  while i < ArraySize(itemList) {
    item = itemList[i];
    if this.IsWeaponSS(item.GetItemType()) && NotEquals(item.GetName(), n"w_handgun_constitutional_unity") {
      counter += 1;
    };
    i += 1;
  };
  return counter > 1;
}

// Runs when item added to inventory
@replaceMethod(PlayerPuppet)
protected cb func OnItemAddedToInventory(evt: ref<ItemAddedEvent>) -> Bool {
  let drawItemRequest: ref<DrawItemRequest>;
  let entryString: String;
  let eqSystem: wref<EquipmentSystem>;
  let itemData: wref<gameItemData>;
  let itemLogDataData: ItemID;
  let itemName: String;
  let itemQuality: gamedataQuality;
  let itemRecord: ref<Item_Record>;
  let questSystem: ref<QuestsSystem>;
  let shouldUpdateLog: Bool;
  let wardrobeSystem: wref<WardrobeSystem>;
  let tweakDbId: TweakDBID; // <- new
  if !ItemID.IsValid(evt.itemID) {
    return false;
  };
  itemData = evt.itemData;
  tweakDbId = ItemID.GetTDBID(itemData.GetID()); // <- new
  questSystem = GameInstance.GetQuestsSystem(this.GetGame());
  itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(evt.itemID));
  itemLogDataData = evt.itemID;
  if !itemRecord.IsSingleInstance() {
    this.UpdateInventoryWeight(RPGManager.GetItemWeight(itemData));
  };
  this.TryScaleItemToPlayer(itemData);
  if IsDefined(itemData) {
    itemQuality = RPGManager.GetItemDataQuality(itemData);
    if itemData.HasTag(n"SkipActivityLog") || itemData.HasTag(n"SkipActivityLogOnLoot") || evt.flaggedAsSilent || itemData.HasTag(n"Currency") {
      shouldUpdateLog = false;
    } else {
      shouldUpdateLog = true;
    };
    if shouldUpdateLog {
      itemName = UIItemsHelper.GetItemName(itemRecord, itemData);
      GameInstance.GetActivityLogSystem(this.GetGame()).AddLog(GetLocalizedText("UI-ScriptExports-Looted") + ": " + itemName);
    };
  };
  if IsDefined(this.m_itemLogBlackboard) {
    this.m_itemLogBlackboard.SetVariant(GetAllBlackboardDefs().UI_ItemLog.ItemLogItem, ToVariant(itemLogDataData), true);
  };
  eqSystem = GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
  if IsDefined(eqSystem) {
    if ItemID.IsValid(evt.itemID) {
    };
    if Equals(RPGManager.GetItemCategory(evt.itemID), gamedataItemCategory.Weapon) && IsDefined(itemData) && itemData.HasTag(n"TakeAndEquip") {
      drawItemRequest = new DrawItemRequest();
      drawItemRequest.owner = this;
      drawItemRequest.itemID = evt.itemID;
      eqSystem.QueueRequest(drawItemRequest);
    };
  };
  wardrobeSystem = GameInstance.GetWardrobeSystem(this.GetGame());
  if IsDefined(wardrobeSystem) && Equals(RPGManager.GetItemCategory(evt.itemID), gamedataItemCategory.Clothing) {
    wardrobeSystem.StoreUniqueItemID(evt.itemID);
  };
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Con_Skillbook) {
    GameInstance.GetTelemetrySystem(this.GetGame()).LogSkillbookUsed(this, evt.itemID);
    ItemActionsHelper.LearnItem(this, evt.itemID, true);
    this.SetWarningMessage(GetLocalizedText("LocKey#46534") + "\\n" + GetLocalizedText(LocKeyToString(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(evt.itemID)).LocalizedDescription())));
  };
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Gen_Readable) {
    GameInstance.GetTransactionSystem(this.GetGame()).RemoveItem(this, evt.itemID, 1);
    entryString = ReadAction.GetJournalEntryFromAction(ItemActionsHelper.GetReadAction(evt.itemID).GetID());
    GameInstance.GetJournalManager(this.GetGame()).ChangeEntryState(entryString, "gameJournalOnscreen", gameJournalEntryState.Active, JournalNotifyOption.Notify);
  };
  // New logic
  if GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.CanAutomaticallyDisassembleJunk) > 0.00 {
    if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Gen_Junk) {
      ItemActionsHelper.DisassembleItem(this, evt.itemID, GameInstance.GetTransactionSystem(this.GetGame()).GetItemQuantity(this, evt.itemID));
    } else {
      if this.HasWeaponInInventorySS() && this.ShouldBeScrappedSS(itemData, itemQuality) && !RPGManager.IsItemIconic(itemData) && NotEquals(this.boughtItem, itemData.GetID()) && !RPGManager.IsItemCrafted(itemData) && !itemData.HasTag(n"Quest") && !this.IsExclusionSS(tweakDbId) && !this.HasExcludedQuestActive() {
        ItemActionsHelper.DisassembleItem(this, evt.itemID, GameInstance.GetTransactionSystem(this.GetGame()).GetItemQuantity(this, evt.itemID));
      } else {
	    if this.ShouldBeScrappedConsumableSS(itemData, itemQuality) && !itemData.HasTag(n"Quest") && !this.IsExclusionSS(tweakDbId) && !this.HasExcludedQuestActive() {
          ItemActionsHelper.DisassembleItem(this, evt.itemID, GameInstance.GetTransactionSystem(this.GetGame()).GetItemQuantity(this, evt.itemID));
		};
      };
    };
  };
  // Default logic
  //if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Gen_Junk) && GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.CanAutomaticallyDisassembleJunk) > 0.00 {
  //  ItemActionsHelper.DisassembleItem(this, evt.itemID, GameInstance.GetTransactionSystem(this.GetGame()).GetItemQuantity(this, evt.itemID));
  // };
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Con_Ammo) {
    GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_EquipmentData).SetBool(GetAllBlackboardDefs().UI_EquipmentData.ammoLooted, true);
    GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_EquipmentData).SignalBool(GetAllBlackboardDefs().UI_EquipmentData.ammoLooted);
  };
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Gen_Keycard) {
    this.GotKeycardNotification();
  };
  if questSystem.GetFact(n"disable_tutorials") == 0 && questSystem.GetFact(n"q001_show_sts_tut") > 0 {
    if Equals(RPGManager.GetWeaponEvolution(evt.itemID), gamedataWeaponEvolution.Smart) && questSystem.GetFact(n"smart_weapon_tutorial") == 0 {
      questSystem.SetFact(n"smart_weapon_tutorial", 1);
    };
    if Equals(RPGManager.GetWeaponEvolution(evt.itemID), gamedataWeaponEvolution.Tech) && RPGManager.IsTechPierceEnabled(this.GetGame(), this, evt.itemID) && questSystem.GetFact(n"tech_weapon_tutorial") == 0 {
      questSystem.SetFact(n"tech_weapon_tutorial", 1);
    };
    if Equals(RPGManager.GetItemCategory(evt.itemID), gamedataItemCategory.Gadget) && questSystem.GetFact(n"grenade_inventory_tutorial") == 0 {
      questSystem.SetFact(n"grenade_inventory_tutorial", 1);
    };
    if Equals(RPGManager.GetItemCategory(evt.itemID), gamedataItemCategory.Cyberware) && questSystem.GetFact(n"cyberware_inventory_tutorial") == 0 {
      questSystem.SetFact(n"cyberware_inventory_tutorial", 1);
    };
    if (Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Con_Inhaler) || Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Con_Injector)) && questSystem.GetFact(n"consumable_inventory_tutorial") == 0 {
      questSystem.SetFact(n"consumable_inventory_tutorial", 1);
    };
    if Equals(RPGManager.GetWeaponEvolution(evt.itemID), gamedataWeaponEvolution.Power) && RPGManager.IsRicochetChanceEnabled(this.GetGame(), this, evt.itemID) && questSystem.GetFact(n"power_weapon_tutorial") == 0 && evt.itemID != ItemID.CreateQuery(t"Items.Preset_V_Unity_Cutscene") && evt.itemID != ItemID.CreateQuery(t"Items.Preset_V_Unity") {
      questSystem.SetFact(n"power_weapon_tutorial", 1);
    };
    if RPGManager.IsItemIconic(evt.itemData) && questSystem.GetFact(n"iconic_item_tutorial") == 0 {
      questSystem.SetFact(n"iconic_item_tutorial", 1);
    };
  };
  if questSystem.GetFact(n"initial_gadget_picked") == 0 {
    if Equals(RPGManager.GetItemCategory(evt.itemID), gamedataItemCategory.Gadget) {
      questSystem.SetFact(n"initial_gadget_picked", 1);
    };
  };
  RPGManager.ProcessOnLootedPackages(this, evt.itemID);
  if Equals(itemQuality, gamedataQuality.Legendary) || Equals(itemQuality, gamedataQuality.Iconic) {
    GameInstance.GetAutoSaveSystem(this.GetGame()).RequestCheckpoint();
  };
}
