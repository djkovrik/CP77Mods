module VirtualAtelier.Helpers
import VirtualAtelier.Core.*

public abstract class AtelierButtonHintsHelper {

  public static func AddInitialPreviewHint(controller: ref<FullscreenVendorGameController>) {
    let actions: ref<AtelierActions>;
    if !controller.GetIsVirtual() {
      actions = AtelierActions.Get(controller.GetPlayerControlledObject());
      controller.m_buttonHintsController.AddButtonHint(actions.togglePreviewVendor, AtelierTexts.PreviewEnable());
    };
  }

  public static func ToggleAtelierControlHints(buttonHints: ref<ButtonHints>, playerObject: ref<GameObject>, show: Bool) -> Void {
    let actions: ref<AtelierActions> = AtelierActions.Get(playerObject);

    if show {
      if NotEquals(actions.zoom, n"") {
        buttonHints.AddButtonHint(actions.zoom, AtelierTexts.Zoom());
      };
      buttonHints.AddButtonHint(actions.resetGarment, AtelierTexts.PreviewReset());
      buttonHints.AddButtonHint(actions.removeAllGarment, AtelierTexts.PreviewRemoveAllGarment());
      buttonHints.AddButtonHint(actions.removePreviewGarment, AtelierTexts.PreviewRemovePreviewGarment());
      buttonHints.AddButtonHint(actions.move, AtelierTexts.Move());
    } else {
      buttonHints.RemoveButtonHint(actions.move);
      buttonHints.RemoveButtonHint(actions.removePreviewGarment);
      buttonHints.RemoveButtonHint(actions.removeAllGarment);
      buttonHints.RemoveButtonHint(actions.resetGarment);
      buttonHints.RemoveButtonHint(actions.zoom);
    };
  }

  public static func ToggleVendorButtonHints(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) -> Void {
    let player: ref<GameObject> = controller.GetPlayerControlledObject();
    let actions: ref<AtelierActions> = AtelierActions.Get(player);
    let buttonHints: ref<ButtonHints> = controller.m_buttonHintsController;

    buttonHints.RemoveButtonHint(actions.togglePreviewVendor);

    if isPreviewMode {
      // Remove vanilla game hints
      buttonHints.RemoveButtonHint(n"back");
      buttonHints.RemoveButtonHint(n"sell_junk");
      buttonHints.RemoveButtonHint(n"toggle_comparison_tooltip");
      // Show preview mode hint
      buttonHints.AddButtonHint(actions.togglePreviewVendor, AtelierTexts.PreviewDisable());
    } else {
      // Restore vanilla game hints
      buttonHints.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
      buttonHints.AddButtonHint(n"sell_junk", GetLocalizedText("UI-UserActions-SellJunk"));
      buttonHints.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText(controller.m_isComparisionDisabled ? "UI-UserActions-EnableComparison" : "UI-UserActions-DisableComparison"));
      // Show preview mode hint
      buttonHints.AddButtonHint(actions.togglePreviewVendor, AtelierTexts.PreviewEnable());
    };

    // Toggle Atelier preview control hints
    AtelierButtonHintsHelper.ToggleAtelierControlHints(buttonHints, player, isPreviewMode);
  }
}
/*
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

    let actionNames: ref<VirtualAtelierActionNames> = VirtualAtelierActionNames.Get(controller.GetPlayerControlledObject());

    if show {
      controller.m_buttonHintsController.AddButtonHint(actionNames.previewModeToggleName, actionNames.previewModeTogglePurchaseLabel);
    } else {
      controller.m_buttonHintsController.RemoveButtonHint(actionNames.previewModeToggleName);
    };
  }
*/
