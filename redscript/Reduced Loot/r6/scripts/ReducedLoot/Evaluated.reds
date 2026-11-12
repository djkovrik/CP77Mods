module ReducedLoot

public struct ReducedLootStack {
  public let id: ItemID;
  public let quantity: Int32;
  public let category: Int32;
}

public abstract class ReducedLootPolicy {
  public final static func Category(record: wref<Item_Record>) -> Int32 {
    let id: TweakDBID;
    let kind: gamedataItemType;
    let consumable: ref<ConsumableItem_Record>;
    if !IsDefined(record) || !IsDefined(record.ItemType()) || !IsDefined(record.ItemCategory()) { return -1; };
    if ReducedLootProtectsRecord(record) { return -1; };
    id = record.GetID();
    kind = record.ItemType().Type();
    if record.TagsContains(n"Recipe") {
      if Equals(id, t"Items.LegendaryOmahaRecipe") { return 11; };
      return -1;
    };
    if IsDefined(record as ItemRecipe_Record) { return -1; };
    if Equals(kind, gamedataItemType.Con_LongLasting) {
      consumable = record as ConsumableItem_Record;
      if IsDefined(consumable) && IsDefined(consumable.ConsumableBaseName()) {
        switch consumable.ConsumableBaseName().Type() {
          case gamedataConsumableBaseName.HealthBooster:
          case gamedataConsumableBaseName.StaminaBooster:
          case gamedataConsumableBaseName.MemoryBooster:
          case gamedataConsumableBaseName.CarryCapacityBooster:
          case gamedataConsumableBaseName.OxyBooster:
            return 5;
        };
      };
    };
    switch id {
      case t"Items.GenericJunkItem3":
      case t"Items.GenericJunkItem4":
      case t"Items.GenericJunkItem5":
      case t"Items.GenericJunkItem7":
      case t"Items.GenericJunkItem8":
      case t"Items.GenericJunkItem9":
      case t"Items.GenericJunkItem10":
        return Equals(kind, gamedataItemType.Gen_Junk) ? 1 : -1;
      case t"Items.Glasses_01_basic_03":
        return Equals(kind, gamedataItemType.Clo_Face) ? 2 : -1;
      case t"Items.Helmet_03_old_01":
        return Equals(kind, gamedataItemType.Clo_Head) ? 2 : -1;
      case t"Items.FormalShoes_01_basic_01":
        return Equals(kind, gamedataItemType.Clo_Feet) ? 2 : -1;
      case t"Items.Undershirt_03_basic_04":
        return Equals(kind, gamedataItemType.Clo_InnerChest) ? 2 : -1;
      case t"Items.Pants_09_old_03":
        return Equals(kind, gamedataItemType.Clo_Legs) ? 2 : -1;
      case t"Items.FirstAidWhiffVLegendaryPlus":
        return Equals(kind, gamedataItemType.Con_Inhaler) ? 4 : -1;
      case t"Items.BonesMcCoy70VLegendaryPlus":
        return Equals(kind, gamedataItemType.Con_Injector) ? 4 : -1;
      case t"Items.GrenadeEMPLegendaryPlus":
        return Equals(kind, gamedataItemType.Gad_Grenade) ? 6 : -1;
      case t"Items.w_att_scope_sniper_01_legendary":
        return Equals(kind, gamedataItemType.Prt_PowerSniperScope) ? 9 : -1;
      case t"Items.MemoryWipeLvl4Program":
        return Equals(kind, gamedataItemType.Prt_Program) ? 10 : -1;
      case t"Items.money":
        return Equals(kind, gamedataItemType.Gen_Misc) ? 0 : -1;
      case t"Items.GoodQualityDrink4":
      case t"Items.TopQualityAlcohol1":
        return Equals(kind, gamedataItemType.Con_Edible) ? 3 : -1;
      case t"Ammo.HandgunAmmo":
      case t"Ammo.RifleAmmo":
      case t"Ammo.ShotgunAmmo":
      case t"Ammo.SniperRifleAmmo":
        return Equals(kind, gamedataItemType.Con_Ammo) ? 7 : -1;
      case t"Items.CommonMaterial1":
      case t"Items.UncommonMaterial1":
      case t"Items.RareMaterial1":
      case t"Items.EpicMaterial1":
      case t"Items.LegendaryMaterial1":
      case t"Items.QuickHackUncommonMaterial1":
      case t"Items.QuickHackRareMaterial1":
      case t"Items.QuickHackEpicMaterial1":
      case t"Items.QuickHackLegendaryMaterial1":
        return Equals(kind, gamedataItemType.Gen_CraftingMaterial) ? 8 : -1;
    };
    return -1;
  }

  public final static func Snapshot(data: wref<gameItemData>, out stack: ReducedLootStack) -> Bool {
    if !IsDefined(data) || !ItemID.IsValid(data.GetID()) || data.GetQuantity() <= 0 { return false; };
    if ReducedLootProtectsItem(data) { return false; };
    stack.id = data.GetID();
    stack.quantity = data.GetQuantity();
    stack.category = ReducedLootPolicy.Category(TweakDBInterface.GetItemRecord(stack.id.id));
    return stack.category >= 0;
  }

  public final static func Remove(system: ref<ReducedLootSession>, epoch: Uint32, owner: ref<GameObject>, source: EntityID, stack: ReducedLootStack) -> Void {
    let ts: ref<TransactionSystem>;
    let current: ReducedLootStack;
    let data: wref<gameItemData>;
    let container: ref<gameLootContainerBase>;
    let body: ref<NPCPuppet>;
    if !IsDefined(owner) || !IsDefined(system) || !system.Active() || system.epoch != epoch || NotEquals(ReducedLootSession.Get(owner.GetGame()), system) { return; };
    if source.hash == 0ul || NotEquals(owner.GetEntityID(), source) || NotEquals(GameInstance.FindEntityByID(owner.GetGame(), source), owner) { return; };
    ts = GameInstance.GetTransactionSystem(owner.GetGame());
    data = ts.GetItemData(owner, stack.id);
    if !IsDefined(data) || !ReducedLootSession.Exact(data.GetID(), stack.id) || data.GetQuantity() != stack.quantity { return; };
    if !ReducedLootPolicy.Snapshot(data, current) || current.category != stack.category || system.PersonalWeapon(stack.id, false) { return; };
    // The caller has consumed the source claim. Failure or an unexpected remainder must never trigger a retry.
    container = owner as gameLootContainerBase;
    body = owner as NPCPuppet;
    if IsDefined(container) {
      if !container.ReducedLootOrdinaryCase() { return; };
    } else {
      if !IsDefined(body) || body.IsQuest() || body.IsCrowd() || !body.WasLootGenerated() { return; };
    };
    if !system.Active() || system.epoch != epoch { return; };
    if !ts.RemoveItem(owner, stack.id, stack.quantity) || ts.GetItemQuantity(owner, stack.id) != 0 {
      ModLog(n"ReducedLoot", "Whole-stack removal was refused or the remainder changed. Source claim retained.");
    } else {
      if IsDefined(body) { system.ConfirmBodyRemoval(source.hash, epoch, stack.id); };
    };
  }

  public final static func SlotCategory(slot: ref<gameLootSlot>) -> Int32 {
    let fixed: ref<gameLootSlotSingleItem>;
    let path: ResRef = slot.GetTemplatePath();
    if !ResRef.IsValid(path) || slot.useAreaLoot || slot.IsQuest() || slot.IsDisabled() { return -1; };
    if Equals(path, r"base\\gameplay\\loot\\tokens\\general_single_item_token.ent") && Equals(slot.GetClassName(), n"gameLootSlotSingleItem") && ArraySize(slot.lootTables) == 0 && !TDBID.IsValid(slot.contentAssignment) {
      fixed = slot as gameLootSlotSingleItem;
      return ReducedLootPolicy.Category(TweakDBInterface.GetItemRecord(fixed.itemTDBID));
    };
    if ReducedLootIsMoneyPlacement(slot, path) { return 0; };
    return -1;
  }
}

public func ReducedLootProtectsItem(data: wref<gameItemData>) -> Bool {
  return data.HasTag(n"Quest")
    || data.HasTag(n"Iconic")
    || data.HasTag(n"UnequipBlocked")
    || data.HasTag(n"PermanentFood")
    || data.HasTag(n"Readable")
    || data.HasTag(n"Shard")
    || data.HasTag(n"Keycard")
    || RPGManager.IsItemIconic(data);
}
