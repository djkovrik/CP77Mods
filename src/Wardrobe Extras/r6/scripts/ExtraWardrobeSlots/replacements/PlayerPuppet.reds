import ExtraWardrobeSlots.Utils.W

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
  let wardrobeSystem: wref<WardrobeSystemExtra>;
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
  this.TryScaleItemToPlayer(itemData);
  if IsDefined(itemData) {
    itemQuality = RPGManager.GetItemDataQuality(itemData);
    if itemData.HasTag(n"SkipActivityLog") || itemData.HasTag(n"SkipActivityLogOnLoot") || evt.flaggedAsSilent || itemData.HasTag(n"Currency") || ItemID.HasFlag(itemData.GetID(), gameEItemIDFlag.Preview) {
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
  wardrobeSystem = WardrobeSystemExtra.GetInstance(this.GetGame());
  if IsDefined(wardrobeSystem) && Equals(RPGManager.GetItemCategory(evt.itemID), gamedataItemCategory.Clothing) && !wardrobeSystem.IsItemBlacklisted(evt.itemID) {
    wardrobeSystem.StoreUniqueItemIDAndMarkNew(this.GetGame(), evt.itemID);
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
  if Equals(RPGManager.GetItemType(evt.itemID), gamedataItemType.Gen_Junk) && GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.CanAutomaticallyDisassembleJunk) > 0.00 {
    ItemActionsHelper.DisassembleItem(this, evt.itemID, GameInstance.GetTransactionSystem(this.GetGame()).GetItemQuantity(this, evt.itemID));
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

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  WardrobeSystemExtra.GetInstance(this.GetGame()).MigrateOldWardrobe();
}
