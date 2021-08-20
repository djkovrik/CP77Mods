// -- Prevents auto disassembling for valuable junk by setting 
//    the upper price threshold for Scrapper perk logic

class SmarterScrapperConfig {
  // Skip items which price above this value
  public static func PriceThreshold() -> Int32 = 25
}

public static func CanBeScrapped_mod(owner: ref<GameObject>, itemId: ItemID) -> Bool {
  return RPGManager.CalculateSellPrice(owner.GetGame(), owner, itemId) <= SmarterScrapperConfig.PriceThreshold();
}

// Runs for current items when you unlock Scrapper perk
@replaceMethod(DisassembleOwnedJunkEffector)
protected func ActionOn(owner: ref<GameObject>) -> Void {
  let i: Int32;
  let list: array<wref<gameItemData>>;
  GameInstance.GetTransactionSystem(owner.GetGame()).GetItemListByTag(owner, n"Junk", list);
  i = 0;
  while i < ArraySize(list) {
    if CanBeScrapped_mod(owner, list[i].GetID()) {
      ItemActionsHelper.DisassembleItem(owner, list[i].GetID(), list[i].GetQuantity());
    };
    i += 1;
  };
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
  let scalingMod: ref<gameStatModifierData>;
  let shouldUpdateLog: Bool;
  if !ItemID.IsValid(evt.itemID) {
    return false;
  };
  itemData = evt.itemData;
  questSystem = GameInstance.GetQuestsSystem(this.GetGame());
  itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(evt.itemID));
  itemLogDataData = evt.itemID;
  if !itemRecord.IsSingleInstance() {
    this.UpdateInventoryWeight(RPGManager.GetItemWeight(itemData));
  };
  if TweakDBInterface.GetBool(ItemID.GetTDBID(evt.itemID) + t".scaleToPlayer", false) && itemData.GetStatValueByType(gamedataStatType.PowerLevel) <= 1.00 {
    GameInstance.GetStatsSystem(this.GetGame()).RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.PowerLevel, true);
    scalingMod = RPGManager.CreateStatModifier(gamedataStatType.PowerLevel, gameStatModifierType.Additive, GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast(this.GetEntityID()), gamedataStatType.PowerLevel));
    GameInstance.GetStatsSystem(this.GetGame()).AddSavedModifier(itemData.GetStatsObjectID(), scalingMod);
  };
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
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Con_Skillbook) {
    GameInstance.GetTelemetrySystem(this.GetGame()).LogSkillbookUsed(ToTelemetryInventoryItem(this, evt.itemID));
    ItemActionsHelper.LearnItem(this, evt.itemID, true);
    this.SetWarningMessage(GetLocalizedText("LocKey#46534") + "\\n" + GetLocalizedText(LocKeyToString(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(evt.itemID)).LocalizedDescription())));
  };
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Gen_Readable) {
    GameInstance.GetTransactionSystem(this.GetGame()).RemoveItem(this, evt.itemID, 1);
    entryString = ReadAction.GetJournalEntryFromAction(ItemActionsHelper.GetReadAction(evt.itemID).GetID());
    GameInstance.GetJournalManager(this.GetGame()).ChangeEntryState(entryString, "gameJournalOnscreen", gameJournalEntryState.Active, JournalNotifyOption.Notify);
  };
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Gen_Junk) && GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast(this.GetEntityID()), gamedataStatType.CanAutomaticallyDisassembleJunk) > 0.00 {
    ItemActionsHelper.DisassembleItem(this, evt.itemID, GameInstance.GetTransactionSystem(this.GetGame()).GetItemQuantity(this, evt.itemID));
    // Scrapper check passed, dissasemble request here
    if CanBeScrapped_mod(this, evt.itemID) {
      ItemActionsHelper.DisassembleItem(this, evt.itemID, GameInstance.GetTransactionSystem(this.GetGame()).GetItemQuantity(this, evt.itemID));
    };
  };
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
