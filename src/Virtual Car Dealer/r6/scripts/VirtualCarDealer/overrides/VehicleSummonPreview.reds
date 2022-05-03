import CarDealer.Classes.PurchasableVehicle
import CarDealer.System.PurchasableVehicleSystem
import CarDealer.Utils.P

// Fix previews
@replaceMethod(VehiclesManagerPopupGameController)
protected func Select(previous: ref<inkVirtualCompoundItemController>, next: ref<inkVirtualCompoundItemController>) -> Void {
  let selectedItem: wref<VehiclesManagerListItemController> = next as VehiclesManagerListItemController;
  let vehicleData: ref<VehicleListItemData> = selectedItem.GetVehicleData();
  let system = PurchasableVehicleSystem.GetInstance(this.m_playerPuppet.GetGame());
  let recordId: TweakDBID = vehicleData.m_data.recordID;
  let record: ref<PurchasableVehicle>;
  if system.IsPurchasable(recordId) {
    // Purchasable vehicle
    record = system.GetRecord(recordId);
    if ResRef.IsValid(record.previewAtlasPath) {
      // Preview detected - set custom
      inkWidgetRef.SetVisible(this.m_icon, false);
      this.customVehicleIcon.SetVisible(true);
      this.customVehicleIcon.SetAtlasResource(record.previewAtlasPath);
      this.customVehicleIcon.SetTexturePart(record.previewPartName);
    } else {
      // No preview detected - call original
      this.customVehicleIcon.SetVisible(false);
      inkWidgetRef.SetVisible(this.m_icon, true);
      InkImageUtils.RequestSetImage(this, this.m_icon, vehicleData.m_icon.GetID());
    };
  } else {
    // Original vehicle
    this.customVehicleIcon.SetVisible(false);
    inkWidgetRef.SetVisible(this.m_icon, true);
    InkImageUtils.RequestSetImage(this, this.m_icon, vehicleData.m_icon.GetID());
  };
}

// -- Add new inkImage for custom preview
@addField(VehiclesManagerPopupGameController)
private let customVehicleIcon: ref<inkImage>;

@wrapMethod(VehiclesManagerPopupGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let container: ref<inkCanvas> = this.GetRootCompoundWidget().GetWidget(n"containerRoot/wrapper/container/image") as inkCanvas;
  let innerContainer: ref<inkCanvas> = new inkCanvas();
  innerContainer.SetName(n"InnerContainer");
  innerContainer.SetSize(new Vector2(500.0, 282.0));
  innerContainer.SetSizeRule(inkESizeRule.Fixed);
  innerContainer.SetHAlign(inkEHorizontalAlign.Left);
  innerContainer.SetVAlign(inkEVerticalAlign.Top);
  innerContainer.SetAnchor(inkEAnchor.TopLeft);
  innerContainer.SetMargin(new inkMargin(20.0, 120.0, 0.0, 0.0));
  innerContainer.SetAnchorPoint(new Vector2(0.0, 0.0));
  innerContainer.Reparent(container);

  this.customVehicleIcon = new inkImage();
  this.customVehicleIcon.SetName(n"CustomPreview");
  this.customVehicleIcon.SetInteractive(false);
  this.customVehicleIcon.SetAnchorPoint(new Vector2(0.5, 0.5));
  this.customVehicleIcon.SetFitToContent(true);
  this.customVehicleIcon.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  this.customVehicleIcon.SetSize(new Vector2(470.0, 265.0));
  this.customVehicleIcon.SetSizeRule(inkESizeRule.Fixed);
  this.customVehicleIcon.SetHAlign(inkEHorizontalAlign.Fill);
  this.customVehicleIcon.SetVAlign(inkEVerticalAlign.Fill);
  this.customVehicleIcon.SetAnchor(inkEAnchor.Fill);
  this.customVehicleIcon.SetAnchorPoint(new Vector2(0.5, 0.5));
  this.customVehicleIcon.Reparent(innerContainer);
}
