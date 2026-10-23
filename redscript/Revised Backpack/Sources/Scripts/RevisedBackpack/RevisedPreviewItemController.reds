module RevisedBackpack

public class RevisedPreviewItemController extends ItemPreviewGameController {

  protected cb func OnRevisedItemPreviewEvent(evt: ref<RevisedItemPreviewEvent>) -> Bool {
    if !evt.isGarment {
      this.PreviewItem(evt.itemId);
    };
  }
}
