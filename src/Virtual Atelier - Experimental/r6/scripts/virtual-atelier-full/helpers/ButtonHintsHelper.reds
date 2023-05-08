module VirtualAtelier.Helpers
import VirtualAtelier.Core.*

public abstract class AtelierButtonHintsHelper {
  
  public static func AddPreviewModeToggleButtonHint(controller: ref<FullscreenVendorGameController>) {
    if !controller.GetIsVirtual() {
      let vendorPreviewButtonHint: ref<VendorPreviewButtonHint> = VendorPreviewButtonHint.Get(controller.GetPlayerControlledObject());
      controller.m_buttonHintsController.AddButtonHint(
        vendorPreviewButtonHint.previewModeToggleName,
        vendorPreviewButtonHint.previewModeToggleEnableLabel
      );
    };
  }

  public static func UpdateButtonHints(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) {
    let vendorPreviewButtonHint: ref<VendorPreviewButtonHint> = VendorPreviewButtonHint.Get(controller.GetPlayerControlledObject());
    let isVirtual: Bool = controller.GetIsVirtual();

    if (isPreviewMode) {
      controller.m_buttonHintsController.RemoveButtonHint(n"back");
      controller.m_buttonHintsController.RemoveButtonHint(n"sell_junk");
      controller.m_buttonHintsController.RemoveButtonHint(n"toggle_comparison_tooltip");

      if (!isVirtual) {
        controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleName,vendorPreviewButtonHint.previewModeToggleDisableLabel);
      };
      if NotEquals(vendorPreviewButtonHint.zoomName, n"") {
        controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.zoomName, vendorPreviewButtonHint.zoomLabel);
      };

      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.resetGarmentName, vendorPreviewButtonHint.resetGarmentLabel);
      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.removeAllGarmentName, vendorPreviewButtonHint.removeAllGarmentLabel);
      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.removePreviewGarmentName, vendorPreviewButtonHint.removePreviewGarmentLabel);
      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.moveName, vendorPreviewButtonHint.moveLabel);
    } else {
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.previewModeToggleName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.resetGarmentName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.removeAllGarmentName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.zoomName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.moveName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.removePreviewGarmentName);

      if (!isVirtual) {
        controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleName, vendorPreviewButtonHint.previewModeToggleEnableLabel);
      };
      
      controller.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
      controller.m_buttonHintsController.AddButtonHint(n"sell_junk", GetLocalizedText("UI-UserActions-SellJunk"));
      controller.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText(controller.m_isComparisionDisabled ? "UI-UserActions-EnableComparison" : "UI-UserActions-DisableComparison"));
    };
  }

  public static func UpdatePurchaseHints(controller: ref<FullscreenVendorGameController>, show: Bool) -> Void {
    let isVirtual: Bool = controller.GetIsVirtual();
    if !isVirtual {
      return ;
    };

    let vendorPreviewButtonHint: ref<VendorPreviewButtonHint> = VendorPreviewButtonHint.Get(controller.GetPlayerControlledObject());

    if show {
      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleName, vendorPreviewButtonHint.previewModeTogglePurchaseLabel);
    } else {
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.previewModeToggleName);
    };
  }
}