module VirtualAtelier.UI
import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Systems.VirtualAtelierStoresManager
import VirtualAtelier.Core.AtelierTexts
import VirtualAtelier.Logs.*

@if(ModuleExists("AtelierDelivery"))
import AtelierDelivery.*

public class AtelierStoresListController extends inkGameController {
  private let player: wref<PlayerPuppet>;
  private let system: wref<VirtualAtelierStoresManager>;
  private let stores: array<ref<VirtualShop>>;
  private let categories: array<VirtualStoreCategory>;
  private let buttonHints: wref<ButtonHints>;
  private let topMenu: wref<inkCompoundWidget>;
  private let storesList: wref<inkVirtualGridController>;
  private let storesListScrollController: wref<inkScrollController>;
  private let storesDataSource: ref<ScriptableDataSource>;
  private let storesDataView: ref<AtelierStoresDataView>;
  private let storesTemplateClassifier: ref<AtelierStoresTemplateClassifier>;
  private let latestHovered: ref<VirtualShop>;
  private let config: ref<VirtualAtelierConfig>;

  private let storesContainer: wref<inkCompoundWidget>;
  private let ordersContainer: wref<inkCompoundWidget>;
  private let categoriesContainer: wref<inkCompoundWidget>;

  private let buttonStores: wref<inkText>;
  private let buttonOrders: wref<inkText>;

  private let storesHovered: Bool = false;
  private let storesSelected: Bool = false;
  private let ordersHovered: Bool = false;
  private let ordersSelected: Bool = false;

  protected cb func OnInitialize() {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let hintsContainer: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"buttonHints") as inkCompoundWidget;
    this.buttonHints = AtelierStoresListButtonHints.Spawn(this, hintsContainer);
    
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.system = VirtualAtelierStoresManager.GetInstance(this.player.GetGame());
    this.config = VirtualAtelierConfig.Get();

    this.InitializeWidgets();
    this.RegisterCallbacks();
    this.RefreshStores();
    this.InitializeTabs();

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

    // First tab selection on load
    this.QueueEvent(VirtualStoreCategorySelectedEvent.Create(this.categories[0]));
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterCallbacks();
    this.storesList.SetSource(null);
    this.storesList.SetClassifier(null);
    this.storesDataView.SetSource(null);
    this.storesDataView = null;
    this.storesDataSource = null;
    this.storesTemplateClassifier = null;
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let name: CName = target.GetName();
    if Equals(name, n"virtualStores") {
      this.storesHovered = true;
      this.ordersHovered = false;
    };
    if Equals(name, n"activeOrders") {
      this.storesHovered = false;
      this.ordersHovered = true;
    };

    this.RefreshControlsColor();
    this.QueueEvent(AtelierStoreSoundEvent.Create(n"ui_menu_hover"));
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let name: CName = target.GetName();
    if Equals(name, n"virtualStores") {
      this.storesHovered = false;
    };
    if Equals(name, n"activeOrders") {
      this.ordersHovered = false;
    };
    this.RefreshControlsColor();
  }

  protected cb func OnPress(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let name: CName = target.GetName();
    if evt.IsAction(n"click") {
      if Equals(name, n"virtualStores") {
        this.storesSelected = true;
        this.storesContainer.SetVisible(true);
        this.categoriesContainer.SetVisible(true);
        this.AnimateScale(this.buttonStores, 1.1);
        this.ordersSelected = false;
        this.ordersContainer.SetVisible(false);
        this.AnimateScale(this.buttonOrders, 1.0);
      };
      
      if Equals(name, n"activeOrders") {
        this.storesSelected = false;
        this.storesContainer.SetVisible(false);
        this.categoriesContainer.SetVisible(false);
        this.AnimateScale(this.buttonStores, 1.0);
        this.ordersSelected = true;
        this.ordersContainer.SetVisible(true);
        this.AnimateScale(this.buttonOrders, 1.1);
      };

      this.RefreshControlsColor();
      this.QueueEvent(AtelierStoreSoundEvent.Create(n"ui_menu_onpress"));
    };
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(this.GetBookmarkAction()) {
      this.HandleBookmarkAction();
    };

    if evt.IsAction(n"back") || evt.IsAction(n"UI_Cancel") || evt.IsAction(n"UI_Exit")  {
      this.ClearButtonHint();
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

    this.ClearButtonHint();

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

    this.buttonHints.AddButtonHint(this.GetBookmarkAction(), hintText);
    this.latestHovered = evt.store;
  }

  protected cb func OnAtelierStoreHoverOutEvent(evt: ref<AtelierStoreHoverOutEvent>) -> Bool {
    this.ClearButtonHint();
  }

  protected cb func OnVirtualStoreCategorySelectedEvent(evt: ref<VirtualStoreCategorySelectedEvent>) -> Bool {
    this.storesDataView.SetActiveCategory(evt.category);
    this.storesDataView.Filter();
    this.storesDataView.UpdateView();
  }

  private func RegisterCallbacks() -> Void {
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
    this.buttonStores.RegisterToCallback(n"OnPress", this, n"OnPress");
    this.buttonStores.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.buttonStores.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.buttonOrders.RegisterToCallback(n"OnPress", this, n"OnPress");
    this.buttonOrders.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.buttonOrders.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
  }

  private func UnregisterCallbacks() -> Void {
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
    this.buttonStores.UnregisterFromCallback(n"OnPress", this, n"OnPress");
    this.buttonStores.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.buttonStores.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.buttonOrders.UnregisterFromCallback(n"OnPress", this, n"OnPress");
    this.buttonOrders.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.buttonOrders.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
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

  private func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.topMenu = root.GetWidgetByPathName(n"topMenu") as inkCompoundWidget;
    this.storesContainer = root.GetWidgetByPathName(n"scrollWrapper") as inkCompoundWidget;
    this.ordersContainer = root.GetWidgetByPathName(n"ordersContainer") as inkCompoundWidget;
    this.categoriesContainer = root.GetWidgetByPathName(n"categories") as inkCompoundWidget;
    let ordersComponent: ref<inkComponent> = this.GetOrdersComponent();
    ordersComponent.Reparent(this.ordersContainer);

    let virtualStores: ref<inkText> = new inkText();
    virtualStores.SetName(n"virtualStores");
    virtualStores.SetText(GetLocalizedTextByKey(n"VA-Virtual-Stores"));
    virtualStores.SetFitToContent(true);
    virtualStores.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    virtualStores.SetScale(new Vector2(1.1, 1.1));
    virtualStores.SetFontSize(60);
    virtualStores.SetInteractive(true);
    virtualStores.SetLetterCase(textLetterCase.UpperCase);
    virtualStores.SetMargin(new inkMargin(0.0, 0.0, 48.0, 0.0));
    virtualStores.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    virtualStores.BindProperty(n"tintColor", n"MainColors.ActiveWhite");
    virtualStores.Reparent(this.topMenu);
    this.buttonStores = virtualStores;

    let activeOrders: ref<inkText> = new inkText();
    activeOrders.SetName(n"activeOrders");
    activeOrders.SetText(GetLocalizedTextByKey(n"VA-Active-Orders"));
    activeOrders.SetFitToContent(true);
    activeOrders.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    activeOrders.SetFontSize(60);
    activeOrders.SetInteractive(true);
    activeOrders.SetLetterCase(textLetterCase.UpperCase);
    activeOrders.SetMargin(new inkMargin(48.0, 0.0, 0.0, 0.0));
    activeOrders.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    activeOrders.BindProperty(n"tintColor", n"MainColors.Gold");
    activeOrders.Reparent(this.topMenu);
    this.buttonOrders = activeOrders;

    this.storesSelected = true;
    this.RefreshControlsColor();
  }

  private func InitializeTabs() -> Void {
    let categoryTab: ref<AtelierStoresCategoryTab>;
    for category in this.categories {
      categoryTab = AtelierStoresCategoryTab.Create(category);
      categoryTab.Reparent(this.categoriesContainer);
    };
  }

  private func RefreshControlsColor() -> Void {
    let storesColor: CName;
    let ordersColor: CName;

    if !this.storesHovered && !this.storesSelected {
      storesColor = n"MainColors.White";
    } else if this.storesHovered && !this.storesSelected {
      storesColor = n"MainColors.Red";
    } else if !this.storesHovered && this.storesSelected {
      storesColor = n"MainColors.Gold";
    } else if this.storesHovered && this.storesSelected  {
      storesColor = n"MainColors.ActiveRed";
    };

    if !this.ordersHovered && !this.ordersSelected {
      ordersColor = n"MainColors.White";
    } else if this.ordersHovered && !this.ordersSelected {
      ordersColor = n"MainColors.Red";
    } else if !this.ordersHovered && this.ordersSelected {
      ordersColor = n"MainColors.Gold";
    } else if this.ordersHovered && this.ordersSelected  {
      ordersColor = n"MainColors.ActiveRed";
    };

    this.buttonStores.BindProperty(n"tintColor", storesColor);
    this.buttonOrders.BindProperty(n"tintColor", ordersColor);
  }

  private func ShowSideImages() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let leftImage: ref<inkImage> = new inkImage();
    leftImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
    leftImage.SetTexturePart(n"chick V");
    leftImage.SetInteractive(false);
    leftImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    leftImage.SetFitToContent(true);
    leftImage.SetMargin(new inkMargin(400.0, 720.0, 0.0, 0.0));
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
    rightImage.SetMargin(new inkMargin(3500.0, 720.0, 0.0, 0.0));
    rightImage.Reparent(root);
  }

  private func RefreshStores() -> Void {
    this.system.RefreshPersistedBookmarks();
    this.system.RefreshNewLabels();
    this.system.BuildCategories();
    this.stores = this.system.GetStores();
    this.categories = this.system.GetCategories();
    AtelierDebug(s"Detected stores: \(ArraySize(this.stores))");
    AtelierDebug(s"Detected categories: \(ArraySize(this.categories))");
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
      AtelierDebug(s"HandleBookmarkAction: \(store.storeID)");
      if store.isBookmarked {
        AtelierDebug(s" - remove bookmark \(store.storeID)");
        store.isBookmarked = false;
        this.system.RemoveBookmark(store.storeID);
      } else {
        AtelierDebug(s"- add bookmark \(store.storeID)");
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

  private func ClearButtonHint() -> Void {
    this.buttonHints.RemoveButtonHint(this.GetBookmarkAction());
    this.latestHovered = null;
  }

  private final func AnimateScale(target: ref<inkWidget>, endScale: Float) -> Void {
    let scaleAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
    scaleInterpolator.SetType(inkanimInterpolationType.Linear);
    scaleInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    scaleInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    scaleInterpolator.SetStartScale(target.GetScale());
    scaleInterpolator.SetEndScale(new Vector2(endScale, endScale));
    scaleInterpolator.SetDuration(0.1);
    scaleAnimDef.AddInterpolator(scaleInterpolator);
    target.PlayAnimation(scaleAnimDef);
  }

  @if(!ModuleExists("AtelierDelivery"))
  private func GetOrdersComponent() -> ref<inkComponent> {
    return new UnderConstructionComponent();
  }

  @if(ModuleExists("AtelierDelivery"))
  private func GetOrdersComponent() -> ref<inkComponent> {
    return new OrdersManagerComponent();
  }
}
