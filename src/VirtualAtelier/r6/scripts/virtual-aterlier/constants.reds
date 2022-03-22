module VendorPreview.constants

public class VendorPreviewButtonHint {
  public let previewModeToggleName: CName;
  public let previewModeToggleNameBackpack: CName;
  public let previewModeToggleEnableLabel: String;
  public let previewModeToggleDisableLabel: String;
  public let previewModeTogglePurchaseLabel: String;

  public let resetGarmentName: CName;
  public let resetGarmentLabel: String;

  public let removeAllGarmentName: CName;
  public let removeAllGarmentLabel: String;
  
  public let removePreviewGarmentName: CName;
  public let removePreviewGarmentLabel: String;
  
  public let moveName: CName;
  public let moveLabel: String;

  public let zoomName: CName;
  public let zoomLabel: String;
  
  public static func Get() -> ref<VendorPreviewButtonHint> {
    let vendorPreviewButtonHint = new VendorPreviewButtonHint();

    vendorPreviewButtonHint.previewModeToggleName = n"UI_PrintDebug";
    vendorPreviewButtonHint.previewModeToggleNameBackpack = n"UI_Unequip";
    vendorPreviewButtonHint.previewModeToggleEnableLabel = VirtualAtelierText.PreviewEnable();
    vendorPreviewButtonHint.previewModeToggleDisableLabel = VirtualAtelierText.PreviewDisable();
    vendorPreviewButtonHint.previewModeTogglePurchaseLabel = VirtualAtelierText.PreviewPurchase();

    vendorPreviewButtonHint.resetGarmentName = n"world_map_filter_navigation_down";
    vendorPreviewButtonHint.resetGarmentLabel = VirtualAtelierText.PreviewReset();

    vendorPreviewButtonHint.removeAllGarmentName = n"world_map_menu_open_quest_static";
    vendorPreviewButtonHint.removeAllGarmentLabel = VirtualAtelierText.PreviewRemoveAllGarment();

    vendorPreviewButtonHint.removePreviewGarmentName = n"disassemble_item";
    vendorPreviewButtonHint.removePreviewGarmentLabel = VirtualAtelierText.PreviewRemovePreviewGarment();

    vendorPreviewButtonHint.moveName = n"world_map_fake_move";
    vendorPreviewButtonHint.moveLabel = VirtualAtelierText.PreviewMove();

    vendorPreviewButtonHint.zoomName = n"mouse_wheel";
    vendorPreviewButtonHint.zoomLabel = VirtualAtelierText.PreviewRotate();

    return vendorPreviewButtonHint;
  }
}

public class VirtualAtelierConfig {
  public static func NumOfVirtualStoresPerRow() -> Int32 = 6
  public static func NumOfRowsTotal() -> Int32  = 2
  public static func StoresPerPage() -> Int32 = VirtualAtelierConfig.NumOfVirtualStoresPerRow() * VirtualAtelierConfig.NumOfRowsTotal()
}
