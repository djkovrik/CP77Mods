module RevisedBackpack

public class RevisedPreviewGarmentController extends WardrobeSetPreviewGameController {

  public cb func OnPreviewInitialized() -> Bool {
    super.OnPreviewInitialized();
    this.PreviewUnequipFromSlot(t"AttachmentSlots.WeaponLeft");
    this.PreviewUnequipFromSlot(t"AttachmentSlots.WeaponRight");
  }

  public cb func OnUninitialize() -> Bool {
    this.CleanUpPuppet();
    super.OnUninitialize();
  }

  protected cb func OnRevisedItemPreviewEvent(evt: ref<RevisedItemPreviewEvent>) -> Bool {
    if evt.isGarment {
      this.ResetPuppetState();
      this.PreviewEquipAndForceShowItem(evt.itemId);
      this.ZoomToItem(evt.itemId);
    };
  }

  private final func ZoomToItem(itemId: ItemID) -> Void {
    let zoomArea: InventoryPaperdollZoomArea = this.GetZoomArea(itemId);
    let setCameraSetupEvent: ref<gameuiPuppetPreview_SetCameraSetupEvent> = new gameuiPuppetPreview_SetCameraSetupEvent();
    setCameraSetupEvent.setupIndex = Cast<Uint32>(EnumInt(zoomArea));
    this.QueueEvent(setCameraSetupEvent);
  }

  private final func ResetPuppetState() -> Void {
    this.ClearPuppet();

    if this.TryRestoreActiveWardrobeSet() {
      this.SyncUnderwearToEquipmentSystem();
    } else {
      this.RestorePuppetEquipment();
    };

    this.DelayedResetItemAppearanceInSlot(t"AttachmentSlots.Chest");
  }

  private final func GetZoomArea(itemId: ItemID) -> InventoryPaperdollZoomArea {
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(itemId);
    let equipmentArea: gamedataEquipmentArea = itemRecord.EquipArea().Type();

    if Equals(equipmentArea, gamedataEquipmentArea.Head) || Equals(equipmentArea, gamedataEquipmentArea.Face) {
      return InventoryPaperdollZoomArea.Head;
    };

    return InventoryPaperdollZoomArea.Default;
  }
}
