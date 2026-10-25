module VirtualAtelier.UI

public class VirtualStoreItemController extends inkVirtualCompoundItemController {

  public let data: ref<VendorInventoryItemData>;

  public let itemViewController: wref<InventoryItemDisplayController>;

  private let dualWieldIcon: wref<inkWidget>;

  private let slotWidget: wref<inkWidget>;

  public let isSpawnInProgress: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
  }

  public final func OnDataChanged(value: Variant) -> Void {
    let displayToCreate: CName = n"itemDisplay";
    this.data = FromVariant<ref<IScriptable>>(value) as VendorInventoryItemData;
    if !IsDefined(this.data) {
      this.UpdateControllerData();
      return;
    };
    if Equals(InventoryItemData.GetEquipmentArea(this.data.ItemData), gamedataEquipmentArea.Weapon) {
      displayToCreate = n"weaponDisplay";
    };
    if !this.isSpawnInProgress {
      if !IsDefined(this.itemViewController) {
        this.isSpawnInProgress = true;
        ItemDisplayUtils.AsyncSpawnCommonSlotControllerVA(this, this.GetRootWidget(), displayToCreate, n"OnSpawned");
      } else {
        this.UpdateControllerData();
      };
    };
  }

  protected cb func OnSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.isSpawnInProgress = false;
    let container: ref<inkCompoundWidget> = widget as inkCompoundWidget;
    this.slotWidget = widget;
    this.dualWieldIcon = null;
    if !IsDefined(widget) {
      return false;
    };
    this.itemViewController = widget.GetController() as InventoryItemDisplayController;
    if IsDefined(container) {
      this.dualWieldIcon = container.GetWidget(n"weaponWrapper/container/dualWieldWrapper/dualWieldInactive");
    };
    this.UpdateControllerData();
  }

  private final func UpdateControllerData() -> Void {
    let applyDLCAddedIndicator: Bool;
    if IsDefined(this.slotWidget) {
      this.slotWidget.SetVisible(IsDefined(this.data));
    };
    if !IsDefined(this.data) || !IsDefined(this.itemViewController) {
      if IsDefined(this.dualWieldIcon) {
        this.dualWieldIcon.SetVisible(false);
      };
      return;
    };
    if this.data.IsVendorItem {
      this.itemViewController.Setup(this.data.ItemData, ItemDisplayContext.Vendor, this.data.IsEnoughMoney);
      applyDLCAddedIndicator = InventoryItemData.GetGameItemData(this.data.ItemData).HasTag(n"DLCAdded") && this.data.IsDLCAddedActiveItem;
      this.itemViewController.SetDLCNewIndicator(applyDLCAddedIndicator);
    } else {
      this.itemViewController.Setup(this.data.ItemData, ItemDisplayContext.VendorPlayer);
    };
    if IsDefined(this.dualWieldIcon) {
      this.dualWieldIcon.SetVisible(Equals(InventoryItemData.GetEquipmentArea(this.data.ItemData), gamedataEquipmentArea.Weapon) && InventoryItemData.CanDualWield(this.data.ItemData));
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
