module RevisedBackpack

public class RevisedBackpackItemController extends inkVirtualCompoundItemController {
  private let m_item: ref<RevisedItemWrapper>;
  
  private let m_shadow: wref<inkWidget>;
  private let m_selection: wref<inkWidget>;
  private let m_itemName: wref<inkText>;
  private let m_itemIcon: wref<inkImage>;
  private let m_itemEquipped: wref<inkWidget>;
  private let m_itemNew: wref<inkWidget>;
  private let m_itemFavorite: wref<inkWidget>;
  private let m_itemType: wref<inkText>;
  private let m_itemTier: wref<inkText>;
  private let m_itemPrice: wref<inkText>;
  private let m_itemWeight: wref<inkText>;
  private let m_itemDps: wref<inkText>;
  private let m_itemQuest: wref<inkWidget>;
  private let m_questContainer: wref<inkWidget>; 

  protected cb func OnInitialize() -> Bool {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.m_shadow = root.GetWidgetByPathName(n"shadow");
    this.m_selection = root.GetWidgetByPathName(n"selection");
    this.m_itemName = root.GetWidgetByPathName(n"item/nameContainer/name") as inkText;
    this.m_itemIcon = root.GetWidgetByPathName(n"item/nameContainer/icon") as inkImage;
    this.m_itemEquipped = root.GetWidgetByPathName(n"item/nameContainer/equipped");
    this.m_itemNew = root.GetWidgetByPathName(n"item/nameContainer/new");
    this.m_itemFavorite = root.GetWidgetByPathName(n"item/nameContainer/favorite");
    this.m_itemType = root.GetWidgetByPathName(n"item/type") as inkText;
    this.m_itemTier = root.GetWidgetByPathName(n"item/tier") as inkText;
    this.m_itemPrice = root.GetWidgetByPathName(n"item/price") as inkText;
    this.m_itemWeight = root.GetWidgetByPathName(n"item/weight") as inkText;
    this.m_itemDps = root.GetWidgetByPathName(n"item/dps") as inkText;
    this.m_itemQuest = root.GetWidgetByPathName(n"item/quest/checkbox");
    this.m_questContainer = root.GetWidgetByPathName(n"item/quest");

    this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");    
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease"); 
    this.RegisterToCallback(n"OnHold", this, n"OnHold");
    this.RegisterToCallback(n"OnPress", this, n"OnPressed");
  }

  protected cb func OnUninitialize() -> Bool {
    let evt: ref<inkPointerEvent>;
    this.OnHoverOut(evt);
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.m_shadow.SetVisible(true);
    if IsDefined(this.m_item) {
      this.QueueEvent(RevisedBackpackItemHoverOverEvent.Create(this.m_item, this.m_selection));
      this.SetIsNew(false);
    };
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.m_shadow.SetVisible(false);
    if IsDefined(this.m_item) {
      this.QueueEvent(RevisedBackpackItemHoverOutEvent.Create(this.m_item));
    };
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    let displayClickEvent: ref<RevisedItemDisplayClickEvent>;
    let toggleQuestTagEvent: ref<RevisedToggleQuestTagEvent>;
    let targetName: CName = evt.GetTarget().GetName();
    if evt.IsAction(n"click") && Equals(targetName, n"quest") && this.CanToggleQuestTag() {
      toggleQuestTagEvent = new RevisedToggleQuestTagEvent();
      toggleQuestTagEvent.itemData = this.m_item.data;
      toggleQuestTagEvent.display = this;
      this.QueueEvent(toggleQuestTagEvent);
    } else if evt.IsAction(n"select") && NotEquals(targetName, n"quest") {
      this.QueueEvent(RevisedBackpackItemSelectEvent.Create(this.m_item));
    } else {
      displayClickEvent = new RevisedItemDisplayClickEvent();
      displayClickEvent.itemData = this.m_item.data;
      displayClickEvent.display = this;
      displayClickEvent.uiInventoryItem = this.m_item.inventoryItem;
      displayClickEvent.actionName = evt.GetActionName();
      this.QueueEvent(displayClickEvent);
    };
  }

  protected cb func OnHold(evt: ref<inkPointerEvent>) -> Bool {
    let displayHoldEvent: ref<RevisedItemDisplayHoldEvent>;
    if evt.GetHoldProgress() >= 1.0 {
      displayHoldEvent = new RevisedItemDisplayHoldEvent();
      displayHoldEvent.itemData = this.m_item.data;
      displayHoldEvent.display = this;
      displayHoldEvent.uiInventoryItem = this.m_item.inventoryItem;
      displayHoldEvent.actionName = evt.GetActionName();
      this.QueueEvent(displayHoldEvent);
    };
  }

  protected cb func OnPressed(evt: ref<inkPointerEvent>) -> Bool {
    let pressEvent: ref<RevisedItemDisplayPressEvent> = new RevisedItemDisplayPressEvent();
    pressEvent.display = this;
    pressEvent.actionName = evt.GetActionName();
    this.QueueEvent(pressEvent);
  }

  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_item = FromVariant<ref<IScriptable>>(value) as RevisedItemWrapper;
    if IsDefined(this.m_item) {
      this.RefreshView();
    };
  }

  protected cb func OnRevisedBackpackItemHighlightEvent(evt: ref<RevisedBackpackItemHighlightEvent>) -> Bool {
    if Equals(evt.itemId, this.m_item.data.GetID()) && NotEquals(this.m_item.GetSelectedFlag(), evt.highlight) {
      this.m_item.SetSelectedFlag(evt.highlight);
      this.m_selection.SetVisible(this.m_item.GetSelectedFlag());
      this.QueueEvent(RevisedBackpackItemWasHighlightedEvent.Create(this));
    };
  }

  public final func Deselect() -> Void {
    this.m_item.SetSelectedFlag(false);
    this.m_selection.SetVisible(this.m_item.GetSelectedFlag());
  }

  public final func GetIsNew() -> Bool {
    return this.m_item.GetNewFlag();
  }

  public final func SetIsNew(flag: Bool) -> Void {
    this.m_item.SetNewFlag(flag);
    this.m_itemNew.SetVisible(this.GetIsNew());
  }

  public final func GetIsPlayerFavourite() -> Bool {
    return this.m_item.GetFavoriteFlag();
  }

  public final func SetIsPlayerFavourite(flag: Bool) -> Void {
    this.Log(s"Switch quest tag for \(this.m_item.GetNameLabel()) to \(flag)");
    this.m_item.SetFavoriteFlag(flag);
    this.m_itemFavorite.SetVisible(this.GetIsPlayerFavourite());
  }

  public final func GetIsQuestItem() -> Bool {
    return this.m_item.GetQuestFlag();
  }

  public final func SetIsQuestItem(flag: Bool) -> Void {
    this.m_item.SetQuestFlag(flag);
    this.m_itemName.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemLabelColor(this.GetIsQuestItem()));
    this.m_itemQuest.SetVisible(this.GetIsQuestItem());
  }

  public final func CanToggleQuestTag() -> Bool {
    return this.m_item.IsQuestTagToggleable();
  }

  private final func RefreshView() -> Void {
    let label: String = this.m_item.GetNameLabel();
    let quantity: Int32 = this.m_item.inventoryItem.GetQuantity();
    if quantity > 1 { label += s" (\(quantity))"; }
    this.m_itemName.SetText(label);
    this.m_itemName.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemLabelColor(this.GetIsQuestItem()));
    this.m_itemIcon.SetTexturePart(RevisedBackpackUtils.GetItemIcon(this.m_item.data));
    this.m_itemIcon.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemIconColor(this.m_item.data));
    this.m_itemEquipped.SetVisible(this.m_item.GetEquippedFlag());
    this.m_itemNew.SetVisible(this.m_item.GetNewFlag());
    this.m_itemFavorite.SetVisible(this.m_item.GetFavoriteFlag());
    this.m_itemType.SetText(this.m_item.GetTypeLabel());
    this.m_itemTier.SetText(this.m_item.GetTierLabel());
    this.m_itemPrice.SetText(this.m_item.GetPriceLabel());
    this.m_itemWeight.SetText(this.m_item.GetWeightLabel());
    this.m_itemDps.SetText(this.m_item.GetDpsLabel());
    this.m_itemQuest.SetVisible(this.m_item.GetQuestFlag());
    this.m_selection.SetVisible(this.m_item.GetSelectedFlag());

    if this.CanToggleQuestTag() {
      this.m_questContainer.SetOpacity(1.0);
    } else {
      this.m_questContainer.SetOpacity(0.1);
    };
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedItemController", str);
    };
  }
}
