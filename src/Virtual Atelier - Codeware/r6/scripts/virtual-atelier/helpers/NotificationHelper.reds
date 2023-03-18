public abstract class AtelierNotificationHelper {

  public static func GetItemPreviewNotificationToken(controller: ref<gameuiMenuGameController>, inventoryItem: ref<UIInventoryItem>) -> ref<inkGameNotificationToken> {
    let previewData: ref<InventoryItemPreviewData> = ItemPreviewHelper.GetPreviewData(controller, inventoryItem, false);
    return controller.ShowGameNotification(previewData);
  }

  public static func GetGarmentPreviewNotificationToken(controller: ref<gameuiMenuGameController>, displayContext: ItemDisplayContext) -> ref<inkGameNotificationToken> {
    let notificationName: CName = n"base\\gameplay\\gui\\widgets\\notifications\\garment_item_preview.inkwidget";
    let previewData: ref<PreviewInventoryItemPreviewData> = new PreviewInventoryItemPreviewData();
    previewData.queueName = n"modal_popup";
    previewData.notificationName = notificationName;
    previewData.isBlocking = false;
    previewData.useCursor = false;
    previewData.displayContext = displayContext;
    return controller.ShowGameNotification(previewData);
  }

  public static func GetGarmentPreviewNotificationToken(controller: ref<gameuiInGameMenuGameController>, displayContext: ItemDisplayContext) -> ref<inkGameNotificationToken> {
    let notificationName: CName = n"base\\gameplay\\gui\\widgets\\notifications\\garment_item_preview.inkwidget";
    let previewData: ref<PreviewInventoryItemPreviewData> = new PreviewInventoryItemPreviewData();
    previewData.queueName = n"modal_popup";
    previewData.notificationName = notificationName;
    previewData.isBlocking = false;
    previewData.useCursor = false;
    previewData.displayContext = displayContext;
    return controller.ShowGameNotification(previewData);
  }
}
