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
  private let m_itemDamagePerShot: wref<inkText>;
  private let m_itemRange: wref<inkText>;
  private let m_itemQuest: wref<inkWidget>;
  private let m_questContainer: wref<inkWidget>; 
  private let m_itemCustomJunk: wref<inkWidget>;
  private let m_customJunkContainer: wref<inkWidget>; 

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
    this.m_itemDamagePerShot = root.GetWidgetByPathName(n"item/damagePerShot") as inkText;
    this.m_itemRange = root.GetWidgetByPathName(n"item/range") as inkText;
    this.m_itemQuest = root.GetWidgetByPathName(n"item/quest/checkbox");
    this.m_questContainer = root.GetWidgetByPathName(n"item/quest");
    this.m_itemCustomJunk = root.GetWidgetByPathName(n"item/customJunk/checkbox");
    this.m_customJunkContainer = root.GetWidgetByPathName(n"item/customJunk");

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
    let target: ref<inkWidget> = evt.GetTarget();
    let isName: Bool = Equals(target.GetName(), n"nameContainer");
    if IsDefined(this.m_item) {
      this.QueueEvent(RevisedBackpackItemHoverOverEvent.Create(this.m_item, isName, target));
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
    let toggleCustomJunkEvent: ref<RevisedToggleCustomJunkEvent>;
    let targetName: CName = evt.GetTarget().GetName();
    if evt.IsAction(n"click") && Equals(targetName, n"quest") && this.CanToggleQuestTag() {
      toggleQuestTagEvent = new RevisedToggleQuestTagEvent();
      toggleQuestTagEvent.itemData = this.m_item.data;
      toggleQuestTagEvent.display = this;
      this.QueueEvent(toggleQuestTagEvent);
    } else if evt.IsAction(n"click") && Equals(targetName, n"customJunk") && this.CanToggleCustomJunk() {
      toggleCustomJunkEvent = new RevisedToggleCustomJunkEvent();
      toggleCustomJunkEvent.itemData = this.m_item.data;
      toggleCustomJunkEvent.display = this;
      this.QueueEvent(toggleCustomJunkEvent);
    } else if evt.IsAction(n"select") && NotEquals(targetName, n"quest") && NotEquals(targetName, n"customJunk") {
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

  public final func SetSelection(selected: Bool) -> Void {
    this.m_item.SetSelectedFlag(selected);
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
    this.Log(s"Switch quest tag for \(this.m_item.nameLabel) to \(flag)");
    this.m_item.SetFavoriteFlag(flag);
    this.m_itemFavorite.SetVisible(this.GetIsPlayerFavourite());
  }

  public final func GetIsQuestItem() -> Bool {
    return this.m_item.GetQuestFlag();
  }

  public final func SetIsQuestItem(flag: Bool) -> Void {
    this.m_item.SetQuestFlag(flag);
    this.m_itemName.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemLabelColor(this.GetIsQuestItem(), this.m_item.inventoryItem.IsIconic()));
    this.m_itemQuest.SetVisible(this.GetIsQuestItem());
  }

  public final func CanToggleQuestTag() -> Bool {
    return this.m_item.questTagToggleable;
  }

  public final func GetIsCustomJunkItem() -> Bool {
    return this.m_item.GetCustomJunkFlag();
  }

  public final func SetIsCustomJunkItem(flag: Bool) -> Void {
    this.m_item.SetCustomJunkFlag(flag);
    this.m_itemCustomJunk.SetVisible(this.GetIsCustomJunkItem());
  }

  public final func CanToggleCustomJunk() -> Bool {
    return this.m_item.customJunkToggleable;
  }

  private final func RefreshView() -> Void {
    let label: String = this.m_item.nameLabel;
    let quantity: Int32 = this.m_item.inventoryItem.GetQuantity();
    if quantity > 1 { label += s" (\(quantity))"; }
    this.m_itemName.SetText(label);
    this.m_itemName.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemLabelColor(this.GetIsQuestItem(), this.m_item.inventoryItem.IsIconic()));
    this.m_itemIcon.SetTexturePart(RevisedBackpackUtils.GetItemIcon(this.m_item.data));
    this.m_itemIcon.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemIconColor(this.m_item.data));
    this.m_itemEquipped.SetVisible(this.m_item.GetEquippedFlag());
    this.m_itemNew.SetVisible(this.m_item.GetNewFlag());
    this.m_itemFavorite.SetVisible(this.m_item.GetFavoriteFlag());
    this.m_itemType.SetText(this.m_item.typeLabel);
    this.m_itemTier.SetText(this.m_item.tierLabel);
    this.m_itemPrice.SetText(this.m_item.priceLabel);
    this.m_itemWeight.SetText(this.m_item.weightLabel);
    this.m_itemDps.SetText(this.m_item.dpsLabel);
    this.m_itemDamagePerShot.SetText(this.m_item.damagePerShotLabel);
    this.m_itemRange.SetText(this.m_item.rangeLabel);
    this.m_itemQuest.SetVisible(this.m_item.GetQuestFlag());
    this.m_itemCustomJunk.SetVisible(this.m_item.GetCustomJunkFlag());
    this.m_selection.SetVisible(this.m_item.GetSelectedFlag());

    if this.CanToggleQuestTag() {
      this.m_questContainer.SetOpacity(1.0);
    } else {
      this.m_questContainer.SetOpacity(0.1);
    };

    if this.CanToggleCustomJunk() {
      this.m_customJunkContainer.SetOpacity(1.0);
    } else {
      this.m_customJunkContainer.SetOpacity(0.1);
    };

    this.Log(s"RefreshView for \(this.m_item.nameLabel), selected \(this.m_item.GetSelectedFlag()), custom junk \(this.m_item.GetCustomJunkFlag())))");
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedItemController", str);
    };
  }
}
