import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.Helpers.AtelierWidgetsHelper

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnInitialize() -> Bool {
  this.previewManager = VirtualAtelierPreviewManager.GetInstance(this.GetPlayerControlledObject().GetGame());
  this.atelierActive = this.previewManager.IsPreviewActive();
  
  wrappedMethod();

  if this.atelierActive {
    this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
    this.additionalData = this.GetRootWidget().GetUserData(n"InventoryItemPreviewData") as PreviewInventoryItemPreviewData;
    AtelierWidgetsHelper.AdjustGarmentPreviewWidgets(this);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnPreviewInitialized() -> Bool {
  wrappedMethod();

  if this.atelierActive {
    this.previewManager.InitializePuppet(this.GetGamePuppet());
    this.previewManager.InitializeCompatibilityHelper(this);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnUninitialize() -> Bool {
  if this.atelierActive {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
    this.previewManager.ResetGarment();
  };

  wrappedMethod();
}

@addMethod(WardrobeSetPreviewGameController)
protected cb func OnGlobalPress(e: ref<inkPointerEvent>) -> Bool {
  if e.IsAction(n"mouse_left") {
    this.isLeftMouseDown = true;
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnPress(e: ref<inkPointerEvent>) -> Bool {
  if !this.atelierActive {
    wrappedMethod(e);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnGlobalRelease(e: ref<inkPointerEvent>) -> Bool {
  if this.atelierActive {
    if e.IsAction(n"mouse_left") {
      this.isLeftMouseDown = false;
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
  if this.atelierActive {
    AtelierInputHelper.OnGarmentPreviewAxisInput(this, event);
  } else {
    wrappedMethod(event);
  };
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnRelativeInput(event: ref<inkPointerEvent>) -> Bool {
  if this.atelierActive  {
    AtelierInputHelper.OnGarmentPreviewRelativeInput(this, event);
  } else {
    wrappedMethod(event);
  };
}

@addMethod(WardrobeSetPreviewGameController)
private func GetIsVirtual() -> Bool {
  return Equals(this.additionalData.displayContext, ItemDisplayContext.VendorPlayer);
}

@addMethod(WardrobeSetPreviewGameController)
protected cb func OnSetCameraSetupEvent(index: Uint32, slotName: CName) -> Bool {
  let animFeature: ref<AnimFeature_Paperdoll> = new AnimFeature_Paperdoll();
  let zoomArea: InventoryPaperdollZoomArea = IntEnum(index);

  if this.atelierActive {
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
