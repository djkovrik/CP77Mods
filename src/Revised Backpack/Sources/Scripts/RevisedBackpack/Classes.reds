module RevisedBackpack

public enum revisedSorting {
  None = 0,
  Name = 1,
  Type = 2,
  Tier = 3,
  Price = 4,
  Weight = 5,
  Dps = 6,
  DamagePerShot = 7,
  Range = 8,
  Quest = 9,
  CustomJunk = 10,
}

public enum revisedSortingMode {
  None = 0,
  Asc = 1,
  Desc = 2,
}

public enum revisedFiltersAction { 
  None = 0,
  Select = 1,
  Junk = 2,
  Disassemble = 3,
}

public class RevisedItemWrapper {
  public let id: TweakDBID;
  public let data: wref<gameItemData>;
  public let inventoryItem: wref<UIInventoryItem>;
  public let equipArea: gamedataEquipmentArea;
  public let type: gamedataItemType;
  public let typeLabel: String;
  public let typeValue: Int32;
  public let tier: gamedataQuality;
  public let tierLabel: String;
  public let tierValue: Int32;
  public let evolution: gamedataWeaponEvolution;
  public let nameLabel: String;
  public let price: Float;
  public let priceLabel: String;
  public let weight: Float;
  public let weightLabel: String;
  public let dps: Float;
  public let dpsLabel: String;
  public let damagePerShot: Float;
  public let damagePerShotLabel: String;
  public let range: Int32;
  public let rangeLabel: String;
  public let isQuest: Bool;
  public let isNew: Bool;
  public let isFavorite: Bool;
  public let isDlcAddedItem: Bool;
  public let isWeapon: Bool;
  public let selected: Bool;
  public let customJunk: Bool;
  public let questTagToggleable: Bool;
  public let customJunkToggleable: Bool;

  public final func GetEquippedFlag() -> Bool {
    return this.inventoryItem.IsEquipped();
  }

  public final func GetNewFlag() -> Bool {
    return this.isNew;
  }

  public final func SetNewFlag(flag: Bool) -> Void {
    this.isNew = flag;
  }

  public final func GetFavoriteFlag() -> Bool {
    return this.isFavorite;
  }

  public final func SetFavoriteFlag(flag: Bool) -> Void {
    this.isFavorite = flag;
  }

  public final func GetQuestFlag() -> Bool {
    return this.isQuest;
  }

  public final func SetQuestFlag(flag: Bool) -> Void {
    this.isQuest = flag;
  }

  public final func GetSelectedFlag() -> Bool {
    return this.selected;
  }

  public final func SetSelectedFlag(selected: Bool) -> Void {
    this.selected = selected;
  }

  public final func GetCustomJunkFlag() -> Bool {
    return this.customJunk;
  }

  public final func SetCustomJunkFlag(customJunk: Bool) -> Void {
    this.customJunk = customJunk;
  }

  public final func GetAmmo() -> TweakDBID {
    let weaponRecord: ref<WeaponItem_Record> = TweakDBInterface.GetItemRecord(this.id) as WeaponItem_Record;
    if IsDefined(weaponRecord) {
      return weaponRecord.Ammo().GetID();
    };

    return t"";
  }
}

public abstract class RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool;
}

public class RevisedBackpackCategory {
  public let id: Int32;
  public let titleLocKey: CName;
  public let texturePart: CName;
  public let atlasResource: ResRef;
  public let predicate: ref<RevisedCategoryPredicate>;

  public static func Create(id: Int32, title: CName, texture: CName, atlas: ResRef, predicate: ref<RevisedCategoryPredicate>) -> ref<RevisedBackpackCategory> {
    let instance: ref<RevisedBackpackCategory> = new RevisedBackpackCategory();
    instance.id = id;
    instance.titleLocKey = title;
    instance.texturePart = texture;
    instance.atlasResource = atlas;
    instance.predicate = predicate;
    return instance;
  }

  public static func Sort(out source: array<ref<RevisedBackpackCategory>>) -> Void {
    let size: Int32 = ArraySize(source);
    let i: Int32;
    let j: Int32;
    let swapped: Bool = false;
    i = 0;
    while i < size - 1 {
      swapped = false;
      j = 0;
      while j < size - i - 1 {
        if (source[j].id > source[j + 1].id) {
          RevisedBackpackCategory.Swap(source, j, j + 1);
          swapped = true;
        };
        j += 1;
      };

      if !swapped { return; }
      i += 1;
    };
  }

  private static func Swap(out source: array<ref<RevisedBackpackCategory>>, left: Int32, right: Int32) -> Void {
    let temp: ref<RevisedBackpackCategory> = source[left];
    source[left] = source[right];
    source[right] = temp;
  }
}

public class RevisedBackpackItemTooltipWrapper extends ATooltipData {
  public let m_data: wref<RevisedItemWrapper>;
  public let m_displayContext: ref<ItemDisplayContextData>;
  public let m_overridePrice: Int32;

  public final static func Make(data: wref<RevisedItemWrapper>, displayContext: ref<ItemDisplayContextData>) -> ref<RevisedBackpackItemTooltipWrapper> {
    let instance: ref<RevisedBackpackItemTooltipWrapper> = new RevisedBackpackItemTooltipWrapper();
    instance.m_overridePrice = -1;
    instance.m_data = data;
    instance.m_displayContext = displayContext;
    return instance;
  }
}

public class RevisedCategorySelectedEvent extends Event {
  public let category: ref<RevisedBackpackCategory>;
  
  public final static func Create(category: ref<RevisedBackpackCategory>) -> ref<RevisedCategorySelectedEvent> {
    let evt: ref<RevisedCategorySelectedEvent> = new RevisedCategorySelectedEvent();
    evt.category = category;
    return evt;
  }
}

public class RevisedBackpackSortingChanged extends Event {
  public let sorting: revisedSorting;
  public let mode: revisedSortingMode;

  public final static func Create(sorting: revisedSorting, mode: revisedSortingMode) -> ref<RevisedBackpackSortingChanged> {
    let evt: ref<RevisedBackpackSortingChanged> = new RevisedBackpackSortingChanged();
    evt.sorting = sorting;
    evt.mode = mode;
    return evt;
  }
}

public class RevisedBackpackColumnHoverOverEvent extends Event {
  public let target: wref<inkWidget>;
  public let type: revisedSorting;

  public final static func Create(target: wref<inkWidget>, type: revisedSorting) -> ref<RevisedBackpackColumnHoverOverEvent> {
    let evt: ref<RevisedBackpackColumnHoverOverEvent> = new RevisedBackpackColumnHoverOverEvent();
    evt.target = target;
    evt.type = type;
    return evt;
  }
}

public class RevisedBackpackColumnHoverOutEvent extends Event {

  public final static func Create() -> ref<RevisedBackpackColumnHoverOutEvent> {
    let evt: ref<RevisedBackpackColumnHoverOutEvent> = new RevisedBackpackColumnHoverOutEvent();
    return evt;
  }
}

public class RevisedBackpackItemHoverOverEvent extends Event {
  public let item: wref<RevisedItemWrapper>;
  public let isOverName: Bool;
  public let widget: wref<inkWidget>;

  public final static func Create(item: ref<RevisedItemWrapper>, isName: Bool, widget: wref<inkWidget>) -> ref<RevisedBackpackItemHoverOverEvent> {
    let evt: ref<RevisedBackpackItemHoverOverEvent> = new RevisedBackpackItemHoverOverEvent();
    evt.item = item;
    evt.isOverName = isName;
    evt.widget = widget;
    return evt;
  }
}

public class RevisedBackpackItemHoverOutEvent extends Event {
  public let item: wref<RevisedItemWrapper>;

  public final static func Create(item: ref<RevisedItemWrapper>) -> ref<RevisedBackpackItemHoverOutEvent> {
    let evt: ref<RevisedBackpackItemHoverOutEvent> = new RevisedBackpackItemHoverOutEvent();
    evt.item = item;
    return evt;
  }
}

public class RevisedBackpackItemSelectEvent extends Event {
  public let display: wref<RevisedBackpackItemController>;
  public let item: wref<RevisedItemWrapper>;
  public let ctrlPressed: Bool;
  public let shiftPressed: Bool;

  public final static func Create(display: ref<RevisedBackpackItemController>, item: ref<RevisedItemWrapper>, ctrlPressed: Bool, shiftPressed: Bool) -> ref<RevisedBackpackItemSelectEvent> {
    let evt: ref<RevisedBackpackItemSelectEvent> = new RevisedBackpackItemSelectEvent();
    evt.display = display;
    evt.item = item;
    evt.ctrlPressed = ctrlPressed;
    evt.shiftPressed = shiftPressed;
    return evt;
  }
}

public class RevisedBackpackItemHighlightEvent extends Event {
  public let itemId: ItemID;
  public let highlight: Bool;

  public final static func Create(itemId: ItemID, highlight: Bool) -> ref<RevisedBackpackItemHighlightEvent> {
    let evt: ref<RevisedBackpackItemHighlightEvent> = new RevisedBackpackItemHighlightEvent();
    evt.itemId = itemId;
    evt.highlight = highlight;
    return evt;
  }
}

public class RevisedBackpackSelectedItemsCountChangedEvent extends Event {
  public let count: Int32;

  public final static func Create(count: Int32) -> ref<RevisedBackpackSelectedItemsCountChangedEvent> {
    let evt: ref<RevisedBackpackSelectedItemsCountChangedEvent> = new RevisedBackpackSelectedItemsCountChangedEvent();
    evt.count = count;
    return evt;
  }
}

public class RevisedItemPreviewEvent extends Event {
  public let itemId: ItemID;
  public let isGarment: Bool;

  public final static func Create(itemId: ItemID, isGarment: Bool) -> ref<RevisedItemPreviewEvent> {
    let evt: ref<RevisedItemPreviewEvent> = new RevisedItemPreviewEvent();
    evt.itemId = itemId;
    evt.isGarment = isGarment;
    return evt;
  }
}

public class RevisedFilteringEvent extends Event {
  public let nameQuery: String;
  public let typeQuery: String;
  public let tiers: array<gamedataQuality>;
  public let ammo: TweakDBID;
  public let filtersReset: Bool;

  public final static func Create(name: String, type: String, tiers: array<gamedataQuality>, ammo: TweakDBID, reset: Bool) -> ref<RevisedFilteringEvent> {
    let evt: ref<RevisedFilteringEvent> = new RevisedFilteringEvent();
    evt.nameQuery = name;
    evt.typeQuery = type;
    evt.tiers = tiers;
    evt.ammo = ammo;
    evt.filtersReset = reset;
    return evt;
  }
}

public class RevisedFiltersActionEvent extends Event {
  public let type: revisedFiltersAction;

  public final static func Create(type: revisedFiltersAction) -> ref<RevisedFiltersActionEvent> {
    let evt: ref<RevisedFiltersActionEvent> = new RevisedFiltersActionEvent();
    evt.type = type;
    return evt;
  }
}

public class RevisedItemDisplayReleaseEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
  public let uiInventoryItem: ref<UIInventoryItem>;
  public let actionName: ref<inkActionName>;
}

public class RevisedItemDisplayHoldEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
  public let uiInventoryItem: ref<UIInventoryItem>;
  public let actionName: ref<inkActionName>;
}

public class RevisedItemDisplayPressEvent extends Event {
  public let display: wref<RevisedBackpackItemController>;
  public let actionName: ref<inkActionName>;
}

public class RevisedToggleCustomJunkEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
}

public class RevisedToggleQuestTagEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
}

public class RevisedBackpackInventoryListenerCallback extends InventoryScriptCallback {

  private let m_backpackInstance: wref<RevisedBackpackController>;

  public final func Setup(backpackInstance: wref<RevisedBackpackController>) -> Void {
    this.m_backpackInstance = backpackInstance;
  }
}

public class RevisedBakcpackImmediateNotificationListener extends ImmediateNotificationListener {

  private let m_backpackInstance: wref<RevisedBackpackController>;

  public final func SetBackpackInstance(instance: wref<RevisedBackpackController>) -> Void {
    this.m_backpackInstance = instance;
  }

  public func Notify(message: Int32, id: Uint64, opt data: wref<IScriptable>) -> Void {
    this.m_backpackInstance.OnBakcpackItemDisplayNotification(IntEnum<ItemDisplayNotificationMessage>(message), id, data);
  }
}

public class RevisedBackpackOutfitCooldownResetCallback extends DelayCallback {

  public let m_controller: wref<RevisedBackpackController>;

  public func Call() -> Void {
    this.m_controller.SetOutfitCooldown(false);
  }
}

public class RevisedBackpackFilterDebounceCallback extends DelayCallback {

  public let m_controller: wref<RevisedBackpackFiltersController>;

  public func Call() -> Void {
    this.m_controller.ApplyFilters();
  }
}

public class RevisedBackpackTemplateClassifier extends inkVirtualItemTemplateClassifier {}

public class RevisedCustomEventBackpackOpened extends CallbackSystemEvent {
  let opened: Bool;

  public final static func Create(opened: Bool) -> ref<RevisedCustomEventBackpackOpened> {
    let evt: ref<RevisedCustomEventBackpackOpened> = new RevisedCustomEventBackpackOpened();
    evt.opened = opened;
    return evt;
  }
}

public class RevisedCustomEventItemHoverOver extends CallbackSystemEvent {
  let data: ref<gameItemData>;

  public final static func Create(data: ref<gameItemData>) -> ref<RevisedCustomEventItemHoverOver> {
    let evt: ref<RevisedCustomEventItemHoverOver> = new RevisedCustomEventItemHoverOver();
    evt.data = data;
    return evt;
  }
}

public class RevisedCustomEventItemHoverOut extends CallbackSystemEvent {
  public final static func Create() -> ref<RevisedCustomEventItemHoverOut> {
    let evt: ref<RevisedCustomEventItemHoverOut> = new RevisedCustomEventItemHoverOut();
    return evt;
  }
}

public class RevisedCustomEventCategorySelected extends CallbackSystemEvent {
  let categoryId: Int32;

  public final static func Create(categoryId: Int32) -> ref<RevisedCustomEventCategorySelected> {
    let evt: ref<RevisedCustomEventCategorySelected> = new RevisedCustomEventCategorySelected();
    evt.categoryId = categoryId;
    return evt;
  }
}

public class RevisedAmmoFilterSelectedEvent extends Event {
  public let ammoId: TweakDBID;

  public final static func Create(ammoId: TweakDBID) -> ref<RevisedAmmoFilterSelectedEvent> {
    let evt: ref<RevisedAmmoFilterSelectedEvent> = new RevisedAmmoFilterSelectedEvent();
    evt.ammoId = ammoId;
    return evt;
  }
}

public class RevisedAmmoFilterResetEvent extends Event {
  public final static func Create() -> ref<RevisedAmmoFilterResetEvent> {
    let evt: ref<RevisedAmmoFilterResetEvent> = new RevisedAmmoFilterResetEvent();
    return evt;
  }
}

public class RevisedBackpackAmmoButtonHoverOverEvent extends Event {
  public let target: wref<inkWidget>;
  public let title: String;

  public final static func Create(target: wref<inkWidget>, title: String) -> ref<RevisedBackpackAmmoButtonHoverOverEvent> {
    let evt: ref<RevisedBackpackAmmoButtonHoverOverEvent> = new RevisedBackpackAmmoButtonHoverOverEvent();
    evt.target = target;
    evt.title = title;
    return evt;
  }
}

public class RevisedBackpackAmmoHoverOutEvent extends Event {
  public final static func Create() -> ref<RevisedBackpackAmmoHoverOutEvent> {
    let evt: ref<RevisedBackpackAmmoHoverOutEvent> = new RevisedBackpackAmmoHoverOutEvent();
    return evt;
  }
}