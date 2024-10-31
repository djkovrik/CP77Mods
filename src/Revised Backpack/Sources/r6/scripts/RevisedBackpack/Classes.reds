module RevisedBackpack

enum revisedSorting {
  None = 0,
  Name = 1,
  Type = 2,
  Tier = 3,
  Price = 4,
  Weight = 5,
  Dps = 6,
  Quest = 7,
}

enum revisedSortingMode {
  None = 0,
  Asc = 1,
  Desc = 2,
}

public class RevisedItemSortData {
  public let name: String;
  public let type: Int32;
  public let tier: Int32;
  public let price: Float;
  public let weight: Float;
  public let dps: Float;
  public let isQuest: Bool;
  public let isNew: Bool;
  public let isFavourite: Bool;
  public let isDlcAddedItem: Bool;
  public let isWeapon: Bool;
}

public class RevisedItemWrapper {
  public let id: TweakDBID;
  public let data: wref<gameItemData>;
  public let inventoryItem: wref<UIInventoryItem>;
  public let displayContextData: wref<ItemDisplayContextData>;
  public let equipArea: gamedataEquipmentArea;
  public let type: gamedataItemType;
  public let evolution: gamedataWeaponEvolution;
  public let displayNameKey: CName;
  public let dps: Float;
  public let isNew: Bool;
  public let isFavorite: Bool;
  public let isQuest: Bool;
  public let selected: Bool;
  public let questTagToggleable: Bool;

  public final func GetNameLabel() -> String {
    return GetLocalizedTextByKey(this.displayNameKey);
  }

  public final func GetTypeLabel() -> String {
    return UIItemsHelper.GetItemTypeKey(this.data, this.equipArea, this.id, this.type, this.evolution);
  }

  public final func GetTierLabel() -> String {
    let qualityText: String = GetLocalizedText(UIItemsHelper.QualityToTierString(this.inventoryItem.GetQuality()));
    let plus: Int32 = Cast<Int32>(this.inventoryItem.GetItemPlus());
    if !this.inventoryItem.IsProgram() {
      if plus >= 2 {
        qualityText += "++";
      } else {
        if plus >= 1 {
          qualityText += "+";
        };
      };
    };

    return qualityText;
  }

  public final func GetPriceLabel() -> String {
    return IntToString(RoundF(this.inventoryItem.GetSellPrice()));
  }

  public final func GetWeightLabel() -> String {
    return FloatToStringPrec(this.inventoryItem.GetWeight(), 1);
  }

  public final func GetDpsLabel() -> String {
    return FloatToStringPrec(this.dps, 1);
  }

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

  public final func IsQuestTagToggleable() -> Bool {
    return this.questTagToggleable;
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

    ModLog(n"Sorting", s"Sorted array size: \(ArraySize(source))");
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

public class RevisedBackpackPopulatedEvent extends Event {}

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
  public let widget: wref<inkWidget>;

  public final static func Create(item: ref<RevisedItemWrapper>, widget: wref<inkWidget>) -> ref<RevisedBackpackItemHoverOverEvent> {
    let evt: ref<RevisedBackpackItemHoverOverEvent> = new RevisedBackpackItemHoverOverEvent();
    evt.item = item;
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
  public let item: wref<RevisedItemWrapper>;

  public final static func Create(item: ref<RevisedItemWrapper>) -> ref<RevisedBackpackItemSelectEvent> {
    let evt: ref<RevisedBackpackItemSelectEvent> = new RevisedBackpackItemSelectEvent();
    evt.item = item;
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

public class RevisedBackpackItemWasHighlightedEvent extends Event {
  public let display: wref<RevisedBackpackItemController>;

  public final static func Create(display: wref<RevisedBackpackItemController>) -> ref<RevisedBackpackItemWasHighlightedEvent> {
    let evt: ref<RevisedBackpackItemWasHighlightedEvent> = new RevisedBackpackItemWasHighlightedEvent();
    evt.display = display;
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

public class RevisedItemDisplayClickEvent extends Event {
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