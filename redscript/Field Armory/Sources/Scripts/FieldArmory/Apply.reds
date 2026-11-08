module FieldArmory

@addMethod(EquipmentSystemPlayerData)
public final func FieldArmoryEquip(id: ItemID, slot: Int32) {
  this.EquipItem(id, slot, false, true);
}

@addMethod(EquipmentSystemPlayerData)
public final func FieldArmoryClear(slot: Int32) {
  this.UnequipItem(this.GetEquipAreaIndex(gamedataEquipmentArea.Weapon), slot);
}

public class ApplyJournal {
  public persistent let before: ref<Loadout>;
  public persistent let clothes: ref<OutfitBackup>;
  public persistent let touchedClothes: Bool;
  public persistent let incoming: array<ItemID>;
  public persistent let outgoing: array<ItemID>;
  public persistent let storageID: EntityID;
}


public class ArmoryOperation extends DelayCallback {
  public let access: ref<StashAccess>;
  public let system: wref<ArmorySystem>;
  public let target: ref<Loadout>;
  public let reverting: Bool;
  private let attempts: Int32;
  private let restoreIssued: Bool;
  private let restoreWait: Int32;
  private let error: String;

  public static func Start(access: ref<StashAccess>, target: ref<Loadout>) -> String {
    let system: ref<ArmorySystem> = ArmorySystem.Get(access.player.GetGame());
    if IsDefined(system.pending) { return Label("ApplyFailed"); }
    if !access.Available() { return Label("StashUnavailable"); }
    if IsDefined(system.journal) { ArmoryOperation.Recover(access); return Label("ApplyFailed"); }

    let view = InventorySnapshot.Read(access);
    let problem = view.Problem(target, true);
    if StrLen(problem) > 0 { return problem; }

    let choice: ref<OutfitChoice>;
    if IsNameValid(target.wardrobe) {
      let wardrobe = WardrobeView.Read(access.player);
      choice = wardrobe.Find(target);
      if !IsDefined(choice) || !choice.valid || wardrobe.locked { return Label("MissingOutfit"); }
    };

    let journal = new ApplyJournal();
    journal.before = view.current;
    journal.storageID = access.storage.GetEntityID();
    if IsDefined(choice) && !choice.wearing {
      journal.clothes = BackupClothes(access.player);
      if !journal.clothes.readable { return Label("EquipmentRestricted"); }
    };

    for id in target.weapons {
      if ItemID.IsValid(id) && !view.Find(id).carried { ArrayPush(journal.incoming, id); }
    };

    for id in view.current.weapons {
      if ItemID.IsValid(id) && !ArrayContains(target.weapons, id) { ArrayPush(journal.outgoing, id); }
    };

    let op = new ArmoryOperation();
    op.system = system;
    op.access = access;
    op.target = target.Copy();
    op.target.gadget = view.Assignment(target.gadget, target.gadgetFamily, EHotkey.RB);
    op.target.healing = view.Assignment(target.healing, target.healingFamily, EHotkey.DPAD_UP);
    system.journal = journal;
    system.pending = op;
    if !op.Write(op.target, false) {
      op.reverting = true;
    } else {
      if IsDefined(journal.clothes) {
        journal.touchedClothes = true;
        op.reverting = !Wear(access.player, choice);
      }
    }
    if !op.reverting { op.Holster(); }
    op.Schedule();
    return "";
  }

  public static func Recover(access: ref<StashAccess>) {
    let system: ref<ArmorySystem> = ArmorySystem.Get(access.player.GetGame());
    if !IsDefined(system.journal) || IsDefined(system.pending) { return; }

    let op: ref<ArmoryOperation> = new ArmoryOperation();
    op.system = system;
    op.access = access;
    op.reverting = true;
    system.pending = op;
    op.Schedule();
  }

  private func Ownership(ids: array<ItemID>, carried: Bool) -> Bool {
    for id in ids {
      if NotEquals(IsDefined(ExactItem(this.access.player, id)), carried) 
      || Equals(IsDefined(ExactItem(this.access.storage, id)), carried) { 
        return false; 
      };
    };
    return true;
  }

  private func Move(ids: array<ItemID>, source: ref<GameObject>, dest: ref<GameObject>) -> Bool {
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(source.GetGame());
    for id in ids {
      if IsDefined(ExactItem(dest, id)) {
        if IsDefined(ExactItem(source, id)) { return false; }
      } else {
        if !IsDefined(ExactItem(source, id)) { return false; }
        if !ts.TransferItem(source, dest, id, 1) || IsDefined(ExactItem(source, id)) || !IsDefined(ExactItem(dest, id)) {
          this.error = Label("TransferBlocked");
          return false;
        };
      };
    };
    return true;
  }

  private func Write(set: ref<Loadout>, restore: Bool) -> Bool {
    let player = this.access.player;
    let storage = this.access.storage;
    if !IsDefined(storage) || !IsDefined(player) { return false; }

    let eq: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(player);
    let journal = this.system.journal;
    let i = 5;
    while i >= 0 {
      let old = eq.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, i);
      if ItemID.IsValid(old) && (old != set.weapons[i] 
        || (i >= 3 && eq.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, i-3) != set.weapons[i-3])) {
          eq.FieldArmoryClear(i);
          if ItemID.IsValid(eq.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, i)) { 
            return false; 
          };
        };
      i -= 1;
    }

    if restore {
      if !this.Move(journal.outgoing, storage, player) || !this.Move(journal.incoming, player, storage) { return false; }
    } else {
      if !this.Move(journal.incoming, storage, player) || !this.Move(journal.outgoing, player, storage) { return false; }
    };

    i = 0;
    while i < 6 {
      let id = set.weapons[i];
      if ItemID.IsValid(id) && eq.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, i) != id {
        if !IsDefined(ExactItem(player, id)) { return false; }
        eq.FieldArmoryEquip(id, i);
        if eq.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, i) != id { return false; }
      };
      i += 1;
    };
    if restore || ItemID.IsValid(set.gadget) { eq.AssignItemToHotkey(set.gadget, EHotkey.RB); }
    if restore || ItemID.IsValid(set.healing) { eq.AssignItemToHotkey(set.healing, EHotkey.DPAD_UP); }

    return true;
  }

  private func Holster() -> Void {
    let request = new EquipmentSystemWeaponManipulationRequest();
    request.owner = this.access.player;
    request.requestType = EquipmentManipulationAction.UnequipWeapon;
    EquipmentSystem.GetInstance(this.access.player).QueueRequest(request);
  }

  private func Schedule() -> Void {
    GameInstance.GetDelaySystem(this.access.player.GetGame()).DelayCallback(this, 0.10, false);
  }

  private func Verify(set: ref<Loadout>, restore: Bool) -> Bool {
    let current = Loadout.Capture(this.access.player);
    if !IsDefined(current) { return false; }
    let i = 0;
    while i < 6 {
      if current.weapons[i] != set.weapons[i] { return false; }
      i += 1;
    }
    if (restore || ItemID.IsValid(set.gadget)) && current.gadget != set.gadget { return false; }
    if (restore || ItemID.IsValid(set.healing)) && current.healing != set.healing { return false; }
    if !this.Ownership(this.system.journal.incoming, !restore) 
      || !this.Ownership(this.system.journal.outgoing, restore) { 
      return false; 
    };

    if !restore && IsNameValid(set.wardrobe) {
      let choice = WardrobeView.Read(this.access.player).Find(set);
      if !IsDefined(choice) || !choice.wearing { return false; }
    };

    return true;
  }

  public func Call()  -> Void {
    if !IsDefined(this.system) || this.system.pending != this || !IsDefined(this.access.player) { return; }
    let journal = this.system.journal;
    if !this.reverting {
      if this.access.Available() && IsDefined(this.system.screen) {
        let ts = GameInstance.GetTransactionSystem(this.access.player.GetGame());
        if this.Verify(this.target, false) 
          && ts.IsSlotEmpty(this.access.player, t"AttachmentSlots.WeaponRight") 
          && ts.IsSlotEmpty(this.access.player, t"AttachmentSlots.WeaponLeft") 
          && !ts.IsSlotSpawningAnyItem(this.access.player, t"AttachmentSlots.WeaponRight") 
          && !ts.IsSlotSpawningAnyItem(this.access.player, t"AttachmentSlots.WeaponLeft") {
            this.system.lastApplied = this.target.serial;
            this.Finish(true, true);
            return;
        };

        this.attempts += 1;
        if this.attempts < 40 { this.Schedule(); return; }
      }
      this.reverting = true;
    }
    if !this.restoreIssued {
      if this.Write(journal.before, true) && (!journal.touchedClothes || RestoreClothes(this.access.player, journal.clothes)) {
        this.restoreIssued = true;
      }
      this.restoreWait += 1;
      if this.restoreWait < 40 { this.Schedule(); return; }
    }

    let restored = this.restoreIssued 
      && this.Verify(journal.before, true)
      && (!journal.touchedClothes || ClothesRestored(this.access.player, journal.clothes));

    if !restored && this.restoreWait < 40 {
      this.restoreWait += 1;
      this.Schedule();
      return;
    };
 
    this.Finish(false, restored);
  }

  private func Finish(success: Bool, verified: Bool) {
    let screen = this.system.screen;
    if verified { this.system.journal = null; }
    this.system.pending = null;
    if IsDefined(screen) {
      if success { screen.Close(); }
      else { screen.Report(StrLen(this.error) > 0 ? this.error : Label("ApplyFailed")); }
    };
  };
}
