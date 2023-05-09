module VirtualAtelier.UI

public class VirtualStoreItemController extends inkVirtualCompoundItemController {

  public let m_data: ref<VendorInventoryItemData>;

  public let m_newData: ref<VendorUIInventoryItemData>;

  public let m_itemViewController: wref<InventoryItemDisplayController>;

  public let m_isSpawnInProgress: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
  }

  public final func OnDataChanged(value: Variant) -> Void {
    this.m_newData = FromVariant<ref<IScriptable>>(value) as VendorUIInventoryItemData;
    let displayToCreate: CName = n"itemDisplay";
    if IsDefined(this.m_newData) {
      if this.m_newData.Item.IsWeapon() && !this.m_newData.Item.IsRecipe() {
        displayToCreate = n"weaponDisplay";
      };
    } else {
      this.m_data = FromVariant<ref<IScriptable>>(value) as VendorInventoryItemData;
      if Equals(InventoryItemData.GetEquipmentArea(this.m_data.ItemData), gamedataEquipmentArea.Weapon) {
        displayToCreate = n"weaponDisplay";
      };
    };
    if !this.m_isSpawnInProgress {
      if !IsDefined(this.m_itemViewController) {
        this.m_isSpawnInProgress = true;
        ItemDisplayUtils.AsyncSpawnCommonSlotController(this, this.GetRootWidget(), displayToCreate, n"OnSpawned");
      } else {
        this.UpdateControllerData();
      };
    };
  }

  protected cb func OnSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_isSpawnInProgress = false;
    this.m_itemViewController = widget.GetController() as InventoryItemDisplayController;
    this.UpdateControllerData();
  }

  private final func UpdateControllerData() -> Void {
    let applyDLCAddedIndicator: Bool;
    if IsDefined(this.m_newData) {
      if this.m_newData.IsVendorItem {
        this.m_itemViewController.Setup(this.m_newData.Item, this.m_newData.DisplayContextData, this.m_newData.IsEnoughMoney, false, false, this.m_newData.OverrideQuantity);
        applyDLCAddedIndicator = this.m_newData.Item.GetItemData().HasTag(n"DLCAdded") && this.m_data.IsDLCAddedActiveItem;
        this.m_itemViewController.SetDLCNewIndicator(applyDLCAddedIndicator);
      } else {
        this.m_itemViewController.Setup(this.m_newData.Item, this.m_newData.DisplayContextData);
      };
      this.m_itemViewController.SetComparisonState(this.m_newData.ComparisonState);
      this.m_itemViewController.SetBuybackStack(this.m_newData.IsBuybackStack);
      return;
    };
    if this.m_data.IsVendorItem {
      this.m_itemViewController.Setup(this.m_data.ItemData, ItemDisplayContext.Vendor, this.m_data.IsEnoughMoney);
      applyDLCAddedIndicator = InventoryItemData.GetGameItemData(this.m_data.ItemData).HasTag(n"DLCAdded") && this.m_data.IsDLCAddedActiveItem;
      this.m_itemViewController.SetDLCNewIndicator(applyDLCAddedIndicator);
    } else {
      this.m_itemViewController.Setup(this.m_data.ItemData, ItemDisplayContext.VendorPlayer);
    };
    this.m_itemViewController.SetComparisonState(this.m_data.ComparisonState);
    this.m_itemViewController.SetBuybackStack(this.m_data.IsBuybackStack);
  }

  protected cb func OnSelected(itemController: wref<inkVirtualCompoundItemController>, discreteNav: Bool) -> Bool {
    let widget: wref<inkWidget>;
    if discreteNav {
      widget = this.GetRootWidget();
      this.SetCursorOverWidget(widget);
    };
  }
}
