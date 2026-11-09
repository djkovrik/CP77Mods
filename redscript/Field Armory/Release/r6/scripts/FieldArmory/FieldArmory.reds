// FieldArmory v0.9.0
module FieldArmory

import Codeware.UI.*
@if(ModuleExists("EquipmentEx"))
import EquipmentEx.*
@if(ModuleExists("EquipmentEx"))
import EquipmentEx.OutfitSystem

public class OpenFieldArmory extends ActionBool {
  public let access: ref<StashAccess>;
  public static func Create(ps: ref<ScriptableDeviceComponentPS>, stock: ref<ScriptableDeviceAction>, access: ref<StashAccess>) -> ref<OpenFieldArmory> {
    let action: ref<OpenFieldArmory> = new OpenFieldArmory();
    action.clearanceLevel = stock.clearanceLevel;
    action.SetUp(ps);
    action.actionName = stock.GetActionID();
    action.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(action.actionName, true, n"FieldArmory-Loadouts", n"FieldArmory-Loadouts");
    action.SetIllegal(stock.IsIllegal());
    action.CreateInteraction([], "", t"Interactions.FieldArmoryLoadouts");
    action.access = access;
    return action;
  }
}
public class StashAccess {
  public let apartment: wref<StashControllerPS>;
  public let trunk: wref<VehicleComponentPS>;
  public let context: GetActionsContext;
  public let vehicleContext: VehicleActionsContext;
  public let storage: wref<GameObject>;
  public let player: wref<PlayerPuppet>;
  public func Available() -> Bool {
    if !IsDefined(this.storage) || !IsDefined(this.player) || !this.storage.IsAttached() { return false; }
    if IsDefined(this.apartment) {
      if !this.apartment.HasActiveContext(gamedeviceRequestType.Direct) { return false; }
      let actions: array<ref<DeviceAction>>;
      if !this.apartment.GetActions(actions, this.context) { return false; }
      return this.apartment.FieldArmoryStockActive(actions, true);
    };
    return IsDefined(this.trunk) && this.trunk.FieldArmoryTrunkActive(this.vehicleContext);
  }
  public func Open(owner: ref<GameObject>) {
    if !IsDefined(owner) { return; }
    this.storage = owner;
    this.player = GetPlayer(owner.GetGame());
    if !this.Available() { return; }
    let system = ArmorySystem.Get(owner.GetGame());
    if IsDefined(system.screen) { return; }
    Stash.ProcessStashRetroFixes(owner);
    MarketSystem.OnVendorMenuOpen(owner);
    let popup: ref<ArmoryScreen> = new ArmoryScreen();
    popup.access = this;
    system.screen = popup;
    GameInstance.GetUISystem(owner.GetGame()).QueueEvent(ShowCustomPopupEvent.Create(popup));
  }
}
@addMethod(ScriptableDeviceComponentPS)
public final func FieldArmoryStockActive(out actions: array<ref<DeviceAction>>, apartment: Bool) -> Bool {
  this.FinalizeGetActions(actions);
  for action in actions {
    if (apartment && IsDefined(action as OpenStash)) || (!apartment && IsDefined(action as VehiclePlayerTrunk)) {
      return !(action as ScriptableDeviceAction).IsInactive();
    };
  };
  return false;
}
@addMethod(VehicleComponentPS)
public final func FieldArmoryTrunkActive(context: VehicleActionsContext) -> Bool {
  let player = GetPlayer(this.GetGameInstance());
  let bb = player.GetPlayerStateMachineBlackboard();
  if !this.GetOwnerEntity().GetVehicleComponent().FieldArmoryAtTrunk(player) 
    || this.GetIsDestroyed() 
    || player.GetTakeOverControlSystem().IsDeviceControlled()
    || EntityID.IsDefined(bb.GetEntityID(GetAllBlackboardDefs().PlayerStateMachine.EntityIDVehicleRemoteControlled)) {
       return false; 
  };
  let hacks = FromVariant<array<TweakDBID>>(bb.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.UploadingQuickHackIDs));
  if ArrayContains(hacks, t"DeviceAction.TakeControlVehicleClassHack") 
    || ArrayContains(hacks, t"DeviceAction.TakeControlClassHack")
    || ArrayContains(hacks, t"DeviceAction.TakeControlCameraClassHack") 
    || ArrayContains(hacks, t"DeviceAction.VehicleExplodeClassHack") { 
      return false; 
  };
  let actions: array<ref<DeviceAction>>;
  this.GetTrunkActions(actions, context);
  return this.FieldArmoryStockActive(actions, false);
}
@addMethod(VehicleComponent)
public final func FieldArmoryAtTrunk(player: ref<PlayerPuppet>) -> Bool {
  let layers: array<gameinteractionsActiveLayerData>;
  this.m_interaction.GetActivatorsForLayer(n"trunk", layers);
  for layer in layers { if layer.activator == player { return true; } }
  return false;
}
@wrapMethod(StashControllerPS)
public func GetActions(out outActions: array<ref<DeviceAction>>, context: GetActionsContext) -> Bool {
  let ok: Bool = wrappedMethod(outActions, context);
  if ok {
    for action in outActions {
      let stock = action as OpenStash;
      if IsDefined(stock) && !stock.IsInactive() {
        let access = new StashAccess();
        access.apartment = this;
        access.context = context;
        ArrayPush(outActions, OpenFieldArmory.Create(this, stock, access));
        break;
      };
    };
  };
  return ok;
}
@wrapMethod(VehicleComponentPS)
public final func GetTrunkActions(actions: script_ref<array<ref<DeviceAction>>>, const context: script_ref<VehicleActionsContext>) {
  wrappedMethod(actions, context);
  for action in Deref(actions) {
    let stock = action as VehiclePlayerTrunk;
    if IsDefined(stock) && !stock.IsInactive() {
      let access = new StashAccess();
      access.trunk = this;
      access.vehicleContext = Deref(context);
      ArrayPush(Deref(actions), OpenFieldArmory.Create(this, stock, access));
      break;
    };
  };
}
@addMethod(StashControllerPS)
private final func OnOpenFieldArmory(evt: ref<OpenFieldArmory>) -> EntityNotificationType {
  return EntityNotificationType.SendThisEventToEntity;
}
@addMethod(Stash)
protected cb func OnOpenFieldArmory(evt: ref<OpenFieldArmory>) -> Bool {
  evt.access.Open(this);
}
@addMethod(VehicleComponentPS)
private final func OnOpenFieldArmory(evt: ref<OpenFieldArmory>) -> EntityNotificationType {
  evt.access.Open(this.GetOwnerEntity());
  return EntityNotificationType.DoNotNotifyEntity;
}
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
  public let pending: ref<ArmoryOperation>;
  public persistent let journal: ref<ApplyJournal>;
  public persistent let sets: array<ref<Loadout>>;
  public persistent let lastApplied: Uint64;
  private persistent let sequence: Uint64;
  public static func Get(game: GameInstance) -> ref<ArmorySystem> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"FieldArmory.ArmorySystem") as ArmorySystem;
  }
  public func OnRestored(saveVersion: Int32, gameVersion: Int32) { 
    this.ResumeJournal(); 
  }
  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) { 
    this.ResumeJournal(); 
  }
  private func ResumeJournal() {
    if IsDefined(this.journal) {
      let restore = new RestoreArmorySession();
      restore.system = this;
      GameInstance.GetDelaySystem(this.GetGameInstance()).DelayCallback(restore, 1.0, false);
    };
  }
  public func Save(draft: ref<Loadout>) -> Int32 {
    let index = 0;
    if draft.serial == 0ul {
      this.sequence += 1ul;
      draft.serial = this.sequence;
      ArrayPush(this.sets, draft.Copy());
      return ArraySize(this.sets) - 1;
    };
    for existing in this.sets {
      if existing.serial == draft.serial {
        this.sets[index] = draft.Copy();
        return index;
      };
      index += 1;
    };
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
  return IsDefined(item) && item.GetQuantity() == 1 
    && !item.HasTag(n"UnequipBlocked") 
    && !item.HasTag(n"Quest")
    && !item.HasTag(n"HideInBackpackUI") 
    && !item.HasTag(n"Grenade")
    && !item.HasTag(n"Inhaler") 
    && !item.HasTag(n"Injector") 
    && !ItemID.HasFlag(item.GetID(), gameEItemIDFlag.Preview);
}
public class ArmoryPreview extends WardrobeSetPreviewGameController {
  private let view: ref<InventorySnapshot>;
  private let selected: ref<Loadout>;
  private let choice: ref<OutfitChoice>;
  private let position: Int32;
  private let requestedRight: ItemID;
  private let requestedLeft: ItemID;
  private let owner: wref<ArmoryScreen>;
  private let generation: Uint32;
  private let originalRight: ItemID;
  private let originalLeft: ItemID;
  private let captured: Bool;
  private let animationPuppet: wref<gamePuppet>;
  private let bodyGrants: array<ItemID>;
  private let bodySlots: array<TweakDBID>;
  private let bodyItems: array<ItemID>;
  private let appliedOutfit: ref<OutfitChoice>;
  private let outfitSlots: array<TweakDBID>;
  private let outfitBaseline: array<ItemID>;
  private let outfitPlaced: array<ItemID>;
  private let outfitGrants: array<ItemID>;
  private let ready: Bool;
  private let grants: array<ItemID>;
  public cb func OnInitialize() -> Bool {
    super.OnInitialize();
    let screen = ArmorySystem.Get(this.GetPlayerControlledObject().GetGame()).screen;
    if IsDefined(screen) && this.GetRootWidget().GetParentWidget() == screen.previewHost { this.owner = screen; screen.preview = this; }
  }
  public func Select(view: ref<InventorySnapshot>, set: ref<Loadout>, outfit: ref<OutfitChoice>, position: Int32) {
    let right: ItemID;
    let left: ItemID;
    if IsDefined(set) {
      right = set.weapons[position];
      left = set.weapons[position+3];
    };
    if this.view == view 
      && this.choice == outfit 
      && this.selected == set 
      && this.position == position 
      && this.requestedRight == right 
      && this.requestedLeft == left { 
        return; 
    };
    this.requestedRight = right;
    this.requestedLeft = left;
    this.view = view;
    this.selected = set;
    this.choice = outfit;
    this.position = position;
    if this.ready { 
      this.Render(); 
    }
  }
  public cb func OnPreviewInitialized() -> Bool {
    super.OnPreviewInitialized();
    this.ready = true;
    if IsDefined(this.owner) { 
      this.owner.Invalidate(); 
    };
    this.Render();
  }
  public cb func OnUninitialize() -> Bool {
    this.generation += 1u;
    if IsDefined(this.animationPuppet) {
      GameObject.ToggleForcedVisibilityInAnimSystemEvent(this.animationPuppet, n"FieldArmoryPreview", false);
      this.animationPuppet = null;
    };
    if this.Separate() && this.captured {
      this.Release();
      if IsDefined(this.appliedOutfit) {
        this.RestoreOutfit();
        this.InitializeCurrentOutfit(this.GetGamePuppet());
      }
      this.RestoreHand(t"AttachmentSlots.WeaponRight", this.originalRight);
      this.RestoreHand(t"AttachmentSlots.WeaponLeft", this.originalLeft);
      this.ReleaseBody();
      AnimationControllerComponent.SetInputFloatToReplicate(this.GetGamePuppet(), n"has_left_weapon", ItemID.IsValid(this.originalLeft) ? 1.0 : 0.0);
    };
    this.view = null;
    this.ready = false;
    super.OnUninitialize();
  }
  private func Separate() -> Bool {
    let puppet = this.GetGamePuppet();
    return IsDefined(this.view) && IsDefined(puppet) && IsDefined(this.view.access.player)
      && NotEquals(puppet.GetEntityID(), this.view.access.player.GetEntityID());
  }
  private func Release() {
    if !this.Separate() { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    ts.RemoveItemFromSlot(puppet, t"AttachmentSlots.WeaponLeft", true);
    ts.RemoveItemFromSlot(puppet, t"AttachmentSlots.WeaponRight", true);
    let i = ArraySize(this.grants)-1;
    while i >= 0 {
      if !ts.HasItem(puppet, this.grants[i]) || ts.RemoveItem(puppet, this.grants[i], 1) { ArrayErase(this.grants, i); }
      i -= 1;
    }
  }
  private func RestoreHand(slot: TweakDBID, id: ItemID) {
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    if ItemID.IsValid(id) && ts.HasItem(puppet, id) && ts.CanPlaceItemInSlot(puppet, slot, id) { ts.AddItemToSlot(puppet, slot, id, true); }
  }
  private func Render() -> Void {
    if !this.Separate() || !IsDefined(this.owner) || this.owner.preview != this { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    if !this.captured {
      // initialize once for this mannequin
      this.animationPuppet = puppet;
      GameObject.ToggleForcedVisibilityInAnimSystemEvent(puppet, n"FieldArmoryPreview", true);
      if ts.IsSlotEmpty(puppet, t"AttachmentSlots.TppHead") && !ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.TppHead") {
        this.SetUpPuppet(this.GetVisualItems());
        this.InitializeCurrentOutfit(puppet);
      }
      this.InitializeBody(puppet);
      let check = new ArmoryBodyCheck();
      check.preview = this;
      GameInstance.GetDelaySystem(puppet.GetGame()).DelayCallback(check, 0.5, false);
      let right = ts.GetItemInSlot(puppet, t"AttachmentSlots.WeaponRight");
      let left = ts.GetItemInSlot(puppet, t"AttachmentSlots.WeaponLeft");
      if IsDefined(right) { this.originalRight = right.GetItemID(); }
      if IsDefined(left) { this.originalLeft = left.GetItemID(); }
      this.captured = true;
    };
    this.generation += 1u;
    this.Release();
    AnimationControllerComponent.SetInputFloatToReplicate(puppet, n"has_left_weapon", 0.0);
    if this.appliedOutfit != this.choice {
      this.UpdateOutfit();
    };
    this.PlaceHands(this.generation, 0);
  }
  public func RefreshPose() {
    if !this.ready || !this.Separate() || !IsDefined(this.owner) || this.owner.preview != this { return; }
    let puppet = this.GetGamePuppet();
    let pose = new AnimFeature_Paperdoll();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    pose.inventoryScreen_Weapon = ItemID.IsValid(this.requestedRight) && ts.HasItemInSlot(puppet, t"AttachmentSlots.WeaponRight", ts.CreatePreviewItemID(this.requestedRight));
    pose.inventoryScreen = !pose.inventoryScreen_Weapon;
    AnimationControllerComponent.ApplyFeature(puppet, n"Paperdoll", pose);
  }
  protected cb func OnSetCameraSetupEvent(index: Uint32, slotName: CName) -> Bool {
    this.RefreshPose();
  }
  private func InitializeBody(puppet: ref<gamePuppet>) {
    let gender: CName = puppet.GetResolvedGenderName();
    if Equals(gender, n"Male") {
      this.AddBodyPart(t"AttachmentSlots.TppHead", t"Items.PlayerMaTppHead");
    } else {
      if Equals(gender, n"Female") { 
        this.AddBodyPart(t"AttachmentSlots.TppHead", t"Items.PlayerWaTppHead"); 
      }
    };
    let arms = EquipmentSystem.GetData(this.view.access.player).GetActiveItem(gamedataEquipmentArea.RightArm);
    let record = ItemID.GetTDBID(arms);
    if !ItemID.IsValid(arms) {
      let held = GameInstance.GetTransactionSystem(puppet.GetGame()).GetItemInSlot(this.view.access.player, t"AttachmentSlots.WeaponRight");
      if IsDefined(held) {
        let weapon = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(held.GetItemID()));
        if IsDefined(weapon) && IsDefined(weapon.HolsteredItem()) { record = weapon.HolsteredItem().GetID(); }
      };
    };
    this.AddBodyPart(t"AttachmentSlots.RightArm", record);
  }
  private func AddBodyPart(slot: TweakDBID, record: TweakDBID) {
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    if !TDBID.IsValid(record) || !ts.IsSlotEmpty(puppet, slot) || ts.IsSlotSpawningAnyItem(puppet, slot) { return; }
    let id = ItemID.FromTDBID(record);
    if !ts.HasItem(puppet, id) {
      if !ts.GiveItem(puppet, id, 1) { return; }
      ArrayPush(this.bodyGrants, id);
    };
    if ts.AddItemToSlot(puppet, slot, id) {
      ArrayPush(this.bodySlots, slot);
      ArrayPush(this.bodyItems, id);
    };
  }
  private func ReleaseBody() -> Void {
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    let i = 0;
    for slot in this.bodySlots {
      if ts.HasItemInSlot(puppet, slot, this.bodyItems[i]) { ts.RemoveItemFromSlot(puppet, slot, true); }
      i += 1;
    };
    for id in this.bodyGrants { ts.RemoveItem(puppet, id, 1); }
  }
  @if(ModuleExists("EquipmentEx"))
  private func InitializeCurrentOutfit(puppet: ref<gamePuppet>) {
    let outfits = OutfitSystem.GetInstance(puppet.GetGame());
    if IsDefined(outfits) && outfits.IsActive() {
      let items: array<ItemID>;
      outfits.EquipPuppetOutfit(puppet, true, items);
    }
  }
  @if(!ModuleExists("EquipmentEx"))
  private func InitializeCurrentOutfit(puppet: ref<gamePuppet>) {}
  public func PlaceHands(generation: Uint32, attempt: Int32) {
    if this.generation != generation || !this.ready || !this.Separate() || !IsDefined(this.owner) || this.owner.preview != this { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    if attempt == 0 && (ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponLeft") || ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponRight")) {
      this.RetryHands(generation, 1); return;
    };
    if attempt > 0 {
      if ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponLeft") || ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponRight") {
        if attempt < 60 { this.RetryHands(generation, attempt+1); }
        return;
      }
      this.Release();
    };
    if !IsDefined(this.selected) { this.RefreshPose(); return; }
    let right = this.view.Data(this.selected.weapons[this.position]);
    let left = this.view.Data(this.selected.weapons[this.position+3]);
    if IsDefined(right) && this.Attach(right, t"AttachmentSlots.WeaponRight") && IsDefined(left)
      && Equals(PairError(this.view.access.player, right, left), "") && this.Attach(left, t"AttachmentSlots.WeaponLeft") {
      AnimationControllerComponent.SetInputFloatToReplicate(puppet, n"has_left_weapon", 1.0);
    };
    this.RefreshPose();
  }
  private func RetryHands(generation: Uint32, attempt: Int32) {
    let callback = new ArmoryPreviewRetry();
    callback.preview = this;
    callback.generation = generation;
    callback.attempt = attempt;
    GameInstance.GetDelaySystem(this.GetGamePuppet().GetGame()).DelayCallback(callback, 0.05, false);
  }
  @if(!ModuleExists("EquipmentEx"))
  private func UpdateOutfit() {
    if IsDefined(this.choice) && this.choice.valid {
      this.ShowVanillaClothes(this.choice.parts);
      this.appliedOutfit = this.choice;
    } else {
      this.RestoreOutfit();
    }
  }
  @if(!ModuleExists("EquipmentEx"))
  private func ShowVanillaClothes(items: array<ItemID>) {
    let areas = [
      gamedataEquipmentArea.Head, 
      gamedataEquipmentArea.Face, 
      gamedataEquipmentArea.InnerChest,
      gamedataEquipmentArea.OuterChest, 
      gamedataEquipmentArea.Legs, 
      gamedataEquipmentArea.Feet
    ];
    for area in areas { this.PreviewUnequipFromEquipmentArea(area); }
    for item in items { this.PreviewEquipItem(item); }
    this.HandleUnderwearVisualTags();
  }
  @if(!ModuleExists("EquipmentEx"))
  private func RestoreOutfit() {
    if !IsDefined(this.appliedOutfit) { return; }
    this.ShowVanillaClothes(this.GetVisualItems());
    this.appliedOutfit = null;
  }
  @if(ModuleExists("EquipmentEx"))
  private func UpdateOutfit() {
    this.RestoreOutfit();
    if !IsDefined(this.choice) || !this.choice.valid { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    let slots = [t"AttachmentSlots.Head", t"AttachmentSlots.Eyes", t"AttachmentSlots.Chest", t"AttachmentSlots.Torso", t"AttachmentSlots.Legs", t"AttachmentSlots.Feet"];
    this.AddProviderSlots(slots);
    for placement in this.choice.placements {
      if !ArrayContains(slots, placement) { ArrayPush(slots, placement); }
    }
    for slot in slots { this.DressSlot(puppet, ts, slot); }
    this.appliedOutfit = this.choice;
  }
  @if(ModuleExists("EquipmentEx"))
  private func DressSlot(puppet: ref<gamePuppet>, ts: ref<TransactionSystem>, slot: TweakDBID) {
    let original = ts.GetItemInSlot(puppet, slot);
    let before = IsDefined(original) ? original.GetItemID() : ItemID.None();
    let index = ArrayFindFirst(this.choice.placements, slot);
    let preview = ItemID.None();
    if index >= 0 {
      let id = this.choice.parts[index];
      if ItemID.IsValid(before) && ItemID.GetTDBID(before) == ItemID.GetTDBID(id) { return; }
      if !ItemID.IsValid(before) && this.choice.wearing && ts.IsSlotSpawningAnyItem(puppet, slot) { return; }
      preview = ts.CreatePreviewItemID(id);
      if !ts.HasItem(puppet, preview) {
        if !ts.GivePreviewItemByItemID(puppet, id) { return; }
        ArrayPush(this.outfitGrants, preview);
      };
    } else {
      if !ItemID.IsValid(before) { return; }
    };
    if ItemID.IsValid(before) && !ts.RemoveItemFromSlot(puppet, slot) { return; }
    ArrayPush(this.outfitSlots, slot);
    ArrayPush(this.outfitBaseline, before);
    if ItemID.IsValid(preview) && ts.CanPlaceItemInSlot(puppet, slot, preview) && ts.AddItemToSlot(puppet, slot, preview, true) {
      ArrayPush(this.outfitPlaced, preview);
    } else { 
      ArrayPush(this.outfitPlaced, ItemID.None()); 
    };
  }
  @if(ModuleExists("EquipmentEx"))
  private func AddProviderSlots(out slots: array<TweakDBID>) {
    for slot in OutfitSystem.GetInstance(this.view.access.player.GetGame()).GetOutfitSlots() {
      if !ArrayContains(slots, slot) { ArrayPush(slots, slot); }
    };
  }
  @if(ModuleExists("EquipmentEx"))
  private func RestoreOutfit() {
    if !IsDefined(this.appliedOutfit) { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    let i = 0;
    for slot in this.outfitSlots {
      if ItemID.IsValid(this.outfitPlaced[i]) && ts.HasItemInSlot(puppet, slot, this.outfitPlaced[i]) {
        ts.RemoveItemFromSlot(puppet, slot);
      }
      if ts.IsSlotEmpty(puppet, slot) && !ts.IsSlotSpawningAnyItem(puppet, slot) {
        this.RestoreHand(slot, this.outfitBaseline[i]);
      }
      i += 1;
    }
    for id in this.outfitGrants { ts.RemoveItem(puppet, id, 1); }
    ArrayClear(this.outfitGrants);
    ArrayClear(this.outfitBaseline);
    ArrayClear(this.outfitPlaced);
    ArrayClear(this.outfitSlots);
    this.appliedOutfit = null;
  }
  private func Attach(item: ref<gameItemData>, slot: TweakDBID) -> Bool {
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    let id = ts.CreatePreviewItemID(item.GetID());
    if !ts.HasItem(puppet, id) {
      if !ts.GivePreviewItemByItemData(puppet, item) { return false; }
      ArrayPush(this.grants, id);
    }
    return ts.CanPlaceItemInSlot(puppet, slot, id) && ts.AddItemToSlot(puppet, slot, id, true);
  }
}
public class ArmoryBodyCheck extends DelayCallback {
  public let preview: wref<ArmoryPreview>;
  public func Call() {
    if IsDefined(this.preview) { this.preview.RefreshPose(); }
  }
}
public class ArmoryPreviewRetry extends DelayCallback {
  public let preview: wref<ArmoryPreview>;
  public let generation: Uint32;
  public let attempt: Int32;
  public func Call() {
    if IsDefined(this.preview) { this.preview.PlaceHands(this.generation, this.attempt); }
  };
}
public class ArmoryScreen extends InGamePopup {
  public let access: ref<StashAccess>;
  private let system: wref<ArmorySystem>;
  private let view: ref<InventorySnapshot>;
  private let wardrobe: ref<WardrobeView>;
  public let previewHost: wref<inkCompoundWidget>;
  private let closing: Bool;
  public let preview: wref<ArmoryPreview>;
  private let shell: ref<InMenuPopupContent>;
  private let tiles: array<wref<inkWidget>>;
  private let accents: array<wref<inkImage>>;
  private let panel: ref<inkVerticalPanel>;
  private let draft: ref<Loadout>;
  private let dialog: ref<inkGameNotificationToken>;
  private let selected: Int32;
  private let position: Int32;
  private let focus: Int32;
  private let callerListener: ref<InventoryScriptListener>;
  private let stashListener: ref<InventoryScriptListener>;
  private let observer: ref<ArmoryInventoryListener>;
  private let refreshing: Bool;
  private let facts: array<CName>;
  private let factListeners: array<Uint32>;
  private let field: Int32;
  private let editorReturnRow: Int32;
  private let stored: Bool;
  private let heading: ref<inkVerticalPanel>;
  private let sourceTabs: ref<inkHorizontalPanel>;
  private let body: ref<inkVerticalPanel>;
  private let footer: ref<inkHorizontalPanel>;
  private let previewControls: ref<inkHorizontalPanel>;
  private let viewport: ref<inkCanvas>;
  private let scroll: ref<inkScrollController>;
  private let target: wref<inkCompoundWidget>;
  private let hovered: Int32;
  private let keyboardFocus: Bool;
  private let contentHeight: Float;
  private let mode: CName;
  private let reason: String;
  private let actions: array<CName>;
  private let values: array<Int32>;
  private let texts: array<wref<inkText>>;
  public func Close() {
    if this.closing { return; }
    this.closing = true;
    super.Close();
  }
  public func UseCursor() -> Bool { 
    return true; 
  }
  // stop simulation
  protected func SetTimeDilation() {}
  protected func ResetTimeDilation() {}
  protected cb func OnCreate() -> Void {
    super.OnCreate();
    this.system = ArmorySystem.Get(this.access.player.GetGame());
    let menu = this.GetGameController().SpawnFromExternal(this.m_container, r"djkovrik\\fieldarmory\\ui\\loadout_menu.inkwidget", n"Root") as inkCompoundWidget;
    if !IsDefined(menu) { this.Close(); return; }
    this.previewHost = menu.GetWidgetByPathName(n"previewHost") as inkCompoundWidget;
    let listHost = menu.GetWidgetByPathName(n"listHost") as inkCompoundWidget;
    this.GetGameController().SpawnFromExternal(this.previewHost, r"djkovrik\\fieldarmory\\ui\\loadout_preview.inkwidget", n"Root:FieldArmory.ArmoryPreview");
    menu.SetChildOrder(inkEChildOrder.Forward);
    listHost.SetAnchor(inkEAnchor.LeftFillVerticaly);
    listHost.SetMargin(inkMargin(20.0, 0.0, 0.0, 0.0));
    listHost.SetInteractive(false);
    listHost.SetChildOrder(inkEChildOrder.Forward);
    this.panel = new inkVerticalPanel();
    this.panel.SetAnchor(inkEAnchor.CenterLeft);
    this.panel.SetAnchorPoint(Vector2(0.0, 0.0));
    this.panel.SetTranslation(Vector2(-350.0, -520.0));
    this.panel.SetFitToContent(true);
    this.panel.Reparent(listHost);
    this.shell = InMenuPopupContent.Create();
    this.shell.Reparent(this.panel);
    let chrome = this.shell.GetRootCompoundWidget();
    chrome.GetWidgetByPathName(n"wrapper/right/fg").SetOpacity(0.45);
    this.heading = new inkVerticalPanel();
    this.heading.Reparent(this.shell.GetContainerWidget());
    this.sourceTabs = new inkHorizontalPanel();
    this.sourceTabs.SetFitToContent(true);
    this.sourceTabs.SetHAlign(inkEHorizontalAlign.Right);
    this.sourceTabs.SetVAlign(inkEVerticalAlign.Top);
    this.sourceTabs.SetMargin(inkMargin(0.0, 20.0, 84.0, 0.0));
    this.sourceTabs.Reparent(chrome);
    this.MakeScrollArea();
    this.footer = new inkHorizontalPanel();
    this.footer.SetHAlign(inkEHorizontalAlign.Right);
    this.footer.SetFitToContent(true);
    this.footer.Reparent(this.panel);
    this.previewControls = new inkHorizontalPanel();
    this.previewControls.SetHAlign(inkEHorizontalAlign.Right);
    this.previewControls.SetFitToContent(true);
    this.previewControls.Reparent(this.panel);
    this.observer = new ArmoryInventoryListener();
    this.observer.screen = this;
    let ts = GameInstance.GetTransactionSystem(this.access.player.GetGame());
    this.callerListener = ts.RegisterInventoryListener(this.access.player, this.observer);
    this.stashListener = ts.RegisterInventoryListener(this.access.storage, this.observer);
    this.Refresh();
    let i = 0;
    for set in this.system.sets {
      if set.serial == this.system.lastApplied { this.selected = i; break; }
      i += 1;
    };
    this.focus = this.selected;
    this.FirstPosition();
    this.Draw(true);
    this.RevealAfterLayout();
    ArmoryOperation.Recover(this.access);
  }
  protected cb func OnAttach() -> Void {
    super.OnAttach();
    this.RegisterToGlobalInputCallback(n"OnPreOnPress", this, n"OnConfirmPress");
    this.RegisterToGlobalInputCallback(n"OnPreOnRelease", this, n"OnConfirmRelease");
  }
  protected cb func OnDetach() -> Void {
    this.UnregisterFromGlobalInputCallback(n"OnPreOnPress", this, n"OnConfirmPress");
    this.UnregisterFromGlobalInputCallback(n"OnPreOnRelease", this, n"OnConfirmRelease");
    let ts = GameInstance.GetTransactionSystem(this.access.player.GetGame());
    ts.UnregisterInventoryListener(this.access.player, this.callerListener);
    if IsDefined(this.access.storage) { ts.UnregisterInventoryListener(this.access.storage, this.stashListener); }
    this.ClearFacts();
    if this.system.screen == this { this.system.screen = null; }
    if IsDefined(this.system.pending) { this.system.pending.reverting = true; }
    super.OnDetach();
  }
  public func Invalidate() -> Void {
    if this.refreshing || !IsDefined(this.system) || this.system.screen != this || IsDefined(this.system.pending) { return; }
    this.refreshing = true;
    let callback = new ScreenRefresh();
    callback.screen = this;
    GameInstance.GetDelaySystem(this.access.player.GetGame()).DelayCallbackNextFrame(callback);
  }
  public func OnRefreshRequested() -> Void {
    this.refreshing = false;
    if this.system.screen == this && !IsDefined(this.system.pending) {
      this.Refresh(); this.Draw();
    };
  }
  private func ClearFacts() {
    let quests = GameInstance.GetQuestsSystem(this.access.player.GetGame());
    let i = 0;
    for fact in this.facts { 
      quests.UnregisterListener(fact, this.factListeners[i]);
       i += 1; 
    };
    ArrayClear(this.facts); 
    ArrayClear(this.factListeners);
  }
  protected cb func OnPairFactChanged(value: Int32) -> Bool { 
    this.Invalidate(); 
  }
  public func Refresh() {
    if !IsDefined(this.access.storage) { this.reason = Label("StashUnavailable"); return; }
    this.view = InventorySnapshot.Read(this.access);
    this.wardrobe = WardrobeView.Read(this.access.player);
    this.ClearFacts();
    let quets = GameInstance.GetQuestsSystem(this.access.player.GetGame());
    for row in this.view.weapons {
      if row.data.HasTag(n"QuestPreventDualWield") {
        let fact = RPGManager.GetItemRecord(row.data.GetID()).QuestFactPreventDualWield();
        if IsNameValid(fact) && !ArrayContains(this.facts, fact) {
          ArrayPush(this.facts, fact);
          ArrayPush(this.factListeners, quets.RegisterListener(fact, this, n"OnPairFactChanged"));
        };
      };
    };
  }
  public func Report(message: String) { 
    this.reason = message; 
    this.Refresh(); 
    this.Draw(); 
  }
  private func Selected() -> ref<Loadout> {
    if IsDefined(this.draft) { return this.draft; }
    if this.selected < ArraySize(this.system.sets) { return this.system.sets[this.selected]; }
    return null;
  }
  private func FirstPosition() {
    this.position = 0;
    let set = this.Selected();
    if !IsDefined(set) { return; }
    while this.position < 2 
    && !ItemID.IsValid(set.weapons[this.position]) 
    && !ItemID.IsValid(set.weapons[this.position+3]) { 
      this.position += 1; 
    };
    if !ItemID.IsValid(set.weapons[this.position]) && !ItemID.IsValid(set.weapons[this.position+3]) { 
      this.position = 0; 
    };
  }
  private func Color(widget: ref<inkWidget>, token: CName) {
    widget.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    widget.BindProperty(n"tintColor", token);
  }
  private func MakeScrollArea() {
    this.viewport = new inkCanvas();
    this.viewport.SetInteractive(true);
    this.viewport.Reparent(this.shell.GetContainerWidget());
    let area = new inkScrollArea();
    area.SetAnchor(inkEAnchor.Fill);
    area.SetMargin(inkMargin(0.0, 0.0, 18.0, 0.0));
    area.fitToContentDirection = inkFitToContentDirection.Horizontal;
    area.useInternalMask = true;
    area.Reparent(this.viewport);
    this.body = new inkVerticalPanel();
    this.body.Reparent(area);
    let track = new inkCanvas();
    track.SetAnchor(inkEAnchor.RightFillVerticaly);
    track.SetSize(10.0, 0.0);
    track.SetInteractive(true);
    track.Reparent(this.viewport);
    let rail = new inkRectangle();
    rail.SetAnchor(inkEAnchor.Fill);
    this.Color(rail, n"MainColors.Grey");
    rail.SetOpacity(0.2);
    rail.Reparent(track);
    let thumb = new inkRectangle();
    thumb.SetAnchor(inkEAnchor.TopFillHorizontaly);
    thumb.SetSize(10.0, 40.0);
    thumb.SetInteractive(true);
    this.Color(thumb, n"MainColors.Grey");
    thumb.SetOpacity(0.65);
    thumb.Reparent(track);
    let slider = new inkSliderController();
    slider.slidingAreaRef = inkWidgetRef.Create(track);
    slider.handleRef = inkWidgetRef.Create(thumb);
    slider.direction = inkESliderDirection.Vertical;
    slider.autoSizeHandle = true;
    slider.minHandleSize = 40.0;
    slider.Setup(0, 1, 0, 0);
    track.AttachController(slider);
    this.scroll = new inkScrollController();
    this.scroll.ScrollArea = inkScrollAreaRef.Create(area);
    this.scroll.VerticalScrollBarRef = inkWidgetRef.Create(track);
    this.scroll.autoHideVertical = true;
    this.viewport.AttachController(this.scroll);
  }
  private func RegisterAction(tile: ref<inkWidget>, action: CName, opt value: Int32, opt frame: ref<inkImage>, opt text: ref<inkText>) {
    tile.SetName(StringToName(ToString(ArraySize(this.tiles))));
    tile.RegisterToCallback(n"OnEnter", this, n"OnHover");
    tile.RegisterToCallback(n"OnLeave", this, n"OnLeaveRow");
    ArrayPush(this.tiles, tile);
    ArrayPush(this.accents, frame);
    ArrayPush(this.actions, action);
    ArrayPush(this.values, value);
    ArrayPush(this.texts, text);
  }
  private func CommandButton(label: String, action: CName) {
    let button: ref<PopupButton> = PopupButton.Create();
    button.SetText(label);
    button.RegisterToCallback(n"OnBtnClick", this, n"OnCommandClick");
    button.Reparent(this.target, this.GetGameController());
    let root = button.GetRootWidget();
    let chrome = button.GetRootCompoundWidget();
    chrome.GetWidgetByPathName(n"minSize").SetSize(0.0, 80.0);
    chrome.GetWidgetByPathName(n"background").SetSize(0.0, 80.0);
    chrome.GetWidgetByPathName(n"frame").SetSize(0.0, 80.0);
    root.SetFitToContent(true);
    root.SetMargin(inkMargin(this.target.GetNumChildren() > 1 ? 14.0 : 0.0, 4.0, 0.0, 6.0));
    this.RegisterAction(root, action);
  }
  private func AddSilhouette(tile: ref<inkCanvas>, field: Int32, item: ref<ArmoryItem>) {
    let icon = new inkImage();
    let size = Vector2(54.0, 54.0);
    if IsDefined(item) {
      let record = RPGManager.GetItemRecord(item.data.GetID());
      let type = record.ItemType().Type();
      let weapon = record as WeaponItem_Record;
      let hudIcon: wref<UIIcon_Record>;
      if IsDefined(weapon) { hudIcon = weapon.HudIcon(); }
      let part: CName;
      switch type {
        case gamedataItemType.Wea_Knife: part = n"knife"; size = Vector2(70.0, 15.0); break;
        case gamedataItemType.Wea_Revolver: part = n"revolver_power"; size = Vector2(72.0, 41.0); break;
        case gamedataItemType.Wea_Handgun: part = n"pistol"; size = Vector2(63.0, 43.0); break;
        case gamedataItemType.Wea_SniperRifle: part = n"sniper"; size = Vector2(98.0, 31.0); break;
        case gamedataItemType.Wea_Shotgun: part = n"shotgun_power"; size = Vector2(90.0, 19.0); break;
        case gamedataItemType.Wea_Katana: part = n"katana"; size = Vector2(81.0, 16.0); break;
        case gamedataItemType.Wea_LightMachineGun: part = n"light_machine"; size = Vector2(87.0, 30.0); break;
        case gamedataItemType.Wea_AssaultRifle: size = Vector2(62.0, 42.0); break;
      };
      if item.data.HasTag(n"Defender") || (IsDefined(hudIcon) && hudIcon.GetID() == t"HUDWeaponIcons.Defender") {
        InkImageUtils.RequestSetImage(this.GetGameController(), icon, t"HUDWeaponIcons.Defender");
        size = Vector2(94.0, 30.0);
      } else if IsNameValid(part) {
        icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\weapon_types.inkatlas");
        icon.SetTexturePart(part);
      } else {
        let classIcon = UIItemsHelper.GetWeaponTypeIcon(type);
        if Equals(classIcon, n"UIIcon.WeaponTypeIcon_Default") && IsDefined(hudIcon) {
          InkImageUtils.RequestSetImage(this.GetGameController(), icon, hudIcon.GetID());
          size = Vector2(94.0, 30.0);
        } else {
          InkImageUtils.RequestSetImage(this.GetGameController(), icon, classIcon);
        };
      };
    } else {
      icon.SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\inventory\\shadow_icons.inkatlas");
      icon.SetTexturePart(field == 6 ? n"granade" : (field == 7 ? n"inhaler" : n"wardrobe"));
      size = Vector2(field == 6 ? 28.0 : (field == 7 ? 35.0 : 22.0), 54.0);
    };
    icon.SetAnchor(inkEAnchor.CenterLeft);
    icon.SetAnchorPoint(Vector2(0.5, 0.5));
    icon.SetMargin(inkMargin(64.0, 0.0, 0.0, 0.0));
    icon.SetSize(size);
    icon.SetInteractive(false);
    this.Color(icon, n"MainColors.Blue");
    if IsDefined(item) { icon.SetOpacity(0.58); }
    icon.Reparent(tile);
  }
  private func Row(label: String, action: CName, opt value: Int32, opt detail: String, opt item: ref<ArmoryItem>, opt statusAtRight: Bool, opt secondary: String) {
    let row = new inkText();
    row.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
    row.SetText(label);
    if !IsNameValid(action) {
      row.SetFontSize(35);
      row.SetFitToContent(true);
      row.SetWrapping(true, 908.0);
      row.SetMargin(inkMargin(4.0, 2.0, 4.0, 8.0));
      this.Color(row, n"MainColors.White");
      row.Reparent(this.target);
      return;
    };
    // fixed for now
    let width: Float = 1130.0;
    let hasDetail: Bool = StrLen(detail) > 0;
    let weaponParts: Bool = Equals(action, n"choose") && this.field < 6 && hasDetail;
    let editor = Equals(action, n"name") || Equals(action, n"pick");
    let silhouette = IsDefined(item) || (Equals(action, n"pick") && value >= 6);
    let hand = Equals(action, n"pick") && value < 6;
    let left = silhouette ? 120.0 : (hand ? 285.0 : 24.0);
    let stacked = hasDetail && !weaponParts && !statusAtRight;
    let height = this.target == this.body ? (editor || stacked ? 94.0 : 80.0) : 68.0;
    let column = weaponParts ? width * 0.46 : width * 0.5;
    let top = 4.0;
    if Equals(action, n"pick") {
      if value < 3 { top = 18.0; }
      else if value == 6 { top = 32.0; }
    }
    let tile = new inkCanvas();
    tile.SetSize(width, height);
    tile.SetMargin(inkMargin(0.0, top, 0.0, 6.0));
    tile.SetInteractive(true);
    tile.SetChildOrder(inkEChildOrder.Forward);
    tile.Reparent(this.target);
    let frame = new inkImage();
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"cell_fg");
    frame.SetNineSliceScale(true);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.Reparent(tile);
    if silhouette { this.AddSilhouette(tile, value, item); }
    let focusText = row;
    if hand {
      let caption = new inkText();
      caption.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
      caption.SetFontSize(35);
      caption.SetAnchor(inkEAnchor.Fill);
      caption.SetMargin(inkMargin(24.0, 0.0, width-left+12.0, stacked ? height-52.0 : 0.0));
      caption.SetVerticalAlignment(textVerticalAlignment.Center);
      caption.SetText(this.FieldLabel(value));
      this.Color(caption, n"MainColors.White");
      caption.Reparent(tile);
      if StrLen(label) == 0 { focusText = caption; }
    }
    row.SetAnchor(inkEAnchor.Fill);
    row.SetMargin(inkMargin(left, 0.0, weaponParts || statusAtRight ? width-column + 12.0 : 20.0, stacked ? height - 52.0 : 0.0));
    row.SetFontSize(37);
    row.SetVerticalAlignment(textVerticalAlignment.Center);
    row.SetWrapping(false, width-44.0);
    row.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    row.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    if StrLen(secondary) > 0 {
      let line = new inkHorizontalPanel();
      line.SetAnchor(inkEAnchor.Fill);
      line.SetMargin(row.GetMargin());
      line.SetInteractive(false);
      line.Reparent(tile);
      row.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
      row.SetFitToContent(true);
      row.SetVAlign(inkEVerticalAlign.Center);
      row.SetWrapping(true, width-left-280.0);
      row.SetVisible(StrLen(label) > 0);
      row.Reparent(line);
      let status = new inkText();
      status.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Regular");
      status.SetFontSize(35);
      status.SetVerticalAlignment(textVerticalAlignment.Center);
      status.SetVAlign(inkEVerticalAlign.Center);
      status.SetFitToContent(true);
      status.SetInteractive(false);
      status.SetText(StrLen(label) > 0 ? " · " + secondary : secondary);
      this.Color(status, n"MainColors.Grey");
      status.Reparent(line);
    } else {
      row.Reparent(tile);
    }
    if hasDetail {
      let parts = new inkText();
      parts.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Regular");
      parts.SetFontSize(weaponParts ? 29 : 32);
      parts.SetText(detail);
      parts.SetAnchor(inkEAnchor.Fill);
      parts.SetMargin(inkMargin(stacked ? 24.0 : column, stacked ? 42.0 : 0.0, 20.0, 0.0));
      if !stacked {
        parts.SetHorizontalAlignment(textHorizontalAlignment.Right);
        parts.SetInteractive(false);
      }
      parts.SetVerticalAlignment(textVerticalAlignment.Center);
      parts.SetWrapping(weaponParts, weaponParts ? width-column-20.0 : width-44.0);
      parts.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
      this.Color(parts, n"MainColors.Grey");
      parts.Reparent(tile);
      if Equals(action, n"name") {
        this.Color(row, n"MainColors.Grey");
        focusText = parts;
      }
    }
    tile.RegisterToCallback(n"OnRelease", this, n"OnRow");
    this.RegisterAction(tile, action, value, frame, focusText);
    if this.target == this.body { 
      this.contentHeight += height + top + 6.0; 
    }
  }
  private func Paint(i: Int32) {
    if i < 0 || i >= ArraySize(this.tiles) { return; }
    let lit = (this.keyboardFocus && i == this.focus) || i == this.hovered;
    let action = this.actions[i];
    if Equals(action, n"source") {
      this.tiles[i].SetOpacity(lit ? 1.0 : 0.82);
      this.accents[i].SetOpacity(this.keyboardFocus && i == this.focus ? 1.0 : 0.0);
      return;
    }
    if !IsDefined(this.accents[i]) {
      let button = this.tiles[i].GetControllerByType(n"Codeware.UI.PopupButton") as PopupButton;
      let input = Equals(action, n"back") || Equals(action, n"close") ? n"cancel" : (i == this.focus ? n"proceed" : n"");
      if NotEquals(button.GetInputAction(), input) { button.SetInputAction(input); }
      this.tiles[i].SetState(lit ? n"Hover" : n"Default");
      return;
    }
    let selected = Equals(action, n"select") && this.values[i] == this.selected;
    this.accents[i].BindProperty(n"tintColor", selected ? n"MainColors.Red" : (lit ? n"MainColors.Blue" : n"MainColors.Grey"));
    this.accents[i].SetOpacity(lit || selected ? 1.0 : 0.16);
    this.texts[i].BindProperty(n"tintColor", lit || (Equals(action, n"choose") && this.values[i] == -1) ? n"MainColors.Blue" : n"MainColors.White");
    this.texts[i].SetOpacity(lit || selected ? 1.0 : 0.88);
  }
  private func Reveal(i: Int32) {
    if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i].GetParentWidget() == this.body {
      this.scroll.EnsureVisible(this.tiles[i]);
      this.scroll.UpdateScrollPositionFromScrollArea();
    }
  }
  protected cb func OnHover(e: ref<inkPointerEvent>) -> Bool {
    let i = StringToInt(NameToString(e.GetCurrentTarget().GetName()));
    if i < 0 || i >= ArraySize(this.tiles) || this.tiles[i] != e.GetCurrentTarget() { return false; }
    let old = this.hovered;
    if old != i { this.GetGameController().PlaySound(n"Button", n"OnHover"); }
    this.hovered = i;
    if this.keyboardFocus {
      this.keyboardFocus = false;
      this.Paint(this.focus);
    }
    if old != i { this.Paint(old); }
    this.Paint(i);
  }
  protected cb func OnLeaveRow(e: ref<inkPointerEvent>) -> Bool {
    let i = this.hovered;
    if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == e.GetCurrentTarget() {
      this.hovered = -1;
      this.Paint(i);
    }
  }
  private func Status(set: ref<Loadout>, out available: Bool) -> String {
    available = false;
    if !IsDefined(this.access.storage) || !IsDefined(this.view) { return Label("StashUnavailable"); }
    let reason = this.view.Problem(set, false);
    if StrLen(reason) > 0 { return reason; }
    let choice = this.wardrobe.Find(set);
    if IsNameValid(set.wardrobe) && (!IsDefined(choice) || !choice.valid || this.wardrobe.locked) { return Label("MissingOutfit"); }
    available = true;
    return this.view.Matches(set) && (!IsDefined(choice)||choice.wearing) ? Label("Equipped") : "";
  }
  private func FieldLabel(field: Int32) -> String {
    if field < 6 { return ToString(1 + field % 3) + " · " + (field < 3 ? Label("RightHand") : Label("LeftHand")); }
    if field == 6 { return Label("CombatGadget"); }
    return field == 7 ? Label("Healing") : Label("Outfit");
  }
  private func EditItem(field: Int32, id: ItemID, fallback: String) {
    let item = this.view.Find(id);
    if IsDefined(item) {
      let owner = item.carried ? Label("Carried") : Label("InStash");
      let parts: String;
      if field < 6 { parts = item.PartsLabel(); }
      this.Row(item.Name(), n"pick", field, parts, null, false, owner);
    } else {
      this.Row(field < 6 ? "" : this.FieldLabel(field), n"pick", field, "", null, false, fallback);
    }
  }
  private func EditorFocus() -> Int32 {
    if this.field < 6 { return 1 + 2 * (this.field % 3) + (this.field < 3 ? 0 : 1); }
    return 1 + this.field;
  }
  private func Draw(opt focusPrimary: Bool) {
    this.sourceTabs.RemoveAllChildren();
    this.sourceTabs.SetVisible(Equals(this.mode, n"picker") && this.field < 6);
    this.heading.RemoveAllChildren();
    this.body.RemoveAllChildren();
    this.footer.RemoveAllChildren();
    this.previewControls.RemoveAllChildren();
    this.contentHeight = 0.0;
    this.hovered = -1;
    this.target = this.heading;
    ArrayClear(this.tiles); ArrayClear(this.accents);
    ArrayClear(this.actions); ArrayClear(this.values); ArrayClear(this.texts);
    let selected = this.Selected();
    this.shell.SetTitle(Equals(this.mode, n"picker") ? this.FieldLabel(this.field) : (IsDefined(this.draft) ? Label("Edit") : Label("Loadouts")));
    if StrLen(this.reason) > 0 { this.Row(this.reason, n""); }
    this.target = this.body;
    if Equals(this.mode, n"picker") { this.DrawPicker(); }
    else {
      if IsDefined(this.draft) {
        this.Row(Label("NameLabel"), n"name", 0, NameToString(selected.title));
        let i = 0;
        while i < 3 {
          this.EditItem(i, selected.weapons[i], ItemID.IsValid(selected.weapons[i]) ? Label("MissingWeapon") : Label("EmptySlot"));
          this.EditItem(i + 3, selected.weapons[i + 3], ItemID.IsValid(selected.weapons[i+3]) ? Label("MissingWeapon") : Label("EmptySlot"));
          i += 1;
        };
        this.EditItem(6, this.view.Assignment(selected.gadget, selected.gadgetFamily, EHotkey.RB), ItemID.IsValid(selected.gadget) ? Label("MissingAssignment") : Label("KeepCurrent"));
        this.EditItem(7, this.view.Assignment(selected.healing, selected.healingFamily, EHotkey.DPAD_UP), ItemID.IsValid(selected.healing) ? Label("MissingAssignment") : Label("KeepCurrent"));
        let outfit = this.wardrobe.Find(selected);
        let outfitLabel = IsNameValid(selected.wardrobe) ? Label("MissingOutfit") : Label("KeepCurrent");
        this.Row(IsDefined(outfit) ? outfit.Title() : Label("Outfit"), n"pick", 8, "", null, false, IsDefined(outfit) ? "" : outfitLabel);
        this.target = this.footer;
        if focusPrimary { this.focus = ArraySize(this.actions); }
        this.CommandButton(Label("Save"), n"save");
        this.CommandButton(Label("DiscardChanges"), n"back");
      } else {
        if ArraySize(this.system.sets) == 0 { this.target = this.heading; this.Row(Label("EmptySlot"), n""); this.target = this.body; }
        let selectedAvailable: Bool;
        let i = 0;
        while i < ArraySize(this.system.sets) {
          let preset = this.system.sets[i];
          let available: Bool;
          let status = this.Status(preset, available);
          this.Row(NameToString(preset.title), n"select", i, status, null, available && StrLen(status) > 0);
          if i == this.selected { selectedAvailable = available; }
          i += 1;
        };
        this.target = this.footer;
        if Equals(this.mode, n"manage") {
          if focusPrimary { this.focus = ArraySize(this.actions); }
          this.CommandButton(Label("EditAction"), n"edit");
          this.CommandButton(Label("Duplicate"), n"copy");
          this.CommandButton(Label("Delete"), n"delete");
        } else {
          if IsDefined(selected) {
            if focusPrimary {
              this.focus = selectedAvailable ? ArraySize(this.actions) : this.selected;
            }
            this.CommandButton(Label("Equip"), n"equip");
            this.CommandButton(Label("Manage"), n"manage");
          }
          this.CommandButton(Label("CreateFromCurrent"), n"new");
        }
      };
    };
    this.target = !IsDefined(selected) || Equals(this.mode, n"edit") ? this.footer : this.previewControls;
    if Equals(this.mode, n"picker") || Equals(this.mode, n"manage") {
      this.CommandButton(Label("Back"), n"back");
    } else {
      if !IsDefined(this.draft) { this.CommandButton(GetLocalizedText("UI-ScriptExports-Close"), n"close"); }
    }
    if IsDefined(selected) {
      this.CommandButton(this.PositionLabel(), n"position");
      if IsDefined(this.preview) { this.preview.Select(this.view, selected, this.wardrobe.Find(selected), this.position); }
    } else { 
      if IsDefined(this.preview) { 
        this.preview.Select(this.view, null, null, 0); 
      } ;
    };
    let editing = Equals(this.mode, n"edit");
    let visibleHeight = MinF(this.contentHeight, editing ? 1120.0 : 720.0);
    this.viewport.SetSize(1160.0, visibleHeight);
    this.viewport.SetVisible(visibleHeight > 0.0);
    let empty = !IsDefined(selected);
    // dynamic maybe? kept for the first release
    let width = empty ? 780.0 : 1280.0;
    this.heading.SetMargin(inkMargin(0.0, 0.0, 0.0, empty ? 22.0 : 0.0));
    this.panel.GetParentWidget().SetSize(width,0.0);
    this.shell.GetRootCompoundWidget().GetWidgetByPathName(n"minSize").SetSize(width, empty ? 220.0 : 190.0);
    this.shell.GetRootCompoundWidget().GetWidgetByPathName(n"wrapper/right").SetSize(width - 40.0, 180.0);
    this.footer.SetVisible(this.footer.GetNumChildren() > 0);
    this.previewControls.SetVisible(this.previewControls.GetNumChildren() > 0);
    this.footer.SetMargin(inkMargin(0.0, 14.0, 0.0, 0.0));
    this.previewControls.SetMargin(inkMargin(0.0, Equals(this.mode, n"picker") ? 14.0 : 0.0, 0.0, 0.0));
    this.focus = Clamp(this.focus, 0, Max(0, ArraySize(this.actions)-1));
    let i = 0;
    while i < ArraySize(this.actions) { this.Paint(i); i += 1; }
  }
  private func PositionLabel() -> String {
    return Label("PreviewPosition") + " " + ToString(this.position+1) + " / 3  >";
  }
  private func Choices() -> array<ref<ArmoryItem>> {
    if this.field < 6 { return this.view.weapons; }
    if this.field == 6 { return this.view.gadgets; }
    return this.view.heals;
  }
  private func DrawSourceTab(stored: Bool, count: Int32) {
    let active = Equals(this.stored, stored);
    let color = active ? n"MainColors.Blue" : n"MainColors.MildRed";
    let width = stored ? 268.0 : 356.0;
    let tab = new inkCanvas();
    tab.SetSize(width, 64.0);
    tab.SetInteractive(true);
    tab.SetMargin(inkMargin(stored ? 18.0 : 0.0, 0.0, 0.0, 0.0));
    tab.Reparent(this.sourceTabs);
    let frame = new inkImage();
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"cell_fg");
    frame.SetNineSliceScale(true);
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetInteractive(false);
    this.Color(frame, color);
    frame.Reparent(tab);
    let caption = new inkText();
    caption.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
    caption.SetFontSize(37);
    caption.SetLetterCase(textLetterCase.UpperCase);
    caption.SetAnchor(inkEAnchor.Fill);
    caption.SetHorizontalAlignment(textHorizontalAlignment.Center);
    caption.SetVerticalAlignment(textVerticalAlignment.Center);
    caption.SetMargin(inkMargin(8.0, 0.0, 8.0, 5.0));
    caption.SetText((stored ? Label("Stash") : Label("Inventory")) + " (" + ToString(count) + ")");
    caption.SetInteractive(false);
    this.Color(caption, color);
    caption.Reparent(tab);
    let line = new inkRectangle();
    line.SetAnchor(inkEAnchor.BottomLeft);
    line.SetAnchorPoint(Vector2(0.0, 1.0));
    line.SetSize(width, active ? 5.0 : 2.0);
    line.SetInteractive(false);
    this.Color(line, color);
    line.Reparent(tab);
    tab.RegisterToCallback(n"OnRelease", this, n"OnRow");
    this.RegisterAction(tab, n"source", stored ? 1 : 0, frame);
  }
  private func DrawPicker() {
    let first = 0;
    if this.field < 6 {
      let carried = this.view.carriedWeapons;
      this.DrawSourceTab(false, carried);
      this.DrawSourceTab(true, ArraySize(this.view.weapons) - carried);
      if this.stored { first = carried; }
    }
    let slot = this.FieldLabel(this.field);
    this.Row(this.field < 6 ? Label("ClearSlot") : Label("KeepCurrent"), n"choose", -1);
    if this.field == 8 {
      let i = 0;
      while i < ArraySize(this.wardrobe.choices) { this.Row(this.wardrobe.choices[i].Title(), n"choose", i, slot); i += 1; }
    } else {
      let rows = this.Choices();
      let end = this.field < 6 && !this.stored ? this.view.carriedWeapons : ArraySize(rows);
      while first < end {
        let item = rows[first];
        if this.field < 6 {
          this.Row(item.Name(), n"choose", first, item.PartsLabel(), item);
        } else {
          this.Row(item.Name(), n"choose", first);
        }
        first += 1;
      }
    }
  }
  protected cb func OnRow(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") && !e.IsHandled() {
      let target = e.GetCurrentTarget();
      let i = StringToInt(NameToString(target.GetName()));
      if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == target {
        e.Handle();
        this.Act(i);
        return true;
      }
    }
  }
  protected cb func OnCommandClick(widget: wref<inkWidget>) {
    let i = StringToInt(NameToString(widget.GetName()));
    if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == widget { this.Act(i); }
  }
  private func TakeConfirm(e: ref<inkPointerEvent>) -> Bool {
    if this.closing || IsDefined(this.dialog) || !this.IsTopPopup() || e.IsHandled() || e.IsConsumed() { return false; }
    if !e.IsAction(n"proceed") && (!e.IsAction(n"activate") || e.IsAction(n"click") || e.IsAction(n"mouse_left")) { return false; }
    e.Handle();
    e.Consume();
    return true;
  }
  protected cb func OnConfirmPress(e: ref<inkPointerEvent>) -> Bool {
    return this.TakeConfirm(e);
  }
  protected cb func OnConfirmRelease(e: ref<inkPointerEvent>) -> Bool {
    if !this.TakeConfirm(e) { return false; }
    this.Act(this.focus);
    return true;
  }
  protected cb func OnGlobalReleaseInput(e: ref<inkPointerEvent>) -> Bool {
    if IsDefined(this.dialog) || !this.IsTopPopup() || e.IsHandled() { return false; }
    if e.IsAction(n"cancel") && (IsDefined(this.draft)||IsNameValid(this.mode)) { e.Handle(); this.Back(); return true; }
    let up = e.IsAction(n"popup_navigate_up");
    let left = e.IsAction(n"popup_navigate_left");
    let across = Equals(this.actions[this.focus], n"source") && (left || e.IsAction(n"popup_navigate_right"));
    if up || e.IsAction(n"popup_navigate_down") || across {
      let old = this.focus;
      let oldHover = this.hovered;
      this.keyboardFocus = true;
      this.hovered = -1;
      let from = this.editorReturnRow > 0 ? this.editorReturnRow : this.focus;
      this.editorReturnRow = 0;
      if across {
        this.focus = left ? 0 : 1;
      } else {
        this.focus = (from+ArraySize(this.actions)+(up ? -1 : 1)) % Max(1, ArraySize(this.actions));
      }
      if oldHover != old { this.Paint(oldHover); }
      this.Paint(old); this.Paint(this.focus); this.Reveal(this.focus);
      e.Handle(); return true;
    }
    return super.OnGlobalReleaseInput(e);
  }
  private func Back() {
    this.reason = "";
    this.Refresh();
    if Equals(this.mode, n"picker") { this.ReturnToEditor(); return; }
    this.draft = null;
    this.mode = n"";
    this.editorReturnRow = 0;
    this.focus = this.selected;
    this.Draw(true);
    this.RevealAfterLayout();
  }
  private func ReturnToEditor() {
    this.mode = n"edit";
    this.editorReturnRow = this.EditorFocus();
    this.Draw(true);
    this.RevealAfterLayout();
  }
  private func Act(i: Int32) {
    if this.closing || i < 0 || i >= ArraySize(this.actions) || IsDefined(this.system.pending) || IsDefined(this.dialog) { return; }
    this.GetGameController().PlaySound(n"Button", n"OnPress");
    let action = this.actions[i];
    let value = this.values[i];
    if Equals(action, n"source") && Equals(this.stored, value == 1) { return; }
    if !Equals(action, n"position") { this.reason = ""; }
    switch action {
      case n"select": this.selected = value; this.FirstPosition(); break;
      case n"manage": this.mode = n"manage"; break;
      case n"new":
        this.Refresh();
        this.draft = Loadout.Capture(this.access.player);
        if !IsDefined(this.draft) { this.Report(Label("EquipmentRestricted")); return; }
        this.draft.title = StringToName(Label("Name")+" "+ToString(ArraySize(this.system.sets)+1));
        if IsDefined(this.wardrobe.unique) { this.wardrobe.unique.Bind(this.draft); }
        this.mode = n"edit"; this.FirstPosition(); break;
      case n"edit": case n"copy":
        this.Refresh(); this.draft = this.Selected().Copy(); this.mode = n"edit";
        if Equals(action, n"copy") { this.draft.serial = 0ul; }
        break;
      case n"name":
        this.dialog = GenericMessageNotification.ShowInput(this.GetGameController(), Label("NameLabel"), NameToString(this.draft.title), GenericMessageNotificationType.ConfirmCancel);
        this.dialog.RegisterListener(this, n"OnName"); return;
      case n"delete":
        this.dialog = GenericMessageNotification.Show(this.GetGameController(), Label("Delete"), Label("ConfirmDelete")+" "+NameToString(this.Selected().title), GenericMessageNotificationType.YesNo);
        this.dialog.RegisterListener(this, n"OnDelete"); return;
      case n"pick":
        this.editorReturnRow = 0;
        this.field = value; this.stored = false; this.mode = n"picker";
        break;
      case n"choose":
        this.Choose(value);
        this.ReturnToEditor();
        return;
      case n"source": this.stored = value == 1; break;
      case n"position":
        this.position = (this.position+1)%3;
        let button = this.tiles[i].GetControllerByType(n"Codeware.UI.PopupButton") as PopupButton;
        button.SetText(this.PositionLabel());
        let set = this.Selected();
        if IsDefined(this.preview) { this.preview.Select(this.view, set, this.wardrobe.Find(set), this.position); }
        return;
      case n"save":
        this.selected = this.system.Save(this.draft); this.Back(); return;
      case n"back": this.Back(); return;
      case n"close": this.Close(); return;
      case n"equip":
        this.reason = ArmoryOperation.Start(this.access, this.Selected()); break;
    }
    this.focus = Equals(action, n"select") ? this.selected : (Equals(action, n"source") ? i : 0);
    let enteringEditor = Equals(action, n"new") || Equals(action, n"edit") || Equals(action, n"copy");
    this.Draw(enteringEditor || Equals(action, n"manage") || Equals(action, n"select"));
    if Equals(action, n"source") && this.stored && this.view.carriedWeapons < ArraySize(this.view.weapons) {
      let match = this.StoredMatch();
      let j = 0;
      while j < ArraySize(this.actions) {
        if Equals(this.actions[j], n"choose") && this.values[j] == match { this.PaintFocusAt(j); break; }
        j += 1;
      }
    } else {
      if Equals(action, n"pick") || Equals(action, n"source") { this.scroll.SetScrollPosition(0.0); }
      this.RevealAfterLayout();
    }
  }
  private func PaintFocusAt(i: Int32) {
    let old = this.focus;
    this.focus = i;
    this.Paint(old); this.Paint(i); this.RevealAfterLayout();
  }
  private func RowToReveal() -> Int32 {
    if this.editorReturnRow > 0 { return this.editorReturnRow; }
    if this.focus >= 0 && this.focus < ArraySize(this.actions) && (Equals(this.actions[this.focus], n"equip") || Equals(this.actions[this.focus], n"edit")) {
      return this.selected;
    }
    return this.focus;
  }
  private func RevealAfterLayout() {
    let row = this.RowToReveal();
    if row < 0 || row >= ArraySize(this.tiles) || this.tiles[row].GetParentWidget() != this.body { return; }
    let callback = new ArmoryScrollToFocus();
    callback.screen = this;
    callback.tile = this.tiles[row];
    GameInstance.GetDelaySystem(this.access.player.GetGame()).DelayCallbackNextFrame(callback);
  }
  public func RevealCurrent(tile: wref<inkWidget>) {
    let row = this.RowToReveal();
    if !this.closing && IsDefined(tile) && row >= 0 && row < ArraySize(this.tiles) && this.tiles[row] == tile {
      this.Reveal(row);
    }
  }
  private func StoredMatch() -> Int32 {
    let first = this.view.carriedWeapons;
    let id = this.draft.weapons[this.field];
    if !ItemID.IsValid(id) { id = this.draft.weapons[this.position]; }
    if ItemID.IsValid(id) {
      let name = GetLocalizedTextByKey(RPGManager.GetItemRecord(id).DisplayName());
      let i = first;
      while i < ArraySize(this.view.weapons) {
        let candidate = this.view.weapons[i].data.GetID();
        if ItemID.GetTDBID(candidate) == ItemID.GetTDBID(id) || (StrLen(name) > 0 && Equals(name, GetLocalizedTextByKey(RPGManager.GetItemRecord(candidate).DisplayName()))) { return i; }
        i += 1;
      }
    }
    return first;
  }
  private func Choose(index: Int32) {
    if this.field == 8 {
      if index >= 0 { this.wardrobe.choices[index].Bind(this.draft); }
      else { this.draft.wardrobe = n""; this.draft.outfitName = n""; }
    } else {
      let id = ItemID.None();
      if index >= 0 { let rows = this.Choices(); id = rows[index].data.GetID(); }
      if this.field < 6 {
        let existing = ArrayFindFirst(this.draft.weapons, id);
        if ItemID.IsValid(id) && existing >= 0 && existing != this.field { this.draft.weapons[existing] = ItemID.None(); }
        this.draft.weapons[this.field] = id;
        this.position = this.field%3;
        this.reason = this.view.Problem(this.draft, false);
      } else { this.draft.SetAssignment(this.field == 6 ? EHotkey.RB : EHotkey.DPAD_UP, id); }
    }
  }
  protected cb func OnName(data: ref<inkGameNotificationData>) {
    this.dialog = null;
    let result = data as GenericMessageNotificationCloseData;
    if IsDefined(result) 
      && Equals(result.result, GenericMessageNotificationResult.Confirm) 
      && StrLen(result.input) > 0 { 
        this.draft.title = StringToName(result.input); 
    };
    this.Draw();
  }
  protected cb func OnDelete(data: ref<inkGameNotificationData>) {
    this.dialog = null;
    let result = data as GenericMessageNotificationCloseData;
    if IsDefined(result) && Equals(result.result, GenericMessageNotificationResult.Yes) {
      this.system.Delete(this.selected); this.selected = Max(0, Min(this.selected, ArraySize(this.system.sets) - 1));
      if ArraySize(this.system.sets) == 0 { this.mode = n""; }
      this.focus = this.selected; this.FirstPosition();
    };
    this.Draw();
  }
}
public class ArmoryScrollToFocus extends DelayCallback {
  public let screen: wref<ArmoryScreen>;
  public let tile: wref<inkWidget>;
  public func Call() {
    if IsDefined(this.screen) { this.screen.RevealCurrent(this.tile); }
  }
}
public class ScreenRefresh extends DelayCallback {
  public let screen: wref<ArmoryScreen>;
  public func Call() {
    if IsDefined(this.screen) { this.screen.OnRefreshRequested(); }
  }
}
public class ArmoryInventoryListener extends InventoryScriptCallback {
  public let screen: wref<ArmoryScreen>;
  public func OnItemAdded(item: ItemID, itemData: wref<gameItemData>, flaggedAsSilent: Bool) { this.screen.Invalidate(); }
  public func OnItemRemoved(item: ItemID, difference: Int32, currentQuantity: Int32) { this.screen.Invalidate(); }
  public func OnPartAdded(item: ItemID, partID: ItemID) { this.screen.Invalidate(); }
  public func OnPartRemoved(partID: ItemID, formerItemID: ItemID) { this.screen.Invalidate(); }
  public func OnItemQuantityChanged(item: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) { this.screen.Invalidate(); }
}
@wrapMethod(PlayerPuppet)
protected cb func OnNewPerkSold(evt: ref<NewPerkSoldEvent>) -> Bool {
  wrappedMethod(evt);
  if Equals(evt.perkType, gamedataNewPerkType.Cool_Central_Milestone_2) {
    let screen = ArmorySystem.Get(this.GetGame()).screen;
    if IsDefined(screen) { screen.Invalidate(); }
  }
}
@wrapMethod(PlayerDevelopmentData)
public final func BuyNewPerk(perkType: gamedataNewPerkType, opt forceBuy: Bool) -> Bool {
  let bought = wrappedMethod(perkType, forceBuy);
  if bought && Equals(perkType, gamedataNewPerkType.Cool_Central_Milestone_2) {
    let screen = ArmorySystem.Get(this.GetOwner().GetGame()).screen;
    if IsDefined(screen) { screen.Invalidate(); }
  }
  return bought;
}
public class RestoreArmorySession extends DelayCallback {
  public let system: wref<ArmorySystem>;
  public func Call() {
    if !IsDefined(this.system) || !IsDefined(this.system.journal) || IsDefined(this.system.pending) { return; }
    let game = this.system.GetGameInstance();
    let player = GetPlayer(game);
    let storage = GameInstance.FindEntityByID(game, this.system.journal.storageID) as GameObject;
    if IsDefined(player) && IsDefined(storage) && storage.IsAttached() && IsDefined(EquipmentSystem.GetData(player)) {
      let access = new StashAccess();
      access.player = player;
      access.storage = storage;
      ArmoryOperation.Recover(access);
    }
  }
}
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
