module VehicleSummonTweaks

private abstract class VehicleSummonFavoritesConfig {
  public static func Pin() -> String = "Pin"
  public static func Unpin() -> String = "Unpin"
}

@addField(VehiclesManagerPopupGameController)
private let buttonText: wref<inkText>;

@addField(VehiclesManagerPopupGameController)
private let currentItem: ref<VehicleListItemData>;

@addMethod(VehiclesManagerPopupGameController)
private func CreateButtonHintWidget() -> Void {
  let container: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidget(n"containerRoot") as inkCompoundWidget;

  let buttonHint: ref<inkWidget> = this.SpawnFromExternal(container, r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root");
  buttonHint.SetMargin(new inkMargin(460.0, 80.0, 0.0, 0.0));
  buttonHint.SetHAlign(inkEHorizontalAlign.Right);
  buttonHint.SetVAlign(inkEVerticalAlign.Bottom);
  buttonHint.SetAnchor(inkEAnchor.BottomCenter);
  buttonHint.SetAnchorPoint(new Vector2(0.0, 0.0));

  let buttonHintController: ref<ButtonHints> = buttonHint.GetController() as ButtonHints;
  buttonHintController.AddButtonHint(n"secondaryAction", "");

  let buttonText: ref<inkText> = new inkText();
  buttonText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  buttonText.BindProperty(n"tintColor", n"MainColors.ActiveRed");
  buttonText.SetLetterCase(textLetterCase.UpperCase);
  buttonText.SetFontSize(36);
  buttonText.SetText(VehicleSummonFavoritesConfig.Pin());
  buttonText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  buttonText.SetMargin(new inkMargin(460.0, 20.0, 0.0, 0.0));
  buttonText.SetHAlign(inkEHorizontalAlign.Right);
  buttonText.SetVAlign(inkEVerticalAlign.Bottom);
  buttonText.SetAnchor(inkEAnchor.BottomCenter);
  buttonText.SetAnchorPoint(new Vector2(0.0, 0.0));
  buttonText.Reparent(container);
  this.buttonText = buttonText;
}

@wrapMethod(VehiclesManagerPopupGameController)
protected func SetupVirtualList() -> Void {
  wrappedMethod();
  this.CreateButtonHintWidget();
}

@wrapMethod(VehiclesManagerPopupGameController)
protected func Select(previous: ref<inkVirtualCompoundItemController>, next: ref<inkVirtualCompoundItemController>) -> Void {
  wrappedMethod(previous, next);

  let currentItemController: wref<VehiclesManagerListItemController> = next as VehiclesManagerListItemController;
  this.currentItem = currentItemController.GetVehicleData();

  if this.currentItem.m_data.uiFavoriteIndex != -1 {
    this.buttonText.SetText(VehicleSummonFavoritesConfig.Unpin());
  } else {
    this.buttonText.SetText(VehicleSummonFavoritesConfig.Pin());
  };
}

@wrapMethod(VehiclesManagerListItemController)
protected cb func OnDataChanged(value: Variant) -> Bool {
  wrappedMethod(value);

  if this.m_vehicleData.m_data.uiFavoriteIndex != -1 {
    inkTextRef.SetText(this.m_label, s"* \(GetLocalizedTextByKey(this.m_vehicleData.m_displayName)) *");
  };
}
