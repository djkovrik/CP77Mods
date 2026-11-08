module FieldArmory

@if(ModuleExists("EquipmentEx"))
import EquipmentEx.*

public class OutfitChoice {
  public let provider: CName;
  public let name: CName;
  public let slot: gameWardrobeClothingSetIndex;
  public let parts: array<ItemID>;
  public let placements: array<TweakDBID>;
  public let wearing: Bool;
  public let valid: Bool;

  public func Bind(set: ref<Loadout>) -> Void {
    set.wardrobe = this.provider;
    set.vanillaSlot = this.slot;
    set.outfitName = this.name;
  }

  public func Title() -> String {
    if Equals(this.provider, n"EquipmentEx") { return NameToString(this.name); }
    return Label("Outfit") + " " + ToString(WardrobeSystem.WardrobeClothingSetIndexToNumber(this.slot)+1);
  }
}

public class WardrobeView {
  public let choices: array<ref<OutfitChoice>>;
  public let unique: ref<OutfitChoice>;
  public let locked: Bool;
  public let provider: CName;
  private let index: ref<inkHashMap>;

  public func Add(choice: ref<OutfitChoice>) {
    ArrayPush(this.choices, choice);
    this.index.Insert(this.Key(choice.slot, choice.name), choice);
  }

  private func Key(slot: gameWardrobeClothingSetIndex, name: CName) -> Uint64 {
    return Equals(this.provider, n"EquipmentEx") ? NameToHash(name) : Cast<Uint64>(EnumInt(slot));
  }

  public func Find(set: ref<Loadout>) -> ref<OutfitChoice> {
    if NotEquals(this.provider, set.wardrobe) { return null; }
    return this.index.Get(this.Key(set.vanillaSlot, set.outfitName)) as OutfitChoice;
  }

  public static func Read(player: ref<PlayerPuppet>) -> ref<WardrobeView> {
    let view = new WardrobeView();
    view.index = new inkHashMap();
    ReadWardrobe(view, player);
    for choice in view.choices {
      if choice.wearing {
        if IsDefined(view.unique) { view.unique = null; break; }
        view.unique = choice;
      };
    };
    return view;
  }
}

@if(!ModuleExists("EquipmentEx"))
public func ReadWardrobe(view: ref<WardrobeView>, player: ref<PlayerPuppet>) {
  let wardrobe = GameInstance.GetWardrobeSystem(player.GetGame());
  let eq = EquipmentSystem.GetData(player);
  let garment = ExactItem(player, eq.GetActiveItem(gamedataEquipmentArea.Outfit));
  view.provider = n"Vanilla";
  view.locked = !eq.IsWardrobeEnabled() || (IsDefined(garment) && garment.HasTag(n"UnequipBlocked"));

  for saved in wardrobe.GetClothingSets() {
    if ArraySize(saved.clothingList) > 0 {
      let choice = new OutfitChoice();
      choice.slot = saved.setID;
      choice.provider = view.provider;
      choice.wearing = Equals(saved.setID, wardrobe.GetActiveClothingSetIndex());
      choice.valid = true;
      for part in saved.clothingList {
        if ItemID.IsValid(part.visualItem) {
          ArrayPush(choice.parts, part.visualItem);
          ArrayPush(choice.placements, EquipmentSystem.GetPlacementSlot(part.visualItem));
        };
      };
      view.Add(choice);
    };
  };
}

@if(ModuleExists("EquipmentEx"))
public func ReadWardrobe(view: ref<WardrobeView>, player: ref<PlayerPuppet>) {
  let ex = OutfitSystem.GetInstance(player.GetGame());
  view.provider = n"EquipmentEx";
  view.locked = ex.IsBlocked();
  let ts = GameInstance.GetTransactionSystem(player.GetGame());
  let occupied = ex.GetUsedSlots();

  for name in ex.GetOutfits() {
    let choice = new OutfitChoice();
    choice.provider = view.provider;
    choice.name = name;
    choice.valid = true;
    let parts = ex.GetOutfitParts(name);
    choice.wearing = ex.IsActive() && ArraySize(occupied) == ArraySize(parts);

    for part in parts {
      let id = part.GetItemID();
      let slot = ex.GetItemSlot(id);
      if !ex.IsEquippable(id, slot) || ArrayContains(choice.placements, slot) { choice.valid = false; }
      let visual = ts.GetItemInSlot(player, slot);
      choice.wearing = choice.wearing && ex.IsEquipped(id) && IsDefined(visual)
        && Equals(ItemID.GetTDBID(visual.GetItemID()), ItemID.GetTDBID(id));
      ArrayPush(choice.parts, id);
      ArrayPush(choice.placements, slot);
    };
    view.Add(choice);
  };
}

public class OutfitBackup {
  public persistent let readable: Bool;
  public persistent let active: Bool;
  public persistent let slot: gameWardrobeClothingSetIndex;
  public persistent let garment: ItemID;
  public persistent let items: array<ItemID>;
  public persistent let placements: array<TweakDBID>;
}

@if(ModuleExists("EquipmentEx"))
public func CaptureProvider(player: ref<PlayerPuppet>, backup: ref<OutfitBackup>) {
  let ex = OutfitSystem.GetInstance(player.GetGame());
  backup.active = ex.IsActive();
  if !backup.active { backup.readable = true; return; }
  let remaining = ex.GetUsedSlots();
  for name in ex.GetOutfits() {
    for part in ex.GetOutfitParts(name) {
      CaptureOutfitItem(ex, part.GetItemID(), remaining, backup);
    }
    if ArraySize(remaining) == 0 { break; }
  }
  if ArraySize(remaining) > 0 {
    let inventory: array<wref<gameItemData>>;
    GameInstance.GetTransactionSystem(player.GetGame()).GetItemList(player, inventory);
    for item in inventory {
      if Equals(RPGManager.GetItemCategory(item.GetID()), gamedataItemCategory.Clothing) {
        CaptureOutfitItem(ex, item.GetID(), remaining, backup);
      }
      if ArraySize(remaining) == 0 { break; }
    }
  }
  if ArraySize(remaining) > 0 {
    for id in GameInstance.GetWardrobeSystem(player.GetGame()).GetStoredItemIDs() {
      CaptureOutfitItem(ex, id, remaining, backup);
      if ArraySize(remaining) == 0 { break; }
    }
  };
  backup.readable = ArraySize(remaining) == 0;
}

@if(ModuleExists("EquipmentEx"))
private func CaptureOutfitItem(ex: ref<OutfitSystem>, id: ItemID, out remaining: array<TweakDBID>, backup: ref<OutfitBackup>) {
  let slot = ex.GetItemSlot(id);
  if ArrayContains(remaining, slot) && ex.IsEquipped(id) {
    ArrayPush(backup.items, id);
    ArrayPush(backup.placements, slot);
    ArrayRemove(remaining, slot);
  }
}

public func BackupClothes(player: ref<PlayerPuppet>) -> ref<OutfitBackup> {
  let backup = new OutfitBackup();
  backup.garment = EquipmentSystem.GetData(player).GetActiveItem(gamedataEquipmentArea.Outfit);
  backup.slot = GameInstance.GetWardrobeSystem(player.GetGame()).GetActiveClothingSetIndex();
  CaptureProvider(player, backup);
  return backup;
}

@if(!ModuleExists("EquipmentEx"))
public func CaptureProvider(player: ref<PlayerPuppet>, backup: ref<OutfitBackup>) { backup.readable = true; }
@if(ModuleExists("EquipmentEx"))
public func Wear(player: ref<PlayerPuppet>, choice: ref<OutfitChoice>) -> Bool {
  return OutfitSystem.GetInstance(player.GetGame()).LoadOutfit(choice.name);
}

@if(!ModuleExists("EquipmentEx"))
public func Wear(player: ref<PlayerPuppet>, choice: ref<OutfitChoice>) -> Bool {
  EquipmentSystem.GetData(player).EquipWardrobeSet(choice.slot);
  return true;
}

@if(ModuleExists("EquipmentEx"))
public func RestoreProvider(player: ref<PlayerPuppet>, backup: ref<OutfitBackup>) -> Bool {
  let ex = OutfitSystem.GetInstance(player.GetGame());
  if backup.active {
    ex.UnequipAll();
    let i = 0;
    for id in backup.items {
      if !ex.EquipItem(id, backup.placements[i]) { return false; }
      i += 1;
    }
  } else { ex.Deactivate(); }
  return Equals(ex.IsActive(), backup.active);
}

@if(!ModuleExists("EquipmentEx"))
public func RestoreProvider(player: ref<PlayerPuppet>, backup: ref<OutfitBackup>) -> Bool {
  let eq = EquipmentSystem.GetData(player);
  if Equals(backup.slot, gameWardrobeClothingSetIndex.INVALID) { 
    eq.UnequipWardrobeSet(); 
  } else { 
    eq.EquipWardrobeSet(backup.slot); 
  };

  return Equals(GameInstance.GetWardrobeSystem(player.GetGame()).GetActiveClothingSetIndex(), backup.slot);
}

public func RestoreClothes(player: ref<PlayerPuppet>, backup: ref<OutfitBackup>) -> Bool {
  let eq = EquipmentSystem.GetData(player);
  if !RestoreProvider(player, backup) { return false; }

  if ItemID.IsValid(backup.garment) && eq.GetActiveItem(gamedataEquipmentArea.Outfit) != backup.garment {
    eq.FieldArmoryEquip(backup.garment, 0);
  };
  return eq.GetActiveItem(gamedataEquipmentArea.Outfit) == backup.garment;
}

public func ClothesRestored(player: ref<PlayerPuppet>, expected: ref<OutfitBackup>) -> Bool {
  let actual = BackupClothes(player);
  if !actual.readable 
    || actual.garment != expected.garment 
    || NotEquals(actual.slot, expected.slot)
    || NotEquals(actual.active, expected.active) { 
      return false; 
  };

  if !actual.active { return true; }
  if ArraySize(actual.items) != ArraySize(expected.items) { return false; }
  let ts = GameInstance.GetTransactionSystem(player.GetGame());
  let i = 0;

  for id in expected.items {
    let index = ArrayFindFirst(actual.placements, expected.placements[i]);
    if index < 0 || actual.items[index] != id { return false; }
    let visual = ts.GetItemInSlot(player, expected.placements[i]);
    if !IsDefined(visual) || NotEquals(ItemID.GetTDBID(visual.GetItemID()), ItemID.GetTDBID(id)) { return false; }
    i += 1;
  };
  return true;
}
