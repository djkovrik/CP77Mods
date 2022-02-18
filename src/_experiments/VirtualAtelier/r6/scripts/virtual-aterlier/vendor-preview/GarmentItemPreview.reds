module VendorPreview.GarmentItemPreviewGameController

import VendorPreview.ItemPreviewManager.*

@addField(GarmentItemPreviewGameController)
private let m_isLeftMouseDown: Bool;

@addField(GarmentItemPreviewGameController)
private let m_isRightMouseDown: Bool;

@addField(GarmentItemPreviewGameController)
private let m_additionalData: ref<PreviewInventoryItemPreviewData>;

@wrapMethod(GarmentItemPreviewGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.m_additionalData = this.GetRootWidget().GetUserData(n"InventoryItemPreviewData") as PreviewInventoryItemPreviewData;

  ItemPreviewManager.AdjustGarmentPreviewWidgets(this);
}

@wrapMethod(GarmentItemPreviewGameController)
protected cb func OnPreviewInitialized() -> Bool {
  // Remove widget parts added in 1.5
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let bg = root.GetWidget(n"bg") as inkWidget;
  let window = root.GetWidget(n"wrapper/window") as inkWidget;
  bg.SetVisible(false);
  window.SetVisible(false);
  wrappedMethod();
}

@addMethod(GarmentItemPreviewGameController)
private func GetIsVirtual() -> Bool {
  return Equals(this.m_additionalData.displayContext, ItemDisplayContext.VendorPlayer);
}

@replaceMethod(GarmentItemPreviewGameController)
protected cb func OnUninitialize() -> Bool {
  ItemPreviewManager.GetInstance().ResetGarment();
}

@replaceMethod(GarmentItemPreviewGameController)
protected cb func OnGlobalPress(e: ref<inkPointerEvent>) -> Bool {
  if e.IsAction(n"mouse_left") {
    this.m_isLeftMouseDown = true;
  }

  if e.IsAction(n"world_map_fake_rotate") {
    this.m_isRightMouseDown = true;
  }
}

@replaceMethod(GarmentItemPreviewGameController)
protected cb func OnGlobalRelease(e: ref<inkPointerEvent>) -> Bool {
  if e.IsAction(n"mouse_left") {
    this.m_isLeftMouseDown = false;
  }

  if e.IsAction(n"world_map_fake_rotate") {
    this.m_isRightMouseDown = false;
  }

  if e.IsAction(n"cancel") {
    this.m_data.token.TriggerCallback(null);
  };
}

@replaceMethod(GarmentItemPreviewGameController)
protected func HandleAxisInput(event: ref<inkPointerEvent>) -> Void {
  ItemPreviewManager.OnGarmentPreviewAxisInput(this, event);
}

@replaceMethod(GarmentItemPreviewGameController)
protected cb func OnRelativeInput(event: ref<inkPointerEvent>) -> Bool {
  ItemPreviewManager.OnGarmentPreviewRelativeInput(this, event);
}

@addField(GarmentItemPreviewGameController)
let m_bbOnEquipmentChangedID: ref<CallbackHandle>;

@wrapMethod(GarmentItemPreviewGameController)
protected final func SetViewData(itemID: ItemID) -> Void {
  wrappedMethod(itemID);
  let p: ref<gamePuppet> = this.GetGamePuppet();
  ItemPreviewManager.CreateInstance(p, this);
}

@addMethod(GarmentItemPreviewGameController)
protected cb func OnSetCameraSetupEvent(index: Uint32, slotName: CName) -> Bool {
  let animFeature: ref<AnimFeature_Paperdoll> = new AnimFeature_Paperdoll();
    
  let zoomArea: InventoryPaperdollZoomArea = IntEnum(index);

  animFeature.inventoryScreen = Equals(zoomArea, InventoryPaperdollZoomArea.Default);
  animFeature.inventoryScreen_Weapon = Equals(zoomArea, InventoryPaperdollZoomArea.Weapon);
  animFeature.inventoryScreen_Legs = Equals(zoomArea, InventoryPaperdollZoomArea.Legs);
  animFeature.inventoryScreen_Feet = Equals(zoomArea, InventoryPaperdollZoomArea.Feet);
  animFeature.inventoryScreen_Cyberware = Equals(zoomArea, InventoryPaperdollZoomArea.Cyberware);
  animFeature.inventoryScreen_QuickSlot = Equals(zoomArea, InventoryPaperdollZoomArea.QuickSlot);
  animFeature.inventoryScreen_Consumable = Equals(zoomArea, InventoryPaperdollZoomArea.Consumable);
  animFeature.inventoryScreen_Outfit = Equals(zoomArea, InventoryPaperdollZoomArea.Outfit);
  animFeature.inventoryScreen_Head = Equals(zoomArea, InventoryPaperdollZoomArea.Head);
  animFeature.inventoryScreen_Face = Equals(zoomArea, InventoryPaperdollZoomArea.Face);
  animFeature.inventoryScreen_InnerChest = Equals(zoomArea, InventoryPaperdollZoomArea.InnerChest);
  animFeature.inventoryScreen_OuterChest = Equals(zoomArea, InventoryPaperdollZoomArea.OuterChest);
  
  AnimationControllerComponent.ApplyFeature(this.GetGamePuppet(), n"Paperdoll", animFeature);
}