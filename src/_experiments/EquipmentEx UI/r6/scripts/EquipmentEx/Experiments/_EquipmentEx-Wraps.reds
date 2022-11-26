import EquipmentEx.OutfitSystem

@wrapMethod(VendorItemVirtualController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let container: ref<inkVerticalPanel> = new inkVerticalPanel();
  container.SetName(n"CustomHeaders");
  container.SetVisible(false);
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetVAlign(inkEVerticalAlign.Center);
  container.SetAnchor(inkEAnchor.CenterLeft);
  container.SetMargin(new inkMargin(10.0, 0.0, 0.0, 40.0));

  let label: ref<inkText> = new inkText();
  label.SetName(n"HeaderLabelPrimary");
  label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  label.SetFontSize(56);
  label.SetText(GetLocalizedTextByKey(n"HeaderLabel"));
  label.SetHAlign(inkEHorizontalAlign.Left);
  label.SetVAlign(inkEVerticalAlign.Bottom);
  label.SetAnchor(inkEAnchor.BottomLeft);
  label.SetAnchorPoint(0.0, 0.5);
  label.SetLetterCase(textLetterCase.OriginalCase);
  label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  label.BindProperty(n"tintColor", n"MainColors.Red");
  
  this.customHeaderPrimary = label;
  this.customHeaderPrimary.Reparent(container);

  label = new inkText();
  label.SetName(n"HeaderLabelSecondary");
  label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  label.SetFontSize(42);
  label.SetText(GetLocalizedTextByKey(n"HeaderLabel"));
  label.SetHAlign(inkEHorizontalAlign.Left);
  label.SetVAlign(inkEVerticalAlign.Bottom);
  label.SetAnchor(inkEAnchor.BottomLeft);
  label.SetAnchorPoint(0.0, 0.5);
  label.SetLetterCase(textLetterCase.OriginalCase);
  label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  label.BindProperty(n"tintColor", n"MainColors.Blue");

  this.customHeaderSecondary = label;
  this.customHeaderSecondary.Reparent(container);

  this.customHeaderContainer = container;
  this.customHeaderContainer.Reparent(this.GetRootCompoundWidget());
}

@wrapMethod(VendorItemVirtualController)
private final func UpdateControllerData() -> Void {
  wrappedMethod();

  if IsDefined(this.m_newData) {
    if this.m_newData.IsCustomHeader() {
      this.customHeaderPrimary.SetText(this.m_newData.customHeaderPrimary);
      this.customHeaderSecondary.SetText(this.m_newData.customHeaderSecondary);
      this.customHeaderContainer.SetVisible(true);
    };
    // TODO some better way maybe? 
    this.m_itemViewController.GetRootCompoundWidget().SetVisible(!this.m_newData.IsCustomHeader());
  };
}

@replaceMethod(UIInventoryItemsManager)
public final func IsItemEquipped(itemID: ItemID) -> Bool {
  return OutfitSystem.GetInstance(this.m_player.GetGame()).IsEquipped(itemID);
}
