module FieldArmory

@if(ModuleExists("EquipmentEx"))
import EquipmentEx.OutfitSystem

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
    }
    if this.view == view && this.choice == outfit && this.selected == set && this.position == position && this.requestedRight == right && this.requestedLeft == left { return; }
    this.requestedRight = right;
    this.requestedLeft = left;
    this.view = view;
    this.selected = set;
    this.choice = outfit;
    this.position = position;
    if this.ready { this.Render(); }
  }

  protected cb func OnPreviewInitialized() -> Bool {
    super.OnPreviewInitialized();
    this.ready = true;
    if IsDefined(this.owner) { this.owner.Invalidate(); }
    this.Render();
  }

  protected cb func OnUninitialize() -> Bool {
    this.generation += 1u;
    if IsDefined(this.animationPuppet) {
      GameObject.ToggleForcedVisibilityInAnimSystemEvent(this.animationPuppet, n"FieldArmoryPreview", false);
      this.animationPuppet = null;
    }
    if this.Separate() && this.captured {
      this.Release();
      this.RestoreOutfit();
      this.RestoreHand(t"AttachmentSlots.WeaponRight", this.originalRight);
      this.RestoreHand(t"AttachmentSlots.WeaponLeft", this.originalLeft);
      this.ReleaseBody();
      AnimationControllerComponent.SetInputFloatToReplicate(this.GetGamePuppet(), n"has_left_weapon", ItemID.IsValid(this.originalLeft) ? 1.0 : 0.0);
    }
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
  private func Render() {
    if !this.Separate() || !IsDefined(this.owner) || this.owner.preview != this { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    if !this.captured {
      // Embedded previews do not run the notification controller's outfit setup.
      // Initialize once for this mannequin, before any hand or outfit changes.
      this.animationPuppet = puppet;
      GameObject.ToggleForcedVisibilityInAnimSystemEvent(puppet, n"FieldArmoryPreview", true);
      // A ready inventory mannequin already carries its appearance and animation bindings.
      // Reserve full outfit setup for a newly created, undressed scene puppet.
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
    }
    this.generation += 1u;
    this.Release();
    AnimationControllerComponent.SetInputFloatToReplicate(puppet, n"has_left_weapon", 0.0);
    if this.appliedOutfit != this.choice {
      this.RestoreOutfit();
      if IsDefined(this.choice) && this.choice.valid { this.Dress(); }
    }
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
    // In the hub OnPuppetReady supplies the TPP head and holstered arms separately from wardrobe visuals.
    let gender = puppet.GetResolvedGenderName();
    if Equals(gender, n"Male") {
      this.AddBodyPart(t"AttachmentSlots.TppHead", t"Items.PlayerMaTppHead");
    } else {
      if Equals(gender, n"Female") { this.AddBodyPart(t"AttachmentSlots.TppHead", t"Items.PlayerWaTppHead"); }
    }
    let arms = EquipmentSystem.GetData(this.view.access.player).GetActiveItem(gamedataEquipmentArea.RightArm);
    let record = ItemID.GetTDBID(arms);
    if !ItemID.IsValid(arms) {
      let held = GameInstance.GetTransactionSystem(puppet.GetGame()).GetItemInSlot(this.view.access.player, t"AttachmentSlots.WeaponRight");
      if IsDefined(held) {
        let weapon = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(held.GetItemID()));
        if IsDefined(weapon) && IsDefined(weapon.HolsteredItem()) { record = weapon.HolsteredItem().GetID(); }
      }
    }
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
    }
    if ts.AddItemToSlot(puppet, slot, id) {
      ArrayPush(this.bodySlots, slot);
      ArrayPush(this.bodyItems, id);
    }
  }
  private func ReleaseBody() {
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    let i = 0;
    for slot in this.bodySlots {
      if ts.HasItemInSlot(puppet, slot, this.bodyItems[i]) { ts.RemoveItemFromSlot(puppet, slot, true); }
      i += 1;
    }
    for id in this.bodyGrants { ts.RemoveItem(puppet, id, 1); }
  }
  @if(ModuleExists("EquipmentEx"))
  private func InitializeCurrentOutfit(puppet: ref<gamePuppet>) {
    let outfits = OutfitSystem.GetInstance(puppet.GetGame());
    if IsDefined(outfits) && outfits.IsActive() { outfits.EquipPuppetOutfit(puppet); }
  }
  @if(!ModuleExists("EquipmentEx"))
  private func InitializeCurrentOutfit(puppet: ref<gamePuppet>) {}
  public func PlaceHands(generation: Uint32, attempt: Int32) {
    if this.generation != generation || !this.ready || !this.Separate() || !IsDefined(this.owner) || this.owner.preview != this { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    if attempt == 0 && (ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponLeft") || ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponRight")) {
      this.RetryHands(generation, 1); return;
    }
    if attempt > 0 {
      if ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponLeft") || ts.IsSlotSpawningAnyItem(puppet, t"AttachmentSlots.WeaponRight") {
        if attempt < 60 { this.RetryHands(generation, attempt+1); }
        return;
      }
      this.Release();
    }
    if !IsDefined(this.selected) { this.RefreshPose(); return; }
    let right = this.view.Data(this.selected.weapons[this.position]);
    let left = this.view.Data(this.selected.weapons[this.position+3]);
    if IsDefined(right) && this.Attach(right, t"AttachmentSlots.WeaponRight") && IsDefined(left)
      && Equals(PairError(this.view.access.player, right, left), "") && this.Attach(left, t"AttachmentSlots.WeaponLeft") {
      AnimationControllerComponent.SetInputFloatToReplicate(puppet, n"has_left_weapon", 1.0);
    }
    this.RefreshPose();
  }
  private func RetryHands(generation: Uint32, attempt: Int32) {
    let callback = new ArmoryPreviewRetry();
    callback.preview = this;
    callback.generation = generation;
    callback.attempt = attempt;
    GameInstance.GetDelaySystem(this.GetGamePuppet().GetGame()).DelayCallback(callback, 0.05, false);
  }
  private func Dress() {
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    this.outfitSlots = [t"AttachmentSlots.Head", t"AttachmentSlots.Eyes", t"AttachmentSlots.Chest", t"AttachmentSlots.Torso", t"AttachmentSlots.Legs", t"AttachmentSlots.Feet"];
    this.AddProviderSlots();
    for slot in this.outfitSlots {
      let original = ts.GetItemInSlot(puppet, slot);
      let before = IsDefined(original) ? original.GetItemID() : ItemID.None();
      ArrayPush(this.outfitBaseline, before);
      if ItemID.IsValid(before) { ts.RemoveItemFromSlot(puppet, slot, true); }
    }
    let i = 0;
    for id in this.choice.parts {
      let slot = this.choice.placements[i];
      let preview = ts.CreatePreviewItemID(id);
      if !ts.HasItem(puppet, preview) && ts.GivePreviewItemByItemID(puppet, id) { ArrayPush(this.outfitGrants, preview); }
      if ts.HasItem(puppet, preview) && ts.CanPlaceItemInSlot(puppet, slot, preview) { ts.AddItemToSlot(puppet, slot, preview, true); }
      i += 1;
    }
    this.appliedOutfit = this.choice;
  }
  @if(ModuleExists("EquipmentEx"))
  private func AddProviderSlots() {
    let slots = OutfitSystem.GetInstance(this.view.access.player.GetGame()).GetOutfitSlots();
    for slot in slots { if !ArrayContains(this.outfitSlots, slot) { ArrayPush(this.outfitSlots, slot); } }
  }
  @if(!ModuleExists("EquipmentEx"))
  private func AddProviderSlots() {}
  private func RestoreOutfit() {
    if !IsDefined(this.appliedOutfit) { return; }
    let puppet = this.GetGamePuppet();
    let ts = GameInstance.GetTransactionSystem(puppet.GetGame());
    let i = 0;
    for slot in this.outfitSlots {
      ts.RemoveItemFromSlot(puppet, slot, true);
      this.RestoreHand(slot, this.outfitBaseline[i]);
      i += 1;
    }
    for id in this.outfitGrants { ts.RemoveItem(puppet, id, 1); }
    ArrayClear(this.outfitGrants);
    ArrayClear(this.outfitBaseline);
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
  }
}
