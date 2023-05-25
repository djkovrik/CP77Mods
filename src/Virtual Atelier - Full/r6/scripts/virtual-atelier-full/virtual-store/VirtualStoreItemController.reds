module VirtualAtelier.UI

public class VirtualStoreItemController extends inkVirtualCompoundItemController {

  public let data: ref<VendorInventoryItemData>;

  public let itemViewController: wref<InventoryItemDisplayController>;

  public let isSpawnInProgress: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
  }

  public final func OnDataChanged(value: Variant) -> Void {
    let displayToCreate: CName = n"itemDisplay";
    this.data = FromVariant<ref<IScriptable>>(value) as VendorInventoryItemData;
    if Equals(InventoryItemData.GetEquipmentArea(this.data.ItemData), gamedataEquipmentArea.Weapon) {
      displayToCreate = n"weaponDisplay";
    };
    if !this.isSpawnInProgress {
      if !IsDefined(this.itemViewController) {
        this.isSpawnInProgress = true;
        ItemDisplayUtils.AsyncSpawnCommonSlotController(this, this.GetRootWidget(), displayToCreate, n"OnSpawned");
      } else {
        this.UpdateControllerData();
      };
    };
  }

  protected cb func OnSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.isSpawnInProgress = false;
    this.itemViewController = widget.GetController() as InventoryItemDisplayController;
    this.UpdateControllerData();
  }

  private final func UpdateControllerData() -> Void {
    let applyDLCAddedIndicator: Bool;
    if this.data.IsVendorItem {
      this.itemViewController.Setup(this.data.ItemData, ItemDisplayContext.Vendor, this.data.IsEnoughMoney);
      applyDLCAddedIndicator = InventoryItemData.GetGameItemData(this.data.ItemData).HasTag(n"DLCAdded") && this.data.IsDLCAddedActiveItem;
      this.itemViewController.SetDLCNewIndicator(applyDLCAddedIndicator);
    } else {
      this.itemViewController.Setup(this.data.ItemData, ItemDisplayContext.VendorPlayer);
    };
  }

  protected cb func OnSelected(itemController: wref<inkVirtualCompoundItemController>, discreteNav: Bool) -> Bool {
    let widget: wref<inkWidget>;
    if discreteNav {
      widget = this.GetRootWidget();
      this.SetCursorOverWidget(widget);
    };
  }
}
