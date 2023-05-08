module VirtualAtelier.Systems

public class VirtualAtelierPreviewManager extends ScriptableSystem {

  private let transactionSystem: wref<TransactionSystem>;
  private let compatibilityHelper: wref<gameuiMenuGameController>;
  private let isPreviewActive: Bool;
  private let initialItems: array<wref<gameItemData>>;
  private let givenItems: array<ItemID>;
  private let puppetId: EntityID;
  private let screenWidthLimit: Float;

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
    ArrayClear(this.initialItems);
    this.puppetId = puppet.GetEntityID();
    let gamePuppet: ref<gamePuppet> = this.GetGamePuppet();
    this.transactionSystem.GetItemList(gamePuppet, this.initialItems);
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

  public func GetIsEquipped(itemId: ItemID) -> Bool {
    return ArrayContains(this.givenItems, itemId);
  }

  public func EquipItem(itemId: ItemID) -> Void {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    let placementSlot: TweakDBID = this.compatibilityHelper.GetAtelierPlacementSlot(itemId);

    let currentItemInSlot: ItemID = this.transactionSystem.GetItemInSlot(puppet, placementSlot).GetItemID();
    if this.GetIsEquipped(currentItemInSlot) {
      this.UnequipItem(currentItemInSlot);
    };

    this.transactionSystem.GiveItem(puppet, itemId, 1);
    this.transactionSystem.AddItemToSlot(puppet, placementSlot, itemId);
    ArrayPush(this.givenItems, itemId);
  }

  public func UnequipItem(itemId: ItemID) -> Void {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    let placementSlot: TweakDBID = this.compatibilityHelper.GetAtelierPlacementSlot(itemId);
    this.transactionSystem.RemoveItemFromSlot(puppet, placementSlot, true);
    this.transactionSystem.RemoveItem(puppet, itemId, 1);
    ArrayRemove(this.givenItems, itemId);
  }

  public func RemoveAllGarment() -> Void {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    if !IsDefined(puppet) { 
      return;
    };

    if ArraySize(this.initialItems) < 1 {
      return;
    };

    let j: Int32 = 0;
    while j < ArraySize(this.initialItems) {
      let currItemId: ItemID = this.initialItems[j].GetID();
      let isWeapon: Bool = RPGManager.IsItemWeapon(currItemId);
      let isClothing: Bool = RPGManager.IsItemClothing(currItemId);

      if (isWeapon || isClothing) {
        let currSlot: TweakDBID = this.compatibilityHelper.GetAtelierPlacementSlot(currItemId);
        this.transactionSystem.RemoveItemFromSlot(puppet, currSlot, true);
      }
     
      j += 1;
    };

    this.RemovePreviewGarment();
  }

  public func RemovePreviewGarment() -> Void {
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

    if ArraySize(this.initialItems) < 1 {
      return;
    };

    let j: Int32 = 0;
    while j < ArraySize(this.initialItems) {
      let currItemId: ItemID = this.initialItems[j].GetID();
      let currSlot = this.compatibilityHelper.GetAtelierPlacementSlot(currItemId);
      this.transactionSystem.AddItemToSlot(puppet, currSlot, currItemId);
      j += 1;
    };
  }

  public func ResetGarment() {
    this.RemovePreviewGarment();
    this.RevertInitialGarment();
  }

  public func TogglePreviewItem(itemId: ItemID) -> Void {
    if this.GetIsEquipped(itemId) {
      this.UnequipItem(itemId);
    } else {
      this.EquipItem(itemId);
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
