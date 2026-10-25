module VirtualAtelier.Systems

public class VirtualAtelierPreviewManager extends ScriptableSystem {

  private let transactionSystem: wref<TransactionSystem>;
  private let compatibilityHelper: wref<gameuiMenuGameController>;
  private let isPreviewActive: Bool;
  private let initialItems: array<wref<gameItemData>>;
  private let givenItems: array<ItemID>;
  private let puppetId: EntityID;
  private let screenWidthLimit: Float;
  private let isVirtualStorePreview: Bool;
  private let weaponPreview: ref<VirtualAtelierWeaponPreview>;

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
    this.InitializeInternals();
  }

  private func InitializeInternals() -> Void {
    this.transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
    this.screenWidthLimit = this.CalculateScreenWidthLimit();
  }

  public static func GetInstance(gi: GameInstance) -> ref<VirtualAtelierPreviewManager> {
    let system: ref<VirtualAtelierPreviewManager> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"VirtualAtelier.Systems.VirtualAtelierPreviewManager") as VirtualAtelierPreviewManager;
    return system;
  }

  public func InitializePuppet(puppet: ref<gamePuppet>) -> Void {
    if !IsDefined(puppet) || this.puppetId == puppet.GetEntityID() {
      return;
    };
    this.ResetGarment();
    ArrayClear(this.givenItems);
    ArrayClear(this.initialItems);
    this.puppetId = puppet.GetEntityID();
    this.transactionSystem.GetItemList(puppet, this.initialItems);
    if this.isVirtualStorePreview {
      let player: wref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
      this.weaponPreview = VirtualAtelierWeaponPreview.Create(puppet, player);
    } else {
      this.weaponPreview = null;
    };
  }

  public func UninitializePuppet(puppet: ref<gamePuppet>) -> Void {
    let emptyId: EntityID;
    if !IsDefined(puppet) || this.puppetId != puppet.GetEntityID() {
      return;
    };
    this.ResetGarment();
    this.weaponPreview = null;
    this.compatibilityHelper = null;
    ArrayClear(this.givenItems);
    ArrayClear(this.initialItems);
    this.puppetId = emptyId;
  }

  public func SetVirtualStorePreview(active: Bool) -> Void {
    if this.isVirtualStorePreview && !active {
      this.UninitializePuppet(this.GetGamePuppet());
    };
    this.isVirtualStorePreview = active;
  }

  public func InitializeCompatibilityHelper(helper: ref<gameuiMenuGameController>) -> Void {
    this.compatibilityHelper = helper;
  }

  public func GetGamePuppet() -> ref<gamePuppet> {
    return GameInstance.FindEntityByID(this.GetGameInstance(), this.puppetId) as gamePuppet;
  }

  public func IsPreviewActive() -> Bool {
    return this.isPreviewActive;
  }

  public func SetPreviewState(active: Bool) -> Void {
    this.isPreviewActive = active;
  }

  public func GetIsEquipped(itemID: ItemID) -> Bool {
    if IsDefined(this.weaponPreview) && this.weaponPreview.GetIsEquipped(itemID) {
      return true;
    };
    return ArrayContains(this.givenItems, itemID);
  }

  public func EquipItem(itemID: ItemID) -> Void {
    if IsDefined(this.weaponPreview) && RPGManager.IsItemWeapon(itemID) {
      if !this.weaponPreview.GetIsEquipped(itemID) {
        this.weaponPreview.ToggleItem(itemID);
      };
      return;
    };
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    let placementSlot: TweakDBID = this.compatibilityHelper.GetAtelierPlacementSlot(itemID);

    let currentItemInSlot: ItemID = this.transactionSystem.GetItemInSlot(puppet, placementSlot).GetItemID();
    if this.GetIsEquipped(currentItemInSlot) {
      this.UnequipItem(currentItemInSlot);
    };

    this.transactionSystem.GiveItem(puppet, itemID, 1);
    this.transactionSystem.AddItemToSlot(puppet, placementSlot, itemID);
    ArrayPush(this.givenItems, itemID);
  }

  public func UnequipItem(itemID: ItemID) -> Void {
    if IsDefined(this.weaponPreview) && RPGManager.IsItemWeapon(itemID) {
      if this.weaponPreview.GetIsEquipped(itemID) {
        this.weaponPreview.ToggleItem(itemID);
      };
      return;
    };
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    let placementSlot: TweakDBID = this.compatibilityHelper.GetAtelierPlacementSlot(itemID);
    this.transactionSystem.RemoveItemFromSlot(puppet, placementSlot, true);
    this.transactionSystem.RemoveItem(puppet, itemID, 1);
    ArrayRemove(this.givenItems, itemID);
  }

  public func RemoveAllGarment() -> Void {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    if !IsDefined(puppet) { 
      return;
    };

    if ArraySize(this.initialItems) < 1 && !IsDefined(this.weaponPreview) {
      return;
    };

    if IsDefined(this.weaponPreview) {
      this.weaponPreview.RemoveAll();
    };

    let j: Int32 = 0;
    while j < ArraySize(this.initialItems) {
      let currItemId: ItemID = this.initialItems[j].GetID();
      let isWeapon: Bool = RPGManager.IsItemWeapon(currItemId);
      let isClothing: Bool = RPGManager.IsItemClothing(currItemId);

      if isClothing || (isWeapon && !IsDefined(this.weaponPreview)) {
        let currSlot: TweakDBID = this.compatibilityHelper.GetAtelierPlacementSlot(currItemId);
        this.transactionSystem.RemoveItemFromSlot(puppet, currSlot, true);
      }
     
      j += 1;
    };

    this.RemovePreviewGarment();
  }

  public func RemovePreviewGarment() -> Void {
    if IsDefined(this.weaponPreview) {
      this.weaponPreview.RemovePreview();
    };
    this.RemoveGivenItems();
  }

  private func RemoveGivenItems() -> Void {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    if !IsDefined(puppet) { 
      return;
    };

    if ArraySize(this.givenItems) < 1 {
      return;
    };

    let i: Int32 = 0;
    while i < ArraySize(this.givenItems) {
      let currItemId: ItemID = this.givenItems[i];
      let currSlot: TweakDBID = this.compatibilityHelper.GetAtelierPlacementSlot(currItemId);
      this.transactionSystem.RemoveItemFromSlot(puppet, currSlot, true);
      this.transactionSystem.RemoveItem(puppet, currItemId, 1);

      i += 1;
    };

    ArrayClear(this.givenItems);
  }

  public func RevertInitialGarment() -> Void {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    if !IsDefined(puppet) { 
      return;
    };

    if IsDefined(this.weaponPreview) {
      this.weaponPreview.Reset();
    };

    if ArraySize(this.initialItems) < 1 {
      return;
    };

    let j: Int32 = 0;
    while j < ArraySize(this.initialItems) {
      let currItemId: ItemID = this.initialItems[j].GetID();
      if !IsDefined(this.weaponPreview) || !RPGManager.IsItemWeapon(currItemId) {
        let currSlot = this.compatibilityHelper.GetAtelierPlacementSlot(currItemId);
        this.transactionSystem.AddItemToSlot(puppet, currSlot, currItemId);
      };
      j += 1;
    };
  }

  public func ResetGarment() {
    if IsDefined(this.weaponPreview) {
      this.RemoveGivenItems();
    } else {
      this.RemovePreviewGarment();
    };
    this.RevertInitialGarment();
  }

  public func TogglePreviewItem(itemID: ItemID) -> Void {
    if this.GetIsEquipped(itemID) {
      this.UnequipItem(itemID);
    } else {
      this.EquipItem(itemID);
    };
  }

  public func GetScreenWidthLimit() -> Float {
    return this.screenWidthLimit;
  }

  private func CalculateScreenWidthLimit() -> Float {
    let settings: ref<UserSettings> = GameInstance.GetSettingsSystem(this.GetGameInstance());
    let config: ref<ConfigVarListString> = settings.GetVar(n"/video/display", n"Resolution") as ConfigVarListString;
    let resolution: String = config.GetValue();
    let dimensions: array<String> = StrSplit(resolution, "x");
    return StringToFloat(dimensions[0]) / 2.0;
  }
}
