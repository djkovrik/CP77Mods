module VirtualAtelier.UI
import VirtualAtelier.Helpers.*
import VirtualAtelier.Systems.*

public class VirtualAtelierStoreController extends gameuiMenuGameController {
  private let player: wref<PlayerPuppet>;
  private let previewManager: wref<VirtualAtelierPreviewManager>;
  private let previewPopupToken: ref<inkGameNotificationToken>;

  protected cb func OnInitialize() -> Bool {
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.previewManager = VirtualAtelierPreviewManager.GetInstance(this.player.GetGame());
    this.previewManager.SetPreviewState(true);
    this.previewPopupToken = AtelierNotificationTokensHelper.GetGarmentPreviewNotificationToken(this, ItemDisplayContext.VendorPlayer) as inkGameNotificationToken;
  }

  protected cb func OnUninitialize() -> Bool {
    this.previewManager.SetPreviewState(false);
    this.previewPopupToken.TriggerCallback(null);
  }
}
