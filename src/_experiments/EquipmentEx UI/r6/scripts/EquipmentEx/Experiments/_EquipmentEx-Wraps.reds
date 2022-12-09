import EquipmentEx.OutfitSystem

@addMethod(VendorItemVirtualController)
protected cb func IsSlotHeader() -> Bool {
  return Equals(this.GetRootWidget().GetName(), n"slot_ex");
}

@wrapMethod(VendorItemVirtualController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if this.IsSlotHeader() {
    let container: ref<inkVerticalPanel> = new inkVerticalPanel();
    container.SetName(n"CustomHeaders");
    container.SetHAlign(inkEHorizontalAlign.Left);
    container.SetVAlign(inkEVerticalAlign.Center);
    container.SetAnchor(inkEAnchor.CenterLeft);
    container.SetAnchorPoint(0.0, 0.5);

    let label: ref<inkText> = new inkText();
    label.SetName(n"HeaderLabelPrimary");
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetFontSize(56);
    label.SetLetterCase(textLetterCase.UpperCase);
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", n"MainColors.Red");
    label.SetFitToContent(true);
    
    this.customHeaderPrimary = label;
    this.customHeaderPrimary.Reparent(container);

    label = new inkText();
    label.SetName(n"HeaderLabelSecondary");
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetFontSize(36); // 42
    label.SetLetterCase(textLetterCase.UpperCase);
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", n"MainColors.Blue");
    label.SetFitToContent(true);
    
    this.customHeaderSecondary = label;
    this.customHeaderSecondary.Reparent(container);

    this.customHeaderContainer = container;
    this.customHeaderContainer.Reparent(this.GetRootCompoundWidget());
  }
}

@wrapMethod(VendorItemVirtualController)
public final func OnDataChanged(value: Variant) -> Void {
  if this.IsSlotHeader() {
    this.m_newData = FromVariant<ref<IScriptable>>(value) as VendorUIInventoryItemData;

    if IsDefined(this.m_newData) && this.m_newData.IsSlotHeader() {
      this.customHeaderPrimary.SetText(this.m_newData.ItemData.CategoryName);

      if ItemID.IsValid(this.m_newData.ItemData.ID) {
        this.customHeaderSecondary.SetText(this.m_newData.ItemData.Name);
        this.customHeaderSecondary.BindProperty(n"tintColor", n"MainColors.Blue");
      } else {
        this.customHeaderSecondary.SetText(GetLocalizedTextByKey(n"UI-Labels-EmptySlot"));
        this.customHeaderSecondary.BindProperty(n"tintColor", n"MainColors.Grey");
      }
    }
  } else {
    wrappedMethod(value);
  }
}

@wrapMethod(UIInventoryItemsManager)
public final func IsItemEquipped(itemID: ItemID) -> Bool {
  let outfitSystem = OutfitSystem.GetInstance(this.m_player.GetGame());
  return outfitSystem.IsActive() ? outfitSystem.IsEquipped(itemID) : wrappedMethod(itemID);
}
