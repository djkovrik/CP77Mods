import VendorPreview.utils.*
import VendorPreview.constants.*

@addField(WebPage)
let owner: wref<GameObject>;

@addMethod(WebPage)
private func PopulateAtelierView(owner: ref<GameObject>) {
  this.owner = owner;

  let panel = this.GetWidget(n"page/linkPanel/panel") as inkVerticalPanel;
  let page = this.GetWidget(n"page");

  panel.RemoveAllChildren();

  let board: wref<IBlackboard> = GameInstance.GetBlackboardSystem(this.owner.GetGame()).Get(GetAllBlackboardDefs().VirtualShop);
  let stores: array<ref<VirtualShop>> = FromVariant(board.GetVariant(GetAllBlackboardDefs().VirtualShop.Stores));

  if ArraySize(stores) < 1 {
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
    emptyStateImage.Reparent(panel);

    let emptyStateMessage: ref<inkText> = new inkText();
    emptyStateMessage.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    emptyStateMessage.SetFontStyle(n"Semi-Bold");
    emptyStateMessage.SetFontSize(50);
    emptyStateMessage.SetLetterCase(textLetterCase.UpperCase);
    emptyStateMessage.SetText("No custom stores installed");
    emptyStateMessage.SetFitToContent(true);
    emptyStateMessage.SetHAlign(inkEHorizontalAlign.Center);
    emptyStateMessage.SetVAlign(inkEVerticalAlign.Center);
    emptyStateMessage.SetTintColor(new HDRColor(0.321569, 0.866667, 0.87451, 1.0));
    emptyStateMessage.SetSize(new Vector2(100.0, 32.0));
    emptyStateMessage.SetTranslation(new Vector2(0.0, 200.0));
    emptyStateMessage.Reparent(panel);
  } else {
    let leftImage: ref<inkImage> = new inkImage();
    leftImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
    leftImage.SetTexturePart(n"chick V");
    leftImage.SetInteractive(false);
    leftImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    leftImage.SetFitToContent(true);
    leftImage.Reparent(this.GetRootCompoundWidget());
    leftImage.SetMargin(0, 500, 0, 0);
    leftImage.SetTranslation(new Vector2(-200.0, 0.0));

    let rightImage: ref<inkImage> = new inkImage();
    rightImage.SetAtlasResource(r"base/gameplay/gui/world/adverts/jingujishop/jingujishop.inkatlas");
    rightImage.SetTexturePart(n"dude V");
    rightImage.SetInteractive(false);
    rightImage.SetHAlign(inkEHorizontalAlign.Right);
    rightImage.SetVAlign(inkEVerticalAlign.Bottom);
    rightImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    rightImage.SetFitToContent(true);
    rightImage.Reparent(this.GetRootCompoundWidget());
    rightImage.SetMargin(3500, 800, 0, 0);

    let numPerRow = GetNumOfVirtualStoresPerRow();
    let numOfStores = ArraySize(stores);
    let numOfRows = CeilF(Cast(numOfStores / numPerRow)) + 1;

    let rowIndex = 0;

    while rowIndex < numOfRows {
      let row: ref<inkHorizontalPanel> = new inkHorizontalPanel();
      row.SetName(n"atelier-row");
      row.SetFitToContent(true);
      row.SetHAlign(inkEHorizontalAlign.Left);
      row.SetVAlign(inkEVerticalAlign.Center);
      row.SetPadding(150, 150, 150, 0);
      row.Reparent(panel);

      let rowStoreIndex = 0 + (rowIndex * numPerRow);
      let lastRowStoreIndex = rowStoreIndex + numPerRow;

      while rowStoreIndex < lastRowStoreIndex {
        if (Equals(rowStoreIndex, numOfStores)) {
          rowStoreIndex = lastRowStoreIndex;

          return;
        }

        let store = stores[rowStoreIndex];

        this.AddStore(row, store);

        rowStoreIndex += 1;
      }

      rowIndex += 1;
    }

    CheckDuplicates(stores, this);
  }
}

public class ItemToStoresMap extends IScriptable {
  let itemID: String;

  let stores: array<String>;
}

@addMethod(WebPage)
private func AddStore(container: ref<inkHorizontalPanel>, store: ref<VirtualShop>) {
  let storeID = store.storeID;
  let storeName = store.storeName;
  let atlasResource = store.atlasResource;
  let texturePart = store.texturePart;

  let link: ref<inkVerticalPanel> = new inkVerticalPanel();
  link.SetName(storeID);
  link.SetHAlign(inkEHorizontalAlign.Left);
  link.SetFitToContent(true);
  link.SetPadding(50, 50, 50, 50);
  link.Reparent(container);

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
  textLink.SetTintColor(new HDRColor(0.321569, 0.866667, 0.87451, 1.0));
  textLink.SetSize(new Vector2(100.0, 32.0));
  textLink.SetTranslation(new Vector2(0, 50));
  textLink.Reparent(link);

  link.RegisterToCallback(n"OnPress", this, n"OnShopClick");
}

@addField(VendorPanelData)
let virtualStore: ref<VirtualShop>;

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
protected cb func OnShopClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.owner.GetGame());

    if IsDefined(uiSystem) {
      let widgetName = evt.GetTarget().GetName();

      if Equals(n"", widgetName) {
          return true;
      }

      let vendorData: ref<VendorPanelData> = new VendorPanelData();

      let board: wref<IBlackboard> = GameInstance.GetBlackboardSystem(this.owner.GetGame()).Get(GetAllBlackboardDefs().VirtualShop);
      let stores: array<ref<VirtualShop>> = FromVariant(board.GetVariant(GetAllBlackboardDefs().VirtualShop.Stores));

      let virtualStore: ref<VirtualShop>;
      let i = 0;

      while i < ArraySize(stores) {
        if Equals(stores[i].storeID, widgetName) {
          virtualStore = stores[i];

          break;
        } else {
          i += 1;
        }
      }

      if Equals(virtualStore.storeID, n"") {
        this.DisplayWarning("Could not find requested " + NameToString(widgetName) + " store instance");
      } else {
        vendorData.data.vendorId = "VirtualVendor";
        vendorData.data.entityID = this.owner.GetEntityID();
        vendorData.data.isActive = true;
        vendorData.virtualStore = virtualStore;

        uiSystem.RequestVendorMenu(vendorData);
      }
    }
  }
}