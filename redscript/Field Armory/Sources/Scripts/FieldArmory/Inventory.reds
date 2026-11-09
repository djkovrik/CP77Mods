module FieldArmory

public class ArmoryItem {
  public let data: ref<gameItemData>;
  public let carried: Bool;
  public let next: ref<ArmoryItem>;

  public func Name() -> String {
    return GetLocalizedTextByKey(RPGManager.GetItemRecord(this.data.GetID()).DisplayName());
  }

  public func Title() -> String {
    let record = RPGManager.GetItemRecord(this.data.GetID());
    let text = GetLocalizedTextByKey(record.DisplayName());
    if Equals(record.EquipArea().Type(), gamedataEquipmentArea.Weapon) {
      let parts = this.PartsLabel();
      if StrLen(parts) > 0 { text += " · " + parts; }
    };
    return text;
  }

  public func PartsLabel() -> String {
    let slots: array<TweakDBID>;
    this.data.GetUsedSlotsOnItem(slots);
    let text = "";

    for slot in slots {
      let part: InnerItemData;
      this.data.GetItemPart(part, slot);
      let id = InnerItemData.GetItemID(part);
      if ItemID.IsValid(id) {
        let name = GetLocalizedTextByKey(RPGManager.GetItemRecord(id).DisplayName());
        if StrLen(name) > 0 {
          if StrLen(text) > 0 { text += " · "; }
          text += name;
        }
      };
    };
    return text;
  }

}

public class InventorySnapshot {
  public let access: ref<StashAccess>;
  public let current: ref<Loadout>;
  public let weapons: array<ref<ArmoryItem>>;
  public let carriedWeapons: Int32;
  public let gadgets: array<ref<ArmoryItem>>;
  public let heals: array<ref<ArmoryItem>>;
  private let index: ref<inkHashMap>;
  private let best: ref<inkHashMap>;

  public static func Read(access: ref<StashAccess>) -> ref<InventorySnapshot> {
    let view = new InventorySnapshot();
    view.access = access;
    view.current = Loadout.Capture(access.player);
    view.index = new inkHashMap();
    view.best = new inkHashMap();
    view.ReadOwner(access.player, true);
    view.carriedWeapons = ArraySize(view.weapons);
    view.ReadOwner(access.storage, false);
    return view;
  }

  private func ReadOwner(owner: ref<GameObject>, carried: Bool) -> Void{
    let items: array<wref<gameItemData>>;
    let data: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(this.access.player);
    GameInstance.GetTransactionSystem(owner.GetGame()).GetItemList(owner, items);
    for item in items { this.IndexItem(item, data, carried); }
  }

  private func IndexItem(item: wref<gameItemData>, eq: ref<EquipmentSystemPlayerData>, carried: Bool) -> Void {
      let id = item.GetID();
      if ItemID.IsQuery(id) || ItemID.HasFlag(id, gameEItemIDFlag.Preview) { return; }
      let type = item.GetItemType();
      let row = new ArmoryItem();
      row.data = item;
      row.carried = carried;

      if Equals(EquipmentSystem.GetEquipAreaType(id), gamedataEquipmentArea.Weapon) {
        ArrayPush(this.weapons, row);
      } else {
        if (!Hotkey.IsCompatible(EHotkey.DPAD_UP, type) && !Hotkey.IsCompatible(EHotkey.RB, type)) || !carried || !eq.IsEquippable(item) || (Hotkey.ItemTypeMustBeEquipped(type) && !eq.IsEquipped(id)) { return; }
        if Hotkey.IsCompatible(EHotkey.RB, type) { ArrayPush(this.gadgets, row); }
        else { if Hotkey.IsCompatible(EHotkey.DPAD_UP, type) { ArrayPush(this.heals, row); } else { return; } }
        let record = RPGManager.GetItemRecord(id);
        let family = ConsumablesChargesHelper.GetConsumableTag(record.Tags());
        if IsNameValid(family) && !Hotkey.ItemTypeMustBeEquipped(type) {
          let key = NameToHash(family);
          let previous = this.best.Get(key) as ArmoryItem;
          if !IsDefined(previous) || record.Quality().Value() > RPGManager.GetItemRecord(previous.data.GetID()).Quality().Value() {
            if IsDefined(previous) { this.best.Set(key, row); } else { this.best.Insert(key, row); }
          };
        };
      };

      let hash = ItemID.GetCombinedHash(id);
      row.next = this.index.Get(hash) as ArmoryItem;
      if IsDefined(row.next) { this.index.Set(hash, row); } else { this.index.Insert(hash, row); }
  }

  public func Find(id: ItemID) -> ref<ArmoryItem> {
    if !ItemID.IsValid(id) { return null; }
    let row = this.index.Get(ItemID.GetCombinedHash(id)) as ArmoryItem;
    while IsDefined(row) {
      if row.data.GetID() == id { return row; }
      row = row.next;
    };

    return null;
  }

  public func Data(id: ItemID) -> wref<gameItemData> {
    let row = this.Find(id);
    if IsDefined(row) { return row.data; }
    return null;
  }

  public func Assignment(id: ItemID, family: CName, key: EHotkey) -> ItemID {
    let row: ref<ArmoryItem>;
    if IsNameValid(family) { row = this.best.Get(NameToHash(family)) as ArmoryItem; }
    else { row = this.Find(id); }
    if IsDefined(row) && row.carried && Hotkey.IsCompatible(key, row.data.GetItemType()) { return row.data.GetID(); }
    return ItemID.None();
  }

  public func Problem(set: ref<Loadout>, finalCheck: Bool) -> String {
    if !IsDefined(this.current) || ArraySize(set.weapons) != 6 { return Label("EquipmentRestricted"); }
    let player = this.access.player;
    let eq = EquipmentSystem.GetData(player);
    let i = 0;
    while i < 6 {
      let id = set.weapons[i];
      let old = this.current.weapons[i];
      let prefix = SlotLabel(i) + " — ";
      if ItemID.IsValid(id) {
        let row = this.Find(id);
        if !IsDefined(row) { return prefix + Label("MissingWeapon"); }

        if ArrayFindFirst(set.weapons, id) != i || !eq.IsEquippable(row.data) || (!row.carried && !Storable(row.data)) {
          return prefix + Label("EquipmentRestricted");
        };

        if i >= 3 {
          let error = PairError(player, this.Data(set.weapons[i-3]), row.data);
          if StrLen(error) > 0 { return prefix + error; }
        };
        if finalCheck && !eq.CheckWeaponAgainstGameplayRestrictions(id, true, i >= 3) { return prefix + Label("EquipmentRestricted"); }
      };

      if old != id && (StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"FirearmsNoSwitch")
        || StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"FirearmsNoUnequipNoSwitch")
        || StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"VehicleScene") || InventoryGPRestrictionHelper.BlockedBySceneTier(player)) {
        return prefix + Label("EquipmentRestricted");
      };

      if old != id || (i >= 3 && ItemID.IsValid(old) && this.current.weapons[i-3] != set.weapons[i-3]) {
        let visible: Bool;
        if eq.IsSlotLocked(gamedataEquipmentArea.Weapon, i, visible) { return prefix + Label("EquipmentRestricted"); }
        if ItemID.IsValid(old) {
          let displaced = this.Data(old);
          if !IsDefined(displaced) || displaced.HasTag(n"UnequipBlocked") { return prefix + Label("UnequipBlocked"); }
          if !ArrayContains(set.weapons, old) && !Storable(displaced) { return prefix + Label("TransferBlocked"); }
        };
      };
      i += 1;
    }

    if ItemID.IsValid(set.gadget) && !ItemID.IsValid(this.Assignment(set.gadget, set.gadgetFamily, EHotkey.RB)) { return Label("CombatGadget") + " — " + Label("MissingAssignment"); }
    if ItemID.IsValid(set.healing) && !ItemID.IsValid(this.Assignment(set.healing, set.healingFamily, EHotkey.DPAD_UP)) { return Label("Healing") + " — " + Label("MissingAssignment"); }

    return "";
  }

  public func Matches(set: ref<Loadout>) -> Bool {
    if !IsDefined(this.current) || ArraySize(set.weapons) != 6 { return false; }
    let i = 0;
    while i < 6 {
      if set.weapons[i] != this.current.weapons[i] { return false; }
      i += 1;
    };

    return (!ItemID.IsValid(set.gadget) 
      || (ItemID.IsValid(this.current.gadget) 
      && this.current.gadget == this.Assignment(set.gadget, set.gadgetFamily, EHotkey.RB)))
      && (!ItemID.IsValid(set.healing) || (ItemID.IsValid(this.current.healing) 
      && this.current.healing == this.Assignment(set.healing, set.healingFamily, EHotkey.DPAD_UP)));
  }
}

public func SlotLabel(i: Int32) -> String {
  return Label("WeaponPosition") + " " + ToString(1 + i % 3) + " · " + (i < 3 ? Label("RightHand") : Label("LeftHand"));
}
