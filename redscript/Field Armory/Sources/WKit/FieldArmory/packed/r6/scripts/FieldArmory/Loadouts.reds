module FieldArmory

public class Loadout {
  public persistent let serial: Uint64;
  public persistent let title: CName;
  public persistent let weapons: array<ItemID>;
  public persistent let gadget: ItemID;
  public persistent let healing: ItemID;
  public persistent let gadgetFamily: CName;
  public persistent let healingFamily: CName;
  public persistent let wardrobe: CName;
  public persistent let vanillaSlot: gameWardrobeClothingSetIndex;
  public persistent let outfitName: CName;

  public func Copy() -> ref<Loadout> {
    let copy = new Loadout();
    copy.serial = this.serial;
    copy.title = this.title;
    copy.weapons = this.weapons;
    copy.gadget = this.gadget;
    copy.healing = this.healing;
    copy.gadgetFamily = this.gadgetFamily;
    copy.healingFamily = this.healingFamily;
    copy.wardrobe = this.wardrobe;
    copy.vanillaSlot = this.vanillaSlot;
    copy.outfitName = this.outfitName;
    return copy;
  }

  public static func Capture(player: ref<PlayerPuppet>) -> ref<Loadout> {
    let data = EquipmentSystem.GetData(player);
    let preset = new Loadout();
    if !IsDefined(data) || data.GetNumberOfSlots(gamedataEquipmentArea.Weapon, true) < 6 { return null; }
    let i = 0;
    while i < 6 {
      ArrayPush(preset.weapons, data.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, i));
      i += 1;
    }
    preset.SetAssignment(EHotkey.RB, data.GetItemIDFromHotkey(EHotkey.RB));
    preset.SetAssignment(EHotkey.DPAD_UP, data.GetItemIDFromHotkey(EHotkey.DPAD_UP));
    return preset;
  }

  public func SetAssignment(key: EHotkey, id: ItemID) {
    let family: CName;
    if ItemID.IsValid(id) {
      let record = RPGManager.GetItemRecord(id);
      if !Hotkey.IsCompatible(key, record.ItemType().Type()) { return; }
      if !Hotkey.ItemTypeMustBeEquipped(record.ItemType().Type()) {
        family = ConsumablesChargesHelper.GetConsumableTag(record.Tags());
      }
    }
    if Equals(key, EHotkey.RB) {
      this.gadget = id;
      this.gadgetFamily = family;
    } else {
      this.healing = id;
      this.healingFamily = family;
    }
  }
}

public class ArmorySystem extends ScriptableSystem {
  public let screen: wref<ArmoryScreen>;
  public persistent let journal: ref<ApplyJournal>;
  public let pending: ref<ArmoryOperation>;
  public let failTransferNumber: Int32;
  public persistent let sets: array<ref<Loadout>>;
  public persistent let lastApplied: Uint64;
  private persistent let sequence: Uint64;
  public static func Get(game: GameInstance) -> ref<ArmorySystem> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"FieldArmory.ArmorySystem") as ArmorySystem;
  }
  private func OnRestored(saveVersion: Int32, gameVersion: Int32) { this.ResumeJournal(); }
  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) { this.ResumeJournal(); }
  private func ResumeJournal() {
    if IsDefined(this.journal) {
      let restore = new RestoreArmorySession();
      restore.system = this;
      GameInstance.GetDelaySystem(this.GetGameInstance()).DelayCallback(restore, 1.0, false);
    }
  }
  public func Save(draft: ref<Loadout>) -> Int32 {
    let index = 0;
    if draft.serial == 0ul {
      this.sequence += 1ul;
      draft.serial = this.sequence;
      ArrayPush(this.sets, draft.Copy());
      return ArraySize(this.sets) - 1;
    }
    for existing in this.sets {
      if existing.serial == draft.serial {
        this.sets[index] = draft.Copy();
        return index;
      }
      index += 1;
    }
    return -1;
  }
  public func Delete(index: Int32) {
    if this.sets[index].serial == this.lastApplied { this.lastApplied = 0ul; }
    ArrayErase(this.sets, index);
  }
}

public func Label(key: String) -> String {
  return GetLocalizedTextByKey(StringToName("FieldArmory-" + key));
}

public func PairError(player: ref<PlayerPuppet>, right: wref<gameItemData>, left: wref<gameItemData>) -> String {
  if !IsDefined(left) { return ""; }
  if !IsDefined(right) || right.GetID() == left.GetID() { return Label("InvalidPair"); }
  let progression = PlayerDevelopmentSystem.GetData(player);
  if !IsDefined(progression) || !progression.IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Cool_Central_Milestone_2) {
    return Label("PerkRequired");
  }
  if !right.CanDualWield(player) || !left.CanDualWield(player)
    || NotEquals(EquipmentSystem.GetPlacementSlot(right.GetID(), true), t"AttachmentSlots.WeaponLeft")
    || NotEquals(EquipmentSystem.GetPlacementSlot(left.GetID(), true), t"AttachmentSlots.WeaponLeft") {
    return Label("InvalidPair");
  }
  return "";
}

public func ExactItem(owner: ref<GameObject>, id: ItemID) -> wref<gameItemData> {
  if !IsDefined(owner) || !ItemID.IsValid(id) || ItemID.IsQuery(id) { return null; }
  let item = GameInstance.GetTransactionSystem(owner.GetGame()).GetItemData(owner, id);
  if IsDefined(item) && item.GetID() == id { return item; }
  return null;
}

public func Storable(item: wref<gameItemData>) -> Bool {
  return IsDefined(item) && item.GetQuantity() == 1 && !item.HasTag(n"UnequipBlocked") && !item.HasTag(n"Quest")
    && !item.HasTag(n"HideInBackpackUI") && !item.HasTag(n"Grenade")
    && !item.HasTag(n"Inhaler") && !item.HasTag(n"Injector") && !ItemID.HasFlag(item.GetID(), gameEItemIDFlag.Preview);
}
