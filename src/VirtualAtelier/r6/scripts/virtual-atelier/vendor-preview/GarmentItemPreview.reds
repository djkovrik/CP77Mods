module VendorPreview.GarmentItemPreviewGameController

import VendorPreview.ItemPreviewManager.*
import VendorPreview.utils.*

@addField(WardrobeSetPreviewGameController)
private let m_isLeftMouseDown: Bool;

@addField(WardrobeSetPreviewGameController)
private let m_additionalData: ref<PreviewInventoryItemPreviewData>;

@addField(WardrobeSetPreviewGameController)
private let m_atelierActive: Bool;

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnInitialize() -> Bool {
  this.m_atelierActive = GetAllBlackboardDefs().atelierPreviewActive;
  
  wrappedMethod();

  if this.m_atelierActive {
    this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
    this.m_additionalData = this.GetRootWidget().GetUserData(n"InventoryItemPreviewData") as PreviewInventoryItemPreviewData;
    ItemPreviewManager.AdjustGarmentPreviewWidgets(this);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnUninitialize() -> Bool {
  if this.m_atelierActive {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
    ItemPreviewManager.GetInstance().ResetGarment();
  };
  wrappedMethod();
}

@addMethod(WardrobeSetPreviewGameController)
private func GetIsVirtual() -> Bool {
  return Equals(this.m_additionalData.displayContext, ItemDisplayContext.VendorPlayer);
}


@addMethod(WardrobeSetPreviewGameController)
protected cb func OnGlobalPress(e: ref<inkPointerEvent>) -> Bool {
  if e.IsAction(n"mouse_left") {
    this.m_isLeftMouseDown = true;
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnGlobalRelease(e: ref<inkPointerEvent>) -> Bool {
  if this.m_atelierActive {
    if e.IsAction(n"mouse_left") {
      this.m_isLeftMouseDown = false;
    };
    if e.IsAction(n"cancel") {
      this.m_data.token.TriggerCallback(null);
    };
  } else {
    wrappedMethod(e);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected func HandleAxisInput(event: ref<inkPointerEvent>) -> Void {
  if this.m_atelierActive {
    ItemPreviewManager.OnGarmentPreviewAxisInput(this, event);
  } else {
    wrappedMethod(event);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnRelativeInput(event: ref<inkPointerEvent>) -> Bool {
  if this.m_atelierActive  {
    ItemPreviewManager.OnGarmentPreviewRelativeInput(this, event);
  } else {
    wrappedMethod(event);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnPreviewInitialized() -> Bool {
  wrappedMethod();
  if this.m_atelierActive && this.m_isNotification {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    ItemPreviewManager.CreateInstance(puppet, this);
  };
}

@addMethod(WardrobeSetPreviewGameController)
protected cb func OnSetCameraSetupEvent(index: Uint32, slotName: CName) -> Bool {
  let animFeature: ref<AnimFeature_Paperdoll> = new AnimFeature_Paperdoll();
  let zoomArea: InventoryPaperdollZoomArea = IntEnum(index);

  if this.m_atelierActive {
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
  };
}
