module VendorPreview.Constants

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

  public let purchaseAll: CName;
  
  public static func Get(playerPuppet: ref<GameObject>) -> ref<VendorPreviewButtonHint> {
    let vendorPreviewButtonHint = new VendorPreviewButtonHint();
    let lastUsedPad: Bool = playerPuppet.PlayerLastUsedPad();

    if lastUsedPad {
      vendorPreviewButtonHint.previewModeToggleName = n"world_map_menu_cycle_filter_prev";
      vendorPreviewButtonHint.previewModeToggleNameBackpack = n"world_map_menu_cycle_filter_prev";
      vendorPreviewButtonHint.resetGarmentName = n"world_map_filter_navigation_down";
      vendorPreviewButtonHint.removeAllGarmentName = n"world_map_menu_open_quest_static";
      vendorPreviewButtonHint.removePreviewGarmentName = n"world_map_filter_navigation_up";
      vendorPreviewButtonHint.moveName = n"world_map_fake_move";
      vendorPreviewButtonHint.zoomName = n"";
      vendorPreviewButtonHint.purchaseAll = n"world_map_menu_cycle_filter_next";
    } else {
      vendorPreviewButtonHint.previewModeToggleName = n"UI_PrintDebug";
      vendorPreviewButtonHint.previewModeToggleNameBackpack = n"UI_Unequip";
      vendorPreviewButtonHint.resetGarmentName = n"world_map_filter_navigation_down";
      vendorPreviewButtonHint.removeAllGarmentName = n"world_map_menu_open_quest_static";
      vendorPreviewButtonHint.removePreviewGarmentName = n"disassemble_item";
      vendorPreviewButtonHint.moveName = n"world_map_fake_move";
      vendorPreviewButtonHint.zoomName = n"mouse_wheel";
      vendorPreviewButtonHint.purchaseAll = n"world_map_menu_open_quest";
    };

    vendorPreviewButtonHint.previewModeToggleEnableLabel = VirtualAtelierText.PreviewEnable();
    vendorPreviewButtonHint.previewModeToggleDisableLabel = VirtualAtelierText.PreviewDisable();
    vendorPreviewButtonHint.previewModeTogglePurchaseLabel = GetLocalizedTextByKey(n"UI-ScriptExports-Buy0");
    vendorPreviewButtonHint.resetGarmentLabel = VirtualAtelierText.PreviewReset();
    vendorPreviewButtonHint.removeAllGarmentLabel = VirtualAtelierText.PreviewRemoveAllGarment();
    vendorPreviewButtonHint.removePreviewGarmentLabel = VirtualAtelierText.PreviewRemovePreviewGarment();
    vendorPreviewButtonHint.moveLabel = GetLocalizedTextByKey(n"Gameplay-Player-ButtonHelper-Move");
    vendorPreviewButtonHint.zoomLabel = GetLocalizedTextByKey(n"UI-ResourceExports-Zoom");

    return vendorPreviewButtonHint;
  }
}
