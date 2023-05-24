module VirtualAtelier.UI
import VirtualAtelier.Systems.VirtualAtelierStoresManager
import VirtualAtelier.Config.VirtualAtelierConfig
import VirtualAtelier.Core.AtelierTexts
import VirtualAtelier.Logs.*

public class AtelierStoresListController extends inkGameController {
  private let player: wref<PlayerPuppet>;
  private let system: wref<VirtualAtelierStoresManager>;
  private let stores: array<ref<VirtualShop>>;
  private let buttonhints: wref<ButtonHints>;
  private let storesList: wref<inkVirtualGridController>;
  private let storesListScrollController: wref<inkScrollController>;
  private let storesDataSource: ref<ScriptableDataSource>;
  private let storesDataView: ref<AtelierStoresDataView>;
  private let storesTemplateClassifier: ref<AtelierStoresTemplateClassifier>;
  private let latestHovered: ref<VirtualShop>;
  private let config: ref<VirtualAtelierConfig>;

  protected cb func OnInitialize() {
    let inkSystem: ref<inkSystem> = GameInstance.GetInkSystem();
    let hudRoot: ref<inkCompoundWidget> = inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    let hintsContainer = hudRoot.GetWidget(n"AtelierButtonHints") as inkCompoundWidget;
    this.buttonhints = hintsContainer.GetWidgetByIndex(0).GetController() as ButtonHints;
    
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.system = VirtualAtelierStoresManager.GetInstance(this.player.GetGame());
    this.config = VirtualAtelierConfig.Get();

    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
    this.RefreshStores();

    if Equals(ArraySize(this.stores), 0) {
      this.ShowEmptyAtelierPage();
    } else {
      this.InitializeData();
      this.ShowSideImages();
      this.RefreshDataSource();
    };

    let depot: ref<ResourceDepot> = GameInstance.GetResourceDepot();
    if !depot.ArchiveExists("VirtualAtelier.archive") {
      AtelierLog("VirtualAtelier.archive not found, make sure that you have it installed.");
    };
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
    this.storesList.SetSource(null);
    this.storesList.SetClassifier(null);
    this.storesDataView.SetSource(null);
    this.storesDataView = null;
    this.storesDataSource = null;
    this.storesTemplateClassifier = null;
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(this.GetBookmarkAction()) {
      this.HandleBookmarkAction();
    };
  }

  protected cb func OnAtelierStoreSoundEvent(evt: ref<AtelierStoreSoundEvent>) -> Bool {
    this.PlaySound(evt.name);
  }

  protected cb func OnAtelierStoreClickEvent(evt: ref<AtelierStoreClickEvent>) -> Bool {
    let virtualStore: ref<VirtualShop>;
    let i: Int32 = 0;
    let count: Int32 = ArraySize(this.stores);
    while i < count {
      if Equals(this.stores[i].storeID, evt.storeID) {
        virtualStore = this.stores[i];
        break;
      } else {
        i += 1;
      };
    };

    if !IsDefined(virtualStore) {
      AtelierLog(s"Could not find requested store instance: \(evt.storeID)");
      return false;
    };

    let vendorData: ref<VendorPanelData> = new VendorPanelData();
    vendorData.data.vendorId = "VirtualVendor";
    vendorData.data.entityID = this.player.GetEntityID();
    vendorData.data.isActive = true;
    this.system.SetCurrentStore(virtualStore);
    GameInstance.GetUISystem(this.player.GetGame()).RequestVendorMenu(vendorData);
    return true;
  }

  protected cb func OnAtelierStoreHoverOverEvent(evt: ref<AtelierStoreHoverOverEvent>) -> Bool {
    let hintText: String;
    if evt.store.isBookmarked {
      hintText = AtelierTexts.RemoveFromFavorites();
    } else {
      hintText = AtelierTexts.AddToFavorites();
    };

    this.buttonhints.AddButtonHint(this.GetBookmarkAction(), hintText);
    this.latestHovered = evt.store;
  }

  protected cb func OnAtelierStoreHoverOutEvent(evt: ref<AtelierStoreHoverOutEvent>) -> Bool {
    this.buttonhints.RemoveButtonHint(this.GetBookmarkAction());
    this.latestHovered = null;
  }

  private func InitializeData() -> Void {
    this.storesList = this.GetChildWidgetByPath(n"scrollWrapper/scrollArea/StoresList").GetController() as inkVirtualGridController;
    this.storesListScrollController = this.GetChildWidgetByPath(n"scrollWrapper").GetControllerByType(n"inkScrollController") as inkScrollController;
    this.storesDataSource = new ScriptableDataSource();
    this.storesDataView = new AtelierStoresDataView();
    this.storesDataView.SetSource(this.storesDataSource);
    this.storesTemplateClassifier = new AtelierStoresTemplateClassifier();
    this.storesList.SetClassifier(this.storesTemplateClassifier);
    this.storesList.SetSource(this.storesDataView);
  }

  private func ShowSideImages() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let leftImage: ref<inkImage> = new inkImage();
    leftImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
    leftImage.SetTexturePart(n"chick V");
    leftImage.SetInteractive(false);
    leftImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    leftImage.SetFitToContent(true);
    leftImage.SetMargin(new inkMargin(0.0, 500.0, 0.0, 0.0));
    leftImage.SetTranslation(new Vector2(-560.0, 0.0));
    leftImage.Reparent(root);

    let rightImage: ref<inkImage> = new inkImage();
    rightImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
    rightImage.SetTexturePart(n"dude V");
    rightImage.SetInteractive(false);
    rightImage.SetHAlign(inkEHorizontalAlign.Right);
    rightImage.SetVAlign(inkEVerticalAlign.Bottom);
    rightImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    rightImage.SetFitToContent(true);
    rightImage.SetMargin(new inkMargin(3100.0, 600.0, 0.0, 0.0));
    rightImage.Reparent(root);
  }

  private func RefreshStores() -> Void {
    this.system.RefreshPersistedBookmarks();
    this.system.RefreshNewLabels();
    this.stores = this.system.GetStores();
    AtelierLog(s"Detected stores: \(ArraySize(this.stores))");
  }

  private func RefreshDataSource() -> Void {
    let items: array<ref<IScriptable>>;
    for store in this.stores {
      ArrayPush(items, store);
    };

    this.storesDataSource.Reset(items);
    this.storesDataView.UpdateView();
  }

  private func HandleBookmarkAction() -> Void {
    let store: ref<VirtualShop> = this.latestHovered;
    if IsDefined(store) {
      AtelierDebug(s"HandleBookmarkAction: \(store.storeID)", this.config);
      if store.isBookmarked {
        AtelierDebug(s" - remove bookmark \(store.storeID)", this.config);
        store.isBookmarked = false;
        this.system.RemoveBookmark(store.storeID);
      } else {
        AtelierDebug(s"- add bookmark \(store.storeID)", this.config);
        store.isBookmarked = true;
        this.system.AddBookmark(store.storeID);
      };

      this.latestHovered = store;
      this.QueueEvent(AtelierStoresRefreshEvent.Create(store));
      this.PlaySound(n"ui_menu_onpress");
    };
  }

  private func ShowEmptyAtelierPage() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let panel: ref<inkVerticalPanel> = new inkVerticalPanel();
    panel.SetName(n"emptyPanel");
    panel.SetFitToContent(true);
    panel.SetAnchor(inkEAnchor.Centered);
    panel.SetAnchorPoint(new Vector2(0.5, 0.5));
    panel.SetMargin(new inkMargin(0.0, 0.0, 160.0, 0.0));
    panel.Reparent(root);

    let emptyStateImage: ref<inkImage> = new inkImage();
    emptyStateImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
    emptyStateImage.SetName(n"empty");
    emptyStateImage.SetTexturePart(n"chick V");
    emptyStateImage.SetInteractive(false);
    emptyStateImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    emptyStateImage.SetFitToContent(true);
    emptyStateImage.Reparent(this.GetRootCompoundWidget());
    emptyStateImage.SetHAlign(inkEHorizontalAlign.Center);
    emptyStateImage.SetVAlign(inkEVerticalAlign.Center);
    emptyStateImage.Reparent(panel);

    let emptyStateMessage: ref<inkText> = new inkText();
    emptyStateMessage.SetName(n"empty");
    emptyStateMessage.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    emptyStateMessage.SetFontStyle(n"Semi-Bold");
    emptyStateMessage.SetFontSize(50);
    emptyStateMessage.SetLetterCase(textLetterCase.UpperCase);
    emptyStateMessage.SetText(AtelierTexts.EmptyPlaceholder());
    emptyStateMessage.SetFitToContent(true);
    emptyStateMessage.SetHAlign(inkEHorizontalAlign.Center);
    emptyStateMessage.SetVAlign(inkEVerticalAlign.Center);
    emptyStateMessage.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    emptyStateMessage.BindProperty(n"tintColor", n"MainColors.Blue");
    emptyStateMessage.SetSize(new Vector2(100.0, 32.0));
    emptyStateMessage.Reparent(panel);
  }

  private func GetBookmarkAction() -> CName {
    if this.player.PlayerLastUsedPad() {
      return n"restore_default_settings";
    };

    return n"world_map_menu_zoom_to_mappin";
  }

  private func PlaySound(name: CName) -> Void {
    GameObject.PlaySoundEvent(this.player, name);
  }
}
