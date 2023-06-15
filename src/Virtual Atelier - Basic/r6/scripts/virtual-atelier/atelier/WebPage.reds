import VendorPreview.StoresManager.VirtualAtelierStoresSystem
import VendorPreview.Config.VirtualAtelierInternals
import VendorPreview.Utils.AtelierDebug
import VendorPreview.Utils.AtelierUtils
import VendorPreview.Codeware.UI.*
import VendorPreview.UI.*

@addMethod(WebPage)
public func DisplayWarning(message: String) {
  let simpleScreenMessage: SimpleScreenMessage;
  simpleScreenMessage.isShown = true;
  simpleScreenMessage.duration = 8.0;
  simpleScreenMessage.message = message;
  simpleScreenMessage.isInstant = true;

  GameInstance.GetBlackboardSystem(this.owner.GetGame()).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.WarningMessage, ToVariant(simpleScreenMessage), true);
}

@addMethod(WebPage)
private func PopulateAtelierView(owner: ref<GameObject>) {
  this.owner = owner;
  this.system = VirtualAtelierStoresSystem.GetInstance(owner);
  this.atelierPages = new inkVerticalPanel();
  this.rootAtelierPanel = this.GetWidget(n"page/linkPanel/panel") as inkVerticalPanel;
  if (!IsDefined(this.rootAtelierPanel)) {
    this.rootAtelierPanel = this.GetWidget(n"Page/linkPanel/panel") as inkVerticalPanel;
  };
  this.rootAtelierPanel.RemoveAllChildren();

  this.stores = this.system.GetStores();
  this.atelierTotalStores = ArraySize(this.stores);

  this.atelierCurrentPageIndex = 0;
  this.atelierTotalPages = 1;
  let i: Int32 = 1;
  while i < this.atelierTotalStores {
    if Equals(i % 10, 0) {
      this.atelierTotalPages += 1;
    };
    i += 1;
  };

  AtelierDebug(s"TOTAL STORES: \(this.atelierTotalStores)");
  AtelierDebug(s"TOTAL PAGES: \(this.atelierTotalPages)");

  if this.atelierTotalStores >= 1 {
    this.ShowSideImages();
    this.PopulateAtelierPages();
    if this.atelierTotalPages > 1 {
      this.PopulatePaginationControls();
    };
    this.ShowCurrentPage();
  } else {
    this.ShowEmptyAtelierPage();
  };
}

@addMethod(WebPage)
private func PopulateAtelierPages() {
  let row: ref<inkHorizontalPanel>;
  let storeIndex: Int32 = 0;
  let rowCounter: Int32 = 0;
  let insideRowIndex: Int32 = 0;
  let insidePageIndex: Int32 = 0;
  let pageIndex: Int32 = 0;
  
  // Populate array
  while pageIndex < this.atelierTotalPages {
    let page: ref<inkVerticalPanel> = new inkVerticalPanel();
    page.SetName(StringToName(s"Page\(pageIndex)"));
    this.atelierPages.AddChildWidget(page);
    pageIndex += 1;
  };

  pageIndex = 0;
  while storeIndex < this.atelierTotalStores {
    let store: ref<VirtualShop> = this.stores[storeIndex];
    let parentPage: ref<inkVerticalPanel> = this.atelierPages.GetWidgetByIndex(pageIndex) as inkVerticalPanel;

    if insideRowIndex == 0 {
      rowCounter += 1;
      row = new inkHorizontalPanel();
      row.SetName(StringToName(s"atelier-row\(rowCounter)"));
      row.SetFitToContent(true);
      row.SetHAlign(inkEHorizontalAlign.Center);
      row.SetVAlign(inkEVerticalAlign.Center);
      row.SetPadding(new inkMargin(150.0, 90.0, 150.0, 0.0));
      parentPage.AddChildWidget(row);
    };

    let storeContainer: ref<inkVerticalPanel> = this.GetStore(store);
    row.AddChildWidget(storeContainer);

    insideRowIndex += 1;
    insidePageIndex += 1;
    storeIndex += 1;

    if insideRowIndex >= VirtualAtelierInternals.NumOfVirtualStoresPerRow() {
      insideRowIndex = 0;
    };

    if insidePageIndex >= VirtualAtelierInternals.StoresPerPage() {
      insidePageIndex = 0;
      rowCounter = 0;
      pageIndex += 1;
    };
  };

  AtelierUtils.CheckDuplicates(this.stores, this);
}

@addMethod(WebPage)
public func GetPaginationLabel() -> String {
  let prefix: String = VirtualAtelierText.PaginationPrefix();
  let conj: String = VirtualAtelierText.PaginationConj();
  return s"[ \(prefix) \(this.atelierCurrentPageIndex + 1) \(conj) \(this.atelierTotalPages) ]";
}

@addMethod(WebPage)
public func PopulatePaginationControls() -> Void {
  let panel: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  panel.SetName(n"Pagination");
  panel.SetFitToContent(true);
  panel.SetHAlign(inkEHorizontalAlign.Center);
  panel.SetVAlign(inkEVerticalAlign.Top);
  panel.SetAnchor(inkEAnchor.TopCenter);
  panel.SetAnchorPoint(new Vector2(0.5, 0.5));
  panel.SetMargin(new inkMargin(0.0, 120.0, 0.0, 0.0));

  this.navigationButtonPrev = AtelierTextButton.Create(n"ButtonPrev", VirtualAtelierText.PaginationPrev(), 68, n"MainColors.Blue", n"MainColors.ActiveBlue", new inkMargin(0.0, 0.0, 0.0, 0.0), true);
  this.navigationButtonPrev.RegisterToCallback(n"OnClick", this, n"OnClickPagination");
  this.navigationButtonPrev.Reparent(panel);

  this.navigationLabel = AtelierTextButton.Create(n"NavLabel", this.GetPaginationLabel(), 70, n"MainColors.Red", n"", new inkMargin(40.0, 0.0, 40.0, 0.0), false);
  this.navigationLabel.Reparent(panel);

  this.navigationButtonNext = AtelierTextButton.Create(n"ButtonNext", VirtualAtelierText.PaginationNext(), 68, n"MainColors.Blue", n"MainColors.ActiveBlue", new inkMargin(0.0, 0.0, 0.0, 0.0), true);
  this.navigationButtonNext.RegisterToCallback(n"OnClick", this, n"OnClickPagination");
  this.navigationButtonNext.Reparent(panel);

  panel.Reparent(this.rootAtelierPanel);

  this.RefreshPaginationControlsState();

  this.RegisterToCallback(n"OnHoverOver", this, n"OnElementHoverOver");
  this.RegisterToCallback(n"OnHoverOut", this, n"OnElementHoverOut");
}

@addMethod(WebPage)
protected cb func OnElementHoverOver(evt: ref<inkPointerEvent>) -> Bool {
  switch evt.GetTarget().GetName() {
    case n"ButtonPrev":
      if this.navigationButtonPrev.IsEnabled() {
        GameObject.PlaySoundEvent(this.owner, n"ui_menu_hover");
        this.navigationButtonPrev.SetHighlighted(true);
      };
      break;
    case n"ButtonNext":
      if this.navigationButtonNext.IsEnabled() {
        GameObject.PlaySoundEvent(this.owner, n"ui_menu_hover");
        this.navigationButtonNext.SetHighlighted(true);
      };
      break;
  };
}

@addMethod(WebPage)
protected cb func OnElementHoverOut(evt: ref<inkPointerEvent>) -> Bool {
  switch evt.GetTarget().GetName() {
    case n"ButtonPrev":
      this.navigationButtonPrev.SetHighlighted(false);
      break;
    case n"ButtonNext":
      this.navigationButtonNext.SetHighlighted(false);
      break;
  };
}

@addMethod(WebPage)
public func RefreshPaginationControlsState() -> Void {
  this.navigationButtonPrev.SetEnabled(NotEquals(this.atelierCurrentPageIndex, 0));
  this.navigationButtonNext.SetEnabled(NotEquals(this.atelierCurrentPageIndex, this.atelierTotalPages - 1));
  this.navigationLabel.UpdateText(this.GetPaginationLabel());
}

@addMethod(WebPage)
protected cb func OnClickPagination(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    let widgetName: CName = evt.GetTarget().GetName();
    if Equals(widgetName, n"ButtonPrev") && this.navigationButtonPrev.IsEnabled() {
      GameObject.PlaySoundEvent(this.owner, n"ui_menu_onpress");
      this.atelierCurrentPageIndex = this.atelierCurrentPageIndex - 1;
      this.RefreshPaginationControlsState();
      this.ShowCurrentPage();
    };
    if Equals(widgetName, n"ButtonNext") && this.navigationButtonNext.IsEnabled() {
      GameObject.PlaySoundEvent(this.owner, n"ui_menu_onpress");
      this.atelierCurrentPageIndex = this.atelierCurrentPageIndex + 1;
      this.RefreshPaginationControlsState();
      this.ShowCurrentPage();
    };
  };
}

@addMethod(WebPage)
public func ShowCurrentPage() -> Void {
  let currentIndex: Int32 = this.atelierCurrentPageIndex;
  if currentIndex < 0 || currentIndex >= this.atelierTotalPages {
    currentIndex = 0;
    this.atelierCurrentPageIndex = 0;
  };

  let page: ref<inkCompoundWidget> = this.atelierPages.GetWidgetByIndex(currentIndex) as inkCompoundWidget;
  if Equals(this.rootAtelierPanel.GetNumChildren(), 2) {
    this.rootAtelierPanel.RemoveChildByIndex(1);
  };
  this.rootAtelierPanel.AddChildWidget(page);
}

@addMethod(WebPage)
private func ShowSideImages() -> Void {
  // Images
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let leftImage: ref<inkImage> = new inkImage();
  leftImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
  leftImage.SetTexturePart(n"chick V");
  leftImage.SetInteractive(false);
  leftImage.SetAnchorPoint(new Vector2(0.5, 0.5));
  leftImage.SetFitToContent(true);
  leftImage.SetMargin(0, 500, 0, 0);
  leftImage.SetTranslation(new Vector2(-200.0, 0.0));
  leftImage.Reparent(root);

  let rightImage: ref<inkImage> = new inkImage();
  rightImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
  rightImage.SetTexturePart(n"dude V");
  rightImage.SetInteractive(false);
  rightImage.SetHAlign(inkEHorizontalAlign.Right);
  rightImage.SetVAlign(inkEVerticalAlign.Bottom);
  rightImage.SetAnchorPoint(new Vector2(0.5, 0.5));
  rightImage.SetFitToContent(true);
  rightImage.SetMargin(3500, 800, 0, 0);
  rightImage.Reparent(root);
}

@addMethod(WebPage)
private func ShowEmptyAtelierPage() -> Void {
  let emptyStateImage: ref<inkImage> = new inkImage();
  emptyStateImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
  emptyStateImage.SetTexturePart(n"chick V");
  emptyStateImage.SetInteractive(false);
  emptyStateImage.SetAnchorPoint(new Vector2(0.5, 0.5));
  emptyStateImage.SetFitToContent(true);
  emptyStateImage.Reparent(this.GetRootCompoundWidget());
  emptyStateImage.SetHAlign(inkEHorizontalAlign.Center);
  emptyStateImage.SetVAlign(inkEVerticalAlign.Center);
  emptyStateImage.SetTranslation(new Vector2(0, 170)); 
  emptyStateImage.Reparent(this.rootAtelierPanel);

  let emptyStateMessage: ref<inkText> = new inkText();
  emptyStateMessage.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  emptyStateMessage.SetFontStyle(n"Semi-Bold");
  emptyStateMessage.SetFontSize(50);
  emptyStateMessage.SetLetterCase(textLetterCase.UpperCase);
  emptyStateMessage.SetText(VirtualAtelierText.EmptyPlaceholder());
  emptyStateMessage.SetFitToContent(true);
  emptyStateMessage.SetHAlign(inkEHorizontalAlign.Center);
  emptyStateMessage.SetVAlign(inkEVerticalAlign.Center);
  emptyStateMessage.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  emptyStateMessage.BindProperty(n"tintColor", n"MainColors.Blue");
  emptyStateMessage.SetSize(new Vector2(100.0, 32.0));
  emptyStateMessage.SetTranslation(new Vector2(0.0, 200.0));
  emptyStateMessage.Reparent(this.rootAtelierPanel);
}


@addMethod(WebPage)
private func GetStore(store: ref<VirtualShop>) -> ref<inkVerticalPanel> {
  let storeID = store.storeID;
  let storeName = store.storeName;
  let atlasResource = store.atlasResource;
  let texturePart = store.texturePart;

  let link: ref<inkVerticalPanel> = new inkVerticalPanel();
  link.SetName(storeID);
  link.SetHAlign(inkEHorizontalAlign.Left);
  link.SetFitToContent(true);
  link.SetPadding(new inkMargin(50.0, 50.0, 50.0, 50.0));

  let imageLink: ref<inkImage> = new inkImage();
  imageLink.SetName(storeID);
  imageLink.SetAtlasResource(atlasResource);
  imageLink.SetTexturePart(texturePart);
  imageLink.SetInteractive(true);
  imageLink.SetHAlign(inkEHorizontalAlign.Center);
  imageLink.SetVAlign(inkEVerticalAlign.Center);
  imageLink.SetAnchorPoint(new Vector2(0.5, 0.5));
  imageLink.SetHeight(250);
  imageLink.SetWidth(300);
  imageLink.SetFitToContent(false);
  imageLink.SetSizeRule(inkESizeRule.Fixed);
  imageLink.Reparent(link);

  // TODO: Allow changing text props [font, style, case]
  let textLink: ref<inkText> = new inkText();
  textLink.SetName(storeID);
  textLink.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  textLink.SetFontStyle(n"Semi-Bold");
  textLink.SetFontSize(32);
  textLink.SetLetterCase(textLetterCase.UpperCase);
  textLink.SetText(storeName);
  textLink.SetFitToContent(true);
  textLink.SetHAlign(inkEHorizontalAlign.Center);
  textLink.SetVAlign(inkEVerticalAlign.Center);
  textLink.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  textLink.BindProperty(n"tintColor", n"MainColors.Blue");
  textLink.SetSize(new Vector2(100.0, 32.0));
  textLink.SetTranslation(new Vector2(0, 50));
  textLink.Reparent(link);

  link.RegisterToCallback(n"OnPress", this, n"OnShopClick");
  return link;
}

@addMethod(WebPage)
protected cb func OnShopClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.owner.GetGame());

    if IsDefined(uiSystem) {
      let widgetName: CName = evt.GetTarget().GetName();

      if Equals(n"", widgetName) {
          return true;
      };

      let vendorData: ref<VendorPanelData> = new VendorPanelData();
      let stores: array<ref<VirtualShop>> = this.system.GetStores();

      let virtualStore: ref<VirtualShop>;
      let i = 0;

      while i < ArraySize(stores) {
        if Equals(stores[i].storeID, widgetName) {
          virtualStore = stores[i];

          break;
        } else {
          i += 1;
        };
      };

      if Equals(virtualStore.storeID, n"") {
        this.DisplayWarning("Could not find requested " + NameToString(widgetName) + " store instance");
      } else {
        vendorData.data.vendorId = "VirtualVendor";
        vendorData.data.entityID = this.owner.GetEntityID();
        vendorData.data.isActive = true;
        vendorData.virtualStore = virtualStore;
        uiSystem.RequestVendorMenu(vendorData);
      };
    };
  };
}
