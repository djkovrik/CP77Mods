public abstract class AtelierWidgetsHelper {

  // Toggle the left side of the vendor inventory, which holds the player's items
  // It's hidden when previewing garments on puppet
  public static func TogglePlayerPanel(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) -> Void {
	  let playerPanelPath: inkWidgetPath = inkWidgetPath.Build(n"wrapper", n"wrapper", n"playerPanel");
	  controller.GetRootCompoundWidget().GetWidgetByPath(playerPanelPath).SetVisible(!isPreviewMode);
  }

  public static func ToggleCraftableItemsPanel(controller: ref<BackpackMainGameController>, isPreviewMode: Bool) {
    let i: Int32 = 0;
    let count: Int32 = ArraySize(controller.m_craftingMaterialsListItems);

    while i <= count {
      let currController = controller.m_craftingMaterialsListItems[i];
      currController.GetRootWidget().SetVisible(!isPreviewMode);
      i += 1;
    };
  }

  public static func ToggleVendorFilters(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) {
    if (controller.GetIsVirtual()) {
      return;
    } else {
      if (isPreviewMode) {
        inkWidgetRef.SetVisible(controller.m_vendorFiltersContainer, false);
        controller.m_vendorItemsDataView.SetFilterType(ItemFilterCategory.Clothes);
        controller.ToggleFilter(controller.m_vendorFiltersContainer, EnumInt(ItemFilterCategory.Clothes));
      } else {
        inkWidgetRef.SetVisible(controller.m_vendorFiltersContainer, true);
        controller.PopulateVendorInventory();
      };
    };
  }

  public static func AdjustGarmentPreviewWidgets(controller: ref<WardrobeSetPreviewGameController>) {
    AtelierInputHelper.RegisterGlobalInputListeners(controller);
    let rootCompoundWidget: ref<inkCompoundWidget> = controller.GetRootCompoundWidget();
    let backgroundWidget: wref<inkWidget> = rootCompoundWidget.GetWidget(n"bg");
    let previewWidget: ref<inkImage> = rootCompoundWidget.GetWidget(n"wrapper/preview") as inkImage;
    let windowWidget: ref<inkWidget> = rootCompoundWidget.GetWidget(n"wrapper/window") as inkWidget;

    previewWidget.SetMargin(0, 0, 960, 0);
    backgroundWidget.SetVisible(false);
    windowWidget.SetVisible(false);

    let transparencyInterpolator: ref<inkAnimTransparency>;
    let translationAnimation: ref<inkAnimDef> = new inkAnimDef();

    transparencyInterpolator = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(0.25);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetStartTransparency(0);
    transparencyInterpolator.SetEndTransparency(1);

    translationAnimation.AddInterpolator(transparencyInterpolator);
    previewWidget.PlayAnimation(translationAnimation);
  }

  public static func OnToggleGarmentPreview(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) {
    AtelierWidgetsHelper.TogglePlayerPanel(controller, isPreviewMode);
    AtelierButtonHintsHelper.UpdateButtonHints(controller, isPreviewMode);
    AtelierWidgetsHelper.ToggleVendorFilters(controller, isPreviewMode);
  }
}
