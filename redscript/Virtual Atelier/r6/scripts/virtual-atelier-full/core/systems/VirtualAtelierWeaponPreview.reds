module VirtualAtelier.Systems

public class VirtualAtelierPreviewWeapon extends IScriptable {
  public let itemID: ItemID;
}

public class VirtualAtelierWeaponPreview extends IScriptable {
  private let puppet: wref<gamePuppet>;
  private let player: wref<PlayerPuppet>;
  private let transactionSystem: wref<TransactionSystem>;
  private let initialRight: ref<VirtualAtelierPreviewWeapon>;
  private let initialLeft: ref<VirtualAtelierPreviewWeapon>;
  private let rightWeapon: ref<VirtualAtelierPreviewWeapon>;
  private let leftWeapon: ref<VirtualAtelierPreviewWeapon>;
  private let isSelectingWeapons: Bool;
  private let givenWeapons: array<ref<VirtualAtelierPreviewWeapon>>;

  public static func Create(puppet: ref<gamePuppet>, player: wref<PlayerPuppet>) -> ref<VirtualAtelierWeaponPreview> {
    let preview: ref<VirtualAtelierWeaponPreview> = new VirtualAtelierWeaponPreview();
    preview.puppet = puppet;
    preview.player = player;
    preview.transactionSystem = GameInstance.GetTransactionSystem(puppet.GetGame());
    preview.initialRight = preview.CaptureWeapon(t"AttachmentSlots.WeaponRight");
    preview.initialLeft = preview.CaptureWeapon(t"AttachmentSlots.WeaponLeft");
    preview.rightWeapon = preview.initialRight;
    preview.leftWeapon = preview.initialLeft;
    return preview;
  }

  public func GetIsEquipped(itemID: ItemID) -> Bool {
    return this.isSelectingWeapons && (this.IsSameWeapon(this.rightWeapon, itemID) || this.IsSameWeapon(this.leftWeapon, itemID));
  }

  public func ToggleItem(itemID: ItemID) -> Void {
    let weapon: ref<VirtualAtelierPreviewWeapon>;
    if !IsDefined(this.puppet) {
      return;
    };

    if this.isSelectingWeapons && this.IsSameWeapon(this.rightWeapon, itemID) {
      this.ChangeWeapons(null, null, true);
    } else if this.isSelectingWeapons && this.IsSameWeapon(this.leftWeapon, itemID) {
      this.ChangeWeapons(this.rightWeapon, null, true);
    } else {
      // At most two active grants and one staged grant; retry failed cleanup before giving more.
      if !this.ReleaseUnusedWeapons() {
        if !this.ApplyWeapons(this.rightWeapon, this.leftWeapon) || !this.ReleaseUnusedWeapons() {
          return;
        };
      };
      if NotEquals(EquipmentSystem.GetPlacementSlot(itemID), t"AttachmentSlots.WeaponRight") {
        return;
      };
      weapon = this.PrepareWeapon(itemID);
      if !IsDefined(weapon) {
        return;
      };
      if this.CanAddLeftWeapon(weapon) {
        this.ChangeWeapons(this.rightWeapon, weapon, true);
      } else {
        this.ChangeWeapons(weapon, null, true);
      };
      this.ReleaseUnusedWeapons();
    };
  }

  public func RemovePreview() -> Void {
    if this.isSelectingWeapons {
      this.ChangeWeapons(null, null, true);
    };
  }

  public func RemoveAll() -> Void {
    this.ChangeWeapons(null, null, true);
  }

  public func Reset() -> Void {
    this.ChangeWeapons(this.initialRight, this.initialLeft, false);
  }

  private func CaptureWeapon(slotID: TweakDBID) -> ref<VirtualAtelierPreviewWeapon> {
    let item: ref<ItemObject> = this.transactionSystem.GetItemInSlot(this.puppet, slotID);
    let weapon: ref<VirtualAtelierPreviewWeapon>;
    if IsDefined(item) {
      weapon = new VirtualAtelierPreviewWeapon();
      weapon.itemID = item.GetItemID();
    };
    return weapon;
  }

  private func IsSameWeapon(weapon: ref<VirtualAtelierPreviewWeapon>, itemID: ItemID) -> Bool {
    return IsDefined(weapon) && Equals(ItemID.GetTDBID(weapon.itemID), ItemID.GetTDBID(itemID));
  }

  private func PrepareWeapon(itemID: ItemID) -> ref<VirtualAtelierPreviewWeapon> {
    let weapon: ref<VirtualAtelierPreviewWeapon>;
    if this.IsSameWeapon(this.initialRight, itemID) {
      return this.initialRight;
    };
    if this.IsSameWeapon(this.initialLeft, itemID) {
      return this.initialLeft;
    };

    weapon = new VirtualAtelierPreviewWeapon();
    weapon.itemID = this.transactionSystem.CreatePreviewItemID(itemID);
    if !this.transactionSystem.HasItem(this.puppet, weapon.itemID) {
      if !this.transactionSystem.GivePreviewItemByItemID(this.puppet, itemID) {
        return null;
      };
      ArrayPush(this.givenWeapons, weapon);
    };
    return weapon;
  }

  private func CanAddLeftWeapon(weapon: ref<VirtualAtelierPreviewWeapon>) -> Bool {
    let rightData: wref<gameItemData>;
    let leftData: wref<gameItemData>;
    if !this.isSelectingWeapons || !IsDefined(this.rightWeapon) || IsDefined(this.leftWeapon) || !IsDefined(this.player) {
      return false;
    };
    if !IsDefined(PlayerDevelopmentSystem.GetData(this.player)) {
      return false;
    };

    rightData = this.transactionSystem.GetItemData(this.puppet, this.rightWeapon.itemID);
    leftData = this.transactionSystem.GetItemData(this.puppet, weapon.itemID);
    if !IsDefined(rightData) || !IsDefined(leftData) {
      return false;
    };
    if !rightData.CanDualWield(this.player) || !leftData.CanDualWield(this.player) {
      return false;
    };
    // GetPlacementSlot silently falls back to the right slot without a second placement.
    if NotEquals(EquipmentSystem.GetPlacementSlot(this.rightWeapon.itemID, true), t"AttachmentSlots.WeaponLeft") || NotEquals(EquipmentSystem.GetPlacementSlot(weapon.itemID, true), t"AttachmentSlots.WeaponLeft") {
      return false;
    };
    return this.transactionSystem.CanPlaceItemInSlot(this.puppet, t"AttachmentSlots.WeaponLeft", weapon.itemID);
  }

  private func ChangeWeapons(right: ref<VirtualAtelierPreviewWeapon>, left: ref<VirtualAtelierPreviewWeapon>, isSelecting: Bool) -> Bool {
    let previousRight: ref<VirtualAtelierPreviewWeapon> = this.rightWeapon;
    let previousLeft: ref<VirtualAtelierPreviewWeapon> = this.leftWeapon;
    if !IsDefined(this.puppet) {
      return false;
    };

    // Keep the old inventory entries until both attachment operations have succeeded.
    if !this.ApplyWeapons(right, left) {
      if !this.ApplyWeapons(previousRight, previousLeft) {
        if !this.IsInSlot(t"AttachmentSlots.WeaponRight", previousRight) {
          this.rightWeapon = null;
        };
        if !this.IsInSlot(t"AttachmentSlots.WeaponLeft", previousLeft) {
          this.leftWeapon = null;
        };
      };
      this.ReleaseUnusedWeapons();
      return false;
    };

    this.rightWeapon = right;
    this.leftWeapon = left;
    this.isSelectingWeapons = isSelecting;
    this.ReleaseUnusedWeapons();
    return true;
  }

  private func ApplyWeapons(right: ref<VirtualAtelierPreviewWeapon>, left: ref<VirtualAtelierPreviewWeapon>) -> Bool {
    return this.ClearDifferentWeapon(t"AttachmentSlots.WeaponLeft", left)
      && this.ClearDifferentWeapon(t"AttachmentSlots.WeaponRight", right)
      && this.AttachWeapon(t"AttachmentSlots.WeaponRight", right)
      && this.AttachWeapon(t"AttachmentSlots.WeaponLeft", left);
  }

  private func IsInSlot(slotID: TweakDBID, weapon: ref<VirtualAtelierPreviewWeapon>) -> Bool {
    return IsDefined(weapon) && (this.transactionSystem.HasItemInSlot(this.puppet, slotID, weapon.itemID) || this.transactionSystem.IsSlotSpawningItem(this.puppet, slotID, weapon.itemID));
  }

  private func ClearDifferentWeapon(slotID: TweakDBID, weapon: ref<VirtualAtelierPreviewWeapon>) -> Bool {
    if this.IsInSlot(slotID, weapon) || (this.transactionSystem.IsSlotEmpty(this.puppet, slotID) && !this.transactionSystem.IsSlotSpawningAnyItem(this.puppet, slotID)) {
      return true;
    };
    return this.transactionSystem.RemoveItemFromSlot(this.puppet, slotID, true);
  }

  private func AttachWeapon(slotID: TweakDBID, weapon: ref<VirtualAtelierPreviewWeapon>) -> Bool {
    if !IsDefined(weapon) || this.IsInSlot(slotID, weapon) {
      return true;
    };
    return this.transactionSystem.CanPlaceItemInSlot(this.puppet, slotID, weapon.itemID) && this.transactionSystem.AddItemToSlot(this.puppet, slotID, weapon.itemID, true);
  }

  private func ReleaseUnusedWeapons() -> Bool {
    let weapon: ref<VirtualAtelierPreviewWeapon>;
    let released: Bool = true;
    let i: Int32 = ArraySize(this.givenWeapons) - 1;
    while i >= 0 {
      weapon = this.givenWeapons[i];
      if weapon != this.rightWeapon && weapon != this.leftWeapon {
        if !this.IsInSlot(t"AttachmentSlots.WeaponRight", weapon) && !this.IsInSlot(t"AttachmentSlots.WeaponLeft", weapon) && (!this.transactionSystem.HasItem(this.puppet, weapon.itemID) || this.transactionSystem.RemoveItem(this.puppet, weapon.itemID, 1)) {
          ArrayErase(this.givenWeapons, i);
        } else {
          released = false;
        };
      };
      i -= 1;
    };
    return released;
  }
}
