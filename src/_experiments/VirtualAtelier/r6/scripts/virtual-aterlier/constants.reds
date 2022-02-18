module VendorPreview.constants

public class VendorPreviewButtonHint {
  public let previewModeToggleName: CName;
  public let previewModeToggleEnableLabel: String;
  public let previewModeToggleDisableLabel: String;
  public let previewModeTogglePurchaseLabel: String;

  public let resetGarmentName: CName;
  public let resetGarmentLabel: String;

  public let removeAllGarmentName: CName;
  public let removeAllGarmentLabel: String;
  
  public let removePreviewGarmentName: CName;
  public let removePreviewGarmentLabel: String;
  
  public let rotateName: CName;
  public let rotateLabel: String;

  public let moveName: CName;
  public let moveLabel: String;

  public let zoomName: CName;
  public let zoomLabel: String;
  
  public static func Get() -> ref<VendorPreviewButtonHint> {
    let vendorPreviewButtonHint = new VendorPreviewButtonHint();

    vendorPreviewButtonHint.previewModeToggleName = n"UI_PrintDebug";
    vendorPreviewButtonHint.previewModeToggleEnableLabel = "Enable Preview";
    vendorPreviewButtonHint.previewModeToggleDisableLabel = "Disable Preview";
    vendorPreviewButtonHint.previewModeTogglePurchaseLabel = "Purchase";

    vendorPreviewButtonHint.resetGarmentName = n"world_map_filter_navigation_down";
    vendorPreviewButtonHint.resetGarmentLabel = "Reset Preview";

    vendorPreviewButtonHint.removeAllGarmentName = n"world_map_menu_open_quest_static";
    vendorPreviewButtonHint.removeAllGarmentLabel = "Remove All Garment";

    vendorPreviewButtonHint.removePreviewGarmentName = n"disassemble_item";
    vendorPreviewButtonHint.removePreviewGarmentLabel = "Remove Preview Garment";

    vendorPreviewButtonHint.rotateName = n"world_map_fake_move";
    vendorPreviewButtonHint.rotateLabel = "Rotate";

    vendorPreviewButtonHint.moveName = n"world_map_fake_rotate";
    vendorPreviewButtonHint.moveLabel = "Move";

    vendorPreviewButtonHint.zoomName = n"mouse_wheel";
    vendorPreviewButtonHint.zoomLabel = "Zoom";

    return vendorPreviewButtonHint;
  }
}

public func GetNumOfVirtualStoresPerRow() -> Int32 {
  return 6;
}
