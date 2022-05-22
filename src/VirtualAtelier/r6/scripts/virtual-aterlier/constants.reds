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
  
  public static func Get(playerPuppet: ref<GameObject>) -> ref<VendorPreviewButtonHint> {
    let vendorPreviewButtonHint = new VendorPreviewButtonHint();
    let lastUsedPad: Bool = playerPuppet.PlayerLastUsedPad();

    if lastUsedPad {
      vendorPreviewButtonHint.previewModeToggleName = n"world_map_menu_toggle_custom_filter";
      vendorPreviewButtonHint.previewModeToggleNameBackpack = n"world_map_menu_toggle_custom_filter";
      vendorPreviewButtonHint.resetGarmentName = n"world_map_filter_navigation_down";
      vendorPreviewButtonHint.removeAllGarmentName = n"world_map_menu_open_quest_static";
      vendorPreviewButtonHint.removePreviewGarmentName = n"world_map_filter_navigation_up";
      vendorPreviewButtonHint.moveName = n"world_map_fake_move";
      vendorPreviewButtonHint.zoomName = n"";
    } else {
      vendorPreviewButtonHint.previewModeToggleName = n"UI_PrintDebug";
      vendorPreviewButtonHint.previewModeToggleNameBackpack = n"UI_Unequip";
      vendorPreviewButtonHint.resetGarmentName = n"world_map_filter_navigation_down";
      vendorPreviewButtonHint.removeAllGarmentName = n"world_map_menu_open_quest_static";
      vendorPreviewButtonHint.removePreviewGarmentName = n"disassemble_item";
      vendorPreviewButtonHint.moveName = n"world_map_fake_move";
      vendorPreviewButtonHint.zoomName = n"mouse_wheel";
    };

    vendorPreviewButtonHint.previewModeToggleEnableLabel = VirtualAtelierText.PreviewEnable();
    vendorPreviewButtonHint.previewModeToggleDisableLabel = VirtualAtelierText.PreviewDisable();
    vendorPreviewButtonHint.previewModeTogglePurchaseLabel = VirtualAtelierText.PreviewPurchase();
    vendorPreviewButtonHint.resetGarmentLabel = VirtualAtelierText.PreviewReset();
    vendorPreviewButtonHint.removeAllGarmentLabel = VirtualAtelierText.PreviewRemoveAllGarment();
    vendorPreviewButtonHint.removePreviewGarmentLabel = VirtualAtelierText.PreviewRemovePreviewGarment();
    vendorPreviewButtonHint.moveLabel = VirtualAtelierText.PreviewMove();
    vendorPreviewButtonHint.zoomLabel = VirtualAtelierText.PreviewRotate();
    return vendorPreviewButtonHint;
  }
}

public class VirtualAtelierConfig {
  public static func NumOfVirtualStoresPerRow() -> Int32 = 5
  public static func NumOfRowsTotal() -> Int32  = 2
  public static func StoresPerPage() -> Int32 = VirtualAtelierConfig.NumOfVirtualStoresPerRow() * VirtualAtelierConfig.NumOfRowsTotal()
}
